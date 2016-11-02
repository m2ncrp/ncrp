include("controllers/vehicle/commands.nut");
include("controllers/vehicle/hiddencars.nut");

// saving original vehicle method
local old__createVehicle = createVehicle;

// creating storage for vehicles
local vehicles = [];
local vehicleOverrides = {};

function addVehicleOverride(range, callback) {
    if (typeof range != "array") {
        range = [range];
    }

    return range.map(function(item) {
        vehicleOverrides[item] <- callback;
    });
}

function getVehicleOverride(vehicleid, modelid) {
    if (modelid in vehicleOverrides) {
        vehicleOverrides[modelid](vehicleid);
    }
}

addEventHandler("onScriptInit", function() {
    // police cars
    addVehicleOverride([21, 42], function(id) {
        setVehicleColour(id, 255, 255, 255, 0, 0, 0);
        setVehicleSirenState(id, false);
        // setVehicleBeaconLight(id, false);
    });

    addVehicleOverride(51, function(id) {
        setVehicleColour(id, 0, 0, 0, 150, 150, 150);
        setVehicleSirenState(id, false);
        // setVehicleBeaconLight(id, false);
    });

    // trucks
    addVehicleOverride(range(34, 39), function(id) {
        setVehicleColour(id, 255, 255, 255, 0, 0, 0);
    });

    // armoured
    addVehicleOverride(17, function() {
        setVehicleColour(id, 0, 0, 0, 0, 0, 0);
    });

    // milk
    addVehicleOverride(19, function() {
        setVehicleColour(id, 160, 160, 130, 50, 230, 50);
    });
});

// overriding to custom one
createVehicle = function(modelid, x, y, z, rx, ry, rz) {
    local vehicle = old__createVehicle(
        modelid.tointeger(), x.tofloat(), y.tofloat(), z.tofloat(), rx.tofloat(), ry.tofloat(), rz.tofloat()
    );

    // apply default functions
    setVehicleRotation(vehicle, rx.tofloat(), ry.tofloat(), rz.tofloat());
    getVehicleOverride(vehicle, modelid.tointeger());

    // save ids
    vehicles.push(vehicle);

    return vehicle;
};

// binding events
addEventHandlerEx("onServerStarted", function() {
    log("[vehicles] starting...");
    createVehicle(8, -1546.6, -156.406, -19.2969, -0.241408, 2.89541, -2.29698);    // Sand Island
    createVehicle(9, -1537.77, -168.93, -19.4142, 0.0217354, 0.396637, -2.80105);   // Sand Island
    createVehicle(20, -1525.16, -193.591, -19.9696, 90.841, -0.248158, 3.35295);    // Sand Island
});

// clearing all vehicles on server stop
addEventHandlerEx("onServerStopping", function() {
    vehicles.apply(destroyVehicle);
});
