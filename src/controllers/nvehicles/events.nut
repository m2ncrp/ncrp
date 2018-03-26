event("onPlayerNVehicleEnter", function(character, vehicle, seat) {
    msg(character, "vehicle.trystartengine", CL_CASCADE);
});
