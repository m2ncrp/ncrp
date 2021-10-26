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

local baseScale = screenX / 1600.0;
local drawing = true;
local ticker = null;
local microticker = null;
local drawdata = {
    time    = "",
    date    = "",
    status  = "",
    version = "0.0.000",
    money   = "",
    state   = "",
    level   = "",
    hunger  = 50.0,
    thirst  = 50.0,
    logos   = "bit.ly/m2ncrp | vk.com/m2ncrp",
};
local textures = {};
local initialized = false;
local datastore = {};
local lines     = [];

local chatslots = ["ooc", "ic", "b"];
local selectedslot = 0;

local asd = null;
local notifications = [];

local cursorVisible = false;

function compute(x, y) {
    datastore[x] <- y;
}

function has(x) {
    return (x in datastore);
}

function get(x) {
    return (x in datastore) ? datastore[x] : 0.0;
}

function lerp(start, alpha, end) {
    return (end - start) * alpha + start;
}

function onSecondChanged() {
    triggerServerEvent("onClientSendFPSData", getFPS());

    drawdata.status = format(
        "ID: %d  |  FPS: %d  |  Ping: %d", /*   |  Online: %d" */
        getLocalPlayer(),
        getFPS(),
        getPlayerPing(getLocalPlayer())
        //(getPlayerCount() + 1)
    );
}

local centerX = screenX * 0.5;
local centerY = screenY * 0.5;

/**
 * Main rendering callback
 */
