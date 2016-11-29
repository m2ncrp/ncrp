local ticker = null;

addEventHandler("onServerClientStarted", function() {
    log("onServerClientStarted");

    if (!ticker) {
        ticker = timer(function() {
            triggerServerEvent("onClientSendFPSData", getFPS());
        }, 1000, -1);
    }

    setRenderHealthbar(false);
});

addEventHandler("onServerFadeScreen", function(time, fadein) {
    fadeScreen(time.tofloat(), fadein);
});

addEventHandler("onClientFrameRender", function() {
    // draw chat line
    dxDrawRectangle(25.0, 0.0, 400, 28.0, 0xA1000000);
});

// addEventHandler("onClientProcess", function() {
//     aa = getScreenFromWorld(-415.277, 477.403, -0.215797);
//     ab = getScreenFromWorld(-419.277, 477.403, -0.215797);
//     ba = getScreenFromWorld(-419.277, 481.403, -0.215797);
//     bb = getScreenFromWorld(-415.277, 481.403, -0.215797);

//     return true;
// });

// addEventHandler("onClientFrameRender", function(isGUIdrawn) {
//     if (isGUIdrawn) {
//         dxDrawLine(aa[0], aa[1], ab[0], ab[1], 0xFF0000FF);
//         dxDrawLine(ab[0], ab[1], ba[0], ba[1], 0xFF0000FF);
//         dxDrawLine(ba[0], ba[1], bb[0], bb[1], 0xFF0000FF);
//         dxDrawLine(bb[0], bb[1], aa[0], aa[1], 0xFF0000FF);
//     }
// });

// local logo = null;
// local todraw = false;
// local angle = 0.0;

// addEventHandler("onClientFrameRender", function(post_gui) {
//     if (todraw && post_gui) {
//         dxDrawText( getPlayerName(getLocalPlayer()), 640.0, 480.0, getPlayerColour(getLocalPlayer()), true, "tahoma-bold" );
//         dxDrawTexture(logo, 640.0, 480.0, 1.0, 0.8, 0.5, 0.5, 0.0, 250);
//         angle += 0.25;
//         if (angle > 360.0) {
//             angle = 0.0;
//         }
//     }

//     if (todraw && post_gui) {
//         local aa = getScreenFromWorld(-566.499, 1530.58, -15.8716);
//         local ab = getScreenFromWorld(-566.499, 1532.58, -15.8716);
//         local ba = getScreenFromWorld(-568.499, 1532.58, -15.8716);
//         local bb = getScreenFromWorld(-568.499, 1530.58, -15.8716);

//         dxDrawLine(aa[0], aa[1], ab[0], ab[1], fromRGB(255, 0, 0));
//         dxDrawLine(ab[0], ab[1], ba[0], ba[1], fromRGB(255, 0, 0));
//         dxDrawLine(ba[0], ba[1], bb[0], bb[1], fromRGB(255, 0, 0));
//         dxDrawLine(bb[0], bb[1], aa[0], aa[1], fromRGB(255, 0, 0));
//     }
// });

// bindKey("b", "down", function() {
//     sendMessage("loading texture");
//     log("loading texture");
//     logo = dxLoadTexture("logo.png");
//     log("texture" + logo);
// });

// bindKey("n", "down", function() {
//     sendMessage("drawing texture");
//     todraw = true;
// });

// bindKey("n", "up", function() {
//     sendMessage("stopping to draw texture");
//     todraw = false;
// });

