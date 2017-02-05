local busses = {};
local syncing = [];
local ticker = null;

local passangerPositions = [
    [-0.386, 3.255,  -0.4332, null],
    [0.183,  3.215,  -0.4421, null],
    [-0.389, 1.465,  -0.7379, null],
    [0.257,  1.513,  -0.4479, null],
    [-0.391, 0.593,  -0.4399, null],
    [0.234,  0.608,  -0.4497, null],
    [-0.394, -0.608, -0.4428, null],
    [0.239,  -0.618, -0.4531, null],
    [-0.901, -1.962, -0.4405, null],
    [0.298,  -2.314, -0.4611, null],
    [-0.393, -2.269, -0.4519, null],
    [0.296,  -3.712, -0.4631, null]
];

/**
 * Generate random number (int)
 * from a range
 * by default range is 0...RAND_MAX
 *
 * @param  {int} min
 * @param  {int} max
 * @return {int}
 */
function random(min = 0, max = RAND_MAX) {
    return (rand() % ((max + 1) - min)) + min;
}

function getPlayerSeat(playerid, busid) {
    foreach (idx, seat in busses[busid]["seats"]) {
        if ( playerid == seat[3] ) {
            return seat;
        }
    }
    return null;
}

addEventHandler("onServerClientStarted", function(version) {
    if (ticker) return;

    // check for distances of the busses
    ticker = timer(function() {
        syncing.clear();

        foreach (idx, passangers in busses) {
            local bus = getVehiclePosition(idx);
            local pos = getPlayerPosition(getLocalPlayer());
            if (getDistanceBetweenPoints2D(bus[0], bus[1], pos[0], pos[1]) < 50.0) {
                syncing.push(idx);
            }
        }
    }, 1000, -1);
});

addEventHandler("onServerClientStopped", function() {
    ticker.Kill();
    ticker = null;
});

addEventHandler("onServerPlayerBusEnter", function(playerid, busid) {
    if (!(busid in busses)) {
        busses[busid] <- {};
        busses[busid]["seats"] <- passangerPositions;
    }

    local seat = random(0, passangerPositions.len()-1);
    seat = passangerPositions[seat];

    busses[busid].push(playerid);
    busses[busid]["seats"][seat][3] = playerid;
});

addEventHandler("onServerPlayerBusExit", function(playerid, busid) {
    if (!(busid in busses)) {
        return;
    }

    local idx = busses[busid].find(playerid);

    if (idx) {
        busses[busid].remove(idx);
    }
});

addEventHandler("onClientFrameRender", function(a) {
    if (a) {
        for (local i = 0; i < syncing.len(); i++) {
            local busid = syncing[i];
            local seat = random(0, passangerPositions.len()-1);
            seat = passangerPositions[seat];
            local pos = getVehiclePosition(busid);
            local angle = getVehicleRotation(busid)[0] * 3.1415 / 180.0;
            
            local relX = seat[0]*cos(angle) - seat[1]*sin(angle);
            local relY = seat[0]*sin(angle) + seat[1]*cos(angle);

            foreach (idx, playerid in busses[busid]) {
                setPlayerPosition(playerid, pos[0] + relX, pos[1] + relY, pos[2] + seat[2]);
            }
        }
    }
});
