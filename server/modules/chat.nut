class Chat extends Message 
{
	function info(message, player)
	{
		this.send(l("message_yellow") + message, player, CL_YELLOW);
	}
	
	function warn(message, player)
	{
		this.send(l("message_red") + message, player, CL_RED);
	}
	
	function green(message, player)
	{
		this.send(l("message_green") + message, player, CL_GREEN);
	}

	function hint(message, player)
	{
		this.send(l("message_hint") + message, player, CL_YELLOW);
	}
	
	function shout(strings, player)
	{
		this.inRadius(player.name + " shout: " + this.tostring(strings) , player, SHOUT_RADIUS, rgb(255,255,215));
	}
	
	function me(strings, player)
	{
		this.inRadius("[ME] " + player.name + " " + this.tostring(strings) + ".", player, NORMAL_RADIUS, rgb(255,215,215));
	}
	
	function trysmth(strings, player)
	{
		local res = random(0,1);
		if(res == 1){
			this.inRadius("[TRY] " + player.name + this.tostring(strings) + " (success).", player, NORMAL_RADIUS, rgb(255,215,215));
		}else{
			this.inRadius("[TRY] " + player.name + this.tostring(strings) + " (failed).", player, NORMAL_RADIUS, rgb(255,215,215));
		}
	}

	function ic(strings, player) 
	{
		this.inRadius("[IC]" + player.name + ": " + this.tostring(strings), player, NORMAL_RADIUS, rgb(255, 255, 255));
	}
	
	function b(strings, player) 
	{
		this.inRadius("[B]" + player.name + ": " + this.tostring(strings), player, NORMAL_RADIUS, rgb(170, 170, 170));
	}
	
	function whisper(strings, player, target) 
	{
		this.send("[W] from " + player.name + ": " + this.tostring(strings), target, rgb(230, 230, 230));
		this.send("[W] to "   + target.name + ": " + this.tostring(strings), player, rgb(230, 230, 230));
	}
	
	function global(strings, player) 
	{
		this.sendAll("[OOC]" + player.name + "[" + player.id + "]" + ": " + this.tostring(strings), rgb(170, 170, 170));
	}
}

/*

/s - крик, больший радиус чем обычно
/l - шепот
/low -||-
/w [id] [text] - шепот кому то [id], рядом
/o - оос чат
/b - local ooc (( NICK: MESSAGE))
/pm [id] [text] - админская

/me
/do
/r
/ra
/ad

*/