function concat(vars) {
    return vars.reduce(function(carry, item) {
        return item ? carry + " " + item : "";
    });
}


function getRandomSubArray(arr, size = 1) {
    local subarr = [];

    while (subarr.len() < size) {
        local rand = random(0, arr.len() - 1);
        subarr.push(arr[rand]);
        arr.remove(rand)
    }
    return subarr;
}
