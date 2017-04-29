/**
 * ************************
 * * BASIC SETUP
 * ************************
 */

# aliases and special stuff
event   <- addEventHandler;
trigger <- triggerServerEvent;

screen  <- getScreenSize();
screenX <- screen[0].tofloat();
screenY <- screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];
centerX <- screenX * 0.5;
centerY <- screenY * 0.5;

ELEMENT_TYPE_BUTTON <- 2;
ELEMENT_TYPE_IMAGE <- 13;

const INVENTORY_INACTIVE_ALPHA = 0.65;
const INVENTORY_ACTIVE_ALPHA   = 1.0;

local storage = {};
local defaultMouseState = false;
local selectedItem = null;
local key_modifiers = {
    ctrl  = false,
    shift = false,
};
local backbone = {
    ihands = null,
};



/**
 * ************************
 * * TRANSLATIONS
 * ************************
 */

local translations = {
    "Item.None"             : "",
    "Item.Revolver12"       : "Revolver 12",
    "Item.MauserC96"        : "Mauser C96",
    "Item.ColtM1911A1"      : "Colt M1911 A1",
    "Item.ColtM1911Spec"    : "Colt M1911 Special",
    "Item.Revolver19"       : "Revolver 19",
    "Item.MK2"              : "MK2",
    "Item.Remington870"     : "Remington 870",
    "Item.M3GreaseGun"      : "MP Grease Gun",
    "Item.MP40"             : "MP-40",
    "Item.Thompson1928"     : "Thompson 1928",
    "Item.M1A1Thompson"     : "M1A1 Thompson",
    "Item.Beretta38A"       : "Beretta 38A",
    "Item.MG42"             : "MG-42",
    "Item.M1Garand"         : "M1 Grand",
    "Item.Kar98k"           : "Kar 98k",
    "Item.Molotov"          : "Molotov",
    "Item.Ammo45ACP"        : "Ammo .45 ACP",
    "Item.Ammo357magnum"    : "Ammo .357 Mangum",
    "Item.Ammo12mm"         : "Ammo 12 mm",
    "Item.Ammo9x19mm"       : "Ammo 9x19 mm",
    "Item.Ammo792x57mm"     : "Ammo 7.92x57 mm",
    "Item.Ammo762x63mm"     : "Ammo 7.62x63 mm",
    "Item.Ammo38Special"    : "Ammo .38 Special",
    "Item.Clothes"          : "Clothes",
    "Item.Burger"           : "Burger",
    "Item.Hotdog"           : "Hotdog",
    "Item.Sandwich"         : "Sandwich",
    "Item.Cola"             : "Cola",
    "Item.Jerrycan"         : "Canister",
};


/**
 * ************************
 * * FIX FOR MUTLIFORM setGuiText
 * ************************
 */

local native_guiSetText = guiSetText;
local gui_text_queue = [];

function guiSetText(handle, text) {
    gui_text_queue.push({ handle = handle, text = text});
}

function guiTextUnqueue() {
    local entry = gui_text_queue.len() ? gui_text_queue.pop() : null;

    if (entry) {
        native_guiSetText(entry.handle, entry.text);
    }
}


/**
 * ************************
 * * INVENTORY BASE CLASS
 * ************************
 */


function formatLabelText(item) {
    if (!("amount" in item)) {
        return "";
    }

    try {
        switch (item.type) {
            case "Item.None":       return "";
            case "Item.Weapon":     return item.amount.tostring();
            case "Item.Ammo":       return item.amount.tostring();
            case "Item.Clothes":    return item.amount.tostring();
        }
    }
    catch (e) {}

    return "";
}

class Inventory
{
    id      = null;
    data    = null;
    handle  = null;
    items   = null;
    opened  = false;
    components = null;
    cache   = null;

    guiTopOffset    = 20.0;
    guiBottomOffset = 20.0;
    guiRightOffset  = 0.0;
    guiPadding      = 5.0;
    guiCellSize     = 64.0;

    guiLableItemOffsetX = 48.0;
    guiLableItemOffsetY = 50.0;

