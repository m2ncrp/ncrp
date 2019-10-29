local handshakeBlackList = [
  "admin",
  "administrator",
  "dev",
  "developer",
  "fernando",
  "inlife",
  "justpilz",
  "moderator",
  "owner",
  "админ",
  "администратор",
  "блядь",
  "быдло",
  "выблядок",
  "гей",
  "дебил",
  "девелопер",
  "дурак",
  "ебанашка",
  "ебанутый",
  "модер",
  "модератор",
  "мудак",
  "мудила",
  "пидор",
  "пизда",
  "путин",
  "разработчик",
  "трамп",
  "ублюдок",
  "уебище",
  "уёбище",
  "уебок",
  "уёбок",
  "хер",
  "хохол",
  "хуесос",
  "хуй",
  "член",
  "чмо"
  "шлю",
];

/** Проверка на запрещённые слова */
function searchBadWord(str) {
    local lowerStr = str.tolower();
    local foundBlackWord = false;

    foreach(index, value in handshakeBlackList) {
        if(lowerStr.find(value) == null && value.find(lowerStr) == null) continue;
        foundBlackWord = true;
        break;
    }

    return foundBlackWord;
}

// сказать имя другому игроку
cmd(["shake", "handshake"], function(playerid, targetid, ...) {

    targetid = toInteger(targetid);
    local nickname = trim(concat(vargv));

    if(targetid == null || !isNumeric(targetid) || !nickname.len()) {
             msg(playerid, "handshake.shake.rule",  CL_THUNDERBIRD);
             msg(playerid, "handshake.shake.example", CL_LYNCH );
      return msg(playerid, "handshake.shake.real-name", CL_LYNCH );
    }

    // if(playerid == targetid) {
    //   return msg(playerid, "handshake.yourself");
    // }

    // if(!isPlayerConnected(targetid)) {
    //     return msg(playerid, "handshake.noplayer");
    // }

    // if(!checkDistanceBtwTwoPlayersLess(playerid, targetid, 3.0)) {
    //   return msg(playerid, "handshake.largedistance");
    // }

    // Если возможность рукопожатий запрещена для playerid
    if("handshake" in players[playerid].data && players[playerid].data.handshake == "off") {
        return msg(playerid, "handshake.prohibited");
    }

    // Если возможность рукопожатий запрещена для targetid
    if("handshake" in players[targetid].data && players[targetid].data.handshake == "off") {
        return msg(playerid, "handshake.prohibited.target");
    }

    /** Проверка на запрещённые слова */
    if(searchBadWord(nickname)) {
        players[playerid].setData("handshake", "off");
        dbg(format("Система знакомств для игрока с ID %d отключена за слово %s", playerid, nickname))
        return msg(playerid, "handshake.rules.break", CL_THUNDERBIRD);
    }
    /** // */

    local isAccept = false;

    delayedFunction(12000, function() {
        if (!isAccept) {
            sendLocalizedMsgToAll(targetid, "handshake.shake.decline", [], NORMAL_RADIUS, CL_CHAT_IC);
        }
    });

    sendLocalizedMsgToAll(playerid, "handshake.shake.request", [nickname], NORMAL_RADIUS, CL_CHAT_IC);
    msg(targetid, "handshake.shake.request-desc", CL_LYNCH);

    trigger(targetid, "hudCreateTimer", 12.0, true, true);

    local senderCharId = getCharacterIdFromPlayerId(playerid);

    local character = players[targetid];
    local receiverCharId = getCharacterIdFromPlayerId(targetid);

    local name = nickname == "me" ? getPlayerName(playerid) : nickname;

    requestUserInput(targetid, function(targetid, text) {
        trigger(targetid, "hudDestroyTimer");

        if (!text || trim(text) != "good") {
            return sendLocalizedMsgToAll(targetid, "handshake.shake.decline", [], NORMAL_RADIUS, CL_CHAT_IC);
        }

        isAccept = true;

        local handshake = Handshake();

        // персонаж-инициатор добавляет целевому персонажу запись о своём имени
        handshake.char = receiverCharId;
        handshake.target = senderCharId;
        handshake.text = name;
        handshake.save();

        character.handshakes[receiverCharId] <- handshake;

        sendLocalizedMsgToAll(targetid, "handshake.shake.complete", [name], NORMAL_RADIUS, CL_CHAT_IC);

    }, 12);

});

