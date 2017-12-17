// class SwitchableVehiclePart
// {
//     vehicleID = null;  // points which one is parent
//     id = null;
//     switchState = null;

//     constructor (vehicleID, partID, state = 0) {
//         this.vehicleID = vehicleID;
//         this.id = partID;
//         this.switchState = state;
//     }

//     function getState() {
//         return this.switchState;
//     }

//     function setState( to ) {
//         this.switchState = to;
//     }

//     function switches() {
//         setState( !this.switchState );
//     }

//     function correct() {
//         if (this.switchState) {
//             setState( true );
//         } else {
//             setState( false );
//         }
//     }
// }

// class Indicator extends SwitchableVehiclePart
// {

//     constructor (vehicleID, side) {
//         base.constructor(vehicleID, side, false);
//     }

//     // Works only if player in vehicle
//     // Returns true if indicator's on, otherwise return false
//     function getState() {
//         local native = getIndicatorLightState(this.vehicleID, this.id);
//         return this.switchState || native;
//     }

//     function setState(to) {
//         setIndicatorLightState(this.vehicleID, this.id, to);
//         base.setState(to);
//     }

//     function partSwitch() {
//         setState( !this.switchState );
//     }

//     function turnOff() {
//         setState(false);
//     }

//     function turnOn() {
//         setState(true);
//     }
// }
//

// local audio_library = {
//     track = null, //"https://wav-library.net/effect/pack-13/Povorotnik_tikaet.mp3"
//     status = false,
//     objectid = null
// };


class VehicleComponent.Gabarites extends VehicleComponent
{
    static classname = "VehicleComponent.Gabarites";

    static Gabarite_States = {
        both_off = 0,
        left_on = 1,
        right_on = 2,
        both_on = 3,
    }

    // left = null;
    // right = null;

    constructor (data) {
        base.constructor(data);

        if (this.data == null) {
            this.data = {
                status = Gabarite_States.both_off
            }
        }

        // left = Indicator(this.parent.vehicleid, INDICATOR_LEFT);
        // right = Indicator(this.parent.vehicleid, INDICATOR_RIGHT);
        // this.data.status = Gabarite_States.both_off;
    }

    function switchBoth() {
        if( this.data.status == Gabarite_States.both_on) {
            // left.setState(false);
            // right.setState(false);
            this.data.status = Gabarite_States.both_off;
            this.correct();
        } else {
            // left.setState(true);
            // right.setState(true);
            data.status = Gabarite_States.both_on;
            this.correct();
        }
    }

    function switchLeft() {
        if (this.data.status == Gabarite_States.both_on) {
            // right.turnOff();
            this.data.status = Gabarite_States.left_on;
            this.correct();
            return;
        }

        if (this.data.status == Gabarite_States.both_off) {
            // left.partSwitch();
            this.data.status = Gabarite_States.left_on;
            this.correct();
            return;
        }

        if (this.data.status == Gabarite_States.right_on) {
            // right.turnOff();
            // left.partSwitch();
            this.data.status = Gabarite_States.left_on;
            this.correct();
            return;
        }

        if(this.data.status == Gabarite_States.left_on) {
            // left.partSwitch();
            this.data.status = Gabarite_States.both_off;
            this.correct();
            return;
        }
    }

    function switchRight() {
        if (this.data.status == Gabarite_States.both_on) {
            // left.turnOff();
            this.data.status = Gabarite_States.right_on;
            this.correct();
            return;
        }

        if (this.data.status == Gabarite_States.both_off) {
            // right.partSwitch();
            this.data.status = Gabarite_States.right_on;
            this.correct();
            return;
        }

        if(this.data.status == Gabarite_States.left_on) {
            // left.turnOff();
            // right.partSwitch();
            this.data.status = Gabarite_States.right_on;
            this.correct();
            return;
        }

        if (this.data.status == Gabarite_States.right_on) {
            // right.partSwitch();
            this.data.status = Gabarite_States.both_off;
            this.correct();
            return;
        }
    }


    function correct() {
        if (this.data.status == Gabarite_States.both_on) {
            // right.turnOn();
            // left.turnOn();
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_LEFT, true);
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_RIGHT, true);
        }

        if (this.data.status == Gabarite_States.both_off) {
            // right.turnOff();
            // left.turnOff();
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_LEFT, false);
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_RIGHT, false);
        }

        if(this.data.status == Gabarite_States.left_on) {
            // right.turnOff();
            // left.turnOn();
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_RIGHT, false);
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_LEFT, true);
        }

        if (this.data.status == Gabarite_States.right_on) {
            // right.turnOn();
            // left.turnOff();
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_LEFT, false);
            setIndicatorLightState(this.parent.vehicleid, INDICATOR_RIGHT, true);
        }
    }
}


key("z", function(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }
    local vehicleid = getPlayerVehicle(playerid);
    vehicleid = vehicles_native[vehicleid].id;
    local gabs = vehicles[vehicleid].components.findOne(VehicleComponent.Gabarites);

    // if engine is in its place and has expected obj type
    if ((gabs || (gabs instanceof VehicleComponent.Gabarites))) {
        gabs.switchLeft();
        triggerClientEvent(playerid, "indicator_check", gabs.parent.vehicleid, gabs.data.status);
    }
});


key("x", function(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getPlayerVehicle(playerid);
    vehicleid = vehicles_native[vehicleid].id;
    local gabs = vehicles[vehicleid].components.findOne(VehicleComponent.Gabarites);

    // if engine is in its place and has expected obj type
    if ((gabs || (gabs instanceof VehicleComponent.Gabarites))) {
        gabs.switchBoth();
        triggerClientEvent(playerid, "indicator_check", gabs.parent.vehicleid, gabs.data.status);
    }
});


key("c", function(playerid) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    local vehicleid = getPlayerVehicle(playerid);
    vehicleid = vehicles_native[vehicleid].id;
    local gabs = vehicles[vehicleid].components.findOne(VehicleComponent.Gabarites);

    // if engine is in its place and has expected obj type
    if ((gabs || (gabs instanceof VehicleComponent.Gabarites))) {
        gabs.switchRight();
        triggerClientEvent(playerid, "indicator_check", gabs.parent.vehicleid, gabs.data.status);
    }
});