    constructor(id, data) {
        this.id     = id;
        this.data   = data;
        this.items  = {};
        this.components = {};
        this.cache  = {};

        return this.createGUI();
    }

    static function isAnyOpened(objects) {
        foreach (idx, inventory in objects) {
            if (inventory.data.type == "PlayerHands") {
                continue;
            }

            if (inventory.opened) {
                return true;
            }
        }

        return false;
    }

    function createGUI() {
        local size = this.getSize();
        local posi = this.getInitialPosition();

        try {
            this.handle = guiCreateElement(ELEMENT_TYPE_WINDOW, this.data.title, posi.x, posi.y, size.x, size.y);
            this.opened = true;

            if (typeof this.handle == "userdata") {
                guiSetSizable(this.handle, false);
            }

            foreach (idx, item in this.data.items) {
                this.createItem(item.slot, item.classname, item.type, item.amount, item.weight);
            }

            local size = this.data.sizeX * this.data.sizeY;
            for (local i = 0; i < size; i++) {
                if (i in this.items) continue;

                this.createItem(i, "Item.None", "Item.None");
            }
        }
        catch (e) { log(e) }
    }

    function updateGUI(data) {
        local find = function(haystack, needed) {
            foreach (idx, value in haystack) {
                if (value.slot == needed) return value;
            }
            return null;
        };

        foreach (slot, item in this.items) {
            local matched = find(data.items, slot);

            // slot now supposed to be empty
            // we should remove this slot
            // and replace with empty one
            if (!matched && item.classname != "Item.None") {
                this.cacheItem(item);
                this.createItem(slot, "Item.None", "Item.None");
                continue;
            }

            // slot now should change image
            // to one from cache, or create one
            // and put old to cache
            if (matched && matched.classname != item.classname) {
                this.cacheItem(item);
                this.createItem(slot, matched.classname, matched.type, matched.amount, matched.weight);
                continue;
            }

            // items are same, but different amount
            // only need to change text on picture
            if (matched && matched.classname == item.classname && matched.amount != item.amount) {
                item.amount = matched.amount;
                item.weight = matched.weight;
                // guiSetText(item.label, formatLabelText(item));
                continue;
            }

            // do nothing
            // items are purely identical
        }
    }

    function createItem(slot, classname, type, amount = 0, weight = 0.0, outside_form = false) {
        local item = { classname = classname, type = type, slot = slot, amount = amount, weight = weight, handle = null, label = null, active = false, parent = this };
        local pos  = this.getItemPosition(item);

        try {
            // do we have new item in cached
            if (item.classname in this.cache && this.cache[item.classname].len()) {
                local itemOld = this.cache[item.classname].pop();

                item.handle = itemOld.handle;
                item.label  = itemOld.label;

                guiSetPosition(item.handle, pos.x, pos.y, false);
                // guiSetPosition(item.label,  pos.x + this.guiLableItemOffsetX, pos.y + this.guiLableItemOffsetY, false);
                guiSetVisible(item.handle, true);
                // guiSetVisible(item.label,  true);

                // guiSetText(item.label, formatLabelText(item));
            } else {
                if (outside_form) {
                    item.handle <- guiCreateElement( ELEMENT_TYPE_IMAGE, item.classname + ".jpg", pos.x, pos.y, this.guiCellSize, this.guiCellSize);
                    // item.label  <- guiCreateElement( ELEMENT_TYPE_LABEL, formatLabelText(item), pos.x + this.guiLableItemOffsetX,
                    //     pos.y + this.guiLableItemOffsetY, 16.0, 15.0
                    // );
                }
                else {
                    item.handle <- guiCreateElement( ELEMENT_TYPE_IMAGE, item.classname + ".jpg", pos.x, pos.y, this.guiCellSize, this.guiCellSize, false, this.handle);
                    // item.label  <- guiCreateElement( ELEMENT_TYPE_LABEL, formatLabelText(item), pos.x + this.guiLableItemOffsetX,
                    //     pos.y + this.guiLableItemOffsetY, 16.0, 15.0, false, this.handle
                    // );
                }
            }

            if ("handle" in item && typeof item.handle == "userdata" && typeof item.label == "userdata") {
                // guiSetAlpha(item.handle, 0.75);
                // guiSetAlwaysOnTop(item.label, true);
            }
        }
        catch (e) { log(e); }
        this.items[item.slot] <- item;
    }

