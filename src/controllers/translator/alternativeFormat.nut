/*

EXAMPLE:

local phrases = {
     "en|Test1" : "1. Test EN"
     "ru|Test1" : "1. Test RU"

     "en|Test2" : "2. Test EN"
     "ru|Test2" : "2. Test RU"
}

alternativeTranslate(phrases);

 */

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
