local _blip_objects = {};
local _blip_cooldown_ticks = 0;

addEventHandler("onClientProcess", function() {
	if (_blip_cooldown_ticks > 10) {
	foreach(blip in _blip_objects) {
		local pos = getPlayerPosition(getLocalPlayer());
		local dist = getDistanceBetweenPoints2D(pos[0], pos[1], blip.x, blip.y);
		if (dist <= blip.r.tofloat() || blip.r.tointeger() == -1) {
			if (!blip.visible) {
				blip.id = createBlip(blip.x.tofloat(), blip.y.tofloat(), blip.library, blip.icon);
				blip.visible = true;
			}
		} else {
			if (blip.visible) {
				blip.visible = false;
				destroyBlip(blip.id);
				blip.id = -1;
			}
		}
	}
	_blip_cooldown_ticks = 0; } 
	_blip_cooldown_ticks++;
});

addEventHandler("onServerBlipAdd", function(uid, x, y, r, library, icon) {
	local obj = {id = -1, x = x, y = y, r = r, library = library, icon = icon, visible = false};
	_blip_objects[uid] <- obj;
});

addEventHandler("onServerBlipDelete", function(uid) {
	destroyBlip(_blip_objects[uid]);
	delete _blip_objects[uid];
});