    /**
     * Hiding old
     */
    function cacheItem(item) {
        if (item.handle && typeof item.handle == "userdata") {
            // disable drawing of this cell
            guiSetVisible(item.handle, false);
            // guiSetVisible(item.label,  false);
            guiSetPosition(item.handle, -this.guiCellSize, -this.guiCellSize, false);
            // guiSetPosition(item.label,  -this.guiCellSize, -this.guiCellSize, false);
        }

        // create cache if doent exsits
        if (!(item.classname in this.cache)) {
            this.cache[item.classname] <- [];
        }

        // store gui handle in cache, to reuse it later
        this.cache[item.classname].push(item);
        // this.items[item.slot]// ???
    }

    function getInitialPosition() {
        local size = this.getSize();
        return { x = centerX - size.x / 2, y = centerY - size.y / 2 };
    }

    function getSize() {
        return {
            x = ((this.data.sizeX * (this.guiCellSize + this.guiPadding)) + this.guiPadding * 2).tofloat() + this.guiRightOffset + 2,
            y = ((this.data.sizeY * (this.guiCellSize + this.guiPadding)) + this.guiPadding * 2).tofloat() + this.guiTopOffset + 2 + this.guiBottomOffset,
        };
    }

    function getItemPosition(item) {
        return {
            x = this.guiPadding + (floor(item.slot % this.data.sizeX) * (this.guiCellSize + this.guiPadding)) + 4,
            y = this.guiPadding + (floor(item.slot / this.data.sizeX) * (this.guiCellSize + this.guiPadding)) + this.guiTopOffset + 2,
        };
    }

    function show() {
        guiSetVisible(this.handle, true);
        guiBringToFront(this.handle);
        this.opened = true;
    }

    function hide() {
        guiSetVisible(this.handle, false);
        this.opened = false;
    }

    function click(item) {
        if (!item.active) {
            if (selectedItem) {
                // toggling item move
                trigger("inventory:move", selectedItem.parent.id, selectedItem.slot, item.parent.id, item.slot);

                // guiSetAlpha(selectedItem.handle, INVENTORY_INACTIVE_ALPHA);
                selectedItem.active = false;
                selectedItem = null;
            } else {
                if (item.classname == "Item.None") return;

                // drop if ctrl
                if (key_modifiers.ctrl) {
                    return trigger("inventory:drop", item.parent.id, item.slot);
                }

                // try to move to hands
                // if (key_modifiers.shift) {
                //     return trigger("inventory:move", item.parent.id, item.slot, backbone["ihands"].id, 0);
                // }

                // select item
                // guiSetAlpha(item.handle, INVENTORY_ACTIVE_ALPHA);
                selectedItem = item;
                item.active = true;
            }
        } else {
            // deselect item
            selectedItem = null;
            item.active = false;
            // guiSetAlpha(item.handle, INVENTORY_INACTIVE_ALPHA);
        }
    }

    function rawclick(element) {

    }
}



/**
 * ************************
 * * PLAYER INVENTORY CLASS
 * ************************
 */

class PlayerInventory extends Inventory
{
    guiRightOffset = 135.0;

    function getInitialPosition() {
        local size = this.getSize();
        return { x = centerX + 5.0, y = centerY - size.y / 2 };
    }

    function addComponent(type, props, yoffset, title) {
        local size = this.getSize();
        local y = this.guiTopOffset + ((this.guiPadding + props.height) * yoffset);

        if (yoffset < 0) {
            y = size.y + ((this.guiPadding + props.height) * yoffset) - 3;
        }

        return guiCreateElement(type, title
            size.x - this.guiPadding * 2 - props.width, y,
            props.width, props.height, false, this.handle
        );
    }

