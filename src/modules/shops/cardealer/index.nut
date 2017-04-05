include("modules/shops/cardealer/models/CarDealer.nut");

local coords = [-1586.8, 1694.74, -0.336785, 150.868, 0.000169911, -0.00273992];

local carDealerLoadedData = [];
local availableCars = [0, 1, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15, 17, 18, 22, 23, 25, 28, 29, 30, 31, 32, 41, 43, 44, 45, 46, 47, 48, 50, 52, 53];

local margin_percent = 5; // наценка в процентах

event("onServerStarted", function() {
    log("[shops] car dealer...");

    // load records (horses and etc.)
    carDealerLoadedDataRead();

    create3DText ( coords[0], coords[1], coords[2]+0.35, "CAR DEALER", CL_ROYALBLUE, 4.0 );
    create3DText ( coords[0], coords[1], coords[2]+0.20, "/dealer", CL_WHITE.applyAlpha(100), 2.0 );

    createBlip  ( -1600.67, 1687.52, [ 25, 0 ], 4000.0 );

    createPlace("CarDealer", -1613.24, 1674.64, -1583.06, 1703.82);
});


event("onServerPlayerStarted", function( playerid ){
    local characterid = players[playerid].id;
    local temp = clone(carDealerLoadedData);
    foreach (idx, car in temp) {
        if (car.ownerid == characterid) {
            local vehicleid = getVehicleIdFromEntityId( car.vehicleid );
            local plate   = getVehiclePlateText( vehicleid );
            local modelid = getVehicleModel( vehicleid );
            local modelName = getVehicleNameByModelId( modelid );

            if(car.sold == 0) {
                msg (playerid, "cardealer.onSaleYet", [modelName, plate], CL_SUCCESS);
            } else {
                msg (playerid, "cardealer.Sold", [modelName, plate], CL_SUCCESS);
                addMoneyToDeposit(playerid, car.price);
                car.remove();
                carDealerLoadedData.remove(idx);
            }
        }
    }
});


event ( "onPlayerVehicleEnter", function ( playerid, vehicleid, seat ) {
    if (isPlayerVehicleOwner(playerid, vehicleid)) {
        return;
    }

    local entityid = getVehicleEntityId( vehicleid );

    foreach (idx, car in carDealerLoadedData) {
        if (car.vehicleid == entityid && car.sold == 0) {
            local characterid = players[playerid].id;

            local margin = car.price / 100 * margin_percent;

            if (characterid != car.ownerid) {
                return msg(playerid, "cardealer.canBuy", [car.price+margin], CL_FIREBUSH);
            }

            return msg(playerid, "cardealer.canReturn", [margin], CL_FIREBUSH);
        }
    }
});


event("onPlayerPlaceEnter", function(playerid, name) {
    if (isPlayerInVehicle(playerid) && name == "CarDealer") {
        local vehicleid = getPlayerVehicle(playerid);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
    }
});

cmd("dealer", "sell", function(playerid, price) {
    if (!isPlayerInVehicle(playerid)) return;

    local vehicleid     = getPlayerVehicle( playerid );
    local vehPos        = getVehiclePosition( vehicleid );
    local modelid       = getVehicleModel( vehicleid );
    local entityid      = getVehicleEntityId( vehicleid );
    local characterid   = players[playerid].id;

    if(!isInPlace("CarDealer", vehPos[0], vehPos[1])) {
        return msg(playerid, "cardealer.saleAvailable", CL_ERROR);
    }

    local onsale = false;
    local owned  = false;
    if (isPlayerVehicleOwner(playerid, vehicleid)) {
        owned = true;
    }

    foreach (idx, car in carDealerLoadedData) {
        if (car.vehicleid == entityid && car.sold == 0 ) {
            onsale = true;
        }
        if (car.ownerid == characterid) {
            owned = true;
        }
    }

    if(!owned) { return msg(playerid, "cardealer.notYourCar", CL_ERROR); }

    if(owned && onsale) {  return msg(playerid, "cardealer.carAlreadyOnSale", CL_ERROR); }

    if(isPlayerVehicleInPlayerFraction(playerid)) {
        return msg(playerid, "cardealer.cantOffer", CL_ERROR);
    }

    if( availableCars.find(modelid) == null || isPlayerVehicleOwner(playerid, vehicleid) == false) {
        return;
    }

    if (!price) {
        return msg(playerid, "cardealer.needPrice", CL_ERROR);
    }

    local car = CarDealer();

    // put data
    car.vehicleid  = entityid;

    car.price = round(fabs(price.tofloat()), 2);
    car.ownerid  = getVehicleOwnerId( vehicleid );
    car.sold  = 0;
    // insert into database
    car.save();
    carDealerLoadedDataRead();

    setVehicleOwner(vehicleid, "[System] CarDealer", 4);
    blockVehicle(vehicleid);

    msg(playerid, "cardealer.onSaleNow", CL_SUCCESS);
});


