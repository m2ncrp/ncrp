/* ============================================================================================ */

function passportHelp( playerid ) {
    local title = "passport.help.title";
    local commands = [
        { name = "passport.help.passport",    desc = "passport.help.desc" }
    ];
    msg_help(playerid, title, commands);
}


cmd("passport", function( playerid, parametr = 0 ) {

    if (parametr != "get") {
        return passportHelp( playerid );
    }

    if (!isPlayerInValidPoint(playerid, getGovCoords(0), getGovCoords(1), 1.0 )) {
        return msg(playerid, "passport.toofar", CL_THUNDERBIRD);
    }

    if ("passport" in players[playerid].data) {

        local status = players[playerid].data.passport.tostring();

        // паспорт уже был получен
        if (status == "true") {
            return msg(playerid, "passport.alreadyget", CL_THUNDERBIRD);
        }

        // чтобы можно было получить новый паспорт в случае смены никнейма
        if (status == "false" || status == "needsolution") {
            players[playerid].setData("passport", "needsolution");
            return msg(playerid, "passport.needsolution", CL_THUNDERBIRD);
        }

        // отказано в получении
        if (status == "rejected") {
            msg(playerid, "passport.rejected", CL_THUNDERBIRD);
            return msg(playerid, "passport.rejected.badname", CL_GRAY);
        }

    } else {
        // первое получение паспорта - оформляем запрос
        players[playerid].setData("passport", "needsolution");
        return msg(playerid, "passport.needsolution", CL_THUNDERBIRD);
    }



    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local passportObj = Item.Passport();
    if (!players[playerid].inventory.isFreeWeight(passportObj)) {
        return msg(playerid, "inventory.weight.notenough", CL_THUNDERBIRD);
    }

    local defaulttogooc = getPlayerOOC(playerid);
    setPlayerOOC(playerid, false);

    local sex = players[playerid].sex;

    passportObj.setData("fio", getPlayerName(playerid));
    passportObj.setData("birthdate", players[playerid].birthdate );
    passportObj.setData("sex", sex );
    passportObj.setData("race", players[playerid].race );

    local complete = false;

    delayedFunction(90000, function() {
        if (complete == false) {
            if(defaulttogooc) setPlayerOOC(playerid, true);
            return msg(playerid, "passport.insert.incorrect", CL_THUNDERBIRD);
        }
    });

    //nationality
    msg(playerid, "passport.insert.nationality", CL_CHESTNUT2);

    for (local i = 1; i <= 11; i++) {
        msg(playerid,  i+". "+ plocalize(playerid, "passport.nationality."+sex+"-"+i));
    }

    trigger(playerid, "hudCreateTimer", 90, true, true);

    requestUserInput(playerid, function(playerid, text) {

        if (!text || !isNumeric(text) || text.tointeger() < 1 || text.tointeger() > 11) {
            if(defaulttogooc) setPlayerOOC(playerid, true);
            return msg(playerid, "passport.insert.incorrect", CL_THUNDERBIRD);
        }
        passportObj.setData("nationality", text.tointeger());

        //hair color
        msg(playerid, "passport.insert.hair", CL_CHESTNUT2);

        for (local i = 1; i <= 9; i++) {
            msg(playerid,  i+". "+ plocalize(playerid, "passport.hair."+i));
        }

        delayedFunction( 1000, function() {
            requestUserInput(playerid, function(playerid, text) {

                if (!text || !isNumeric(text) || text.tointeger() < 1 || text.tointeger() > 9) {
                    if(defaulttogooc) setPlayerOOC(playerid, true);
                    return msg(playerid, "passport.insert.incorrect", CL_THUNDERBIRD);
                }
                passportObj.setData("hair", text.tointeger());

                //hair color
                msg(playerid, "passport.insert.eyes", CL_CHESTNUT2);

                for (local i = 1; i <= 9; i++) {
                    msg(playerid,  i+". "+ plocalize(playerid, "passport.eyes."+i));
                }

                delayedFunction( 1000, function() {
                    requestUserInput(playerid, function(playerid, text) {
                        trigger(playerid, "hudDestroyTimer");
                        if (!text || !isNumeric(text) || text.tointeger() < 1 || text.tointeger() > 9) {
                            if(defaulttogooc) setPlayerOOC(playerid, true);
                            return msg(playerid, "passport.insert.incorrect", CL_THUNDERBIRD);
                        }
                        passportObj.setData("eyes", text.tointeger());

                        msg(playerid, "passport.got", CL_SUCCESS);

                        local day   = getDay();
                        local month = getMonth();
                        local year  = getYear() + 10;
                        if (day < 10) { day = "0"+day; }
                        if (month < 10) { month = "0"+month; }
                        passportObj.setData("issued",  getDate());
                        passportObj.setData("expires", day+"."+month+"."+year);

                        players[playerid].inventory.push( passportObj );
                        passportObj.save();
                        players[playerid].inventory.sync();

                        players[playerid].setData("passport", true);
                        players[playerid].save();

                        complete = true;

                        if(defaulttogooc) setPlayerOOC(playerid, true);

                    }, 30);
                });
            }, 30);
        });
    }, 30);

});


