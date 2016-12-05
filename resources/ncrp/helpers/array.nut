function concat(vars, symbol = " ") {
    return vars.reduce(function(carry, item) {
        return item ? carry + symbol + item : "";
    });
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
