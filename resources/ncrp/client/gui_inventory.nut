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

event("inventory:onServerItemAdd", function(id) {});
event("inventory:onServerItemMove", function(id) {});
event("inventory:onServerItemDrop", function(id) {});
event("inventory:onServerItemRemove", function(id) {});

const INVENTORY_INACTIVE_ALPHA = 0.65;
const INVENTORY_ACTIVE_ALPHA   = 1.0;

local storage = {};
local defaultMouseState = false;
local selectedItem = null;

class Inventory
{
    id      = null;
    data    = null;
    handle  = null;
    items   = null;
    cache   = null;
    opened  = false;

    guiTopOffset    = 20.0;
    guiBottomOffset = 20.0;
    guiPadding      = 5.0;
    guiCellSize     = 64.0;

    guiLableItemOffsetX = 48.0;
    guiLableItemOffsetY = 50.0;

    constructor(id, data) {
        this.id     = id;
        this.data   = data;
        this.items  = {};
        this.cache  = {};

        return this.createGUI();
    }

    static function isAnyOpened(objects) {
        foreach (idx, inventory in objects) {
            if (inventory.opened) {
                return true;
            }
        }

        return false;
    }

    static function formatLabelText(item) {
        switch (item.type) {
            case "Item.None":       return "";
            case "Item.Weapon":     return item.amount.tostring();
            case "Item.Ammo":       return item.amount.tostring();
            case "Item.Clothes":    return item.amount.tostring();
        }

        return "";
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

    function createItem(slot, classname, type, amount = 0, weight = 0.0) {
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
            item.handle <- guiCreateElement( ELEMENT_TYPE_IMAGE, item.classname + ".jpg", pos.x, pos.y, this.guiCellSize, this.guiCellSize, false, this.handle);
            item.label  <- guiCreateElement( ELEMENT_TYPE_LABEL, this.formatLabelText(item), pos.x + this.guiLableItemOffsetX, pos.y + this.guiLableItemOffsetY, 16.0, 15.0, false, this.handle);
        }

        guiSetAlpha(item.handle, 0.75);
        guiSetAlwaysOnTop(item.label, true);

        this.items[item.slot] <- item;
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
                guiSetText(item.label, this.formatLabelText(matched));
                continue;
            }

            // do nothing
            // items are purely identical
        }
    }

    function createGUI() {
        local size = this.getSize();

        this.handle = guiCreateElement(ELEMENT_TYPE_WINDOW, this.data.title, centerX - size.x / 2, centerY - size.y / 2, size.x, size.y);
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

    function getSize() {
        return {
            x = ((this.data.sizeX * (this.guiCellSize + this.guiPadding)) + this.guiPadding * 2).tofloat() + 2,
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
}

event("onClientFrameRender", function(afterGUI) {
    if (!afterGUI) return;

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

            pos.x += window[0];
            pos.y += window[1];

            dxDrawRectangle(pos.x, pos.y, inventory.guiCellSize, inventory.guiCellSize, 0x61AF8E4D);
        }

        local coef  = (weight / inventory.data.limit);
        local width = (size.x - inventory.guiPadding * 2 - 7) * (coef > 1.0 ? 1.0 : coef);

        dxDrawRectangle(window[0].tofloat() + inventory.guiPadding + 4, window[1] + size.y - inventory.guiBottomOffset - 3, size.x - inventory.guiPadding * 2 - 7, 15.0, 0xFF242522);
        dxDrawRectangle(window[0].tofloat() + inventory.guiPadding + 4, window[1] + size.y - inventory.guiBottomOffset - 3, width, 15.0, 0xFFAF8E4D);

        // dxDrawText();
    }
});

event("inventory:onServerOpen", function(id, data) {
    local data = JSONParser.parse(data);

    if (!Inventory.isAnyOpened(storage)) {
        defaultMouseState = isCursorShowing();
        showCursor(true);
    }

    if (!(id in storage)) {
        storage[id] <- Inventory(id, data);
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
            if (element == item.handle) {
                return inventory.click(item);
            }
        }
    }
});



dbg <- function(...) {
    log(JSONEncoder.encode(concat(vargv)));
}

dbgc <- function(...) {
    sendMessage(JSONEncoder.encode(concat(vargv)));
};

/**
 * Concatenate array using symbol as separator
 * @param  {Array} vars
 * @param  {String} symbol
 * @return {String}
 */
function concat(vars, symbol = " ") {
    return vars.reduce(function(carry, item) {
        return item ? carry + symbol + item : "";
    });
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
