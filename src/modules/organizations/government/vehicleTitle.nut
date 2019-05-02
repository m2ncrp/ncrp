local tax_fixprice = 20.0;
local tax = 0.025;  // 2.5 percents
local months = [1, 3, 6, 12];

alternativeTranslate({

    "en|inventory.vehicletitle.removedcar"      : "It's certificate of title for the car which I once owned. I don't even know where it now..."
    "ru|inventory.vehicletitle.removedcar"      : "Это свидетельство о праве собственности на автомобиль, которым я когда-то владел. Даже не знаю где он сейчас..."

    "en|inventory.vehicletitle.modelandplate"   : "Model name and plate: %s - %s"
    "ru|inventory.vehicletitle.modelandplate"   : "Модель и номер: %s - %s"

    "en|inventory.vehicletitle.manufactureprice" : "Manufacture price: $%.2f"
    "ru|inventory.vehicletitle.manufactureprice" : "Отпускная цена: $%.2f"

    "en|inventory.vehicletitle.manufactureyear" : "Manufacture year: %d"
    "ru|inventory.vehicletitle.manufactureyear" : "Год производства: %d"

    "en|inventory.vehicletitle.owners"          : "Owners (%d):"
    "ru|inventory.vehicletitle.owners"          : "Владельцы (%d):"

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

acmd("vt", function(playerid, plateText = 0, ownerid = null) {
    if (plateText == 0 || ownerid == null) {
        return msg(playerid, "Format: /vt plate playerid")
    }

    if (!isPlayerInValidPoint(playerid, getGovCoords(0), getGovCoords(1), 3.0 )) {
        return msg(playerid, "Too far");
    }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local vehicleTitle = Item.VehicleTitle();
    if (!players[playerid].inventory.isFreeVolume(vehicleTitle)) {
        return msg(playerid, "inventory.volume.notenough", CL_THUNDERBIRD);
    }

    local plateText = plateText.toupper();
    local vehicleid = getVehicleByPlateText(plateText.toupper());
    if(vehicleid == null) {
        return msg( playerid, "parking.checkPlate");
    }

    local car = getCarInfoModelById(getVehicleModel(vehicleid));

    vehicleTitle.setData("ownerid", getCharacterIdFromPlayerId(ownerid.tointeger()) );
    vehicleTitle.setData("plate", plateText);
    vehicleTitle.setData("price",  car.price );
    vehicleTitle.setData("owners", [] );
    vehicleTitle.setData("year",  getYear() );
    vehicleTitle.setData("date",  getDate() );

    players[playerid].inventory.push( vehicleTitle );
    vehicleTitle.save();
    players[playerid].inventory.sync();

    msg(playerid, "VehicleTitle is in your inventory")
    dbg("chat", "police", getAuthor(playerid), format("выдал %s свидетельство о праве собственности на автомобиль %s", getAuthor(ownerid), plateText.toupper()) );
});
