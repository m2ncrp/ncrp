const NICKNAME_CHANGE_PRICE = 30.00;
local CHANGE_NICKNAME_X = -566.434
local CHANGE_NICKNAME_Y = 1632.95
local CHANGE_NICKNAME_Z = -15.6957

include("controllers/auth/data-names.nut");

event("onServerPlayerStarted", function(playerid) {
        createPrivate3DText(playerid, CHANGE_NICKNAME_X, CHANGE_NICKNAME_Y, CHANGE_NICKNAME_Z+0.35, plocalize(playerid,"nickname.change.pickup"), CL_RIPELEMON, 5.0);
        createPrivate3DText(playerid, CHANGE_NICKNAME_X, CHANGE_NICKNAME_Y, CHANGE_NICKNAME_Z+0.20, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(150), 2.0);
});

key("e", function(playerid) {
    if (isInRadius(playerid, CHANGE_NICKNAME_X, CHANGE_NICKNAME_Y, CHANGE_NICKNAME_Z, 2.0)) {
        if (!canChangeName(playerid)) return msg(playerid, "nickname.change.unavailable", CL_ERROR);
        triggerClientEvent(playerid, "nicknameChange", playerid, NICKNAME_CHANGE_PRICE);
    };
}, KEY_UP);

event("generateNickname", function (playerid, name) {
    local char = players[playerid];
    if (name == "first"){
        local firstname = getRandomFirstname(char.sex, char.nationality);
        triggerClientEvent(playerid, "onChangeRandomFirstname", firstname);
    } else if (name == "last") {
        local lastname = getRandomLastname(char.nationality);
        triggerClientEvent(playerid, "onChangeRandomLastname", lastname);
    }
});

event("changeNickname", function (playerid, firstname, lastname, valid) {
    if (!valid) return msg(playerid, "nickname.change.incorrect", CL_ERROR);
    if (getPlayerMoney(playerid) < NICKNAME_CHANGE_PRICE) return msg(playerid, "nickname.change.insufficient", CL_ERROR);
    if (canChangeName(playerid)) {
        players[playerid].firstname = firstname;
        players[playerid].lastname = lastname;
        subPlayerMoney(playerid, NICKNAME_CHANGE_PRICE);
        return msg(playerid, "nickname.change.success", format("%s %s", firstname, lastname), CL_SUCCESS);
    } else return msg(playerid, "nickname.change.unavailable", CL_ERROR);
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
    "ru|nickname.change.pickup"        : "СМЕНИТЬ ИМЯ"

    "en|nickname.change.unavailable"   : "You can't change your nickname right now"
    "ru|nickname.change.unavailable"   : "Вы не можете сменить свое имя в данный момент"

    "en|nickname.change.incorrect"   : "Incorrect Name"
    "ru|nickname.change.incorrect"   : "Некорректное имя или фамилия"

    "en|nickname.change.insufficient"   : "Insufficient funds"
    "ru|nickname.change.insufficient"   : "Недостаточно средств"

    "en|nickname.change.success"   : "You successfully change your name to %s"
    "ru|nickname.change.success"   : "Вы успешно сменили имя на %s"
});


