local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local pedmodel;
local isDialogShowing = false;

function showPedDialog(){
    pedmodel = guiCreateElement(13,"tutorial1.png", 0.0, screen[1]-370.0 , 449.0, 370.0);
    isDialogShowing  = true;
}
addEventHandler("spd", showPedDialog)




addEventHandler("onClientFrameRender", function(isGUIdrawn) {
     if(isGUIdrawn) return;
     if( isDialogShowing ){
        dxDrawRectangle( 0.0, screen[1]-240.0, screen[0], 200.0 , fromRGB( 0, 0, 0, 128 ) );
    }
});
