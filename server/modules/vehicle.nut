_vehicle_queue <- [];
_vehicle_number_map <- {};

for(local i = 1; i < MAX_VEHICLES; i++) {
	local a = i.tostring();
	if (a.len() == 1) a = "00" + a;
	else if (a.len() == 2) a = "0" + a;
	_vehicle_number_map[VEHICLE_PREFIX + a] <- true;
}

class Vehicle extends Object {

	uid = 0;
	id = 0;
	alarm = 0;
	color = 0;
	plate = "";
	tune = 0;
	dynamic = false;
	passengers = null;
	backpos = null;
	cache = null;
	// SEATBELT + to chanse
	
	constructor(model, plate, color, pos = p3(), rot = p3()) 
	{
		this.color = color;
		this.plate = plate;
		dbg("trying to create a vehicle");
		this.id = createVehicle(model.tointeger(), pos.x, pos.y, pos.z, rot.x, rot.y, rot.z);
		wait(1);
		
		_vehicle_queue.push(this);
		
		world.addTimer(this.id, function() {
			for(local i = 0; i < _vehicle_queue.len(); i++) {
				if (_vehicle_queue[i]) {
					local obj = _vehicle_queue[i];
					obj.setColor(obj.color);
					obj.setPlate(obj.plate);
					obj.setTuning(obj.tune);
					_vehicle_queue.remove(i);
					break;
				}
			}
		}, 3000, 1);
		this.cache = {};
		this.passengers = {};
		this.passengers[0] <- null;

		dbg("vehicle created");
	}
	
	function onPlayerEnter(player, seat = 0)
	{
		this.passengers[seat] <- player;
		if (seat == 0) {
			this.backpos = this.getPosition();
		}
	}

	function onPlayerExit(player, seat = 0)
	{
		this.save();
		this.passengers[seat] = null;
	}
	
	function destroy()
	{
		return destroyVehicle(this.id);
	}
	
	function repair()
	{
		return repairVehicle(this.id)
	}
	
	function load()
	{
		local result = world.query("SELECT * FROM vehicles");
		foreach(item in result) 
		{
			local pos = p3(item.x, item.y, item.z);
			local rot = p3(item.rx, item.ry, item.rz);
			local obj = Vehicle(item.model, item.plate, item.color, pos, rot);
			
			if ((item.plate in _vehicle_number_map) && _vehicle_number_map[item.plate] == true) {
				_vehicle_number_map[item.plate] = false;
			}
			
			obj.uid = item.uid;
			obj.tune = item.tune;
			obj.dynamic = true;
			
			world.addVehicle(obj);
		}
		return true;
	}
	
	function create()
	{
		local p = this.getPosition();
		local r = this.getRotation();
		local s = "INSERT INTO vehicles (model,plate,color,x,y,z,rx,ry,rz) VALUES (%d,'%s',%d,%f,%f,%f,%f,%f,%f)";
		world.query(s, this.getModel(), this.plate, this.color, p.x, p.y, p.z, r.x, r.y, r.z);
		this.uid = world.lastid();
		this.dynamic = true;
		return this.uid;
	}
	
	function del()
	{
		world.query("DELETE FROM vehicle_owners WHERE uid=%d", this.uid);
		world.query("DELETE FROM vehicles WHERE uid=%d", this.uid);
		world.delStruct(this.id).destroy();
	}
	
	function save()
	{
		if (this.dynamic) {
			local p = this.getPosition();
			local r = this.getRotation();
			local s = "UPDATE vehicles SET color=%d,plate='%s',x=%f,y=%f,z=%f,rx=%f,ry=%f,rz=%f WHERE uid=%d";
			world.query(s, this.getColor(), this.getPlate(), p.x, p.y, p.z, r.x, r.y, r.z, this.uid);
		}
	}
	
	function findEmptyNumber()
	{
		for(local i = 1; i < MAX_VEHICLES; i++) {
			local a = i.tostring();
			if (a.len() == 1) a = "00" + a;
			else if (a.len() == 2) a = "0" + a;
			if (_vehicle_number_map[VEHICLE_PREFIX + a] == true) {
				_vehicle_number_map[VEHICLE_PREFIX + a] = false;
				return VEHICLE_PREFIX + a;
			}
		}
		return (md5(time().tostring() + random(21,548454).tostring())).slice(0, 6);
	}
	
	function setCache(query, data) 
	{
		this.cache[query] <- data;
	}

	function getCache(query)
	{
		if (query in this.cache) {
			return this.cache[query];
		} 
		return -1;
	}

	function updCache(query) 
	{
		if (this.getCache(query) != -1) {
			this.cache[query] = null;
			delete this.cache[query];
		}
	}