cmd("dealer", "buy", function(playerid) {
    if (!isPlayerInVehicle(playerid)) return;

    local vehicleid     = getPlayerVehicle( playerid );
    local vehPos        = getVehiclePosition( vehicleid );
    local modelid       = getVehicleModel( vehicleid );
    local entityid      = getVehicleEntityId( vehicleid );
    local characterid   = players[playerid].id;

    if(!isInPlace("CarDealer", vehPos[0], vehPos[1])) {
        return msg(playerid, "cardealer.buyingAvailable", CL_ERROR);
    }

    local onsale = false;
    if (isPlayerVehicleOwner(playerid, vehicleid)) {
        return msg(playerid, "cardealer.thisYourCarAlready", CL_ERROR);
    }


    local carInfo = null;
    CarDealer.findBy({ vehicleid = entityid }, function(err, cars) {
        foreach (idx, car in cars) {
            if (car.vehicleid == entityid && car.sold == 0 ) {
                onsale = true;
                carInfo = car;
            }
        }
    });

    if(!onsale) { return msg(playerid, "cardealer.notForSale", CL_ERROR); }

    local margin = carInfo.price / 100 * margin_percent;
    local amount = carInfo.price + margin;
    local playeridOldOwner = getPlayerIdFromCharacterId(carInfo.ownerid);

    if(playeridOldOwner != false) {

    /* возврат авто + оплата комиссии */
        if(playeridOldOwner == playerid) {
            if(!canMoneyBeSubstracted(playerid, margin)) {
                return msg(playerid, "cardealer.notenoughmoney", CL_ERROR);
            }
            subMoneyToPlayer(playerid, margin);
            addMoneyToTreasury(margin);
            msg(playeridOldOwner, "cardealer.returnedCar", margin, CL_FIREBUSH);
            carInfo.remove();
        }

    /* покупка авто. продавец онлайн */
        if(playeridOldOwner != playerid) {
            if(!canMoneyBeSubstracted(playerid, amount)) {
                return msg(playerid, "cardealer.notenoughmoney", CL_ERROR);
            }
            subMoneyToPlayer(playerid, amount);
            addMoneyToDeposit(playeridOldOwner, amount);
            msg(playerid, "cardealer.boughtCar", CL_SUCCESS);
            local plate   = getVehiclePlateText( vehicleid );
            local modelName = getVehicleNameByModelId( modelid );
            msg(playeridOldOwner, "cardealer.Sold", [modelName, plate], CL_FIREBUSH);
            carInfo.remove();
        }
    }

    /* покупка авто. продавец оффлайн */
    if(playeridOldOwner == false) {
        if(!canMoneyBeSubstracted(playerid, amount)) {
            return msg(playerid, "cardealer.notenoughmoney", CL_ERROR);
        }
        subMoneyToPlayer(playerid, amount);
        msg(playerid, "cardealer.boughtCar", CL_SUCCESS);
        carInfo.sold = 1;
        carInfo.save();
    }

    carDealerLoadedDataRead();

    setVehicleOwner(vehicleid, playerid);
    __vehicles[vehicleid].entity.save();
    unblockVehicle(vehicleid);

});

function carDealerLoadedDataRead() {
    CarDealer.findAll(function(err, results) {
        carDealerLoadedData = (results.len()) ? results : [];
    });
}


// usage: /dealer
cmd("dealer",  function(playerid) {
    carDealerHelp ( playerid );
});


function carDealerHelp ( playerid ) {
    local title = "cardealer.help.title";
    local commands = [
        { name = "cardealer.help.cmd.sell",       desc = "cardealer.help.sell" },
        { name = "cardealer.help.cmd.buy",        desc = "cardealer.help.buy" },
    ];
    msg_help(playerid, title, commands);
}


