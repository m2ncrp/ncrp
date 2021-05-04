
local tax = 0.01 / 30;                  // 1 percents for 30 day
local vehiclesLimit = 2;                // рекомендуемое количество автомобилей на игрока
local vehiclesWithoutIncreaseTax = 2;   // количество автомобилей без повышения налогового коэффициента

event("onServerDayChange", function() {
    // счётчик количества автомобилей на каждого персонажа
    local vehiclesCountForPlayer = {};

    // коэффициент на каждого игрока
    local coefForPlayer = {};

    // собираем количество автомобилей по каждому персонажу
    foreach (vehicleid, object in __vehicles) {

        if (!object) continue;

        local veh = getVehicleEntity(vehicleid);

        if(veh == null || isGovVehicle(veh.plate) || isVehicleidPoliceVehicle(vehicleid)) {
            continue;
        }

        local ownerid = veh.ownerid;

        if((ownerid in vehiclesCountForPlayer) == false) {
            vehiclesCountForPlayer[ownerid] <- 0;
        }

        vehiclesCountForPlayer[ownerid] += 1;
    }

    foreach (vehicleid, object in __vehicles) {

        if (!object) continue;

        local veh = getVehicleEntity(vehicleid);

        if(veh == null || isGovVehicle(veh.plate) || isVehicleidPoliceVehicle(vehicleid)) {
            continue;
        }

        local ownerid = veh.ownerid;

        if((ownerid in coefForPlayer) == false) {
            local coef = (1 + (vehiclesCountForPlayer[ownerid] - vehiclesWithoutIncreaseTax) / vehiclesLimit.tofloat());
            if(coef < 1) coef = 1;

            coefForPlayer[ownerid] <- coef;
        }

        local modelid = veh.model;
        local carInfo = getCarInfoModelById( modelid );

        if (carInfo == null || veh.owner == "city" || ("taxFree" in veh.data) /*|| isVehicleCarRent(vehicleid) */) {
            continue;
        }

        // Машины, необлагаемые налогом
        if ("taxFree" in veh.data) {
            veh.data.tax <- 0;
            continue;
        }

        if(("tax" in veh.data) == false) {
            veh.data.tax <- 0;
        }

        veh.data.tax += round((carInfo.price * tax * coefForPlayer[ownerid]), 2);
    }
});


alternativeTranslate({

    "en|tax.help.title"  : "Tax for vehicle:"
    "ru|tax.help.title"  : "Налог на автомобиль:"

    "en|tax.help.tax"    : "/tax PlateNumber"
    "ru|tax.help.tax"    : "/tax НомерАвтомобиля"

    "en|tax.help.desc"   : "Pay tax"
    "ru|tax.help.desc"   : "Оплатить налог"

    "en|tax.toofar"      : "You can pay tax at city government."
    "ru|tax.toofar"      : "Узнать и оплатить налог можно в мэрии города."

    "en|tax.novehicles"   : "You don't gave a vehicles"
    "ru|tax.novehicles"   : "У вас нет автомобилей"

    "en|tax.notrequired" : "This car not required to tax."
    "ru|tax.notrequired" : "Указанный автомобиль не облагается налогом."

    "en|tax.iszero"      : "Tax is zero."
    "ru|tax.iszero"      : "Налог ещё не начислен."

    "en|tax.payed"       : "You payed tax $%.2f for vehicle with plate %s."
    "ru|tax.payed"       : "Вы оплатили налог $%.2f за авто с номером %s."

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
});

function getVehicleTax(vehicleid) {
    local veh = getVehicleEntity(vehicleid);
    return (!veh || ("tax" in veh.data) == false) ? 0 : veh.data.tax;
}

function getVehicleTaxList( playerid ) {

    local charid = getCharacterIdFromPlayerId(playerid);

    msg(playerid, "");
    msg(playerid, "============== Налог на автомобиль ==============", CL_RIPELEMON);

    local taxes = [];

    foreach (vehicleid, object in __vehicles) {

        if (!object) continue;

        local veh = getVehicleEntity(vehicleid);

        if(veh == null || isGovVehicle(veh.plate)) {
            continue;
        }

        local ownerid = veh.ownerid;

        if(ownerid == charid) {
            local taxAmount = ("tax" in veh.data) ? veh.data.tax : 0;
            local color = taxAmount > 0 ?  CL_FLAT_RED : CL_FLAT_GREEN;
            local status = taxAmount > 0 ? format("начислено $%.2f", taxAmount) : "не начислено";

            local carLine = {
              text = format("%s - %s - %s", veh.plate, getVehicleNameByModelId(veh.model), status),
              color = color
            }

            taxes.push(carLine)
        }
    }

    if(taxes.len() == 0) {
      return msg(playerid, "tax.novehicles");
    }

    foreach (idx, taxLine in taxes) {
      msg(playerid, taxLine.text, taxLine.color);
    }

    msg(playerid, "Оплатить: /tax  номер-автомобиля (например, /tax AB-123)", CL_GRAY);
}


