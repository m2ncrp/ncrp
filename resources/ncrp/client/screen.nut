addEventHandler("onServerFadeScreen", function(time, fadein) {
    fadeScreen(time.tofloat(), fadein);
});

local logo = null;
local todraw = false;
local angle = 0.0;

addEventHandler("onClientFrameRender", function(post_gui) {
    if (todraw && post_gui) {
        dxDrawText( getPlayerName(getLocalPlayer()), 640.0, 480.0, getPlayerColour(getLocalPlayer()), true, "tahoma-bold" );
        dxDrawTexture(logo, 640.0, 480.0, 1.0, 0.8, 0.5, 0.5, 0.0, 250);
        angle += 0.25;
        if (angle > 360.0) {
            angle = 0.0;
        }
    }

    if (todraw && post_gui) {
        local aa = getScreenFromWorld(-566.499, 1530.58, -15.8716);
        local ab = getScreenFromWorld(-566.499, 1532.58, -15.8716);
        local ba = getScreenFromWorld(-568.499, 1532.58, -15.8716);
        local bb = getScreenFromWorld(-568.499, 1530.58, -15.8716);

        dxDrawLine(aa[0], aa[1], ab[0], ab[1], fromRGB(255, 0, 0));
        dxDrawLine(ab[0], ab[1], ba[0], ba[1], fromRGB(255, 0, 0));
        dxDrawLine(ba[0], ba[1], bb[0], bb[1], fromRGB(255, 0, 0));
        dxDrawLine(bb[0], bb[1], aa[0], aa[1], fromRGB(255, 0, 0));
    }
});

bindKey("b", "down", function() {
    sendMessage("loading texture");
    log("loading texture");
    logo = dxLoadTexture("logo.png");
    log("texture" + logo);
});

bindKey("n", "down", function() {
    sendMessage("drawing texture");
    todraw = true;
});

bindKey("n", "up", function() {
    sendMessage("stopping to draw texture");
    todraw = false;
});
