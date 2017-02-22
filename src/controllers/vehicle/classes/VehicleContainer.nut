class VehicleContainer extends Container
{
    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor() {
        base.constructor(Vehicle);
    }


    /**
     * Find nearest vehicle id to particular player
     * @param  {Integer} playerid
     * @return {Integer}
     */
    function nearestVehicle(playerid) {
        local min = null;
        local closestid = null;

        // iterate over player, and calculate distance with each one
        foreach(targetid, data in this.getAll()) {
            local dist = getDistance(playerid, targetid);

            // compare with smallest, and if less - override smallest
            if ((dist < min || !min) && targetid != playerid) {
                min = dist;
                closestid = targetid;
            }
        }
        return closestid;
    }
}
