/**
 * Descriptive array of all swearwords
 * @type {Array}
 */
local swearwords = [
    "сука", "блеать", "m2rl", "mafia2rl"
];


/**
 * Storage for compiled elements (regexes)
 * @type {Array}
 */
local __compiled = null;

/**
 * Strip input string from swearwords
 * @param  {String} input
 * @return {String}
 */
function stipSwearwords(input) {
    if (!__compiled.len()) {
        foreach (idx, value in swearwords) {
            __compiled.push(regexp(value.tolower()));
        }
    }

    foreach (idx, expression in __compiled) {

        local result = "";
        local position = 0;
        local captures = expression.capture(string.tolower());

        while (captures != null) {
            foreach (i, capture in captures) {
                result += string.slice(position, capture.begin);
                result += replacement;
                position = capture.end;
            }

            captures = expression.capture(string.tolower(), position);
        }

        result += string.slice(position);

    }

    return input;
}
