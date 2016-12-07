include("modules/organizations/bookmakers/models/SportMember.nut");
include("modules/organizations/bookmakers/models/SportEvent.nut");

const BK_RADIUS = 4.0;
/*
const BK_X = -669.88;
const BK_Y = -98.718;
const BK_Z = 1.03804;
*/

const BK_X = -416.889;
const BK_Y = 474.576;
const BK_Z = -0.238935;

      BK_COLOR <- CL_PICTONBLUEDARK;

local bk_player = {};
local bkSpotTypes = [
    "baseball",
    "horserace"
];

local bkLoadedData = {
    members = [],
    events  = [],
    current = {
        horses = [],
        teams = []
    }
};

event("onPlayerConnect", function(playerid, name, ip, serial ){
    bk_player[playerid] <- {};
    bk_player[playerid]["bet"] <- null;
});

event("onServerStarted", function() {
    log("[jobs] loading bookmakers...");

    // load records (horses and etc.)
    SportMember.findAll(function(err, results) {
        bkLoadedData.members = (!results.len()) ? bkCreateBaseData() : results;
    });

    // load current events
    SportEvent.findAll(function(err, results) {
        bkLoadedData.events = (!results.len()) ? bkCreateEvent() : results;
    });

    create3DText ( BK_X, BK_Y, BK_Z+0.35, "Betting Office", CL_ROYALBLUE );
    create3DText ( BK_X, BK_Y, BK_Z+0.20, "/bk", CL_WHITE.applyAlpha(100), 3.0 );

    createBlip  (  BK_X, BK_Y, [ 6, 4 ], 4000.0);

});

event("onServerHourChange", function() {
    if (getHour() == 0)  { bkCreateEvent(); return; }
    if (getHour() != 20) return;

    SportEvent.findBy({ winner = 0 }, function(err, events) {
        foreach (idx, sprt in events) {
            sprt.getParticipants(function(err, teams) {

                // add win to random winner
                local winner = teams[random(0, teams.len() - 1)];
                winner.wins++;

                // add totals to all and save
                foreach (idx, team in teams) {
                    team.total++;
                    team.save();
                }

                // save winner id
                sprt.winner = winner.id;
                sprt.save();
            });
        }
    });

});


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------


function bkCreateEvent () {

// create horserace events
    local data = bkSelectFixedAmount("horserace", 8);
    local sprt = SportEvent();

    foreach (idx, value in data) {
        sprt.addParticipant(value);
        bkLoadedData.current.horses.push(value);
    }

    sprt.type = "horserace";
    sprt.date = getDate();
    sprt.save();

    print("saved with id: " + sprt.id);

// create baseball events
    for (local i = 0; i < 5; i++) {

        local data = bkSelectFixedAmount("baseball", 2);
        local sprt = SportEvent();

        foreach (idx, value in data) {
            sprt.addParticipant(value);
            bkLoadedData.current.teams.push(value);
        }

        sprt.type = "baseball";
        sprt.date = getDate();
        sprt.save();

        print("saved with id: " + sprt.id);
    }
}


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------


function bkRemoveEvents (type = null) {
    if (type == null) {
        ORM.Query("delete from @SportEvent").execute();
        return;
    }
    if (type == "baseball") {
        ORM.Query("delete from @SportEvent where type = 'baseball'").execute();
        return;
    }
    if (type == "horserace") {
        ORM.Query("delete from @SportEvent where type = 'horserace'").execute();
        return;
    }
    print("[bk] type \""+type+"\" not found" );
}


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------


function bkCreateBaseData() {
    local members   = [];
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

    foreach (idx, value in baseballs) {
        // crate
        local member = SportMember();

        // put data
        member.type  = bkSpotTypes[0];
        member.title = value;
        member.wins  = random(3, 7);
        member.total = member.wins + random(3, 10);

        // insert into database
        member.save();
        members.push(member);
    }

    local horses = [
        "Phalaris", "Eclipse", "Nearco", "Sayram", "American Pharoah", "Sorrento", "Mustang", "Nearctic", "Allegra", "Alaska", "Acorn", "Adagio", "Admiral", "Arnie", "Artemis", "Artex", "Arthur", "Banjo", "Baloo", "Bambi", "Bandit", "Barkley", "Bueno", "Noir", "Jaguar", "Ebony", "Onyx", "Domino", "Cleveland", "Adobe", "Cinnamon", "Brandy", "Autumn", "Opie", "Fiona", "Peter Pan", "Russell", "Blondie", "Rapunzel", "Spirit", "Trapper", "Napoleon", "Pepper", "Snowball", "Lacey", "Traveller", "Scout", "Little Joe", "Jigsaw", "Pirate", "Rembrandt", "Monte", "Baymax", "Goliath", "Universe", "Bolt", "Challenger", "Billie Jean", "Fargo", "Jet", "Victory", "Pharoah", "Trigger", "Champ", "Oakley", "Bonney", "Rio", "Dale", "Gene", "Cash", "Chisholm", "Misty", "Dolly", "Cookie", "Charlie Brown", "Kokomo", "Olaf", "Thelwell", "Isabelle", "Randolph", "Debutante", "Marquis", "Juliet", "Henrietta", "Vanderbilt", "Versailles", "El Jefe", "Queen", "Boots", "Major", "Barkley", "Barnaby", "Whiskers", "Balki", "Newton", "Tigger", "Buster", "Flopsy", "Paris", "Sicily", "Beijing", "Vancouver", "Utah", "Sydney", "Berlin", "Carolina", "Passport", "London", "Mozart", "Jackson", "Beethoven", "Mona", "Dickinson", "Bard", "Da Vinci", "Sullivan", "Chopin"
    ];

    foreach (idx, value in horses) {
        // crate
        local member = SportMember();

        // put data
        member.type  = bkSpotTypes[1];
        member.title = value;
        member.wins  = random(3, 7);
        member.total = member.wins + random(3, 10);

        // insert into database
        member.save();
        members.push(member);
    }

    return members;
}


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------


