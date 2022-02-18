local nodes = getSnowplowNodes();
local edges = getSnowplowEdges();

event("onServerStarted", function() {
    foreach (idx, point in nodes) {
        create3DText(point.coords.x, point.coords.y, point.coords.z+0.35, "POINT "+idx, CL_RIPELEMON, 75.0 );
    }

    foreach (idx, edge in edges) {
        foreach (idy, zoneId in edge) {
            local prevId = idx.tointeger();
            createLine(
                format("%d_%d", prevId, zoneId),
                nodes[prevId].coords.x,
                nodes[prevId].coords.y,
                nodes[prevId].coords.z,
                nodes[zoneId].coords.x,
                nodes[zoneId].coords.y,
                nodes[zoneId].coords.z
            );
        }
    }
});

local record = false;
local prevId = null;

key("y", function(playerid) {
    record = !record;
    msg(playerid, "Now record is "+record, record ? CL_SUCCESS : CL_ERROR)
});

key("t", function(playerid) {
    prevId = null;
    return msg(playerid, "Reset prevId", CL_WARNING);
});

event("onPlayerAreaEnter", function(playerid, name) {
    if(!record) return;

    local parts = split(name, "_");

    if(parts[0] != "snowplowZone") return msg(playerid, "not snowplowZone");
    local zoneId = parts[1].tointeger();

    dbg(prevId, ":", zoneId)

    if(prevId == zoneId) return msg(playerid, "prevId == zoneId");

    if(!(zoneId in edges)) {
        edges[zoneId] <- [];
    }

    if(!prevId) {
        prevId = zoneId;
        return msg(playerid, format("Set new prevId. Now: %d", zoneId));
    }

    if(edges[prevId].find(zoneId.tointeger()) != null) {
        msg(playerid, format("%d already exist in %d", zoneId, prevId));
        return prevId = zoneId;
    }

    edges[prevId].push(zoneId.tointeger());

    msg(playerid, format("To %d added %d", prevId, zoneId), CL_SUCCESS);

    createLine(
        format("%d_%d", prevId, zoneId),
        nodes[prevId.tointeger()].coords.x,
        nodes[prevId.tointeger()].coords.y,
        nodes[prevId.tointeger()].coords.z,
        nodes[zoneId.tointeger()].coords.x,
        nodes[zoneId.tointeger()].coords.y,
        nodes[zoneId.tointeger()].coords.z
    );

    prevId = zoneId;
})


class DataFile {
    filename = null;

    constructor (name, rights = "a") {
        filename = file(name, rights);
    }

    function write(data) {
        data = data.tostring();
        for (local i = 0; i < data.len(); i++) {
          filename.writen(data[i], 'b');
        }
        filename.writen('\n', 'b');
        return this;
    }

    function newline() {
        filename.writen('\n', 'b');
        return this;
    }

    function close() {
        filename.close();
    }
}

cmd("log", function(playerid) {
    msg(playerid, JSONEncoder.encode(edges), CL_CHESTNUT);
    local file = DataFile("edges.json")
    file.write(JSONEncoder.encode(edges));
    file.close();
})

local count = nodes.len();

key("n", function(playerid) {
    if(!isPlayerInValidVehicle(playerid, 39)) { return msg(playerid, "You need Shubert SnowPlow."); }
    local vehicleid = getPlayerVehicle(playerid);
    local vehPos = getVehiclePositionObj(vehicleid);

    dbg("snowplowv3( " + format("%.3f", round(vehPos.x, 3)) +",  "+    format("%.3f", round(vehPos.y, 3)) +",  "+   format("%.3f", round(vehPos.z, 3)) +" );");
    msg(playerid, "Чекпоинт добавлен: "+count, CL_SUCCESS );
    create3DText(x, y, z+0.35, "POINT "+count, CL_RIPELEMON, 75.0 );
    count += 1;
});