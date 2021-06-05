include("modules/shops/cardealer/models/CarDealer.nut");

local coords = [-1586.8, 1694.74, -0.336785, 150.868, 0.000169911, -0.00273992];

local carDealerLoadedData = [];
local availableCars = [0, 1, 4, 6, 7, 8, 9, 10, 12, 13, 14, 15, 17, 18, 22, 23, 25, 28, 29, 30, 31, 32, 41, 43, 44, 45, 46, 47, 48, 50, 52, 53, 54, 56, 57, 59];

local margin_percent = 0.02; // наценка в процентах  // deprecated
local sell_percent = 0.65; // наценка в процентах    // deprecated
local tax_limit = 25.0;                              // deprecated

local dealer_purchase_percent = 0.65;
local dealer_sale_percent = 0.65;
local dealer_margin_percent = 0.02;

local time_to_sale_dealer = 86400 * 30;    // время на продажу дилеру - 30 дней
local time_to_sale        = 86400 * 10;    // время на продажу игроку - 10 дней
local time_to_await_owner = 86400 * 15;    // время ожидания игрока, чтобы забрал авто - 15 дней

event("onServerStarted", function() {
    logStr("[shops] loading car dealer...");

    // load records (horses and etc.)
    carDealerLoadedDataRead();

    create3DText ( coords[0], coords[1], coords[2]+0.35, "CAR DEALER", CL_ROYALBLUE, 4.0 );
    create3DText ( coords[0], coords[1], coords[2]+0.20, "/dealer", CL_WHITE.applyAlpha(100), 2.0 );

    createBlip  ( -1600.67, 1687.52, [ 25, 0 ], ICON_RANGE_VISIBLE );

    createPlace("CarDealer", -1613.24, 1674.64, -1583.06, 1703.82);
});


event("onServerHourChange", function() {
    local timestamp = getTimestamp();

    foreach (idx, deal in carDealerLoadedData) {

        if (["canceled", "completed", "deleted"].find(deal.status) != null) {
            continue;
        }

        // снять с продажи если истёк срок, и начать информировать и ждать владельца, чтобы забрал
        if (deal.status == "sale" && timestamp > deal.until) {
            deal.status = "await_owner";
            deal.until = timestamp + time_to_await_owner;
            deal.save();
        }

        // удалить автомобиль если владелец не забрал в течение срока возврата
        if (timestamp > deal.until && deal.status == "await_owner") {
            local vehicleid = getVehicleIdFromEntityId( deal.vehid );
            __vehicles[vehicleid].entity.deleted = 1;
            __vehicles[vehicleid].entity.save();
            deal.status = "deleted";
            deal.save();
            dbg("chat", "report", "Автодилер", format("Удалил автомобиль %s с номером %s", deal.data.modelName, deal.data.plate));
        }
    }
});


event("onServerPlayerStarted", function(playerid) {
    local characterid = players[playerid].id;

    local timestamp = getTimestamp();
    foreach (idx, deal in carDealerLoadedData) {

        if (deal.seller_id != characterid || (["canceled", "completed"].find(deal.status) != null)) {
            continue;
        }

        local modelName = deal.data.modelName;
        local plate = deal.data.plate;

        if (deal.status == "sale") {
            msg(playerid, "cardealer.onSaleYet", [modelName, plate], CL_SUCCESS);
            continue;
        }

        if (deal.status == "await_owner") {
            msg(playerid, "cardealer.await-owner", [modelName, plate], CL_WARNING);
            continue;
        }

        if (deal.status == "money_transfer") {
            msg(playerid, "cardealer.sold", [deal.data.modelName, deal.data.plate, deal.price], CL_SUCCESS);
            addMoneyToDeposit(playerid, deal.price);
            deal.status = "completed";
            deal.reason = "sold offline, money transferred successfully";
            deal.save();
            continue;
        }

        if (deal.status == "deleted") {
            msg(playerid, "cardealer.deleted", [modelName, plate], CL_WARNING);
            deal.status = "canceled";
            deal.reason = "car has been deleted";
            deal.save();
            continue;
        }
    }
});


