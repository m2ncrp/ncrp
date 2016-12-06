include("modules/organizations/bookmakers/SportEntries");

local baseballs = [
    "Pittsburgh Pirates"   ,
    "St. Louis Cardinals"  ,
    "Cincinnati Reds"      ,
    "Chicago Cubs"         ,
    "Los Angeles Dodgers"  ,
    "San Francisco Giants" ,
    "Philadelphia Phillies",
    "Atlanta Braves"       ,
    "Oakland Athletics"    ,
    "Cleveland Indians"    ,
    "Minnesota Twins"      ,
    "Chicago White Sox"    ,
    "Detroit Tigers"       ,
    "Boston Red Sox"       ,
    "Baltimore Orioles"    ,
    "New York Yankees"     ,
    "Empire Bay Cannons"   ,
    "Lost Heaven Lancers"  ,
    "Birkland Bulls"
];

local bkSpotTypes = [
    "baseball",
    "horserace"
];

event("onServerStarted", function() {
    SportEntries.findAll(function(err, entries) {
        // if (err || )
    });
});

function bkShowList ( playerid ) {
    // Code
}

function bkSelectSport ( playerid, sport = null ) {
    // Code
}

function bkBet ( playerid, sportid, amount ) {
    // Code
}
