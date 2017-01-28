translation("en", {
    "organizations.police.phone.dispatch.call"              : "%s says: Operator, give me dispatch."
    "organizations.police.phone.operator.connecttodispatch" : "- Putting you through now."
    "organizations.police.phone.dispatch.online"            : "- Dispatcher on line."
    "organizations.police.phone.dispatch.badge"             : "%s says: %s, badge 00000."
    "organizations.police.phone.dispatch.policereply"       : "- How can I help, %s?"
    "organizations.police.phone.dispatch.calltowtruck"      : "%s says: I need tow truck to transfer vehicle with plate %s to car pound."

    "organizations.police.phone.dispatch.hintanswer"        : "[HINT] Type a number one of the possible answers:"
    "organizations.police.phone.dispatch.choiseanswer1"     : "#1. Get address"
    "organizations.police.phone.dispatch.choiseanswer2"     : "#2. Get information on vehicle by plate number"
    "organizations.police.phone.dispatch.choiseanswer3"     : "#3. Transfer for suspect"
    "organizations.police.phone.dispatch.choiseanswer4"     : "#4. Call tow truck to transport vehicle to car pound"

    "organizations.police.phone.dispatch.dunno"             : "%s says: Em, sorry i'm forgot what I want to ask about."
    "organizations.police.phone.dispatch.policerefuse"      : "- Oh, okay. Call us if you'll need something. Good luck!"
    "organizations.police.phone.dispatch.getaddress"        : "%s says: I want to get an address of (smth)"
    "organizations.police.phone.dispatch.getvehicleinfo"    : "%s says: I want to get information about vehicle with plate number %s"
    "organizations.police.phone.dispatch.transfersuspect"   : "%s says: I need to transfer the suspect."
    "organizations.police.phone.dispatch.towtruck"          : "%s says: I need a tow truck to transfer vehicle with plate %s to car pound. Location: %s"
    "organizations.police.phone.dispatch.repeatplease"      : "- Простите, я плохо вас слышу. Повторите, пожалуйста?"
});

translation("ru", {
    "organizations.police.phone.dispatch.call"              : "%s сказал: Оператор, соедините с диспетчером."
    "organizations.police.phone.operator.connecttodispatch" : "- Соединяю."
    "organizations.police.phone.dispatch.online"            : "- Диспетчер на линии, слушаю."
    "organizations.police.phone.dispatch.badge"             : "%s сказал: %s, жетон 00000."
    "organizations.police.phone.dispatch.policereply"       : "- Чем могу помочь, %s?"
    "organizations.police.phone.dispatch.calltowtruck"      : "%s сказал: Мне требуется тягач для транспортировки автомобиля с номерами %s на штрафстоянку."

    "organizations.police.phone.dispatch.hintanswer"        : "[ПОДСКАЗКА]. Напишите в чат номер одного из представленных вариантов:"
    "organizations.police.phone.dispatch.choiseanswer1"     : "#1. Узнать адрес"
    "organizations.police.phone.dispatch.choiseanswer2"     : "#2. Получить сведенья об автомобиле по номеру"
    "organizations.police.phone.dispatch.choiseanswer3"     : "#3. Транспортировка подозреваемого"
    "organizations.police.phone.dispatch.choiseanswer4"     : "#4. Вызов тягача для транспортировки автомобиля на штрафстоянку"

    "organizations.police.phone.dispatch.dunno"             : "%s сказал: Эм, честно говоря я забыл что хотел."
    "organizations.police.phone.dispatch.policerefuse"      : "- Хорошо. Позвоните, если вам что-то потребуется. Удачи!"
    "organizations.police.phone.dispatch.getaddress"        : "%s сказал: Я хотел бы узнать где находится (заведение или ещё какая дичь)"
    "organizations.police.phone.dispatch.getvehicleinfo"    : "%s сказал: Я хотел бы узнать информацию об автомобиле с номером %s"
    "organizations.police.phone.dispatch.transfersuspect"   : "%s сказал: Мне необходима транспортировка подозреваемого."
    "organizations.police.phone.dispatch.towtruck"          : "%s сказал: Необходим тягач для перевозки автомобиля с номерами %s на штрафстоянку. Местоположение: %s"
    "organizations.police.phone.dispatch.repeatplease"      : "- Простите, я плохо вас слышу. Повторите, пожалуйста?"
});

