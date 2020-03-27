include("controllers/citizens/models/Citizen.nut");

local citizens_cache = {};

event("onServerStarted", function() {
    logStr("starting citizens...");

    citizensLoadData();
});


event("onServerSecondChange", function() {

    if ((getSecond() % 10) != 0) {
        return;
    }

    local currentTimestamp = getTimestamp();


    local currentHour = getHour();


    /*
    с 7 до 8 - завтрак (покупка завтрака в кафе)
    с 9 до 12 - работа
    с 13 до 14 - обед
    с 14 до 18 - работа
    с 19 до 22 - разное
    с 23 до 6 - сон
    */


    logStr("currentTimestamp: " + currentTimestamp)
    foreach (citizenid, object in citizens_cache) {

        if (!object) continue;

        if(object.timestamp > currentTimestamp) continue;
        logStr(object.id + ". timestamp: " + object.timestamp)
        object.timestamp = getTimestamp() + random(20, 60);

        object.save();
    }
});


function citizensLoadData() {
    Citizen.findAll(function(err, results) {
      logStr(results.len().tostring())
        foreach (idx, object in results) {
            logStr(object)
            citizens_cache[object.id] <- object;
        }
    });
}

function citizensCreateData() {
    for (local i = 0; i < 10; i++) {
        local citizen = Citizen();
        citizen.money = random(10, 1000).tofloat();
        citizen.next_action = "sleep";
        citizen.timestamp = getTimestamp() + random(5, 15);
        citizen.save();
    }
    citizensLoadData();
}