include("modules/shops/cardealer/models/CarDealer.nut");

local coords = [-1586.8, 1694.74, -0.336785, 150.868, 0.000169911, -0.00273992];

local carDealerLoadedData = [];
local availableCars = [0, 1, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15, 17, 18, 22, 23, 25, 28, 29, 30, 31, 32, 41, 43, 44, 45, 46, 47, 48, 50, 52, 53, 54, 56, 57, 59];

local margin_percent = 0.02; // наценка в процентах
local sell_percent = 0.65; // наценка в процентах

local time_to_sale_dealer = 2592000;    // время на продажу дилеру - 30 дней
local time_to_sale = 864000;            // время на продажу игроку - 10 дней
local time_to_await_owner = 432000;     // время ожидания игрока, чтобы забрал авто - 5 дней

event("onServerStarted", function() {
    log("[shops] loading car dealer...");

    // load records (horses and etc.)
    carDealerLoadedDataRead();

    create3DText ( coords[0], coords[1], coords[2]+0.35, "CAR DEALER", CL_ROYALBLUE, 4.0 );
    create3DText ( coords[0], coords[1], coords[2]+0.20, "/dealer", CL_WHITE.applyAlpha(100), 2.0 );

    createBlip  ( -1600.67, 1687.52, [ 25, 0 ], ICON_RANGE_VISIBLE );

    createPlace("CarDealer", -1613.24, 1674.64, -1583.06, 1703.82);
});


event("onServerPlayerStarted", function( playerid ){
    local characterid = players[playerid].id;
    //local temp = clone(carDealerLoadedData);
    local timestamp = getTimestamp();
    foreach (idx, car in carDealerLoadedData) {

        if (car.status == "canceled" || car.status == "completed") {
            continue;
        }

        // отправить на штрафстоянку если владелец не забрал в течение 5 суток с момента окончания срока (15 суток от начала продажи)
        if (timestamp > car.until && car.status == "await_owner") {
            car.status = "canceled";
            car.save();
            local vehicleid = getVehicleIdFromEntityId( car.vehicleid );
            if(setVehicleToCarPound(vehicleid)) {
                local plate = getVehiclePlateText(vehicleid);
                __vehicles[vehicleid].entity.parking = getTimestamp() - 3456000; // поправка на 80 игровых дней, чтобы тачка долго не стояла
                __vehicles[vehicleid].entity.save();
                dbg("chat", "report", "Автодилер", format("Отправил на штрафстоянку автомобиль с номером %s", plate));
                dbg("chat", "police", "Автодилер", format("Отправил на штрафстоянку автомобиль с номером %s", plate));
            } else {
                dbg("chat", "report", "Автодилер", format("Не удалось отправить на штрафстоянку автомобиль с номером %s", plate));
            }
        }

        // снять с продажи если истёк срок, и начать информировать и ждать владельца, чтобы забрал
        if (timestamp > car.until && car.status == "sale") {
            car.status = "await_owner";
            car.until = timestamp + time_to_await_owner;
            car.save();
        }



        if (car.ownerid == characterid && car.status != "completed" && car.status != "canceled") {
            local vehicleid = getVehicleIdFromEntityId( car.vehicleid );
            // если пока игрок отсутствовал, автомобиль был продан и пропал с сервера
            if(!vehicleid) {
              if (car.status == "sold_offline") {
                msg(playerid, "cardealer.soldEarlier", CL_SUCCESS);
                addMoneyToDeposit(playerid, car.price);
                car.status = "completed";
                car.save();
              }
              return;
            }

            local plate   = getVehiclePlateText( vehicleid );
            local modelid = getVehicleModel( vehicleid );
            local modelName = getVehicleNameByModelId( modelid );

            if (car.status == "sale") {
                msg (playerid, "cardealer.onSaleYet", [modelName, plate], CL_SUCCESS);
            }

            if (car.status == "sold_offline") {
                msg(playerid, "cardealer.sold", [modelName, plate], CL_SUCCESS);
                addMoneyToDeposit(playerid, car.price);
                car.status = "completed";
                car.save();
                //carDealerLoadedData.remove(idx);
            }

            if (car.status == "await_owner") {
                msg(playerid, "cardealer.removed", [modelName, plate], CL_WARNING);
            }
        }
    }
});


event ( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    // if (isPlayerVehicleOwner(playerid, vehicleid)) {
    //     return;
    // }

    local entityid = getVehicleEntityId( vehicleid );

    foreach (idx, car in carDealerLoadedData) {
        local characterid = players[playerid].id;

        if (car.vehicleid == entityid && car.status == "await_owner") {
            if(characterid == car.ownerid) {
                return msg(playerid, "cardealer.takeBack", CL_FIREBUSH);
            }

            return msg(playerid, "cardealer.notForSale", CL_FIREBUSH);
        }

        if (car.vehicleid == entityid && car.status == "sale") {
            local margin = car.price * margin_percent;

            if (characterid != car.ownerid) {
                msg(playerid, "cardealer.canBuy", [car.price+margin], CL_FIREBUSH);
                return msg(playerid, "cardealer.hintTaxForBuyers", CL_HELP);
            }

            return msg(playerid, "cardealer.canReturn", [margin], CL_FIREBUSH);
        }
    }
});


event("onPlayerPlaceEnter", function(playerid, name) {
    if (isPlayerInVehicle(playerid) && name == "CarDealer") {
        local vehicleid = getPlayerVehicle(playerid);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
        msg(playerid, "cardealer.enterZone");
        msg(playerid, "cardealer.enterZoneMore");
    }
});

cmd("dealer", function(playerid) {

    local plaPos = getPlayerPosition(playerid);

    if(!isInPlace("CarDealer", plaPos[0], plaPos[1])) {
        return msg(playerid, "cardealer.info.hint", CL_HELP);
    }

    if (!isPlayerInVehicle(playerid)) {
        msg(playerid, "cardealer.info.title", CL_HELP_LINE);
        msg(playerid, "cardealer.info.youcan", CL_HELP);
        msg(playerid, "cardealer.info.buy");
        msg(playerid, "cardealer.info.sell");
        return;
    }

    local vehicleid     = getPlayerVehicle( playerid );
    local vehPos        = getVehiclePosition( vehicleid );
    local modelid       = getVehicleModel( vehicleid );
    local entityid      = getVehicleEntityId( vehicleid );

    if(!isInPlace("CarDealer", vehPos[0], vehPos[1])) {
        return msg(playerid, "cardealer.saleAvailable", CL_ERROR);
    }

    if (!isPlayerHaveVehicleKey(playerid, vehicleid)) {
        return msg(playerid, "cardealer.info.no", CL_ERROR);
    }

    local carInfo = getCarInfoModelById(modelid);

    msg(playerid, "cardealer.info.title", CL_HELP_LINE);
    msg(playerid, "cardealer.info.subtitle", CL_HELP);
    msg(playerid, "cardealer.info.way1");
    msg(playerid, "cardealer.info.way2", [ carInfo.price * sell_percent ]);

})

