local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];
centerX <- screenX * 0.5;
centerY <- screenY * 0.5;

addEventHandler("onClientFrameRender", function(isGUIDrawn) {
    if(isGUIDrawn) return;
		if(!isInputVisible()) return;
    // dxDrawRectangle(centerX - 288.0, screenY - 32.0, 200.0, 50.0, fromRGB(50, 50, 50, 255));
});