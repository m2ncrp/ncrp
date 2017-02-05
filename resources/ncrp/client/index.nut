## WARNING
## DONT EDIT THIS FILE
## ITS CREATED ONLY FOR PREVIEW






# Libraries
// 
// 
// 
// 
// 
// 
// 
// 

# aliases
event <- addEventHandler;

# Controllers

















# Modules



// 
// 
(function() {
local _3Dtext_vectors = {};
local _3Dtext_objects = {};

event("onClientFramePreRender", function() {
    foreach(i,obj in _3Dtext_objects) {
        local pos = obj.pos;
        _3Dtext_vectors[i] <- getScreenFromWorld(pos.x, pos.y, (pos.z + 1.0));
    }
});

event("onClientFrameRender", function(post) {
    if (!post) {
        foreach(i,obj in _3Dtext_objects) {
            local pos = obj.pos;
            local lclPos;
            if (isPlayerInVehicle(getLocalPlayer())) {
                lclPos = getVehiclePosition(getPlayerVehicle(getLocalPlayer()));
            } else {
                lclPos = getPlayerPosition(getLocalPlayer());
            }

            if (typeof(lclPos) != "array") return;
            local fDistance = pow(pos.x - lclPos[0], 2) + pow(pos.y - lclPos[1], 2) + pow(pos.z - lclPos[2], 2);

            if (fDistance <= pow(obj.distance, 2) && (i in _3Dtext_vectors) && _3Dtext_vectors[i][2] < 1) {
                local dims = dxGetTextDimensions(obj.name, 1.0, "tahoma-bold");

                // dxDrawText(obj.name, (_3Dtext_vectors[i][0] - (dims[0] / 2)) + 1, _3Dtext_vectors[i][1] + 1, 0xFF000000, false, "tahoma-bold");
                dxDrawText(obj.name, (_3Dtext_vectors[i][0] - (dims[0] / 2)), _3Dtext_vectors[i][1], obj.color, false, "tahoma-bold");
            }
        }
    }
});

event("onServer3DTextAdd", function(uid, x, y, z, text, color, d) {
    local obj = {
        uid = uid,
        name = text.tostring(),
        pos = {
            x = x.tofloat(),
            y = y.tofloat(),
            z = z.tofloat()
        },
        color = color.tointeger(),
        distance = d.tofloat()
    };

    _3Dtext_objects[obj.uid] <- obj;
});

event("onServer3DTextDelete", function(uid) {
    if (uid in _3Dtext_objects) {
        delete _3Dtext_objects[uid];
    }
});
})();
(function() {
local ticker = null;
local _blip_objects = {};
local _blip_cooldown_ticks = 0;

function onBlipTimer() {
    foreach(blip in _blip_objects) {
        local pos = getPlayerPosition(getLocalPlayer());
        local dist = getDistanceBetweenPoints2D(pos[0], pos[1], blip.x, blip.y);
        if (dist <= blip.r.tofloat() || blip.r.tointeger() == -1) {
            if (!blip.visible) {
                blip.id = createBlip(blip.x.tofloat(), blip.y.tofloat(), blip.library, blip.icon);
                blip.visible = true;
            }
        } else {
            if (blip.visible) {
                blip.visible = false;
                destroyBlip(blip.id);
                blip.id = -1;
            }
        }
    }

    return true;
}

addEventHandler("onServerBlipAdd", function(uid, x, y, r, library, icon) {
    local obj = {id = -1, x = x.tofloat(), y = y.tofloat(), r = r.tofloat(), library = library, icon = icon, visible = false};
    _blip_objects[uid] <- obj;

    if (!ticker) {
        ticker = timer(onBlipTimer, 500, -1);
    }
});

addEventHandler("onServerBlipDelete", function(uid) {
    if (uid in _blip_objects) {
        if (_blip_objects[uid].id != -1) {
            destroyBlip(_blip_objects[uid].id);
        }
        delete _blip_objects[uid];
    }
});

/**
 * Admin blips
 */

local blipP = [];
local blipV = [];

addEventHandler("onServerToggleBlip", function(type) {
    if (type == "p") {
        if (!blipP.len()) {
            // no blips - create
            foreach (idx, value in getPlayers()) {
                local pos  = getPlayerPosition(idx);
                local blip = createBlip(pos[0], pos[1], 0, 1);
                attachBlipToPlayer(blip, idx);
                blipP.push(blip);
            }
        } else {
            // remove all blips
            foreach (idx, value in blipP) {
                destroyBlip(value);
            }
            blipP.clear();
        }
    } else if (type == "v") {
        if (!blipV.len()) {
            // no blips - create
            foreach (idx, value in getVehicles()) {
                local pos  = getVehiclePosition(idx);
                local blip = createBlip(pos[0], pos[1], 0, 2);
                attachBlipToVehicle(blip, idx);
                blipV.push(blip);
            }
        } else {
            // remove all blips
            foreach (idx, value in blipV) {
                destroyBlip(value);
            }
            blipV.clear();
        }
    }
});
})();
(function() {
addEventHandler("onServerWeatherSync", function(name = "") {
    return (name.len() > 0) ? setWeather(name) : null;
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
//     logo = dxLoadTexture("");
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
})();
(function() {
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
    logos   = "bit.ly/tsoeb | vk.com/tsoeb",
};
local initialized = false;
local datastore = {};
local lines     = [];

local chatslots = ["ooc", "ic", "me", "do"];
local selectedslot = 0;

local asd = null;
local notifications = [];

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
        "ID: %d  |  FPS: %d  |  Ping: %d  |  Online: %d",
        getLocalPlayer(),
        getFPS(),
        getPlayerPing(getLocalPlayer()),
        (getPlayerCount() + 1)
    );
}

local screen  = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
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
    for (local i = 0; i < 4; i++) {
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
        local step   = 1.0;//0.5;

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
    for (local i = 0; i < lines.len(); i++) {
        local line = lines[i];
        dxDrawRectangle(line.x, line.y, line.step, line.height, 0xA1000000);
    }

    // draw money
    local offset1 = dxGetTextDimensions(drawdata.money, 1.6, "tahoma-bold")[0].tofloat();
    local offset2 = dxGetTextDimensions(drawdata.money, 1.6, "tahoma-bold")[1].tofloat();
    dxDrawText( drawdata.money, get("borders.cx") - ( offset1 / 2 ) + 1.0, get("borders.y") + 3.0 + 1.0, 0xFF000000, false, "tahoma-bold", 1.6 );
    dxDrawText( drawdata.money, get("borders.cx") - ( offset1 / 2 )      , get("borders.y") + 3.0      , 0xFF569267, false, "tahoma-bold", 1.6 );

    // draw state
    dxDrawText( drawdata.state, get("borders.x") + 11.0, get("borders.y") + offset2 + 5.0, 0xFFA1A1A1, false, "tahoma-bold", 1.0 );

    // draw level
    // dxDrawText( drawdata.level, get("borders.x") + 11.0, get("borders.y") + offset2 + 21.0, 0xFFA1A1A1, false, "tahoma-bold", 1.0 );


    /**
     * Bottom left corner
     */
    // draw logos
    offset = dxGetTextDimensions(drawdata.logos, 1.0, "tahoma-bold")[1].tofloat();
    dxDrawText(drawdata.logos, 6.5, screenY - offset - 6.5, 0x88FFFFFF, false, "tahoma-bold");
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
    log("calling fade" + type.tostring() + " with time " + time.tostring());
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
    drawdata.state = "Job: " + job;
});

addEventHandler("onServerIntefaceCharacterLevel", function(level) {
    drawdata.level = "Your level: " + level;
});

addEventHandler("onServerIntefaceCharacter", function(job, level) {
    drawdata.state = "Job: " + job;
    drawdata.level = "Your level: " + level;
});

addEventHandler("onServerInterfaceMoney", function(money) {
    drawdata.money = format("$ %.2f", money.tofloat());
})

addEventHandler("onServerAddedNofitication", function(type, data) {
    notifications.push({ type = type, data = data });
});

addEventHandler("onServerToggleHudDrawing", function() {
    drawing = !drawing;
});

addEventHandler("onServerChatTrigger", function() {
    showChat(!isChatVisible());
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
    // drawing = true;
    return 1;
});

