class Message {
	function send(message, player, color = 0)
	{
		if (!color) { color = rgb();}
		sendPlayerMessage(player.id, message, color.r, color.g, color.b);
	}
	
	function sendAll(message, color = 0)
	{
		if (!color) { color = rgb();}
		local players = world.getPlayers();
		foreach(id, player in players) 
		{
			if (player.logined) {
				this.send(message, player, color);
			}
		}
	}
	
	function oldSendAll(message, color = 0)
	{
		if (!color) { color = rgb();}
		sendPlayerMessageToAll(message, rgb.r, rgb.g, rgb.b);
	}
	
	function inRadius(message, sender, radius, color = 0)
	{
		local players = world.getPlayers();
		foreach(player in players) {
			if (sender.getDistance(player) <= radius) {
				this.send(message, player, color);
			}
		}
	}
	
	function inRadiusEx(message, sender, radius = NORMAL_RADIUS, color = 0)
	{
		local players = world.getPlayers();
		foreach(player in players) {
			if (sender.id != player.id && sender.getDistance(player) <= radius) {
				this.send(message, player, color);
			}
		}
	}
	
	function tostring(array)
	{
		local result = "";
		foreach(string in array) result += " " + string;
		return strip(result);
	}
}