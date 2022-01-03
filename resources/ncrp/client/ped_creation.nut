addEventHandler("onServerClientStarted", function(version) {
    #   model       x          y           z         rot x          rot y          roy z        name        #
    local pedsArray = [
        [145,    -704.88,   1461.06,   -6.86539,       80.0,   -0.000400906,   -0.00015495, "Robert Casey"  ], // ped for truck job. Placed in Kingston under Red Bridge.
        // [109,    610.033, 744.465, -16.5903,          150.0,            0.0,           0.0, "Jonathan Neil"  ], // ped for truck shop
        [154,   -557.706,   1698.31,   -22.2408,    24.3432,     0.00231509,    -0.0055519, " "   ], // ped on the platform on the train station
        //[62,      -342.6,  -952.716,   -21.7457,    -10.052,    -0.00627452,    0.00265012, "Edgard Ross"   ], // ped near small port office on the pierce
        [52,     389.032,   128.104,   -20.2027,      135.0,    0.000657043,   -0.00108726, "Lao Chen"      ], // ped at Seagift
        // [75,     169.415,  -334.993,   -20.1634,      270.0,   -0.000566336,   -0.00311189, "Oliver Parks"  ], // ped at Cop
        //[171,   -720.586,   248.261,   0.365978,    51.2061,    0.000172777,   -0.00688932, "Daniel Burns"  ], // ped at Taxi
        [148,   -1586.8,    1694.74,  -0.336785,      135.0,    0.000169911,   -0.00273992, "Jack Hicks"    ], // ped at Car Dealer
        [116,   -122.331,  -62.9116,    -12.041,    45.2061,    0.000169911,   -0.00273992, "Sara Johnson"    ], // ped at government
        // [86,    -50.2636, 743.157, -17.851,     -179.49, -0.000195116, -0.000435274, "Stuart Booker"],  // ped for bookmakers office, at freddys bar
    ];

    log("creating peds");

    for (local i = 0; i < pedsArray.len(); i++) {
        local pedSubArray = pedsArray[i];
        local pedid = createPed(  pedSubArray[0], pedSubArray[1], pedSubArray[2], pedSubArray[3], pedSubArray[4], pedSubArray[5], pedSubArray[6]);
        setPedName(pedid, pedSubArray[7]);
    }

    log("peds created");
});

function round(val, decimalPoints) {
    local f = pow(10, decimalPoints) * 1.0;
    local newVal = val * f;
    newVal = floor(newVal + 0.5)
    newVal = (newVal * 1.0) / f;
   return newVal;
}

local pedsTaxiArray = {};
addEventHandler("createPedTaxiPassenger", function(playerName, skin, x, y, z, rx, ry, rz) {
   if ( ! (playerName in pedsTaxiArray) ) {
       pedsTaxiArray[playerName] <- {};
   }
   // приводим угол поворота к правильному, округляем до 2 знаком после запятой
   local nrx = round(rx.tofloat() * 0.016667, 2);
   local pedid = createPed( skin, x.tofloat(), y.tofloat(), z.tofloat(), nrx, ry.tofloat(), rz.tofloat());
   setPedName(pedid, " ");

   pedsTaxiArray[playerName]["pedid"] <- pedid;
});

addEventHandler("destroyPedTaxiPassenger", function(playerName) {
   destroyPed( pedsTaxiArray[playerName]["pedid"] );
});
