enum Gabarite_States {
    both_off,   // 0
    left_on,    // 1
    right_on,   // 2
    both_on     // 3
}

class Gabarites {
    left = null;
    right = null;
    current_state = null;
    
    constructor (vehicleID) {
        left = Indicator(vehicleID, INDICATOR_LEFT);
        right = Indicator(vehicleID, INDICATOR_RIGHT);
        this.current_state = Gabarite_States.both_off;
    }

    function switchBoth() {
        if( current_state == Gabarite_States.both_on) {
            left.setState(false);
            right.setState(false);
            current_state = Gabarite_States.both_off;
        } else {
            left.setState(true);
            right.setState(true);
            current_state = Gabarite_States.both_on;
        }
    }

    function switchLeft() {
        if (current_state == Gabarite_States.both_on) {
            right.turnOff();
            current_state = Gabarite_States.both_off;
            return;
        }

        if (current_state == Gabarite_States.both_off) {
            left.partSwitch();
            current_state = Gabarite_States.left_on;
            return;
        }

        if (current_state == Gabarite_States.right_on) {
            right.turnOff();
            left.partSwitch();
            current_state = Gabarite_States.left_on;
            return;
        }

        if(current_state == Gabarite_States.left_on) {
            left.partSwitch();
            current_state = Gabarite_States.both_off;
            return;
        }
    }

    function switchRight() {
        if (current_state == Gabarite_States.both_on) {
            left.turnOff();
            current_state = Gabarite_States.right_on;
            return;
        }

        if (current_state == Gabarite_States.both_off) {
            right.partSwitch();
            current_state = Gabarite_States.right_on;
            return;
        }

        if(current_state == Gabarite_States.left_on) {
            left.turnOff();
            right.partSwitch();
            current_state = Gabarite_States.right_on;
            return;
        }

        if (current_state == Gabarite_States.right_on) {
            right.partSwitch();
            current_state = Gabarite_States.both_off;
            return;
        }
    }

    function correct() {
        if (current_state == Gabarite_States.both_on) {
            right.turnOn();
            left.turnOn();
        }

        if (current_state == Gabarite_States.both_off) {
            right.turnOff();
            left.turnOff();
        }

        if(current_state == Gabarite_States.left_on) {
            right.turnOff();
            left.turnOn();
        }

        if (current_state == Gabarite_States.right_on) {
            right.turnOn();
            left.turnOff();
        }
    }
}
