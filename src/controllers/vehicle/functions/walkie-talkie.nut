local MAX_CHANNEL_COUNT = 64;

function getVehicleWalkieTalkieChannel(vehicleid) {
    local veh = getVehicleEntity(vehicleid);
    if(veh == null) return false;

    if( !("radio" in veh.data.options)) {
        return false;
    }

     return veh.data.options.radio;
}

function sendRadioMsg(playerid, text) {
    if ( !isPlayerInVehicle(playerid) ) {
        return msg(playerid, "vehicle.options.walkietalkie.not-in-car");
    }

    local vehicleid = getPlayerVehicle(playerid);
    local radioChannel = getVehicleWalkieTalkieChannel(vehicleid);

    if(radioChannel == false) {
        return msg(playerid, "vehicle.options.walkietalkie.not-installed");
    }

    foreach (vehicleid, vehicle in __vehicles) {
        local entity = getVehicleEntity(vehicleid);
        if(entity == null) continue;
        if(!("radio" in entity.data.options)) continue;
        if(entity.data.options.radio != radioChannel) continue;
        local passengers = getVehiclePassengers(vehicleid);
        foreach (seat, targetid in passengers) {
            msg( targetid, "vehicle.options.walkietalkie.msg", [radioChannel, text], CL_ROYALBLUE );
        }
    }
}

cmd(["r", "radio"], function(playerid, ...) {
    sendRadioMsg(playerid, concat(vargv));
});

cmd(["r", "radio"], "set", function(playerid, newChannel = 0) {
    if (!isPlayerInVehicle(playerid)) {
        return msg(playerid, "vehicle.options.walkietalkie.not-in-car");
    }

    local vehicleid = getPlayerVehicle(playerid);
    local channel = getVehicleWalkieTalkieChannel(vehicleid);

    if(channel == false) {
        return msg(playerid, "vehicle.options.walkietalkie.not-installed");
    }

    newChannel = toInteger(newChannel);

    if(newChannel < 0 || newChannel > 64) {
        return msg(playerid, "vehicle.options.walkietalkie.channel-limit", [ MAX_CHANNEL_COUNT] );
    }

    local veh = getVehicleEntity(vehicleid);
    veh.data.options.radio = newChannel;

    msg(playerid, "vehicle.options.walkietalkie.channel-changed", [newChannel]);
});

cmd(["r", "radio"], "get", function(playerid) {
    if ( !isPlayerInVehicle(playerid) ) {
        return msg(playerid, "vehicle.options.walkietalkie.not-in-car");
    }

    local vehicleid = getPlayerVehicle(playerid);
    local channel = getVehicleWalkieTalkieChannel(vehicleid);

    if(channel == false) {
        return msg(playerid, "vehicle.options.walkietalkie.not-installed");
    }

    msg(playerid, "vehicle.options.walkietalkie.channel-current", [channel]);
});


alternativeTranslate({

    "en|vehicle.options.walkietalkie.msg"             : "[RADIO] [channel: %d]: %s"
    "ru|vehicle.options.walkietalkie.msg"             : "[РАЦИЯ] [канал: %d]: %s"

    "en|vehicle.options.walkietalkie.not-in-car"      : "You can use the radio only while in the car."
    "ru|vehicle.options.walkietalkie.not-in-car"      : "Воспользоваться рацией можно только находясь в автомобиле."

    "en|vehicle.options.walkietalkie.not-installed"   : "There's no radio in the car."
    "ru|vehicle.options.walkietalkie.not-installed"   : "В автомобиле не установлена рация."

    "en|vehicle.options.walkietalkie.channel-limit"   : "Channel must be a number from 0 to %d"
    "ru|vehicle.options.walkietalkie.channel-limit"   : "Канал должен быть числом от 0 до %d."

    "en|vehicle.options.walkietalkie.channel-changed" : "New channel: %d."
    "ru|vehicle.options.walkietalkie.channel-changed" : "Установлен канал: %d."

    "en|vehicle.options.walkietalkie.channel-current" : "Current channel: %d."
    "ru|vehicle.options.walkietalkie.channel-current" : "Текущий канал: %d."

});
