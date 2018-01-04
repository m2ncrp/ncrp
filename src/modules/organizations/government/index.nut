// nothing there yet :p
local coords = [-122.331, -62.9116, -12.041];
local tax_fixprice = 20.0;
local tax = 0.025;  // 2 percents

event("onServerStarted", function() {
    log("[organizations] government...");

    create3DText ( coords[0], coords[1], coords[2]+0.35, "SECRETARY OF GOVERNMENT", CL_ROYALBLUE);
    create3DText ( coords[0], coords[1], coords[2]+0.20, "/tax | /passport", CL_WHITE.applyAlpha(100), 2.0 );

    createBlip  ( coords[0], coords[1], [ 24, 0 ], 4000.0 );

});


alternativeTranslate({

    "en|tax.help.title"  : "Tax for vehicle:"
    "ru|tax.help.title"  : "Налог на автомобиль:"

    "en|tax.help.tax"    : "/tax  PlateNumber"
    "ru|tax.help.tax"    : "/tax  НомерАвтомобиля"

    "en|tax.help.desc"   : "Pay tax"
    "ru|tax.help.desc"   : "Оплатить налог"

    "en|tax.toofar"      : "You can pay tax at city government."
    "ru|tax.toofar"      : "Оплатить налог можно в мэрии города."

    "en|tax.notrequired" : "This car not required to tax."
    "ru|tax.notrequired" : "Указанный автомобиль не облагается налогом."

    "en|tax.payed"       : "You payed tax $%.2f for vehicle with plate %s."
    "ru|tax.payed"       : "Вы оплатили налог $%.2f за автомобиль с номером %s."

    "en|tax.money.notenough"  : "Not enough money. Need $%.2f."
    "ru|tax.money.notenough"  : "Недостаточно денег. Для оплаты требуется $%.2f."

    "en|tax.info.title"       : "Information about tax for vehicle:"
    "ru|tax.info.title"       : "Информация об оплате налога на автомобиль:"

    "en|tax.info.plate"       : "Plate: %s"
    "ru|tax.info.plate"       : "Номер: %s"

    "en|tax.info.model"       : "Model: %s"
    "ru|tax.info.model"       : "Модель: %s"

    "en|tax.info.issued"      : "Date of issue: %s"
    "ru|tax.info.issued"      : "Выдан: %s"

    "en|tax.info.expires"     : "Date of expiration: %s"
    "ru|tax.info.expires"     : "Истекает: %s"



    "en|passport.help.title"        : "Passport:"
    "ru|passport.help.title"        : "Паспорт гражданина:"

    "en|passport.help.passport"     : "/passport get"
    "ru|passport.help.passport"     : "/passport get"

    "en|passport.help.desc"         : "Get passport"
    "ru|passport.help.desc"         : "Получить пасспорт"

    "en|passport.toofar"            : "You can get passport at city government."
    "ru|passport.toofar"            : "Получить пасспорт можно в мэрии города."

    "en|passport.alreadyget"        : "You have a passport already."
    "ru|passport.alreadyget"        : "Вы уже получали паспорт."

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

});

function taxHelp( playerid ) {
    local title = "tax.help.title";
    local commands = [
        { name = "tax.help.tax",    desc = "tax.help.desc" }
    ];
    msg_help(playerid, title, commands);
}


cmd("tax", function( playerid, plateText = 0 ) {

    if (plateText == 0) {
        return taxHelp( playerid );
    }

    if (!isPlayerInValidPoint(playerid, coords[0], coords[1], 1.0 )) {
        return msg(playerid, "tax.toofar", CL_THUNDERBIRD);
    }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local taxObj = Item.VehicleTax();
    if (!players[playerid].inventory.isFreeWeight(taxObj)) {
        return msg(playerid, "inventory.weight.notenough", CL_THUNDERBIRD);
    }

    local plateText = plateText.toupper();
    local vehicleid = getVehicleByPlateText(plateText.toupper());
    if(vehicleid == null) {
        return msg( playerid, "parking.checkPlate");
    }

    local modelid = getVehicleModel( vehicleid );
    local carInfo = getCarInfoModelById( modelid );

    if (carInfo == null || isVehicleCarRent(vehicleid)) {
        return msg(playerid, "tax.notrequired");
    }

    local price = tax_fixprice + carInfo.price * tax;
    if (!canMoneyBeSubstracted(playerid, price)) {
        return msg(playerid, "tax.money.notenough", [ price ], CL_THUNDERBIRD);
    }

    msg(playerid, "tax.payed", [ price, plateText ], CL_SUCCESS);
    subMoneyToPlayer(playerid, price);

    taxObj.setData("plate", plateText);
    taxObj.setData("model",  modelid );

    local day   = getDay();
    local month = getMonth() + 1;
    local year  = getYear();
    if (month == 13) { month = 1; year += 1; }
    if (day < 10)   { day = "0"+day; }
    if (month < 10) { month = "0"+month; }
    taxObj.setData("issued",  getDate());
    taxObj.setData("expires", day+"."+month+"."+year);

    players[playerid].inventory.push( taxObj );
    taxObj.save();
    players[playerid].inventory.sync();

});


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

    if (!isPlayerInValidPoint(playerid, coords[0], coords[1], 1.0 )) {
        return msg(playerid, "passport.toofar", CL_THUNDERBIRD);
    }

    if ("passport" in players[playerid].data) {
        if (players[playerid].data.passport == true) {
            return msg(playerid, "passport.alreadyget", CL_THUNDERBIRD);
        }
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


    //nationality
    msg(playerid, "passport.insert.nationality", CL_CHESTNUT2);

    for (local i = 1; i <= 10; i++) {
        msg(playerid,  i+". "+ plocalize(playerid, "passport.nationality."+sex+"-"+i));
    }

    trigger(playerid, "hudCreateTimer", 60, true, true);

    requestUserInput(playerid, function(playerid, text) {
        trigger(playerid, "hudDestroyTimer");

        if (!text || !isNumeric(text) || text.tointeger() < 1 || text.tointeger() > 10) {
            if(defaulttogooc) setPlayerOOC(playerid, true);
            return msg(playerid, "passport.insert.incorrect", CL_THUNDERBIRD);
        }
        passportObj.setData("nationality", text.tointeger());

        //hair color
        msg(playerid, "passport.insert.hair", CL_CHESTNUT2);

        for (local i = 1; i <= 9; i++) {
            msg(playerid,  i+". "+ plocalize(playerid, "passport.hair."+i));
        }

        trigger(playerid, "hudCreateTimer", 60, true, true);

        delayedFunction( 1000, function() {
            requestUserInput(playerid, function(playerid, text) {
                trigger(playerid, "hudDestroyTimer");
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

                trigger(playerid, "hudCreateTimer", 60, true, true);

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
                        local year  = getYear() + 1;
                        if (month < 10) { month = "0"+month; }
                        passportObj.setData("issued",  getDate());
                        passportObj.setData("expires", day+"."+month+"."+year);

                        players[playerid].inventory.push( passportObj );
                        passportObj.save();
                        players[playerid].inventory.sync();

                        players[playerid].setData("passport", true);
                        players[playerid].save();

                        if(defaulttogooc) setPlayerOOC(playerid, true);

                    }, 60);
                });
            }, 60);
        });
    }, 60);

});
