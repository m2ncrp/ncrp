// // include("controllers/nvehicles/classes/Vehicle_hack.nut");

// /**
//  * Iterate over all players
//  * and fill array with ones that are passangers
//  */
// function updateVehiclePassengers() {
//     foreach (vehicle in vehicles) {
//         foreach (seat, playerid in vehicle.passengers) {
//             if (!isPlayerConnected(playerid)) {
//                 passengers[vehicleid][seat] = -1;
//             }
//         }
//     }
// }

// /**
//  * Add passanger to vehicle
//  * @param {int} vehicleid
//  * @param {int} playerid
//  */
// function addVehiclePassenger(vehicleObj, playerid, seat) {
//     if (vehicleObj.passengers == null) {
//         vehicleObj.passengers = array(4, -1);
//     }

//     // push player to vehicle
//     vehicleObj.passengers[seat] = playerid;
//     return true;
// }

// /**
//  * Add passanger to vehicle
//  * @param {int} vehicleid
//  * @param {int} playerid
//  */
// function removeVehiclePassenger(vehicleObj, playerid, seat) {
//     if (vehicleObj.passengers == null) {
//         return;
//     }

//     // migrate passanger to driver
//     if (seat == 0 && vehicleObj.passengers[1] != -1) {
//         vehicleObj.passengers[0] = vehicleObj.passengers[1];
//         vehicleObj.passengers[1] = -1;
//         return true;
//     }

//     vehicleObj.passengers[seat] = -1;
//     return true;
// }

// /**
//  * Return all players in particular vehicle
//  * @param  {obj} vehicleObj
//  * @return {array}
//  */
// function getVehiclePassengers(vehicleObj) {
//     local table = {};

//     if (!!vehicleObj) {
//         return table;
//     }

//     foreach (seat, playerid in vehicleObj.passengers) {
//         if (playerid == -1) continue;
//         table[seat] <- playerid;
//     }

//     return table;
// }

// /**
//  * Return count of all players in particular vehicle
//  * @param  {obj} vehicleObj
//  * @return {int}
//  */
// function getVehiclePassengersCount(vehicleObj) {
//     return (vehicleObj.passengers == null) ? 0 : vehicleObj.passengers.len();
// }

// /**
//  * Return if vehicle empty
//  * @param  {obj}  vehicleObj
//  * @return {Boolean}
//  */
// function isVehicleEmpty(vehicleObj) {
//     return (getVehiclePassengersCount(vehicleObj) < 1);
// }

// /**
//  * Get current player seat id
//  * or null if is not int the vehicle, or not found
//  * @param  {Integer} playerid
//  * @return {Integer} seat
//  */
// function getPlayerVehicleSeat(playerid) {
//     if (!isPlayerInVehicle(playerid)) {
//         return null;
//     }

//     local vehicleid  = getPlayerVehicle(playerid);

//     foreach (seat, targetid in vehicles[vehicleid].passengers) {
//         if (playerid == targetid) return seat;
//     }

//     return null;
// }

// /**
//  * Check if player is sitting in correct seat
//  * @param  {Integer} playerid
//  * @param  {Integer} seat
//  * @return {Boolean} result
//  */
// function isPlayerInVehicleSeat(playerid, seat = 0) {
//     return (isPlayerInVehicle(playerid) && getPlayerVehicleSeat(playerid) == seat);
// }

// /**
//  * Alias for driver
//  * @param  {[type]}  playerid [description]
//  * @return {Boolean}          [description]
//  */
// function isPlayerVehicleDriver(playerid) {
//     return isPlayerInVehicleSeat(playerid, 0);
// }

// /**
//  * Return playerid of vehicle driver
//  * or null if no driver in the vehicle
//  * @param  {[type]}  vehicleid [description]
//  * @return {int}
//  */
// function getVehicleDriver(vehicleid) {
//     if (0 in getVehiclePassengers(vehicleid)) {
//         return getVehiclePassengers(vehicleid)[0];
//     }
//     return null;
// }

// /**
//  * Return playerid of vehicle passenger
//  * or null if no passenger in the vehicle
//  * @param  {[type]}  vehicleid [description]
//  * @return {int}
//  */
// // function getVehiclePassenger(vehicleid) {
// //     if (0 in getVehiclePassengers(vehicleid)) {
// //         return getVehiclePassengers(vehicleid)[1];
// //     }
// //     return null;
// // }
