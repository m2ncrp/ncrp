addEventHandler("onServerClientStarted", function(version) {
    // ped for truck job. Placed in Kingston under Red Bridge.
    local myPed1 = createPed( 145, -704.88, 1461.06, -6.86539, 80.0, -0.000400906, -0.00015495 );
    setPedName( myPed1, "Robert Casey" );

    // ped for bookmakers office, at freddys bar
    local myPed2 = createPed( 86, -50.2636, 743.157, -17.851, -179.49, -0.000195116, -0.000435274 );
    setPedName( myPed2, "Stuart Booker" );

    /**
     * Spawns
     */

     // ped on the platform on the train station
    local trainStationPed = createPed( 154, -557.822, 1685.22, -22.2408, -15.24998, -0.000795216, -0.00502778 );
    setPedName( trainStationPed, "Paulo Matti" );

    // ped near small port office on the pierce
    local portPed = createPed( 62, -342.6, -952.716, -21.7457, -102.052, -0.00627452, 0.00265012 );
    setPedName( portPed, "Edgard Ross" );
});
