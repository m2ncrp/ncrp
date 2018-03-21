local autoticketscost = {
    "KosoyPereulok": 45.0
}

local ticketscost = {
    "speed": 35.0,      // Превышение скорости
    "parking": 30.0,    // Парковка в неположеном месте
    "tax": 20.0         // Неоплата налога
}


event("onPlayerPlaceEnter", function(playerid, name) {
    if(name != "KosoyPereulok" || !isPlayerInVehicle(playerid) || !isPlayerVehicleDriver(playerid) ) return;

    local cost = autoticketscost.KosoyPereulok;
    subMoneyToPlayer(playerid, cost);
    addMoneyToTreasury(cost);
    msg(playerid, "fractions.police.ticket.kosoypereulok", [cost], CL_THUNDERBIRD); return;
});


fmd("pd", ["pd.ticket"], "$f ticket", function(fraction, character, target) {

    if(!target) {
        return msg(character.playerid, "fractions.police.ticket.needtarget")
    }

    local targetid = target;
    if (target.len() == 6) {
        targetid = getVehicleByPlateText(target);
    }

    if (!isOriginalVehicleExists(targetid)) { return dbg("TODO: add support for NVEHICLE") }

    msg(playerid, "empirecustom.phone.enter");
    msg(playerid, "empirecustom.phone.help", AD_TIMEOUT, CL_GRAY);
    trigger(playerid, "hudCreateTimer", AD_TIMEOUT, true, true);
    local ad_sended = false;

    delayedFunction(AD_TIMEOUT*1000, function() {
        if (ad_sended == false) {
            msg(playerid, "empirecustom.phone.canceled", TELEPHONE_TEXT_COLOR);
        }
    });

    requestUserInput(playerid, function(playerid, text) {
        trigger(playerid, "hudDestroyTimer");
        if (text.tolower() == "отмена" || text.tolower() == "'отмена'" || text.tolower() == "нет" || text.tolower() == "'нет'" || text.tolower() == "cancel" || text.tolower() == "'cancel'" || text == "0") {
            ad_sended = "canceled";
            return msg(playerid, "empirecustom.phone.canceled", TELEPHONE_TEXT_COLOR);
        }

        msg(playerid, "empirecustom.phone.yourad", text, TELEPHONE_TEXT_COLOR);
        msg(playerid, "empirecustom.phone.placed", TELEPHONE_TEXT_COLOR);
        ad_sended = true;
        subMoneyToDeposit(playerid, AD_COST);
        addMoneyToTreasury(AD_COST);

        delayedFunction(60000, function() {
            trigger("onRadioMessageSend", text);
            //msg(playerid, "empirecustom.phone.ad", text, AD_COLOR);
        });
    }, AD_TIMEOUT);

    msg(character.playerid, "hey hostital member with 'heal' permission"+targetid);
});



function policeFindThatMotherfucker(playerid, IDorPLATE, reason) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.notanofficer");
    }

    if ( isOnPoliceDuty(playerid) ) {
        if ( isIdOrPlatenumber(IDorPLATE) ) {
            local targetid = IDorPLATE.tointeger();
            if ( playerid == targetid ) {
                return;
            }
            if ( !isPlayerConnected(targetid) ) {
                return msg(playerid, "general.playeroffline");
            }
            local reason    = reason.tointeger();
            local pos       = getPlayerPosition(targetid);
            local price     = POLICE_TICKET_PRICELIST[reason][0].tofloat();
            local player_reason = plocalize(playerid, POLICE_TICKET_PRICELIST[reason][1]);
            local target_reason = plocalize(targetid, POLICE_TICKET_PRICELIST[reason][1]);

            // if (checkDistanceBtwTwoPlayersLess(playerid, targetid, POLICE_TICKET_DISTANCE)) {
                msg(targetid, "organizations.police.ticket.givewithreason", [getAuthor(playerid), target_reason, price]);
                msg(playerid, "organizations.police.ticket.given", [getAuthor(targetid), player_reason, price]);
                subMoneyToPlayer(targetid, price);
                addMoneyToTreasury(price);
                // PoliceTicket( getPlayerName(targetid), POLICE_TICKET_PRICELIST[reason][1], price, "open", pos[0], pos[1], pos[2], getPlayerName(playerid))
                //     .save();
            // }
        } else {
            getVehicleOwnerAndPinTicket(playerid, IDorPLATE, reason);
        }
    } else {
        return msg(playerid, "organizations.police.offduty.notickets");
    }
}



event("onPlayerPhoneCall", function(playerid, number, place) {
    if(number == "1111") {

        msg(playerid, "empirecustom.phone.hello", AD_COST, TELEPHONE_TEXT_COLOR);

        if(!canBankMoneyBeSubstracted(playerid, AD_COST)) {
            return msg(playerid, "empirecustom.phone.notenough");
        }

        msg(playerid, "empirecustom.phone.enter");
        msg(playerid, "empirecustom.phone.help", AD_TIMEOUT, CL_GRAY);
        trigger(playerid, "hudCreateTimer", AD_TIMEOUT, true, true);
        local ad_sended = false;

        delayedFunction(AD_TIMEOUT*1000, function() {
            if (ad_sended == false) {
                msg(playerid, "empirecustom.phone.canceled", TELEPHONE_TEXT_COLOR);
            }
        });

        requestUserInput(playerid, function(playerid, text) {
            trigger(playerid, "hudDestroyTimer");
            if (text.tolower() == "отмена" || text.tolower() == "'отмена'" || text.tolower() == "нет" || text.tolower() == "'нет'" || text.tolower() == "cancel" || text.tolower() == "'cancel'" || text == "0") {
                ad_sended = "canceled";
                return msg(playerid, "empirecustom.phone.canceled", TELEPHONE_TEXT_COLOR);
            }

            msg(playerid, "empirecustom.phone.yourad", text, TELEPHONE_TEXT_COLOR);
            msg(playerid, "empirecustom.phone.placed", TELEPHONE_TEXT_COLOR);
            ad_sended = true;
            subMoneyToDeposit(playerid, AD_COST);
            addMoneyToTreasury(AD_COST);

            delayedFunction(60000, function() {
                trigger("onRadioMessageSend", text);
                //msg(playerid, "empirecustom.phone.ad", text, AD_COLOR);
            });
        }, AD_TIMEOUT);
    }

});


//fmd(["police"], ["police.ticket"], ["$f ticket"], function(fraction, character, targetId = -1) {
//    msg(character.playerid, "Test msg about police ticket "+targetId);
//});
