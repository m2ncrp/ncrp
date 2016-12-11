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
