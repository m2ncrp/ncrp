

// всё херня, подлюкчать не надо


//const ELEMENT_TYPE_BUTTON = 2;
//// check for 2x widht bug
//local screen = getScreenSize();
//local screenX = screen[0].tofloat();
//local screenY = screen[1].tofloat();
//
//if ((screenX / screenY) > 2.0) {
//    screenX = 0.5 * screenX;
//}
//
//screen = [screenX, screenY];
//
//local window;
//local input = [];
//local button = [];
//local label = [];
//local radio = [];
//
//local isPaintCarMenu = false;
//
//
//addEventHandler("onClientFrameRender", function(isGUIDrawn) {
//    if (!drawing) return;
//    if (isGUIDrawn) return;
//
//    if (!isPaintCarMenu) return;
//
//    local text   = "Hold left shift and move mouse to rotate camera.";
//    local offset = dxGetTextDimensions(text, 2.0, "tahoma-bold")[1];
//    dxDrawText(text, 25.0, screenY - offset - 25.0, 0xAAFFFFFF, false, "tahoma-bold", 2.0);
//
//});
//
//
//
//
//bindKey("shift", "down", function() {
//    if(isCharacterCreationMenu || isCharacterSelectionMenu){
//        showCursor(false);
//    }
//});
//
//bindKey("shift", "up", function() {
//   if(isCharacterCreationMenu || isCharacterSelectionMenu){
//        showCursor(true);
//   }
//});