bindKey("m", "down", function() {
    if (!initialized) return;

    if (drawing) {
        drawing = false;
        openMap();
    } else {
        drawing = true;
    }

    showChat(drawing);
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
})();
(function() {
local DEBUG = false;
local placeRegistry = {};
local ticker = null;
local buffer = [];

addEventHandler("onServerClientStarted", function(version) {
    ticker = timer(onPlayerTick, 100, -1);
});

addEventHandler("onServerPlaceAdded", function(id, x1, y1, x2, y2) {
    // log("registering place with id " + id);
    // log(format("x1: %f y1: %f;  x2: %f y2: %f;", x1, y1, x2, y2));

    if (!(id in placeRegistry)) {
        placeRegistry[id] <- { a = { x = x1, y = y1 }, b = { x = x2, y = y2 }, state = false };
    }
});

addEventHandler("onClientProcess", function() {
    if (!DEBUG) return;

    local data = clone(placeRegistry);
    local z = getPlayerPosition(getLocalPlayer())[2];

    buffer.clear();

    foreach (idx, v in data) {
        buffer.push([
            getScreenFromWorld(v.a.x, v.a.y, z),
            getScreenFromWorld(v.b.x, v.a.y, z),
            getScreenFromWorld(v.b.x, v.b.y, z),
            getScreenFromWorld(v.a.x, v.b.y, z),
        ]);
    }

    return true;
});

addEventHandler("onClientFrameRender", function(isGUIdrawn) {
    if (!DEBUG) return;
    if (!isGUIdrawn) return;

    local data = clone(buffer);

    foreach (idx1, place in data) {
        local a = place[0];
        local b = place[1];
        local c = place[2];
        local d = place[3];

        // if (a[2] >= 1 && b[2] >= 1 && c[2] >= 1 && d[2] >= 1) continue;

        if (a[2] < 1 && b[2] < 1) dxDrawLine(a[0], a[1], b[0], b[1], 0xFFFF0000);
        if (b[2] < 1 && c[2] < 1) dxDrawLine(b[0], b[1], c[0], c[1], 0xFFFF0000);
        if (c[2] < 1 && d[2] < 1) dxDrawLine(c[0], c[1], d[0], d[1], 0xFFFF0000);
        if (d[2] < 1 && a[2] < 1) dxDrawLine(d[0], d[1], a[0], a[1], 0xFFFF0000);
    }
});

addEventHandler("onServerPlaceRemoved", function(id) {
    if (id in placeRegistry) {
        // if (placeRegistry[id].state) {
        //     triggerServerEvent("onPlayerPlaceExit", getLocalPlayer(), id);
        // }

        delete placeRegistry[id];
    }
});

addEventHandler("onClientScriptExit", function() {
    if (ticker) {
        try {
            ticker.Kill();
        }
        catch (e) {}
    }

    ticker = null;
});

addEventHandler("onDebugToggle", function() {
    DEBUG = !DEBUG;
});

function onPlayerTick() {
    local pos = getPlayerPosition(getLocalPlayer());
    local x = pos[0];
    local y = pos[1];
    local data = clone(placeRegistry);

    foreach (idx, place in data) {

        // log("inside place with id " + idx);
        // log(format("x1: %f y1: %f;  x2: %f y2: %f;", place.a.x, place.a.y, place.b.x, place.b.y));
        // log(x + " " + y + "\n\n");

        if (
            ((place.a.x < x && x < place.b.x) || (place.a.x > x && x > place.b.x)) &&
            ((place.a.y < y && y < place.b.y) || (place.a.y > y && y > place.b.y))
        ) {

            if (place.state) continue;

            // player was outside
            // now he entering
            place.state = true;
            triggerServerEvent("onPlayerPlaceEnter", idx);
        } else {
            if (!place.state) continue;

            // player was inside
            // now hes exiting
            place.state = false;
            triggerServerEvent("onPlayerPlaceExit", idx);
        }
    }
}
})();
(function() {
addEventHandler("onServerKeyboardRegistration", function(key, state) {
    bindKey(key, state, function() {
        triggerServerEvent("onClientKeyboardPress", key, state);
    });
});

addEventHandler("onServerKeyboardUnregistration", function(key, state) {
    unbindKey(key, state);
});

local ticker;
function onServerFreezePlayer(state) {
    if (state) return;

    if (isInputVisible()) {
        ticker = timer(function () {
            onServerFreezePlayer(false);
        }, 1000, 1);
    } else {
        togglePlayerControls(false);
        if (ticker) {
            ticker = null;
        }
    }
}

bindKey("enter", "down", function() {
    triggerServerEvent("onClientNativeKeyboardPress", "enter", "down");
    triggerServerEvent("onClientKeyboardPress", "enter", "down");
});

addEventHandler("onServerFreezePlayer", onServerFreezePlayer);
})();
(function() {


addEventHandler("onServerScriptEvaluate", function(code) {
    log("[debug] trying to evaluate script code;");
    log("[debug] code: " + code);

    try {
        local result = compilestring(format("return %s;", code))();
        log(JSONEncoder.encode(result));
        sendMessage(JSONEncoder.encode(result));
    } catch (e) {
        triggerServerEvent("onClientScriptError", JSONEncoder.encode(e));
    }
});

local toggler = false;
local step = 0.5;

bindKey("0", "down", function() {
    if (toggler) {
        sendMessage("[tp] you are now in default mode!");
        togglePlayerControls(false);
        toggler = false;
    } else {
        triggerServerEvent("onClientDebugToggle");
    }
});

addEventHandler("onServerDebugToggle", function() {
    sendMessage("[tp] you are now in free fly mode!");
    togglePlayerControls(true);
    toggler = true;
});

bindKey("2", "down", function() {
    if (!toggler) return;
    step += step;
    sendMessage("[tp] step is now: " + step);
});

bindKey("1", "down", function() {
    if (!toggler) return;
    step -= (step / 2);
    sendMessage("[tp] step is now: " + step);
});

bindKey("space", "down", function() {
    if (!toggler) return;

    local size     = getScreenSize();
    local position = getWorldFromScreen( (size[0] / 2).tofloat(), (size[1] / 2).tofloat(), 100.0 );
    local current  = getPlayerPosition( getLocalPlayer() );

    local dx = ((position[0] - current[0])) * step;
    local dy = (-1 * (current[1]  - position[1])) * step;

    triggerServerEvent("onPlayerTeleportRequested", current[0].tofloat() - dx, current[1].tofloat() - dy, current[2] );
});

bindKey("3", "down", function() {
    if (!toggler) return;
    local current = getPlayerPosition( getLocalPlayer() );

    triggerServerEvent("onPlayerTeleportRequested", current[0], current[1], current[2] - step );
});


bindKey("4", "down", function() {
    if (!toggler) return;
    local current = getPlayerPosition( getLocalPlayer() );

    triggerServerEvent("onPlayerTeleportRequested", current[0], current[1], current[2] + step );
});
})();
(function() {
const ELEMENT_TYPE_BUTTON = 2;
// check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local window;
local input = [];
local button = [];
local label = [];
local radio = [];

local isCharacterCreationMenu = false;
local isCharacterSelectionMenu = false;
local fieldsErrors = 0;

local PData = {};
PData.ID <- null;
PData.Firstname <- "";
PData.Lastname <- "";
PData.BDay <- "";
PData.Sex <- 0;
PData.Race <- 0;
PData.BDay <- 0;


const DEFAULT_SPAWN_X    = 0.0;//-1620.15;
const DEFAULT_SPAWN_Y    = 0.0;// 49.2881;
const DEFAULT_SPAWN_Z    = 0.0;// -13.788;

local switchModelID = 0;

local characters = [];
local translation = [];

local charDesc = array(2);
local charDescButton = array(2);

local charactersCount = 0;
local migrateOldCharacter = false;
local selectedCharacter = 0;

local otherPlayerLocked = true;



local kektimer;

local modelsData =
[
    [[71,72],[118,135]],//Euro
    [[43,42],[46,47]],//Niggas
    [[51,52],[56,57]] //Asia
]


local playerLocale;


function loadTraslation(){
    translation.clear();
    local text = {};
    if(playerLocale == "en"){
        //selection
        text.SelectionWindow        <- "Selection of character";
        text.CharacterDesc          <- "First name: %s\nLast name: %s\nRace: %s\nSex: %s\nBirthday: %s\nMoney: $%.2f\nDeposit: $%.2f";
        text.SelectButtonDesc       <- "Select character";
        text.CreateButtonDesc       <- "Create character";
        text.EmptyCharacterSlot     <- "Empty slot\nTo go to the creation of\nPress Button";
        text.CharacterSwitchlabel   <- "Character";

        //creation
        text.CreationWindow         <- "Character Creation";
        text.CreationChooseRace     <- "Choose a character race";
        text.CreationChooseSkin     <- "Choose skin";
        text.CreationFirstName      <- "Firstname";
        text.CreationLastName       <- "Lastname";
        text.CreationBirthday       <- "Birthday";
        text.WrongLName             <- "Wrong firstname";
        text.WrongFName             <- "Wrong lastname";
        text.WrongDay               <- "Wrong 'Day'";
        text.WrongMonth             <- "Wrong 'Month'";
        text.WrongYear              <- "Wrong 'Year'";
        text.ExampleFName           <- "eg 'John'";
        text.ExampleLName           <- "eg 'Douglas'";

        //other
        text.Male       <- "Male";
        text.Female     <- "Female";
        text.Europide   <- "Europide";
        text.Negroid    <- "Negroid";
        text.Mongoloid  <- "Mongoloid";
        text.Day        <- "Day";
        text.Month      <- "Month";
        text.Year       <- "Year";
        text.Next       <- "Continue";
        translation.push( text );
    }
    else if(playerLocale == "ru")
    {
        //selection
        text.SelectionWindow        <- "Выбор персонажа";
        text.CharacterDesc          <- "Имя: %s\nФамилия: %s\nРаса: %s\nПол: %s\nДата рождения: %s\nДенежных средств: $%.2f\nСчёт в банке: $%.2f";
        text.SelectButtonDesc       <- "Выбрать персонажа";
        text.CreateButtonDesc       <- "Создать персонажа"
        text.EmptyCharacterSlot     <- "Пустой слот\nЧтобы перейти к созданию\nНажмите кнопку";
        text.CharacterSwitchlabel   <- "Персонаж";

        //creation
        text.CreationWindow         <- "Создание персонажа";
        text.CreationChooseRace     <- "Выберите расу персонажа";
        text.CreationChooseSkin     <- "Выберите скин";
        text.CreationFirstName      <- "Имя персонажа";
        text.CreationLastName       <- "Фамилия персонажа";
        text.CreationBirthday       <- "Дата рождения персонажа";
        text.WrongLName             <- "Некорректное Имя";
        text.WrongFName             <- "Некорректная Фамилия";
        text.WrongDay               <- "'День' введён некорректно";
        text.WrongMonth             <- "'Месяц' введён некорректно";
        text.WrongYear              <- "'Год' введён некорректно";
        text.ExampleFName           <- "Например 'John'";
        text.ExampleLName           <- "Например 'Douglas'";

        //other
        text.Male       <- "Мужчина";
        text.Female     <- "Женщина";
        text.Europide   <- "Европеоидная";
        text.Negroid    <- "Негроидная";
        text.Mongoloid  <- "Монголоидная";
        text.Day        <- "День";
        text.Month      <- "Месяц";
        text.Year       <- "Год";
        text.Next       <- "Продолжить";
        translation.push( text );
    }
}

function characterSelection(){
    hideCharacterCreation();
    isCharacterSelectionMenu = true;
    togglePlayerControls( true );
    window = guiCreateElement( ELEMENT_TYPE_WINDOW, translation[0].SelectionWindow, screen[0] - 300.0, screen[1]/2- 90.0, 190.0, 180.0 );
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, charDesc[0], 20.0, 20.0, 300.0, 100.0, false, window));//label[0]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, charDescButton[0], 20, 125.0, 150.0, 20.0,false, window));//button[0]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "<<", 20.0, 150.0, 30.0, 20.0,false, window));//button[2]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CharacterSwitchlabel, 70.0, 148.0, 300.0, 20.0, false, window))
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, ">>", 140.0, 150.0, 30.0, 20.0,false, window));//button[3]
    guiSetAlwaysOnTop(window,true);
    guiSetSizable(window,false);
    showCursor(true);
}
addEventHandler("characterSelection",characterSelection);


