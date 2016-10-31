function concat(vars) {
	return vars.reduce(function(carry, item) { return carry + " " + item; });
}

function random(min = 0, max = RAND_MAX)
{
   return (rand() % ((max + 1) - min)) + min;
}

function getDistance( senderID, targetID ) 
{
	local p1 = getPlayerPosition( senderID );
	local p2 = getPlayerPosition( targetID );
	
	return getDistanceBetweenPoints3D(p1[0], p1[1], p1[2], p2[0], p2[1], p2[2]);
}

function inRadius(message, sender, radius, color = 0)
{
	local players = playerList.getPlayers();
	foreach(player in players) {
		if (getDistance(sender, player) <= radius) {
			if (color)
				sendPlayerMessage(player, message, color.r, color.g, color.b);
			else 
				sendPlayerMessage(player, message);
		}
	}
}

class PlayerList 
{
	players = null;

	constructor () {
	    this.players = {};	    
	}

	function getPlayers()
	{
		return this.players;
	}
	
	function addPlayer(id, name, ip, serial) 
	{
		this.players[id] <- id;
	}
	
	function delPlayer(id) 
	{
		local t = this.players[id];
		delete this.players[id];
		return t;
	}
	
	function getPlayer(id)
	{
		return this.players[id];
	}
	
	function nearestPlayer( playerid )
	{
		local min = null;
		local str = null;
		foreach(target in this.getPlayers()) {
			local dist = getDistance(playerid, player);
			if(dist < min || !min) {
				min = dist;
				str = target;
			}
		}
		return str;
	}
}
