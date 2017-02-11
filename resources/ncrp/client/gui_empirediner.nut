const ELEMENT_TYPE_BUTTON = 2;
const ELEMENT_TYPE_IMAGE = 13;
// check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local window;
local logo;
local laben = array(4, null)
local items = array(4, null)
local button;

function empireDiner(){
    window   =  guiCreateElement( ELEMENT_TYPE_WINDOW, "Empire Bay Diner", screen[0]/2 - 135.0, screen[1]/2 - 232.5, 270.0, 465.0);
    logo     =  guiCreateElement( ELEMENT_TYPE_IMAGE, "empirediner.png",    10.0, 20.0, 248.0, 151.0, false, window);
    items[0] =  guiCreateElement( ELEMENT_TYPE_IMAGE, "Item.Burger.jpg",    10.0, 175.0, 64.0, 64.0, false, window);
    items[1] =  guiCreateElement( ELEMENT_TYPE_IMAGE, "Item.Hotdog.jpg",    10.0, 245.0, 64.0, 64.0, false, window);
    items[2] =  guiCreateElement( ELEMENT_TYPE_IMAGE, "Item.Sandwich.jpg",  10.0, 319.0, 64.0, 64.0, false, window);
    items[3] =  guiCreateElement( ELEMENT_TYPE_IMAGE, "Item.Cola.jpg",      10.0, 393.0, 64.0, 64.0, false, window);

}
addEventHandler("diner", empireDiner);
