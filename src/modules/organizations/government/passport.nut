passportRequests <- null;

event("onServerStarted", function() {

    logStr("[passport requests] loading module...");

    loadPassportRequest();
});

function loadPassportRequest() {
    passportRequests <- ContainerPassportRequests(PassportRequest);

    PassportRequest.findAll(function(err, results) {
        foreach (idx, object in results) {
            passportRequests.set(object.id, object);
        }
    });
}

function getPassportRequestByCharid(charid) {
    foreach (idx, object in passportRequests) {
        if(object.charid == charid) {
            return object;
        }
    }

    return false;
}

function getPassportRequest(id) {
    foreach (idx, object in passportRequests) {
        if(object.id == id) {
            return object;
        }
    }

    return false;
}

local nations = [
    "",
    "american",
    "british",
    "italian",
    "chinese",
    "french",
    "afro",
    "irish",
    "jewish",
    "german",
    "mexican",
];

local colors = {
    "completed": CL_EUCALYPTUS,
    "approved": CL_SUCCESS,
    "rejected": CL_ERROR,
    "needsolution": CL_PICTONBLUE
}

event("onServerPlayerStarted", function( playerid ){

    local char = players[playerid];

    if (char.nationality == "") {
        delayedFunction(5000, function() {
            msg(playerid, "У вашего персонажа не заполнена национальность.", CL_WARNING);
            msg(playerid, "Заполнить: /nation", CL_GRAY);
        })
    }

});

function isPlayerHaveValidPassport( playerid ) {
    // всегда возвращать true
    return true;

    local haveValidPassport = false;

    foreach (idx, item in players[playerid].inventory) {
        if(item._entity == "Item.Passport") {
            if(item.data.fio == getPlayerName(playerid)) {
                local curdateStamp = getDay() + getMonth()*30 + getYear()*360;
                local dateStamp = convertDateToTimestamp(item.data.expires);
                if(curdateStamp <= dateStamp) {
                    haveValidPassport = true;
                    break;
                }
            }
        }
    }

    return haveValidPassport;
}

cmd("nation", function(playerid) {

    local char = players[playerid];

    if(char.nationality != "") {
        return msg(playerid, format("Национальность персонажа: %s", plocalize(playerid, "nationality."+char.nationality)), CL_SUCCESS);
    }

    for (local i = 1; i <= 10; i++) {
        msg(playerid,  i+". "+ plocalize(playerid, "nationality."+nations[i]));
    }

    msg(playerid, "Выберите национальность и укажите её номер в чат.", CL_WARNING);

    trigger(playerid, "hudCreateTimer", 30, true, true);

    local timer = delayedFunction(30000, function() {
        return msg(playerid, "Выбор не сделан", CL_ERROR);
    });

    delayedFunction(500, function() {
        requestUserInput(playerid, function(playerid, text) {
            trigger(playerid, "hudDestroyTimer");
            if (!text || !isNumeric(text) || text.tointeger() < 1 || text.tointeger() > 10) {
                return msg(playerid, "Некорректный выбор", CL_ERROR);
            }

            local num = text.tointeger();
            char.nationality = nations[num];
            char.save();

            msg(playerid, format("Выбрана национальность: %s", plocalize(playerid, "nationality."+nations[num])), CL_SUCCESS);

            timer.Kill();

        }, 30);
    });
});

