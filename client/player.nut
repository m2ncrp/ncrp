local _server_time = {};

addEventHandler("onClientFrameRender", function(post) {
	if(!post && ("hour" in _server_time)) {
		local screen = getScreenSize();
		local t = _server_time;
		
		foreach(name, value in t) {
			if (!value) value = 0;
			t[name] = value.tostring();
			if (t[name].len() < 2) t[name] = "0" + value;
		}
		
		local ttime = t.hour + ":" + t.minute;
		local timesize = dxGetTextDimensions(ttime, 4.0, "tahoma-bold");
		dxDrawText(ttime, screen[0] - timesize[0] - 30.0, 8.0, 0xFFFFFFFF, true, "tahoma-bold", 4.0);
		
		local tdate = t.day + "." + t.month + "." + t.year;
		local datesize = dxGetTextDimensions(tdate, 1.0, "tahoma-bold");
		dxDrawText(tdate, screen[0] - timesize[0] / 2 - datesize[0] / 2 - 30.0, 70.0, 0xFFFFFFFF, true, "tahoma-bold", 1.0);
	}
});

addEventHandler("onServerTimeSync", function(m, h, d, mo, y) {
	local time = {minute = m, hour = h, day = d, month = mo, year = y};
	_server_time = time;
});

addEventHandler("onServerFadeScreen", function(time, fadein) {
	fadeScreen(time, fadein);
});