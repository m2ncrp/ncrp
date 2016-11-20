local aa;
local ab;
local ba;
local bb;

addEventHandler("onServerClientStarted", function() {
    setRenderHealthbars(false);
});

addEventHandler("onServerFadeScreen", function(time, fadein) {
    fadeScreen(time.tofloat(), fadein);
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