cmd("passport", function( playerid) {
    if (!isPlayerInValidPoint(playerid, getGovCoords(0), getGovCoords(1), 2.0 )) {
        return msg(playerid, "passport.toofar", CL_ERROR);
    }

    if(isRestartPlanned()) {
        return msg(playerid, "В данный момент операции по заявкам не осуществляются.", CL_ERROR);
    }

    local char = players[playerid];

    if(char.nationality == "") {
        return msg(playerid, "Сначала необходимо выбрать национальность: /nation", CL_WARNING);
    }

    local request = getPassportRequestByCharid(char.id);

    if(request) {

        // решение ещё не принято
        if(request.status == "needsolution") {
            return msg(playerid, "passport.needsolution", CL_WARNING);
        }

         // отказано в получении
        if(request.status == "rejected") {
            msg(playerid, "passport.rejected", CL_ERROR);
            msg(playerid, "passport.rejected.reason", request.reason, CL_ERROR);
            msg(playerid, "passport.rejected.badname", CL_GRAY);

            delayedFunction(2000, function() {
                msg(playerid, "passport.rejected.new", CL_SUCCESS);
                local index = request.id;
                request.remove();
                passportRequests.remove(index);
            });

            return;
        }

        // разрешение получено, можно получать
        if(request.status == "approved") {
            msg(playerid, "passport.approved", CL_SUCCESS);

            if(!players[playerid].inventory.isFreeSpace(1)) {
                return msg(playerid, "inventory.space.notenough", CL_ERROR);
            }

            local passportObj = Item.Passport();

            if (!players[playerid].inventory.isFreeVolume(passportObj)) {
                return msg(playerid, "inventory.volume.notenough", CL_ERROR);
            }

            passportObj.setData("fio", getPlayerName(playerid));
            passportObj.setData("birthdate", char.birthdate);
            passportObj.setData("sex", char.sex);
            passportObj.setData("hair", request.hair);
            passportObj.setData("eyes", request.eyes);
            passportObj.setData("nationality", char.nationality);

            local day   = getDay();
            local month = getMonth();
            local year  = getYear() + 2;
            if (day < 10) { day = "0"+day; }
            if (month < 10) { month = "0"+month; }
            passportObj.setData("issued", getDate());
            passportObj.setData("expires", day+"."+month+"."+year);

            players[playerid].inventory.push( passportObj );
            request.status = "completed";
            request.save();

            passportObj.save();
            players[playerid].inventory.sync();
            players[playerid].save();

            msg(playerid, "passport.got", CL_SUCCESS);
            msg(playerid, "passport.got.check-inventory", CL_GRAY);

            nano({
                "path": "discord",
                "server": "gov",
                "channel": "passport_office",
                "action": "new",
                "description": "Выдан паспорт",
                "color": "purple",
                "datetime": getDateTime(),
                "fields": [
                    ["Номер", request.id],
                    ["Имя Фамилия", getPlayerName(playerid)],
                    ["Пол", plocalize(playerid, "passport.sex."+char.sex)],
                    ["Национальность", plocalize(playerid, "nationality."+char.nationality)],
                    ["Дата рождения", char.birthdate],
                    ["Цвет волос", plocalize(playerid, "passport.hair."+request.hair)],
                    ["Цвет глаз", plocalize(playerid, "passport.eyes."+request.eyes)],
                    ["Дата выдачи", getDate()],
                    ["Дата истечения", day+"."+month+"."+year],
                ]
            });

            return;
        }

        // паспорт уже был получен
        if(request.status == "completed") {
            return msg(playerid, "passport.alreadyget", CL_ERROR);
        }

        return;
    }


    // оформляем заявку
    // players[playerid].setData("passport", "needsolution");

    local request = PassportRequest();
    request.fio = format("%s %s", char.firstname, char.lastname);
    request.charid = char.id;
    request.gender = char.sex;
    request.nationality = char.nationality;
    request.birthdate = char.birthdate;
    request.status = "needsolution";
    request.examiner = "";

    trigger(playerid, "hudCreateTimer", 60, true, true);

    local defaulttogooc = getPlayerOOC(playerid);
    setPlayerOOC(playerid, false);

    local timer = delayedFunction(60000, function() {
        if(defaulttogooc) setPlayerOOC(playerid, true);
        return msg(playerid, "passport.insert.incorrect", CL_ERROR);
    });

    //hair color
    msg(playerid, "passport.insert.hair", CL_CHESTNUT2);

    for (local i = 1; i <= 9; i++) {
        msg(playerid,  i+". "+ plocalize(playerid, "passport.hair."+i));
    }

    delayedFunction(100, function() {
        requestUserInput(playerid, function(playerid, text) {

            if (!text || !isNumeric(text) || text.tointeger() < 1 || text.tointeger() > 9) {
                return msg(playerid, "passport.insert.incorrect", CL_ERROR);
            }

            request.hair = text.tointeger();

            //eyes color
            msg(playerid, "passport.insert.eyes", CL_CHESTNUT2);

            for (local i = 1; i <= 9; i++) {
                msg(playerid,  i+". "+ plocalize(playerid, "passport.eyes."+i));
            }

            delayedFunction(100, function() {
                requestUserInput(playerid, function(playerid, text) {
                    trigger(playerid, "hudDestroyTimer");
                    setPlayerOOC(playerid, defaulttogooc);

                    if (!text || !isNumeric(text) || text.tointeger() < 1 || text.tointeger() > 9) {
                        return msg(playerid, "passport.insert.incorrect", CL_ERROR);
                    }

                    request.eyes = text.tointeger();
                    passportRequests.push(request);
                    request.save();

                    timer.Kill();

                    // new
                    nano({
                        "path": "discord",
                        "server": "gov",
                        "channel": "passport_requests",
                        "action": "new",
                        "description": "Заявка на паспорт",
                        "color": "yellow",
                        "datetime": getDateTime(),
                        "direction": false,
                        "fields": [
                            ["Номер", request.id],
                            ["Имя Фамилия", getPlayerName(playerid)],
                            ["Пол", plocalize(playerid, "passport.sex."+char.sex)],
                            ["Национальность", plocalize(playerid, "nationality."+char.nationality)],
                            ["Дата рождения", char.birthdate],
                            ["Цвет волос", plocalize(playerid, "passport.hair."+request.hair)],
                            ["Цвет глаз", plocalize(playerid, "passport.eyes."+request.eyes)],
                        ]
                    });

                    return msg(playerid, "passport.request-sent", CL_SUCCESS);

                }, 30);
            })
        }, 30);
    });
    return;
});


