include("controllers/city-regions/constants.nut");
local cityAreas = getCityAreas();
local cityAreasPoints = getCityAreasPoints();

event("onServerStarted", function() {
  foreach (idx, area in cityAreas) {
    dbg(idx, area)
    local points = area.points.map(function(pointNumber) {
      local point = cityAreasPoints["point"+pointNumber]
      return [ point.x, point.y];
    })

    dbg(idx, area.name, points)

    createPolygon(idx, points);
  }
});

event("onPlayerAreaEnter", function(playerid, name) {
    if (name.find("area") == null) {
        return;
    }

    local area = cityAreas[name];
    msg(playerid, format("You entered in %s", area.name))
});

event("onPlayerAreaLeave", function(playerid, name) {
    if (name.find("area") == null) {
        return;
    }

    local area = cityAreas[name];
    msg(playerid, format("You leaved %s", area.name))
});