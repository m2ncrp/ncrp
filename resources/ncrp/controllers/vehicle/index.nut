include("controllers/vehicle/commands.nut");

include("controllers/vehicle/patterns/VehicleContainer.nut");

include("controllers/vehicle/classes/NativeVehicle.nut");
include("controllers/vehicle/classes/OwnableVehicle.nut");
include("controllers/vehicle/classes/SeatableVehicle.nut");
include("controllers/vehicle/classes/RespawnableVehicle.nut");
include("controllers/vehicle/classes/CustomVehicle.nut");


const VEHICLE_RESPAWN_TIME      = 300; // 5 (real) minutes
const VEHICLE_FUEL_DEFAULT      = 40.0;
const VEHICLE_MIN_DIRT          = 0.25;
const VEHICLE_MAX_DIRT          = 0.75;
const VEHICLE_DEFAULT_OWNER     = "";
const VEHICLE_OWNERSHIP_NONE    = 0;
const VEHICLE_OWNERSHIP_SINGLE  = 1;
// const VEHICLE_OWNER_CITY        = "__cityNCRP";

translate("en", {
    "vehicle.sell.amount"       : "You need to set the amount you wish to sell your car for."
    "vehicle.sell.2passangers"  : "You need potential buyer to sit in the vehicle with you."
    "vehicle.sell.ask"          : "%s offers you to buy his vehicle for $%.2f."
    "vehicle.sell.log"          : "You offered %s to buy your vehicle for $%.2f."
    "vehicle.sell.success"      : "You've successfuly sold this car."
    "vehicle.buy.success"       : "You've successfuly bought this car."
    "vehicle.sell.failure"      : "%s refused to buy this car."
    "vehicle.buy.failure"       : "You refused to buy this car."
    "vehicle.sell.notowner"     : "You can't sell car tht doesn't belong to you."
});


__vehicles <- VehicleContainer();

event("onScriptInit", function() {

});

// binding events
event("onServerStarted", function() {
    log("[vehicles] starting...");
    local counter = 0;

    // load all vehicles from db
    Vehicle.findAll(function(err, results) {
        foreach (idx, vehicle in results) {
            // Use data from vehicle-metainfo.nut file to get seats in given model
            // local seats = getSeatsNumber(vehicle.model);
            local seats = 2;
            local veh = CustomVehicle( vehicle.model, seats, vehicle.x, vehicle.y, vehicle.z, vehicle.rx, vehicle.ry, vehicle.rz );
            veh.setColor( vehicle.cra, vehicle.cga, vehicle.cba, vehicle.crb, vehicle.cgb, vehicle.cbb );
            veh.setPlate( vehicle.plate );
            veh.setTuning( vehicle.tunetable );
            veh.setOwner( vehicle.owner, vehicle.ownerid );
            veh.setFuel( vehicle.fuellevel );
            veh.setDirlLevel( vehicle.dirtlevel );

            __vehicles.add(veh.vid, veh);
            counter++;
        }

        log("[vehicles] loaded " + counter + " vehicles from database.");
    });
});

// respawn cars and update passangers
event("onServerMinuteChange", function() {

});

// handle vehicle enter
event("native:onPlayerVehicleEnter", function(playerid, vehicleid, seat) {

});

// handle vehicle exit
event("native:onPlayerVehicleExit", function(playerid, vehicleid, seat) {

});

// force resetting vehicle position to death point
event("onPlayerDeath", function(playerid) {

});

event("onPlayerSpawned", function(playerid) {

});
