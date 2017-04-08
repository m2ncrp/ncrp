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

    static function formatLabelText(item) {
        if (!("amount" in item)) {
            return "";
        }

        switch (item.type) {
            case "Item.None":       return "";
            case "Item.Weapon":     return item.amount.tostring();
            case "Item.Ammo":       return item.amount.tostring();
            case "Item.Clothes":    return item.amount.tostring();
        }

        return "";
    }

    function createGUI() {
        local size = this.getSize();
        local posi = this.getInitialPosition();

        this.handle = guiCreateElement(ELEMENT_TYPE_WINDOW, this.data.title, posi.x, posi.y, size.x, size.y);
        this.opened = true;

        guiSetSizable(this.handle, false);

        foreach (idx, item in this.data.items) {
            this.createItem(item.slot, item.classname, item.type, item.amount, item.weight);
        }

        local size = this.data.sizeX * this.data.sizeY;
        for (local i = 0; i < size; i++) {
            if (i in this.items) continue;

            this.createItem(i, "Item.None", "Item.None");
        }
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
                guiSetText(item.label, Inventory.formatLabelText(item));
                continue;
            }

            // do nothing
            // items are purely identical
        }
    }

    function createItem(slot, classname, type, amount = 0, weight = 0.0, outside_form = false) {
        local item = { classname = classname, type = type, slot = slot, amount = amount, weight = weight, handle = null, label = null, active = false, parent = this };
        local pos  = this.getItemPosition(item);

        // do we have new item in cached
        if (item.classname in this.cache && this.cache[item.classname].len()) {
            local itemOld = this.cache[item.classname].pop();

            item.handle = itemOld.handle;
            item.label  = itemOld.label;

            guiSetPosition(item.handle, pos.x, pos.y, false);
            guiSetPosition(item.label,  pos.x + this.guiLableItemOffsetX, pos.y + this.guiLableItemOffsetY, false);
            guiSetVisible(item.handle, true);
            guiSetVisible(item.label,  true);

            guiSetText(item.label, this.formatLabelText(item));
        } else {
            if (outside_form) {
                item.handle <- guiCreateElement( ELEMENT_TYPE_IMAGE, item.classname + ".jpg", pos.x, pos.y, this.guiCellSize, this.guiCellSize);
                item.label  <- guiCreateElement( ELEMENT_TYPE_LABEL, this.formatLabelText(item), pos.x + this.guiLableItemOffsetX,
                    pos.y + this.guiLableItemOffsetY, 16.0, 15.0
                );
            }
            else {
                item.handle <- guiCreateElement( ELEMENT_TYPE_IMAGE, item.classname + ".jpg", pos.x, pos.y, this.guiCellSize, this.guiCellSize, false, this.handle);
                item.label  <- guiCreateElement( ELEMENT_TYPE_LABEL, this.formatLabelText(item), pos.x + this.guiLableItemOffsetX,
                    pos.y + this.guiLableItemOffsetY, 16.0, 15.0, false, this.handle
                );
            }
        }

        if ("handle" in item) {
            guiSetAlpha(item.handle, 0.75);
            guiSetAlwaysOnTop(item.label, true);
        }

        this.items[item.slot] <- item;
    }

    /**
     * Hiding old
     */
    function cacheItem(item) {
        // disable drawing of this cell
        guiSetVisible(item.handle, false);
        guiSetVisible(item.label,  false);
        guiSetPosition(item.handle, -this.guiCellSize, -this.guiCellSize, false);
        guiSetPosition(item.label,  -this.guiCellSize, -this.guiCellSize, false);

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
                trigger("onPlayerMoveItem", selectedItem.parent.id, selectedItem.slot, item.parent.id, item.slot);

                guiSetAlpha(selectedItem.handle, INVENTORY_INACTIVE_ALPHA);
                selectedItem.active = false;
                selectedItem = null;
            } else {
                if (item.classname == "Item.None") return;

                // drop if shift
                if (key_modifiers.ctrl) {
                    return trigger("onPlayerDropItem", item.parent.id, item.slot);
                }

                // try to move to hands
                if (key_modifiers.shift) {
                    return trigger("onPlayerMoveItem", item.parent.id, item.slot, backbone["ihands"].id, 0);
                }

                // select item
                guiSetAlpha(item.handle, INVENTORY_ACTIVE_ALPHA);
                selectedItem = item;
                item.active = true;
            }
        } else {
            // deselect item
            selectedItem = null;
            item.active = false;
            guiSetAlpha(item.handle, INVENTORY_INACTIVE_ALPHA);
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

        guiSetAlwaysOnTop(this.handle, true);
        guiSetMovable(this.handle, false);

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
            guiSetText(this.components["lbl_name"], item.classname);
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
                backbone["ihands"].click(backbone["ihands"].items[0]);
                return true;
            }

            if (idx == "btn_use" && selectedItem) {
                selectedItem.active = false;
                trigger("onPlayerUseItem", selectedItem.parent.id, selectedItem.slot);
                selectedItem = null;
                return true;
            }

            if (idx == "btn_drop" && selectedItem) {
                selectedItem.active = false;
                trigger("onPlayerDropItem", selectedItem.parent.id, selectedItem.slot);
                selectedItem = null;
                return true;
            }
        }

        // drop item via clicking outside screen
        if (element == backbone["window"] && selectedItem) {
            selectedItem.active = false;
            trigger("onPlayerDropItem", selectedItem.parent.id, selectedItem.slot);
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
        guiSetAlwaysOnTop(this.items[0].label, true);
        backbone["ihands"] = this;
    }

    function createItem(slot, classname, type, amount = 0, weight = 0.0) {
        return base.createItem(slot, classname, type, amount, weight, true);
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


addEventHandler("onServerClientStarted", function(version = null) {
    // backbone["ihands"] <- null;
    backbone["window"] <- guiCreateElement( ELEMENT_TYPE_WINDOW, "", 0.0, 0.0, screenX, screenY);
    backbone["bhands"] <- guiCreateElement( ELEMENT_TYPE_IMAGE, "ui_inv_hands.png", 0.0, screenY - 108.0, 108.0, 108.0);
    // backbone["fhands"] <- guiCreateElement( ELEMENT_TYPE_IMAGE, "Item.None.jpg", 0.0, screenY - 64.0, 64.0, 64.0);

    guiSetAlpha(backbone["window"], 0.0);
    guiSetAlpha(backbone["bhands"], 0.6);

    guiSetSizable(backbone["window"], false);
    guiSetMovable(backbone["window"], false);
});


event("onClientFrameRender", function(afterGUI) {
    if (!afterGUI) {
        return drawWorldGround();
    }

    local upd = guiTextUnqueue();
    local drawed = false;

    foreach (idx, inventory in storage) {
        if (!inventory.opened) continue;

        local items  = clone(inventory.items);
        local window = guiGetPosition(inventory.handle);
        local weight = 0.0;
        local size   = inventory.getSize();

        foreach (idx, item in items) {
            weight += item.weight;

            if (!item.active) continue;

            local pos = inventory.getItemPosition(item);

            if (inventory.data.type != "PlayerHands") {
                pos.x += window[0];
                pos.y += window[1];
            }

            dxDrawRectangle(pos.x, pos.y, inventory.guiCellSize, inventory.guiCellSize, 0x61AF8E4D);
        }

        if (inventory.data.type == "PlayerHands") continue;

        local coef  = (weight / inventory.data.limit);
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

event("inventory:onServerOpen", function(id, data) {
    local data = JSONParser.parse(data);

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
            if (element == item.handle || element == item.label) {
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
    maxamt   = 25,
    alpha    = 165,
};

event("inventory:onServerGroundSync", function(incoming_data) {
    ground.current.extend(JSONParser.parse(incoming_data).items);
});

event("inventory:onServerGroundPush", function(incoming_data) {
    ground.current.push(JSONParser.parse(incoming_data));
});

event("inventory:onServerGroundRemove", function(incoming_data) {
    local item = JSONParser.parse(incoming_data);

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
    local curpos = getPlayerPosition(getLocalPlayer());
    local pos    = { x = curpos[0], y = curpos[1], z = curpos[2] };
    local radius = ground.distance;
    local nearitem = false;

    local items = ground.current.filter(function(i, item) {
        return (
            ("x" in item) && (item.x != 0.0 || item.y != 0.0 || item.z != 0.0)
            && (abs(pos.x - item.x) < radius) && (abs(pos.y - item.y) < radius) && (abs(pos.z - item.z) < radius)
        );
    });

    // lastest should be the newest items
    items.reverse();

    // limit amount of drawing items
    if (items.len() > ground.maxamt) {
        items = items.slice(0, ground.maxamt);
    }

    // draw them !
    items.map(function(item) {
        local item_texture  = getGroundTexture(item.classname);
        local item_screen   = getScreenFromWorld(item.x, item.y, item.z);
        local item_distance = getDistanceBetweenPoints3D(item.x, item.y, item.z, pos.x, pos.y, pos.z);

        if (item_distance < ground.distance) {
            local scale = 1 - (((item_distance > ground.distance) ? ground.distance : item_distance) / ground.distance);
            dxDrawTexture(item_texture, item_screen[0], item_screen[1], scale, scale, 0.5, 0.5, 0.0, ground.alpha);
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


dbg <- function(...) {
    log(JSONEncoder.encode(concat(vargv)));
}

dbgc <- function(...) {
    sendMessage(JSONEncoder.encode(concat(vargv)));
};


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



/**
 * JSON Parser
 *
 * @author Mikhail Yurasov <mikhail@electricimp.com>
 * @package JSONParser
 * @version 0.3.1
 */

/**
 * JSON Parser
 * @package JSONParser
 */
class JSONParser {

    // should be the same for all components within JSONParser package
    static version = [1, 0, 0];

    /**
     * Parse JSON string into data structure
     *
     * @param {string} str
     * @param {function({string} value[, "number"|"string"])|null} converter
     * @return {*}
     */
    function parse(str, converter = null) {

        local state;
        local stack = []
        local container;
        local key;
        local value;

        // actions for string tokens
        local string = {
            go = function () {
                state = "ok";
            },
            firstokey = function () {
                key = value;
                state = "colon";
            },
            okey = function () {
                key = value;
                state = "colon";
            },
            ovalue = function () {
                value = this._convert(value, "string", converter);
                state = "ocomma";
            }.bindenv(this),
            firstavalue = function () {
                value = this._convert(value, "string", converter);
                state = "acomma";
            }.bindenv(this),
            avalue = function () {
                value = this._convert(value, "string", converter);
                state = "acomma";
            }.bindenv(this)
        };

        // the actions for number tokens
        local number = {
            go = function () {
                state = "ok";
            },
            ovalue = function () {
                value = this._convert(value, "number", converter);
                state = "ocomma";
            }.bindenv(this),
            firstavalue = function () {
                value = this._convert(value, "number", converter);
                state = "acomma";
            }.bindenv(this),
            avalue = function () {
                value = this._convert(value, "number", converter);
                state = "acomma";
            }.bindenv(this)
        };

        // action table
        // describes where the state machine will go from each given state
        local action = {

            "{": {
                go = function () {
                    stack.push({state = "ok"});
                    container = {};
                    state = "firstokey";
                },
                ovalue = function () {
                    stack.push({container = container, state = "ocomma", key = key});
                    container = {};
                    state = "firstokey";
                },
                firstavalue = function () {
                    stack.push({container = container, state = "acomma"});
                    container = {};
                    state = "firstokey";
                },
                avalue = function () {
                    stack.push({container = container, state = "acomma"});
                    container = {};
                    state = "firstokey";
                }
            },

            "}" : {
                firstokey = function () {
                    local pop = stack.pop();
                    value = container;
                    container = ("container" in pop) ? pop.container : null;
                    key = ("key" in pop) ? pop.key : null;
                    state = pop.state;
                },
                ocomma = function () {
                    local pop = stack.pop();
                    container[key] <- value;
                    value = container;
                    container = ("container" in pop) ? pop.container : null;
                    key = ("key" in pop) ? pop.key : null;
                    state = pop.state;
                }
            },

            "[" : {
                go = function () {
                    stack.push({state = "ok"});
                    container = [];
                    state = "firstavalue";
                },
                ovalue = function () {
                    stack.push({container = container, state = "ocomma", key = key});
                    container = [];
                    state = "firstavalue";
                },
                firstavalue = function () {
                    stack.push({container = container, state = "acomma"});
                    container = [];
                    state = "firstavalue";
                },
                avalue = function () {
                    stack.push({container = container, state = "acomma"});
                    container = [];
                    state = "firstavalue";
                }
            },

            "]" : {
                firstavalue = function () {
                    local pop = stack.pop();
                    value = container;
                    container = ("container" in pop) ? pop.container : null;
                    key = ("key" in pop) ? pop.key : null;
                    state = pop.state;
                },
                acomma = function () {
                    local pop = stack.pop();
                    container.push(value);
                    value = container;
                    container = ("container" in pop) ? pop.container : null;
                    key = ("key" in pop) ? pop.key : null;
                    state = pop.state;
                }
            },

            ":" : {
                colon = function () {
                    // check if the key already exists
                    if (key in container) {
                        throw "Duplicate key \"" + key + "\"";
                    }
                    state = "ovalue";
                }
            },

            "," : {
                ocomma = function () {
                    container[key] <- value;
                    state = "okey";
                },
                acomma = function () {
                    container.push(value);
                    state = "avalue";
                }
            },

            "true" : {
                go = function () {
                    value = true;
                    state = "ok";
                },
                ovalue = function () {
                    value = true;
                    state = "ocomma";
                },
                firstavalue = function () {
                    value = true;
                    state = "acomma";
                },
                avalue = function () {
                    value = true;
                    state = "acomma";
                }
            },

            "false" : {
                go = function () {
                    value = false;
                    state = "ok";
                },
                ovalue = function () {
                    value = false;
                    state = "ocomma";
                },
                firstavalue = function () {
                    value = false;
                    state = "acomma";
                },
                avalue = function () {
                    value = false;
                    state = "acomma";
                }
            },

            "null" : {
                go = function () {
                    value = null;
                    state = "ok";
                },
                ovalue = function () {
                    value = null;
                    state = "ocomma";
                },
                firstavalue = function () {
                    value = null;
                    state = "acomma";
                },
                avalue = function () {
                    value = null;
                    state = "acomma";
                }
            }
        };

        //

        state = "go";
        stack = [];

        // current tokenizeing position
        local start = 0;

        try {

            local
                result,
                token,
                tokenizer = _JSONTokenizer();

            while (token = tokenizer.nextToken(str, start)) {

                if ("ptfn" == token.type) {
                    // punctuation/true/false/null
                    action[token.value][state]();
                } else if ("number" == token.type) {
                    // number
                    value = token.value;
                    number[state]();
                } else if ("string" == token.type) {
                    // string
                    value = tokenizer.unescape(token.value);
                    string[state]();
                }

                start += token.length;
            }

        } catch (e) {
            state = e;
        }

        // check is the final state is not ok
        // or if there is somethign left in the str
        if (state != "ok" || regexp("[^\\s]").capture(str, start)) {
            local min = @(a, b) a < b ? a : b;
            local near = str.slice(start, min(str.len(), start + 10));
            throw "JSON Syntax Error near `" + near + "`";
        }

        return value;
    }

    /**
     * Convert strings/numbers
     * Uses custom converter function
     *
     * @param {string} value
     * @param {string} type
     * @param {function|null} converter
     */
    function _convert(value, type, converter) {
        if ("function" == typeof converter) {

            // # of params for converter function

            local parametercCount = 2;

            // .getinfos() is missing on ei platform
            if ("getinfos" in converter) {
                parametercCount = converter.getinfos().parameters.len()
                    - 1 /* "this" is also included */;
            }

            if (parametercCount == 1) {
                return converter(value);
            } else if (parametercCount == 2) {
                return converter(value, type);
            } else {
                throw "Error: converter function must take 1 or 2 parameters"
            }

        } else if ("number" == type) {
            return (value.find(".") == null && value.find("e") == null && value.find("E") == null) ? value.tointeger() : value.tofloat();
        } else {
            return value;
        }
    }
}

/**
 * JSON Tokenizer
 * @package JSONParser
 */
class _JSONTokenizer {

    _ptfnRegex = null;
    _numberRegex = null;
    _stringRegex = null;
    _ltrimRegex = null;
    _unescapeRegex = null;

    constructor() {
        // punctuation/true/false/null
        this._ptfnRegex = regexp("^(?:\\,|\\:|\\[|\\]|\\{|\\}|true|false|null)");

        // numbers
        this._numberRegex = regexp("^(?:\\-?\\d+(?:\\.\\d*)?(?:[eE][+\\-]?\\d+)?)");

        // strings
        this._stringRegex = regexp("^(?:\\\"((?:[^\\r\\n\\t\\\\\\\"]|\\\\(?:[\"\\\\\\/trnfb]|u[0-9a-fA-F]{4}))*)\\\")");

        // ltrim pattern
        this._ltrimRegex = regexp("^[\\s\\t\\n\\r]*");

        // string unescaper tokenizer pattern
        this._unescapeRegex = regexp("\\\\(?:(?:u\\d{4})|[\\\"\\\\/bfnrt])");
    }

    /**
     * Get next available token
     * @param {string} str
     * @param {integer} start
     * @return {{type,value,length}|null}
     */
    function nextToken(str, start = 0) {

        local
            m,
            type,
            token,
            value,
            length,
            whitespaces;

        // count # of left-side whitespace chars
        whitespaces = this._leadingWhitespaces(str, start);
        start += whitespaces;

        if (m = this._ptfnRegex.capture(str, start)) {
            // punctuation/true/false/null
            value = str.slice(m[0].begin, m[0].end);
            type = "ptfn";
        } else if (m = this._numberRegex.capture(str, start)) {
            // number
            value = str.slice(m[0].begin, m[0].end);
            type = "number";
        } else if (m = this._stringRegex.capture(str, start)) {
            // string
            value = str.slice(m[1].begin, m[1].end);
            type = "string";
        } else {
            return null;
        }

        token = {
            type = type,
            value = value,
            length = m[0].end - m[0].begin + whitespaces
        };

        return token;
    }

    /**
     * Count # of left-side whitespace chars
     * @param {string} str
     * @param {integer} start
     * @return {integer} number of leading spaces
     */
    function _leadingWhitespaces(str, start) {
        local r = this._ltrimRegex.capture(str, start);

        if (r) {
            return r[0].end - r[0].begin;
        } else {
            return 0;
        }
    }

    // unesacape() replacements table
    _unescapeReplacements = {
        "b": "\b",
        "f": "\f",
        "n": "\n",
        "r": "\r",
        "t": "\t"
    };

    /**
     * Unesacape string escaped per JSON standard
     * @param {string} str
     * @return {string}
     */
    function unescape(str) {

        local start = 0;
        local res = "";

        while (start < str.len()) {
            local m = this._unescapeRegex.capture(str, start);

            if (m) {
                local token = str.slice(m[0].begin, m[0].end);

                // append chars before match
                local pre = str.slice(start, m[0].begin);
                res += pre;

                if (token.len() == 6) {
                    // unicode char in format \uhhhh, where hhhh is hex char code
                    // todo: convert \uhhhh chars
                    res += token;
                } else {
                    // escaped char
                    // @see http://www.json.org/
                    local char = token.slice(1);

                    if (char in this._unescapeReplacements) {
                        res += this._unescapeReplacements[char];
                    } else {
                        res += char;
                    }
                }

            } else {
                // append the rest of the source string
                res += str.slice(start);
                break;
            }

            start = m[0].end;
        }

        return res;
    }
}

/**
 * JSON encoder
 *
 * @author Mikhail Yurasov <mikhail@electricimp.com>
 * @verion 0.7.0
 */
class JSONEncoder {

    static version = [1, 0, 0];

    // max structure depth
    // anything above probably has a cyclic ref
    static _maxDepth = 32;

    /**
     * Encode value to JSON
     * @param {table|array|*} value
     * @returns {string}
     */
    function encode(value) {
        return this._encode(value);
    }

    /**
     * @param {table|array} val
     * @param {integer=0} depth – current depth level
     * @private
     */
    function _encode(val, depth = 0) {

        // detect cyclic reference
        if (depth > this._maxDepth) {
            throw "Possible cyclic reference";
        }

        local
            r = "",
            s = "",
            i = 0;

        switch (typeof val) {

            case "table":
            case "class":
                s = "";

                // serialize properties, but not functions
                foreach (k, v in val) {
                    if (typeof v != "function") {
                        s += ",\"" + k + "\":" + this._encode(v, depth + 1);
                    }
                }

                s = s.len() > 0 ? s.slice(1) : s;
                r += "{" + s + "}";
                break;

            case "array":
                s = "";

                for (i = 0; i < val.len(); i++) {
                    s += "," + this._encode(val[i], depth + 1);
                }

                s = (i > 0) ? s.slice(1) : s;
                r += "[" + s + "]";
                break;

            case "integer":
            case "float":
            case "bool":
                r += val;
                break;

            case "null":
                r += "null";
                break;

            case "instance":

                if ("_serializeRaw" in val && typeof val._serializeRaw == "function") {

                        // include value produced by _serializeRaw()
                        r += val._serializeRaw().tostring();

                } else if ("_serialize" in val && typeof val._serialize == "function") {

                    // serialize instances by calling _serialize method
                    r += this._encode(val._serialize(), depth + 1);

                } else {

                    s = "";

                    try {

                        // iterate through instances which implement _nexti meta-method
                        foreach (k, v in val) {
                            s += ",\"" + k + "\":" + this._encode(v, depth + 1);
                        }

                    } catch (e) {

                        // iterate through instances w/o _nexti
                        // serialize properties, but not functions
                        foreach (k, v in val.getclass()) {
                            if (typeof v != "function") {
                                s += ",\"" + k + "\":" + this._encode(val[k], depth + 1);
                            }
                        }

                    }

                    s = s.len() > 0 ? s.slice(1) : s;
                    r += "{" + s + "}";
                }

                break;

            // strings and all other
            default:
                r += "\"" + this._escape(val.tostring()) + "\"";
                break;
        }

        return r;
    }

    /**
     * Escape strings according to http://www.json.org/ spec
     * @param {string} str
     */
    function _escape(str) {
        local res = "";

        for (local i = 0; i < str.len(); i++) {

            local ch1 = (str[i] & 0xFF);

            if ((ch1 & 0x80) == 0x00) {
                // 7-bit Ascii

                ch1 = format("%c", ch1);

                if (ch1 == "\"") {
                    res += "\\\"";
                } else if (ch1 == "\\") {
                    res += "\\\\";
                } else if (ch1 == "/") {
                    res += "\\/";
                } else if (ch1 == "\b") {
                    res += "\\b";
                } else if (ch1 == "\f") {
                    res += "\\f";
                } else if (ch1 == "\n") {
                    res += "\\n";
                } else if (ch1 == "\r") {
                    res += "\\r";
                } else if (ch1 == "\t") {
                    res += "\\t";
                } else if (ch1 == "\0") {
                    res += "\\u0000";
                } else {
                    res += ch1;
                }

            } else {

                if ((ch1 & 0xE0) == 0xC0) {
                    // 110xxxxx = 2-byte unicode
                    local ch2 = (str[++i] & 0xFF);
                    res += format("%c%c", ch1, ch2);
                } else if ((ch1 & 0xF0) == 0xE0) {
                    // 1110xxxx = 3-byte unicode
                    local ch2 = (str[++i] & 0xFF);
                    local ch3 = (str[++i] & 0xFF);
                    res += format("%c%c%c", ch1, ch2, ch3);
                } else if ((ch1 & 0xF8) == 0xF0) {
                    // 11110xxx = 4 byte unicode
                    local ch2 = (str[++i] & 0xFF);
                    local ch3 = (str[++i] & 0xFF);
                    local ch4 = (str[++i] & 0xFF);
                    res += format("%c%c%c%c", ch1, ch2, ch3, ch4);
                }

            }
        }

        return res;
    }
}
