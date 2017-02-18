event("onServerStarted", function() {
    log("[shops] loading car searching services...");
});

translate("en", {
    "shops.findcar.hello"       : "[CALL] Empire Bay Car Searching Services. We can find all your cars. It's cost $%.2f from bank account."
    "shops.findcar.help"        : "To begin searching write 'yes' in chat for %d seconds."
    "shops.findcar.wait"        : "Searching... Please, wait..."
    "shops.findcar.found"       : "[CALL] We found all your cars. Thanks for choosing Empire Bay Car Searching Services. (hang up)"
    "shops.findcar.seemap"      : "All your cars are shown on the map in 90 seconds."
    "shops.findcar.notenough"   : "[CALL] Sorry, you don't have enough money in bank account. Good bye. (hang up)"
    "shops.findcar.canceled"    : "[CALL] If you want to find cars, call to us. Good luck! (hang up)"
});

local FINDCAR_COST = 29.90;
local FINDCAR_TIMEOUT = 30; // in seconds

event("onPlayerPhoneCall", function(playerid, number, place) {
    if(number == "0000") {

        msg(playerid, "shops.findcar.hello", FINDCAR_COST, TELEPHONE_TEXT_COLOR);

            if(!canBankMoneyBeSubstracted(playerid, FINDCAR_COST)) {
                return msg(playerid, "shops.findcar.nomoney", TELEPHONE_TEXT_COLOR);
            }

        msg(playerid, "shops.findcar.help", FINDCAR_TIMEOUT, CL_GRAY);
        trigger(playerid, "hudCreateTimer", FINDCAR_TIMEOUT, true, true);
        local findcar = false;

        delayedFunction(FINDCAR_TIMEOUT*1000, function() {
            if (findcar == false) {
                msg(playerid, "shops.findcar.canceled", TELEPHONE_TEXT_COLOR);
            }
        });

        requestUserInput(playerid, function(playerid, text) {
            trigger(playerid, "hudDestroyTimer");
            if (text.tolower() != "yes" && text.tolower() != "'yes'" && text.tolower() != "да" && text.tolower() != "'да'") {
                findcar = "canceled";
                return msg(playerid, "shops.findcar.canceled", TELEPHONE_TEXT_COLOR);
            }

            msg(playerid, "shops.findcar.wait");
            subBankMoneyToPlayer(playerid, FINDCAR_COST);
            findcar = true;
            delayedFunction(10000, function() {

                foreach (vehicleid, obj in __vehicles) {
                    if (isPlayerVehicleOwner(playerid, vehicleid)) {
                        local pos = getVehiclePositionObj(vehicleid);
                        local blip = createPrivateBlip(playerid, pos.x, pos.y, ICON_RED, 4000);
                        delayedFunction(90000, function() {
                            removeBlip(blip);
                        });
                    }
                }
                msg(playerid, "shops.findcar.found", TELEPHONE_TEXT_COLOR);
                msg(playerid, "shops.findcar.seemap");

            });
        }, FINDCAR_TIMEOUT);
    }
});
