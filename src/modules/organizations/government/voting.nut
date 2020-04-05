local candidates = {
    "1": "Donny Fennicello"
    "2": "Antonio Marchini"
}

function candidatesList(playerid) {
    for (local i = 1; i <= candidates.len(); i++) {
        msg(playerid, format("#%d %s: /vote %d", i, candidates[i.tostring()], i));
    }
}

cmd("vote", function( playerid, candidate = "0" ) {

    if (!isPlayerInValidPoint(playerid, getGovCoords(0), getGovCoords(1), 5.0 )) {
        return msg(playerid, "Проголосовать можно только в здании администрации", CL_THUNDERBIRD);
    }

    candidate = candidate.tointeger()

    if (candidate == 0) {
        msg(playerid, "Выборы мэра города "+getYear()+":", CL_CRUSTA);
        msg(playerid, "=======================================", CL_CRUSTA);
        msg(playerid, "Рассылка просьб проголосовать в любые чаты и личные сообщения (pm) как здесь, так и в Discord, запрещена. При выявлении нарушения - штраф $1000 (при отсутствии денег баланс уйдёт в минус).");
        msg(playerid, "=======================================", CL_CRUSTA);
        msg(playerid, "Кандидаты:");
        candidatesList(playerid);
        return;
    }

    local timestamp = getTimestamp();

    if(timestamp < 1586239200) {
        return msg(playerid, "Голосование не началось! Старт в 09:00 по Москве", CL_THUNDERBIRD);
    }

    if(timestamp > 1586451600) {
        return msg(playerid, "Голосование уже завершено!", CL_THUNDERBIRD);
    }

    local votingName = "voting"+getYear();

    if (votingName in players[playerid].data) {
        return msg(playerid, "Вы уже голосовали!", CL_THUNDERBIRD);
    }

    if (candidate != 1 && candidate != 2) {
        msg(playerid, "Проголосуйте за кандидата из списка:", CL_CRUSTA);
        candidatesList(playerid);
        return;
    }

    local name = candidates[candidate.tostring()];

    players[playerid].setData(votingName, name);
    players[playerid].save();

    msg(playerid, "Ваш голос за "+name+" принят.", CL_SUCCESS);

});
