// nothing there yet :p
local coords = [-122.331, -62.9116, -12.041];
local tax_fixprice = 20.0;
local tax = 0.02;  // 2 percents

event("onServerStarted", function() {
    log("[organizations] government...");

    create3DText ( coords[0], coords[1], coords[2]+0.35, "SECRETARY OF GOVERNMENT", CL_ROYALBLUE);
    create3DText ( coords[0], coords[1], coords[2]+0.20, "/tax", CL_WHITE.applyAlpha(100), 2.0 );

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

    "en|tax.toofar"      : "This car can't registered."
    "ru|tax.toofar"      : "Оплатить налог можно в мэрии города."

    "en|tax.notrequired" : "This car not required to tax."
    "ru|tax.notrequired" : "Указанный автомобиль не облагается налогом."

    "en|tax.payed"       : "You payed tax for vehicle with plate %s."
    "ru|tax.payed"       : "Вы оплатили налог за автомобиль с номером %s."


    "en|tax.info.title"       : "Information about tax for vehicle:"
    "ru|tax.info.title"       : "Информация об оплате налога на автомобиль:"

    "en|tax.info.plate"       : "Plate: %s"
    "ru|tax.info.plate"       : "Номер: %s"

    "en|tax.info.model"       : "Model: %s"
    "ru|tax.info.model"       : "Модель: %s"

    "en|tax.info.issued"      : "Issued: %s"
    "ru|tax.info.issued"      : "Выдан: %s"

    "en|tax.info.expired"     : "Expired: %s"
    "ru|tax.info.expired"     : "Истекает: %s"

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
        return msg(playerid, "tax.toofar", [], CL_THUNDERBIRD);
    }

    if(players[playerid].inventory.freelen() <= 0) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local plateText = plateText.toupper();
    local vehicleid = getVehicleByPlateText(plateText.toupper());
    if(vehicleid == null) {
        return msg( playerid, "parking.checkPlate");
    }

    local modelid = getVehicleModel( vehicleid );
    local carInfo = getCarInfoModelById( modelid );

    if (carInfo == null) {
        return msg(playerid, "tax.notrequired");
    }

    local price = tax_fixprice + carInfo.price * tax;
    if (!canMoneyBeSubstracted(playerid, price)) {
        return msg(playerid, "money.notenough", [ price ], CL_THUNDERBIRD);
    }

    msg(playerid, "tax.payed", [ plateText ], CL_SUCCESS);
    subMoneyToPlayer(playerid, price);

    local tax = Item.VehicleTax();
    tax.setData("plate", plateText);
    tax.setData("model",  modelid );

    local day   = getDay();
    local month = getMonth() + 1;
    local year  = getYear();
    if (month == 13) { month = 1; year += 1; }
    if (day < 10)   { day = "0"+day; }
    if (month < 10) { month = "0"+month; }
    tax.setData("issued",  getDate());
    tax.setData("expired", day+"."+month+"."+year);

    players[playerid].inventory.push( tax );
    tax.save();
    players[playerid].inventory.sync();

});


