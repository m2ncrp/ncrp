/*1. биография + статус verified
2. 10 наигранных часов
3. 250 баксов гос.пошлина*/

/* ============================================================================================ */

function ltcHelp( playerid ) {
    local title = "ltc.help.title";
    local commands = [
        { name = "ltc.help.ltc",    desc = "ltc.help.desc" }
    ];
    msg_help(playerid, title, commands);
}


cmd("ltc", function( playerid, parametr = 0 ) {

    if (parametr != "get") {
        return ltcHelp( playerid );
    }

    if (!isPlayerInValidPoint(playerid, getGovCoords(0), getGovCoords(1), 1.5 )) {
        return msg(playerid, "ltc.toofar", CL_THUNDERBIRD);
    }

    if ("ltc" in players[playerid].data) {

        local status = players[playerid].data.ltc.tostring();

        // лицензия на оружие уже была получена
        if (status == "blocked") {
            return msg(playerid, "ltc.blocked", CL_THUNDERBIRD);
        }

        // лицензия на оружие уже была получена
        if (status == "true") {
            return msg(playerid, "ltc.alreadyget", CL_THUNDERBIRD);
        }

        // чтобы можно было получить новую лицензи по окончанию срока
        if (status == "false" || status == "needsolution") {
            players[playerid].setData("ltc", "needsolution");
            return msg(playerid, "ltc.needsolution", CL_THUNDERBIRD);
        }

        // отказано в получении
        if (status == "rejected") {
            return msg(playerid, "ltc.rejected", CL_THUNDERBIRD);
        }

    } else {
        // первое получение лицензии на оружие - оформляем запрос
        players[playerid].setData("ltc", "needsolution");
        return msg(playerid, "ltc.needsolution", CL_THUNDERBIRD);
    }

    local isVerified = ("verified" in players[playerid].data) ? players[playerid].data.verified : false;

    if (players[playerid].xp < 900) {
               msg(playerid, "ltc.countdown", CL_THUNDERBIRD);
        return msg(playerid, "ltc.countdown.hint", [ 900 - players[playerid].xp ], CL_GRAY);
    }

    if (!isVerified) {
               msg(playerid, "ltc.verified", CL_THUNDERBIRD);
        return msg(playerid, "ltc.verified.hint", CL_GRAY);
    }

    if (!canMoneyBeSubstracted(playerid, 250.0)) {
        return msg(playerid, "ltc.notenough", CL_THUNDERBIRD);
    }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local ltcObj = Item.LTC();
    if (!players[playerid].inventory.isFreeWeight(ltcObj)) {
        return msg(playerid, "inventory.weight.notenough", CL_THUNDERBIRD);
    }

    subMoneyToPlayer(playerid, 250.0);

    ltcObj.setData("number", playerid);
    ltcObj.setData("fio", getPlayerName(playerid));

    msg(playerid, "ltc.got", CL_SUCCESS);

    local day   = getDay();
    local month = getMonth();
    local year  = getYear() + 1;
    if (day < 10) { day = "0"+day; }
    if (month < 10) { month = "0"+month; }
    ltcObj.setData("issued",  getDate());
    ltcObj.setData("expires", day+"."+month+"."+year);

    players[playerid].inventory.push( ltcObj );
    ltcObj.save();
    players[playerid].inventory.sync();

    players[playerid].setData("ltc", true);
    players[playerid].save();
});


fmd("gov", ["gov.ltc"], "$f ltc", function(fraction, character, result, targetid = null) {

    if (!isPlayerInValidPoint(character.playerid, getGovCoords(0), getGovCoords(1), 3.0 )) {
        return msg(character.playerid, "ltc.toofar", CL_THUNDERBIRD);
    }

    targetid = toInteger(targetid);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(character.playerid, "admin.error", CL_ERROR);
    }

    if(players[targetid].getData("ltc") == "blocked") {
        return msg(character.playerid, "ltc.solution.isblocked", CL_ERROR);
    }

    switch(result) {
        case "approved":
            players[targetid].setData("ltc", "approved");
            msg(character.playerid, "ltc.solution.approved", CL_EUCALYPTUS);
        break;
        case "rejected":
            players[targetid].setData("ltc", "rejected");
            msg(character.playerid, "ltc.solution.rejected", CL_THUNDERBIRD);
        break;
        default:
            msg(character.playerid, "ltc.solution.invalid", CL_ERROR);
    }
});