    function createGUI() {
        base.createGUI();

        if (typeof this.handle == "userdata") {
            guiSetAlwaysOnTop(this.handle, true);
            guiSetMovable(this.handle, false);
        }

        local props = {
            width  = 125.0,
            height = 30.0,
        };

        // buttons
        this.components["lbl_name"] <- this.addComponent(ELEMENT_TYPE_LABEL,  props,  0, "");
        this.components["btn_use"]  <- this.addComponent(ELEMENT_TYPE_BUTTON, props, -3, "Использовать");
        this.components["btn_hand"] <- this.addComponent(ELEMENT_TYPE_BUTTON, props, -2, "Взять в руку");
        this.components["btn_drop"] <- this.addComponent(ELEMENT_TYPE_BUTTON, props, -1, "Бросить на землю");
    }

    function click(item) {
        base.click(item);

        if (item.classname == "Item.None") {
            guiSetText(this.components["lbl_name"], "");
        }

        if (item.active) {
            if (item.classname in translations) {
                guiSetText(this.components["lbl_name"], translations[item.classname]);
            }
            else {
                guiSetText(this.components["lbl_name"], item.classname);
            }
        }
        else {
            guiSetText(this.components["lbl_name"], "");
        }
    }

    function rawclick(element) {
        foreach (idx, value in this.components) {
            if (element != value) {
                continue;
            }

            if (idx == "btn_hand" && backbone["ihands"]) {
                guiSetText(this.components["lbl_name"], "");
                backbone["ihands"].click(backbone["ihands"].items[0]);
                return true;
            }

            if (idx == "btn_use" && selectedItem) {
                guiSetText(this.components["lbl_name"], "");
                selectedItem.active = false;
                trigger("inventory:use", selectedItem.parent.id, selectedItem.slot);
                selectedItem = null;
                return true;
            }

            if (idx == "btn_drop" && selectedItem) {
                guiSetText(this.components["lbl_name"], "");
                selectedItem.active = false;
                trigger("inventory:drop", selectedItem.parent.id, selectedItem.slot);
                selectedItem = null;
                return true;
            }
        }

        // drop item via clicking outside screen
        if (element == backbone["window"] && selectedItem) {
            guiSetText(this.components["lbl_name"], "");
            selectedItem.active = false;
            trigger("inventory:drop", selectedItem.parent.id, selectedItem.slot);
            selectedItem = null;
            return true;
        }

        return false;
    }
}


/**
 * ************************
 * * PLAYER HANDS CLASS
 * ************************
 */

class PlayerHands extends Inventory
{
    function getSize() {
        return { x = 72.0, y = 128.0 };
    }

    function getItemPosition(item) {
        return { x = 8.0, y = screenY - 72.0 };
    }

    function getInitialPosition() {
        return { x = -screenX, y = -screenY };
    }

    function createGUI() {
        base.createGUI();
        guiSetAlpha(this.handle, 0.0);
        guiSetAlwaysOnTop(this.items[0].handle, true);
        // guiSetAlwaysOnTop(this.items[0].label, true);
        backbone["ihands"] = this;
    }

    function createItem(slot, classname, type, amount = 0, weight = 0.0) {
        return base.createItem(slot, classname, type, amount, weight, true);
    }

    function hide() {
        guiSetVisible(this.items[0].handle, false);
        this.opened = false;
    }

    function show() {
        guiSetVisible(this.items[0].handle, true);
        guiBringToFront(this.items[0].handle);
        this.opened = true;
    }
}


/**
 * ************************
 * * INVENTORY INTERACTIONS
 * ************************
 */

local class_map = {
    Inventory       = Inventory,
    PlayerInventory = PlayerInventory,
    PlayerHands     = PlayerHands,
};


