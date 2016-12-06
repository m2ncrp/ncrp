
const BK_RADIUS = 4.0;
const BK_X = -669.88;
const BK_Y = -98.718;
const BK_Z = 1.03804;
      BK_COLOR <- CL_PICTONBLUEDARK;

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

translation("en", {

    "bk.goto"              : "Go to betting office in West Side"
    "bk.selectsport"       : "Select sport:"
    "bk.baseboll"          : "1. Baseboll"
    "bk.horseriding"       : "2. Horse riding"

    "bk.selectteam"        : "Select team to bet"
    "bk.selecthorse"       : "Select horse to bet"

});


function bkOpen ( playerid, sport = null ) {

    if(!isPlayerInValidPoint(playerid, BK_X, BK_Y, BK_RADIUS)) {
        return msg( playerid, "bk.goto", BK_COLOR );
    }

    if (sport == null) {
        msg(playerid, "==================================", CL_HELP_LINE);
        msg( playerid, "bk.selectsport", CL_PICTONBLUEDARK);
        msg( playerid, "bk.baseboll", CL_PICTONBLUEDARK);
        msg( playerid, "bk.horseriding", BK_COLOR);

        return;
    }
    local sport = sport.tointeger();
    if (sport == 1) {
        msg(playerid, "==================================", CL_HELP_LINE);
        msg( playerid, "bk.selectteam", BK_COLOR);

        return;
    }

    if (sport == 2) {
        msg(playerid, "==================================", CL_HELP_LINE);
        msg( playerid, "bk.selecthorse", BK_COLOR);

        return;
    }

}

function bkBet ( playerid, sportid, amount ) {
    // Code
}



cmd("bk", function(playerid, sport = null) {
    bkOpen (playerid, sport);
});
