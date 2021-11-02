include("modules/jobs/busdriver/commands.nut");
include("modules/jobs/busdriver/passengers.nut");
include("modules/jobs/busdriver/translations.nut");

local job_bus = {};
local job_bus_blocked = {};
local busStops = {};
local routes = {};

local RADIUS_BUS = 2.0;
local RADIUS_BUS_SMALL = 1.0;
local RADIUS_BUS_STOP = 2.0;
local BUS_JOB_X = -422.731;
local BUS_JOB_Y = 479.372;
local BUS_JOB_Z = 0.10922;

local BUS_JOB_NAME = "busdriver";
local BUS_JOB_TIMEOUT = 1800; // 30 minutes
local BUS_JOB_SKIN = 171;
local BUS_JOB_DISTANCE = 100;
local BUS_JOB_LEVEL = 1;
      BUS_JOB_COLOR <- CL_CRUSTA;
local BUS_JOB_GET_HOUR_START        = 0  ;   // 6;
local BUS_JOB_GET_HOUR_END          = 23 ;   // 9;
local BUS_JOB_LEAVE_HOUR_START      = 0  ;   // 20;
local BUS_JOB_LEAVE_HOUR_END        = 23 ;   // 22;
local BUS_JOB_WORKING_HOUR_START    = 0  ;   // 6;
local BUS_JOB_WORKING_HOUR_END      = 23 ;   // 21;
local BUS_ROUTE_IN_HOUR = 4;
local BUS_ROUTE_NOW = 4;
local BUS_TICKET_PRICE = 0.4;

local routes_list_all = [ 1, 2, 3, 4, 5, 6, 7 ];
local routes_list = clone( routes_list_all );

local BUS_DEPOT_SIDEWALK = [-436.409, 461.904, -411.006, 498.025];

