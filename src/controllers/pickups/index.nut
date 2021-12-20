include("controllers/pickups/commands.nut");

local pickupList = [
    "DLC_ARROW_00",     // arrow DLC
    "DLC_ARROW_01",     // arrow DLC
    "DLC_ARROW_02",     // arrow DLC
    "DLC_ARROW_03",     // arrow DLC
    "DLC_ARROW_04",     // arrow DLC
    "DLC_ARROW_05",     // arrow DLC
    "DLC_ARROW_06",     // arrow DLC
    "DLC_ARROW_07",     // arrow DLC
    "DLC_ARROW_08",     // arrow DLC
    "DLC_ARROW_09",     // arrow DLC
    "DLC_ARROW_10",     // arrow DLC
    "DLC_ARROW_11",     // arrow DLC
    "DLC_ARROW_12",     // arrow DLC
    "DLC_ARROW_13",     // arrow DLC
    "DLC_ARROW_14",     // arrow DLC
    "DLC_ARROW_15",     // arrow DLC
    "DLC_ARROW_16",     // arrow DLC
    "DLC_ARROW_17",     // arrow DLC
    "DLC_ARROW_18",     // arrow DLC
    "DLC_ARROW_19",     // arrow DLC
    "RTR_ARROW_00",     // arrow RTR
    "RTR_ARROW_01",     // arrow RTR
    "RTR_ARROW_02",     // arrow RTR
    "RTR_ARROW_03",     // arrow RTR
    "RTR_ARROW_04",     // arrow RTR
    "RTR_ARROW_05",     // arrow RTR
    "RTR_ARROW_06",     // arrow RTR
    "RTR_ARROW_07",     // arrow RTR
    "RTR_ARROW_08",     // arrow RTR
    "RTR_ARROW_09",     // arrow RTR
    "RTR_ARROW_10",     // arrow RTR
    "RTR_ARROW_11",     // arrow RTR
    "RTR_ARROW_12",     // arrow RTR
    "RTR_ARROW_13",     // arrow RTR
    "RTR_ARROW_14",     // arrow RTR
    "RTR_ARROW_15",     // arrow RTR
    "RTR_ARROW_16",     // arrow RTR
    "RTR_ARROW_17",     // arrow RTR
    "RTR_ARROW_18",     // arrow RTR
    "RTR_ARROW_19",     // arrow RTR
    "DLC_MISSIONEND1_00",  // house
    "RTR_MISSIONEND1_00",  // house
    "DLC_SAVE_00",         // house
    "DLC_PARKING1_00",     // parking
    "RTR_POUTA1_00",       // cuff
    "RTR_CD1_00",          // wheel
    "RTR_CD1_01",          // wheel
    "RTR_CD1_02",          // wheel
    "DLC_BRUSKY_00",       // B red
    "DLC_BRUSKY_01",       // B red
    "DLC_BRUSKY_D_00",     // B silver
    "DLC_BRUSKY_D_01",     // B silver
    "DLC_CHARLIE_00",      // C red
    "DLC_CHARLIE_01",      // C red
    "DLC_CHARLIE_D_00",    // C silver
    "DLC_CHARLIE_D_01",    // C silver
    "DLC_EDDIE_00",        // E red
    "DLC_EDDIE_01",        // E red
    "DLC_EDDIE_D_00",      // E silver
    "DLC_EDDIE_D_01",      // E silver
    "DLC_EDDIE_G_00",      // E gold
    "DLC_GIUSEPPE_00",     // G red
    "DLC_GIUSEPPE_01",     // G red
    "DLC_GIUSEPPE_D_00",   // G silver
    "DLC_GIUSEPPE_D_01",   // G silver
    "DLC_JOE_G_00",        // J gold
    "DLC_MARTY_00",        // M red
    "DLC_MARTY_01",        // M red
    "DLC_MARTY_D_00",      // M silver
    "DLC_MARTY_D_01",      // M silver
    "DLC_ROCCO_00",        // R red
    "DLC_ROCCO_01",        // R red
    "DLC_ROCCO_D_00",      // R silver
    "DLC_ROCCO_D_01",      // R rsilvered
    "DLC_TONY_00",          // T red
    "DLC_TONY_01",          // T red
    "DLC_TONY_D_00",        // T silver
    "DLC_TONY_D_01",        // T silver
    "DLC_TONY_G_00",        // T gold
    "RTR_BO4_00",           // B with 4 stars gold big
    "RTR_BO4fin00",         // B with 4 stars gold small [no textures]
    "DLC_TIMER_00",     // Timer
    "DLC_TIMER_01",     // Timer
    "DLC_TIMER_02",     // Timer
    "RTR_CH1_00",       // One star
    "RTR_CH1_01",       // One star
    "RTR_CH2_00",       // Two star
    "RTR_CH2_01",       // Two star
    "RTR_CH3_00",       // Three star
    "RTR_CH3_01",       // Three star
    "RTR_CH4_00",       // Gold star
    "RTR_FI4_00",       // head with tesak big
    "RTR_FI4fin00",     // head with tesak small [no textures]
    "RTR_IR1_00",       // knife and podkova One star Green
    "RTR_IR1_01",       // knife and podkova One star Green
    "RTR_IR1fin00",     // knife and podkova One star Green  small [no textures]
    "RTR_IR1fin01",     // knife and podkova One star Green  small [no textures]
    "RTR_IR2_00",       // knife and podkova Two stars Bronze
    "RTR_IR2_01",       // knife and podkova Two stars Bronze
    "RTR_IR2fin00",     // knife and podkova Two stars Bronze  small [no textures]
    "RTR_IR2fin01",     // knife and podkova Two stars Bronze  small [no textures]
    "RTR_IR3_00",       // knife and podkova Three stars Silver
    "RTR_IR3_01",       // knife and podkova Three stars Silver
    "RTR_IR3fin00",     // knife and podkova Three stars Silver  small [no textures]
    "RTR_IR3fin01",     // knife and podkova Three stars Silver  small [no textures]
    "RTR_IR4_00",       // knife and podkova Four stars Gold
    "RTR_IR4fin00",     // knife and podkova Four stars Gold  small [no textures]
    "RTR_IT1_00",       // Weapons Green One Star
    "RTR_IT1_01",       // Weapons Green One Star
    "RTR_IT1fin00",     // Weapons Green One Star small [no textures]
    "RTR_IT1fin01",     // Weapons Green One Star small [no textures]
    "RTR_IT2_00",       // Weapons Bronze Two Stars
    "RTR_IT2_01",       // Weapons Bronze Two Stars
    "RTR_IT2fin00",     // Weapons Bronze Two Stars small [no textures]
    "RTR_IT2fin01",     // Weapons Bronze Two Stars small [no textures]
    "RTR_IT3_00",       // Weapons Silver Three Stars
    "RTR_IT3_01",       // Weapons Silver Three Stars
    "RTR_IT3fin00",     // Weapons Silver Three Stars small [no textures]
    "RTR_IT3fin01",     // Weapons Silver Three Stars small [no textures]
    "RTR_IT4_00",       // Weapons Gold Four Stars
    "RTR_IT4fin00",     // Weapons Gold Four Stars small [no textures]
    "RTR_PARKING1_00",  // parking Bronze broken
    // "DLC_Sound_Tick",   // Ticker
]

