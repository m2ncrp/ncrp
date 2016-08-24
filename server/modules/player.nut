class Player extends Object {

	uid = 0;
	id = 0;
	ip = null;
	serial = null;
	name = null;
	password = null;
	skin = null;
	money = DEFAULT_MONEY;
	spawn = 1;
	adminlevel = 0;
	logined = false;
	controlled = true;
	minutes = 0;
	lastaction = 0;
	position = null;
	afk = false;
	afkarea = Area3D(p3(), 5.0);
	places = null;
	memory = null;
	slot = 0;
	chatslots = null;
	onfinish = null;
	
	constructor(id, name, ip, serial)
	{
		skin = random(136,137);
		this.id = id;
		this.name = name;
		this.ip = ip;
		this.serial = serial;
		this.places = {};
		this.memory = {};
		this.chatslots = ["/ic", "/me", "/ooc"];
	}
	
	/* Callbacks */
	
	function onConnect() 
	{
		if (!this.checkName()) { this.kick("Wrong name"); }

		this.message("---------------------------------------------", CL_YELLOW);
		this.message("* " + l("welcome_title") + this.name);

		if (this.isRegistered()) {
			/*local self = this;
			world.addTimer(this.uid + "_register", function() {
    			gui_login(self);
			}, 500, 1);*/
			//gui_login( this );
			this.message("* " + l("welcome_login1"));
			this.message("*");
			this.message("* " + l("welcome_login2"));
		} else {
			this.message("* " + l("welcome_register1"));
			this.message("*");
			this.message("* " + l("welcome_register2"));
		}
		
		this.message("---------------------------------------------", CL_YELLOW);
	}
	
	function onDisconnect(reason) 
	{
		this.save();
	}
	
	function onSpawn() 
	{
		this.action();
		local place = world.getStruct(this.spawn);
		this.forceSpawn(place, MAX_HEALTH, this.skin);
		this.toggle((this.controlled && this.logined));
		
		foreach(struct in world.getStructures()) {
			struct.render(this);
			this.places[struct.uid] <- false;
		}
		foreach(org in world.getOrganizations()) {
			org.text.create(this);
		}
		world.sync(this);
	}
	
	function onKill(killer)
	{
		this.action();
		dbg("player->onKill " + this.name);
	}
	
	function onDeath()
	{
		this.action();
		dbg("player->onDie " + this.name);
	}
	
	function onVehicleEnter(vehicle, seat)
	{
		vehicle.onPlayerEnter(this, seat);
		this.action();
	}
	
	function onVehicleExit(vehicle, seat)
	{
		vehicle.onPlayerExit(this, seat);
		this.action();
		this.savepos();
	}

	function onSlotChange(slot) 
	{
		this.slot = slot;
	}
	
	function onChat(input) 
	{
		this.action();
		local flag = true;
		local ptext = function() {
			if (flag) {
				flag = false;
				return input;
			} 
			return ""; 
		};
		local command = split(this.chatslots[this.slot.tointeger()], " ");
		command[0] = str_replace("/", "", command[0]);
		if (command[0] in _server_commands) {
			local a0 = this.id;
			local a1 = ( command.len() > 1 ) ? command[1] : ptext();
			local a2 = ( command.len() > 2 ) ? command[2] : ptext();
			local a3 = ( command.len() > 3 ) ? command[3] : ptext();
			local a4 = ( command.len() > 4 ) ? command[4] : ptext();
			local a5 = ( command.len() > 5 ) ? command[5] : ptext();
			_server_commands[ command[0] ] (a0, a1, a2, a3, a4, a5);
		}
		return 0;
	}
	
	function onAfk()
	{
		this.message(l("player_onafk"));
	}
	
	function onAfterAfk()
	{
		this.message(l("player_ondeafk"));
	}
	
	function onBan(reason, days)
	{
	
	}
	
	function onSpawnBanned()
	{
		//doesn't work
	}
	
	function onStructEnter(struct)
	{
		this.message("You entered " + struct.name);
	}
	
	function onStructLeave(struct)
	{
		this.message("You left " + struct.name);
	}
	
	/* Methods */
	
	function setSlot(command) 
	{
		this.chatslots[this.slot] = command;
		triggerClientEvent(this.id, "onAddClienChatCommand", command);
	}

	function changeSlot(slot) 
	{
		this.slot = slot;
		triggerClientEvent(this.id, "onServerChangePlayerSlot", slot);
	}

	function forceSpawn(place, health = MAX_HEALTH, model = 0)
	{
		this.setPosition(place.position);
		this.setHealth(health);
		this.setModel(model);
	}

	function fadein(time, onfinish = null) 
	{
		triggerClientEvent(this.id, "onServerFadeScreen", time, true);
		if (onfinish) {
			local self = this;
			self.onfinish = onfinish;
			world.addTimer("fadein_" + this.id, function() {
				self.onfinish();
			}, time, 1);
		}
	}

	function fadeout(time, onfinish = null) 
	{
		triggerClientEvent(this.id, "onServerFadeScreen", time, false);
		if (onfinish) {
			local self = this;
			self.onfinish = onfinish;
			world.addTimer("fadeout_" + this.id, function() {
				self.onfinish();
			}, time, 1);
		}
	}
	
	function kick(reason = 0)
	{
		if (reason) Message.send(reason, this);// CLIENT SIDE
		this.save();
		kickPlayer(this.id);
	}
	
	function ban(reason, days = 30)
	{
		local unbanned = daystamp() + days;
		world.query("INSERT INTO player_bans (userid,reason,banned,unbanned) VALUES (%d,'%s',%d,%d)", this.uid, reason, daystamp(), unbanned);
		this.onBan(reason, days);
	}
	
	function checkName(username = 0)
	{
		if (!username) username = this.name;
		local rx = regexp("([A-Za-z0-9]{1,32}_[A-Za-z0-9]{1,32})");
		return rx.match(username);
	}
	
	function isRegistered()
	{
		local result = world.query("SELECT COUNT() FROM players WHERE name='%s'", this.name);
		return result[1]["COUNT()"].tointeger();
	}
	
	function isLogined()
	{
		this.action();
		return this.logined;
	}
	
	function tryRegister(password)
	{
		if (!this.logined && !this.isRegistered()) {
			password = md5(password);
			
			local s = "INSERT INTO players (name,password,spawn,skin,money,health) VALUES ('%s','%s',%d,%d,%f,%f)";
			world.query(s, this.name, password, this.spawn, this.skin, this.money, MAX_HEALTH);
			return true;
		}
		return false;
	}
	
	function tryLogin(password)
	{
		if (!this.logined && this.isRegistered()) {
			password = md5(password);
			
			local result = world.query("SELECT COUNT() FROM players WHERE name='%s' AND password='%s'", this.name, password);
			if (result[1]["COUNT()"].tointeger() > 0) {
				this.logined = true;
				this.password = password;
				this.load();
				return true;
			}
		}
		return false;
	}
	
	function update()
	{
		foreach(struct in world.getStructures()) {
			local instruct = struct.contains(this);
			if (this.places.len() > 0) {
				if (instruct && this.places[struct.uid] == false) {
					this.places[struct.uid] <- true;
					this.onStructEnter(struct);
				} else if (!instruct && this.places[struct.uid] == true) {
					this.places[struct.uid] <- false;
					this.onStructLeave(struct);
				}				
			}
		}
	}
	
	function load()
	{
		world.query("UPDATE players SET lasttime=%d WHERE name='%s'", daystamp(), this.name);
		
		local data = world.query("SELECT * FROM players WHERE name='%s' AND password='%s'", this.name, this.password)[1];
		
		this.spawn = data.spawn;
		this.minutes = data.minutes;
		this.adminlevel = data.adminlevel;
		this.money = data.money;
		this.uid = data.uid;
		this.skin = data.skin;
		this.position = p3(data.x, data.y, data.z);
		
		
		local bans = world.query("SELECT * FROM player_bans WHERE userid=%d AND unbanned>%d", this.uid, daystamp());
		if (bans.len() > 0) {  
			local place = world.getStruct(STRUCT_PRISON_BLOCK3);
			triggerClientEvent(this.id, "onPlayerSpawnBanned", bans);
			local skin = _player_prison_skins[random(0, _player_prison_skins.len() - 1)];
			this.forceSpawn(place, MAX_HEALTH, skin);
		} else {
			local place = {position = this.position};
			if (place.position.isNull()) place = world.getStruct(this.spawn);
			this.forceSpawn(place, data.health, data.skin);
		}
		this.toggle(true);
	}
	
	function save()
	{
		if (this.logined) {
			local p = this.getPosition();
			local string = "UPDATE players SET spawn=%d,minutes=%d,money=%d,skin=%d,health=%f,adminlevel=%d,x=%f,y=%f,z=%f WHERE name='%s'";
			world.query(string, this.spawn, this.minutes, this.money, this.skin, this.getHealth(), this.adminlevel, p.x, p.y, p.z, this.name);
			return true;
		}
	}

	function savepos()
	{
		if (this.logined) {
			local p = this.getPosition();
			local string = "UPDATE players SET x=%f,y=%f,z=%f WHERE name='%s'";
			world.query(string, p.x, p.y, p.z, this.name);
			return true;
		}
	}
	
	function checkpos()
	{
		if (!this.afkarea.contains(this)) {
			this.action();
		}
		this.afkarea.a = this.getPosition();
	}
	
	function action()
	{
		if (this.afk) {
			this.onAfterAfk();
			this.afk = false;
		}
		this.lastaction = time();
	}
	
	function isAfk()
	{
		this.checkpos();
		if ((time() - this.lastaction) > AFK_TIME) {
			if (!this.afk) {
				this.afk = true;
				this.onAfk();
			}
		}
		return this.afk;
	}
	
	function getMemory(name)
	{
		if (name in this.memory)
			return this.memory[name];
		return null;
	}

	function setMemory(name, value)
	{
		this.memory[name] <- value;
	}

	function delMemory(name)
	{
		local d = this.getMemory(name);
		if (d) delete this.memory[name];
		return d;
	}

	function getHealth()
	{
		return getPlayerHealth(this.id);
	}
	
	function setHealth(health)
	{
		return setPlayerHealth(this.id, health);
	}
	
	function getModel()
	{
		return getPlayerModel(this.id);
	}

	function setModel(model)
	{
		this.skin = model;
		return setPlayerModel(this.id, model);
	}
	
	function message(message, color = 0)
	{
		Chat.send(message, this, color);
	}
	
	function toggle(param)
	{
		return togglePlayerControls(this.id, param);
	}
	
	function inVehicle()
	{
		return isPlayerInVehicle(this.id);
	}
	
	function getVehicle()
	{
		return world.getVehicle(getPlayerVehicle(this.id));
	}
	
	function getPosition()
	{
		local pos = getPlayerPosition(this.id);
		return point(pos[0], pos[1], pos[2]);
	}
	
	function getRotation()
	{
		local pos = getPlayerRotation(this.id);
		return point(pos[0], pos[1], pos[2]);
	}
	
	function setPosition(p)
	{
		return setPlayerPosition(this.id, p.x, p.y, p.z);
	}
	
	function setRotation(p)
	{
		return setPlayerRotation(this.id, p.x, p.y, p.z);
	}

	function giveGun(gun, ammo)
	{
		return givePlayerWeapon(this.id, gun, ammo);
	}
}