/**
 * DEPRECATED
 * Check if current connected player is have key from vehicleid
 *
 * @param  {integer}  playerid
 * @param  {any}      param - vehicleid or plateText
 * @return {Boolean}
 */
function isPlayerHaveValidVehicleTax(playerid, param, days = 0) {

    local plate = null;

    if (typeof param == "string") {
        plate = param;
    }

    if (typeof param == "integer") {
        plate = getVehiclePlateText(param);
    }

    local curdateStamp = getDay() + getMonth()*30 + getYear()*360 + days;

    local isHave = false;

    foreach (idx, item in players[playerid].inventory) {

        if(item._entity == "Item.VehicleTax") {
            local dateArray = split(item.data.expires,".");
            local dateStamp = dateArray[0].tointeger() + dateArray[1].tointeger()*30 + dateArray[2].tointeger()*360;
            if (item.data.plate == plate && curdateStamp <= dateStamp) {
                isHave = true;
                break;
            }
        }
    }

    return isHave;
}

cmd("tax", function( playerid, plateText = 0) {

    if (!isPlayerInValidPoint(playerid, getGovCoords(0), getGovCoords(1), 1.0 )) {
        return msg(playerid, "tax.toofar", CL_THUNDERBIRD);
    }

    if (plateText == 0) {
        return getVehicleTaxList( playerid );
    }

    local plateText = plateText.toupper();
    local vehicleid = getVehicleByPlateText(plateText.toupper());
    local veh = getVehicleEntity(vehicleid);

    if(veh == null) {
        return msg( playerid, "parking.checkPlate");
    }

    local modelid = veh.model;
    local carInfo = getCarInfoModelById( modelid );

    if (carInfo == null || isVehicleCarRent(vehicleid) || isGovVehicle(veh.plate)) {
        return msg(playerid, "tax.notrequired");
    }

    if(("tax" in veh.data) == false) {
        veh.data.tax <- 0;
    }

    if (veh.data.tax == 0) {
        return msg(playerid, "tax.iszero");
    }

    local price = veh.data.tax;
    if (!canMoneyBeSubstracted(playerid, price)) {
        return msg(playerid, "tax.money.notenough", [ price ], CL_THUNDERBIRD);
    }

    msg(playerid, "tax.payed", [ price, plateText ], CL_SUCCESS);
    subMoneyToPlayer(playerid, price);
    addTreasuryMoney(price);
    veh.data.tax = 0;

    vehicleWanted = getVehicleWantedForTax();

});

acmd("resettaxall", function(playerid) {
    foreach (vehicleid, object in __vehicles) {

        if (!object) continue;

        local veh = getVehicleEntity(vehicleid);

        if(veh == null || isGovVehicle(veh.plate)) {
            continue;
        }

        veh.data.tax <- 0;
    }
});

acmd("resettax", function(playerid) {

    if(!isPlayerInVehicle(playerid)) {
        return msg(playerid, "Нужно быть в автомобиле.", CL_ERROR);
    }

    local vehicleid = getPlayerVehicle(playerid);
    local veh = getVehicleEntity(vehicleid);

    if(veh == null) {
        return msg(playerid, "Этот автомобиль не из базы.", CL_ERROR);
    }

    veh.data.tax <- 0;
    msg(playerid, "Сумма налога на автомобиль обнулена.", CL_SUCCESS);
});

acmd("taxfree", function(playerid, status = "true") {

    if(!isPlayerInVehicle(playerid)) {
        return msg(playerid, "Нужно быть в автомобиле.", CL_ERROR);
    }

    local vehicleid = getPlayerVehicle(playerid);
    local veh = getVehicleEntity(vehicleid);

    if(veh == null) {
        return msg(playerid, "Этот автомобиль не из базы.", CL_ERROR);
    }

    veh.data.taxFree <- !!status;
    msg(playerid, format("Статус облагания налогом: %s", status), CL_SUCCESS);
});



/*

    // if(!players[playerid].inventory.isFreeSpace(1)) {
        // return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    // }

    // local taxObj = Item.VehicleTax();
    // if (!players[playerid].inventory.isFreeWeight(taxObj)) {
        // return msg(playerid, "inventory.weight.notenough", CL_THUNDERBIRD);
    // }

    taxObj.setData("plate", plateText);
    taxObj.setData("model",  modelid );

    local day   = getDay();
    local month = getMonth();
    local year  = getYear();

    local intMonth = year * 12 + month + monthUp;

    year = floor(intMonth / 12);
    month = intMonth % 12;

    if (month == 0) {
        month = 12;
        year -= 1;
    }
    if (day < 10)   { day = "0"+day; }
    if (month < 10) { month = "0"+month; }

    taxObj.setData("issued",  getDate());
    taxObj.setData("expires", day+"."+month+"."+year);

    players[playerid].inventory.push( taxObj );
    taxObj.save();
    players[playerid].inventory.sync();

*/
