## WARNING
## DONT EDIT THIS FILE
## ITS CREATED ONLY FOR PREVIEW






# Libraries










# aliases and special stuff
event <- addEventHandler;

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


# Controllers










// 
// 


# Modules

// 
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
const DEBUG_ENABLED = true;

/**
 * Function that logs to server console
 * provided any number of provided values
 *
 * @param  {...}  any number of arguments
 * @return none
 */
function log(...) {
    return ::print(JSONEncoder.encode(vargv).slice(2).slice(0, -2));
};


/**
 * Function that logs to server console
 * provided any number of provided values
 * NOTE: addes prefix [debug] in front of output
 *
 * @param  {...}  any number of arguments
 * @return none
 */
function dbg(...) {
    return DEBUG_ENABLED ? ::print("[debug] " + JSONEncoder.encode(vargv)) : null;
}

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
 * Return new array with elements
 * shuffled in the random order
 * @param  {Array} array
 * @return {Array}
 */
function shuffle(input) {
    local array  = clone(input);
    local output = [];

    if (!("random" in getroottable())) {
        random <- function (min, max) {
            return ((rand() % ((max + 1) - min)) + min);
        };
    }

    while (array.len()) {
        if (random(0, 1) == 1) {
            array.reverse();
        }

        local idx = random(0, array.len() - 1);
        output.push(array[idx]);
        array.remove(idx);
    }

    return output;
}

/**
 * Return new array with all unique elements
 * @param  {Array} array
 * @return {Array}
 */
function array_unique ( array ) {
    local result = [];
    foreach (idx, value in array) {
        if(result.find(value) == null)
        {
            result.push(value);
        }
    }
    return result;
}


function getRandomSubArray(arr, size = 1) {
    local subarr = [];
    local orig = arr.map(function(a) {return a;});

    while (subarr.len() < size) {
        local rand = random(0, orig.len() - 1);
        subarr.push(orig[rand]);
        orig.remove(rand)
    }
    return subarr;
}
/**
 * Call a delayed function
 *
 * @param {int} time in ms
 * @param {Function} callback
 * @param {mixed} [additional] optional argument
 *     that will be passed to a callback
 *
 * @return {int} timer id
 */
function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}
/**
 * Generate random number (int)
 * from a range
 * by default range is 0...RAND_MAX
 *
 * @param  {int} min
 * @param  {int} max
 * @return {int}
 */
function random(min = 0, max = RAND_MAX) {
    return (rand() % ((max + 1) - min)) + min;
}

/**
 * Generate random number (float)
 * from a range
 * by default range is 0...RAND_MAX
 *
 * @param  {float} min
 * @param  {float} max
 * @return {float}
 */
function randomf(min = 0.0, max = RAND_MAX) {
    return (rand() % (max - min + 0.001)) + min;
}

/**
 * Max from a range (2 or more parameters)
 * @return {int}
 */
function max(...) {
    return vargv.reduce(function(carry, item) {
        return item > carry ? item : carry;
    });
}

/**
 * Min from a range (2 or more parameters)
 * @return {int}
 */
function min(...) {
    return vargv.reduce(function(carry, item) {
        return item < carry ? item : carry;
    });
}

/**
 * Generate arrray containing numbers
 * which represents range from ... to
 *
 * @param  {int} from
 * @param  {int} to
 * @return {array}
 */
function range(from, to) {
    local tmp = [];

    for (local i = from; i <= to; i++) {
        tmp.push(i);
    }

    return tmp;
}

/**
 * Round <val> to <decimalPoints> after dot.
 *
 * @param  {float} val
 * @param  {int} count number after dot
 * @return {float} result
 * URL: https://forums.electricimp.com/discussion/2128/round-float-to-fixed-decimal-places
 */
function round(val, decimalPoints) {
    local f = pow(10, decimalPoints) * 1.0;
    local newVal = val * f;
    newVal = floor(newVal + 0.5)
    newVal = (newVal * 1.0) / f;
   return newVal;
}

/**
 * Greatest common divisor
 * @param  {float} a
 * @param  {float} b
 * @return {float}
 */
function nod (a, b) {
    local a = abs(a);
    local b = abs(b);
    while (a != b) {
        if (a > b) {
            a -= b;
        } else {
            b -= a;
        }
    }
    return a;
}

/**
 *   !!! No use without testing
 * Round to simple fraction
 * @param  {float} num
 * @return {string}
 */
function fractionSimple (num) {

    local num = num.tofloat();
    local chis = (num%1)*100;
        dbg("chis: "+chis);
    local tseloe = floor(num);
        dbg("tseloe: "+tseloe);
    local nodd = nod(chis, 100);
        dbg("nodd: "+nodd);
    local znam = 100 / nodd;
    local chis = (tseloe * znam) + (chis / nodd);
    dbg("chis|znam "+chis+"|"+znam);
}

/**
 *   !!! No use without testing
 * Round to periodoc fraction
 * @param  {float} num
 * @return {string}
 */
