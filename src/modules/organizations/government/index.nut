include("modules/organizations/government/passport.nut");

// nothing there yet :p
local coords = [-122.331, -62.9116, -12.041];
local tax_fixprice = 20.0;
local tax = 0.025;  // 2.5 percents
local months = [1, 3, 6, 12];

local SIDEWALK = [-118.966, -73.4, -66.4244, -52.5];

function getGovCoords(i) {
    return coords[i];
}

event("onServerStarted", function() {
    log("[organizations] government...");

    create3DText ( coords[0], coords[1], coords[2]+0.20, "/tax | /passport", CL_WHITE.applyAlpha(100), 2.0 );

    createBlip  ( coords[0], coords[1], [ 24, 0 ], 4000.0 );

    createPlace("GovernmentSidewalk", SIDEWALK[0], SIDEWALK[1], SIDEWALK[2], SIDEWALK[3]);

});

event("onServerPlayerStarted", function( playerid ) {
    createPrivate3DText ( playerid, coords[0], coords[1], coords[2]+0.35, plocalize(playerid, "3dtext.organizations.meria"), CL_ROYALBLUE);
});

alternativeTranslate({

    "en|tax.help.title"  : "Tax for vehicle:"
    "ru|tax.help.title"  : "Налог на автомобиль:"

    "en|tax.help.tax"    : "/tax  PlateNumber NumberOfMonths"
    "ru|tax.help.tax"    : "/tax  НомерАвтомобиля КоличествоМесяцев"

    "en|tax.help.desc"   : "Pay tax"
    "ru|tax.help.desc"   : "Оплатить налог"

    "en|tax.toofar"      : "You can pay tax at city government."
    "ru|tax.toofar"      : "Оплатить налог можно в мэрии города."

    "en|tax.notrequired" : "This car not required to tax."
    "ru|tax.notrequired" : "Указанный автомобиль не облагается налогом."

    "en|tax.payed"       : "You payed tax $%.2f for vehicle with plate %s for %d months."
    "ru|tax.payed"       : "Вы оплатили налог $%.2f за авто с номером %s на %d мес."

    "en|tax.money.notenough"  : "Not enough money. Need $%.2f."
    "ru|tax.money.notenough"  : "Недостаточно денег. Для оплаты требуется $%.2f."

    "en|tax.monthUp"          : "Choose correct number of months: 1, 3, 6 or 12 "
    "ru|tax.monthUp"          : "Выберите корректное число месяцев: 1, 3, 6 или 12"

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

function taxHelp( playerid ) {
    local title = "tax.help.title";
    local commands = [
        { name = "tax.help.tax",    desc = "tax.help.desc" }
    ];
    msg_help(playerid, title, commands);
}


cmd("tax", function( playerid, plateText = 0, monthUp = 1 ) {

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

    if(monthUp) {
        monthUp = monthUp.tointeger();
        if(months.find(monthUp) == null) {
            return msg(playerid, "tax.monthUp", CL_THUNDERBIRD);
        }
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

    local price = tax_fixprice + carInfo.price * tax * monthUp;
    if (!canMoneyBeSubstracted(playerid, price)) {
        return msg(playerid, "tax.money.notenough", [ price ], CL_THUNDERBIRD);
    }

    msg(playerid, "tax.payed", [ price, plateText, monthUp ], CL_SUCCESS);
    subMoneyToPlayer(playerid, price);

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

    vehicleWanted = getVehicleWantedForTax();

});

event("onPlayerPlaceEnter", function(playerid, name) {
    if (isPlayerInVehicle(playerid) && name == "GovernmentSidewalk") {
        local vehicleid = getPlayerVehicle(playerid);
        local vehSpeed = getVehicleSpeed(vehicleid);
        local vehPos = getVehiclePosition(vehicleid);

        local vehSpeedNew = [];

        if (vehPos[0] > SIDEWALK[0] && vehPos[0] < SIDEWALK[2]) {
            // для нижней границы
            if (vehPos[1] > (SIDEWALK[1] - 4.0) && vehPos[1] < (SIDEWALK[1] + 4.0)) {
                if (vehSpeed[1] >= 0) vehSpeed[1] = (vehSpeed[1] + 1) * -1;
            }
            // для верхней границы
            if (vehPos[1] > (SIDEWALK[3] - 4.0) && vehPos[1] < (SIDEWALK[3] + 4.0)) {
                if (vehSpeed[1] <= 0) vehSpeed[1] = (vehSpeed[1] - 1) * -1;
            }
        }

        // для правой боковой границы
        if (vehPos[0] > (SIDEWALK[2] - 4.0) && vehPos[0] < (SIDEWALK[2] + 4.0)) {
            if (vehPos[1] > SIDEWALK[1] && vehPos[1] < SIDEWALK[3]) {
                if (vehSpeed[0] <= 0) vehSpeed[0] = (vehSpeed[0] - 1) * -1;
            }
        }

        setVehicleSpeed(vehicleid, vehSpeed[0], vehSpeed[1], vehSpeed[2]);
    }
});

//function tax(monthUp = 12, day = null, month = null, year = null, ) {
//    day   = day   ? day   : getDay();
//    month = month ? month : getMonth();
//    year  = year  ? year  : getYear();
//    dbg(day+"."+month+"."+year)
//
//    local intMonth = year * 12 + month + monthUp;
//    local intYear = floor(intMonth / 12);
//    local lostMonth = intMonth % 12;
//
//    if (lostMonth == 0) {
//        lostMonth = 12;
//        intYear -= 1;
//    }
//
//    dbg(day+"."+lostMonth+"."+intYear)
//}
