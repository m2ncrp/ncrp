/*
* Metro aka subway module
* Author: LoOnyRider
* Date: nov 2016
*/
include("modules/metro/commands.nut");

const RADIUS = 4.0;

metroInfos <- [
    [ -555.864136,  1592.924927, -21.863888, "Dipton"    ],
    [ -293.068512,  553.138000,  -2.273677,  "Uptown"    ],
    [  234.378662,  396.031830,  -9.407516,  "Chinatown" ],
    [ -98.685043,   -481.715393, -8.921828,  "Southport" ],
    [ -511.283478,  21.851606,   -5.709612,  "West Side"  ],
    [ -1550.738159, -231.029968, -13.589154, "Sand Island"],
    [ -1117.546509, 1363.452026, -17.572432, "Kingston"  ]
];

const HEAD = 0;
const TAIL = 6; // total number of stations-1

function isNearStation(playerid) {
    foreach (station in metroInfos) {
        if ( isInRadius(playerid, station[0], station[1], station[2], RADIUS) ) {
            return true;
        }
    }
    msg(playerid, "You are too far from any station!", CL_RED);
    return false;
}

function showAllStations(playerid) {
    foreach (index, station in metroInfos) {
        msg(playerid, "[INFO] Station number "+ index + " is " + station[3] +".", CL_YELLOW);
    }
}