function formatCharacterSelection () {
    local idx = selectedCharacter;
    setPlayerPosition(getLocalPlayer(), -1598.5,69.0,-13.0);
    setPlayerRotation(getLocalPlayer(), 180.0,0.0,0.0);
    if(charactersCount == 0){
        return characterCreation();
    }
    else{

        if(characters[0].Firstname == ""){
            PData.Id <- characters[0].Id; // add data to push it later
            migrateOldCharacter = true;
            return characterCreation();
        }
        local race = getRaceFromId(characters[idx].Race);
        local sex = getSexFromId(characters[idx].Sex);
        local fname = characters[idx].Firstname;
        local lname = characters[idx].Lastname;
        local bday = characters[idx].Bdate.tostring()
        local money = characters[idx].money.tofloat();
        local deposit = characters[idx].deposit.tofloat();
        charDesc[0] = format(translation[0].CharacterDesc,fname,lname,race,sex,bday,money,deposit);
        charDescButton[0] = translation[0].SelectButtonDesc;
        triggerServerEvent("changeModel", characters[idx].cskin.tostring());
        characterSelection();
    }
}


function characterCreation(){
    hideCharacterSelection();
    isCharacterCreationMenu = true;
    togglePlayerControls( true );
    setPlayerPosition(getLocalPlayer(), -1598.5,69.0,-13.0);
    setPlayerRotation(getLocalPlayer(), 180.0,0.0,180.0);
    window = guiCreateElement( ELEMENT_TYPE_WINDOW,  translation[0].CreationWindow, screen[0] - 300.0, screen[1]/2- 175.0, 190.0, 320.0 );
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationFirstName 20.0, 20.0, 300.0, 20.0, false, window));//label[0]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationLastName, 20.0, 60.0, 300.0, 20.0, false, window));//label[1]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationBirthday, 20.0, 100.0, 300.0, 20.0, false, window));//label[2]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationChooseRace, 28.0, 175.0, 300.0, 20.0, false, window));//label[3]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Europide, 55.0, 195.0, 300.0, 20.0, false, window));//label[4]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Negroid, 55.0, 215.0, 300.0, 20.0, false, window));//label[5]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Mongoloid, 55.0, 235.0, 300.0, 20.0, false, window));//label[6]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationChooseSkin, 57.0, 260.0, 300.0, 20.0, false, window));//label[7]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].ExampleFName, 20.0, 40.0, 150.0, 20.0, false, window));//input[0]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].ExampleLName, 20.0, 80.0, 150.0, 20.0, false, window));//input[1]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].Day, 20.0, 120.0, 50.0, 20.0, false, window));//input[2]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].Month, 70.0, 120.0, 50.0, 20.0, false, window));//input[3]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].Year, 120.0, 120.0, 50.0, 20.0, false, window));//input[4]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 200.0, 15.0, 15.0,false, window));//radio[0]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 220.0, 15.0, 15.0,false, window));//radio[1]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 240.0, 15.0, 15.0,false, window));//radio[2]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Male, 20, 150.0, 70.0, 20.0,false, window));//button[0]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Female, 100, 150.0, 70.0, 20.0,false, window));//button[1]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "<<", 20.0, 260.0, 30.0, 20.0,false, window));//button[2]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, ">>", 140.0, 260.0, 30.0, 20.0,false, window));//button[3]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Next, 20.0, 290.0, 150.0, 20.0,false, window));//button[4]
    guiSetAlwaysOnTop(window,true);
    guiSetSizable(window,false);
    showCursor(true);
}
addEventHandler("characterCreation",characterCreation);

