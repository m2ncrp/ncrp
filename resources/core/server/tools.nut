function concat(vars) {
	return vars.reduce(function(carry, item) { return carry + " " + item; });
}

function random(min = 0, max = RAND_MAX)
{
   return (rand() % ((max + 1) - min)) + min;
}

const NORMAL_RADIUS = 20.0;
const SHOUT_RADIUS = 35.0;

function getDistance( senderID, targetID ) 
{
	local p1 = getPlayerPosition( sender );
	local p2 = getPlayerPosition( targetID );
	
	return getDistanceBetweenPoints3D(p1[0], p1[1], p1[2], p2[0], p2[1], p2[2]);
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
		this.players[id] <- Player(id, name, ip, serial);
		this.players[id].onConnect();
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
		foreach(player in this.getPlayers()) {
			local dist = getDistance(playerid, player);
			if(dist < min || !min) {
				min = dist;
				str = player;
			}
		}
		return str;
	}
}