POLICE_DISPATCH_ANSWER_TIMEOUT <- 90;

event("onPlayerVehicleExit", function( playerid, vehicleid, seat ) {
    if (isOfficer(playerid) && isVehicleidPoliceVehicle(vehicleid)) {
        clearUserInput(playerid);
    }
});

function isOfficerNearCommunications(playerid) {
    return (isPlayerInPoliceVehicle(playerid) || getPlayerPhoneName(playerid));
}

function callPoliceDispatchByPhone(playerid, place = "") {
    local message = "organizations.police.phone.dispatch.call"; //  - Operator, give me dispatch.  // Оператор, соедините с диспетчером.
    // Operator, message for KJPL. // Оператор, сообщение для диспетчера.
    sendLocalizedMsgToAll(playerid, message, [getPlayerName(playerid)], POLICE_PHONENORMAL_RADIUS, CL_WHITE);

    local replyMessage = "organizations.police.phone.operator.connecttodispatch"; //  - Putting you through now.      // Соединяю
    sendLocalizedMsgToAll(playerid, replyMessage, [""], POLICE_PHONEREPLY_RADIUS, CL_WHITE);

    // continue dialog
    callPoliceDispatch(playerid, place);
}

function callPoliceDispatch(playerid, place = "") {
    local message;
    local replyMessage;

    delayedFunction( random(1700, 2600), function() {
        if ( !isOfficerNearCommunications(playerid) ) return;
        replyMessage = "organizations.police.phone.dispatch.online"; // - Dispatcher on line. // Диспетчер, слушаю.
        sendLocalizedMsgToAll(playerid, replyMessage, [""], POLICE_PHONEREPLY_RADIUS, CL_WHITE);

        message = "organizations.police.phone.dispatch.badge"; //  - <Name>, badge <number>.       // (Кто), жетон (номер)
        sendLocalizedMsgToAll(playerid, message, [getPlayerName(playerid), getPlayerName(playerid)], POLICE_PHONENORMAL_RADIUS, CL_WHITE);
    });

    // Check if player has permission to take info
    // if ( getPoliceRank(playerid) < 3 ) {
    //     return msg(playerid, "organizations.police.lowrank", [], CL_GRAY);
    // }

    delayedFunction( random(2900, 3100), function() {
        if ( !isOfficerNearCommunications(playerid) ) return;
        replyMessage = "organizations.police.phone.dispatch.policereply"; //  - How can I help, <rank>?       // Чем могу помочь, (ранг)?
        sendLocalizedMsgToAll(playerid, replyMessage, [getLocalizedPlayerJob(playerid)], POLICE_PHONEREPLY_RADIUS, CL_WHITE); // "Чем могу помочь, Сержант %Familyname%"

        trigger("onCallPoliceDispatch", playerid);
    });
}

