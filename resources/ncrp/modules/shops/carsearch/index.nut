event("onServerStarted", function() {
    log("[shops] loading car searching services...");
});

translate("en", {
    "shops.findcar.hello"  : "[CALL] Empire Bay Car Searching Services. We can find all your cars. It's cost $%.2f from bank account."
    "shops.findcar.wait"   : "Searching... Please, wait..."
    "shops.findcar.found"  : "[CALL] We found all your cars. Thanks for choosing Empire Bay Car Searching Services."
    "shops.findcar.seemap" : "All your cars are shown on the map in 90 seconds."
    "shops.findcar.nomoney" : "[CALL] Sorry, you don't have enough money in bank account. Good bye."
});

const FINDCAR_COST = 49.90;

event("onPlayerPhoneCall", function(playerid, number, place) {
    if(number == "0000") {
        msg(playerid, "shops.findcar.hello", FINDCAR_COST, TELEPHONE_TEXT_COLOR);

        delayedFunction(5000, function() {
            if(!canBankMoneyBeSubstracted(playerid, FINDCAR_COST)) {
                return msg(playerid, "shops.findcar.nomoney", TELEPHONE_TEXT_COLOR);
            }

            msg(playerid, "shops.findcar.wait");
            subBankMoneyToPlayer(playerid, FINDCAR_COST);

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

        });
    }
});