	function addRole(player, role)
	{
		this.updCache("isRole_" + player.uid + "_" + role);
		if (!this.isRole(player, role)) {
			world.query("INSERT INTO vehicle_owners (vehicleid,userid,role) VALUES (%d,%d,%d)", this.uid, player.uid, role);
		}
	}
	
	function setRole(player, role)
	{
		this.updCache("isRole_" + player.uid + "_" + role);
		world.query("DELETE FROM vehicle_owners WHERE vehicleid=%d AND userid=%d");
		world.query("INSERT INTO vehicle_owners (vehicleid,userid,role) VALUES (%d,%d,%d)", this.uid, player.uid, role);
	}
	
	function delRole(player, role = 0)
	{
		this.updCache("isRole_" + player.uid + "_" + role);
		if (role)
			world.query("DELETE FROM vehicle_owners WHERE vehicleid=%d AND userid=%d AND role=%d", this.uid, player.uid, role);
		else
			world.query("DELETE FROM vehicle_owners WHERE vehicleid=%d AND userid=%d", this.uid, player.uid);
	}
	
	function isRole(player, role)
	{
		local cachename = "isRole_" + player.uid + "_" + role;
		if (this.getCache(cachename) == -1) {
			dbg(cachename);
			local string = "SELECT COUNT() FROM vehicle_owners WHERE vehicleid=%d AND userid=%d AND role=%d";
			local result = world.query(string, this.uid, player.uid, role)[1];
			this.setCache(cachename, (result["COUNT()"].tointeger() > 0));
		}
		return this.getCache(cachename);
	}
	
	function isFree()
	{
		local string = "SELECT COUNT() FROM vehicle_owners WHERE vehicleid=%d AND role=%d";
		local result = world.query(string, this.uid, 1)[1];
		if (result["COUNT()"].tointeger() < 1) return true;
		return false;
	}
	
	function isOwner(player)
	{
		return (this.isRole(player, 3)) ? true : false;
	}
	
	function isDisposer(player) 
	{
		return (this.isRole(player, 2)) ? true : false;
	}
	
	function isUser(player) 
	{
		return (this.isRole(player, 1)) ? true : false;
	}

	function getDriver()
	{
		return this.passengers[0];
	}

	function isDriven()
	{
		if (this.getDriver() != null) {
			return true;
		}
		return false;
	}

	function setColourEx(c) {return this.setColorEx(c);}
	function setColorEx(c) 
	{
		return setVehicleColour(this.id, c[0].r, c[0].g, c[0].b, c[1].r, c[1].g, c[1].b);
	}
	
	function getColourEx() {return this.getColorEx();}
	function getColorEx()
	{
		local c = getVehicleColour(this.id);
		return [rgb(c[0], c[1], [2]), rgb(c[3], c[4], c[5])];
	}
	
	function setColour(c) {return this.setColor(c);}
	function setColor(c) 
	{
		this.color = c.tointeger();
		return this.setColorEx(_vehicle_colors[this.color]);
	}
	
	function getColour() {return this.getColor();}
	function getColor()
	{
		return this.color;
	}
	
	function getModel() 
	{
		return getVehicleModel(this.id);
	}
	
	function setPlate(text = "")
	{
		return setVehiclePlateText(this.id, text);
	}
	
	function getPlate()
	{
		local number = getVehiclePlateText(this.id);
		if (number.len() > 6)
			return number.slice(0, 6);
		return number;
	}
	
	function getPosition()
	{
		local pos = getVehiclePosition(this.id);
		return point(pos[0], pos[1], pos[2]);
	}
	
	function getRotation()
	{
		local pos = getVehicleRotation(this.id);
		return point(pos[0], pos[1], pos[2]);
	}
	
	function setPosition(p)
	{
		return setVehiclePosition(this.id, p.x, p.y, p.z);
	}
	
	function setRotation(p)
	{
		return setVehicleRotation(this.id, p.x, p.y, p.z);
	}
	
	function setEngine(active)
	{
		return setVehicleEngineState(this.id, active);
	}
	
	function getEngine()
	{
		return getVehicleEngineState(this.id);
	}
	
	function getTuning()
	{
		return getVehicleTuningLevel(this.id);
	}
	
	function setTuning(level = 0)
	{
		return setVehicleTuningTable(this.id, level.tointeger());
	}

	function moveBack()
	{
		if (this.backpos) {
			this.setPosition(this.backpos);
			this.setEngine(false);
		}
	}
	
	function engine()
	{
		if (this.getEngine()) {
			this.setEngine(false);
		} else {
			this.setEngine(true);
		}
	}
}