addEventHandler("onClientFrameRender", function(isGUIdrawn) {
    if (!drawing) return;
    if (isGUIdrawn) return;

    local offset;
    local length;
    local height;

    // on init
    if (!initialized) {
        // // draw full black screen
        // dxDrawRectangle(0.0, 0.0, screenX, screenY, 0xFF000000);

        // height = 0;

        // // draw text
        // foreach (idx, value in welcomeTexts) {
        //     offset  = dxGetTextDimensions(value.text, value.size, "tahoma-bold")[0].tofloat();
        //     height += dxGetTextDimensions(value.text, value.size, "tahoma-bold")[1].tofloat();

        //     // calculate height offset
        //     height += value.offset;

        //     // draw it
        //     dxDrawText(value.text, centerX - (offset * 0.5), height, value.color, false, "tahoma-bold", value.size);
        // }

        return;
    }

    // if (asd) {
    //     local limit = 7.5;
    //     local c = getScreenFromWorld(-555.251,  1702.31, -22.2408);
    //     local pos = getPlayerPosition(getLocalPlayer());
    //     local dist = sqrt(pow(-555 - pos[0], 2) + pow(1702 - pos[1], 2) + pow(-22 - pos[2], 2));
    //     if (dist < limit) {
    //         local scale = 1 - (((dist > limit) ? limit : dist) / limit);
    //         dxDrawTexture(asd, c[0], c[1], scale, scale, 0.5, 0.5, 0.0, 255);
    //     }
    // }

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
    offset = 0;
    for (local i = 0; i < 3; i++) {
        local size = dxGetTextDimensions(chatslots[i], 1.0, "tahoma-bold")[0].tofloat() + 20.0;

        if (i == selectedslot) {
            dxDrawRectangle(15.0 + offset, 3.0, size - 1.0, 20.0, 0xFF29AF5C);
        }

        dxDrawText(chatslots[i], 25.0 + offset, 6.5, i == selectedslot ? 0xFF111111 : 0xFFFFFFFF, false, "tahoma-bold" );
        offset += size;
    }

    /**
     * Category: top-right
     */
    // draw time
    offset = dxGetTextDimensions(drawdata.time, 3.6, "tahoma-bold")[0].tofloat();
    dxDrawText(drawdata.time, screenX - offset - 15.0, 8.0, 0xFFE4E4E4, false, "tahoma-bold", 3.6 );

    // draw date
    offset = dxGetTextDimensions(drawdata.date, 1.4, "tahoma-bold")[0].tofloat();
    dxDrawText(drawdata.date, screenX - offset - 20.0, 58.0, 0xFFE4E4E4, false, "tahoma-bold", 1.4 );

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

        compute("hunger.x", get("borders.x") + get("roundy.width"));
        compute("hunger.y", get("borders.y") - get("roundy.width"));
        compute("hunger.size.x", screenX - get("hunger.x"));
        compute("hunger.size.y", screenY - get("hunger.y"));

        compute("hunger.px", get("hunger.x") + 32.0 * baseScale);
        compute("hunger.py", get("hunger.y") + 74.0 * baseScale);
        compute("hunger.psx", get("hunger.size.x") - 32.0 * baseScale * 2.0 + 1.0);
        compute("hunger.psy", get("hunger.size.y") - 50.0 * baseScale * 2.0);

        compute("hunger.w", get("hunger.psx") * 0.30); // width of each bar (hunger or thirst)
        compute("hunger.icon", get("hunger.psx") / 54.0);

        // local radius = length / 2;
        // local step   = 1.0;//0.5;

        // for (local x = 0; x < length; x += step) {
        //     local len = sqrt( pow(radius, 2) - pow(radius - x, 2) );

        //     lines.push({
        //         x = get("borders.x") + x,
        //         y = get("borders.y") - radius + len - 2.5,
        //         step = step,
        //         height = radius - len + 2.5
        //     });
        // }
    }
/*
    // draw base
    dxDrawRectangle(get("borders.x"), get("borders.y"), get("roundy.width"), get("roundy.height") + 5.0, 0xA1000000);
    for (local i = 0; i < lines.len(); i++) {
        local line = lines[i];
        dxDrawRectangle(line.x, line.y, line.step, line.height, 0xA1000000);
    }
*/
    // draw money
    local offset1 = dxGetTextDimensions(drawdata.money, 1.6, "tahoma-bold")[0].tofloat();
    local offset2 = dxGetTextDimensions(drawdata.money, 1.6, "tahoma-bold")[1].tofloat();
    dxDrawText( drawdata.money, get("borders.cx") - ( offset1 / 2 ) + 1.0, get("borders.y") + 3.0 + 1.0, 0xFF000000, false, "tahoma-bold", 1.6 );
    dxDrawText( drawdata.money, get("borders.cx") - ( offset1 / 2 )      , get("borders.y") + 3.0      , 0xFF569267, false, "tahoma-bold", 1.6 );

    // draw state
    local stateDimensions = dxGetTextDimensions(drawdata.state, 1.0, "tahoma-bold");
    local stateWidth = stateDimensions[0].tofloat();
    dxDrawText( drawdata.state, get("borders.cx") - ( stateWidth / 2 ) + 1.0, get("borders.y") + offset2 + 6.0, 0xFF000000, false, "tahoma-bold", 1.0 );
    dxDrawText( drawdata.state, get("borders.cx") - ( stateWidth / 2 )      , get("borders.y") + offset2 + 5.0, 0xFFA1A1A1, false, "tahoma-bold", 1.0 );

    // dxDrawRectangle(get("borders.x"), get("borders.y"), get("borders.cx"), get("borders.cy"), 0x99FFFFFF);

    // dxDrawText(stateWidth.tostring(), get("borders.x"), get("borders.y"), 0xFFA1A1A1, false, "tahoma-bold", 1.0 );
    // dxDrawText(stateHeight.tostring(), get("borders.cx"), get("borders.y") + 21, 0xFFA1A1A1, false, "tahoma-bold", 1.0 );

    // draw level
    // dxDrawText( drawdata.level, get("borders.x") + 11.0, get("borders.y") + offset2 + 21.0, 0xFFA1A1A1, false, "tahoma-bold", 1.0 );

    /**
     * Hunger and thirst
     */

    // debug stuff
    // dxDrawRectangle(get("hunger.x"), get("hunger.y"), get("hunger.size.x"), get("hunger.size.y"), 0x99FFFFFF);
    // dxDrawRectangle(get("hunger.px"), get("hunger.py"), get("hunger.psx"), get("hunger.psy"), 0x99FFFFFF);

    local hungerY  = (drawdata.hunger / 100.0) * get("hunger.psy");
    local thirstY = (drawdata.thirst / 100.0) * get("hunger.psy");

    // draw hunger                         >>x<<                                                   >>y<<                                          >>w<<                     >>h<<             color
    dxDrawRectangle( get("hunger.px") - 1.0,                                            get("hunger.py") - 1.0,                             get("hunger.w") + 2.0,      get("hunger.psy"),  0xA1000000);
    dxDrawRectangle( get("hunger.px"),                                                  get("hunger.py") + get("hunger.psy") - hungerY,     get("hunger.w"),            hungerY,            0xFF569267);
    // draw thirst
    dxDrawRectangle( get("hunger.px") + get("hunger.psx") - get("hunger.w") - 1.0,      get("hunger.py") - 1.0,                             get("hunger.w") + 2.0,      get("hunger.psy"),  0xA1000000);
    dxDrawRectangle( get("hunger.px") + get("hunger.psx") - get("hunger.w"),            get("hunger.py") + get("hunger.psy") - thirstY,     get("hunger.w"),            thirstY,            0xFF569267);

    if (!("ui_hunger_green" in textures)) return;
    if (!("ui_thirst_green" in textures)) return;

    // draw icons
    dxDrawTexture( textures.ui_hunger_green, get("hunger.px") + get("hunger.w") * 0.5,                              get("hunger.py") + get("hunger.psy"),   get("hunger.icon"),  get("hunger.icon"), 0.5, 0.5, 0.0, 255);
    dxDrawTexture( textures.ui_thirst_green, get("hunger.px") + get("hunger.psx") - get("hunger.w") * 0.5 + 1.0,    get("hunger.py") + get("hunger.psy"),   get("hunger.icon"),  get("hunger.icon"), 0.5, 0.5, 0.0, 255);

    /**
     * Bottom left corner
     */
    // draw logos
    // offset = dxGetTextDimensions(drawdata.logos, 1.0, "tahoma-bold")[1].tofloat();
    // dxDrawText(drawdata.logos, 6.5, screenY - offset - 6.5, 0x88FFFFFF, false, "tahoma-bold");
});

