event("onPlayerNVehicleEnter", function(character, vehicle, seat) {
    msg(character, "vehicle.tryStartEngine", CL_CASCADE);
});
