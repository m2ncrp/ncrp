const TICKER_STEP = 0.05;
local storage = {};

function lerp(start, alpha, end) {
    return (end - start) * alpha + start;
}

// addEventHandler("onServerSyncPackage", function(pacakage) {
//     storage.clear();
//     storage = JSONParser.parse(pacakage);
// });

// function syncPlayer(record) {
//     if (isPlayerConnected(record.playerid)) {
//         local xpos = getPlayerPosition(record.playerid);

//         if (!("ticker" in record)) {
//             record["ticker"] <- 0.0;
//         }

//         if (record.ticker <= 1.0) {
//             local x = lerp(xpos[0], record.ticker, record.x);
//             local y = lerp(xpos[1], record.ticker, record.y);
//             local z = lerp(xpos[2], record.ticker, record.z);

//             setPlayerPosition(record.playerid, x, y, z);
//             record.ticker += TICKER_STEP;
//         }
//     }
// }

// function syncVehicle(record) {
//     setVehiclePosition(record.vehicleid, record.x, record.y, record.z);
// }

// addEventHandler("onClientProcess", function() {
//     foreach (idx, record in storage) {
//         try {
//             if (record.type == "vehicle") {
//                 syncVehicle(record);
//             } else if (record.type == "player") {
//                 syncPlayer(record);
//             }
//         } catch (e) {}
//     }
// });

local targets = {};

addEventHandler("onClientScriptInit", function() {
    foreach (idx, value in getVehicles()) {
        // TODO: add fligh down fix
    }
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
                pos.ticker += TICKER_STEP;
            }
        }
    }
});

addEventHandler("onServerPlayerSyncPackage", function(playerid, x, y, z) {
    targets[playerid] <- {x = x, y = y, z = z, ticker = 0.0};
});

addEventHandler("onServerPlayerPositionSet", function(id, x, y, z) {
    // targets[playerid] <- {x = x, y = y, z = z, ticker = 0.0};
    setPlayerPosition(id, x, y, z);
});

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
