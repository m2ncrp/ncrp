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