fmd("gov", ["gov.passport"], "$f passport list", function(fraction, character, page = "1") {

    if(isRestartPlanned()) {
        return msg(character.playerid, "В данный момент операции по заявкам не осуществляются.", CL_ERROR);
    }

    local length = passportRequests.len();
    if(length == 0) {
        return msg(character.playerid, "Заявок на получение паспорта нет", CL_WARNING);
    }
    page = page.tointeger();
    if(page < 1 || page > length % 10) {
        return msg(character.playerid, "Неверный номер страницы", CL_ERROR);
    }

    // соберём все реквесты
    local requests = [];
    foreach (idx, req in passportRequests) {
        requests.push(req);
    }

    // инвертируем
    requests.reverse();
    local indexStart = ((page-1) * 10);
    local indexEnd = (indexStart + 10) > length ? length : indexStart + 10;

    // title
    msgt(character.playerid, format("Заявки на паспорт (страница: %d)", page));

    for (local i = indexStart; i < indexEnd; i++) {
        local req = requests[i];
        local str;
        if(req.status == "needsolution") {
            str = format("%d. %s - %s", req.id, req.fio, plocalize(character.playerid, "passport.status."+req.status))
        } else if(req.status == "rejected") {
            str = format("%d. %s - %s %s: %s", req.id, req.fio, plocalize(character.playerid, "passport.status."+req.status), req.examiner, req.reason)
        } else {
            str = format("%d. %s - %s %s", req.id, req.fio, plocalize(character.playerid, "passport.status."+req.status),req.examiner)
        }
        msg(character.playerid, str, colors[req.status]);
    }

    msg(character.playerid, "Посмотреть заявку: /gov passport show номер-заявки", CL_GRAY);

    if(indexEnd != length) {
        msg(character.playerid, "");
        msg(character.playerid, format("Следующая страница: /gov passport list %d", page+1), CL_GRAY);
    }

    // dbg("admin", "mutelist", list);
});

