# Libraries
include("libraries/JSONEncoder.class.nut", INCLUDE_GLOBAL);
include("libraries/JSONParser.class.nut", INCLUDE_GLOBAL);
include("libraries/debug.nut", INCLUDE_GLOBAL);
include("helpers/array.nut", INCLUDE_GLOBAL);
include("helpers/function.nut", INCLUDE_GLOBAL);
include("helpers/math.nut", INCLUDE_GLOBAL);
include("helpers/string.nut", INCLUDE_GLOBAL);
include("helpers/table.nut", INCLUDE_GLOBAL);


# aliases and special stuff
event <- addEventHandler;

screen  <- getScreenSize();
screenX <- screen[0].tofloat();
screenY <- screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];
centerX <- screenX * 0.5;
centerY <- screenY * 0.5;

ELEMENT_TYPE_BUTTON <- 2;
ELEMENT_TYPE_IMAGE <- 13;


# Controllers
include("controllers/3dtext/client.nut");
include("controllers/blip/client.nut");
include("controllers/weather/client.nut");
include("controllers/screen/client.nut");
include("controllers/place/client.nut");
include("controllers/keyboard/client.nut");
include("controllers/admin/client/sqdebug.nut");
include("controllers/player/client/tabpanel.nut");
include("controllers/player/client/nametags.nut");

// include("controllers/inventory/client/base.nut");
// include("controllers/inventory/client/main.nut");


# Modules
include("modules/rentcar/client.nut");
// include("modules/jobs/busdriver/client.nut");
