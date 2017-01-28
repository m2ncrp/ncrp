class LockableVehicle extends RespawnableVehicle
{



}


// local blockedVehicles = {};

// /**
//  * Block vehicle (it cannot be moved or driven)
//  * @param int vehicleid
//  * @return bool
//  */
// function blockVehicle(vehicleid) {
//     setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
//     setVehicleEngineState(vehicleid, false);
//     setVehicleFuel(vehicleid, 0.0, true);

//     if (!(vehicleid in blockedVehicles)) {
//         blockedVehicles[vehicleid] <- true;
//     }

//     return true;
// }

// *
//  * Unblock vehicle
//  * @param {int} vehicleid
//  * @param {float} fuel
//  * @return {bool}
 
// function unblockVehicle(vehicleid, fuel = VEHICLE_FUEL_DEFAULT) {
//     if (vehicleid in blockedVehicles) {
//         blockedVehicles[vehicleid] = false;
//     }

//     return restoreVehicleFuel(vehicleid);
// }

// /**
//  * Check if current vehicle is blocked
//  * @param  {Integer}  vehicleid
//  * @return {Boolean}
//  */
// function isVehicleBlocked(vehicleid) {
//     return (vehicleid in blockedVehicles && blockedVehicles[vehicleid]);
// }
