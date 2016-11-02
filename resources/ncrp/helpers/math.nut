function random(min = 0, max = RAND_MAX) {
    return (rand() % ((max + 1) - min)) + min;
}

function max(...) {
    return vargv.reduce(function(carry, item) {
        return item > carry ? item : carry;
    });
}

function min(...) {
    return vargv.reduce(function(carry, item) {
        return item < carry ? item : carry;
    });
}