event("onServerStarted", function() {
    logStr("[jobs] loading busdriver job...");

    createPlace("LittleItalyWaypoint",  -215.876, 625.305, -221.062, 650.786);
    //createPlace("WestSideWaypoint",  -536.377, -126.749, -561.389, -142.504);
    createPlace("SandIslandWaypoint",  -1552.11, -238.172, -1537.36, -215.447);

    createVehicle(20, -436.205, 417.33, 0.908799, 45.8896, -0.100647, 0.237746);
    createVehicle(20, -436.652, 427.656, 0.907598, 44.6088, -0.0841779, 0.205202);
    createVehicle(20, -437.04, 438.027, 0.907163, 45.1754, -0.100916, 0.242581);
    createVehicle(20, -410.198, 493.193, -0.21792, 180.0, -3.80509, -0.228946);

    //createVehicle(20, -426.371, 410.698, 0.742629, 90.2978, -3.42313, 0.371656);
    //createVehicle(20, -412.107, 410.674, -0.0407671, 89.4833, -3.28604, 1.37194);

  //busStops[0]   <-  busStop("NAME",                                              public ST                                   private

    busStops[4]   <-  busStop("busstop.Uptown4",                          busv3( -373.499,   468.245, - 1.27469 ),   busv3(  -376.67,   471.245,   -0.944843 ), 0);

    busStops[5]   <-  busStop("busstop.WestSide",                         busv3( -474.538,   7.72202,  -1.33022 ),   busv3( -471.471,   10.2396,     -1.4627 ), 180);
    busStops[6]   <-  busStop("busstop.Midtown",                          busv3( -428.483,  -303.189,  -11.7407 ),   busv3( -431.421,  -299.824,    -11.8258 ), 90);
    busStops[7]   <-  busStop("busstop.SouthPort",                        busv3( -137.196,  -475.182,  -15.2725 ),   busv3( -140.946,   -472.49,    -15.4755 ), 90);
    busStops[8]   <-  busStop("busstop.OysterBay",                        busv3(  299.087,  -311.669,  -20.162  ),   busv3(  296.348,  -315.252,    -20.3024 ), 0);
    busStops[9]   <-  busStop("busstop.Chinatown",                        busv3(  277.134,   359.335,  -21.535  ),   busv3(  274.361,   355.601,    -21.6772 ), 0);
    busStops[10]  <-  busStop("busstop.LittleItalyEast",                  busv3(   477.92,   733.942,  -21.2513 ),   busv3(  475.215,   736.735,    -21.3909 ), 90);
    busStops[11]  <-  busStop("busstop.MilvilleNorthWest",                busv3(  691.839,   873.923,  -11.9926 ),   busv3(   688.59,   873.993,    -12.2225 ), 0);
    busStops[12]  <-  busStop("busstop.MilvilleNorthEast",                busv3(  697.743,   873.697,  -11.9925 ),   busv3(  701.126,   873.666,    -11.8061 ), 180);
    busStops[13]  <-  busStop("busstop.LittleItalyEastWest",              busv3(  162.136,   835.064,  -19.6378 ),   busv3(  164.963,   832.472,    -19.7743 ), -90);
    busStops[14]  <-  busStop("busstop.LittleItalyDiamondMotors",         busv3( -173.266,   724.155,  -20.4991 ),   busv3( -170.596,   727.372,    -20.6562 ), 180);
    busStops[15]  <-  busStop("busstop.EastSide",                         busv3( -104.387,   377.106,  -13.9932 ),   busv3( -101.08,    374.001,    -14.1311 ), -90);
    busStops[16]  <-  busStop("busstop.Dipton",                           busv3( -582.427,   1604.64,  -16.4354 ),   busv3( -579.006,   1601.32,    -16.1774 ), -90); // Dipton1
    busStops[17]  <-  busStop("busstop.Dipton",                           busv3( -568.004,   1580.03,  -16.7092 ),   busv3( -571.569,   1582.89,    -16.1666 ), 90); // Dipton2
    busStops[18]  <-  busStop("busstop.Kingston",                         busv3( -1151.38,   1486.28,  -3.42484 ),   busv3( -1147.42,   1483.27,    -3.03844 ), -90); // Kingston1
    busStops[19]  <-  busStop("busstop.Kingston",                         busv3( -1063.9,    1457.63,  -3.97645 ),   busv3( -1067.98,    1460.7,    -3.57558 ), 90); // Kingston2
    busStops[20]  <-  busStop("busstop.Greenfield",                       busv3( -1669.57,   1089.86,  -6.95323 ),   busv3( -1667.56,   1094.36,    -6.71022 ), 163); // Greenfield1
    busStops[21]  <-  busStop("busstop.Greenfield",                       busv3( -1612.92,    996.92,  -5.90228 ),   busv3( -1615.41,   992.857,    -5.58949 ), -10); // Greenfield2
    busStops[22]  <-  busStop("busstop.SandIsland",                       busv3( -1601.16,   -190.15,  -20.3354 ),   busv3( -1597.43,  -193.281,    -19.9776 ), -90);
    busStops[23]  <-  busStop("busstop.SandIslandNorth",                  busv3( -1559.15,   109.576,  -13.2876 ),   busv3(  -1562.2,    105.64,    -13.0085 ), 0);
    busStops[24]  <-  busStop("busstop.HuntersPoint",                     busv3( -1344.5,    421.815,  -23.7303 ),   busv3( -1347.92,    418.11,    -23.4532 ), 0);
    busStops[25]  <-  busStop("busstop.LittleItalySouthNorth",            busv3( 131.681,    789.366,  -19.3316 ),   busv3(  128.864,   787.641,    -19.0034 ), 0);

    busStops[26]   <-  busStop("busstop.UptownHotel",                   busv3(-751.538,  674.475,   -17.5355),    busv3(   -748.5,   677.217,  -17.2655 ), 180);
    busStops[27]   <-  busStop("busstop.SouthsportWest",                busv3(-720.819, -494.274,   -22.7685),    busv3( -719.484,  -490.295,  -22.5009 ), 152);
    busStops[28]   <-  busStop("busstop.Port",                          busv3(  -392.1, -562.882,   -19.6869),    busv3( -395.138,  -565.624,  -19.4169 ), 0);
    busStops[29]   <-  busStop("busstop.SouthPortNorth",                busv3(-250.571, -388.602,   -17.7316),    busv3( -253.313,  -385.564,  -17.4616 ), 90);
    busStops[30]   <-  busStop("busstop.Meria",                         busv3(-45.1856, -135.133,   -14.4352),    busv3( -48.2236,  -137.875,  -14.1652 ), 0);
    busStops[31]   <-  busStop("busstop.Twister",                       busv3(-95.4395, -221.978,   -13.6903),    busv3( -98.1815,   -218.94,  -13.4203 ), 90);
    busStops[32]   <-  busStop("busstop.EastSideAlley",                 busv3( 57.7815,  336.702,   -14.2565),    busv3(  54.7435,    333.96,  -13.9865 ), 0);
    busStops[33]   <-  busStop("busstop.EastSideNearAlley",             busv3(  23.411,   209.09,   -15.8912),    busv3(   20.669,   212.128,  -15.6212 ), 90);
    busStops[34]   <-  busStop("busstop.Chinatown2",                    busv3( 439.583,  311.419,   -20.1715),    busv3(  442.621,   314.161,  -19.9015 ), 180);
    busStops[35]   <-  busStop("busstop.OysterBayNorth",                busv3( 420.587,  12.7031,   -24.9261),    busv3(  417.845,   15.7411,  -24.6561 ), 90);
    busStops[36]   <-  busStop("busstop.OysterBayTrago",                busv3( 557.632,   -306.9,   -20.1562),    busv3(   560.67,  -304.158,  -19.8862 ), 180);
    busStops[37]   <-  busStop("busstop.OysterBayDiner",                busv3( 172.783, -459.168,   -20.1567),    busv3(  175.525,  -462.206,  -19.8867 ), -90);
    busStops[38]   <-  busStop("busstop.MidtownVangel",                 busv3(-282.204, -101.303,    -11.185),    busv3( -279.462,  -104.341,   -10.915 ), -90);
    busStops[39]   <-  busStop("busstop.MidtownHotel",                  busv3(-374.996,  -179.04,   -10.2722),    busv3( -371.958,  -176.298,  -10.0022 ), 180);
    busStops[40]   <-  busStop("busstop.Arcade",                        busv3(-581.778, -60.4754,    1.04647),    busv3( -579.036,  -63.5134,   1.31647 ), -90);
    busStops[41]   <-  busStop("busstop.MonaLisa",                      busv3(-663.505,  317.714,   0.482136),    busv3( -666.543,   314.972,  0.752136 ), 0);
    busStops[42]   <-  busStop("busstop.LincolnPark",                   busv3(-221.314,  127.139,   -10.7052),    busv3( -218.276,   129.881,  -10.4352 ), 180);
    busStops[43]   <-  busStop("busstop.LittleItalyAlley",              busv3(-125.626,  649.013,   -20.0742),    busv3( -122.884,   645.975,  -19.8042 ), -90);
    busStops[44]   <-  busStop("busstop.LittleItalyAlleyToEast",        busv3(-70.4062,  627.135,   -20.1466),    busv3( -73.1481,   630.173,  -19.8766 ), 90);
    busStops[45]   <-  busStop("busstop.Hospital",                      busv3(-376.318,  811.123,   -20.1355),    busv3( -373.576,   808.085,  -19.8655 ), -90);
    busStops[46]   <-  busStop("busstop.UptownDown",                    busv3(-639.583,  850.731,   -18.9095),    busv3( -636.545,   853.473,  -18.6395 ), 180);
    busStops[47]   <-  busStop("busstop.KingstonSubway",                busv3(-1152.56,  1371.54,    -13.565),    busv3(  -1155.3,   1374.58,   -13.295 ), 90);
    busStops[48]   <-  busStop("busstop.KingstonNorth",                 busv3(-1288.97,  1695.94,    11.0666),    busv3( -1286.23,    1692.9,   11.0666 ), -90);
    busStops[49]   <-  busStop("busstop.SouthportSubway",               busv3(-113.694, -521.534,    -16.708),    busv3( -110.656,  -518.792,   -16.438 ), 180);

    busStops[51]   <-  busStop("busstop.Uptown1a",                      busv3( -400.996,   490.790,  -1.01301),   busv3( -404.360,   488.435,   -0.568764), 0);
    busStops[52]   <-  busStop("busstop.Uptown1b",                      busv3( -400.996,   466.620,  -1.01301),   busv3( -397.527,     469.4,   -0.919742), 180);
    busStops[53]   <-  busStop("busstop.Uptown2a",                      busv3( -400.996,   444.260,  -1.05144),   busv3( -404.360,   441.001,   -0.566925), 0);
    busStops[54]   <-  busStop("busstop.Uptown2b",                      busv3( -400.996,   424.805,  -1.05144),   busv3( -397.477,   427.987,   -0.924575), 180);
    busStops[55]   <-  busStop("busstop.Uptown3a",                      busv3( -419.423,   444.260, 0.0254459),   busv3( -423.116,   441.001,    0.132165), 0);
    busStops[56]   <-  busStop("busstop.Uptown3b",                      busv3( -419.423,   424.805, 0.0254459),   busv3( -416.102,   428.005,    0.131614), 180);

    busStops[57]   <-  busStop("busstop.Titania",                       busv3( -541.287,  -195.892,  -4.47402),   busv3( -537.546,  -193.893,    -4.12014), 176);
    busStops[58]   <-  busStop("busstop.FirstChurchOfChrist",           busv3( -555.034,   241.919,  0.114311),   busv3( -551.781,   243.949,    0.347858), 180);
    busStops[59]   <-  busStop("busstop.Arcade",                        busv3( -607.171,  -77.7955,   1.03814),   busv3( -608.978,  -74.7061,     1.31292), 90);

// FirstChurchofChrist, Scientist http://www.nycago.org/Organs/NYC/html/FirstCS.html

    busStops[97]  <-  busStop("busstop.SandIsland",                     busv3( 0.0, 0.0, 0.0 ),                    busv3(  -1541.81, -231.531, -20.3354   ), null); // waypoint
    busStops[98]  <-  busStop("busstop.LittleItalySouthNorth",          busv3( 0.0, 0.0, 0.0 ),                    busv3(  -70.9254, 638.342, -20.237     ), null); // waypoint
    busStops[99]  <-  busStop("busstop.Midtown",                        busv3( 0.0, 0.0, 0.0 ),                    busv3(  -530.473, -292.407, -10.0177   ), null); // waypoint


   //routes[0] <- [zarplata, [stop1, stop2, stop3, ..., stop562]];
   //routes[1] <- [9, [1, 5, 99, 6, 97, 22, 23, 24, 26]]; //sand island
   //routes[2] <- [8, [2, 21, 19, 17, 14, 15, 2]]; //greenfield
   //routes[3] <- [12, [3, 5, 99, 6, 7, 8, 9, 10, 11, 13, 14, 15, 3]]; //center
   //routes[4] <- [15, [4, 98, 25, 16, 18, 20, 22, 23, 24, 21, 19, 17, 14, 15, 4]];
   //routes[5] <- [23, [4, 5, 99, 6, 7, 8, 9, 10, 12, 13, 16, 18, 20, 22, 23, 24, 21, 19, 17, 14, 15, 4]];

    routes[1] <- [12, [51, 5, 57, 7, 28, 97, 22, 23, 24, 52]];                                               // sand island
    routes[2] <- [10, [55, 21, 19, 17, 14, 15, 55]];                                                         // uptown-kingston
    routes[3] <- [13, [53, 58, 59, 6, 7, 8, 9, 10, 11, 13, 45, 54]];                                         // center + hospital
    routes[4] <- [16, [51, 44, 25, 16, 18, 48, 20, 22, 23, 24, 21, 47, 46, 52]];                             // kingston
    routes[5] <- [20, [4, 26, 27, 28, 7, 8, 9, 10, 12, 13, 16, 18, 20, 22, 23, 24, 21, 19, 17, 14, 15, 4]];  // big empire bay
    routes[6] <- [16, [56, 33, 9, 34, 35, 36, 37, 49, 28, 29, 30, 38, 40, 41, 56]];                          // new center
    routes[7] <- [9, [54, 42, 39, 31, 32, 43, 54]];                                                         // small

    registerPersonalJobBlip("busdriver", BUS_JOB_X, BUS_JOB_Y);

    createPlace("BusDepotSidewalk", BUS_DEPOT_SIDEWALK[0], BUS_DEPOT_SIDEWALK[1], BUS_DEPOT_SIDEWALK[2], BUS_DEPOT_SIDEWALK[3]);

});

