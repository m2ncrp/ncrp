local REGEXP_INTEGER = regexp("\\d+");
local REGEXP_FLOAT   = regexp("[0-9\\.]+");

/**
 * isInteger in this value
 * @param {Mixed} value
 * @return {Boolean} [description]
 */
function isInteger(value) {
    return (typeof value == "integer" || REGEXP_INTEGER.match(value));
}

/**
 * isInteger in this value
 * @param {Mixed} value
 * @return {Boolean} [description]
 */
function isFloat(value) {
    return (typeof value == "float" || REGEXP_FLOAT.match(value));
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
