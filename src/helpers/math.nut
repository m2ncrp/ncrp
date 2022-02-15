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
 * Return random string by array of objects with weight
 *
 * @param  {array of objects} options
 * local options = [
 *     { "item": "bike", "weight": 0.4 },
 *     { "item": "car", "weight": 0.3 },
 *     { "item": "boat", "weight": 0.15 },
 *     { "item": "train", "weight": 0.1 },
 *     { "item": "plane", "weight": 0.05 },
 * ];
 * @return {string}
 */
function weightedRandom(options) {
    local i;
    local count = options.len();
    local weights = array(count);

    for (i = 0; i < count; i++) {
        local weight = i - 1 >= 0 && weights[i - 1] ? weights[i - 1] : 0;
        weights[i] = options[i].weight + weight;
    }

    local random = randomf(0.0, 1.0) * weights[weights.len() - 1];

    for (i = 0; i < (weights.len() - 1); i++) {
        if (weights[i] > random) break;
    }

    return options[i].item;
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
function range(from, to = null) {
    if (to == null) {
        to = from;
        from = 0;
    }

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

function todeg(angle) {
    return angle / PI * 180.0;
}

function torad(angle) {
    return angle * PI / 180.0;
}


function sortArray(arr) {
    local cloned = clone arr;
    cloned.sort(function(a, b) {
        if(a >= b) return 1;
        if(a < b) return -1;
    })

    return cloned;
}

function maxOfArray(arr) {
    return sortArray(arr)[arr.len() - 1]
}

function minOfArray(arr) {
    return sortArray(arr)[0]
}