event("onPlayerPlaceEnter", function(playerid, name) {
    if (isPlayerInVehicle(playerid) && name == "BusDepotSidewalk") {
        local vehicleid = getPlayerVehicle(playerid);
        local vehSpeed = getVehicleSpeed(vehicleid);
        local vehPos = getVehiclePosition(vehicleid);

        local vehSpeedNew = [];

        if (vehPos[0] > BUS_DEPOT_SIDEWALK[0] && vehPos[0] < BUS_DEPOT_SIDEWALK[2]) {
            // для нижней границы
            if (vehPos[1] > (BUS_DEPOT_SIDEWALK[1] - 4.0) && vehPos[1] < (BUS_DEPOT_SIDEWALK[1] + 4.0)) {
                if (vehSpeed[1] >= 0) vehSpeed[1] = (vehSpeed[1] + 2) * -1;
            }
            // для верхней границы
            if (vehPos[1] > (BUS_DEPOT_SIDEWALK[3] - 4.0) && vehPos[1] < (BUS_DEPOT_SIDEWALK[3] + 4.0)) {
                if (vehSpeed[1] <= 0) vehSpeed[1] = (vehSpeed[1] - 2) * -1;
            }
        }

        // для правой боковой границы
        if (vehPos[0] > (BUS_DEPOT_SIDEWALK[2] - 4.0) && vehPos[0] < (BUS_DEPOT_SIDEWALK[2] + 4.0)) {
            if (vehPos[1] > (BUS_DEPOT_SIDEWALK[1] - 2.0) && vehPos[1] < (BUS_DEPOT_SIDEWALK[3] + 2.0)) {
                if (vehSpeed[0] <= 0) vehSpeed[0] = (vehSpeed[0] - 2) * -1;
            }
        }

        setVehicleSpeed(vehicleid, vehSpeed[0], vehSpeed[1], vehSpeed[2]);
    }
});

