/**
 * Algorithm of slaughterhouse worker
 * 1. Steam cleaning (remove dirt and other contaminants)
 * 2. Remove animal hide
 * 3. Cut with massive splitter saws
 * 4. Keep pork in cold storage for number of days
 * 5. Put it on line and move to cutting table
 * 6. Packing meat (produce steakes, sausages or mince)
 * 7. Get payment
 *
 * Algorithm of slaughterhouse driver
 * 1. Load packages of meat into truck
 * 2. Transport it to food types of businesses.
 * 3. Back to slaughterhouse for payment
 *
 * Resources:
 * 1. https://upload.wikimedia.org/wikipedia/commons/a/a9/Pork_packing_in_Cincinnati_1873.jpg?uselang=ru
 * 2. https://www.youtube.com/watch?v=6UxWIDm5jxI
 *
 * Actions on work:
 * 1. Got injured by saw (big damage) or knife (medium damage)
 * 2. Cut out finger (couse blood left ~ slow death)
 * 3. Die from hook
 * 4. Die on rendering machine
 */


event("onServerStarted", function() {
    createVehicle(34, 22.6424, 1810.16, -17.5449, 90.0, 0.0, 0.0);
    createVehicle(34, 28.9143, 1811.15, -17.5465, 180.0, 0.0, 0.0);
    createVehicle(34, 35.9682, 1811.41, -17.5501, 180.0, 0.0, 0.0);
    createVehicle(34, 45.0284, 1811.01, -17.5489, 180.0, 0.0, 0.0);
    createVehicle(34, 49.7049, 1811.26, -17.55  , 180.0, 0.0, 0.0);

    create3DText( 13.9297, 1810.26, -16.9628, "get slaughterhouse worker job", CL_RIPELEMON, 4000.0);

    create3DText( 25.9416, 1830.11, -16.9628, "Storage on Clemente&Co", CL_RIPELEMON, 4000.0);

    // cutting tables
    create3DText( 25.1438, 1843.63, -16.9627, "cutting table", CL_RIPELEMON, 2.0); // 1
    create3DText( 25.1001, 1845.86, -16.9626, "cutting table", CL_RIPELEMON, 2.0); // 2
    create3DText( 22.4607, 1845.86, -16.9626, "cutting table", CL_RIPELEMON, 2.0); // 3
    create3DText( 22.4572, 1843.72, -16.9627, "cutting table", CL_RIPELEMON, 2.0); // 4
    create3DText( 28.5079, 1843.54, -16.962 , "cutting table", CL_RIPELEMON, 2.0); // 5
    create3DText( 28.4034, 1845.84, -16.9614, "cutting table", CL_RIPELEMON, 2.0); // 6
    create3DText( 31.1511, 1843.62, -16.9614, "cutting table", CL_RIPELEMON, 2.0); // 7
    create3DText( 31.1091, 1845.73, -16.9608, "cutting table", CL_RIPELEMON, 2.0); // 8
    create3DText( 33.7123, 1847.27, -16.9627, "cutting table", CL_RIPELEMON, 2.0); // 9
    create3DText( 33.6718, 1849.54, -16.9626, "cutting table", CL_RIPELEMON, 2.0); // 10
    create3DText( 12.0871, 1846.38, -16.9626, "cutting table", CL_RIPELEMON, 2.0); // 11

    create3DText( 35.8693, 1791.79, -17.8628, "slaughterhouse driver get job", CL_RIPELEMON, 4000.0);
    // 51.435, 1799.25, -17.141 // Get route list
    // 60.9491, 1803.31, -17.8655 // Get load from dat storage

    // 22.6424, 1810.16, -17.5449 // vehicle 1
    // 28.9143, 1811.15, -17.5465 // 2
    // 35.9682, 1811.41, -17.5501 // 3
    // 45.0284, 1811.01, -17.5489 // 4
    // 49.7049, 1811.26, -17.55   // 5


    create3DText( 797.488, 843.595, -11.7611, "load animals", CL_RIPELEMON, 4000.0);
    create3DText( 777.391, 844.812, -11.7623, "load animals", CL_RIPELEMON, 4000.0);
});
