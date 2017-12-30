local VEHKEYS_X = -199.524;
local VEHKEYS_Y = 838.586;
local VEHKEYS_Z = -21.2431;
local VEHKEYS_RADIUS = 2.0;

alternativeTranslate({
    "en|vehkeys.help.title"  : "Ключ от автомобиля:"
    "ru|vehkeys.help.title"  : "Ключ от автомобиля:"

    "en|vehkeys.help.key"    : "/key  PlateNumber"
    "ru|vehkeys.help.key"    : "/key  НомерАвтомобиля"

    "en|vehkeys.help.desc"   : "Get key of car"
    "ru|vehkeys.help.desc"   : "Получить ключ от автомобиля"

    "en|vehkeys.toofar"      : "You can get key of car at auto shop."
    "ru|vehkeys.toofar"      : "Получить ключ от автомобиля можно в автосалоне."

    "en|vehkeys.got"         : "You received key of car for %s."
    "ru|vehkeys.got"         : "Вы получили ключ от автомобиля с номером %s."

    "en|vehkeys.alreadygot"  :  "You have already received key of this car."
    "ru|vehkeys.alreadygot"  :  "Вы уже получили ключ от этого автомобиля."

});

event("onServerStarted", function() {
    create3DText (VEHKEYS_X, VEHKEYS_Y, VEHKEYS_Z+0.35, "GET CAR KEYS", CL_FLAMINGO );
    create3DText (VEHKEYS_X, VEHKEYS_Y, VEHKEYS_Z+0.20, "/key", CL_WHITE.applyAlpha(150), VEHKEYS_RADIUS );
 });

function getVehicleKeysHelp( playerid ) {
    local title = "vehkeys.help.title";
    local commands = [
        { name = "vehkeys.help.key",    desc = "vehkeys.help.desc" }
    ];
    msg_help(playerid, title, commands);
}


cmd("key", function( playerid, plateText = 0 ) {

    if (plateText == 0) {
        return getVehicleKeysHelp( playerid );
    }

    if (!isPlayerInValidPoint(playerid, VEHKEYS_X, VEHKEYS_Y, 1.0 )) {
        return msg(playerid, "vehkeys.toofar", CL_THUNDERBIRD);
    }

    if(!players[playerid].inventory.isFreeSpace(1)) {
        return msg(playerid, "inventory.space.notenough", CL_THUNDERBIRD);
    }

    local vehicleKey = Item.VehicleKey();
    if (!players[playerid].inventory.isFreeWeight(vehicleKey)) {
        return msg(playerid, "inventory.weight.notenough", CL_THUNDERBIRD);
    }

    local plateText = plateText.toupper();
    local vehicleid = getVehicleByPlateText(plateText.toupper());

    if(vehicleid == null) {
        return msg( playerid, "parking.checkPlate", CL_THUNDERBIRD);
    }

    if(__vehicles[vehicleid].ownership.ownerid == 3) {
        return msg( playerid, "vehkeys.alreadygot", CL_THUNDERBIRD);
    }

    if (!isPlayerVehicleOwner(playerid, vehicleid)) {
        return msg(playerid, "parking.notYourCar", CL_THUNDERBIRD);
    }

    local entityid = getVehicleEntityId(vehicleid);

    vehicleKey.setData("id", entityid);
    __vehicles[vehicleid].ownership.ownerid = 3;

    players[playerid].inventory.push( vehicleKey );
    vehicleKey.save();
    players[playerid].inventory.sync();

    return msg( playerid, "vehkeys.got", plateText, CL_SUCCESS );
});