mcmd(["dev.ltc.manage"], "ltc", "manage", function(playerid, result, targetid = null) {

    targetid = toInteger(targetid);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(playerid, "admin.error", CL_ERROR);
    }

    switch(result) {
        case "block":
            players[targetid].setData("ltc", "blocked");
            msg(playerid, "ltc.solution.blocked", CL_EUCALYPTUS);
        break;
        case "unblock":
            players[targetid].setData("ltc", "false");
            msg(playerid, "ltc.solution.unblocked", CL_THUNDERBIRD);
        break;
        default:
            msg(playerid, "ltc.solution.invalid", CL_ERROR);
    }
});


alternativeTranslate({

    "en|ltc.help.title"        : "LTC:"
    "ru|ltc.help.title"        : "Лицензия на оружие:"

    "en|ltc.help.ltc"          : "/ltc get"
    "ru|ltc.help.ltc"          : "/ltc get"

    "en|ltc.help.desc"         : "Get LTC"
    "ru|ltc.help.desc"         : "Получить лицензию на оружие"

    "en|ltc.toofar"            : "You can get LTC at city government."
    "ru|ltc.toofar"            : "Получить лицензию на оружие можно в мэрии города."

    "en|ltc.alreadyget"        : "You have a LTC already."
    "ru|ltc.alreadyget"        : "Вы уже получали лицензию на оружие."

    "en|ltc.blocked"           : "You are not available to get a LTC."
    "ru|ltc.blocked"           : "Вам недоступно получение лицензии на оружие."

    "en|ltc.rejected"          : "Your LTC request has been denied."
    "ru|ltc.rejected"          : "Вам отказано в получении лицензии на оружие."

    "en|ltc.needsolution"      : "Contact the government official (not NPC) for getting a LTC."
    "ru|ltc.needsolution"      : "Для получения лицензии на оружие обратитесь к сотруднику мэрии (реальному живому игроку)."

    "en|ltc.countdown"         : "The length of your stay in Empire Bay is insufficient to get a LTC."
    "ru|ltc.countdown"         : "Срок вашего пребывания в Empire Bay недостаточен для получения лицензии на оружие."

    "en|ltc.countdown.hint"    : "You need to spend another %d minutes on the server."
    "ru|ltc.countdown.hint"    : "Вам необходимо провести на сервере ещё %d мин."

    "en|ltc.verified"          : "Your stay status in Empire Bay is not verified."
    "ru|ltc.verified"          : "Ваш статус пребывания в Empire Bay не подтверждён."

    "en|ltc.verified.hint"     : "You need write biography of your character to get the Verified status."
    "ru|ltc.verified.hint"     : "Необходимо написать биографию персонажа, чтобы получить статус Verified."

    "en|ltc.notenough"         : "You don't have enough money. Need $250"
    "ru|ltc.notenough"         : "Недостаточно денег. Для оформления лицензии нужно $250"

    "en|ltc.solution.invalid"  : "Invalid status."
    "ru|ltc.solution.invalid"  : "Статус указан неверно."

    "en|ltc.solution.approved" : "You have approved the request for getting a LTC."
    "ru|ltc.solution.approved" : "Вы одобрили заявку на получение лицензии на оружие."

    "en|ltc.solution.rejected" : "You have rejected/approved the request for getting a LTC."
    "ru|ltc.solution.rejected" : "Вы отклонили заявку на получение лицензии на оружие."

    "en|ltc.solution.isblocked"  : "You can't change the status of a LTC for a specified player."
    "ru|ltc.solution.isblocked"  : "Вы не можете изменить статус получения лицензии на оружие для указанного игрока."

    "en|ltc.solution.blocked"    : "You have blocked the request for getting a LTC for %s"
    "ru|ltc.solution.blocked"    : "Вы заблокировали получение LTC для %s."

    "en|ltc.solution.unblocked"  : "You have unblocked the request for getting a LTC for %s"
    "ru|ltc.solution.unblocked"  : "Вы разблокировали получение LTC для %s."

    "en|ltc.got"               : "You got the LTC."
    "ru|ltc.got"               : "Вы получили лицензию на оружие."

    "en|ltc.info.title"        : "LTC:"
    "ru|ltc.info.title"        : "Лицензия на оружие:"

    "en|ltc.info.fio"          : "Firstname Lastname: %s"
    "ru|ltc.info.fio"          : "Имя Фамилия: %s"

    "en|ltc.info.number"       : "Serial number: %s"
    "ru|ltc.info.number"       : "Серийный номер: %s"

    "en|ltc.info.issued"       : "Date of issue: %s"
    "ru|ltc.info.issued"       : "Дата выдачи: %s"

    "en|ltc.info.expires"      : "Date of expiration: %s"
    "ru|ltc.info.expires"      : "Истекает: %s"
});
