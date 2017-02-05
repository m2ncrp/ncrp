local ticker = null;

addEventHandler("onServerClientStarted", function(version) {
    local peds = [
        [145,   -704.88,  1461.06, -6.86539,       80.0, -0.000400906,  -0.00015495, "Robert Casey"],  // ped for truck job. Placed in Kingston under Red Bridge.
        // [86,    -50.2636, 743.157, -17.851,     -179.49, -0.000195116, -0.000435274, "Stuart Booker"],  // ped for bookmakers office, at freddys bar
        [154,   -557.706, 1698.31, -22.2408,    24.3432,   0.00231509,   -0.0055519, "Paulo Matti" ], // ped on the platform on the train station
        [62,    -342.6,  -952.716, -21.7457,    -10.052,  -0.00627452,   0.00265012, "Edgard Ross" ], // ped near small port office on the pierce
        [52,    389.032,  128.104, -20.2027,      135.0, 0.000657043, -0.00108726, "Lao Chen" ], // ped at Seagift
        [75,    169.415, -334.993, -20.1634, 270.0, -0.000566336, -0.00311189, "Oliver Parks" ], // ped at Seagift
        [171,   -720.586, 248.261, 0.365978, 51.2061, 0.000172777, -0.00688932, "Daniel  Burns" ], // ped at Seagift
    ];

    if (ticker) {
        return;
    }

    log("creating peds");

    // create peds
    foreach (idx, data in peds) {
        local tmp = clone(data);
        tmp.insert(0, getroottable()); tmp.pop();
        local ped = createPed.acall(tmp);
        data.push(ped);
        setPedName(ped, data[data.len() - 2]);
    }

    log("peds created");

    // // reset positons
    // ticker = timer(function() {
    //     setPedPosition(data[data.len() - 1], data[1], data[2], data[3]);
    // }, 250);
});