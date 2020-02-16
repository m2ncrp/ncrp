local rentcars = {};

function getPlayerWhoRentVehicle(vehicleid) {
    local vehid = getVehicleEntityId(vehicleid);
    return (vehid in rentcars) ? rentcars[vehid] : null;
}

function RentCar(playerid) {
    local vehicleid = getPlayerVehicle(playerid);
    local minute = getMinute().tofloat();
    local minutesleft = ceil( minute / 10 ) * 10 - minute; // minutes to near largest round number: if minute == 36 then minutesleft = 4
    if (minutesleft == 0) { minutesleft = 10; }
    local rentprice = round(getVehicleRentPrice(vehicleid).tofloat() / 60.0 * minutesleft, 2);

    if(!canMoneyBeSubstracted(playerid, rentprice)) {
        return msg(playerid, "rentcar.notenough");
    }

    local veh = getVehicleEntity(vehicleid);
    local charid = getCharacterIdFromPlayerId(playerid);
    rentcars[veh.id] <- charid;
    unblockDriving(vehicleid);

    setVehicleRespawnEx(vehicleid, false);

    subMoneyToPlayer( playerid, rentprice );
    veh.data.rent.money += rentprice;
    veh.data.rent.count += 1;
    msg(playerid, "rentcar.rented");
    msg(playerid, "rentcar.paidcar", [ rentprice ] );
}
addEventHandler("RentCar", RentCar);

// need changed
function RentCarRefuse(playerid) {
    if(isPlayerCarRent(playerid)) {
        local vehicleid = getPlayerVehicle(playerid);
        blockDriving(playerid, vehicleid);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
    }
    local charid = getCharacterIdFromPlayerId(playerid);
    foreach (vehid, value in rentcars) {
        if (value == charid) {
            delete rentcars[vehid];
            local vehicleid = getVehicleIdFromEntityId(vehid);
            setVehicleRespawnEx(vehicleid, true);
        }
    }
    msg(playerid, "rentcar.refused");
}

event("onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if(isVehicleCarRent(vehicleid) && seat == 0) {
        local charid = getCharacterIdFromPlayerId(playerid);
        local whorent = getPlayerWhoRentVehicle(vehicleid);
        local ownerId = getVehicleOwnerId(vehicleid);

        if(whorent != charid) {
            blockDriving(playerid, vehicleid);

            // Сел владелец автомобиля
            if(ownerId == charid) {
                // И автомобиль не занят
                msg(playerid, "");
                if(whorent == null) {
                    msg(playerid, "Это ваш автомобиль и он сдаётся в аренду.", CL_HELP);
                    msg(playerid, "Вы можете:", CL_JORDYBLUE);
                    msg(playerid, "- посмотреть сведения об аренде: /lease stats", CL_JORDYBLUE);
                    msg(playerid, "- снять автомобиль с аренды: /lease stop", CL_JORDYBLUE);
                } else {
                    msg(playerid, "Это ваш автомобиль и он сейчас арендован.", CL_HELP);
                    msg(playerid, "Когда текущая аренда будет завершена, вы сможете снять автомобиль с аренды или посмотреть сведения о ней.", CL_JORDYBLUE);
                }
            } else {
                if(checkPlayerSectionData(playerid, "rent")) {
                    if(players[playerid].data.rent.accessible) {
                        showRentCarGUI(playerid, vehicleid);
                    } else {
                        msg(playerid, "Вам недоступна возможность аренды автомобиля", CL_ERROR);
                    }
                } else {
                    msg(playerid, "rentcar.rent.dontknow", CL_HELP);
                    msg(playerid, "rentcar.explorecity", CL_HELP);
                }
            }
            trigger(playerid, "onServerShowChatTrigger");
        } else {
            unblockDriving(vehicleid);
        }
    }
});

event("onPlayerVehicleExit", function ( playerid, vehicleid, seat ) {
    local vehid = getVehicleEntityId(vehicleid);
    if (vehid in rentcars && seat == 0) {
        blockDriving(playerid, vehicleid);
    }
});

event("onPlayerDisconnect", function ( playerid, reason ) {
    local charid = getCharacterIdFromPlayerId(playerid);
    foreach (vehid, value in rentcars) {
        if (value == charid) {
            local vehicleid = getVehicleIdFromEntityId(vehid);
            blockDriving(playerid, vehicleid);
            setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
            delete rentcars[vehid];
            setVehicleRespawnEx(vehicleid, true);
        }
    }
});

event("onServerMinuteChange", function() {
    if (((getMinute()+1) % 10.0) != 0) {
        return;
    }

    foreach (vehid, value in rentcars) {
        local vehicleid = getVehicleIdFromEntityId(vehid);

        local charid = value;
        local playerid = getPlayerIdFromCharacterId(charid);
        local price = getVehicleRentPrice(vehicleid).tofloat();
        if(!canMoneyBeSubstracted(playerid, price)) {
            blockDriving(playerid, vehicleid);
            setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
            delete rentcars[vehid];
            setVehicleRespawnEx(vehicleid, true);
            msg(playerid, "rentcar.cantrent");
        } else {
            local rentprice = round(price / 60 * 10, 2);
            subMoneyToPlayer(playerid, rentprice );
            local veh = getVehicleEntity(vehicleid);
            veh.data.rent.money += rentprice;
            // addMoneyToTreasury(rentprice);
            msg(playerid, "rentcar.paidcar", [ rentprice ] );
            msg(playerid, "rentcar.refuse");
        }
    }
});

