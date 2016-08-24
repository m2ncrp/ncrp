class text3D {
	x = 0;
	y = 0;
	z = 0;
	color = null;
	text = "";
	uid = "";
	
	constructor(text, x, y, z, color = rgb()) {
		this.uid = md5(time().tostring() + random(1111,9999).tostring());
		this.text = text;
		this.x = x;
		this.y = y;
		this.z = z;
		this.color = color;
	}
	
	function create(player) 
	{
		local c = fromRGB(this.color.r, this.color.g, this.color.b, this.color.a);
		return triggerClientEvent(player.id, "onServer3DTextAdd", this.uid, this.text, this.x, this.y, this.z, c);
	}
	
	function destroy(player)
	{
		return triggerClientEvent(player.id, "onServer3DTextDelete", this.uid);
	}
}