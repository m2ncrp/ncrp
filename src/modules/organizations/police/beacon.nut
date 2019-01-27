/**
 * Switch police vehicle beacon
 * @param  {int} playerid
 */
function switchBeaconLight(playerid) {
    local vehicleid = getPlayerVehicle( playerid );
    local prevState = getVehicleBeaconLightState( vehicleid );
    setVehicleBeaconLightState( vehicleid, !prevState );
}