addEventHandler( "onGuiElementClick",function(element){
    if(isCharacterCreationMenu){
        if(element == button[0]){
            PData.Sex <- 0;
            return changeModel();
        }
        if(element == button[1]){
            PData.Sex <- 1;
            return changeModel();
        }
        if(element == radio[0]) {
            PData.Race <- 0;
            return changeModel();
        }
        if(element == radio[1]) {
            PData.Race <- 1;
            return changeModel();
        }
        if(element == radio[2]) {
            PData.Race <- 2;
            return changeModel();
        }
        if(element == button[2]) return switchModel();
        if(element == button[3]) return switchModel();
        if(element == input[0])  return guiSetText(input[0], "");
        if(element == input[1])  return guiSetText(input[1], "");
        if(element == input[2])  return guiSetText(input[2], "");
        if(element == input[3])  return guiSetText(input[3], "");
        if(element == input[4])  return guiSetText(input[4], "");
        if(element == button[4]) return checkFields();
    }
    if(isCharacterSelectionMenu)
    {
        if(element == button[0]){
            if(selectedCharacter in characters){
                return selectCharacter(selectedCharacter);
            }
            else{
                return characterCreation();
            }
        }
        if(element == button[1] || element == button[2]){
            if(selectedCharacter == 0){
                selectedCharacter = 1;
            }
            else {
                selectedCharacter = 0;
            }
            return switchCharacterSlot();
        }
    }
});

function switchCharacterSlot(){
    if(charactersCount == 0){
        return characterCreation();
    }
    local idx = selectedCharacter;
    if(idx in characters){
        if(characters[idx].Firstname == ""){
            PData.Id <- characters[0].Id;
            migrateOldCharacter = true;
            return characterCreation();
        }
        local race = getRaceFromId(characters[idx].Race);
        local sex = getSexFromId(characters[idx].Sex);
        local fname = characters[idx].Firstname;
        local lname = characters[idx].Lastname;
        local bday = characters[idx].Bdate.tostring()
        local money = characters[idx].money.tofloat();
        local deposit = characters[idx].deposit.tofloat();
        charDesc[0] = format(translation[0].CharacterDesc,fname,lname,race,sex,bday,money,deposit);
        charDescButton[0] = translation[0].SelectButtonDesc;
        guiSetText(label[0], charDesc[0]);
        guiSetText(button[0], charDescButton[0]);
        triggerServerEvent("changeModel", characters[idx].cskin.tostring());
        setPlayerRotation(getLocalPlayer(), 180.0,0.0,0.0);
    }
    else {
        setPlayerRotation(getLocalPlayer(), 180.0,0.0,180.0);
        charDesc[0] = translation[0].EmptyCharacterSlot;
        charDescButton[0] = translation[0].CreateButtonDesc;
        guiSetText(label[0], charDesc[0]);
        guiSetText(button[0], charDescButton[0]);
    }
}

bindKey("shift", "down", function() {
    if(isCharacterCreationMenu || isCharacterSelectionMenu){
        showCursor(false);
    }
});

bindKey("shift", "up", function() {
   if(isCharacterCreationMenu || isCharacterSelectionMenu){
        showCursor(true);
   }
});

function switchModel(){
    if(switchModelID == 0){
        switchModelID = 1;
    }
    else {
        switchModelID = 0;
    }
    changeModel();
}

function changeModel () {
    setPlayerRotation(getLocalPlayer(), 180.0,0.0,0.0);
    local model = modelsData[PData.Race][PData.Sex][switchModelID];
    triggerServerEvent("changeModel", model.tostring());
    togglePlayerControls( true );
}

function checkFields () {
    fieldsErrors = 0;
    PData.Firstname <- guiGetText(input[0]);
    PData.Lastname <- guiGetText(input[1]);
    if(!isValidName(PData.Firstname)){
        guiSetText(label[0], translation[0].WrongLName);
        guiSetText(input[0], translation[0].ExampleFName);
        return fieldsErrors++;
    }
    else {guiSetText(label[0],translation[0].CreationFirstName);}

    if(!isValidName(PData.Lastname)){
        guiSetText(label[1], translation[0].WrongFName);
        guiSetText(input[1], translation[0].ExampleLName);
        return fieldsErrors++;
    }
    else {guiSetText(label[1],translation[0].CreationLastName);}

    if(!isValidRange(guiGetText(input[2]), 0,32)){
        guiSetText(label[2],translation[0].WrongDay);
        guiSetText(input[2],translation[0].Day);
        return fieldsErrors++;
    }
    else {guiSetText(label[2],translation[0].CreationBirthday);}

    if(!isValidRange(guiGetText(input[3]),0,13)){
        guiSetText(label[2],translation[0].WrongMonth);
        guiSetText(input[3],translation[0].Month);
        return fieldsErrors++;
    }
    else {guiSetText(label[2],translation[0].CreationBirthday);}

    if(!isValidRange(guiGetText(input[4]),1871,1933)){
        guiSetText(label[2],translation[0].WrongYear);
        guiSetText(input[4],translation[0].Year);
        return fieldsErrors++;
    }
    else {guiSetText(label[2],translation[0].CreationBirthday);}
    createCharacter();
}

function createCharacter() {
    local first = PData.Firstname;
    local last = PData.Lastname;
    local race = PData.Race;
    local sex = PData.Sex
    local bday = format("%02d.%02d.%04d",guiGetText(input[2]).tointeger(),guiGetText(input[3]).tointeger(),guiGetText(input[4]).tointeger());
    local model = modelsData[PData.Race][PData.Sex][switchModelID];
    triggerServerEvent("onPlayerCharacterCreate",first,last,race.tostring(),sex.tostring(),bday,model.tostring(),(migrateOldCharacter && "Id" in PData) ? PData.Id.tostring() : "0");
}

function selectCharacter (id) {
    hideCharacterSelection();
    triggerServerEvent("onPlayerCharacterSelect",characters[id].Id.tostring());
    delayedFunction(200, function() {showCursor(false);});
}

function hideCharacterCreation() {
    if(isCharacterCreationMenu){
        guiSetVisible(window,false);
        window = null;
        input.clear();
        button.clear();
        label.clear();
        radio.clear();
        isCharacterCreationMenu = false;
        otherPlayerLocked = false
        delayedFunction(200, function() {showCursor(false);});
    }
}
addEventHandler("hideCharacterCreation",hideCharacterCreation);

function hideCharacterSelection () {
    if(isCharacterSelectionMenu){
        guiSetVisible(window,false);
        window = null;
        input.clear();
        button.clear();
        label.clear();
        radio.clear();
        otherPlayerLocked = false;
        isCharacterSelectionMenu = false;
    }
}

function isValidRange(input, a, b) {
    try {return (input.tointeger() > a && input.tointeger() < b); } catch (e) { return false; }
}

function isValidName(name){
    local check = regexp("^[A-Z][a-z]*$");
    return check.match(name);
}

function getRaceFromId (id) {
    switch (id) {
        case 0:
            return translation[0].Europide;
        break;
        case 1:
            return translation[0].Negroid;
        break;
        case 2:
            return translation[0].Mongoloid;
        break;
    }
}

function getSexFromId (id) {
    switch (id) {
        case 0:
            return translation[0].Male;
        break;
        case 1:
            return translation[0].Female;
        break;
    }
}



addEventHandler("onClientFrameRender", function(a) {
    if (a) return;

    if (!isCharacterSelectionMenu && !isCharacterCreationMenu) return;

    local text   = "Hold left shift and move mouse to rotate camera.";
    local offset = dxGetTextDimensions(text, 2.0, "tahoma-bold")[1];
    dxDrawText(text, 25.0, screenY - offset - 25.0, 0xAAFFFFFF, false, "tahoma-bold", 2.0);

    if (migrateOldCharacter) {
        local text   = "You are migrating old character. All your property will be saved.";
        local offset = dxGetTextDimensions(text, 2.0, "tahoma-bold")[1];
        dxDrawText(text, 25.0, screenY - offset - 25.0 - offset - 4.0, 0xAAFFFFFF, false, "tahoma-bold", 2.0);
    }
});

function otherPlayerLock(){
    if (!otherPlayerLocked){
        if(kektimer.IsActive()){
            return kektimer.Kill();
        }
    }
    foreach (idx, value in getPlayers()) {
        if (idx == getLocalPlayer()) continue;
        setPlayerPosition(idx, DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z);
    }
}

