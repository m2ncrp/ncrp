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
