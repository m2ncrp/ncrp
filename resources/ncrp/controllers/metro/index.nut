include("controllers/metro/commands.nut");

const RADIUS = 4.0;

metroInfos <- [
    [ -555.864136, 1592.924927, -21.863888, "Dipton" ],
    [ -293.068512, 553.138000, -2.273677, "Uptown" ],
    [ 234.378662, 396.031830, -9.407516, "Chinatown" ],
    [ -98.685043, -481.715393, -8.921828, "Southport" ],
    [ -511.283478, 21.851606, -5.709612, "Westside" ],
    [ -1550.738159, -231.029968, -13.589154, "SandIsland" ],
    [ -1117.546509, 1363.452026, -17.572432, "Kingston" ]
];

const HEAD = 0;
const TAIL = 6; // total number of stations

function isNearStation(playerid){
	local playerPos = getPlayerPosition( playerid );

	foreach (index, station in metroInfos) {
    	local dist = getDistanceBetweenPoints3D( station[0], station[1], station[2], playerPos[0], playerPos[1], playerPos[2] );
    	if (dist < RADIUS) {
    		return true;
    	}
    }
    return false;
}