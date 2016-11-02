function concat(vars) {
    return vars.reduce(function(carry, item) { 
        return item ? carry + " " + item : ""; 
    });
}