event("onClientFrameRender", function(afterGUI) {
    if (!afterGUI) {
        return drawWorldGround();
    }

    local upd = guiTextUnqueue();
    local drawed = false;

    foreach (idx, inventory in storage) {
        if (!inventory.opened) continue;

        local items  = clone(inventory.items);              if (typeof items != "table") return;
        local window = guiGetPosition(inventory.handle);    if (typeof window != "array" || window.len() != 2) return;
        local weight = 0.0;
        local size   = inventory.getSize();                 if (typeof size != "table") return;

        foreach (idx, item in items) {
            weight += item.weight;

            if (!item.active) continue;

            local pos = inventory.getItemPosition(item);    if (typeof pos != "table") return;

            if (inventory.data.type != "PlayerHands") {
                pos.x += window[0];
                pos.y += window[1];
            }

            dxDrawRectangle(pos.x, pos.y, inventory.guiCellSize, inventory.guiCellSize, 0x61AF8E4D);
        }

        if (inventory.data.type == "PlayerHands") continue;

        local coef = (weight / inventory.data.limit);       if (typeof coef != "float") return;
        local invwidth = size.x - inventory.guiPadding * 2 - inventory.guiRightOffset - 7;
        local width = invwidth * (coef > 1.0 ? 1.0 : coef);

        dxDrawRectangle(window[0].tofloat() + inventory.guiPadding + 4, window[1] + size.y - inventory.guiBottomOffset - 3, invwidth, 15.0, 0xFF242522);
        dxDrawRectangle(window[0].tofloat() + inventory.guiPadding + 4, window[1] + size.y - inventory.guiBottomOffset - 3, width, 15.0, 0xFFAF8E4D);

        drawed = true;

        // dxDrawText();
    }

    // if (drawed) {
    //     local text   = "Hold left shift to select multiple items.";
    //     local offset = dxGetTextDimensions(text, 2.0, "tahoma-bold")[1];
    //     dxDrawText(text, 125.0, screenY - offset - 25.0, 0xAAFFFFFF, false, "tahoma-bold", 2.0);
    // }
});

event("inventory:onServerOpen", function(id, incoming_data) {
    local data = compilestring.call(getroottable(), format("return %s", incoming_data))();

    if (data.type != "PlayerHands") {
        if (!Inventory.isAnyOpened(storage)) {
            defaultMouseState = isCursorShowing();
            showCursor(true);
        }
    }

    if (!(id in storage)) {
        if (data.type in class_map) {
            storage[id] <- class_map[data.type](id, data);
        }
        else {
            storage[id] <- Inventory(id, data);
        }
    } else {
        storage[id].updateGUI(data);
        storage[id].show();
    }
});

event("inventory:onServerClose", function(id) {
    if (id in storage) {
        storage[id].hide();
    }

    if (!Inventory.isAnyOpened(storage)) {
        showCursor(defaultMouseState);
    }
});

event("onGuiElementClick", function(element) {
    foreach (idx, inventory in storage) {
        if (!inventory.opened) continue;

        foreach (idx, item in inventory.items) {
            if (element == item.handle) {// || element == item.label) {
                return inventory.click(item);
            }

            if (inventory.rawclick(element)) {
                return;
            }
        }
    }

    guiSendToBack(backbone["bhands"]);
    guiSendToBack(backbone["window"]);
});

event("onServerKeyboard", function(key, state) {
    key_modifiers[key] <- (state == "down");
});


/**
 * ************************
 * * WORLD GROUND
 * ************************
 */

local ground = {
    textures = {},
    current  = [],
    distance = 15.0,
    maxamt   = 100,
    alpha    = 165,
};

event("inventory:onServerGroundSync", function(incoming_data) {
    ground.current.extend(compilestring.call(getroottable(), format("return %s", incoming_data), "ground_push")().items);
});

event("inventory:onServerGroundPush", function(incoming_data) {
    ground.current.push(compilestring.call(getroottable(), format("return %s", incoming_data), "ground_push")());
});

event("inventory:onServerGroundRemove", function(incoming_data) {
    local item = compilestring.call(getroottable(), format("return %s", incoming_data), "ground_push")();

    ground.current = ground.current.filter(function(i, element) {
        return (element.id != item.id);
    });
});

function getGroundTexture(key) {
    local name = key + ".jpg";

    if (name in ground.textures) {
        return ground.textures[name];
    }

    ground.textures[name] <- dxLoadTexture(name);
    return ground.textures[name];
}

