class OwnableVehicle extends LockableVehicle {
    static classname = "OwnableVehicle";
    ownership = null;

    constructor (model, px, py, pz, rx = 0.0, ry = 0.0, rz = 0.0) {
        base.constructor(model, px, py, pz, rx, ry, rz);

        ownership = {
            status   = VEHICLE_OWNERSHIP_NONE,
            owner    = null,
            ownerid  = -1,
        };
    }

    /**
     * Set vehicle owner
     * can be passed as playername or connected playerid
     *
     * @param {Mixed} playerNameOrId
     */
    function setOwner(playerNameOrId, ownerid = null) {
        local playerid = -1;

        // if its id - get name from it
        if (typeof playerNameOrId == "integer") {
            if (isPlayerConnected(playerNameOrId)) {
                playerid = playerNameOrId;
                playerNameOrId = getPlayerName(playerNameOrId);
            } else {
                return dbg("[vehicle] OwnableVehicle.setOwner: trying to set for playerid that aint connected #" + playerNameOrId);
            }
        } else {
            playerid = getPlayerIdFromName(playerNameOrId);
        }

        this.ownership.status = VEHICLE_OWNERSHIP_SINGLE;
        this.ownership.owner = playerNameOrId;

        if (playerid != -1 && isPlayerLoaded(playerid)) {
            this.ownership.ownerid = players[playerid].id;
        } else if (ownerid) {
            this.ownership.ownerid = ownerid.tointeger();
        }
        return true;
    }


    /**
     * Get vehicle owner name or null
     *
     * @return {mixed}
     */
    function getOwner() {
        return this.ownership.owner;
    }


    /**
     * Check if current connected player is owner of ther car
     *
     * @param  {integer}  playerid
     * @return {Boolean}
     */
    function isOwner(playerid) {
        return (isPlayerConnected(playerid) && isPlayerLoaded(playerid) && getOwnerId() == players[playerid].id);
    }


    /**
     * Checks if current vehicle has owner
     * @return {Boolean}
     */
    function isOwned() {
        return (getOwnerId() != -1);
    }


    /**
     * Get vehicle owner name or null
     *
     * @return {mixed}
     */
    function getOwnerId() {
        return this.ownership.ownerid;
    }


    events = [
        event("native:onPlayerVehicleEnter", function( playerid, vehicleid, seat ) {
            local vehicle = __vehicles.get(vehicleid);
            // check blocking
            if (vehicle.isOwned() && seat == 0) {
                dbg("player", "vehicle", "enter", vehicle.getPlate(), getIdentity(playerid), "owned: " + vehicle.isOwner(playerid));

                if (vehicle.isOwner(playerid)) {
                    msg(playerid, "It's your vehicle.");
                    // Don't block it
                    vehicle.unblock();
                } else {
                    msg(playerid, "It's not your vehicle!");
                    // Block it
                    vehicle.block();
                }
            }
        }),

        event("native:onPlayerVehicleExit", function( playerid, vehicleid, seat ) {
            // handle vehicle passangers
            local veh = __vehicles.get(vehicleid);
            // check blocking
            if ( veh.isOwned() && isOwner(playerid) ) {
                veh.block();
            }
        })
    ];
}