cmd("dealer", "sell", function(playerid, price) {
    if (!isPlayerInVehicle(playerid)) return;

    local vehicleid     = getPlayerVehicle( playerid );
    local entityid      = getVehicleEntityId( vehicleid );
    local vehPos        = getVehiclePosition( vehicleid );
    local modelid       = getVehicleModel( vehicleid );
    local modelName     = getVehicleNameByModelId( modelid );
    local plate         = getVehiclePlateText(vehicleid);
    local characterid   = getCharacterIdFromPlayerId(playerid);


    if (!isInPlace("CarDealer", vehPos[0], vehPos[1])) {
        return msg(playerid, "cardealer.saleAvailable", CL_ERROR);
    }

    local onsale = false;
    local owned  = false;

    if (isPlayerHaveVehicleKey(playerid, vehicleid)) {
        owned = true;
    }

    foreach (idx, carItem in carDealerLoadedData) {
        if (carItem.vehicleid == entityid) {
            if(carItem.status == "sale") {
                onsale = true;
            }
            if (carItem.ownerid == characterid) {
                owned = true;
            }
        }
    }

    if (!owned) { return msg(playerid, "cardealer.notYourCar", CL_ERROR); }

    if (owned && onsale) {
        return msg(playerid, "cardealer.carAlreadyOnSale", CL_ERROR);
    }

    if (availableCars.find(modelid) == null) {
        return;
    }

    local veh = getVehicleEntity(vehicleid);

    if (veh.data.tax >= 50.0) {
               msg(playerid, "cardealer.needPayTax", CL_ERROR);
        return msg(playerid, "cardealer.hintTaxForSellers", CL_HELP);
    }

    if (!price) {
        return msg(playerid, "cardealer.needPrice", CL_ERROR);
    }

    blockDriving(playerid, vehicleid);

    local positionInInventory = -1;
    foreach (idx, item in players[playerid].inventory) {
        if(item._entity == "Item.VehicleKey") {
            if (item.data.id == entityid) {
                positionInInventory = idx;
                break;
            }
        }
    }

    if (positionInInventory >= 0) {

        local item = players[playerid].inventory.remove(positionInInventory);
        players[playerid].inventory.sync();
        item.remove();
        players[playerid].save()
    }

    local carInfo = getCarInfoModelById(modelid);

    local car = CarDealer();

    // put data
    car.vehicleid  = entityid;
    car.status     = "sale";
    car.created    = getTimestamp();

    if (price == "now") {
        local amount = round(carInfo.price * sell_percent, 2);
        addMoneyToPlayer(playerid, amount);
        car.ownerid = 4;
        car.price = round(carInfo.price * 0.85, 2);
        car.until = car.created.tointeger() + time_to_sale_dealer;
        msg(playerid, "cardealer.soldNow", [ amount ], CL_SUCCESS);
        dbg("chat", "report", getPlayerName(playerid), format("Продал дилеру автомобиль «%s» (%s) за $%.2f", modelName, plate, amount));
    } else {
        car.ownerid = getVehicleOwnerId( vehicleid );
        car.price   = round(fabs(price.tofloat()), 2);
        car.until   = car.created.tointeger() + time_to_sale;
        msg(playerid, "cardealer.onSaleNow", CL_SUCCESS);
        dbg("chat", "report", getPlayerName(playerid), format("Выставил на продажу автомобиль «%s» (%s) за $%.2f", modelName, plate, car.price));
    }
    setVehicleOwner(vehicleid, "[System] CarDealer", 4);
    // insert into database
    car.save();
    carDealerLoadedDataRead();
});


