local REGEXP_INTEGER = regexp("\\d+");

/**
 * isInteger in this value
 * @param {Mixed} value
 * @return {Boolean} [description]
 */
function isInteger(value) {
    return (typeof value == "integer" || REGEXP_INTEGER.match(value));
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