alternativeTranslate({

    "en|cardealer.onSaleYet"              :  "Your car «%s» with plate %s is on sale now."
    "ru|cardealer.onSaleYet"              :  "Ваш автомобиль «%s» (%s) пока ещё не продан."

    "en|cardealer.Sold"                   :  "Your car «%s» with plate %s sold."
    "ru|cardealer.Sold"                   :  "Ваш автомобиль «%s» (%s) продан. Деньги переведены на счёт в банк."

    "en|cardealer.canBuy"                 :  "You can buy this car for $%.2f via /dealer buy"
    "ru|cardealer.canBuy"                 :  "Вы можете купить этот автомобиль за $%.2f: /dealer buy"

    "en|cardealer.canReturn"              :  "This is your car, but it on sale. You can return it with $%.2f commission via /dealer buy"
    "ru|cardealer.canReturn"              :  "Это ваш автомобиль, но он выставлен на продажу. Вы можете забрать его c комиссией в $%.2f: /dealer buy"

    "en|cardealer.saleAvailable"          :  "Sale car available only in dealer area."
    "ru|cardealer.saleAvailable"          :  "Выставить автомобиль на продажу можно только на территории дилера."

    "en|cardealer.notYourCar"             :  "This is not your car."
    "ru|cardealer.notYourCar"             :  "Этот автомобиль вам не принадлежит."

    "en|cardealer.carAlreadyOnSale"       :  "This car already on sale."
    "ru|cardealer.carAlreadyOnSale"       :  "Этот автомобиль уже выставлен на продажу."

    "en|cardealer.cantOffer"              :  "You can't offer the car for sale, which is in fraction."
    "ru|cardealer.cantOffer"              :  "Вы не можете выставить на продажу автомобиль, который числится на балансе фракции."

    "en|cardealer.needPrice"              :  "You need to set price via /dealer sell 1000"
    "ru|cardealer.needPrice"              :  "Необходимо указать цену продажи. Например /dealer sell 1000"

    "en|cardealer.needPrice"              :  "You need to set price via /dealer sell 1000"
    "ru|cardealer.needPrice"              :  "Необходимо указать цену продажи. Например /dealer sell 1000"

    "en|cardealer.onSaleNow"              :  "The car is on sale now."
    "ru|cardealer.onSaleNow"              :  "Вы выставили автомобиль на продажу."

    "en|cardealer.buyingAvailable"        :  "Buying car available only in dealer area."
    "ru|cardealer.buyingAvailable"        :  "Приобрести автомобиль можно только на территории дилера."

    "en|cardealer.thisYourCarAlready"     :  "This is your car already."
    "ru|cardealer.thisYourCarAlready"     :  "Этот автомобиль уже ваш."

    "en|cardealer.notForSale"             :  "This car is not for sale."
    "ru|cardealer.notForSale"             :  "Этот автомобиль не выставлен на продажу."

    "en|cardealer.boughtCar"              :  "You bought this car."
    "ru|cardealer.boughtCar"              :  "Вы приобрели этот автомобиль."

    "en|cardealer.returnedCar"            :  "You returned your car back with $%.2f commission."
    "ru|cardealer.returnedCar"            :  "Вы забрали автомобиль с комиссией в $%.2f."

    "en|cardealer.notenoughmoney"         :   "Not enough money to pay!"
    "ru|cardealer.notenoughmoney"         :   "Увы, у тебя недостаточно денег."

    "en|cardealer.help.title"             :   "List of available commands for CAR DEALER:"
    "ru|cardealer.help.title"             :   "Список доступных команд у автодилера:"

    "en|cardealer.help.cmd.sell"          :   "/dealer sell PRICE"
    "ru|cardealer.help.cmd.sell"          :   "/dealer sell ЦЕНА"

    "en|cardealer.help.sell"              :   "Sell car (need to be in car). 5 percent of price will be added to the final price. Example: /dealer sell 1000"
    "ru|cardealer.help.sell"              :   "Выставить авто на продажу (нужно быть за рулём). К конечной цене будет прибавлено 5 процентов от указанной суммы. Образец: /dealer sell 1000"

    "en|cardealer.help.cmd.buy"           :   "/dealer buy"
    "ru|cardealer.help.cmd.buy"           :   "/dealer buy"

    "en|cardealer.help.buy"               :   "Buy car (need to be in car)"
    "ru|cardealer.help.buy"               :   "Купить автомобиль (нужно быть за рулём)"
});