// setup default animation
local screenFade = {
    state   = "out",
    current = 0,
    time    = 5000,
};

addEventHandler("onClientFrameRender", function(isGUIdrawn) {
    if (!isGUIdrawn) return;

    if ( screenFade.current > 0 ) {
        local alpha = lerp(0, clamp(0.0, screenFade.current.tofloat() / screenFade.time.tofloat(), 1.0), 255).tointeger();
        dxDrawRectangle(0.0, 0.0, screenX, screenY, fromRGB(0, 0, 0, alpha));
    }
});

addEventHandler("onServerFadeScreen", function(time, type) {
    screenFade.state    = type.tostring();
    screenFade.time     = time.tofloat();
    screenFade.current  = (type == "in") ? 0 : screenFade.time.tofloat();
});

addEventHandler("onNativePlayerFadeout", function(time) {
    fadeScreen(time.tofloat(), true);
});

function onEvery10ms() {
    // transp -> black
    if (screenFade.state == "in" && screenFade.current < screenFade.time) {
        screenFade.current += 10;// / (getFPS().tofloat() + 1);
    }

    // black -> transp
    if (screenFade.state == "out" && screenFade.current > 0) {
        screenFade.current -= 10;//0 / (getFPS().tofloat() + 1);
    }
}

/**
 * Handling client events
 */
addEventHandler("onServerIntefaceTime", function(time, date) {
    drawdata.time = time;
    drawdata.date = date;
});