// Waiting for player input or refuse
event("onCallPoliceDispatch", function (playerid) {
        local cancel = {
        "0"                 :"",
        "отмена"            :"",
        "'отмена'"          :"",
        "cancel"            :"",
        "'cancel'"          :"",
    }

    local answer1 = {
        "1"                 :"",
        "#1"                :"",
        "#1."               :"",
        "1."                :"",
    };

    local answer2 = {
        "2"                 :"",
        "#2"                :"",
        "#2."               :"",
        "2."                :"",
    };

    local answer3 = {
        "3"                 :"",
        "#3"                :"",
        "#3."               :"",
        "3."                :"",
    };

    local answer4 = {
        "4"                 :"",
        "#4"                :"",
        "#4."               :"",
        "4."                :"",
    };

    msg( playerid, "");
    msg(playerid, "organizations.police.phone.dispatch.hintanswer");

    // Show up anser choise with GUI
    //  1. Узнать адрес заведения
    //  2. Пробить номер машины
    //      Мишина зарегистрирована на (имя), (адрес постоянного проживания).
    //  3. Сообщения от других игроков-полицейских и обращения в EBPD
    //  4. Транспортировка задержанного
    //  5. Буксировка авто на штрафстоянку
    for (local i = 1; i <= 4; i++) {
        msg( playerid, "organizations.police.phone.dispatch.choiseanswer" + i.tostring(), [], CL_YELLOW );
    }

    local message;
    local replyMessage;

    requestUserInput(playerid, function(playerid, ...) {
        if ( !isOfficerNearCommunications(playerid) ) return;

        local text = concat( vargv );
        if (text.tolower() in cancel) {
            // FIX IT
            message = "organizations.police.phone.dispatch.dunno"; // Эм, честно говоря я забыл что хотел. // Em, sorry i'm forgot what I want to ask about.
            sendLocalizedMsgToAll(playerid, message, [getPlayerName(playerid)], POLICE_PHONENORMAL_RADIUS, CL_WHITE);

            replyMessage = "organizations.police.phone.dispatch.policerefuse"; // "- Oh, okay. Call us if you'll need something. Good luck! (hang up)"
            sendLocalizedMsgToAll(playerid, replyMessage, [], POLICE_PHONEREPLY_RADIUS, CL_WHITE);
            return msg( playerid, "");
        }

        if (text.tolower() in answer1) {
            message = "organizations.police.phone.dispatch.getaddress"; // Я хотел бы узнать где находится (заведение или ещё какая дичь) // I want to get addres of (smth)
            sendLocalizedMsgToAll(playerid, message, [getPlayerName(playerid)], POLICE_PHONENORMAL_RADIUS, CL_WHITE);
            return msg( playerid, "");
        }

        if (text.tolower() in answer2) {
            message = "organizations.police.phone.dispatch.getvehicleinfo"; // Я хотел бы узнать информацию об автомобиле с номером %s // I want to get information about vehicle with player number %s
            sendLocalizedMsgToAll(playerid, message, [getPlayerName(playerid), "TEST-EB"], POLICE_PHONENORMAL_RADIUS, CL_WHITE);
            return msg( playerid, "");
        }

        if (text.tolower() in answer3) {
            message = "organizations.police.phone.dispatch.transfersuspect"; // Мне необходима транспортировка подозреваемого. // I need to transfer the suspect.
            sendLocalizedMsgToAll(playerid, message, [getPlayerName(playerid)], POLICE_PHONENORMAL_RADIUS, CL_WHITE);
            return msg( playerid, "");
        }

        if (text.tolower() in answer4) {
            message = "organizations.police.phone.dispatch.towtruck"; // Необходим тягач для перевозки автомобиля с номерами %s на штрафстоянку. Местоположение: %s // I need tow truck to transfer vehicle with plate %s to car pound. Location: %s
            sendLocalizedMsgToAll(playerid, message, [getPlayerName(playerid), "TEST-EB", place], POLICE_PHONENORMAL_RADIUS, CL_WHITE);
            return msg( playerid, "");
        }

        replyMessage = "organizations.police.phone.dispatch.repeatplease"; // Простите, я плохо вас слышу. Повторите, пожалуйста? // Sorry, I hear you poorly. Repeat please?
        sendLocalizedMsgToAll(playerid, replyMessage, [], POLICE_PHONEREPLY_RADIUS, CL_WHITE);

        delayedFunction( random(100, 200), function() {
            if ( !isOfficerNearCommunications(playerid) ) return;
            trigger("onCallPoliceDispatch", playerid);
        });
    }, POLICE_DISPATCH_ANSWER_TIMEOUT);
});





event("onPlayerPhoneCall", function(playerid, number, place) {
    if (number == "dispatch" && isOfficer(playerid)) {
        callPoliceDispatchByPhone(playerid, place);
    }
});


cmd(["r"],["dispatch"], function(playerid) {
    if ( isPlayerInPoliceVehicle(playerid) && isOfficer(playerid) ) {
        callPoliceDispatch(playerid, "не определено");
    }
});
