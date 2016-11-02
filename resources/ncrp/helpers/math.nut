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