function bkSelectFixedAmount(type, amount) {
    local data = [];
    local source = shuffle(bkLoadedData.records);

    foreach (idx, value in source) {
        if (data.len() >= amount) break;
        if (value.type == type) data.push(value);
    }

    return data;
}


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------


function bkShowList ( playerid ) {
    // Code
}


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------


translation("en", {
    "bk.goto"              : "Go to betting office in West Side"
    "bk.selectsport"       : "Select sport:"
    "bk.baseball"          : "1. Baseball"
    "bk.horseriding"       : "2. Horse riding"

    "bk.selectteam"        : "Select team to bet"
    "bk.selecthorse"       : "Select horse to bet"
    "bk.toselectteam"      : "To select team use: /bk team ID"
    "bk.toselecthorse"     : "To select horse use: /bk horse ID"
});


//---------------------------------------------------------------------------------------------------------------

function bkFindCoef ( wins, total ) {
    return 10-round( (wins.tofloat() / total.tofloat()), 1)*10;
}


function bkOpen ( playerid, type = null) {

    if(!isPlayerInValidPoint(playerid, BK_X, BK_Y, BK_RADIUS)) {
        return msg( playerid, "bk.goto", BK_COLOR );
    }

    if (type == null) {
        msg(playerid, "==================================", CL_HELP_LINE);
        msg( playerid, "bk.selectsport", CL_PICTONBLUEDARK);
        msg( playerid, "bk.baseball", CL_PICTONBLUEDARK);
        msg( playerid, "bk.horseriding", BK_COLOR);

        return;
    }

    local count = 1;
    if (type == "2") {
        msg( playerid, "==================================", CL_HELP_LINE );
        msg( playerid, "bk.selectteam", BK_COLOR);
        foreach (idx, event in bkLoadedData.events) {
            local currentmembers = split(event.participants, ",");
            if (event.type == "baseball") {
                local id1 = bkLoadedData.members[ (currentmembers[1].tointeger() - 1)];
                local id2 = bkLoadedData.members[ (currentmembers[2].tointeger() - 1)];
                local coef1 = bkFindCoef(id1.wins, id1.total);
                local coef2 = bkFindCoef(id2.wins, id2.total);

                msg( playerid, "["+count+"] "+id1.title+" ("+coef1+"/1)   -   ["+(count+1)+"] "+id2.title+" ("+coef2+"/1)");
                count += 2;
            }
        }
        msg( playerid, "bk.toselectteam22", BK_COLOR);
        bk_player[playerid]["bet"] <- "baseball";
    }
     if (type == "1") {
        msg( playerid, "==================================", CL_HELP_LINE );
        msg( playerid, "bk.selecthorse", BK_COLOR);
        foreach (idx, event in bkLoadedData.events) {
            local currentmembers = split(event.participants, ",");
            if (event.type == "horserace") {
                foreach (i, member in currentmembers) {
                    if (member == "0") continue;
                    local mid = bkLoadedData.members[ (member.tointeger() - 1)]
                    local coef = bkFindCoef(mid.wins, mid.total);
                    msg( playerid, i+". "+mid.title+" ("+coef+"/1)");
                }
            }
        }
        msg( playerid, "bk.toselecthorse11", BK_COLOR);
        bk_player[playerid]["bet"] <- "horserace";
    }
}


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------

function bkGetHorseIdByNumber( id = null) {
    foreach (idx, event in bkLoadedData.events) {
        local currentmembers = split(event.participants, ",");
        if (event.type == "horserace") {
            foreach (i, member in currentmembers) {
                if (member == "0") continue;
                if (i == id) {
                        dbg(member);
                    return member.tointeger();
                }
            }
        }
    }
}

function bkGetTeamIdByNumber( id = null) {
    local count = 1;
    local pos = 1 - (id.tointeger() % 2);
    foreach (idx, event in bkLoadedData.events) {
        local currentmembers = split(event.participants, ",");
        if (event.type == "baseball") {
            if (id == (count+pos) ) {
            local id = bkLoadedData.members[ (currentmembers[(1+pos)].tointeger() - 1)].id;
            dbg(id);
            return id.tointeger();
            }
            count += 2;
        }
    }
}


function bkBet ( playerid, number, amount ) {

    if(!isPlayerInValidPoint(playerid, BK_X, BK_Y, BK_RADIUS)) {
        return msg( playerid, "bk.goto", BK_COLOR );
    }

    local type = bk_player[playerid]["bet"];

    if(type == null) {
        return msg( playerid, "bk.needselectsport", BK_COLOR );
    }

    local amount = amount.tofloat();

    if ( !canMoneyBeSubstracted(playerid, amount) ) {
        return msg(playerid, "bk.notenough", CL_RED);
    }

    if ( amount > 100000.0) {
        return msg(playerid, "bk.bettoomuch", CL_RED);
    }

      local participant = null;
        if(type == "horserace") {
            participant = bkGetHorseIdByNumber( number.tointeger() );
        }
        else if(type == "baseball") {
            participant = bkGetTeamIdByNumber( number.tointeger() );
        }

    if (participant == null) {
        return msg(playerid, "bk.betnotfound", CL_RED);
    }

    local bet = SportBet();

    bet.name  = getPlayerName( playerid );
    bet.participant = participant.tointeger();
    bet.amount = amount;
    bet.save();

}


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------


cmd("bk", function(playerid, sport = null) {
    bkOpen ( playerid, sport );
});


cmd("bk", "bet", function(playerid, number, amount) {
    bkBet (playerid, number, amount);
});