event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    local veh = getVehicleEntity(vehicleid);

    if (!veh) return;

    local entityid = veh.id;

    foreach (idx, deal in carDealerLoadedData) {
        local characterid = players[playerid].id;

        if (deal.vehid == entityid && deal.status == "await_owner") {
            if(characterid == deal.seller_id) {
                return msg(playerid, "cardealer.outofsale", CL_FIREBUSH);
            }

            return msg(playerid, "cardealer.notForSale", CL_FIREBUSH);
        }

        if (deal.vehid == entityid && deal.status == "sale") {
            local margin = deal.price * margin_percent;

            if (characterid != deal.seller_id) {
                msg(playerid, "cardealer.canBuy", [deal.price+margin], CL_FIREBUSH);
                msg(playerid, "cardealer.unpaid-tax", [veh.data.tax.tofloat()], CL_ERROR);
                return;
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
        return msg(playerid, "cardealer.action", CL_ERROR);
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
        return msg(playerid, "cardealer.action", CL_ERROR);
    }

    local onsale = false;
    local owned  = false;

    if (isPlayerHaveVehicleKey(playerid, vehicleid)) {
        owned = true;
    }

    foreach (idx, carItem in carDealerLoadedData) {
        if (carItem.vehid == entityid) {
            if(carItem.status == "sale") {
                onsale = true;
            }
            if (carItem.seller_id == characterid) {
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

    if (veh.data.tax >= tax_limit) {
               msg(playerid, "cardealer.needPayTax", CL_ERROR);
        return msg(playerid, "cardealer.hintTaxForSellers", [tax_limit], CL_HELP);
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

    local deal = CarDealer();
    local amount = round(carInfo.price * dealer_purchase_percent, 2);

    // Purchase transaction
    deal.vehid      = entityid;
    deal.type       = "purchase";
    deal.seller_id  = getVehicleOwnerId(vehicleid);
    deal.price      = amount;
    deal.created    = getTimestamp();
    deal.data       = {
        plate = plate,
        modelName = modelName
    }

    if (price == "now") {
        deal.status     = "completed";
        deal.buyer_id   = 4;
        deal.commission = 0.0;
        deal.total      = amount * -1; // расход дилера
        deal.until      = deal.created;
        deal.save();

        // sale transaction
        local saleDeal = CarDealer();
        saleDeal.vehid      = entityid;
        deal.type           = "sale";
        saleDeal.seller_id  = 4;
        saleDeal.price      = round(carInfo.price * dealer_sale_percent, 2);
        saleDeal.created    = getTimestamp();
        saleDeal.data       = {
            plate = plate,
            modelName = modelName
        }
        saleDeal.status     = "sale";
        saleDeal.commission = round(carInfo.price * (dealer_sale_percent - dealer_purchase_percent), 2);
        saleDeal.total      = 0.0;  // будущий приход дилера, но пока 0
        saleDeal.until      = saleDeal.created.tointeger() + time_to_sale_dealer;
        saleDeal.save();

        addMoneyToPlayer(playerid, amount);
        msg(playerid, "cardealer.soldNow", [ amount ], CL_SUCCESS);
        dbg("chat", "report", getPlayerName(playerid), format("Продал дилеру автомобиль «%s» (%s) за $%.2f", modelName, plate, amount));
    } else {
        deal.type       = "transfer";
        deal.price      = round(fabs(price.tofloat()), 2);
        deal.status     = "sale";
        deal.commission = round(carInfo.price * dealer_margin_percent, 2);
        deal.total      = 0.0;  // будущий приход дилера, но пока 0
        deal.until      = deal.created.tointeger() + time_to_sale;
        deal.save();
        msg(playerid, "cardealer.onSaleNow", CL_SUCCESS);
        dbg("chat", "report", getPlayerName(playerid), format("Выставил на продажу автомобиль «%s» (%s) за $%.2f", modelName, plate, deal.price));
    }

    setVehicleOwner(vehicleid, "[System] CarDealer", 4);
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
    local deal = null;

    foreach (idx, dealItem in carDealerLoadedData) {
        if (dealItem.vehid == entityid) {
            if(dealItem.status == "sale") {
                onsale = true;
                deal = dealItem;
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

    local sellerPlayerid = getPlayerIdFromCharacterId(deal.seller_id);

    /* возврат авто раньше окончания срока продажи + оплата комиссии */
    if(sellerPlayerid == playerid) {
        if(!canMoneyBeSubstracted(playerid, deal.commission)) {
            return msg(playerid, "cardealer.notenoughmoney", CL_ERROR);
        }
        subPlayerMoney(playerid, deal.commission);
        msg(sellerPlayerid, "cardealer.returnedCar", deal.commission, CL_FIREBUSH);
        deal.status = "canceled";
        deal.reason = "seller refused";
        deal.total = deal.commission;
        dbg("chat", "report", getPlayerName(playerid), format("Забрал с продажи автомобиль «%s» (%s) за $%.2f", modelName, plate, deal.commission));
    } else {
        /* Кто-то покупает авто. */
        local amount = deal.price + deal.commission;
        if(!canMoneyBeSubstracted(playerid, amount)) {
            return msg(playerid, "cardealer.notenoughmoney", CL_ERROR);
        }
        subPlayerMoney(playerid, amount);

        if(sellerPlayerid != -1 && sellerPlayerid != playerid) {
            addPlayerDeposit(sellerPlayerid, amount);
            msg(sellerPlayerid, "cardealer.sold", [modelName, plate, amount], CL_FIREBUSH);
        }

        msg(playerid, "cardealer.boughtCar", CL_SUCCESS);

        if(deal.type == "sale") {
            deal.total = deal.price + deal.commission;
            deal.status = "completed";
        }

        if(deal.type == "transfer") {
            deal.total = deal.commission;
            deal.status = sellerPlayerid == -1 ? "money_transfer" : "completed";
        }

        deal.buyer_id = getCharacterIdFromPlayerId(playerid);
        dbg("chat", "report", getPlayerName(playerid), format("Купил автомобиль «%s» (%s) за $%.2f", modelName, plate, amount));
    }

    deal.save();

    vehicleKey.setData("id", entityid);
    players[playerid].inventory.push(vehicleKey);
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
    local deal = null;

    foreach (idx, dealItem in carDealerLoadedData) {
        if (dealItem.vehid == entityid) {
            if(dealItem.status == "await_owner") {
                onremoving = true;
                deal = dealItem;
            }
        }
    }

    if(!onremoving) {
        return msg(playerid, "cardealer.notForRemoving", CL_ERROR);
    }

    if(characterid != deal.seller_id) {
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
    deal.commission = 0.0;
    deal.status = "canceled";
    deal.reason = "time expired";
    deal.save();

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
    "ru|cardealer.info.buy"               :  "Для покупки - выбери автомобиль по правую руку от дилера и сядь в него. Если автомобилей нет, значит сейчас их никто не продаёт через дилера. В этом случае загляни сюда позже."

    "en|cardealer.info.sell"              :  "Drive the car to the dealer's area and type /dealer in chat to sell."
    "ru|cardealer.info.sell"              :  "Для продажи - загони автомобиль на территорию и напиши /dealer."

    "en|cardealer.onSaleYet"              :  "Your car «%s» with plate %s is on sale now."
    "ru|cardealer.onSaleYet"              :  "Ваш автомобиль «%s» (%s) пока ещё не продан."

    "en|cardealer.sold"                   :  "Your car «%s» with plate %s sold. $%.2f transferred to the bank account."
    "ru|cardealer.sold"                   :  "Ваш автомобиль «%s» (%s) продан. На счёт в банк переведено $%.2f."

    "en|cardealer.await-owner"                :  "Your car «%s» with plate %s is removed from sale due to lack of demand. Take it from the dealer's area as soon as possible, otherwise it will be remove irrevocably."
    "ru|cardealer.await-owner"                :  "Ваш автомобиль «%s» (%s) снят с продажи из-за невостребованности. Заберите его с площадки дилера как можно скорее, иначе он будет утилизирован."

    "en|cardealer.deleted"                :  "Your car «%s» with plate %s is removed from sale due to lack of demand. Take it from the dealer's area as soon as possible, otherwise it will be remove irrevocably."
    "ru|cardealer.deleted"                :  "Ваш автомобиль «%s» (%s) снят с продажи из-за невостребованности. Заберите его с площадки дилера как можно скорее, иначе он будет утилизирован."

    "en|cardealer.soldNow"                :  "You sold you car for $%.2f"
    "ru|cardealer.soldNow"                :  "Вы продали автомобиль за $%.2f"

    "en|cardealer.canBuy"                 :  "You can buy this car for $%.2f via /dealer buy"
    "ru|cardealer.canBuy"                 :  "Вы можете купить этот автомобиль за $%.2f: /dealer buy"

    "en|cardealer.canReturn"              :  "This is your car, but it on sale. You can return it with $%.2f commission via /dealer buy"
    "ru|cardealer.canReturn"              :  "Это ваш автомобиль, но он выставлен на продажу. Вы можете забрать его c комиссией в $%.2f: /dealer buy"

    "en|cardealer.outofsale"              :  "This is your car, and it is removed from sale. Take it back via /dealer take"
    "ru|cardealer.outofsale"              :  "Это ваш автомобиль, и он снят с продажи из-за невостребованности. Заберите его: /dealer take"

    "en|cardealer.enterZone"              :  "Want to sell car? Park the car neatly."
    "ru|cardealer.enterZone"              :  "Хотите продать автомобиль? Припаркуйтесь аккуратно."

    "en|cardealer.enterZoneMore"          :  "More info: /dealer"
    "ru|cardealer.enterZoneMore"          :  "Подробнее: /dealer"

    "en|cardealer.notYourCar"             :  "This is not your car."
    "ru|cardealer.notYourCar"             :  "Этот автомобиль вам не принадлежит."

    "en|cardealer.carAlreadyOnSale"       :  "This car already on sale."
    "ru|cardealer.carAlreadyOnSale"       :  "Этот автомобиль уже выставлен на продажу."

    "en|cardealer.needPayTax"             :  "Need to pay off the tax on the vehicle."
    "ru|cardealer.needPayTax"             :  "Необходимо погасить налог на транспортное средство."

    "en|cardealer.hintTaxForSellers"      :  "You can sell vehicle only if tax debt lower than $%.2f."
    "ru|cardealer.hintTaxForSellers"      :  "Вы можете продать автомобиль, только если долг по оплате налога меньше $%.2f."

    "en|cardealer.unpaid-tax"             :  "Keep in mind that unpaid tax for this vehicle is $%.2f."
    "ru|cardealer.unpaid-tax"             :  "Учитывайте, что неоплаченный налог на этот автомобиль составляет $%.2f."

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
    "ru|cardealer.notenoughmoney"         :   "У вас недостаточно денег."

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
