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
        }

        if (current_state == Gabarite_States.both_off) {
            left._switch();
        }

        if (current_state == Gabarite_States.right_on) {
            right.turnOff();
            left._switch();
        }

        if(current_state == Gabarite_States.left_on) {
            left._switch();
        }

        current_state = Gabarite_States.left_on;
    }

    function switchRight() {
        if (current_state == Gabarite_States.both_on) {
            left.turnOff();
        }

        if (current_state == Gabarite_States.both_off) {
            right._switch();
        }

        if(current_state == Gabarite_States.left_on) {
            left.turnOff();
            right._switch();
        }

        if (current_state == Gabarite_States.right_on) {
            right._switch();
        }

        current_state = Gabarite_States.right_on;
    }
}
