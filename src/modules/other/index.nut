local privateZonePlayersAccess = {};

local ENTER_PASSWORD_TIMEOUT = 5;

event("onServerStarted", function() {
    //createPlace("PrivateLocation1", -232.905, -423.552, -201.029, -410.348);
    createPlace("PrivateLocation2", -1313.16, 220.903, -1284.03, 257.316);
});

alternativeTranslate({
    "en|privatezone.hello"  : "Security: This is a private area. Say the password."
    "ru|privatezone.hello"  : "Охранник: Это частная территория. Пароль?"

    "en|privatezone.welcome"  : "Security: Welcome, %s %s!"
    "ru|privatezone.welcome"  : "Охранник: Добро пожаловать, %s %s!"

    "en|privatezone.goodbuy"  : "Security: Goodbuy, %s %s!"
    "ru|privatezone.goodbuy"  : "Охранник: До свидания, %s %s!"

    "en|privatezone.getout"   : "Security: Get out of here right now!"
    "ru|privatezone.getout"   : "Охранник: Убирайся отсюда сейчас же!"


    "en|Mr"  : "Mr."
    "ru|Mr"  : "мистер"

    "en|Mrs"  : "Mrs."
    "ru|Mrs"  : "миссис"

});

function privateZoneHello(playerid, direction) {
    local sexWord;
    local directionWord;
    if(players[playerid].sex == 0) {
        sexWord = "Mr";
    } else {
        sexWord = "Mrs";
    }
    if(direction == "enter") {
        directionWord = "privatezone.welcome";
    } else {
        directionWord = "privatezone.goodbuy";
    }

    sexWord = plocalize(playerid, sexWord);

    msg(playerid, directionWord, [sexWord, players[playerid].lastname], CL_GOSSIP);

}

event("onPlayerPlaceEnter", function(playerid, name) {
    if (/*name == "PrivateLocation1" ||*/ name == "PrivateLocation2") {

            local charId = getCharacterIdFromPlayerId(playerid);
            if ( !(charId in privateZonePlayersAccess) ) {
                privateZonePlayersAccess[charId] <- {};
                privateZonePlayersAccess[charId]["access"] <- false;
                privateZonePlayersAccess[charId]["status"] <- "outside";
            } else {
                if ( privateZonePlayersAccess[charId]["access"] == true ) {
                    privateZoneHello(playerid, "enter");
                    privateZonePlayersAccess[charId]["status"] = "inside";
                    return;
                }
            }

            msg(playerid, "privatezone.hello", CL_ERROR);
            privateZonePlayersAccess[charId]["status"] <- "enterpassword";

            freezePlayer(playerid, true);
            trigger(playerid, "hudCreateTimer", ENTER_PASSWORD_TIMEOUT, true, true);
            local validPassword = false;

            if(isPlayerInVehicle(playerid)) {
                local vehicleid = getPlayerVehicle(playerid);
                local vehSpeed = getVehicleSpeed(vehicleid);
                local vehPos = getVehiclePosition(vehicleid);
                //local vehSpeedNew = [];
                //if (vehSpeed[0] <= 0) vehSpeed[0] = (vehSpeed[0] - 1) * -1;
                //if (vehSpeed[1] >= 0) vehSpeed[1] = (vehSpeed[1] + 1) * -1;
                //setVehicleSpeed(vehicleid, vehSpeed[0], vehSpeed[1], vehSpeed[2]);
                setVehicleEngineState(vehicleid, false);
                setVehicleSpeed(vehicleid, 0.0, -1.0, 0.0);
                delayedFunction(500, function() {
                    setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
                });
            }

            delayedFunction(ENTER_PASSWORD_TIMEOUT*1000, function() {
                if (validPassword == false) {
                    setPlayerPosition(playerid, -1300.0, 218.903, -23.589);
                    freezePlayer(playerid, false);
                    if(isPlayerInVehicle(playerid)) {
                        local vehicleid = getPlayerVehicle(playerid);
                        setVehicleSpeed(vehicleid, 0.0, -7.0, 0.0);
                    }
                    privateZonePlayersAccess[charId]["status"] <- "outside";
                    msg(playerid, "privatezone.getout", CL_ERROR);
                }
            });


            requestUserInput(playerid, function(playerid, text) {
                trigger(playerid, "hudDestroyTimer");
                if (text.tolower() != "123") {
                    //"[-1302.49,218.661,-23.5872]"
                    setPlayerPosition(playerid, -1300.0, 220.903, -23.589);
                    if(isPlayerInVehicle(playerid)) {
                        local vehicleid = getPlayerVehicle(playerid);
                        setVehicleSpeed(vehicleid, 0.0, -7.0, 0.0);
                    }
                    freezePlayer(playerid, false);
                    privateZonePlayersAccess[charId]["status"] <- "outside";
                    msg(playerid, "privatezone.getout", CL_ERROR);
                    return;
                }
                validPassword = true;
                freezePlayer(playerid, false);
                privateZoneHello(playerid, "enter");
                privateZonePlayersAccess[charId]["status"] = "inside";
                privateZonePlayersAccess[charId]["access"] = true;
            }, ENTER_PASSWORD_TIMEOUT*1000);
    }
});

event("onPlayerPlaceExit", function(playerid, name) {
    if (/*name == "PrivateLocation1" || */name == "PrivateLocation2") {
        local charId = getCharacterIdFromPlayerId(playerid);
        if ( privateZonePlayersAccess[charId]["access"] == true) {
            privateZoneHello(playerid, "leave");
            privateZonePlayersAccess[charId]["status"] = "outside";
            return;
        }
    }
});


event("onServerHourChange", function() {
    foreach (index, playerAccess in privateZonePlayersAccess) {
        if(playerAccess["status"] != "inside") {
            playerAccess["access"] <- false;
        }
    }
});
