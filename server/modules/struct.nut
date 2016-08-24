class Struct extends Object {

	uid = 0;
	name = "";
	position = null;
	size = null;
	text = null;
	type = 1;
	
	constructor(pos, size)
	{
		this.name = "Empty Structure";
		this.position = pos;
		if (size.y.tofloat() != 0.0) {
			this.type = 2;
		}
		this.size = size;
		local c = this.getCenter();
		this.text = text3D(name, c.x, c.y, c.z, rgb(200,200,200,100));
	}
	
	function load()
	{
		local result = world.query("SELECT * FROM structures");
		foreach(item in result) 
		{
			local obj = Struct(p3(item.x, item.y, item.z), p3(item.sx, item.sy));

			obj.uid = item.uid;
			obj.setName(item.name, true);

			world.addStruct(obj);
		}
		return true;
	}
	
	function create()
	{
		local p = this.position;
		local size = this.size;

		local s = "INSERT INTO structures (name,x,y,z,sx,sy) VALUES ('%s',%f,%f,%f,%f,%f)";
		world.query(s, this.name, p.x, p.y, p.z, size.x.tofloat(), size.y.tofloat());
		this.uid = world.lastid();
		
		this.renderForAll();
		return this;
	}

	function setName(name, localy = false)
	{
		this.name = name;
		this.text.text = name;
		if (!localy) { 
			world.query("UPDATE structures SET name='%s' WHERE uid=%d", name, this.uid);
			this.renderForAll(true);
		}
	}
	
	function destroy()
	{
		world.query("DELETE FROM struct_owners WHERE structid=%d", this.uid);
		world.query("DELETE FROM structures WHERE uid=%d", this.uid);
		world.delStruct(this.uid);
	}
	
	function render(player, reset = false)
	{
		if (reset) this.text.destroy(player);
		this.text.create(player);
	}
	
	function renderForAll(reset = false)
	{
		foreach(player in world.getPlayers()) {
			this.render(player, reset);
			if (!reset) player.places[this.uid] <- false;
		}
	}
	
	function isRole(player, role)
	{
		local string = "SELECT COUNT() FROM struct_owners WHERE structid=%d AND userid=%d AND role=%d";
		local result = world.query(string, this.uid, player.uid, role)[1];
		if (result["COUNT()"].tointeger() > 0) return true;
		return false;
	}
	
	function isOwner(player)
	{
		if (this.isRole(player, 3)) return true;
		return false;
	}
	
	function contains(object)
	{
		local area = null;
		if (this.type == 1)
			area = Area3D(this.position, this.size.x);
		else
			area = Area2D(this.position, this.size);
		return area.contains(object);
	}
	
	function getCenter()
	{
		if (this.type == 1) {
			return this.getPosition();
		} else if (this.type == 2) {
			local p = point();
			p.x = (this.position.x + this.size.x) / 2;
			p.y = (this.position.y + this.size.y) / 2;
			p.z = this.position.z;
			return p;
		}
		return null;
	}

	function getPosition()
	{
		return this.position;
	}
	
	function setPosition(p)
	{
		return this.position = p;
	}
}