class mapBlip {
	x = 0;
	y = 0;
	r = 0;
	library = 0;
	icon = 0;
	uid = "";
	
	constructor(x, y, library = -1, icon = -1, r = 125.0) {
		this.uid = md5(time().tostring() + random(1111,9999).tostring());
		this.library = library;
		this.icon = icon;
		this.r = r;
		this.x = x;
		this.y = y;
	}
	
	function create(player) 
	{
		if (this.library != -1 && this.icon != -1)
		return triggerClientEvent(player.id, "onServerBlipAdd", this.uid, this.x, this.y, this.r, this.library, this.icon);
		return false;
	}
	
	function destroy(player)
	{
		if (this.library != -1 && this.icon != -1)
		return triggerClientEvent(player.id, "onServerBlipDelete", this.uid);
		return false;
	}
}