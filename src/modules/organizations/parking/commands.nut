// player need to be in car
cmd("unpark", function ( playerid ) {
    trigger("onVehicleGetFromCarPound", playerid);
});

// /park plate_number
acmd("apark", function ( playerid, plate) {
    trigger("onVehicleSetToCarPound", playerid, plate);
});

// player need to be in car
acmd("aunpark", function ( playerid ) {
    trigger("onVehicleGetFromCarPound", playerid);
});