function fractionPeriodic (num) {

    local num = num.tostring();
        dbg("num: "+num);
    num = num.slice(0, 4);
        dbg("num slice: "+num);
    local posle = num.slice(2, 4);
        dbg("posle: "+posle);
    if (posle.find("0")) {
        posle = posle.slice(1, 2);
            dbg("if posle: "+posle);
    }  // если [0,]66 => 66, если [0,]06 => 6

    local val_do = posle.slice(0, 1);
        dbg("val_do: "+val_do);
    local chis = posle.tofloat() - fabs(val_do.tofloat());   // выполнили 6 пункт
        dbg("chis: "+chis);
    local znam = 90.0;
    local nd = nod(chis, znam);
    local ekran_chis = chis/nd;
    local ekran_znam = znam/nd;
        dbg("ekran: "+ekran_chis+"|"+ekran_znam);
    //return ekran;
}



class Vector3d {
    X = null; 
    Y = null; 
    Z = null;

    constructor (X = 0.0, Y = 0.0, Z = 0.0) {
        this.X = X;
        this.Y = Y
        this.Z = Z;
    }
}
local REGEXP_INTEGER = regexp("\\d+");
local REGEXP_FLOAT   = regexp("[0-9\\.]+");

/**
 * isInteger in this value
 * @param {Mixed} value
 * @return {Boolean} [description]
 */
function isInteger(value) {
    return (value != null && (typeof value == "integer" || REGEXP_INTEGER.match(value)));
}

/**
 * isInteger in this value
 * @param {Mixed} value
 * @return {Boolean} [description]
 */
function isFloat(value) {
    return (value != null && (typeof value == "float" || REGEXP_FLOAT.match(value)));
}


/**
 * Combined resulted function
 * check if number is numeric (float/integer)
 * @param {Mixed} value
 * @return {Boolean}
 */
function isNumeric(value) {
    return (isInteger(value) || isFloat(value));
}

/**
 * Convert value to string
 * wihout scientific notation
 * Useful for a long-ass values
 *
 * @param  {mixed} value
 * @return {string}
 */
function floatToString(value) {
    return format("%.0f", value.tofloat());
}

/**
 * Strip all non integer data from the string
 * and return plain, cleared value or 0
 *
 * @param  {Mixed} value
 * @return {Integer}
 */
function toInteger(value) {
    if (isInteger(value)) {
        return value.tointeger();
    }

    if (value == null) {
        return 0;
    }

    local result = REGEXP_INTEGER.search(value);

    if (result != null) {
        return value.slice(result.begin, result.end).tointeger();
    }

    return 0;
}

toInt <- toInteger;

/**
 * Replace occurances of "search" to "replace" in the "subject"
 * @param  {string} search
 * @param  {string} replace
 * @param  {string} subject
 * @return {string}
 */
function str_replace(original, replacement, string) {
    local expression = regexp(original);
    local result = "";
    local position = 0;
    local captures = expression.capture(string);

    while (captures != null) {
        foreach (i, capture in captures) {
            result += string.slice(position, capture.begin);
            result += replacement;
            position = capture.end;
        }

        captures = expression.capture(string, position);
    }

    result += string.slice(position);

    return result;
}

/**
 * Replace occurances of "search" to "replace" in the "subject"
 * @param  {string} search
 * @param  {string} replace
 * @param  {string} subject
 * @return {string}
 */
function preg_replace(original, replacement, string) {
    local expression = regexp(original);
    local result = "";
    local position = 0;
    local captures = expression.capture(string);

    while (captures != null) {
        local capture = captures[0];

        result += string.slice(position, capture.begin);

        local subsitute = replacement;

        for (local i = 1; i < captures.len(); i++) {
            subsitute = str_replace("\\$" + i, string.slice(captures[i].begin, captures[i].end), subsitute);
        }

        result += subsitute;
        position = capture.end;
        captures = expression.capture(string, position);
    }

    result += string.slice(position);
    return result;
}

/**
 * Escape strings according to http://www.json.org/ spec
 * @param {String} str
 */
function escape(str) {
    local res = "";

    for (local i = 0; i < str.len(); i++) {

        local ch1 = (str[i] & 0xFF);

        if ((ch1 & 0x80) == 0x00) {
            // 7-bit Ascii

            ch1 = format("%c", ch1);

            if (ch1 == "\'") {
                res += "\\\'";
            } else if (ch1 == "\"") {
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
/**
 * Return array of keys of the table
 * @param  {Table} table
 * @return {Array}
 */
function tableKeys(table) {
    if (typeof table != "table") {
        return error("tableKeys: provided data is not a table.");
    }

    local keys = [];

    foreach (idx, value in table) {
        keys.push(idx);
    }

    return keys;
}
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

addEventHandler("onServerClientStarted", function(version) {
    ticker = timer(onPlayerTick, 100, -1);
});
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
dbgc <- function(...) {
    sendMessage(JSONEncoder.encode(concat(vargv)));
};

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
local window;
local label;
local buttons = array(2);

addEventHandler("showRentCarGUI", function(windowText,labelText, button1Text, button2Text) {
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
});

function hideCursor() {
    showCursor(false);
}

function hideRentCarGUI () {
    guiSetVisible(window,false);
    guiSetText( label, "");
    delayedFunction(100, hideCursor);//todo fix
}

addEventHandler( "onGuiElementClick", function(element) {
    if(element == buttons[0]){
        triggerServerEvent("RentCar");
        hideRentCarGUI();
    }

    if(element == buttons[1]){
        hideRentCarGUI();
    }
});
})();
