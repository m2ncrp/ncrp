/*
1. Команда /discord на сервере создаёт уникальный id из 4 цифр, записывает его в хранилище, рядом проставляет временную метку now + 10 минут и полное имя игрока.
Этот уникальный id отображается игроку в чате.
2. Игрок запоминает id и идёт в канал доступ-к-каналам. Из игры можно выйти. Пишет туда код. Код считывается. Сообщение сразу удаляется.
Выполняется проверка на наличие кода в хранилище.
Если код существует, то игроку задаётся никнейм, равный полному имени игрока. Код удаляется из хранилища.
Выдаётся роль участника.

*/

keys = {}

event("onServerMinuteChange", function() {
    if(getMinute() % 2 == 1) {
        local now = getTimestamp();
        foreach(idx, key in keys) {
            if (key.expired >= now) clearDiscordKey(idx);
        }
    }
});

function getRandomDiscordKey(name) {
    // generate key
    local key = format( "%04d", random(0, 9999) );

    // if exists - regenerate
    if (key in keys) {
        return getRandomDiscordKey();
    }


    // register key
    keys[key] <- {
        name = name,
        expired = getTimestamp() + 600
    };

    return key;
}

function clearDiscordKey(key) {
    if (key in keys) {
        delete keys[key];
        return true;
    }

    return false;
}

function tt() {
    dbg(getRandomDiscordKey("Fernando"));
}