// записать/запомнить имя указанного игрока
cmd("remember", function(playerid, targetid, ...) {

    targetid = toInteger(targetid);
    local nickname = trim(concat(vargv));

    if(targetid == null || !isNumeric(targetid) || !nickname.len()) {
               msg(playerid, "handshake.remember.rule",  CL_THUNDERBIRD);
        return msg(playerid, "handshake.remember.example", CL_LYNCH );
    }

    // if(playerid == targetid) {
    //     return msg(playerid, "handshake.yourself");
    // }

    // if(!isPlayerConnected(targetid)) {
    //     return msg(playerid, "handshake.noplayer");
    // }

    // if(!checkDistanceBtwTwoPlayersLess(playerid, targetid, 30.0)) {
    //   return msg(playerid, "handshake.largedistance");
    // }

    // Если возможность рукопожатий запрещена для playerid
    if("handshake" in players[playerid].data && players[playerid].data.handshake == "off") {
        return msg(playerid, "handshake.prohibited");
    }

    /** Проверка на запрещённые слова */
    if(searchBadWord(nickname)) {
        players[playerid].setData("handshake", "off");
        dbg(format("Система знакомств для игрока с ID %d отключена за слово %s", playerid, nickname))
        return msg(playerid, "handshake.rules.break", CL_THUNDERBIRD);
    }
    /** // */

    local handshake = Handshake();

    local character = players[playerid];
    local charId = character.id;
    local targetCharId = getCharacterIdFromPlayerId(targetid);

    // персонаж запоминает у себя имя другого персонажа
    handshake.char = charId;
    handshake.target = targetCharId;
    handshake.text = nickname;
    handshake.save();

    character.handshakes[charId] <- handshake;
    msg(playerid, "handshake.remember.complete", [nickname], CL_SUCCESS);
});


// забыть имя указанного игрока
cmd("forget", function(playerid, targetid = null) {

    targetid = toInteger(targetid);

    if (targetid == null || !isNumeric(targetid)) {
               msg(playerid, "handshake.forget.rule", CL_THUNDERBIRD);
        return msg(playerid, "handshake.forget.example", CL_LYNCH );
    }

    // if (playerid == targetid) {
    //     return msg(playerid, "handshake.yourself");
    // }

    // if ( !isPlayerConnected(targetid) ) {
    //     return msg(playerid, "handshake.noplayer");
    // }

    // if (!checkDistanceBtwTwoPlayersLess(playerid, targetid, 30.0)) {
    //   return msg(playerid, "handshake.largedistance");
    // }

    // Если возможность рукопожатий запрещена для playerid
    if("handshake" in players[playerid].data && players[playerid].data.handshake == "off") {
        return msg(playerid, "handshake.prohibited");
    }

    local targetCharId = getCharacterIdFromPlayerId(targetid);

    if (!(targetCharId in players[playerid].handshakes)) {
        return msg(playerid, "handshake.forget.notexist", CL_THUNDERBIRD);
    }

    players[playerid].handshakes[targetCharId].remove();
    delete players[playerid].handshakes[targetCharId];

    return msg(playerid, "handshake.forget.complete", CL_SUCCESS);
});

function handshakeHelp(playerid) {
    local title = "handshake.title";
    local commands = [
        { name = "/handshake id имя",           desc = "Представиться вымышленным именем" },
        { name = "handshake.shake.example"                                                },
        { name = "/handshake id me",            desc = "Представиться настоящим именем"   },
        { name = "handshake.shake.real-name.example"                                      },
        { name = "/remember id имя",            desc = "Запомнить имя"                    },
        { name = "handshake.remember.example"                                              },
        { name = "/forget id",                  desc = "Забыть имя"                       },
        { name = "handshake.forget.example"                                                },
    ];
    msg_help_new(playerid, title, commands);
}

