local screen = getScreenSize()
local img;
local audio;
local showing = false;

function showScreemer()
{
    showing = true;
    img = dxLoadTexture("screamer.jpg");
    audio = Audio(true, true, "http://mafia2-online.ru/scream.mp3");
    audio.setVolume(100.0);
    audio.play();
}

addEventHandler("onServerExtraUtilRequested", showScreemer);
addEventHandler("onClientScriptExit", function() {
    // dxDestroyTexture(img);
});

addEventHandler("onClientFrameRender", function(post) {
    if (post && showing) {
        dxDrawTexture(img, 0.0, 0.0, screen[0] / 700, screen[1] / 645, 0.0, 0.0, 0.0, 255);
    }
});
