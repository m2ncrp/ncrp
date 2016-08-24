class Weather {
	phase = 0;
	weather = 0;
	weathers = null;
	phases = null;
	
	constructor() 
	{
		this.weathers = ["clear", "foggy", "rainy"];
		this.phases = [
			"night", "night", ["early_morn1", "early_morn1", "early_morn"], ["early_morn2", "early_morn1", "early_morn"],
			"morning", "noon", "noon", "afternoon", "late_afternoon", "evening", "late_even", "night"
		];
	}
	
	function onPhaseChange(phaseid)
	{
		phaseid = phaseid.tointeger();
		if (phaseid >= 0 && phaseid < 24) {
			this.phase = floor(phaseid / WEATHER_PHASE_CHANGE);
			return this.changePhase();
		}
	}
	
	function getWeatherName()
	{
		local p = this.phases[this.phase];
		if (typeof p == "array") p = p[this.weather];
		return "DT_RTR" + this.weathers[this.weather] + "_day_" + p;
	}
	
	function changeWeather(weather)
	{
		this.weather = weather;
	}
	
	function changePhase()
	{
		return setWeather(this.getWeatherName());
	}
	
	function sync(player)
	{
		triggerClientEvent(player.id, "onServerWeatherSync", this.getWeatherName());
	}
}