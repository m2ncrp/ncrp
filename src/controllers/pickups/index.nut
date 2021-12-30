include("controllers/pickups/commands.nut");
include("controllers/pickups/constants.nut");
include("controllers/pickups/test.nut");

event("onServerStarted", function() {
    logStr("[pickups] loading pickup module...");
});

function createPickup(name, x, y, z) {
    foreach (idx, data in players) {
        triggerClientEvent(idx, "createPickup", name, x.tofloat(), y.tofloat(), z.tofloat());
    }
}

function movePickup(name, x, y, z) {
    foreach (idx, data in players) {
        triggerClientEvent(idx, "movePickup", name, x.tofloat(), y.tofloat(), z.tofloat());
    }
}

function rotatePickup(name) {
    foreach (idx, data in players) {
        triggerClientEvent(idx, "rotatePickup", name);
    }
}

function stopRotationPickup(name) {
    foreach (idx, data in players) {
        triggerClientEvent(idx, "stopRotationPickup", name);
    }
}

function destroyPickup(name) {
    foreach (idx, data in players) {
        triggerClientEvent(idx, "destroyPickup", name);
    }
}

function createPrivatePickup(playerid, name, x, y, z) {
    triggerClientEvent(playerid, "createPickup", name, x.tofloat(), y.tofloat(), z.tofloat());
}

function movePrivatePickup(playerid, name,  x, y, z) {
    triggerClientEvent(playerid, "movePickup", name, x.tofloat(), y.tofloat(), z.tofloat());
}

function rotatePrivatePickup(playerid, name) {
    triggerClientEvent(playerid, "rotatePickup", name);
}

function stopRotationPrivatePickup(playerid, name) {
    triggerClientEvent(playerid, "stopRotationPickup", name);
}

function destroyPrivatePickup(playerid, name) {
    triggerClientEvent(playerid, "destroyPickup", name);
}
