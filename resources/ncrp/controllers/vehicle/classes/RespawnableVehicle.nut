VEHICLE_RESPAWN_PLAYER_DISTANCE <- pow(20, 2);

class RespawnableVehicle extends SeatableVehicle {
    static classname = "RespawnableVehicle";
    respawn = null;

    constructor (model, seats, px, py, pz, rx = 0.0, ry = 0.0, rz = 0.0) {
        base.constructor(model, seats, px, py, pz, rx, ry, rz);

        respawn = {
            enabled = true,
            position = { x = px.tofloat(), y = py.tofloat(), z = pz.tofloat() },
            rotation = { x = rx.tofloat(), y = ry.tofloat(), z = rz.tofloat() },
            time = getTimestamp(),
        };
    }

    /**
     * Set if vehicle can be automatically respawned
     * @param  {bool} value
     * @return {bool}
     */
    function setRespawnEx(value) {
        return this.respawn.enabled = value;
    }


     /**
     * Trigger vehicle respawn
     * (on position where it was created)
     *
     * @param  {int} vehicleid
     * @param  {bool} forced
     * @return {boolean}
     */
    function tryRespawn(forced = false) {
        local data = this.respawn;

        if (!forced) {
            if (!data.enabled) {
                return false;
            }

            if ((getTimestamp() - data.time) < VEHICLE_RESPAWN_TIME) {
                return false;
            }

            // if vehicle not emtpty - reset timestamp
            if (!isEmpty()) {
                data.time = getTimestamp();
                return false;
            }
        }

        // repair and refuel
        this.repair();

        // NOTE(inlife): might be bugged (stopping vehicles)
        this.setSpeed(0.0, 0.0, 0.0);

        if (!forced) {
            // maybe vehicle already near its default place
            // if (isVehicleNearPoint(vehicleid, data.position.x, data.position.y, 1.0)) {
            //     return false;
            // }

            foreach (playerid, value in players) {
                local ppos = getPlayerPosition(playerid);
                local vpos = getVehiclePosition(vehicleid);

                // dont respawn if player is near
                if ((pow(ppos[0] - vpos[0], 2) + pow(ppos[1] - vpos[1], 2)) < VEHICLE_RESPAWN_PLAYER_DISTANCE) {
                    dbg("vehicle", "respawn", "not respawning because of close player distance", getVehiclePlateText(vehicleid), getAuthor(playerid));
                    data.time = getTimestamp();
                    return false;
                }
            }
        }

        // reset respawn time
        data.time = getTimestamp();
        // reset position/rotation
        this.setPos(data.position.x, data.position.y, data.position.z);
        this.setRot(data.rotation.x, data.rotation.y, data.rotation.z);
        // reset other parameters
        this.setEngineState(false);
        this.setDirlLevel( randomf(VEHICLE_MIN_DIRT, VEHICLE_MAX_DIRT) );
        return true;
    }

    /**
     * Reset vehicle respawn timer
     * @return {bool}
     */
    function resetRespawnTimer() {
        this.respawn.time = getTimestamp();
        return true;
    }



    events = [
        event("native:onPlayerVehicleEnter", function( playerid, vehicleid, seat ) {
            // handle vehicle passangers
            local veh = __vehicles.get(vehicleid);
            veh.resetRespawnTimer();
            veh.save();

            // trigger other events
            // trigger("onPlayerVehicleEnter", playerid, vehicleid, seat);
        }),

        event("native:onPlayerVehicleExit", function( playerid, vehicleid, seat ) {
            // handle vehicle passangers
            local veh = __vehicles.get(vehicleid);
            veh.resetRespawnTimer();
            veh.save();

            // trigger other events
            // trigger("onPlayerVehicleExit", playerid, vehicleid, seat);
        })
    ];
}