function drawWorldGround() {
    local playerid = getLocalPlayer();                              if (typeof playerid != "integer" || playerid > 1000 || playerid < 0) return;
    local curpos = getPlayerPosition(playerid);                     if (typeof curpos != "array" || curpos.len() != 3) return;
    local pos    = { x = curpos[0], y = curpos[1], z = curpos[2] }; if (typeof pos != "table" || pos.len() != 3) return;
    local radius = ground.distance;                                 if (typeof radius != "float") return;
    local nearitem = false;

    local items = ground.current.filter(function(i, item) {
        return (
            ("x" in item) && (item.x != 0.0 || item.y != 0.0 || item.z != 0.0)
            && (abs(pos.x - item.x) < radius) && (abs(pos.y - item.y) < radius) && (abs(pos.z - item.z) < radius)
        );
    });

    if (typeof items != "array") return;

    // lastest should be the newest items
    // items.reverse();

    local get_dist = function(item) {
        return pow(item.x - pos.x, 2) + pow(item.y - pos.y, 2);
    };

    // limit amount of drawing items
    if (items.len() > ground.maxamt) {
        // items = items.slice(0, ground.maxamt);
        items.sort(@(a, b) get_dist(a) <=> get_dist(b));
        items = items.slice(0, ground.maxamt);
    }

    if (typeof items != "array") return;
    if (typeof ground.alpha != "integer") return;

    // draw them !
    items.map(function(item) {
        local item_texture  = getGroundTexture(item.classname);           if (typeof item_texture != "userdata") return;
        local item_screen   = getScreenFromWorld(item.x.tofloat(), item.y.tofloat(), item.z.tofloat()); if (typeof item_screen != "array" || item_screen.len() != 3) return;
        local item_distance = getDistanceBetweenPoints3D(item.x.tofloat(), item.y.tofloat(), item.z.tofloat(), pos.x, pos.y, pos.z); if (typeof item_distance != "float") return;

        if (item_distance < ground.distance && item_screen[2] < 1.0) {
            local scale = 1 - (((item_distance > ground.distance) ? ground.distance : item_distance) / ground.distance);
            dxDrawTexture(item_texture, item_screen[0].tofloat(), item_screen[1].tofloat(), scale.tofloat(), scale.tofloat(), 0.5, 0.5, 0.0, ground.alpha);
        }

        if (item_distance < 1.0) {
            nearitem = true;
        }
    });

    if (nearitem) {
        local text   = "Press E to pick up item.";
        local offset = dxGetTextDimensions(text, 2.0, "tahoma-bold")[1];
        dxDrawText(text, 125.0, screenY - offset - 25.0, 0xAAFFFFFF, false, "tahoma-bold", 2.0);
    }
}



/**
 * ************************
 * * LIBRARIES
 * ************************
 */


// dbg <- function(...) {
//     // log(JSONEncoder.encode(concat(vargv)));
// }

// dbgc <- function(...) {
//     // sendMessage(JSONEncoder.encode(concat(vargv)));
// };


function concat(vars, symbol = " ") {
    return vars.reduce(function(carry, item) {
        return item ? carry + symbol + item : "";
    });
}

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}

function random(min = 0, max = RAND_MAX) {
    return (rand() % ((max + 1) - min)) + min;
}


function randomf(min = 0.0, max = RAND_MAX) {
    return (rand() % (max - min + 0.001)) + min;
}

function min(a, b) {
    return a > b ? b : a;
}


addEventHandler("onServerClientStarted", function(version = null) {
// delayedFunction(1, function(version = null) {
    // backbone["ihands"] <- null;
    backbone["window"] <- guiCreateElement( ELEMENT_TYPE_WINDOW, "", 0.0, 0.0, screenX, screenY);
    backbone["bhands"] <- guiCreateElement( ELEMENT_TYPE_IMAGE, "ui_inv_hands.png", 0.0, screenY - 108.0, 108.0, 108.0);
    // backbone["fhands"] <- guiCreateElement( ELEMENT_TYPE_IMAGE, "Item.None.jpg", 0.0, screenY - 64.0, 64.0, 64.0);

    guiSetAlpha(backbone["window"], 0.0);
    guiSetAlpha(backbone["bhands"], 0.6);

    guiSetSizable(backbone["window"], false);
    guiSetMovable(backbone["window"], false);

    trigger("inventory:loaded");

    sendMessage("my screen: %f %f", screenX.tofloat(), screenY.tofloat());
});


//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
//aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
