local MAX_CHANNEL_COUNT = 64;

function getVehicleRadioChannel(vehicleid) {
    local veh = getVehicleEntity(vehicleid);
    if(veh == null) return false;

    if( !("radio" in veh.data.options)) {
        return false;
    }

     return veh.data.options.radio;
}

function sendRadioMsg(playerid, text) {
    if ( !isPlayerInVehicle(playerid) ) {
        return msg(playerid, "vehicle.options.radio.not-in-car");
    }

    local vehicleid = getPlayerVehicle(playerid);
    local radioChannel = getVehicleRadioChannel(vehicleid);

    if(radioChannel == false) {
        return msg(playerid, "vehicle.options.radio.not-installed");
    }

    foreach (vehicleid, vehicle in __vehicles) {
        local entity = getVehicleEntity(vehicleid);
        if(entity == null) continue;
        if(!("radio" in entity.data.options)) continue;
        if(entity.data.options.radio != radioChannel) continue;
        local passengers = getVehiclePassengers(vehicleid);
        foreach (seat, targetid in passengers) {
            msg( targetid, "vehicle.options.radio.msg", [radioChannel, text], CL_ROYALBLUE );
        }
    }
}

cmd(["r", "radio"], sendRadioMsg);

cmd(["r", "radio"], "set", function(playerid, channel = 0) {
    if ( !isPlayerInVehicle(playerid) ) {
        return msg(playerid, "vehicle.options.radio.not-in-car");
    }

    local vehicleid = getPlayerVehicle(playerid);
    local channel = getVehicleRadioChannel(vehicleid);

    if(channel == false) {
        return msg(playerid, "vehicle.options.radio.not-installed");
    }

    channel = toInteger(channel);

    if(channel < 0 || channel > 64) {
        return msg(playerid, "vehicle.options.radio.channel-limit", [ MAX_CHANNEL_COUNT] );
    }

    veh.data.options.radio = toInteger(channel);
    msg(playerid, "vehicle.options.radio.channel-changed", [channel]);
});

cmd(["r", "radio"], "get", function(playerid) {
    if ( !isPlayerInVehicle(playerid) ) {
        return msg(playerid, "vehicle.options.radio.not-in-car");
    }

    local vehicleid = getPlayerVehicle(playerid);
    local channel = getVehicleRadioChannel(vehicleid);

    if(channel == false) {
        return msg(playerid, "vehicle.options.radio.not-installed");
    }

    msg(playerid, "vehicle.options.radio.channel-current", [channel]);
});


alternativeTranslate({

    "en|vehicle.options.radio.msg"             : "[RADIO] [channel: %d]: %s"
    "ru|vehicle.options.radio.msg"             : "[РАЦИЯ] [канал: %d]: %s"

    "en|vehicle.options.radio.not-in-car"      : "You can use the radio only while in the car."
    "ru|vehicle.options.radio.not-in-car"      : "Воспользоваться рацией можно только находясь в автомобиле."

    "en|vehicle.options.radio.not-installed"   : "There's no radio in the car."
    "ru|vehicle.options.radio.not-installed"   : "В автомобиле не установлена рация."

    "en|vehicle.options.radio.channel-limit"   : "Channel must be a number from 0 to %d"
    "ru|vehicle.options.radio.channel-limit"   : "Канал должен быть числом от 0 до %d."

    "en|vehicle.options.radio.channel-changed" : "New channel: %d."
    "ru|vehicle.options.radio.channel-changed" : "Установлен канал: %d."

    "en|vehicle.options.radio.channel-current" : "Current channel: %d."
    "ru|vehicle.options.radio.channel-current" : "Текущий канал: %d."

});
