function createPrivatePickup (playerid, name, x, y, z) {
    triggerClientEvent(playerid, "createPickup", name, x.tofloat(), y.tofloat(), z.tofloat());
}

function removePrivatePickup(playerid, name) {
    triggerClientEvent(playerid, "destroyPickup", name);
}


function createGlobalPickup (name, x, y, z) {
    foreach (idx, data in players) {
        triggerClientEvent(idx, "createPickup", name, x.tofloat(), y.tofloat(), z.tofloat());
    }
}

function removeGlobalPickup(name) {
    foreach (idx, name in players) {
        triggerClientEvent(idx, "destroyPickup", name);
    }
}


event("onServerPlayerStarted", function(playerid) {
    dbg("ya")
    triggerClientEvent(playerid, "loadPickups");
    delayedFunction(1000, function() {
        createGlobalPickup("RTR_ARROW_00", -393.429, 912.044, -19.0026);
    })
    delayedFunction(5000, function() {
        createGlobalPickup("RTR_ARROW_00", -393.429, 912.044, -19.0026);
    })
});
