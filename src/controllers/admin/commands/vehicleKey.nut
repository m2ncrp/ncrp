alternativeTranslate({
    "en|vehkeys.help.title"  : "Ключ от автомобиля:"
    "ru|vehkeys.help.title"  : "Ключ от автомобиля:"

    "en|vehkeys.help.key"    : "/key  PlateNumber"
    "ru|vehkeys.help.key"    : "/key  НомерАвтомобиля"

    "en|vehkeys.help.desc"   : "Get key of car"
    "ru|vehkeys.help.desc"   : "Получить ключ от автомобиля"

    "en|vehkeys.got"         : "You received key of car for %s."
    "ru|vehkeys.got"         : "Вы получили ключ от автомобиля с номером %s."

    "en|vehkeys.alreadygot"  :  "You have already received key of this car."
    "ru|vehkeys.alreadygot"  :  "Вы уже получили ключ от этого автомобиля."

});

function getVehicleKeysHelp( playerid ) {
    local title = "vehkeys.help.title";
    local commands = [
        { name = "vehkeys.help.key",    desc = "vehkeys.help.desc" }
    ];
    msg_help(playerid, title, commands);
}


mcmd(["admin.item"], "key", function( playerid, plateText = 0 ) {

    if (plateText == 0) {
        return getVehicleKeysHelp( playerid );
    }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local vehicleKey = Item.VehicleKey();
    if (!players[playerid].inventory.isFreeVolume(vehicleKey)) {
        return msg(playerid, "inventory.volume.notenough", CL_THUNDERBIRD);
    }

    local plateText = plateText.toupper();
    local vehicleid = getVehicleByPlateText(plateText.toupper());

    if(vehicleid == null) {
        return msg( playerid, "parking.checkPlate", CL_THUNDERBIRD);
    }

    // if(__vehicles[vehicleid].ownership.ownerid == 3) {
    //     return msg( playerid, "vehkeys.alreadygot", CL_THUNDERBIRD);
    // }

    // if (!isPlayerVehicleOwner(playerid, vehicleid)) {
    //     return msg(playerid, "parking.notYourCar", CL_THUNDERBIRD);
    // }

    local entityid = getVehicleEntityId(vehicleid);

    vehicleKey.setData("id", entityid);

    players[playerid].inventory.push( vehicleKey );
    vehicleKey.save();
    players[playerid].inventory.sync();

    return msg( playerid, "vehkeys.got", plateText, CL_SUCCESS );
});