cmd("dealer", "buy", function(playerid) {
    if (!isPlayerInVehicle(playerid)) return;

    local vehicleid     = getPlayerVehicle( playerid );
    local entityid      = getVehicleEntityId( vehicleid );
    local vehPos        = getVehiclePosition( vehicleid );
    local modelid       = getVehicleModel( vehicleid );
    local modelName     = getVehicleNameByModelId( modelid );
    local plate         = getVehiclePlateText( vehicleid );
    local characterid   = players[playerid].id;

    if(!isInPlace("CarDealer", vehPos[0], vehPos[1])) {
        return msg(playerid, "cardealer.action", CL_ERROR);
    }

    if (isPlayerHaveVehicleKey(playerid, vehicleid)) {
        return msg(playerid, "cardealer.thisYourCarAlready", CL_ERROR);
    }

    local onsale = false;
    local car = null;

    foreach (idx, carItem in carDealerLoadedData) {
        if (carItem.vehicleid == entityid) {
            if(carItem.status == "sale") {
                onsale = true;
                car = carItem;
            }
        }
    }

    if(!onsale) {
        return msg(playerid, "cardealer.notForSale", CL_ERROR);
    }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_ERROR);
    }

    local vehicleKey = Item.VehicleKey();
    if (!players[playerid].inventory.isFreeVolume(vehicleKey)) {
        return msg(playerid, "inventory.volume.notenough", CL_ERROR);
    }

    local margin = car.price * margin_percent;
    local amount = car.price + margin;
    local playeridOldOwner = getPlayerIdFromCharacterId(car.ownerid);


    if(playeridOldOwner >= 0) {

    /* возврат авто + оплата комиссии */
        if(playeridOldOwner == playerid) {
            if(!canMoneyBeSubstracted(playerid, margin)) {
                return msg(playerid, "cardealer.notenoughmoney", CL_ERROR);
            }
            subMoneyToPlayer(playerid, margin);
            msg(playeridOldOwner, "cardealer.returnedCar", margin, CL_FIREBUSH);
            car.status = "canceled";
            car.total_price = margin;
            dbg("chat", "report", getPlayerName(playerid), format("Забрал с продажи автомобиль «%s» (%s) за $%.2f", modelName, plate, margin));
        }

    /* покупка авто. продавец онлайн */
        if(playeridOldOwner != playerid) {
            if(!canMoneyBeSubstracted(playerid, amount)) {
                return msg(playerid, "cardealer.notenoughmoney", CL_ERROR);
            }
            subMoneyToPlayer(playerid, amount);
            addMoneyToDeposit(playeridOldOwner, amount);
            msg(playerid, "cardealer.boughtCar", CL_SUCCESS);
            msg(playeridOldOwner, "cardealer.sold", [modelName, plate], CL_FIREBUSH);
            car.total_price = amount;
            car.status = "sold";
            dbg("chat", "report", getPlayerName(playerid), format("Купил автомобиль «%s» (%s) за $%.2f", modelName, plate, amount));
        }
    }

    /* покупка авто. продавец оффлайн */
    if(playeridOldOwner == -1) {
        if(!canMoneyBeSubstracted(playerid, amount)) {
            return msg(playerid, "cardealer.notenoughmoney", CL_ERROR);
        }
        subMoneyToPlayer(playerid, amount);
        msg(playerid, "cardealer.boughtCar", CL_SUCCESS);
        car.total_price = amount;
        car.status = car.ownerid == 4 ? "completed" : "sold_offline";
        dbg("chat", "report", getPlayerName(playerid), format("Купил автомобиль «%s» (%s) за $%.2f (offine)", modelName, plate, amount));
    }

    car.save();

    vehicleKey.setData("id", entityid);
    players[playerid].inventory.push( vehicleKey );
    vehicleKey.save();
    players[playerid].inventory.sync();

    carDealerLoadedDataRead();

    setVehicleOwner(vehicleid, playerid);
    __vehicles[vehicleid].entity.save();
    unblockDriving(vehicleid);

});

cmd("dealer", "take", function(playerid) {
    if (!isPlayerInVehicle(playerid)) return;

    local vehicleid     = getPlayerVehicle( playerid );
    local entityid      = getVehicleEntityId( vehicleid );
    local vehPos        = getVehiclePosition( vehicleid );
    local modelid       = getVehicleModel( vehicleid );
    local modelName     = getVehicleNameByModelId( modelid );
    local plate         = getVehiclePlateText( vehicleid );
    local characterid   = players[playerid].id;

    if(!isInPlace("CarDealer", vehPos[0], vehPos[1])) {
        return msg(playerid, "cardealer.action", CL_ERROR);
    }

    if (isPlayerHaveVehicleKey(playerid, vehicleid)) {
        return msg(playerid, "cardealer.thisYourCarAlready", CL_ERROR);
    }

    local onremoving = false;
    local car = null;

    foreach (idx, carItem in carDealerLoadedData) {
        if (carItem.vehicleid == entityid) {
            if(carItem.status == "await_owner") {
                onremoving = true;
                car = carItem;
            }
        }
    }

    if(!onremoving) {
        return msg(playerid, "cardealer.notForRemoving", CL_ERROR);
    }

    if(characterid != car.ownerid) {
        return msg(playerid, "cardealer.notYourCar", CL_ERROR);
    }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_ERROR);
    }

    local vehicleKey = Item.VehicleKey();
    if (!players[playerid].inventory.isFreeVolume(vehicleKey)) {
        return msg(playerid, "inventory.volume.notenough", CL_ERROR);
    }

    msg(playerid, "cardealer.returnedCarFree", CL_SUCCESS);
    car.status = "canceled";
    car.save();

    vehicleKey.setData("id", entityid);
    players[playerid].inventory.push( vehicleKey );
    vehicleKey.save();
    players[playerid].inventory.sync();

    carDealerLoadedDataRead();

    setVehicleOwner(vehicleid, playerid);
    __vehicles[vehicleid].entity.save();
    unblockDriving(vehicleid);

});

