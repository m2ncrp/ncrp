class World {

	db = null;
	players = null;
	vehicles = null;
	timers = null;
	spawns = null;
	structures = null;
	organizations = null;
	weather = null;
	time = null;
	
	constructor(database) 
	{
		this.players = {};
		this.vehicles = {};
		this.timers = {};
		this.spawns = {};
		this.structures = {};
		this.organizations = {};
		this.time = {};
		this.db = database;
		this.weather = Weather();
		this.time = {second = 0, minute = 0, hour = 0, day = 0, month = 0, year = 0};
	}
	
	function load()
	{
		local r = this.query("SELECT * FROM world")[1];
		this.time.minute = r.minute;
		this.time.hour = r.hour;
		this.time.day = r.day;
		this.time.month = r.month;
		this.time.year = r.year;
		
		this.weather.onPhaseChange(this.time.hour);
		Struct.load();
		Organization.load();
		Vehicle.load();
	}
	
	function autosave()
	{
		dbg("Autosave");
		local s = "UPDATE world SET minute=%d,hour=%d,day=%d,month=%d,year=%d";
		local t = this.time;
		this.query(s, t.minute, t.hour, t.day, t.month, t.year);
		foreach(player in this.getPlayers()) {
			player.save();
		}
	}

	function sync(player)
	{
		local t = this.time;
		this.weather.sync(player);
		triggerClientEvent(player.id, "onServerTimeSync", t.minute, t.hour, t.day, t.month, t.year.tostring());
	}
	
	function onSecondChange()
	{
		this.time.second++;
		if (this.time.second >= WORLD_SECONDS_PER_MINUTE) {
			this.time.second = 0;
			this.onMinuteChange();
		}
		foreach(player in this.getPlayers()) {
			player.update();
		}
	}
	
	function onMinuteChange() 
	{
		this.time.minute++;
		if (this.time.minute >= WORLD_MINUTES_PER_HOUR) {
			this.time.minute = 0;
			this.onHourChange();
		}
		foreach(player in this.getPlayers()) {
			if (!player.isAfk()) player.minutes++;
			this.sync(player);
		}
		if (!(this.time.minute % AUTOSAVE_TIME)) this.autosave();
	}
	
	function onHourChange()
	{
		this.time.hour++;
		if (this.time.hour >= WORLD_HOURS_PER_DAY) {
			this.time.hour = 0;
			this.onDayChange();
		}
		this.weather.onPhaseChange(this.time.hour);
	}
	
	function onDayChange()
	{
		this.time.day++;
		if (this.time.day >= WORLD_DAYS_PER_MONTH) {
			this.time.day = 1;
			this.onMonthChange();
		}
	}
	
	function onMonthChange()
	{
		this.time.month++;
		if (this.time.month >= WORLD_MONTH_PER_YEAR) {
			this.time.month = 1;
			this.onYearChange();
		}
	}
	
	function onYearChange()
	{
		this.time.year++;
	}
	
	/* Time */
	function setHour(){
		this.onHourChange();
	}
	
	/* Players */
	
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
	
	function nearestPlayer(object)
	{
		local min = null;
		local str = null;
		foreach(player in this.getPlayers()) {
			local dist = object.getDistance(player);
			if(dist < min || !min) {
				min = dist;
				str = player;
			}
		}
		return str;
	}
	
	/* Vehicles */
	function getVehicles()
	{
		return this.vehicles;
	}
	
	function addVehicle(obj) 
	{
		this.vehicles[obj.id] <- obj;
		return obj;
	}
	
	function delVehicle(id) 
	{
		local t = this.vehicles[id];
		delete this.vehicles[id];
		return t;
	}
	
	function getVehicle(id)
	{
		return this.vehicles[id];
	}
	
	function nearestVehicle(object)
	{
		local min = null;
		local str = null;
		foreach(vehicle in this.getVehicles()) {
			local dist = object.getDistance(vehicle);
			if(dist < min || !min) {
				min = dist;
				str = vehicle;
			}
		}
		return str;
	}
	
	
	/* Timers */
	function addTimer(name, func, interval, repeat = -1) 
	{
		this.timers[name] <- timer(func, interval, repeat);
	}
	
	function activeTimer(name) 
	{
		return this.timers[name].IsActive();
	}
	
	function delTimer(name)
	{
		if (this.activeTimer(name)) {
			this.timers[name].Kill();	
		}
	}
	
	
	/* Structures */
	function getStructures()
	{
		return this.structures;
	}
	
	function addStruct(obj)
	{
		this.structures[obj.uid] <- obj;
		return obj;
	}
	
	function delStruct(id) 
	{
		local t = this.structures[id];
		delete this.structures[id];
		return t;
	}
	
	function getStruct(id)
	{
		return this.structures[id];
	}
	
	function nearestStructure(object)
	{
		local min = null;
		local str = null;
		foreach(structure in this.getStructures()) {
			local dist = object.getDistance(structure);
			if(dist < min || !min) {
				min = dist;
				str = structure;
			}
		}
		return str;
	}
	
	/* Fractions */
	function getOrganizations()
	{
		return this.organizations;
	}
	
	function addOrganization(obj)
	{
		this.organizations[obj.uid] <- obj;
		return obj;
	}
	
	function delOrganization(id) 
	{
		local t = this.organizations[id];
		delete this.organizations[id];
		return t;
	}
	
	function getOrganization(id)
	{
		return this.organizations[id];
	}
	
	function nearestOrganization(object)
	{
		local min = null;
		local str = null;
		foreach(org in this.getOrganizations()) {
			local dist = object.getDistance(org);
			if(dist < min || !min) {
				min = dist;
				str = org;
			}
		}
		return str;
	}
	
	/* Database */
	function query(s,
		p0=0,p1=0,p2=0,p3=0,p4=0,p5=0,p6=0,p7=0,p8=0,p9=0,p10=0,
		p11=0,p12=0,p13=0,p14=0,p15=0,p16=0,p17=0,p18=0,p19=0,p20=0,
		p21=0,p22=0,p23=0,p24=0,p25=0,p26=0,p27=0,p28=0,p29=0,p30=0
	) {
		local string = format(s,
			p0,p1,p2,p3,p4,p5,p6,p7,p8,p9,p10,
			p11,p12,p13,p14,p15,p16,p17,p18,p19,p20,
			p21,p22,p23,p24,p25,p26,p27,p28,p29,p30
		);
		return this.db.query(string);
	}
	
	function lastid()
	{
		return this.db.last_insert_id();
	}
}