// /ticket <id or plate> <reason-id>
cmd(["ticket"], function(playerid, target = null) {
    policeGiveTicket(playerid, target);
});

/**
 * Return true if parameter length less than 4 symbols that mean it's player ID
 * Return false if length more than 4 symbols that mean it's plate number
 * @param  {string}  parameter  player ID or plate number
 * @return {Boolean}            is it player ID
 */
function isValueId(value) {
    return ( value.len() < 4 );
}

local timers = {};

POLICE_TICKET_PRICELIST <- [
    [ 7.0,  "Пешее движение по проезжей части"],
    [ 10.0, "Непропуск пешехода"],
    [ 15.0, "Неиспользование поворотников"],
    [ 25.0, "Превышение скорости"],
    [ 30.0, "Создание препятствий для движения"],
    [ 40.0, "Выезд на полосу встречного движения"],
    [ 20.0, "Проезд знака STOP без остановки"],
    [ 45.0, "Проезд знака DO NOT ENTER"],
    [ 45.0, "Движение за пределами проезжей части"],
    [ 25.0, "Игнорирование требования остановки"],
    [ 30.0, "Оскорбление сотрудника полиции"],

    //[17.0, "organizations.police.lawbreak.warning"          ],  // 0 - Предупреждение aka warning
    //[18.5, "organizations.police.lawbreak.trafficviolation" ],  // 1 - Нарушение ПДД aka traffic violation
    //[20.0, "organizations.police.lawbreak.roadaccident"      ]   // 2 - ДТП aka road acident
];

function policeGiveTicket(playerid, value) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.notanofficer");
    }

    if ( isOnPoliceDuty(playerid) ) {

        if(value == null) {
            return msg(playerid, "Формат: /ticket id", CL_ERROR)
        }

        local charId = getCharacterIdFromPlayerId(playerid);
        if ( ! (charId in timers) ) {
            timers[charId] <- null;
        }

        if (timers[charId] && timers[charId].IsActive()) {
            return;
        }

        msg(playerid, "organizations.police.ticket.list", CL_CHESTNUT2);

        local count = POLICE_TICKET_PRICELIST.len();

        for (local i = 0; i < count; i++) {
            msg(playerid, "  "+(i+1)+". "+ POLICE_TICKET_PRICELIST[i][1]);
        }

        msg(playerid, "organizations.police.ticket.neednumber", CL_GRAY);

        freezePlayer(playerid, true);

        trigger(playerid, "hudCreateTimer", 60, true, true);

        timers[charId] = delayedFunction(60*1000, function() {
            if (timers[charId].IsActive()) {
                msg(playerid, "organizations.police.ticket.cancel", CL_INFO);
                freezePlayer(playerid, false);
            }
        });

        requestUserInput(playerid, function(playerid, reason) {
            trigger(playerid, "hudDestroyTimer");
            freezePlayer(playerid, false);
            timers[charId].Kill();

            if ( !isNumeric(reason) ) {
                return msg(playerid, "organizations.police.ticket.cancel", CL_INFO);
            }

            local reason = reason.tointeger() - 1;

            if ( reason >= 0 && reason < count ) {

                local price      = POLICE_TICKET_PRICELIST[reason][0].tofloat();
                local reasonText = POLICE_TICKET_PRICELIST[reason][1];

                local player_reason = reasonText;
                local target_reason = reasonText;

                //local player_reason = plocalize(playerid, POLICE_TICKET_PRICELIST[reason][1]);
                //local target_reason = plocalize(targetid, POLICE_TICKET_PRICELIST[reason][1]);

                local targetid = value.tointeger();

                if ( playerid == targetid ) {
                    return msg(playerid, "organizations.police.cantgivetickethimself", CL_ERROR);
                }
                if ( !isPlayerConnected(targetid) ) {
                    return msg(playerid, "general.playeroffline", CL_ERROR);
                }

                if (!checkDistanceBtwTwoPlayersLess(playerid, targetid, POLICE_TICKET_DISTANCE)) {
                    return msg(playerid, "organizations.police.toofarfromoffender", CL_ERROR);
                }

                if (canMoneyBeSubstracted(targetid, price)) {
                    dbg("chat", "police", getAuthor(playerid), format("У нарушителя **%s** недостаточно денег для оплаты штрафа за %s ($%.2f)", getPlayerName(targetid), reasonText, price) );
                    return msg(playerid, "organizations.police.ticket.targetnomoney", CL_ERROR);
                }

                msg(targetid, "organizations.police.ticket.givewithreason", [getAuthor(playerid), target_reason, price], CL_CHESTNUT);
                msg(playerid, "organizations.police.ticket.given", [getAuthor(targetid), player_reason, price], CL_CHESTNUT);
                subMoneyToPlayer(targetid, price);
                dbg("chat", "police", getAuthor(playerid), format("Выписал штраф **%s** за %s ($%.2f)", getPlayerName(targetid), reasonText, price) );
                addMoneyToTreasury(price);
                return;
            }

            return msg(playerid, "organizations.police.ticket.cancel", CL_INFO);

        }, 60);

    } else {
        return msg(playerid, "organizations.police.offduty.notickets");
    }
}

/**
 ** deprecated or need to rewrite
 **
function getVehicleOwnerAndPinTicket(playerid, plateTxt, reason) {
    local reason = reason.tointeger();
    local price  = POLICE_TICKET_PRICELIST[reason][0].tofloat();
    local key    = POLICE_TICKET_PRICELIST[reason][1];
    local plates = getRegisteredVehiclePlates();
    local opos   = getPlayerPosition(playerid);

    if (plateTxt.len() < 6) {
        return msg(playerid, "Enter whole 6 letter plate number", CL_ERROR);
    }

    foreach (plate, vehicleid in plates) {
        if (plate.tolower().find(plateTxt.tolower()) != null) {
            local pos    = getVehiclePosition(vehicleid);
            if ( !checkDistanceXYZ(pos[0], pos[1], pos[2], opos[0], opos[1], opos[2], POLICE_TICKET_DISTANCE) ) {
                return msg(playerid, "Distance too large");
            }
            local owner = (getVehicleOwner(vehicleid) ? getVehicleOwner(vehicleid) : "");
            local player_reason = plocalize(playerid, key);

            msg(playerid, "organizations.police.ticket.given", [plateTxt, player_reason, price]);

            PoliceTicket( owner, key, price, "open", pos[0], pos[1], pos[2], getPlayerName(playerid))
                .save();
            return owner;
        }
    }
}
*/