event("onPlayerConnect", function(playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);
    if ( ! (charId in job_bus) ) {
        job_bus[charId] <- {};
        job_bus[charId]["route"] <- false;
        job_bus[charId]["bus3dtext"] <- [ null, null ];
        job_bus[charId]["busload3dtext"] <- null;
        job_bus[charId]["busBlip"] <- null;
        job_bus[charId]["idBusStop"] <- null;
    }
});


event("onServerPlayerStarted", function( playerid ){

    //creating public 3dtext
    foreach (idx, value in busStops) {
        if (idx < 80) {
            createPrivate3DText ( playerid, value.public.x, value.public.y, value.public.z+0.35, plocalize(playerid, "3dtext.busstop.title"), CL_ROYALBLUE );
            createPrivate3DText ( playerid, value.public.x, value.public.y, value.public.z-0.15, plocalize(playerid, "3dtext."+value.name), CL_WHITE.applyAlpha(150) );
            createPrivate3DText ( playerid, value.public.x, value.public.y, value.public.z+0.10, [[ "3dtext.job.press.E", "PRICE", ], "%s | %s: $"+BUS_TICKET_PRICE ], CL_WHITE.applyAlpha(125), 1.0 );
        }
    }

    //creating 3dtext for bus depot
    createPrivate3DText ( playerid, BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.35, plocalize(playerid, "3dtext.job.busdriver"), CL_ROYALBLUE );
    createPrivate3DText ( playerid, BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.20, plocalize(playerid, "3dtext.job.press.action"), CL_WHITE.applyAlpha(150), RADIUS_BUS );

    if(isBusDriver(playerid)) {

        createText (playerid, "leavejob3dtext", BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.05, plocalize(playerid, "3dtext.job.press.leave"), CL_WHITE.applyAlpha(100), RADIUS_BUS_SMALL );

        if (getPlayerJobState(playerid) == "working" || getPlayerJobState(playerid) == "wait") {
            if(job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2].len() == 0) {
                setPlayerJobState(playerid, "complete");
                msg( playerid, "job.bus.takeyourmoney", BUS_JOB_COLOR );
                return;
            }
            local busID = job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2][0];
            if (busID < 90 ) job_bus[getCharacterIdFromPlayerId(playerid)]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
            setPlayerJobState(playerid, "working");
            trigger(playerid, "setGPS", busStops[busID].private.x, busStops[busID].private.y);
            trigger(playerid, "hudDestroyTimer");
            msg( playerid, "job.bus.continuebusstop", BUS_JOB_COLOR );
            msg( playerid, "job.bus.nextbusstop", plocalize(playerid, "job."+busStops[busID].name), BUS_JOB_COLOR );
            return;
        }

        if (getPlayerJobState(playerid) == "complete") {
            return msg( playerid, "job.bus.takeyourmoney", BUS_JOB_COLOR );
        }

        msg( playerid, "job.bus.ifyouwantstart", BUS_JOB_COLOR );
        restorePlayerModel(playerid);
        setPlayerJobState(playerid, null);
    }
});

event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    if (!isPlayerVehicleBus(playerid)) {
        return;
    }

    if(isBusDriver(playerid) && getPlayerJobState(playerid) == "working") {
        unblockDriving(vehicleid);
    } else {
        blockDriving(playerid, vehicleid);
    }
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (!isPlayerVehicleBus(playerid)) {
        return;
    }

    blockDriving(playerid, vehicleid);
});

