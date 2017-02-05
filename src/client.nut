# Libraries
include("libraries/JSONEncoder.class.nut", INCLUDE_GLOBAL);
include("libraries/JSONParser.class.nut", INCLUDE_GLOBAL);
include("libraries/debug.nut", INCLUDE_GLOBAL);
include("helpers/array.nut", INCLUDE_GLOBAL);
include("helpers/function.nut", INCLUDE_GLOBAL);
include("helpers/math.nut", INCLUDE_GLOBAL);
include("helpers/string.nut", INCLUDE_GLOBAL);
include("helpers/table.nut", INCLUDE_GLOBAL);

# aliases
event <- addEventHandler;

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
include("controllers/auth/client.nut");
include("controllers/inventory/client/base.nut");

# Modules
include("modules/rentcar/client.nut");
// include("modules/jobs/busdriver/client.nut");
