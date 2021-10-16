include("controllers/sync-doors/models/Door.nut");

local coords = {
  clemente = [-28.1281, 1577.48, 100.376, 1848.97],
  seagift = [289.917, 42.6427, 426.186, 189.896],
  forge = [1366.69, 1150.28, 1011.31, 1400.56],
  port1 = [0.0, 0.0, 0.0, 0.0],
  port2 = [0.0, 0.0, 0.0, 0.0],
}

local doors = {};
local DOOR_PREFIX = "Door-";

event("onServerStarted", function() {

    logStr("[doors] loading door module...");

    doorsLoadedDataRead();

    foreach (idx, door in doors) {
      createPlace(format("%s%s", DOOR_PREFIX, door.name), coords[door.name][0], coords[door.name][1], coords[door.name][2], coords[door.name][3]);
    }
});

function doorsLoadedDataRead() {
    Door.findAll(function(err, results) {
        if(results.len()) {
            doors = results
        } else {
            local items = [
                {
                    name = "clemente",
                    state = "false",
                },
                {
                    name = "seagift",
                    state = "true",
                },
                {
                    name = "forge",
                    state = "false",
                }
            ];

            foreach(i, item in items) {
                local field = Door();

                // put data
                field.name = item.name;
                field.state = item.state;
                field.save();
            }

            doorsLoadedDataRead();
        };
    });
}

function getDoorField(name = "") {
    foreach(i, item in doors) {
        if(item.name == name) {
            return item;
        }
    }
}

function setDoorState(name, state) {
    local field = getDoorField(name);
    field.state = state.tostring();
    field.save();
}

event("onPlayerPlaceEnter", function(playerid, name) {
    delayedFunction(1000, function() {
        if(name.find(DOOR_PREFIX) == null) return;

        local doorName = name.slice(DOOR_PREFIX.len());
        local state = JSONParser.parse(getDoorField(doorName).state) ? "Open" : "Close"
        triggerClientEvent(playerid, doorName+state);
    });
});

acmd("door", function(playerid, doorName, state) {
    state = strip(state).slice(0, 1).toupper() + strip(state).slice(1).tolower();
    setDoorState(doorName, state == "Open" ? true : false);
    foreach (targetid, name in getPlayers()) {
        local plaPos = getPlayerPositionObj(targetid);
        if(isInPlace(DOOR_PREFIX+doorName, plaPos.x, plaPos.y)) {
            triggerClientEvent(targetid, doorName+state);
        }
    }
    msg(playerid, format("%s now: %s", doorName, state));
})

acmd("doors", function(playerid) {
    local phdoors = [];
    foreach(i, item in doors) {
       phdoors.push(format("%s - %s", item.name, item.state));
    }
    phdoors.push("/door name open/close");
    msgh(playerid, "Двери и ворота", phdoors);
})