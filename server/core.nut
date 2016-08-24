const SCRIPT_ROOT = "resources/erp/server/";
const MODULES_DIR = "modules/";
const DEBUG_ENABLED = 1;

function include(filename, fm = true) 
{
	local file = SCRIPT_ROOT + ((fm) ? MODULES_DIR : "") + filename + ".nut";
	return dofile(file, true);
}

function random(min = 0, max = RAND_MAX)
{
   return (rand() % ((max + 1) - min)) + min;
}

function dbg(data)
{
	if (DEBUG_ENABLED) {
		log("[debug] " + json.encode(data));
	}
}

function compile(filename)
{
	local compile = loadfile(SCRIPT_ROOT + MODULES_DIR + filename + ".nut", true);
	writeclosuretofile(SCRIPT_ROOT + MODULES_DIR + filename + ".sq", compile);
}

function str_replace(search, replace, subject)
{
	local first = subject.find(search[0].tochar()), last = (typeof first == "null" ? null:subject.find(search[(search.len()-1)].tochar(), first)), string = "";

  	if (typeof first == "null" || typeof last == "null") return false;
 
  	for (local i = 0; i < subject.len(); i++)
    	if (i >= first && i <= last) {
      		if (i == first)
        		string = format("%s%s", string, replace.tostring());
		}
   		else string = format("%s%s", string, subject[i].tochar());
 
  	return string;
}

function strrep(string, original, replacement) {
  local expression = regexp(original);
  local result = "";
  local position = 0;
  local captures = expression.capture(string);
  while (captures != null) {
    foreach (i, capture in captures) {
      result += string.slice(position, capture.begin);
      result += replacement;
      position = capture.end;
    }
    captures = expression.capture(string, position);
  }
  result += string.slice(position);
  return result;
}

_server_commands <- {};
function cmd(names, func) 
{
	if (typeof names != "array") {
		names = [names];
	}
	foreach(name in names) {
		_server_commands[name] <- func;
		addCommandHandler(name, func);
	}
}

function daystamp()
{
	local year = 2012;
	local d = date();
	return ((d.year - year) * 365) + d.yearday;
}


world <- 0;

addEventHandler("onScriptInit", function() {
	setGameModeText("Role-Play");
	setMapName("Night City Role-Play v0.0.7");
	
	include("json");
	include("object");
	include("area");
	include("color");
	include("project", false);
	include("weather");
	include("3dtext");
	include("blips");
	include("message");
	include("chat");
	include("player");
	include("vehicle");
	include("struct");
	include("organization");
	include("localization");
	include("gui");
	include("interface");

	include("world");
	world = World(sqlite("erp2.db"));
	
	include("commands");
	include("timers");
	
	world.load();
});

addEventHandler("onPlayerConnect", function(playerid, name, ip, serial) {
	return world.addPlayer(playerid, name, ip, serial);
});

addEventHandler("onPlayerSpawn", function(playerid) {
	return world.getPlayer(playerid).onSpawn();
});

addEventHandler("onPlayerDeath", function(playerid, killerid) {
	local player = world.getPlayer(playerid);
	if (killerid != INVALID_ENTITY_ID) 
		return player.onKill(world.getPlayer(killerid));
	else
		return player.onDeath();
});

addEventHandler("onPlayerChangeNick", function(playerid, p1 = 0, p2 = 0, p3 = 0) {
	local player = world.getPlayer(playerid);
	player.kick("Nick change");
});

addEventHandler("onPlayerVehicleEnter", function(playerid, vehicleid, seat) {
	return world.getPlayer(playerid).onVehicleEnter(
		world.getVehicle(vehicleid), seat
	);
});

addEventHandler("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
	return world.getPlayer(playerid).onVehicleExit(
		world.getVehicle(vehicleid), seat
	);
});

addEventHandler("onPlayerGuiOpen", function(playerid) {
	world.getPlayer(playerid).toggle(false);
});

addEventHandler("onPlayerLastGuiClose", function(playerid) {
	world.getPlayer(playerid).toggle(true);
});

addEventHandler("onPlayerChangeChatSlot", function(playerid = 999, slot = 888) {
	return world.getPlayer(playerid).onSlotChange(slot);
});

addEventHandler("onPlayerDisconnect", function(playerid, reason) {
	return world.delPlayer(playerid).onDisconnect(reason);
});

addEventHandler("onPlayerChat", function(playerid, text) {
	return world.getPlayer(playerid).onChat(text);
});

addEventHandler("onScriptExit", function() {
	dbg("stopping server");
	local players = world.getPlayers();
	local vehicles = world.getVehicles();
	foreach(player in players) player.kick("Server stopped");
	world.db.close();
});