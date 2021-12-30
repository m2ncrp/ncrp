include("controllers/sync-doors/models/Door.nut");

local coords = {
  clemente = [-28.1281, 1577.48, 100.376, 1848.97],
  seagift = [289.917, 42.6427, 426.186, 189.896],
  forge = [1366.69, 1150.28, 1011.31, 1400.56],
  port1 = [0.0, 0.0, 0.0, 0.0],
  port2 = [0.0, 0.0, 0.0, 0.0],
}

local places = {
    "fuelStationLittleItalyWest": {"doors": ["Wash_gate00", "Wash_gate01", "GS_door", "GS_door00", "GS_door01"], "coords": [-145.67170, 606.97190, -167.67170, 614.97190]},
    "clemente": {"doors": ["HlavniVrata"], "coords": [-28.1281, 1577.48, 100.376, 1848.97]},
    "seagift": {"doors": ["SG_gate01"], "coords": [289.917, 42.6427, 426.186, 189.896]},
    "forge": {"doors": ["FNDR_Vrata_Exter"], "coords": [1366.69, 1150.28, 1011.31, 1400.56]},
}

local doors = {};
local DOOR_PREFIX = "Door-";

event("onServerStarted", function() {

    logStr("[doors] loading door module...");

    doorsLoadedDataRead();

    foreach (idx, door in places) {
        createPlace(format("%s%s", DOOR_PREFIX, idx), places[idx]["coords"][0], places[idx]["coords"][1], places[idx]["coords"][2], places[idx]["coords"][3]);
    }
});

function doorsLoadedDataRead() {
    Door.findAll(function(err, results) {
        if(results.len()) {
            doors = results
        } else {
            foreach(i, item in places) {
                foreach (idx, value in item.doors) {
                    local field = Door();
                    // put data
                    field.name = format("%s-%s", i, value);
                    dbg(field.name);
                    field.ingame_name = value;
                    field.state = "false"
                    field.save();
                }
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
    dbg(name, state)
    field.save();
}

event("onPlayerPlaceEnter", function(playerid, name) {
    delayedFunction(1000, function() {
        if(name.find(DOOR_PREFIX) == null) return;
        local doorName = name.slice(DOOR_PREFIX.len());
        foreach (idx, value in places[doorName]["doors"]) {
            local state = getDoorField(doorName + "-" + value).state;
            local name = getDoorField(doorName + "-" + value).ingame_name;
            dbg(state);
            if (state == "true") {
                triggerClientEvent(playerid, "doorOpen", name);
            } else {
                triggerClientEvent(playerid, "doorClose", name);
            }
        }
    });
});

acmd("door", function(playerid, doorName, state) {
    local state = strip(state).slice(0, 1).toupper() + strip(state).slice(1).tolower();
    dbg(state);
    setDoorState(doorName, state == "Open" ? true : false);
    foreach (targetid, name in getPlayers()) {
        local plaPos = getPlayerPositionObj(targetid);
        local placeName = DOOR_PREFIX+split(doorName,"-")[0];
        if(isInPlace(placeName, plaPos.x, plaPos.y)) {
            dbg("Я ТУТ");
            if (state == "Open") {
                triggerClientEvent(playerid, "doorOpen", getDoorField(doorName).ingame_name);
            } else {
                triggerClientEvent(playerid, "doorClose", getDoorField(doorName).ingame_name);
            }
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
