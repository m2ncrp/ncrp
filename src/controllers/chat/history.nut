//чат
addEventHandler("onPlayerChat", function(playerid, text) {
    if (logged[playerid] == 0 || arrest[playerid] != 0) {
        return;
    } else if (text.len() > max_text_len) {
        sendMessage(
            playerid,
            "[ERROR] Максимальная длина сообщения " +
                max_text_len +
                " символов",
            red
        );
        return;
    }

    local count = 0;
    local say =
        "(Всем OOC) " +
        getPlayerName(playerid) +
        " [" +
        playerid +
        "]: " +
        text;
    local say_10_r =
        "(Ближний IC) " +
        getPlayerName(playerid) +
        " [" +
        playerid +
        "]: " +
        text;

    foreach(i, playername in getPlayers());
    {
        local myPos = getPlayerPosition(playerid);
        local Pos = getPlayerPosition(i);

        if (
            logged[i] == 1 &&
            isPointInCircle3D(
                myPos[0],
                myPos[1],
                myPos[2],
                Pos[0],
                Pos[1],
                Pos[2],
                me_radius
            ) &&
            i != playerid
        ) {
            count = count + 1;
        }
    }

    if (count == 0) {
        sendMessageAll(playerid, say, gray);

        print("[CHAT] " + say);
    } else {
        ic_chat(playerid, say_10_r);
        print("[CHAT] " + say_10_r);
    }
});

addEventHandler("up_chat", function(playerid) {
    local count = 5;

    if (min_chat[playerid] - count < 0) {
        return;
    }

    max_chat[playerid] -= count;
    min_chat[playerid] -= count;

    for (local i = min_chat[playerid]; i < max_chat[playerid]; i++) {
        sendMessage_log(
            playerid,
            message[playerid][i][0],
            message[playerid][i][1],
            message[playerid][i][2],
            message[playerid][i][3]
        );
    }
});

addEventHandler("down_chat", function(playerid) {
    local count = 5;

    if (max_chat[playerid] + count > message[playerid].len()) {
        return;
    }

    max_chat[playerid] += count;
    min_chat[playerid] += count;

    for (local i = min_chat[playerid]; i < max_chat[playerid]; i++) {
        sendMessage_log(
            playerid,
            message[playerid][i][0],
            message[playerid][i][1],
            message[playerid][i][2],
            message[playerid][i][3]
        );
    }
});
