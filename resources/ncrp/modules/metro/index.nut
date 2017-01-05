include("modules/metro/commands.nut");
include("modules/metro/functions.nut");

translation("en", {
    "metro.toofaraway"                  : "[SUBWAY] You are too far from any station!"
    "metro.notenoughmoney"              : "[SUBWAY] Not enough money!"
    "metro.pay"                         : "[SUBWAY] You pay $%.2f for ticket."
    "metro.arrived"                     : "[SUBWAY] You arrived to %s station."
    "metro.herealready"                 : "[SUBWAY] You're here already."
    "metro.notexist"                    : "[SUBWAY] Selected station doesn't exist."
    "metro.nocar"                       : "[SUBWAY] Subway isn't ferry boat. Leave the car."

    "metro.listStations.title"          : "List of available stations:"
    "metro.listStations.station"        : "Station #%d - %s"
    "metro.listStations.station.closed" : "Station #%d - %s (closed)"

    "metro.station.closed.maintaince"   : "Station %s is closed for maintaince. Please move to another station or use other public transport."

    "metro.help.title"                  : "List of available commands for SUBWAY:"
    "metro.help.subway"                 : "Move to station by id"
    "metro.help.subwayList"             : "Show list of all stations"
    "metro.help.sub"                    : "Analog /subway id"
    "metro.help.metro"                  : "Analog /subway id"

    "metro.station.nearest.showblip"    : "[SUBWAY] Nearest station (%s) is marked by yellow icon on map."
});

const METRO_RADIUS = 3.8;
const METRO_TICKET_COST = 0.25;

const METRO_KEY_AVALIABLE = "open";
const METRO_KEY_UNAVALIABLE = "closed";

// x, y, z, "station caption", main 3d text radius, additional 3d text x_pos, additional 3d text y_pos, additional 3d text z_pos, key_status
metroInfos <- [
    [ -555.353,     1605.74,    -20.6639,   "Dipton",       4, "down", -532.406,   1605.85,    -16.6,       METRO_KEY_AVALIABLE ],
    [ -293.068512,  553.138000, -2.273677,  "Uptown",      40, "up",   null,       null,       null,        METRO_KEY_AVALIABLE ],
    [  234.378662,  396.031830, -9.407516,  "Chinatown",   15, "up",   259.013,    395.816,    -21.6287,    METRO_KEY_AVALIABLE ],
    [ -98.685043,   -481.715393,-8.921828,  "Southport",   15, "up",   -98.6563,   -498.904,   -15.7404,    METRO_KEY_AVALIABLE ],
    [ -498.224,     21.5297,    -4.50967,   "West Side",    4, "down", -498.266,   -2.04015,   -0.539263,   METRO_KEY_AVALIABLE ],
    [ -1550.738159, -231.029968,-13.589154, "Sand Island", 15, "up",   -1550.59,   -213.811,   -20.3354,    METRO_KEY_AVALIABLE ],
    [ -1117.73,     1363.49,    -17.5724,   "Kingston",     4, "down", -1141.32,   1363.65,    -13.5724,    METRO_KEY_AVALIABLE ]
];

const METRO_HEAD = 0;
const METRO_TAIL = 6; // total number of stations-1

event("onServerStarted", function() {
    log("[metro] loading metro stations...");
    //creating public 3dtext
    foreach (station in metroInfos) {

        create3DText ( station[0], station[1], station[2]+0.35, "=== " + station[3].toupper() + " SUBWAY STATION ===", CL_EUCALYPTUS, station[4] );
        create3DText ( station[0], station[1], station[2]+0.20, "/subway", CL_WHITE.applyAlpha(150), METRO_RADIUS );

        if(station[6]) {
            create3DText ( station[6], station[7], station[8]+0.35, "Go "+station[5]+" to enter the subway", CL_EUCALYPTUS, 30 );
        }
    }
});