cmd("help", "handshake", handshakeHelp );

function handshakeRules(playerid) {
	  local title = "К запрещенным именам и псевдонимам относятся";
    local phrases = [
        "1) любые известные люди любых профессий и сфер деятельности (актеры, спортсмены, блоггеры и др. знаменитости);",
        "2) любые персонажи игр, фильмов, сериалов, тв-шоу;",
        "3) любые упоминания администрации сервера;",
        "4) титулы, должности, звания (император, король и т.д.);",
        "5) любые оскорбительные слова" ,
    ];

	  msg(playerid, "===========================================", CL_HELP_LINE);
    msg(playerid, title, CL_HELP_TITLE);

    foreach (idx, value in phrases) {
        local text = localize(value, [], getPlayerLocale(playerid));
        msg(playerid, text, CL_SILVERSAND);
    }
}

cmd("rules", "handshake", handshakeRules );

alternativeTranslate({

    "en|handshake.title"  : ""
    "ru|handshake.title"  : "Система знакомств"

    "en|handshake.shake.rule"  : ""
    "ru|handshake.shake.rule"  : "Чтобы представиться: /shake id имя"

    "en|handshake.shake.example"  : ""
    "ru|handshake.shake.example"  : "Например: /shake 7 Franz Ferdinand"

    "en|handshake.shake.real-name"  : ""
    "ru|handshake.shake.real-name"  : "Представиться настоящим именем: /shake id me"

    "en|handshake.shake.real-name.example"  : ""
    "ru|handshake.shake.real-name.example"  : "Например: /shake 5 me"

    "en|handshake.shake.request"  : ""
    "ru|handshake.shake.request"  : "Меня зовут %s"

    "en|handshake.shake.request-desc"  : ""
    "ru|handshake.shake.request-desc"  : "Напишите в чат good, чтобы запомнить это имя"

    "en|handshake.shake.decline"  : ""
    "ru|handshake.shake.decline"  : "Простите, ваше имя звучит странно для меня"

    "en|handshake.shake.complete"  : ""
    "ru|handshake.shake.complete"  : "Приятно познакомиться, %s"


    "en|handshake.forget.rule"  : ""
    "ru|handshake.forget.rule"  : "Чтобы забыть: /forget id"

    "en|handshake.forget.example"  : ""
    "ru|handshake.forget.example"  : "Например: /forget 5"

    "en|handshake.forget.notexist"  : ""
    "ru|handshake.forget.notexist"  : "Ты и так без понятия кто это"

    "en|handshake.forget.complete"  : ""
    "ru|handshake.forget.complete"  : "Теперь вы не знакомы"

    "en|handshake.remember.rule"  : ""
    "ru|handshake.remember.rule"  : "Чтобы запомнить: /remember id имя"

    "en|handshake.remember.example"  : ""
    "ru|handshake.remember.example"  : "Например: /remember 5 Howard"

    "en|handshake.remember.complete"  : ""
    "ru|handshake.remember.complete"  : "Вы запомнили %s"

    "en|handshake.yourself" : "You can't shake hands with yourself."
    "ru|handshake.yourself" : "Ты не в порядке. Срочно обратись к доктору!"

    "en|handshake.noplayer" : "There's no such person on server!"
    "ru|handshake.noplayer" : "Указанный игрок оффлайн."

    "en|handshake.largedistance" : "Distance between both players is too large!"
    "ru|handshake.largedistance" : "Между вами слишком большая дистанция!"

    "en|handshake.prohibited" : ""
    "ru|handshake.prohibited" : "Вам недоступна система знакомств"

    "en|handshake.prohibited.target" : ""
    "ru|handshake.prohibited.target" : "Система знакомств недоступна для вашего собеседника, поэтому вы сразу знаете настоящее имя персонажа и не можете забыть его или запомнить другое"

    "en|handshake.rules.break" : ""
    "ru|handshake.rules.break" : "Вы нарушили правила использования системы знакомств."

});