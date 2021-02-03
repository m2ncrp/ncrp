/*
1. Команда /discord на сервере создаёт уникальный id из 4 цифр, записывает его в хранилище, рядом проставляет временную метку now + 10 минут и полное имя игрока.
Этот уникальный id отображается игроку в чате.
2. Игрок запоминает id и идёт в канал доступ-к-каналам. Из игры можно выйти. Пишет туда код. Код считывается. Сообщение сразу удаляется.
Выполняется проверка на наличие кода в хранилище.
Если код существует, то игроку задаётся никнейм, равный полному имени игрока. Код удаляется из хранилища.
Выдаётся роль участника.

*/

local codes = {};
local charIds = {};

function isExpired(time) {
    local now = getTimestamp();
    return now >= time;
}

nnListen(function(sourceData) {
    local data = JSONParser.parse(sourceData);

    if(!(type in data)) return;
    if(data.type != "discord-member-code-remove") return;

    local code = data.code;

    if (code in codes) {
        clearDiscordCode(code);
    }
});

event("onServerMinuteChange", function() {
    if(getMinute() % 2 == 1) {
        foreach(idx, code in codes) {
            if (isExpired(code.expired)) clearDiscordCode(idx);
        }
    }
});

function getRandomDiscordCode(charId, name) {

    // memo
    if(charId in charIds) {
        return charIds[charId];
    }

    // generate code
    local code = format("%04d", random(0, 9999));

    // if exists - regenerate
    if (code in codes) {
        return getRandomDiscordCode(charId, name);
    }

    local exp = getTimestamp() + 600;

    // register code
    codes[code] <- {
        id = charId,
        name = name,
        expired = exp
    };

    charIds[charId] <- code;

    nano({
        "path": "discord-member",
        "name": name,
        "code": code,
        "expired": exp.tostring()
    })

    return code;
}

function clearDiscordCode(code) {
    if (code in codes) {
        delete charIds[codes[code].id];
        delete codes[code];
        // dbg(format("delete %s", code));
        return true;
    }

    return false;
}

cmd("discord", function (playerid) {
    local charName = getPlayerName(playerid);
    local charId = getCharacterIdFromPlayerId(playerid);
    local code = getRandomDiscordCode(charId, charName);

    msg(playerid, format("Ваш код: %s", code));
    msg(playerid, "Перейдите в Discord на сервер NCRP в канал #ввод-кода и следуйте инструкциям.", CL_LIGHTGRAY);
    msg(playerid, "Код действителен в течение 10 минут.", CL_CASCADE);
});

// function tt() {
//     local charName = "Fern2";
//     local charId = 2;
//     local code = getRandomDiscordCode(charId, charName);
//     dbg(format("Your code: %s", code))
// }