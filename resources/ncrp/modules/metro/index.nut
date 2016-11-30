include("modules/metro/commands.nut");

translation("en", {
    "metro.toofaraway"              : "[SUBWAY] You are too far from any station!"
    "metro.notenoughmoney"          : "[SUBWAY] Not enough money!"
    "metro.pay"                     : "[SUBWAY] You pay $%.2f for ticket."
    "metro.arrived"                 : "[SUBWAY] You arrived to %s station."
    "metro.herealready"             : "[SUBWAY] You're here already."
    "metro.notexist"                : "[SUBWAY] Selected station doesn't exist."
    "metro.nocar"                   : "[SUBWAY] Subway isn't ferry boat. Leave the car."

    "metro.listStations.title"      : "List of available stations:"
    "metro.listStations.station"    : "Station #%d - %s"

});

translation("ru", {
    "metro.toofaraway"              : "[МЕТРО] Вы находитесь слишком далеко от станции!"
    "metro.notenoughmoney"          : "[МЕТРО] У вас недостаточно денег!"
    "metro.pay"                     : "[МЕТРО] Вы заплатили $%.2f за проезд."
    "metro.arrived"                 : "[МЕТРО] Вы прибыли на станцию %s."
    "metro.herealready"             : "[МЕТРО] Вы и так уже здесь."
    "metro.notexist"                : "[МЕТРО] Выбранной станции метро не существует."
    "metro.nocar"                   : "[МЕТРО] Метро - не паром. Выйдите из авто."

    "metro.listStations.title"      : "Список доступных станций метро:"
    "metro.listStations.station"    : "Станция #%d - %s"
});

const METRO_RADIUS = 3.8;

metroInfos <- [
    [ -555.353, 1605.74, -20.6639,           "Dipton",       4, "down", -532.406, 1605.85, -16.6 ],
    [ -293.068512,  553.138000,  -2.273677,  "Uptown",      40, "up",   null, null, null ],
    [  234.378662,  396.031830,  -9.407516,  "Chinatown",   15, "up",   259.013, 395.816, -21.6287 ],
    [ -98.685043,   -481.715393, -8.921828,  "Southport",   15, "up",   -98.6563, -498.904, -15.7404 ],
    [ -498.224, 21.5297, -4.50967,           "West Side",    4, "down", -498.266, -2.04015, -0.539263 ],
    [ -1550.738159, -231.029968, -13.589154, "Sand Island", 15, "up",   -1550.59, -213.811, -20.3354 ],
    [ -1117.73, 1363.49, -17.5724,           "Kingston",     4, "down", -1141.32, 1363.65, -13.5724 ]
];

const METRO_HEAD = 0;
const METRO_TAIL = 6; // total number of stations-1

event("onServerStarted", function() {
    log("[metro] loading metro stations...");
    //creating public 3dtext
    foreach (station in metroInfos) {
        create3DText ( station[0], station[1], station[2]+0.35, "=== " + station[3].toupper() + " SUBWAY STATION ===", CL_EUCALYPTUS, station[4] );
        create3DText ( station[0], station[1], station[2]+0.20, "/subway", CL_WHITE.applyAlpha(150), METRO_RADIUS );

        if(station[6]) {
            create3DText ( station[6], station[7], station[8]+0.35, "Go "+station[5]+" to enter the subway", CL_EUCALYPTUS, 30 );
        }
    }
});


function isNearStation(playerid) {
    foreach (key, station in metroInfos) {
        if ( isInRadius(playerid, station[0], station[1], station[2], METRO_RADIUS) ) {
            return (true) ? key : "faraway";
        }
    }
    return "faraway";
}

function metroGo( playerid, id = null ) {
    if (id == null) {
        return metroShowListStations(playerid);
    }

    local id = id.tointeger();
    //if (id < METRO_HEAD) {  id = METRO_HEAD;  }
    //if (id > METRO_TAIL) {  id = METRO_TAIL;  }

    id -= 1; //for correct

    local ticketCost = 0.25;
    local isNear = isNearStation( playerid );

    if ( isNear == "faraway") {
        return msg(playerid, "metro.toofaraway", CL_RED);
    }

    if( isPlayerInVehicle( playerid ) ) {
        return msg(playerid, "metro.nocar", CL_RED);
    }

    if ( isNumeric(isNear) ) {

        if (id < METRO_HEAD || id > METRO_TAIL) {
            return msg(playerid, "metro.notexist", CL_RED);
        }

        if ( id == isNear ) {
            return msg(playerid, "metro.herealready", CL_RED);
        }

        if ( !canMoneyBeSubstracted(playerid, ticketCost) ) {
            return msg(playerid, "metro.notenoughmoney", CL_RED);
        }
        togglePlayerControls( playerid, true );
        screenFadeinFadeout(playerid, 500, function() {
            subMoneyToPlayer(playerid, ticketCost); // don't forget took money for ticket ~ 25 cents
            msg(playerid, "metro.pay", ticketCost );
            msg(playerid, "metro.arrived", metroInfos[id][3]);
            setPlayerPosition(playerid, metroInfos[id][0], metroInfos[id][1], metroInfos[id][2]);
        }, function() {
            togglePlayerControls( playerid, false );
        });
    }
}


function metroShowListStations ( playerid ) {
    msg(playerid, "==================================", CL_HELP_LINE);
    msg(playerid, "metro.listStations.title", CL_HELP_TITLE);
    foreach (index, station in metroInfos) {
        msg(playerid, "metro.listStations.station", [(index+1), station[3]], CL_WHITE);
    }
}
