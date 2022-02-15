const NICKNAME_CHANGE_PRICE = 30.00;
local NICKNAME_CHANGE_COORD = {
    "x": -566.434,
    "y": 1632.95,
    "z": -15.6957
};

event("onServerPlayerStarted", function(playerid) {
    createPrivate3DText(playerid, NICKNAME_CHANGE_COORD.x, NICKNAME_CHANGE_COORD.y, NICKNAME_CHANGE_COORD.z+0.35, plocalize(playerid,"nickname.change.pickup"), CL_RIPELEMON, 5.0);
    createPrivate3DText(playerid, NICKNAME_CHANGE_COORD.x, NICKNAME_CHANGE_COORD.y, NICKNAME_CHANGE_COORD.z+0.20, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(150), 2.0);
});

key("e", function(playerid) {
    if (isInRadius(playerid, NICKNAME_CHANGE_COORD.x, NICKNAME_CHANGE_COORD.y, NICKNAME_CHANGE_COORD.z, 2.0)) {
        if (!canChangeName(playerid)) return msg(playerid, "nickname.change.unavailable", CL_ERROR);
        triggerClientEvent(playerid, "nicknameChange", playerid, NICKNAME_CHANGE_PRICE, getPlayerLocale(playerid));
    };
}, KEY_UP);

event("onGenerateNickname", function (playerid, name) {
    local char = players[playerid];
    if (name == "first"){
        local firstname = getRandomFirstname(char.sex, char.nationality);
        triggerClientEvent(playerid, "onChangeRandomFirstname", firstname);
    } else if (name == "last") {
        local lastname = getRandomLastname(char.nationality);
        triggerClientEvent(playerid, "onChangeRandomLastname", lastname);
    }
});

event("onChangeNickname", function (playerid, firstname, lastname, valid) {
    if (!valid) return msg(playerid, "nickname.change.incorrect", CL_ERROR);
    if (!canMoneyBeSubstracted(playerid, NICKNAME_CHANGE_PRICE)) return msg(playerid, "nickname.change.notenoughmoney", CL_ERROR);
    if (!canChangeName(playerid)) return msg(playerid, "nickname.change.unavailable", CL_ERROR);
    players[playerid].firstname = firstname;
    players[playerid].lastname = lastname;
    subPlayerMoney(playerid, NICKNAME_CHANGE_PRICE);
    return msg(playerid, "nickname.change.success", format("%s %s", firstname, lastname), CL_SUCCESS);
});

function canChangeName(playerid) {
    local charid = getCharacterIdFromPlayerId(playerid);
    local request = getPassportRequestByCharid(charid);
    if (request != false) {
        if (request.status != "rejected"){
            return false
        }
    }
    return true;
};


alternativeTranslate({
    "en|nickname.change.pickup"        : "CHANGE NICKNAME"
    "ru|nickname.change.pickup"        : "СМЕНА ИМЕНИ"

    "en|nickname.change.unavailable"   : "You can't change your nickname right now"
    "ru|nickname.change.unavailable"   : "Вы не можете изменить имя в данный момент"

    "en|nickname.change.incorrect"   : "Incorrect Name"
    "ru|nickname.change.incorrect"   : "Некорректное имя или фамилия"

    "en|nickname.change.notenoughmoney" : "You don't have enough money"
    "ru|nickname.change.notenoughmoney" : "У вас недостаточно денег"

    "en|nickname.change.success"   : "You successfully change your name to %s"
    "ru|nickname.change.success"   : "Вы успешно сменили имя на %s"
});