fmd("gov", ["gov.passport"], "$f passport show", function(fraction, character, num = "0") {

    if(isRestartPlanned()) {
        return msg(character.playerid, "В данный момент операции по заявкам не осуществляются.", CL_ERROR);
    }

    local request = getPassportRequest(num.tointeger());

    if(!request) {
        return msg(character.playerid, "Указанная заявка не существует", CL_ERROR);
    }

    local plaId = character.playerid;

    local lines = [
        plocalize(plaId, "passport.info.fio", [request.fio]),
        plocalize(plaId, "passport.info.birthdate", [request.birthdate]),
        plocalize(plaId, "passport.info.sex", [plocalize(plaId, "passport.sex."+request.gender)]),
        plocalize(plaId, "passport.info.nationality", [plocalize(plaId, "nationality."+request.nationality)]),
        plocalize(plaId, "passport.info.hair", [plocalize(plaId, "passport.hair."+request.hair)]),
        plocalize(plaId, "passport.info.eyes", [plocalize(plaId, "passport.eyes."+request.eyes)]),
        "",
    ]

    if(request.status == "needsolution") {
        lines.push(format("Одобрить: /gov passport approve %d", request.id));
        lines.push(format("Отклонить: /gov passport reject %d причина", request.id));
    }

    if(request.status == "approved" || request.status == "rejected") {
        lines.push(format("Сбросить в «новое»: /gov passport reset %d", request.id));
    }

    msgh(plaId, "Заявка на выдачу паспорта #"+num, lines)
});

fmd("gov", ["gov.passport"], "$f passport", function(fraction, character, result, num, ...) {

    if(isRestartPlanned()) {
        return msg(character.playerid, "В данный момент операции по заявкам не осуществляются.", CL_ERROR);
    }

    local request = getPassportRequest(num.tointeger());

    if(!request) {
        return msg(character.playerid, "Указанная заявка не существует", CL_ERROR);
    }

    if(request.status == "completed") {
        return msg(character.playerid, "Нельзя изменить решение по выполненной заявке.", CL_ERROR);
    }

    if((request.status == "approved" || request.status == "rejected") && result != "reset") {
        return msg(character.playerid, "По этой заявке решение уже принято. Вы не можете изменить решение без сбрасывания: /gov passport reset %d", [request.id], CL_ERROR);
    }

    local reason = concat(vargv);

    if(result == "reject" && reason == null) {
        return msg(character.playerid, "Не указана причина отклонения заявки", CL_ERROR);
    }

    // if (!isPlayerInValidPoint(character.playerid, getGovCoords(0), getGovCoords(1), 1.0 )) {
    //     return msg(character.playerid, "passport.toofar", CL_ERROR);
    // }

    switch(result) {
        case "approve":
            request.status = "approved";
            request.examiner = getPlayerName(character.playerid);
            request.save();
            msg(character.playerid, "passport.solution.approved", CL_SUCCESS);
            nano({
                "path": "discord",
                "server": "gov",
                "channel": "passport_requests",
                "action": "changed",
                "author": request.examiner,
                "description": "Одобрил заявку",
                "color": "green",
                "datetime": getDateTime(),
                "direction": false,
                "fields": [
                    ["Номер", request.id],
                    ["Имя Фамилия", request.fio],
                ]
            });
        break;
        case "reject":
            request.status = "rejected";
            request.examiner = getPlayerName(character.playerid);
            request.reason = reason;
            request.save();
            msg(character.playerid, "passport.solution.rejected", CL_ERROR);
            nano({
                "path": "discord",
                "server": "gov",
                "channel": "passport_requests",
                "action": "changed",
                "author": request.examiner,
                "description": "Отклонил заявку",
                "color": "red",
                "datetime": getDateTime(),
                "direction": false,
                "fields": [
                    ["Номер", request.id],
                    ["Имя Фамилия", request.fio],
                    ["Причина", reason],
                ]
            });
        break;
        case "reset":
            local prevStatus = request.status;
            request.status = "needsolution";
            request.examiner = "";
            request.save();
            msg(character.playerid, "passport.solution.reseted", CL_PICTONBLUE);
            nano({
                "path": "discord",
                "server": "gov",
                "channel": "passport_requests",
                "action": "reset",
                "author": getPlayerName(character.playerid),
                "description": "Сбросил решение по заявке",
                "color": "blue",
                "datetime": getDateTime(),
                "direction": false,
                "fields": [
                    ["Номер", request.id],
                    ["Имя Фамилия", request.fio],
                    ["Предыдущий статус заявки", plocalize(character.playerid, "passport.status."+prevStatus)]
                ]
            });
        break;
        default:
            msg(character.playerid, "passport.solution.invalid", CL_ERROR);
    }
});