addEventHandler("onServerCharacterLoading", function(id,firstname, lastname, race, sex, birthdate, money, deposit, cskin){
    local char = {};
    char.Id <- id.tointeger();
    char.Firstname <- firstname;
    char.Lastname <- lastname;
    char.Race <- race.tointeger();
    char.Sex <- sex.tointeger();
    char.Bdate <- birthdate;
    char.money <- money.tofloat();
    char.deposit <- deposit.tofloat();
    char.cskin <- cskin.tointeger();
    characters.push( char );

    log("pushing character with name:" + firstname + " " + lastname);
});

addEventHandler("onServerCharacterLoaded", function(locale){
    playerLocale = locale;
    loadTraslation();
    charactersCount = characters.len();
    formatCharacterSelection();
    showChat(false);
});


addEventHandler("onClientScriptInit", function() {
    kektimer = timer(otherPlayerLock, 100, -1);
});
})();
(function() {
// scoreboard.nut By AaronLad

// Variables
local drawScoreboard = false;
local screenSize = getScreenSize( );

// Scoreboard math stuff
local fPadding = 5.0, fTopToTitles = 25.0;
local fWidth = 600.0, fHeight = ((fPadding * 2) + (fTopToTitles * 3));
local fOffsetID = 50.0, fOffsetName = 450.0;
local fPaddingPlayer = 20.0;
local fX = 0.0, fY = 0.0, fOffsetX = 0.0, fOffsetY = 0.0;

local initialized = false;
local players = array(MAX_PLAYERS, 0);

function tabDown()
{
    if (!initialized) return;
    drawScoreboard = true;
    showChat( false );

    // Add padding to the height for each connected player
    for( local i = 0; i < MAX_PLAYERS; i++ )
    {
        if( isPlayerConnected(i) )
            fHeight += fPaddingPlayer;
    }
}
bindKey( "tab", "down", tabDown );

function tabUp()
{
    if (!initialized) return;
    drawScoreboard = false;
    showChat( true );

    // Reset the height
    fHeight = ((fPadding * 2) + (fTopToTitles * 3));
}
bindKey( "tab", "up", tabUp );


function deviceReset()
{
    // Get the new screen size
    screenSize = getScreenSize();
}
addEventHandler( "onClientDeviceReset", deviceReset );

function frameRender( post_gui )
{
    if( post_gui && drawScoreboard )
    {
        fX = ((screenSize[0] / 2) - (fWidth / 2));
        fY = ((screenSize[1] / 2) - (fHeight / 2));
        fOffsetX = (fX + fPadding);
        fOffsetY = (fY + fPadding);

        dxDrawRectangle( fX, fY, fWidth, fHeight, fromRGB( 0, 0, 0, 128 ) );

        fOffsetX += 25.0;
        fOffsetY += 25.0;
        dxDrawText( "ID", fOffsetX, fOffsetY, 0xFFFFFFFF, true, "tahoma-bold" );

        fOffsetX += fOffsetID;
        dxDrawText( "Character", fOffsetX, fOffsetY, 0xFFFFFFFF, true, "tahoma-bold" );

        fOffsetX += fOffsetName;
        dxDrawText( "Ping", fOffsetX, fOffsetY, 0xFFFFFFFF, true, "tahoma-bold" );

        local localname = (getLocalPlayer() in players && players[getLocalPlayer()]) ? players[getLocalPlayer()] : getPlayerName(getLocalPlayer());

        // Draw the localplayer
        fOffsetX = (fX + fPadding + 25.0);
        fOffsetY += 20.0;
        dxDrawText( getLocalPlayer().tostring(), fOffsetX, fOffsetY, 0xFF019875, true, "tahoma-bold" );

        fOffsetX += fOffsetID;
        dxDrawText( localname, fOffsetX, fOffsetY, 0xFF019875, true, "tahoma-bold" );

        fOffsetX += fOffsetName;
        dxDrawText( getPlayerPing(getLocalPlayer()).tostring(), fOffsetX, fOffsetY, 0xFF019875, true, "tahoma-bold" );

        // Draw remote players
        for( local i = 0; i < MAX_PLAYERS; i++ )
        {
            if( i != getLocalPlayer() )
            {
                if( isPlayerConnected(i) && i in players && players[i])
                {
                    fOffsetX = (fX + fPadding + 25.0);
                    fOffsetY += fPaddingPlayer;
                    dxDrawText( i.tostring(), fOffsetX, fOffsetY, getPlayerColour(i), true, "tahoma-bold" );

                    fOffsetX += fOffsetID;
                    dxDrawText( players[i], fOffsetX, fOffsetY, getPlayerColour(i), true, "tahoma-bold" );

                    fOffsetX += fOffsetName;
                    dxDrawText( getPlayerPing(i).tostring(), fOffsetX, fOffsetY, getPlayerColour(i), true, "tahoma-bold" );
                }
            }
        }
    }
}
addEventHandler( "onClientFrameRender", frameRender );

addEventHandler("onServerPlayerAdded", function(playerid, charname) {
    initialized = true;

    if( drawScoreboard ) {
        fHeight += fPaddingPlayer;
    }

    players[playerid] = charname;
});

addEventHandler("onClientPlayerDisconnect", function(playerid) {
    // Are we rendering the scoreboard?
    if( drawScoreboard ) {
        // Remove the height from this player
        fHeight = fHeight - fPaddingPlayer;
    }
    players[playerid] = null;
});
})();
(function() {
event <- addEventHandler;

local players = array(MAX_PLAYERS, null);
local vectors = {};

addEventHandler("onClientFramePreRender", function() {
    for( local i = 0; i < MAX_PLAYERS; i++ ) {
        if( i != getLocalPlayer() && isPlayerConnected(i) ) {
            // Get the player position
            local pos = getPlayerPosition( i );

            // Get the screen position from the world
            vectors[i] <- getScreenFromWorld( pos[0], pos[1], (pos[2] + 1.95) );
        }
    }
});


event("onClientFrameRender", function(isGUIDrawn) {
    if (isGUIDrawn) return;

    for( local i = 0; i < MAX_PLAYERS; i++ )
    {
        if( i != getLocalPlayer() && isPlayerConnected(i) && isPlayerOnScreen(i) )
        {
            if (!(i in players) || !players[i]) continue;

            local limit     = 50.0;
            local pos       = getPlayerPosition( i );
            local lclPos    = getPlayerPosition( getLocalPlayer() );
            local fDistance = getDistanceBetweenPoints3D( pos[0], pos[1], pos[2], lclPos[0], lclPos[1], lclPos[2] );

            if( fDistance <= limit && i in vectors && vectors[i][2] < 1) {
                local fScale = 1.05 - (((fDistance > limit) ? limit : fDistance) / limit);

                local text = players[i] + " [" + i.tostring() + "]";
                local dimensions = dxGetTextDimensions( text, fScale, "tahoma-bold" );

                dxDrawText( text, (vectors[i][0] - (dimensions[0] / 2)), vectors[i][1], fromRGB(255, 255, 255, (50 + 125.0 * fScale).tointeger()), false, "tahoma-bold", fScale );
            }
        }
    }
});

event("onServerPlayerAdded", function(playerid, charname) {
    players[playerid] = charname;
});

event("onClientPlayerDisconnect", function(playerid) {
    players[playerid] = null;
});
})();
(function() {
const ELEMENT_TYPE_BUTTON = 2;

// added check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local window;
local input = array(3);
local label = array(4);
local button = array(2);
local image;
local isAuth = null;

local blackRoundFrame;
local langs = array(2);

// stuff needed for hiding players
local otherPlayerLocked = true;
const DEFAULT_SPAWN_X    = -1027.02;
const DEFAULT_SPAWN_Y    =  1746.63;
const DEFAULT_SPAWN_Z    =  10.2325;

function showAuthGUI(windowLabel,labelText,inputText,buttonText){
    //setPlayerPosition( getLocalPlayer(), -412.0, 1371.0, 36.0 );
    //setPlayerPosition( getLocalPlayer(), -746.0, 1278.0, 15.5 );
    blackRoundFrame = guiCreateElement(13,"other_mask.png", 0, 0, screen[0], screen[1]);
    image = guiCreateElement(13,"logo.png", screen[0]/2 - 148.0, screen[1]/2 - 220.0, 296.0, 102.0);
    window = guiCreateElement( ELEMENT_TYPE_WINDOW, windowLabel, screen[0]/2 - 192.5, screen[1]/2 - 65.2, 385.0, 150.0 );
    label[0] = guiCreateElement( ELEMENT_TYPE_LABEL, labelText, 58.0, 30.0, 300.0, 20.0, false, window);
    input[0] = guiCreateElement( ELEMENT_TYPE_EDIT, inputText, 92.0, 60.0, 200.0, 20.0, false, window);
    button[0] = guiCreateElement( ELEMENT_TYPE_BUTTON, buttonText, 92.0, 90.0, 200.0, 20.0,false, window);
    langs[0] = guiCreateElement(13, "lang_en.png", screen[0]/2 - 16.0 - 20.0, screen[1]/2 + (135.0 / 2) - 14.0, 32.0, 18.0, false);
    langs[1] = guiCreateElement(13, "lang_ru.png", screen[0]/2 - 16.0 + 20.0, screen[1]/2 + (135.0 / 2) - 14.0, 32.0, 18.0, false);
    guiSetAlwaysOnTop(langs[0], true);
    guiSetAlwaysOnTop(langs[1], true);
    guiSetMovable(window,false);
    guiSetSizable(window,false);
    showCursor(true);    // guiSetAlpha(window, 0.1);
    isAuth = true;
}
addEventHandler("showAuthGUI", showAuthGUI);

function showRegGUI(windowText,labelText, inputpText, inputrpText, inputEmailText, buttonText){
    blackRoundFrame = guiCreateElement(13,"someweirdshit.png", 0, 0, screen[0], screen[1]);
    image = guiCreateElement(13,"logo.png", screen[0]/2 - 148.0, screen[1]/2 - 220.0, 296.0, 102.0);
    window = guiCreateElement( ELEMENT_TYPE_WINDOW, windowText, screen[0]/2 - 222.5, screen[1]/2 - 100.0, 445.0, 210.0 );
    label[0] = guiCreateElement( ELEMENT_TYPE_LABEL, labelText, 85.0, 30.0, 300.0, 20.0, false, window);
    label[1] = guiCreateElement( ELEMENT_TYPE_LABEL, inputpText, 90.0, 60.0, 300.0, 20.0, false, window);
    label[2] = guiCreateElement( ELEMENT_TYPE_LABEL, inputrpText, 90.0, 90.0, 300.0, 20.0, false, window);
    label[3] = guiCreateElement( ELEMENT_TYPE_LABEL, inputEmailText, 90.0, 120.0, 300.0, 20.0, false, window);
    input[0] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 200.0, 60.0, 150.0, 20.0, false, window);
    input[1] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 200.0, 90.0, 150.0, 20.0, false, window);
    input[2] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 150.0, 120.0, 200.0, 20.0, false, window);
    button[1] = guiCreateElement( 2, buttonText ,  150.0, 150.0, 150.0, 20.0, false, window);
    langs[0] = guiCreateElement(13, "lang_en.png", screen[0]/2 - 16.0 - 20.0, screen[1]/2 + (200.0 / 2) - 20.0, 32.0, 18.0);
    langs[1] = guiCreateElement(13, "lang_ru.png", screen[0]/2 - 16.0 + 20.0, screen[1]/2 + (200.0 / 2) - 20.0, 32.0, 18.0);
    guiSetAlwaysOnTop(langs[0], true);
    guiSetAlwaysOnTop(langs[1], true);
    guiSetInputMasked( input[0], true );
    guiSetInputMasked( input[1], true );
    guiSetMovable(window,false);
    guiSetSizable(window,false);
    showCursor(true);
    // guiSetAlpha(window, 0.1);
    isAuth = false;
}
addEventHandler("showRegGUI", showRegGUI);