addEventHandler("onServerIntefaceCharacterJob", function(job) {
    drawdata.state = job; // Работа:
});

addEventHandler("onServerIntefaceCharacterLevel", function(level) {
    //drawdata.level = "Your level: " + level;
});

addEventHandler("onServerIntefaceCharacter", function(job, level) {
    drawdata.state = job; // Работа:
    //drawdata.level = "Your level: " + level;
});

addEventHandler("onServerInterfaceMoney", function(money) {
    drawdata.money = format("$ %.2f", money.tofloat());
})

addEventHandler("onServerAddedNofitication", function(type, data) {
    notifications.push({ type = type, data = data });
});

addEventHandler("onPlayerHungerUpdate", function(hunger, thirst) {
    drawdata.hunger = hunger;
    drawdata.thirst = thirst;
});

addEventHandler("onServerToggleHudDrawing", function() {
    drawing = !drawing;
    toggleHud(drawing);
});

addEventHandler("onServerChatTrigger", function() {
    showChat(!isChatVisible());
});

addEventHandler("onServerShowChatTrigger", function() {
    showChat(true);
});

addEventHandler("onServerHideChatTrigger", function() {
    showChat(false);
});

addEventHandler("onServerCursorTrigger", function() {
    cursorVisible = !cursorVisible;
    showCursor(cursorVisible);
});

addEventHandler("onServerShowCursorTrigger", function() {
    showCursor(true);
});

addEventHandler("onServerHideCursorTrigger", function() {
    showCursor(false);
});

addEventHandler("onServerChatSlotRequested", function(slot) {
    slot = slot.tointeger();
    slot = slot < 0 ? 0 : slot;
    slot = slot > chatslots.len() ? chatslots.len() : slot;

    // try to swtich slot
    // if (isInputVisible()) {
        selectedslot = slot;
    // }
});

// addEventHandler("onClientOpenMap", function() {
//     drawing = false;
//     return 1; // enable map (0 to disable)
// })

addEventHandler("onClientCloseMap", function() {
    return 1;
});

addEventHandler("map:onServerOpen", function() {
    delayedFunction(100, function() {
        openMap();
    });
});


addEventHandler("onServerKeyboard", function(key, state) {
    if (key == "m" && state == "down") {
        if (!initialized) return;

        if (drawing) {
            drawing = false;
            triggerServerEvent("map:onClientOpen");
        } else {
            triggerServerEvent("map:onClientClose");
            drawing = true;
        }

        showChat(drawing);
    }
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
    // setRenderNametags(true);
    // setRenderHealthbar(false);
    toggleHud(true);

    // load params
    drawdata.version = (version) ? version : drawdata.version;

    initialized = true;

    // asd = dxLoadTexture("fine.png");
    textures["ui_hunger_green"] <- dxLoadTexture("ui_hunger_green.png");
    textures["ui_thirst_green"] <- dxLoadTexture("ui_thirst_green.png");
    // textures["ui_hunger_red"]   <- dxLoadTexture("ui_hunger_red.png");
    // textures["ui_thirst_red"]   <- dxLoadTexture("ui_thirst_red.png");
});

addEventHandler("onClientScriptInit", function() {
    setRenderHealthbar(false);
    setRenderNametags(false);
    toggleHud(false);
    // sendMessage("You can start playing the game after registeration or login is succesfuly completed.", 0, 177, 106);
    // sendMessage("");
    // sendMessage("We have a support for english language. Switch via: /en", 247,  202, 24);
    // sendMessage("Ó íàñ åñòü ïîääåðæêà ðóññêîãî ÿçûêà. Âêëþ÷èòü: /ru", 247,  202, 24);
    // // sendMessage(format("screenX: %f, screenY: %f", screenX, screenY));

    if (!microticker) {
        microticker = timer(onEvery10ms, 10, -1);
    }

    triggerServerEvent("onClientSuccessfulyStarted");
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}