alternativeTranslate({

    "en|passport.help.title"        : "Passport:"
    "ru|passport.help.title"        : "Паспорт гражданина:"

    "en|passport.help.passport"     : "/passport get"
    "ru|passport.help.passport"     : "/passport get"

    "en|passport.help.desc"         : "Get passport"
    "ru|passport.help.desc"         : "Получить паспорт"

    "en|passport.toofar"            : "You can get passport at city government."
    "ru|passport.toofar"            : "Получить паспорт можно в мэрии города."

    "en|passport.alreadyget"        : "You have a passport already."
    "ru|passport.alreadyget"        : "Вы уже получали паспорт."

    "en|passport.status.needsolution"  : "new"
    "ru|passport.status.needsolution"  : "новое"

    "en|passport.status.approved" :  "approved"
    "ru|passport.status.approved" :  "одобрено"

    "en|passport.status.rejected" : "rejected"
    "ru|passport.status.rejected" : "отклонено"

    "en|passport.status.completed" :  "completed"
    "ru|passport.status.completed" :  "получен"

    "en|passport.status.needsolution" :  "is considered"
    "ru|passport.status.needsolution" :  "рассматривается"

    "en|passport.needsolution"      : ""
    "ru|passport.needsolution"      : "Ваша заявка ещё рассматривается. Приходите позже."

    "en|passport.approved"          : ""
    "ru|passport.approved"          : "Ваша заявка рассмотрена и одобрена."

    "en|passport.rejected"          : "Your passport request has been denied."
    "ru|passport.rejected"          : "Вам отказано в получении паспорта."

    "en|passport.rejected.reason"   : "Reason: %s"
    "ru|passport.rejected.reason"   : "Причина: %s"

    "en|passport.rejected.badname"  : ""
    "ru|passport.rejected.badname"  : "Если причиной указано любая проблема с именем и фамилией - обратитесь к администрации для смены имени."

    "en|passport.request-sent"      : ""
    "ru|passport.request-sent"      : "Заявка на получение паспорта принята. В течение некоторого времени (обычно 1 реальный день) по заявке будет принято решение. Возвращайтесь!"

    "en|passport.rejected.new"      : ""
    "ru|passport.rejected.new"      : "Вы можете подать новую заявку, но будьте внимательны при заполнении."


    "en|passport.solution.invalid"  : "Invalid status."
    "ru|passport.solution.invalid"  : "Статус указан неверно."

    "en|passport.solution.approved" : "You have approved the application for obtaining a passport."
    "ru|passport.solution.approved" : "Вы одобрили заявку на получение паспорта."

    "en|passport.solution.rejected" : "You have rejected the application for obtaining a passport."
    "ru|passport.solution.rejected" : "Вы отклонили заявку на получение паспорта."

    "en|passport.solution.reseted" : "You have reseted the application for obtaining a passport."
    "ru|passport.solution.reseted" : "Вы сбросили решение по заявке на получение паспорта."

    "en|passport.insert.nationality" : "Insert number of nationality:"
    "ru|passport.insert.nationality" : "Укажите номер, соответствующий вашей национальности:"

    "en|passport.insert.hair"       : "Insert number of hair color:"
    "ru|passport.insert.hair"       : "Укажите номер, соответствующий цвету волос:"

    "en|passport.insert.eyes"       : "Insert number of eyes color:"
    "ru|passport.insert.eyes"       : "Укажите номер, соответствующий цвету глаз:"

    "en|passport.insert.incorrect"  : "Incorrect. Try again..."
    "ru|passport.insert.incorrect"  : "Указано некорректное значение. Попробуй сначала."

    "en|passport.got"               : "You got the passport."
    "ru|passport.got"               : "Вы получили паспорт гражданина США."

    "en|passport.got.check-inventory"  : "Check your inventory."
    "ru|passport.got.check-inventory"  : "Проверьте свой инвентарь."

    "en|passport.info.title"        : "Passport:"
    "ru|passport.info.title"        : "Паспорт гражданина:"

    "en|passport.info.fio"          : "Firstname Lastname: %s"
    "ru|passport.info.fio"          : "Имя Фамилия: %s"

    "en|passport.info.nationality"  : "Nationality: %s"
    "ru|passport.info.nationality"  : "Национальная принадлежность: %s"

    "en|passport.info.birthdate"    : "Date of birth: %s"
    "ru|passport.info.birthdate"    : "Дата рождения: %s"

    "en|passport.info.birthplace"   : "Place of birth: %s"
    "ru|passport.info.birthplace"   : "Место рождения: %s"

    "en|passport.info.race"         : "Раса: %s"
    "ru|passport.info.race"         : "Раса: %s"

    "en|passport.info.sex"          : "Sex: %s"
    "ru|passport.info.sex"          : "Пол: %s"

    "en|passport.info.eyes"         : "Eyes: %s"
    "ru|passport.info.eyes"         : "Цвет глаз: %s"

    "en|passport.info.hair"         : "Hair: %s"
    "ru|passport.info.hair"         : "Цвет волос: %s"

    "en|passport.info.issued"       : "Date of issue: %s"
    "ru|passport.info.issued"       : "Дата выдачи: %s"

    "en|passport.info.expires"      : "Date of expiration: %s"
    "ru|passport.info.expires"      : "Истекает: %s"

    "en|passport.sex.0" : "Man"
    "ru|passport.sex.0" : "Мужской"

    "en|passport.sex.1" : "Woman"
    "ru|passport.sex.1" : "Женский"



    "en|passport.eyes.1" : "blue"
    "ru|passport.eyes.1" : "синий"
    "en|passport.eyes.2" : "light blue"
    "ru|passport.eyes.2" : "голубой"
    "en|passport.eyes.3" : "gray"
    "ru|passport.eyes.3" : "серый"
    "en|passport.eyes.4" : "gray-blue"
    "ru|passport.eyes.4" : "серо-голубой"
    "en|passport.eyes.5" : "green"
    "ru|passport.eyes.5" : "зелёный"
    "en|passport.eyes.6" : "amber"
    "ru|passport.eyes.6" : "янтарный"
    "en|passport.eyes.7" : "olive"
    "ru|passport.eyes.7" : "оливковый"
    "en|passport.eyes.8" : "brown"
    "ru|passport.eyes.8" : "карий"
    "en|passport.eyes.9" : "black"
    "ru|passport.eyes.9" : "чёрный"


    "en|passport.hair.1" : "dark"
    "ru|passport.hair.1" : "тёмный"
    "en|passport.hair.2" : "black"
    "ru|passport.hair.2" : "чёрный"
    "en|passport.hair.3" : "light"
    "ru|passport.hair.3" : "светлый"
    "en|passport.hair.4" : "light brown"
    "ru|passport.hair.4" : "русый"
    "en|passport.hair.5" : "brownish"
    "ru|passport.hair.5" : "коричневый"
    "en|passport.hair.6" : "ginger"
    "ru|passport.hair.6" : "рыжий"
    "en|passport.hair.7" : "dark blond"
    "ru|passport.hair.7" : "тёмно-русый"
    "en|passport.hair.8" : "gray"
    "ru|passport.hair.8" : "седые"
    "en|passport.hair.9" : "dark brown"
    "ru|passport.hair.9" : "тёмно-коричневый"


    "en|passport.nationality.0-1"   : "Englishman"
    "ru|passport.nationality.0-1"   : "Англичанин"
    "en|passport.nationality.0-2"   : "Italian"
    "ru|passport.nationality.0-2"   : "Итальянец"
    "en|passport.nationality.0-3"   : "American"
    "ru|passport.nationality.0-3"   : "Американец"
    "en|passport.nationality.0-4"   : "Irishman"
    "ru|passport.nationality.0-4"   : "Ирландец"
    "en|passport.nationality.0-5"   : "Italian-American"
    "ru|passport.nationality.0-5"   : "Итало-американец"
    "en|passport.nationality.0-6"   : "Frenchman"
    "ru|passport.nationality.0-6"   : "Француз"
    "en|passport.nationality.0-7"   : "African American"
    "ru|passport.nationality.0-7"   : "Афроамериканец"
    "en|passport.nationality.0-8"   : "Chinese"
    "ru|passport.nationality.0-8"   : "Китаец"
    "en|passport.nationality.0-9"   : "Mexican"
    "ru|passport.nationality.0-9"   : "Мексиканец"
    "en|passport.nationality.0-10"  : "German"
    "ru|passport.nationality.0-10"  : "Немец"
    "en|passport.nationality.0-11"  : "Jewish"
    "ru|passport.nationality.0-11"  : "Еврей"

    "en|passport.nationality.1-1"   : "Englishwoman"
    "ru|passport.nationality.1-1"   : "Англичанка"
    "en|passport.nationality.1-2"   : "Italian"
    "ru|passport.nationality.1-2"   : "Итальянка"
    "en|passport.nationality.1-3"   : "American"
    "ru|passport.nationality.1-3"   : "Американка"
    "en|passport.nationality.1-4"   : "Irishwoman"
    "ru|passport.nationality.1-4"   : "Ирландка"
    "en|passport.nationality.1-5"   : "Italian-American"
    "ru|passport.nationality.1-5"   : "Итало-американка"
    "en|passport.nationality.1-6"   : "Frenchwoman"
    "ru|passport.nationality.1-6"   : "Француженка"
    "en|passport.nationality.1-7"   : "African American"
    "ru|passport.nationality.1-7"   : "Афроамериканка"
    "en|passport.nationality.1-8"   : "Chinese"
    "ru|passport.nationality.1-8"   : "Китаянка"
    "en|passport.nationality.1-9"   : "Mexican"
    "ru|passport.nationality.1-9"   : "Мексиканка"
    "en|passport.nationality.1-10"  : "German"
    "ru|passport.nationality.1-10"  : "Немка"
    "en|passport.nationality.1-11"  : "Jewish"
    "ru|passport.nationality.1-11"  : "Еврейка"

    "ru|nationality.american"          : "Американцы"
    "ru|nationality.british"           : "Британцы"
    "ru|nationality.italian"           : "Итальянцы"
    "ru|nationality.chinese"           : "Китайцы"
    "ru|nationality.french"            : "Французы"
    "ru|nationality.afro"              : "Афроамериканцы"
    "ru|nationality.irish"             : "Ирландцы"
    "ru|nationality.jewish"            : "Евреи"
    "ru|nationality.german"            : "Немцы"
    "ru|nationality.mexican"           : "Мексиканцы"

});