event("onPlayerPhoneCall", function(playerid, number, place) {
    if(number == "0192") {
        carRentalCall(playerid)
    }
});

function showRentCarGUI(playerid, vehicleid){
    local windowText =  plocalize(playerid, "rentcar.gui.window");
    local labelText =   plocalize(playerid, "rentcar.gui.canrent", [getVehicleRentPrice(vehicleid)]);
    local button1Text = plocalize(playerid, "rentcar.gui.buttonRent");
    local button2Text = plocalize(playerid, "rentcar.gui.buttonRefuse");
    triggerClientEvent(playerid, "showRentCarGUI", windowText,labelText,button1Text,button2Text);
}

alternativeTranslate({
    "ru|rentcar.goto"           : "Отправляйтесь на парковку авто, предоставляемых в аренду, в Северном Милвилле."
    "ru|rentcar.notrent"        : "Этот автомобиль нельзя арендовать."
    "ru|rentcar.notenough"      : "У вас недостаточно денег."
    "ru|rentcar.rented"         : "Вы арендовали этот автомобиль. Отказаться от аренды: /unrent"
    "ru|rentcar.refused"        : "Вы отказались от аренды. Благодарим за выбор Car Rental!"
    "ru|rentcar.cantrent"       : "У вас закончились деньги, аренда приостановлена. Пожалуйста, покиньте автомобиль."
    "ru|rentcar.paidcar"        : "Вы заплатили за аренду автомобиля $%.2f."
    "ru|rentcar.refuse"         : "Отказаться от аренды: /unrent"
    "ru|rentcar.notenoughbill"  : "Недостаточно денег на балансе автомобиля"
    "ru|rentcar.rent.dontknow"  : "Вы пока не знаете как арендовать автомобиль."
    "ru|rentcar.lease.dontknow" : "Вы пока не знаете как сдать автомобиль в аренду."
    "ru|rentcar.explorecity"    : "Изучите город в поисках дополнительной информации."

    // Для GUI
    "ru|rentcar.gui.window"         : "Аренда автомобиля"
    "ru|rentcar.gui.buttonRent"     : "Арендовать"
    "ru|rentcar.gui.buttonRefuse"   : "Отказаться"
    "ru|rentcar.gui.canrent"        : "Вы можете взять этот автомобиль в аренду.\nЦена: $%.2f в час (игровой)."

    "en|rentcar.goto"                      : "Go to parking CAR RENTAL in North Millville to rent a car."
    "en|rentcar.notrent"                   : "This car can not be rented."
    "en|rentcar.notenough"                 : "You don't have enough money."
    "en|rentcar.rented"                    : "You rented this car. If you want to refuse from rent: /unrent"
    "en|rentcar.refused"                   : "You refused from rent all cars. Thank you for choosing North Millville Car Rental!"
    "en|rentcar.cantrent"                  : "You can't drive this car more, because you don't have enough money. Please, get out of the car."
    "en|rentcar.paidcar"                   : "You paid for car $%.2f."
    "en|rentcar.refuse"                    : "If you want to refuse from rent: /unrent"
    "en|rentcar.notenoughbill"             : "Not enough money on vehicle bill"

    //GUI
    "en|rentcar.gui.window"                : "Car rent"
    "en|rentcar.gui.buttonRent"            : "Rent"
    "en|rentcar.gui.buttonRefuse"          : "Refuse"
    "en|rentcar.gui.canrent"               : "You can rent this car.\nPrice: $%.2f in hour (in game)"

})

    // UPDATE tbl_characters SET data = JSON_SET(data, '$.jobs.police.count', 0) WHERE job like "police%";
    // select json_extract(data, '$.passport') from tbl_characters;

    // local qc = ORM.Query("select * from tbl_items where _entity = 'Item.Passport' and data->'$.fio' = concat(:firstname, ' ', :lastname) and STR_TO_DATE(data->'$.expires','\"%d.%m.%Y\"') >= STR_TO_DATE(:date, '%d.%m.%Y')");
    //local q = ORM.Query("SELECT json_extract(data, '$.jobs') FROM tbl_characters WHERE id = 2")
    // q.setParameter("charid", charid);



function disableRentForPlayer(charid) {
    local q = ORM.Query("SELECT data FROM tbl_characters WHERE id = :charid")
    req.setParameter("charid", charid);

    local data = null;
    q.getResult(function(err, results) {
        return results.map(function(item) {
            data = JSONParser.parse(item.data);
            data.rent.accessible = false;
            local req = ORM.Query("UPDATE tbl_characters SET data = :data WHERE id = :charid")
            req.setParameter("charid", charid);
            req.setParameter("data", JSONEncoder.encode(data));
        })
    });
}


// local q = ORM.Query("SELECT data FROM tbl_characters WHERE id = 2")
