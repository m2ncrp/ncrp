class Organization {
	
	uid = 0;
	name = "";
	structid = 0;
	parent = 0;
	ranks = null;
	data = null;
	text = null;
	
	constructor(name, structid, parent = 0)
	{
		this.ranks = [];
		this.data = {};
		this.name = name;
		this.structid = structid;
		this.parent = parent;
		local pos = world.getStruct(this.structid).getPosition();
		this.text = text3D(this.name, pos.x, pos.y, pos.z + 0.25);
	}
	
	function load()
	{
		local result = world.query("SELECT * FROM fractions");
		foreach(item in result) 
		{
			local obj = Organization(item.name, item.structid, item.parentid);

			obj.uid = item.uid;
			obj.loadRanks();
			obj.loadData();

			world.addOrganization(obj);
		}
		return true;
	}
	
	function create()
	{
		local string = "INSERT INTO fractions (name,parentid,structid) VALUES ('%s',%d,%d)";
		world.query(string, this.name, this.parent, this.structid);
		this.uid = world.lastid();
		
		this.renderForAll();
	}
	
	function destroy()
	{
		world.query("DELETE FROM fractions WHERE uid=%d", this.uid);
		world.query("DELETE FROM fraction_ranks WHERE fractionid=%d", this.uid);
		world.query("DELETE FROM fraction_members WHERE fractionid=%d", this.uid);
		world.delOrganization(this.uid);
	}
	
	function renderForAll()
	{
		foreach(player in world.getPlayers()) {
			this.text.create(player);
		}
	}

	function loadRanks()
	{
		local result = world.query("SELECT * FROM fraction_ranks WHERE fractionid=%d", this.uid);
		foreach(item in result) {
			this.ranks.push(item);
		}
	}
	
	function loadData()
	{
		local result = world.query("SELECT * FROM fraction_data WHERE fractionid=%d", this.uid);
		foreach(item in result) {
			this.setData(item.name, item.value, item.type.tointeger());
		}
	}

	function saveData()
	{
		foreach(name, value in this.data) {
			local q = "UPDATE fraction_data SET (value='%s',type=%d) WHERE fractionid=%d AND name='%s' IF @@ROWCOUNT=0 INSERT INTO fraction_data VALUES (NULL,%d,'%s','%s',%d)";
			world.query(q, value, this.getDType(value), this.uid, name, this.uid, name, value, this.getDType(value));
		}
	}

	function getDType(value) 
	{
		local type = 0;
		switch(typeof value) {
			case "string": type = 0; break;
			case "integer": type = 1; break;
			case "float": type = 3; break;
		} 
		return type;
	}

	function setDType(value, type = 0)
	{
		switch(type) {
			case 0: value = value.tostring();  break;
			case 1: value = value.tointeger(); break;
			case 2: value = value.tofloat();   break;
		}
		return value;
	}

	function setData(name, value, type = 0)
	{
		value = this.setDType(value, type);
		this.data[name] <- value;
		return value;
	}
	
	function getData(name)
	{
		if (name in this.data) {
			return name;
		}
		return null;
	}

	function delData(name)
	{
		if (name in this.data) {
			local value = this.data[name];
			delete this.data[name];
			return value;
		}
		return false;
	}

	function addRank(name, open = false, role = 1)
	{
		local string = "INSERT INTO fraction_ranks (name,open,fractionid,role) VALUES ('%s',%b,%d,%d)";
		world.query(string, name, open, this.uid, role);
		local obj = {uid = world.lastid(), name = name, open = open, fractionid = this.uid, role = role};
		this.ranks.push(obj);
	}

	function delRank(id)
	{
		world.query(
			"DELETE FROM fraction_members WHERE rankid IN (SELECT uid FROM fraction_ranks WHERE rank=%d AND fractionid=%d", 
			id, this.uid
		);
		delete this.ranks[id];
		world.query("DELETE FROM fraction_ranks WHERE rank=%d AND fractionid=%d", id, this.uid);
	}
	
	function getRankByUid(uid)
	{
		foreach(rank in this.ranks) {
			if (rank.uid == uid) {
				return rank;
			}
		}
	}
	
	function getRank(player)
	{
		local s = "SELECT rankid FROM fraction_members WHERE userid=%d AND fractionid=%d";
		local r = world.query(s, player.uid, this.uid)[1];
		return this.getRankByUid(r.rankid);
	}
	
	function getRole(player)
	{
		return this.getRank(player).role;
	}
	
	function setRank(player, rank)
	{
		if (this.isMember(player)) {
			local r = this.ranks[rank];
			world.query("UPDATE fraction_members SET rankid=%d WHERE userid=%d AND fractionid=%d", r.uid, player.uid, this.uid);
		}
	}
	
	function addMember(player, rank)
	{
		local r = this.ranks[rank].uid;
		world.query("INSERT INTO fraction_members (fractionid,userid,rankid) VALUES (%d,%d,%d)", this.uid, player.uid, r);
	}
	
	function delMember(player)
	{
		world.query("DELETE FROM fraction_members WHERE fractionid=%d AND userid=%d", this.uid, player.uid);
	}
	
	function isMember(player)
	{
		local string = "SELECT COUNT() FROM fraction_members WHERE fractionid=%d AND userid=%d";
		local result = world.query(string, this.uid, player.uid)[1];
		if (result["COUNT()"].tointeger() > 0) return true;
		return false;
	}
	
	function getParent()
	{
		if (this.parent)
			return world.getOrganization(this.parent);
		return false;
	}

	/* Routes */
	
	function addRoutePoint(player, position = false, command = "", time = 0, transport = false)
	{
		local p = point();
		local t = 0;
		if (position) p = player.getPosition();
		if (transport) t = (player.inVehicle()) ? player.getVehicle().getModel() : 0;

		local q = "INSERT INTO fraction_route_points (x,y,z,r,transport,command,time,parent) VALUES (%f,%f,%f,%f,%d,'%s',%d,%d)";
		world.query(q, p.x, p.y, p.z, ROUTE_POINT_RADIUS, t, command, time, player.getMemory("org_route_parent"));

		if (player.getMemory("org_route_parent") == 0) {
			player.setMemory("org_route_first", world.lastid());
		}

		player.setMemory("org_route_parent", world.lastid());
	}	

	function addRoute(player, name, type = STRICT_POINTS)
	{
		world.query("INSERT INTO fraction_routes (name, type, fractionid) VALUES ('%s', %d, %d)", name, type, this.uid);

		player.setMemory("org_route_parent", 0);
		player.setMemory("org_route_header", world.lastid());
	}

	function commitRoute(player)
	{
		world.query("UPDATE fraction_routes SET (head=%d) WHERE uid=%d", player.delMemory("org_route_first"), player.delMemory("org_route_header"));
	}

	function getPosition() 
	{
		return world.getStruct(this.structid).getPosition();
	}
}