event("onServerHourChange", function() {
    BUS_ROUTE_NOW = BUS_ROUTE_IN_HOUR + random(-2, 1);
});

function busStop(a, b, c, d) {
    return {name = a, public = b, private = c, rotation = d };
}

function busv3(a, b, c) {
    return {x = a.tofloat(), y = b.tofloat(), z = c.tofloat() };
}


/**
 * Create private 3DTEXT for current bus stop
 * @param  {int}  playerid
 * @return {array} [idtext1, id3dtext2]
 */
function createPrivateBusStop3DText(playerid, busstop) {
    return [
        createPrivate3DText (playerid, busstop.x, busstop.y, busstop.z+0.35, plocalize(playerid, "STOPHERE"), CL_RIPELEMON, BUS_JOB_DISTANCE ),
        createPrivate3DText (playerid, busstop.x, busstop.y, busstop.z-0.15, plocalize(playerid, "3dtext.job.press.E"), CL_WHITE.applyAlpha(150), RADIUS_BUS_STOP )
    ];
}

/**
 * Remove private 3DTEXT AND BLIP for current bus stop
 * @param  {int}  playerid
 */
function busJobRemovePrivateBlipText ( playerid ) {
    if(job_bus[getCharacterIdFromPlayerId(playerid)]["bus3dtext"][0] != null) {
        remove3DText ( job_bus[getCharacterIdFromPlayerId(playerid)]["bus3dtext"][0] );
        remove3DText ( job_bus[getCharacterIdFromPlayerId(playerid)]["bus3dtext"][1] );
    }
    if (job_bus[getCharacterIdFromPlayerId(playerid)]["busBlip"] != null) {
        removeBlip ( job_bus[getCharacterIdFromPlayerId(playerid)]["busBlip"] );
    }
}

/**
 * Check is player is a busdriver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isBusDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "busdriver"));
}

/**
 * Check is player's vehicle is a bus
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleBus(playerid) {
    return (isPlayerInValidVehicle(playerid, 20));
}

/**
 * Check is route selected
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isBusRouteSelected(playerid) {
    return (job_bus[getCharacterIdFromPlayerId(playerid)]["route"] != false) ? true : false;
}

/**
 * Check is BusReady
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isBusReady(playerid) {
    return job_bus[getCharacterIdFromPlayerId(playerid)]["busready"];
}


/**
Event: JOB - Bus driver - Already have job
*/
key("e", function(playerid) {

    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return;
    }

    if (getPlayerJob(playerid) && getPlayerJob(playerid) != BUS_JOB_NAME) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), BUS_JOB_COLOR );
    }
})



function busJobGet( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return;
    }

    // если у игрока недостаточный уровень
    if(!isPlayerLevelValid ( playerid, BUS_JOB_LEVEL )) {
        return msg(playerid, "job.bus.needlevel", BUS_JOB_LEVEL, BUS_JOB_COLOR );
    }

    if(!isPlayerHaveValidPassport(playerid)) {
               msg(playerid, "job.needpassport", BUS_JOB_COLOR );
        return msg(playerid, "passport.toofar", CL_LYNCH );
    }

    if (getCharacterIdFromPlayerId(playerid) in job_bus_blocked) {
        if (getTimestamp() - job_bus_blocked[getCharacterIdFromPlayerId(playerid)] < BUS_JOB_TIMEOUT) {
            return msg( playerid, "job.bus.badworker", BUS_JOB_COLOR);
        }
    }
    msg( playerid, "job.bus.driver.now", BUS_JOB_COLOR );
    msg( playerid, "job.bus.driver.togetroute", CL_LYNCH );
    setPlayerJob( playerid, "busdriver");
    setPlayerJobState( playerid, null);

    //busJobStartRoute( playerid );
    createText (playerid, "leavejob3dtext", BUS_JOB_X, BUS_JOB_Y, BUS_JOB_Z+0.05, plocalize(playerid, "3dtext.job.press.leave"), CL_WHITE.applyAlpha(100), RADIUS_BUS_SMALL );
}
addJobEvent("e", null,    null, busJobGet);
addJobEvent("e", null, "nojob", busJobGet);


/**
Event: JOB - Bus driver - Need complete
*/
function busJobNeedComplete( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return;
    }

    msg( playerid, "job.bus.route.needcomplete", BUS_JOB_COLOR );
}
addJobEvent("e", BUS_JOB_NAME,  "working", busJobNeedComplete);


/**
Event: JOB - Bus driver - Completed
*/
function busJobCompleted( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return;
    }

    setPlayerJobState(playerid, null);
    busGetSalary( playerid );
    job_bus[getCharacterIdFromPlayerId(playerid)]["route"] = false;
    jobRestorePlayerModel(playerid);
    return;
}
addJobEvent("e", BUS_JOB_NAME,  "complete", busJobCompleted);