event("onServerStarted", function() {
    logStr("[pickups] loading pickup module...");
});

 event("onServerPlayerStarted", function(playerid) {
    triggerClientEvent(playerid, "loadPickups");
    // foreach (idx, pickup in pickupList) {
    //     dbg(pickup, idx)
    //     local x = round(idx/20, 1)
    //     local y = idx%20;
    //     createPickup(pickup, -400.429 + x * 2.5, 900.0 - 2.5*y, -19.0026);
    //     // rotatePickup(pickup);
    // }

    delayedFunction(2000, function() {
        createPickup("RTR_ARROW_00", -393.429, 912.044, -19.0026);
        rotatePickup("RTR_ARROW_00");
    })
    // delayedFunction(5000, function() {
    //     createPickup("RTR_ARROW_00", -393.429, 915.044, -19.0026);
    // })
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

function stopPickup(name) {
    foreach (idx, data in players) {
        triggerClientEvent(idx, "stopPickup", name);
    }
}

function rotatePickup(name) {
    foreach (idx, data in players) {
        triggerClientEvent(idx, "rotatePickup", name);
    }
}

function destroyPickup(name) {
    foreach (idx, data in players) {
        triggerClientEvent(idx, "destroyPickup", name);
    }
}

// function createPrivatePickup (playerid, name, x, y, z) {
//     triggerClientEvent(playerid, "createPickup", name, x.tofloat(), y.tofloat(), z.tofloat());
// }

// function removePrivatePickup(playerid, name) {
//     triggerClientEvent(playerid, "destroyPickup", name);
// }