function destroyAuthGUI(){
    if(window){
        guiSetVisible(window,false);
        guiSetVisible(image,false);
        guiSetVisible(blackRoundFrame,false);
        guiSetVisible(langs[0],false);
        guiSetVisible(langs[1],false);

        //guiDestroyElement(window);
        //guiDestroyElement(image);

        delayedFunction(500, function() {
            showCursor(false);
        })
        blackRoundFrame = null;
        image = null;
        window = null;
    }
}
addEventHandler("destroyAuthGUI", destroyAuthGUI);

addEventHandler("changeAuthLanguage", function(lwindow, llabel, linput, lbutton, rwindow, rlabel, rinputp, rinputrp, riptemail, rbutton) {
    if (isAuth) {
        guiSetText(window, lwindow);
        guiSetText(label[0], llabel);
        guiSetText(input[0], linput);
        guiSetText(button[0], lbutton);
    } else {
        guiSetText(window, rwindow);
        guiSetText(label[0], rlabel);
        guiSetText(label[1], rinputp);
        guiSetText(label[2], rinputrp);
        guiSetText(label[3], riptemail);
        guiSetText(button[1], rbutton);
    }
});

addEventHandler( "onGuiElementClick",function(element){ //this shit need some refactor
    if(element == button[0]){
        if(isAuth) {
           buttonLoginClick();
        }
    }
    if(element == button[1]){
       buttonRegisterClick();
    }
    if(element == input[0]){
        if(isAuth) {
            guiSetText(input[0], "");
            guiSetInputMasked(input[0], true );
        }
    }
    if(element == input[2]){
        guiSetText(input[2], "");
    }

    if (element == langs[0]) {
        triggerServerEvent("onPlayerLanguageChange", "en");
    }
    if (element == langs[1]) {
        triggerServerEvent("onPlayerLanguageChange", "ru");
    }
});

/**
 * Trigger button login click
 */
function buttonLoginClick() {
    local password = guiGetText(input[0]);
    if(password.len() > 0){
        triggerServerEvent("loginGUIFunction", password);
    }
    else{
        guiSetInputMasked( input[0], false);
        guiSetText(input[0], "Пароль");
    }
}

/**
 * Trigger button register click
 */
function buttonRegisterClick() {
     if(guiGetText(input[0]) == guiGetText(input[1])){
        if(guiGetText(input[2]).len() > 0){
            if(isValidEmail(guiGetText(input[2]))){
                guiSetText(input[2], "Введён некорректный email");
            }
            else {
                local password = guiGetText(input[0]);
                local email = guiGetText(input[2]);
                triggerServerEvent("registerGUIFunction", password, email.tolower());
            }
        }
        else {
            guiSetText(label[0], "Введите ваш email адресс!");
        }
    }
}

function isValidEmail(email)
{
    local check = regexp("^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$"); //Email Validation Regex
    return check.match(email);
}

function setPlayerIntroScreen () {
    setPlayerRotation(getLocalPlayer(), 0.0, 0.0, 180.0);
}
addEventHandler("setPlayerIntroScreen",setPlayerIntroScreen);

function resetPlayerIntroScreen () {
    isAuth = null;
    showChat(true);
    delayedFunction(500, function() {
        showChat(true);
    });
}
addEventHandler("resetPlayerIntroScreen",resetPlayerIntroScreen);

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}

addEventHandler("authErrorMessage", function (errorText) {
    guiSetText(label[0], errorText);
});

addEventHandler("onClientScriptInit", function() {
    showChat(false);
});

/**
 * Handling enter key for
 * passing registraion or login
 */
