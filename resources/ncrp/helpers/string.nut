local REGEXP_INTEGER = regexp("\\d+");

/**
 * isInteger in this value
 * @param {Mixed} value
 * @return {Boolean} [description]
 */
function isInteger(value) {
    return (typeof value == "integer" || REGEXP_INTEGER.match(value));
}