/**
Event: JOB - Bus driver - Leave job
*/
function busJobLeave( playerid ) {
    if(!isBusDriver(playerid)) {
        return;
    }

    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS_SMALL)) {
        return;
    }

    if(getPlayerJobState(playerid) == null) {
        msg( playerid, "job.bus.goodluck", BUS_JOB_COLOR);
    }

    if(getPlayerJobState(playerid) == "working") {
        return msg( playerid, "job.bus.needCompleteToLeave", BUS_JOB_COLOR );
    }

    if(getPlayerJobState(playerid) == "complete") {
        setPlayerJobState(playerid, null);
        busGetSalary( playerid );
        job_bus[getCharacterIdFromPlayerId(playerid)]["route"] = false;
        msg( playerid, "job.bus.goodluck", BUS_JOB_COLOR);
    }

    removeText(playerid, "leavejob3dtext");
    trigger(playerid, "removeGPS");

    setPlayerJob( playerid, null );

    msg( playerid, "job.leave", BUS_JOB_COLOR );

    // remove private blip job
    removePersonalJobBlip ( playerid );

}
addJobEvent("q", BUS_JOB_NAME,       null, busJobLeave);
addJobEvent("q", BUS_JOB_NAME,  "working", busJobLeave);
addJobEvent("q", BUS_JOB_NAME, "complete", busJobLeave);


/**
Event: JOB - Bus driver - Get salary
*/
function busGetSalary( playerid ) {
    local amount = job_bus[getCharacterIdFromPlayerId(playerid)]["route"][1] + getSalaryBonus();
    players[playerid].data.jobs.busdriver.count += 1;
    addPlayerMoney(playerid, amount);
    subWorldMoney(amount);
    msg( playerid, "job.bus.nicejob", amount, BUS_JOB_COLOR );
}


/**
Event: JOB - BUS driver - Start route
*/
function busJobStartRoute( playerid ) {
    if(!isPlayerInValidPoint(playerid, BUS_JOB_X, BUS_JOB_Y, RADIUS_BUS)) {
        return;
    }

    if(!isPlayerHaveValidPassport(playerid)) {
               msg(playerid, "job.needpassport", BUS_JOB_COLOR );
        return msg(playerid, "passport.toofar", CL_LYNCH );
    }

    if(BUS_ROUTE_NOW < 1) {
        return msg( playerid, "job.nojob", BUS_JOB_COLOR );
    }

    setPlayerJobState( playerid, "working");
    jobSetPlayerModel( playerid, BUS_JOB_SKIN );

    local rand = random(0, routes_list.len()-1);
    local route = routes_list[rand];
    routes_list.remove(rand);
    if(routes_list.len() == 0) routes_list = clone( routes_list_all );


    job_bus[getCharacterIdFromPlayerId(playerid)]["route"] <- [route, routes[route][0], clone( routes[route][1] ) ]; //create clone of route

    msg(playerid, "job.bus.route.your", BUS_JOB_COLOR);
    msg(playerid, "#"+route+" - "+plocalize(playerid, "job.bus.route."+route), BUS_JOB_COLOR);

    msg(playerid, "job.bus.attention", CL_GRAY);

    local busID = job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2][0];

    msg( playerid, "job.bus.startroute", plocalize(playerid, "job."+busStops[busID].name), BUS_JOB_COLOR );
    if (busID < 90 ) job_bus[getCharacterIdFromPlayerId(playerid)]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
    trigger(playerid, "setGPS", busStops[busID].private.x, busStops[busID].private.y);
}
addJobEvent("e", BUS_JOB_NAME, null, busJobStartRoute);