function carDealerLoadedDataRead() {
    CarDealer.findAll(function(err, results) {
        carDealerLoadedData = (results.len()) ? results : [];
    });
}

alternativeTranslate({

    "en|cardealer.info.hint"              :  "Want to see the range or sell your car through a dealer - visit the area in the northwest of Kingston."
    "ru|cardealer.info.hint"              :  "Хочешь посмотреть ассортимент или продать свой автомобиль через дилера - посети площадку на северо-западе Кингстона."

    "en|cardealer.info.youcan"            :  "You can buy or sell car by dealer."
    "ru|cardealer.info.youcan"            :  "Ты можешь купить или продать машину с помощью дилера."

    "en|cardealer.info.buy"               :  "Choose the car on the right hand of the dealer and sit in it to buy. If there are no cars in the area, nobody sells cars through the dealer.   Glance here later."
    "ru|cardealer.info.buy"               :  "Для покупки - выбери автомобиль по правую руку от дилера, и садись в него. Если автомобилей нет, значит сейчас их никто не   продаёт через дилера. В этом случае загляни сюда позже."

    "en|cardealer.info.sell"              :  "Drive the car to the dealer's area and type /dealer in chat to sell."
    "ru|cardealer.info.sell"              :  "Для продажи - загони автомобиль на территорию и напиши /dealer."

    "en|cardealer.onSaleYet"              :  "Your car «%s» with plate %s is on sale now."
    "ru|cardealer.onSaleYet"              :  "Ваш автомобиль «%s» (%s) пока ещё не продан."

    "en|cardealer.soldEarlier"            :  "Your car sold. Money transferred to the bank account."
    "ru|cardealer.soldEarlier"            :  "Ваш автомобиль продан. Деньги переведены на счёт в банк."

    "en|cardealer.sold"                   :  "Your car «%s» with plate %s sold. Money transferred to the bank account."
    "ru|cardealer.sold"                   :  "Ваш автомобиль «%s» (%s) продан. Деньги переведены на счёт в банк."

    "en|cardealer.removed"                :  "Your car «%s» with plate %s is removed from sale due to lack of demand. Take it from the dealer's area as soon as possible, otherwise it will be move to the paid parking, and you will be left without key."
    "ru|cardealer.removed"                :  "Ваш автомобиль «%s» (%s) снят с продажи из-за невостребованности. Заберите его с площадки дилера как можно скорее, иначе он будет отправлен на штрафстоянку, а вы останетесь без ключа."

    "en|cardealer.soldNow"                :  "You sold you car for $%.2f"
    "ru|cardealer.soldNow"                :  "Вы продали автомобиль за $%.2f"

    "en|cardealer.canBuy"                 :  "You can buy this car for $%.2f via /dealer buy"
    "ru|cardealer.canBuy"                 :  "Вы можете купить этот автомобиль за $%.2f: /dealer buy"

    "en|cardealer.canReturn"              :  "This is your car, but it on sale. You can return it with $%.2f commission via /dealer buy"
    "ru|cardealer.canReturn"              :  "Это ваш автомобиль, но он выставлен на продажу. Вы можете забрать его c комиссией в $%.2f: /dealer buy"

    "en|cardealer.takeBack"               :  "This is your car, and it is removed from sale. Take it back via /dealer take"
    "ru|cardealer.takeBack"               :  "Это ваш автомобиль, и он снят с продажи из-за невостребованности. Заберите его: /dealer take"

    "en|cardealer.outofsale"              :  "This is your car, and it is removed from sale. Take it back via /dealer take"
    "ru|cardealer.outofsale"              :  "Это ваш автомобиль, и он снят с продажи из-за невостребованности. Заберите его: /dealer take"

    "en|cardealer.enterZone"              :  "Want to sell car? Park the car neatly."
    "ru|cardealer.enterZone"              :  "Хотите продать автомобиль? Припаркуйтесь аккуратно."

    "en|cardealer.enterZoneMore"          :  "More info: /dealer"
    "ru|cardealer.enterZoneMore"          :  "Подробнее: /dealer"

    "en|cardealer.saleAvailable"          :  "Sale car available only in dealer area."
    "ru|cardealer.saleAvailable"          :  "Выставить автомобиль на продажу можно только на территории дилера."

    "en|cardealer.notYourCar"             :  "This is not your car."
    "ru|cardealer.notYourCar"             :  "Этот автомобиль вам не принадлежит."

    "en|cardealer.carAlreadyOnSale"       :  "This car already on sale."
    "ru|cardealer.carAlreadyOnSale"       :  "Этот автомобиль уже выставлен на продажу."

    "en|cardealer.needValidVehicleTax"    :  "Need valid vehicle tax for car with plate %s minimum for %d days."
    "ru|cardealer.needValidVehicleTax"    :  "Нужна действительная квитанция об оплате налога на автомобиль %s минимум на %d ближайших дней."

    "en|cardealer.needPayTax"             :  "Need to pay off the tax on the vehicle."
    "ru|cardealer.needPayTax"             :  "Необходимо погасить налог на транспортное средство."

    "en|cardealer.hintTaxForSellers"      :  "You can sell vehicle only if tax debt lower than $50."
    "ru|cardealer.hintTaxForSellers"      :  "Вы можете продать автомобиль, только если долг по оплате налога меньше $50."

    "en|cardealer.hintTaxForBuyers"       :  "When buying, keep in mind that tax can be up to $50."
    "ru|cardealer.hintTaxForBuyers"       :  "При покупке учитывайте, что неоплаченный за автомобиль налог может составлять до $50."

    "en|cardealer.needPrice"              :  "You need to set price or sell immediately. More /dealer"
    "ru|cardealer.needPrice"              :  "Необходимо указать цену продажи или продать немедленно. Подробнее /dealer"

    "en|cardealer.onSaleNow"              :  "The car is on sale now."
    "ru|cardealer.onSaleNow"              :  "Вы выставили автомобиль на продажу."

    "en|cardealer.action"                 :  "This action can be carried out only in the dealer's area."
    "ru|cardealer.action"                 :  "Данное действие можно осуществить только на территории дилера."

    "en|cardealer.thisYourCarAlready"     :  "This is your car already."
    "ru|cardealer.thisYourCarAlready"     :  "Этот автомобиль уже ваш."

    "en|cardealer.notForSale"             :  "This car is not for sale."
    "ru|cardealer.notForSale"             :  "Этот автомобиль не выставлен на продажу."

    "en|cardealer.notForRemoving"         :  "This car still is on sale."
    "ru|cardealer.notForRemoving"         :  "Этот автомобиль ещё продаётся."

    "en|cardealer.boughtCar"              :  "You bought this car."
    "ru|cardealer.boughtCar"              :  "Вы приобрели этот автомобиль."

    "en|cardealer.returnedCar"            :  "You returned your car back for $%.2f."
    "ru|cardealer.returnedCar"            :  "Вы забрали автомобиль, заплатив $%.2f."

    "en|cardealer.returnedCarFree"        :  "You returned your car back."
    "ru|cardealer.returnedCarFree"        :  "Вы забрали свой автомобиль."

    "en|cardealer.notenoughmoney"         :   "Not enough money to pay!"
    "ru|cardealer.notenoughmoney"         :   "Увы, у тебя недостаточно денег."

    "en|cardealer.info.no"                :   "No information for this car"
    "ru|cardealer.info.no"                :   "Нет информации по данному автомобилю"


    "en|cardealer.info.title"             :   "================= CAR DEALER =================="
    "ru|cardealer.info.title"             :   "================= АВТОДИЛЕР =================="

    "en|cardealer.info.subtitle"          :   "You can sell your car by two ways:"
    "ru|cardealer.info.subtitle"          :   "Вы можете продать автомобиль двумя способами:"

    "en|cardealer.info.way1"              :   "1. Set price and await a customer: /dealer sell 100, where 100 is price"
    "ru|cardealer.info.way1"              :   "1. Указать цену и ждать: /dealer sell 100, где 100 - цена в $"

    "en|cardealer.info.way2"              :   "2. Sell now for $%.2f: /dealer sell now"
    "ru|cardealer.info.way2"              :   "2. Продать сейчас же за $%.2f: /dealer sell now"

});
