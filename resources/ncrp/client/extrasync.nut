// local busses = {};
// local syncing = [];
// local ticker = null;

// addEventHandler("onServerClientStarted", function() {
//     if (ticker) return;

//     // check for distances of the busses
//     ticker = timer(function() {
//         syncing.clear();

//         foreach (idx, passangers in busses) {
//             local bus = getVehiclePosition(idx);
//             local pos = getPlayerPosition(getLocalPlayer());
//             if (getDistanceBetweenPoints2D(bus[0], bus[1], pos[0], pos[1]) < 50.0) {
//                 syncing.push(idx);
//             }
//         }
//     }, 1000, -1);
// });

// addEventHandler("onServerClientStopped", function() {
//     ticker.Kill();
//     ticker = null;
// });

// addEventHandler("onServerPlayerBusEnter", function(playerid, busid) {
//     if (!(busid in busses)) {
//         busses[busid] <- [];
//     }

//     busses[busid].push(playerid);
// });

const STEP    = 0.05;
local targets = {};

function lerp(start, alpha, end) {
    return (end - start) * alpha + start;
}

addEventHandler("onServerSyncPackage", function(playerid, x, y, z) {
    targets[playerid] <- {x = x, y = y, z = z, ticker = 0.0};
});

addEventHandler("onClientProcess", function() {
    foreach (playerid, pos in targets) {
        if (isPlayerConnected(playerid)) {
            local xpos = getPlayerPosition(playerid);

            if (pos.ticker <= 1.0) {
                local x = lerp(xpos[0], pos.ticker, pos.x);
                local y = lerp(xpos[1], pos.ticker, pos.y);
                local z = lerp(xpos[2], pos.ticker, pos.z);

                setPlayerPosition(playerid, x, y, z);
                pos.ticker += STEP;
            }
        }
    }
});