// working good, check
// coords bus at bus station in Sand Island    -1597.05, -193.64, -19.9622, -89.79, 0.235025, 3.47667
// coords bus at bus station in Hunters Point    -1562.5, 105.709, -13.0123, 0.966663, -0.00153991, 0.182542
function busJobStop( playerid ) {

    if(!isPlayerInVehicle(playerid) || !isPlayerVehicleBus(playerid) ) {
        return;
    }

    if (!isPlayerVehicleBus(playerid)) {
        return msg(playerid, "job.bus.needbus", BUS_JOB_COLOR );
    }

    local busID = job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2][0];

    if(!isPlayerVehicleInValidPoint(playerid, busStops[busID].private.x, busStops[busID].private.y, RADIUS_BUS_STOP )) {
        return/* msg( playerid, "job.bus.gotobusstop", "job."+busStops[busID].name, BUS_JOB_COLOR )*/;
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.bus.driving", CL_RED );
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(busStops[busID].rotation != null) {
        local vehRot = getVehicleRotation(vehicleid);
        local offset = fabs(fabs(vehRot[0]) - fabs(busStops[busID].rotation));
        if (offset > 3.5) {
            return msg(playerid, "job.bus.needcorrectpark", CL_RED );
        }
    }

    setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);

    busJobRemovePrivateBlipText( playerid );
    trigger(playerid, "removeGPS");
    trigger(playerid, "hudDestroyTimer");

    msg( playerid, "job.bus.waitpasses", BUS_JOB_COLOR );

    local routenumber = job_bus[getCharacterIdFromPlayerId(playerid)]["route"][0];
    local busStopLeft = job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2].len();
    local nextBusID = null;

    sendLocalizedMsgToAll(playerid, "job.bus.driversays", [], SHOUT_RADIUS, CL_CREAMCAN);

    if(busStopLeft > 1) {
        nextBusID = job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2][1];
        //sendLocalizedMsgToAll(playerid, "chat.player.shout", [getCharacterIdFromPlayerId(playerid), message], SHOUT_RADIUS, CL_WHITE);
        sendLocalizedMsgToAll(playerid, "job.bus.nextbusstop2", [ routenumber, plocalize(playerid, "job."+busStops[busID].name)], SHOUT_RADIUS, CL_CREAMCAN);
        if (busStopLeft > 2) {
            sendLocalizedMsgToAll(playerid, "job.bus.nextbusstop", [ plocalize(playerid, "job."+busStops[nextBusID].name)], SHOUT_RADIUS, CL_CREAMCAN);
        } else {
            sendLocalizedMsgToAll(playerid, "job.bus.nextbusstop3", [ plocalize(playerid, "job."+busStops[nextBusID].name)], SHOUT_RADIUS, CL_CREAMCAN);
        }
        job_bus[getCharacterIdFromPlayerId(playerid)]["busload3dtext"] = create3DText (
            busStops[busID].private.x,
            busStops[busID].private.y,
            busStops[busID].public.z+3.0,
            [[ "ROUTE", "NEXT", "3dtext."+busStops[nextBusID].name ], "=== %s #"+routenumber+"   %s: %s ===" ],
            CL_CREAMCAN );


        //[["test1", "test2"], "%s %s -- %s"]
    } else {
        sendLocalizedMsgToAll(playerid, "job.bus.lastbusstop", [ routenumber, plocalize(playerid, "job."+busStops[busID].name)], SHOUT_RADIUS, CL_CREAMCAN);
        job_bus[getCharacterIdFromPlayerId(playerid)]["busload3dtext"] = create3DText (
            busStops[busID].private.x,
            busStops[busID].private.y,
            busStops[busID].public.z+3.0,
            [[ "ROUTE", "END" ], "=== %s #"+routenumber+"   %s ===" ],
            CL_CREAMCAN );
    }

    job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2].remove(0);

    freezePlayer( playerid, true);
    setPlayerJobState(playerid, "wait");
    job_bus[getCharacterIdFromPlayerId(playerid)]["idBusStop"] = busID;
    local vehFuel = getVehicleFuel( vehicleid );
    setVehicleFuel( vehicleid, 0.0 );

    trigger(playerid, "hudCreateTimer", 10.0, true, true);

    playerDelayedFunction(playerid, 10000, function () {
        freezePlayer( playerid, false);
        playerDelayedFunction(playerid, 1000, function () { freezePlayer( playerid, false); });
        playerDelayedFunction(playerid, 3000, function () { freezePlayer( playerid, false); });
        setVehicleFuel( vehicleid, vehFuel );

        remove3DText( job_bus[getCharacterIdFromPlayerId(playerid)]["busload3dtext"] );

        if (job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2].len() == 0) {
            msg( playerid, "job.bus.gototakemoney", BUS_JOB_COLOR );
            blockDriving(playerid, vehicleid);
            setPlayerJobState(playerid, "complete");

            local passengers = getAllBusPassengers(vehicleid);

            foreach (idx, passid in passengers) {
                screenFadeinFadeoutEx(passid, 500, 1000, (function(pid) {
                    return function() {
                        removePlayerFromBus(pid);
                        reloadPlayerModel(pid);
                        setPlayerPosition(pid, busStops[busID].public.x, busStops[busID].public.y, busStops[busID].public.z);
                    }
                })(passid));
            }

            return;
        }

        local busID = job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2][0];

        job_bus[getCharacterIdFromPlayerId(playerid)]["idBusStop"] = null;

        if (busID < 90 ) job_bus[getCharacterIdFromPlayerId(playerid)]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
        //job_bus[getCharacterIdFromPlayerId(playerid)]["busBlip"]   = createPrivateBlip(playerid, busStops[busID].private.x, busStops[busID].private.y, ICON_YELLOW, 2000.0);
        //job_bus[getCharacterIdFromPlayerId(playerid)]["busBlip"]   = playerid+"blip"; //надо вырезать
        setPlayerJobState(playerid, "working");
        trigger(playerid, "setGPS", busStops[busID].private.x, busStops[busID].private.y);
        msg( playerid, "job.bus.gotonextbusstop", plocalize(playerid, "job."+busStops[busID].name), BUS_JOB_COLOR );
        //local gpsPos = busStops[busID].private;
        //trigger(playerid, "setGPS", gpsPos.x, gpsPos.y);
    });

}
addJobEvent("e", BUS_JOB_NAME, "working", busJobStop);



event("onPlayerPlaceEnter", function(playerid, name) {
    if (isBusDriver(playerid) && isPlayerVehicleBus(playerid) && getPlayerJobState(playerid) == "working") {
        if((name == "LittleItalyWaypoint" && job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2][0] == 98) /*|| (name == "WestSideWaypoint" && job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2][0] == 99)*/ || (name == "SandIslandWaypoint" && job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2][0] == 97)) {
            trigger(playerid, "removeGPS");
            job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2].remove(0);
            local busID = job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2][0];
            trigger(playerid, "setGPS", busStops[busID].private.x, busStops[busID].private.y);
            job_bus[getCharacterIdFromPlayerId(playerid)]["bus3dtext"] = createPrivateBusStop3DText(playerid, busStops[busID].private);
        }
    }
});


event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (isBusDriver(playerid) && getVehicleModel(vehicleid) == 20 && getPlayerJobState(playerid) == "complete") {
        delayedFunction(14000, function () {
            tryRespawnVehicleById(vehicleid, true);
        });
    }
});


function getNearestBusStationForPlayer(playerid) {
    local pos = getPlayerPositionObj( playerid );
    local dis = 5;
    local busStopid = null;
    foreach (key, value in busStops) {
        local distance = getDistanceBetweenPoints3D( pos.x, pos.y, pos.z, value.public.x, value.public.y, value.public.z );
        if (distance < dis) {
           dis = distance;
           busStopid = key;
        }
    }
    return busStopid;
}

