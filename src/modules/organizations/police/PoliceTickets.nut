// /ticket <id or plate> <reason-id>
cmd(["ticket"], function(playerid, target = null) {
    policeGiveTicket(playerid, target);
});

local timers = {};

POLICE_TICKET_PRICELIST <- [
    [ 5.0,  "Пешее движение по проезжей части"],
    [ 8.0, "Непропуск пешехода"],
    [ 10.0, "Неиспользование поворотников"],
    [ 15.0, "Превышение скорости"],
    [ 20.0, "Создание препятствий для движения"],
    [ 40.0, "Выезд на полосу встречного движения"],
    [ 10.0, "Проезд знака STOP без остановки"],
    [ 40.0, "Проезд знака DO NOT ENTER"],
    [ 30.0, "Движение за пределами проезжей части"],
    [ 15.0, "Игнорирование требования остановки"],
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

                if (!canMoneyBeSubstracted(targetid, price)) {
                    dbg("ncrp", "console", format("У нарушителя **%s** недостаточно денег для оплаты штрафа за %s ($%.2f)", getPlayerName(targetid), reasonText, price) );
                    return msg(playerid, "organizations.police.ticket.targetnomoney", CL_ERROR);
                }

                msg(targetid, "organizations.police.ticket.givewithreason", [getAuthor(playerid), target_reason, price], CL_CHESTNUT);
                msg(playerid, "organizations.police.ticket.given", [getAuthor(targetid), player_reason, price], CL_CHESTNUT);
                subMoneyToPlayer(targetid, price);
                nano({
                    "path": "discord",
                    "server": "police",
                    "channel": "tickets",
                    "author": getPlayerName(playerid),
                    "title": getKnownCharacterName(playerid, targetid),
                    "description": "Получил штраф",
                    "color": "blue",
                    "datetime": getDateTime(),
                    "fields": [
                        ["Нарушение", reasonText],
                        ["Сумма", format("$ %.2f", price)]
                    ]
                });

                addTreasuryMoney(price);
                return;
            }

            return msg(playerid, "organizations.police.ticket.cancel", CL_INFO);

        }, 60);

    } else {
        return msg(playerid, "organizations.police.offduty.notickets");
    }
}