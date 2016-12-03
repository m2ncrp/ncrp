local REGEXP_INTEGER = regexp("\\d+");
local REGEXP_FLOAT   = regexp("[0-9\\.]+");

/**
 * isInteger in this value
 * @param {Mixed} value
 * @return {Boolean} [description]
 */
function isInteger(value) {
    return (value && (typeof value == "integer" || REGEXP_INTEGER.match(value)));
}

/**
 * isInteger in this value
 * @param {Mixed} value
 * @return {Boolean} [description]
 */
function isFloat(value) {
    return (value && (typeof value == "float" || REGEXP_FLOAT.match(value)));
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