addEventHandler("onServerPressEnter", function() {
    if (isAuth != null) {
        if (isAuth) {
            buttonLoginClick();
        } else {
            buttonRegisterClick();
        }
    }
});
})();
(function() {
addEventHandler("onServerClientStarted", function(version) {
    #   model       x          y           z         rot x          rot y          roy z        name        #
    local pedsArray = [
        [145,    -704.88,   1461.06,   -6.86539,       80.0,   -0.000400906,   -0.00015495, "Robert Casey"  ], // ped for truck job. Placed in Kingston under Red Bridge.
        [154,   -557.706,   1698.31,   -22.2408,    24.3432,     0.00231509,    -0.0055519, "Paulo Matti"   ], // ped on the platform on the train station
        [62,      -342.6,  -952.716,   -21.7457,    -10.052,    -0.00627452,    0.00265012, "Edgard Ross"   ], // ped near small port office on the pierce
        [52,     389.032,   128.104,   -20.2027,      135.0,    0.000657043,   -0.00108726, "Lao Chen"      ], // ped at Seagift
        [75,     169.415,  -334.993,   -20.1634,      270.0,   -0.000566336,   -0.00311189, "Oliver Parks"  ], // ped at Seagift
        [171,   -720.586,   248.261,   0.365978,    51.2061,    0.000172777,   -0.00688932, "Daniel  Burns" ], // ped at Seagift

        // [86,    -50.2636, 743.157, -17.851,     -179.49, -0.000195116, -0.000435274, "Stuart Booker"],  // ped for bookmakers office, at freddys bar
    ];

    log("creating peds");

    // for (local i = 0; i < pedsArray.len(); i++) {
    //     local pedSubArray = pedsArray[i];
    //     // dbg(pedSubArray);
    //     // dbg("createPed", pedSubArray[0], pedSubArray[1], pedSubArray[2], pedSubArray[3], pedSubArray[4], pedSubArray[5], pedSubArray[6]);
    //          createPed(  pedSubArray[0], pedSubArray[1], pedSubArray[2], pedSubArray[3], pedSubArray[4], pedSubArray[5], pedSubArray[6]);

    //     // setPedName(pedid, tmp[7]);
    // }

    log("peds created");
});
})();
(function() {
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
})();
(function() {
const ELEMENT_TYPE_BUTTON = 2;

// added check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local window;
local label;
local button;
local oldCursorState = false;

addEventHandler("onAlert", function (title, message) {
    if (!window || (window && !guiIsVisible(window))) {
        oldCursorState = isCursorShowing();
    }
    if(window){
        guiSetVisible(window,true);
        guiSetText(label, message.tostring());
    }
    else{
        window = guiCreateElement( ELEMENT_TYPE_WINDOW, title, screen[0]/2 - 100, screen[1]/2 - 50, 200.0, 100.0 );
        label = guiCreateElement( ELEMENT_TYPE_LABEL, message.tostring(), 10.0, 20.0, 300.0, 50.0, false, window);
        button = guiCreateElement( ELEMENT_TYPE_BUTTON, "OK" ,  10.0, 70, 180.0, 20.0, false, window);
    }
    if(!oldCursorState){
        showCursor(true);
    }
    guiSetMovable(window,false);
    guiSetSizable(window,false);
});

addEventHandler( "onGuiElementClick",function(element){
    if(element == button){
        guiSetText(label, "");
        guiSetVisible(window,false);
        delayedFunction(200, function() {
            showCursor(oldCursorState);
        });
    }
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}

addEventHandler( "onClientPlayerMoveStateChange", function( playerid, oldMoveState, newMoveState ){
    triggerServerEvent("updateMoveState",newMoveState);
});

/*
addEventHandler( "getClientMoveState", getMoveStatefunction(){
    local state = getPlayerMoveState(getLocalPlayer());
    return state;
});
*/
})();
(function() {
/*
 addEventHandler("setGPS",function(fx,fy) {
    removeGPSTarget();
    setGPSTarget(fx.tofloat(), fy.tofloat());
 });
*/
 addEventHandler("setGPS",function(fx,fy) {
    setGPSTarget(fx.tofloat(), fy.tofloat());
 });

 addEventHandler("removeGPS",function() {
    removeGPSTarget();
 });

 addEventHandler("hudCreateTimer", function(seconds, showed, started) {
    if( isHudTimerRunning() )
        {
            destroyHudTimer();
        }
    createHudTimer( seconds.tofloat() * 0.75, showed, started );
 });

 addEventHandler("hudDestroyTimer", function() {
    if( isHudTimerRunning() )
        {
            destroyHudTimer();
        }
 });
})();
(function() {
const MAX_INVENTORY_SLOTS = 30;
const ELEMENT_TYPE_IMAGE = 13;
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local invWindow;
local invItemImg = array(31, null);
local playerItems = {};
local labelItems = array(31, null);
local selectedSlot = -1;
local clickedSlot = -1;
local labelItemOffsetX = 46.0;
local labelItemOffsetY = 50.0;
local weight = array(3);

local invWinW = 356.0;
local invWinH = 465.0;
local invWinPosOffsetX = 0.0;
local invWinPosOffsetY = 232.5;

local charWindow;
local charItemImg = array(5, null);
local charLabelsItem = array(5, null);

local InvItemsPos =
[
    [10.0,25.0],    [78.0,25.0],    [146.0,25.0],   [214.0,25.0],   [282.0,25.0],
    [10.0,93.0],    [78.0,93.0],    [146.0,93.0],   [214.0,93.0],   [282.0,93.0],
    [10.0,161.0],   [78.0,161.0],   [146.0,161.0],  [214.0,161.0],  [282.0,161.0],
    [10.0,229.0],   [78.0,229.0],   [146.0,229.0],  [214.0,229.0],  [282.0,229.0],
    [10.0,297.0],   [78.0,297.0],   [146.0,297.0],  [214.0,297.0],  [282.0,297.0],
    [10.0,365.0],   [78.0,365.0],   [146.0,365.0],  [214.0,365.0],  [282.0,365.0]
];

/*
local CharItemsPos =
[
];
*/

addEventHandler("onServerSyncItems", function(slot,classname,amount, type, weight){  //slot, classname, amout, type
    playerItems[slot.tointeger()] <- {classname = classname, amount = amount.tointeger(), type = type};
    updateImage(slot.tointeger());
    log(format("onServerSyncItems - slot: %s, classname: %s, amount: %s, type: %s, totalweight: %s", slot, classname,amount,type,weight));
});

function Inventory () {
    if(guiIsVisible(invWindow)){
        guiSetVisible(invWindow, false);
        guiSetVisible(charWindow, false);
        showCursor(false);
    }
    else {
        guiSetPosition(invWindow,screen[0]/2, screen[1]/2 -232.5);
        guiSetSize(invWindow,356.0, 465.0);
        guiSetSizable(invWindow,false);

        guiSetPosition(charWindow,screen[0]/2  - 305.0, screen[1]/2 - 232.5);
        guiSetSize(charWindow,300.0, 465.0);
        guiSetSizable(charWindow,false);

        guiSetVisible(invWindow, true);
        guiSetVisible(charWindow, true);
        showCursor(true);
    }
}
addEventHandler("onPlayerInventorySwitch", Inventory);

function updateImage (id) {
     if(!invWindow){
        invWindow = guiCreateElement( ELEMENT_TYPE_WINDOW, "Инвентарь", 0.0, 0.0, 356.0, 465.0);
        charWindow = guiCreateElement( ELEMENT_TYPE_WINDOW, "Персонаж", 0.0, 0.0, 300.0, 465.0);

        //weight[0] = guiCreateElement( 13,"weight-bg.jpg", 10.0, 435.0, 346.0, 20.0, false, invWindow);
        //weight[1] = guiCreateElement( 13,"weight-front.jpg", 10.0, 435.0, 180.0, 20.0, false, invWindow);
        weight[0] = guiCreateElement( ELEMENT_TYPE_LABEL, "Переносимый груз 1.3/5.0 kg", 100.0, 435.0, 190.0, 20.0, false, invWindow);
       // guiSetAlwaysOnTop(weight[1], true);
        //guiSetAlwaysOnTop(weight[2], true);
        guiSetVisible(invWindow, false);
        guiSetVisible(charWindow, false);
    }
    if(invWindow){
        if(!invItemImg[id]){
            invItemImg[id] = guiCreateElement( ELEMENT_TYPE_IMAGE, playerItems[id].classname+".jpg", InvItemsPos[id][0], InvItemsPos[id][1], 64.0, 64.0, false, invWindow);
            labelItems[id] = guiCreateElement( ELEMENT_TYPE_LABEL, formatLabelText(id), InvItemsPos[id][0]+labelItemOffsetX, InvItemsPos[id][1]+labelItemOffsetY, 16.0, 15.0, false, invWindow);
            guiSetAlwaysOnTop(labelItems[id], true);
            guiSetAlpha(invItemImg[id], 0.75);
            return;
        }
        else {
            guiDestroyElement(invItemImg[id]);
            invItemImg[id] = guiCreateElement( ELEMENT_TYPE_IMAGE, playerItems[id].classname+".jpg", InvItemsPos[id][0], InvItemsPos[id][1], 64.0, 64.0, false, invWindow);
            guiSetText(labelItems[id], formatLabelText(id));
            guiSetAlpha(invItemImg[id], 0.75);
            return;
        }
    }
}


addEventHandler( "onGuiElementClick",
    function( element ){
        for(local i = 0; i < MAX_INVENTORY_SLOTS; i++){
            /*if(element == invWindow){
                if(selectedSlot != -1){
                    guiSetAlpha(invItemImg[selectedSlot], 0.8);
                    return selectedSlot = -1;
                }
            }*/
            if(element == invItemImg[i]){
               clickedSlot = i;
                if(selectedSlot != -1 && i != selectedSlot){
                    triggerServerEvent("onPlayerMoveItem", selectedSlot, clickedSlot)
                    //sendMessage("onPlayerMoveItem: selected: "+selectedSlot+ "clicked: "+clickedSlot);
                    guiSetAlpha(invItemImg[selectedSlot], 0.75);
                    return selectedSlot = -1; //reset select
                }
                if(selectedSlot != -1 && i == selectedSlot){
                    //sendMessage("DOUBLE CLICK: selected: "+selectedSlot+ "clicked: "+clickedSlot);
                    triggerServerEvent("onPlayerUseItem", selectedSlot.tostring());
                    guiSetAlpha(invItemImg[selectedSlot], 0.75);
                    return selectedSlot = -1;
                }
                if(playerItems[i].type != "ITEM_TYPE.NONE"){
                    guiSetAlpha(invItemImg[i], 1.0);
                    return selectedSlot = i;
                }
                //sendMessage("clickid: "+clickedSlot+ "selectid: "+selectedSlot+"");
            }

        }
});




function formatLabelText(slot){
    if(playerItems[slot].type == "ITEM_TYPE.NONE"){
        return "";
    }
    if(playerItems[slot].type == "ITEM_TYPE.WEAPON"){
        return playerItems[slot].amount.tostring();
    }
    if(playerItems[slot].type == "ITEM_TYPE.AMMO"){
        return playerItems[slot].amount.tostring();
    }
    if(playerItems[slot].type == "ITEM_TYPE.CLOTHES"){
        return playerItems[slot].amount.tostring();
    }
    return "";

}
})();
(function() {
local screen = getScreenSize();
local window;
local logo;
local input = array(2);
local label = array(3);
local button;
local image;


function showBankGUI(){
    window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Банковский счёт: Klo_Douglas [1000$]", screen[0]/2 - 140, screen[1]/2 - 100.0, 280.0, 200.0 );
    image = guiCreateElement(13,"", 20.0, 20.0, 250.0, 31.0, false, window);
    label[1] = guiCreateElement( ELEMENT_TYPE_LABEL, "Пополнить: ", 22.0, 60.0, 300.0, 20.0, false, window);
    label[2] = guiCreateElement( ELEMENT_TYPE_LABEL, "Снять:", 22.0, 90.0, 300.0, 20.0, false, window);
    showCursor(true);
}
addEventHandler("showBankGUI",showBankGUI)

function hideBankGUI(){
    guiSetVisivle(window,false);
    showCursor(false);
}
})();
(function() {
const ELEMENT_TYPE_BUTTON = 2;

// added check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local window;
local label;
local buttons = array(2);

/**
 * [showRentCarGUI description]
 * @param  {[string]} windowText  [description]
 * @param  {[string]} labelText   [description]
 * @param  {[string]} button1Text [description]
 * @param  {[string} button2Text  [description]
 * @return {[type]}               [description]
 */
function showRentCarGUI (windowText,labelText, button1Text, button2Text) {
    if(window){//if widow created
        guiSetSize(window, 270.0, 90.0  );
        guiSetPosition(window,screen[0]/2 - 135, screen[1]/2 - 45);
        guiSetText( window, windowText);
        guiSetText( label, labelText);
        guiSetText( buttons[0], button1Text);
        guiSetText( buttons[1], button2Text);
        guiSetVisible( window, true);
    }
    else{//if widow doesn't created, create his
        window =  guiCreateElement( ELEMENT_TYPE_WINDOW, windowText, screen[0]/2 - 135, screen[1]/2 - 45, 270.0, 90.0 );
        label = guiCreateElement( ELEMENT_TYPE_LABEL, labelText, 20.0, 20.0, 300.0, 40.0, false, window);
        buttons[0] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button1Text, 20.0, 60.0, 115.0, 20.0,false, window);
        buttons[1] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button2Text, 140.0, 60.0, 115.0, 20.0,false, window);
    }
    guiSetSizable(window,false);
    guiSetMovable(window,false);
    showCursor(true);
}
addEventHandler("showRentCarGUI",showRentCarGUI);


function hideRentCarGUI () {
    guiSetVisible(window,false);
    guiSetText( label, "");
    delayedFunction(100, hideCursor);//todo fix
}

function hideCursor() {
    showCursor(false);
}


addEventHandler( "onGuiElementClick",
    function(element)
    {
        if(element == buttons[0]){
            triggerServerEvent("RentCar");
            hideRentCarGUI();
        }
        if(element == buttons[1]){
            hideRentCarGUI();
        }
    });

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}
})();
(function() {
const ELEMENT_TYPE_BUTTON = 2;

// added check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local window;
local label = array(2);
local buttons = array(4);
local input = array(1);

/**
 * [showPhoneGUI description]
 * @param  {[string]} windowText  [description]
 * @param  {[string]} labelText   [description]
 * @param  {[string]} button1Text [description]
 * @param  {[string} button2Text  [description]
 * @return {[type]}               [description]
 */
function showPhoneGUI (windowText, label0Callto, label1insertNumber, button0Police, button1Taxi, button2Call, button3Refuse, input0exampleNumber) {
    if(window){//if widow created
        guiSetSize(window, 200.0, 250.0  );
        guiSetPosition(window,screen[0]/2 - 100, screen[1]/2 - 125);
        guiSetText( window, windowText);
        guiSetText( label[0], label0Callto);
        guiSetText( label[1], label1insertNumber);
        guiSetText( buttons[0], button0Police);
        guiSetText( buttons[1], button1Taxi);
        guiSetText( buttons[2], button2Call);
        guiSetText( buttons[3], button3Refuse);
        guiSetText( input[0], input0exampleNumber);
        guiSetVisible( window, true);
    }
    else{//if widow doesn't created, create his
        window =  guiCreateElement( ELEMENT_TYPE_WINDOW, windowText, screen[0]/2 - 100, screen[1]/2 - 125, 200.0, 250.0 );
        label[0]   = guiCreateElement(  ELEMENT_TYPE_LABEL, label0Callto,       50.0,   23.0, 150.0, 20.0, false, window);
        buttons[0] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button0Police,     15.0,   50.0, 170.0, 25.0, false, window);
        buttons[1] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button1Taxi,       15.0,   80.0, 170.0, 25.0, false, window);

        label[1]   = guiCreateElement(  ELEMENT_TYPE_LABEL, label1insertNumber, 52.0,   110.0, 120.0, 20.0, false, window);

        input[0]   = guiCreateElement(  ELEMENT_TYPE_EDIT,  input0exampleNumber,15.0,   137.0, 170.0, 22.0, false, window);
        buttons[2] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button2Call,       15.0,   165.0, 170.0, 25.0, false, window);
        buttons[3] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button3Refuse,     15.0,   208.0, 170.0, 25.0, false, window);
    }
    guiSetSizable(window,false);
    guiSetMovable(window,false);
    showCursor(true);
}
addEventHandler("showPhoneGUI",showPhoneGUI);


function hidePhoneGUI () {
    guiSetVisible(window,false);
    guiSetText( label[0], "");
    guiSetText( input[0], "555-");
    delayedFunction(100, hideCursor); //todo fix
}

function hideCursor() {
    showCursor(false);
}


addEventHandler( "onGuiElementClick",
    function(element)
    {
        if(element == buttons[0]){
            triggerServerEvent("PhoneCallGUI", "police");
            hidePhoneGUI();
        }
        if(element == buttons[1]){
            log("call taxi");
            triggerServerEvent("PhoneCallGUI", "taxi");
            hidePhoneGUI();
        }
        if(element == buttons[2]){
            local number = guiGetText(input[0]);
            triggerServerEvent("PhoneCallGUI", number);
            hidePhoneGUI();
        }
        if(element == buttons[3]){
            hidePhoneGUI();
        }
        if(element == input[0]){
            guiSetText(input[0], "555-");
        }
    });

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}
})();
