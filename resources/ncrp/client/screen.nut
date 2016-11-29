local ticker = null;
local drawdata = {
    time    = "00:00",
    date    = "01.01.1950",
    status  = "",
    version = "0.0.000",
    money   = "",
    state   = "",
    level   = ""
};

local datastore = {};
local lines     = [];

function compute(x, y) {
    datastore[x] <- y;
}

function has(x) {
    return (x in datastore);
}

function get(x) {
    return (x in datastore) ? datastore[x] : 0.0;
}


function onSecondChanged() {
    triggerServerEvent("onClientSendFPSData", getFPS());

    drawdata.status = format(
        "v%s  |  FPS: %d  |  Ping: %d  |  Online: %d",
        drawdata.version,
        getFPS(),
        getPlayerPing(getLocalPlayer()),
        (getPlayerCount() + 1)
    );
}

/**
 * Main rendering callback
 */
addEventHandler("onClientFrameRender", function(isGUIdrawn) {
    if (!isGUIdrawn) return;

    local screen = getScreenSize();
    local screenX = screen[0];
    local screenY = screen[1];

    local offset;
    local length;
    local height;

    local ROUND_TO_RIGHT_RATIO = 13.6;

    /**
     * Category: top-left
     */
    // draw top chat line
    dxDrawRectangle(10.0, 0.0, 400.0, 28.0, 0xA1000000);

    // draw status line
    offset = dxGetTextDimensions(drawdata.status, 1.0, "tahoma-bold")[0].tofloat();
    dxDrawText(drawdata.status, 410.0 - offset - 8.0, 6.5, 0xFFA1A1A1, false, "tahoma-bold" );

    // draw chat slots
    // TODO:

    /**
     * Category: top-right
     */
    // draw time
    offset = dxGetTextDimensions(drawdata.time, 3.6, "tahoma-bold")[0].tofloat();
    dxDrawText(drawdata.time, screenX - offset - 15.0, 8.0, 0xFFE4E4E4, false, "tahoma-bold", 3.6 );

    // draw date
    offset = dxGetTextDimensions(drawdata.date, 1.4, "tahoma-bold")[0].tofloat();
    dxDrawText(drawdata.date, screenX - offset - 25.0, 58.0, 0xFFE4E4E4, false, "tahoma-bold", 1.4 );


    /**
     * Category: bottom-right
     */
    // calculating borders
    if (!has("borders.x") || !has("borders.y")) {
        length = (screenY / 5.0); // get height of meter (depends on screen Y)
        height = (screenY / 13.80);

        compute("roundy.height", height);
        compute("roundy.width",  length);
        compute("borders.x",    screenX - length - (screenX / ROUND_TO_RIGHT_RATIO));
        compute("borders.y",    screenY - height);
        compute("borders.cx",   screenX - (length / 2) - (screenX / ROUND_TO_RIGHT_RATIO));

        local radius = length / 2;
        local step   = 0.5;

        for (local x = 0; x < length; x += step) {
            local len = sqrt( pow(radius, 2) - pow(radius - x, 2) );

            lines.push({
                x = get("borders.x") + x,
                y = get("borders.y") - radius + len - 2.5,
                step = step,
                height = radius - len + 2.5
            });
        }
    }

    // draw base
    dxDrawRectangle(get("borders.x"), get("borders.y"), get("roundy.width"), get("roundy.height") + 5.0, 0xA1000000);
    foreach (idx, line in lines) {
        dxDrawRectangle(line.x, line.y, line.step, line.height, 0xA1000000);
    }

    // draw money
    local offset1 = dxGetTextDimensions(drawdata.money, 1.6, "tahoma-bold")[0].tofloat();
    local offset2 = dxGetTextDimensions(drawdata.money, 1.6, "tahoma-bold")[1].tofloat();
    dxDrawText( drawdata.money, get("borders.cx") - ( offset1 / 2 ) + 1.0, get("borders.y") + 3.0 + 1.0, 0xFF000000, false, "tahoma-bold", 1.6 );
    dxDrawText( drawdata.money, get("borders.cx") - ( offset1 / 2 )      , get("borders.y") + 3.0      , 0xFF569267, false, "tahoma-bold", 1.6 );

    // draw state
    dxDrawText( drawdata.state, get("borders.x") + 11.0, get("borders.y") + offset2 + 5.0, 0xFFA1A1A1, false, "tahoma-bold", 1.0);

    // draw level
    dxDrawText( drawdata.level, get("borders.x") + 11.0, get("borders.y") + offset2 + 21.0, 0xFFA1A1A1, false, "tahoma-bold", 1.0);
});

/**
 * Handling client events
 */
addEventHandler("onServerIntefaceTime", function(time, date) {
    drawdata.time = time;
    drawdata.date = date;
});

addEventHandler("onServerIntefaceCharacterJob", function(job) {
    drawdata.state = job;
});

addEventHandler("onServerIntefaceCharacterLevel", function(level) {
    drawdata.level = level;
});

addEventHandler("onServerIntefaceCharacter", function(job, level) {
    drawdata.state = job;
    drawdata.level = level;
});

addEventHandler("onServerInterfaceMoney", function(money) {
    drawdata.money = format("$ %.2f", money.tofloat());
})

addEventHandler("onServerFadeScreen", function(time, fadein) {
    fadeScreen(time.tofloat(), fadein);
});

/**
 * Initialization
 */
addEventHandler("onServerClientStarted", function(version = null) {
    log("onServerClientStarted");

    if (!ticker) {
        ticker = timer(onSecondChanged, 1000, -1);
    }

    // apply defaults
    setRenderHealthbar(false);

    // load params
    drawdata.version = (version) ? version : drawdata.version;
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

