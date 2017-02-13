event("onServerStarted", function() {
local phrases = {
     "ru|Test112" : "2222 ru 22222"
     "en|Test112" : "2222 en 22222"

     "ru|Test113" : "3333 ru 33333"
     "en|Test113" : "3333 en 33333"
}

    alternativeTranslate(phrases);

});


function alternativeTranslate(phrases) {
    foreach (idx, phrase in phrases) {
        local split = split(idx, "|");
        local temp = {};
        temp[split[1]] <- phrase;
        translate(split[0], temp );
    }
}


/*
foreach (idx, phrase in phrases) {
    local temp = {};
    temp[phrase[1]] <- phrase[2];
    translate(phrase[0], temp );
}
*/

/*
foreach (idx, phrase in phrases) {
    local ins = {};
    foreach (idy, ph in phrase) {
        ins[idy] <- ph;
        translate(idx, ins );
    }
}
*/
