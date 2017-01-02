local passangerPositions = [
    [-0.386, 3.255,  -0.4332, null],  // 0
    [0.183,  3.215,  -0.4421, null],  // 1
    [-0.389, 1.465,  -0.7379, null],  // 2
    [0.257,  1.513,  -0.4479, null],  // 3
    [-0.391, 0.593,  -0.4399, null],  // 4
    [0.234,  0.608,  -0.4497, null],  // 5
    [-0.394, -0.608, -0.4428, null],  // 6
    [0.239,  -0.618, -0.4531, null],  // 7
    [-0.901, -1.962, -0.4405, null],  // 8
    [0.298,  -2.314, -0.4611, null],  // 9
    [-0.393, -2.269, -0.4519, null],  // 10
    [0.296,  -3.712, -0.4631, null]   // 11
];

// Recalculate relative passanger position by rotating X axis only
// local relX = seat[0]*cos(angle) - seat[1]*sin(angle);
// local relY = seat[0]*sin(angle) + seat[1]*cos(angle);
// 
// Get true coordinates of passanger from bus center
// local pos = getVehiclePosition(busid);
// setPlayerPosition(playerid, pos[0] + relX, pos[1] + relY, pos[2] + seat[2]);

class Bus extends Vehicle {
    MAX_SEATS = 11;
    seats = null;
    
    constructor (model, px, py, pz, rx, ry, rz) {
        base.constructor(model, px, py, pz, rx, ry, rz);
        seats = BasePool(12, passangerPositions);
    }

    /**
     * Return true if given seat is free
     * @param  {integer}  seat 
     * @return {Boolean}
     */
    function isSeatFree(seat) {
        return seats[seat][3] == null;
    }

    /**
     * Return array [X, Y, Z, passangerID] of random free seat
     * @param  {integer}    playerid
     * @return {array}      seat info
     */
    function getRandomSeat(playerid) {
        local seat = random(0, passangerPositions.len()-1);
        // get free seat
        if ( !isSeatFree(seat) ) {
            return getRandomSeat(playerid);
        }
        return seats[seat];
    }

    events = [
       addEventHandler("onServerPlayerBusEnter", function( playerid, vehicleid ) {

            return 1;
       })
    ];
}