key("e", function(playerid) {
    if(isPlayerInVehicle(playerid)) return;

    /* exit from bus */
    if(isPlayerBusPassenger(playerid)) {

        local vehicleid = getPlayerBusPassengerVehicle(playerid);
        if(vehicleid == -1) return;

        local driverid = getVehicleDriver(vehicleid);
        if(driverid == null) return removePlayerFromBus(playerid);

        local busid = job_bus[getCharacterIdFromPlayerId(driverid)]["idBusStop"];
        if(busid == null) return msg(playerid, "bus.passenger.leaveonly");

        msg(playerid, "bus.passenger.leavebus", CL_CREAMCAN);
        msg(driverid, "bus.passenger.passleave", CL_CREAMCAN);
        removePlayerFromBus(playerid);
        setPlayerPosition(playerid, busStops[busid].public.x, busStops[busid].public.y, busStops[busid].public.z);
        screenFadeinFadeoutEx(playerid, 500, 1000, function() {
            reloadPlayerModel(playerid);
        });

    } else {
    /* enter in bus */
        local busid = getNearestBusStationForPlayer(playerid);
        if(busid == null) return ;

        local vehicleid = getNearestCarForPlayer(playerid, 10.0);
        local modelid = getVehicleModel(vehicleid);
        local driverid = getVehicleDriver(vehicleid);
        if(vehicleid <= 0 || modelid != 20 || driverid == null) return msg(playerid, "bus.passenger.busnotfound", CL_CREAMCAN);

        if(job_bus[getCharacterIdFromPlayerId(driverid)]["idBusStop"] != busid) return;

        if(job_bus[getCharacterIdFromPlayerId(driverid)]["route"][2].len() < 1) return msg(playerid, "bus.passenger.lastbusstop", BUS_JOB_COLOR);

        if(!canMoneyBeSubstracted(playerid, BUS_TICKET_PRICE)) return msg(playerid, "bus.passenger.notenoughmoney", CL_RED);

        msg(playerid, "bus.passenger.enterbus", CL_CREAMCAN);
        msg(driverid, "bus.passenger.passenter", CL_CREAMCAN);
        msg(playerid, "bus.passenger.attention", CL_GRAY);

        subPlayerMoney(playerid, BUS_TICKET_PRICE);
        addPlayerMoney(driverid, BUS_TICKET_PRICE);
        putPlayerInBus(playerid, vehicleid);

    }

}, KEY_UP);


// don't touch and don't replace. Service command for fast test!
acmd("gotobusstop", function(playerid) {
    local busid = job_bus[getCharacterIdFromPlayerId(playerid)]["route"][2][0];
    local poss = busStops[busid].private;
    setVehiclePosition( getPlayerVehicle(playerid), poss.x, poss.y, poss.z );
    busJobStop( playerid );
});

acmd("buscomplete", function(playerid) {
    setPlayerJobState(playerid, "complete");
});

local count = 27;

acmd("busadd", function(playerid, busstopname) {
    if(!isPlayerInValidVehicle(playerid, 20)) { return msg(playerid, "You need a bus."); }
    local vehicleid = getPlayerVehicle(playerid);
    local vehPos = getVehiclePosition(vehicleid);
    local vehRot = getVehicleRotation(vehicleid);

    local xR = vehRot[0];
    local x = vehPos[0];
    local y = vehPos[1];
    local z = vehPos[2];
    local xPass = 0;
    local yPass = 0;
    local zPass = 0;
    local R = 0;
    // when near 0
    if(xR > -5 && xR < 5) {
        dbg("0");
        R = 0;
        xPass = x + 3.038;
        yPass = y + 2.742;
    }
    // when near 90
    else if(xR > 85 && xR < 95) {
        dbg("90");
        R = 90;
        xPass = x + 2.742;
        yPass = y - 3.038;
    }


    // when near 180
    else if( (xR > 175 && xR < 180) || (xR < -175 && xR > -179.99) ) {
        dbg("180");
        R = 180;
        xPass = x - 3.038;
        yPass = y - 2.742;
    }

    // when near -90
    else if(xR > -95 && xR < -85) {
        dbg("-90");
        R = -90;
        xPass = x - 2.742;
        yPass = y + 3.038;
    }

    zPass = z - 0.27;
    createText (playerid, "test"+count, xPass, yPass, zPass+0.35, "=== BUS STOP ===", CL_ROYALBLUE );
    dbg("busStops["+count+"]   <-  busStop(\"job.busstop."+busstopname+"\", busv3("+ xPass +","+ yPass +","+ zPass +"), busv3( "+ x +","+ y +","+ z +" ), "+R+");");
    msg(playerid, "Bus stop has been created. Copy coords from console.", CL_SUCCESS );
    count += 1;
});


acmd("bus", "setroutesall", function(playerid, ...) {
    if (!vargv.len()) msg(playerid, "Need to write numbers of bus routes separated by space.");

    routes_list_all = [];
    foreach (idx, value in vargv) {
        routes_list_all.push(value.tointeger());
    }
    routes_list = clone (routes_list_all);
    msg(playerid, "New list of bus routes: "+concat(routes_list_all) );
});


acmd("bus", "getroutes", function(playerid) {
    msg(playerid, "List of available bus routes: "+concat(routes_list) );
});

acmd("bus", "getroutesall", function(playerid) {
    msg(playerid, "List of all bus routes: "+concat(routes_list_all) );
});