fmd("gov", ["gov.passport"], "$f passport", function(fraction, character, result, targetid = null) {

    // if (!isPlayerInValidPoint(character.playerid, getGovCoords(0), getGovCoords(1), 1.0 )) {
    //     return msg(character.playerid, "passport.toofar", CL_THUNDERBIRD);
    // }

    targetid = toInteger(targetid);

    if (targetid == null || !isPlayerConnected(targetid)) {
        return msg(character.playerid, "admin.error", CL_ERROR);
    }

    switch(result) {
        case "approved":
            players[targetid].setData("passport", "approved");
            msg(character.playerid, "passport.solution.approved", CL_EUCALYPTUS);
        break;
        case "rejected":
            players[targetid].setData("passport", "rejected");
            msg(character.playerid, "passport.solution.rejected", CL_THUNDERBIRD);
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

    "en|passport.rejected"          : "Your passport request has been denied."
    "ru|passport.rejected"          : "Вам отказано в получении паспорта."
    "en|passport.rejected.badname"  : "Reason: Invalid (NON-RP) сharacter name."
    "ru|passport.rejected.badname"  : "Причина: имя персонажа не соответствует временному интервалу игры."

    "en|passport.needsolution"      : "Contact the government official (not NPC) for obtaining a passport."
    "ru|passport.needsolution"      : "Для получения паспорта обратитесь к сотруднику мэрии (реальному живому игроку)."

    "en|passport.solution.invalid"  : "Invalid status."
    "ru|passport.solution.invalid"  : "Статус указан неверно."

    "en|passport.solution.approved" : "You have approved the application for obtaining a passport."
    "ru|passport.solution.approved" : "Вы одобрили заявку на получение паспорта."

    "en|passport.solution.rejected" : "You have rejected/approved the application for obtaining a passport."
    "ru|passport.solution.rejected" : "Вы отклонили заявку на получение паспорта."


    "en|passport.insert.nationality" : "Insert number of nationality:"
    "ru|passport.insert.nationality" : "Укажите номер, соответствующий вашей национальности:"

    "en|passport.insert.hair"       : "Insert number of hair color:"
    "ru|passport.insert.hair"       : "Укажите номер, соответствующий цвету волос:"

    "en|passport.insert.eyes"       : "Insert number of eyes color:"
    "ru|passport.insert.eyes"       : "Укажите номер, соответствующий цвету глаз:"

    "en|passport.insert.incorrect"  : "What are you doing? Try again..."
    "ru|passport.insert.incorrect"  : "Ну, и что ты делаешь? Только бланк испортил..."

    "en|passport.got"               : "You got the passport."
    "ru|passport.got"               : "Вы получили паспорт гражданина США."

    "en|passport.info.title"        : "Passport:"
    "ru|passport.info.title"        : "Паспорт гражданина:"

    "en|passport.info.fio"          : "Firstname Lastname: %s"
    "ru|passport.info.fio"          : "Имя Фамилия: %s"

    "en|passport.info.nationality"  : "Nationality: %s"
    "ru|passport.info.nationality"  : "Национальность: %s"

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
    "ru|passport.sex.0" : "мужской"

    "en|passport.sex.1" : "Woman"
    "ru|passport.sex.1" : "женский"



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

});
