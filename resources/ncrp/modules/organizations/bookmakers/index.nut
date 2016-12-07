include("modules/organizations/bookmakers/models/SportEntries.nut");
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

local bkSpotTypes = [
    "baseball",
    "horserace"
];

local bkLoadedData = {
    records = []
};

event("onServerStarted", function() {
    SportEntries.findAll(function(err, entries) {
        if (err || !entries.len()) {
            // called only one time (per database)
            entries = bkCreateBaseData();
        }

        bkLoadedData.records = entries;
    });

    log("[jobs] loading porter job...");

    //creating 3dtext for bus depot
    create3DText ( BK_X, BK_Y, BK_Z+0.35, "TRAIN STATION", CL_ROYALBLUE );
    create3DText ( BK_X, BK_Y, BK_Z+0.20, "/help job porter", CL_WHITE.applyAlpha(100), 3.0 );

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


function bkCreateEvent () {

// create horserace events
    local data = bkSelectFixedAmount("horserace", 8);
    local sprt = SportEvent();

    foreach (idx, value in data) {
        sprt.addParticipant(value);
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
        }

        sprt.type = "baseball";
        sprt.date = getDate();
        sprt.save();

        print("saved with id: " + sprt.id);
    }
}

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

function bkCreateBaseData() {
    local entries   = [];
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
        local entry = SportEntries();

        // put data
        entry.type  = bkSpotTypes[0];
        entry.title = value;
        entry.wins  = random(3, 7);
        entry.total = random(3, 23);

        // insert into database
        entry.save();
        entries.push(entry);
    }

    local horses = [
        "Phalaris", "Eclipse", "Nearco", "Sayram", "American Pharoah", "Sorrento", "Mustang", "Nearctic", "Allegra", "Alaska", "Acorn", "Adagio", "Admiral", "Arnie", "Artemis", "Artex", "Arthur", "Banjo", "Baloo", "Bambi", "Bandit", "Barkley", "Bueno", "Noir", "Jaguar", "Ebony", "Onyx", "Domino", "Cleveland", "Adobe", "Cinnamon", "Brandy", "Autumn", "Opie", "Fiona", "Peter Pan", "Russell", "Blondie", "Rapunzel", "Spirit", "Trapper", "Napoleon", "Pepper", "Snowball", "Lacey", "Traveller", "Scout", "Little Joe", "Jigsaw", "Pirate", "Rembrandt", "Monte", "Baymax", "Goliath", "Universe", "Bolt", "Challenger", "Billie Jean", "Fargo", "Jet", "Victory", "Pharoah", "Trigger", "Champ", "Oakley", "Bonney", "Rio", "Dale", "Gene", "Cash", "Chisholm", "Misty", "Dolly", "Cookie", "Charlie Brown", "Kokomo", "Olaf", "Thelwell", "Isabelle", "Randolph", "Debutante", "Marquis", "Juliet", "Henrietta", "Vanderbilt", "Versailles", "El Jefe", "Queen", "Boots", "Major", "Barkley", "Barnaby", "Whiskers", "Balki", "Newton", "Tigger", "Buster", "Flopsy", "Paris", "Sicily", "Beijing", "Vancouver", "Utah", "Sydney", "Berlin", "Carolina", "Passport", "London", "Mozart", "Jackson", "Beethoven", "Mona", "Dickinson", "Bard", "Da Vinci", "Sullivan", "Chopin"
    ];

    foreach (idx, value in horses) {
        // crate
        local entry = SportEntries();

        // put data
        entry.type  = bkSpotTypes[1];
        entry.title = value;
        entry.wins  = random(3, 7);
        entry.total = random(3, 23);

        // insert into database
        entry.save();
        entries.push(entry);
    }

    return entries;
}

function bkSelectFixedAmount(type, amount) {
    local data = [];
    local source = shuffle(bkLoadedData.records);

    foreach (idx, value in source) {
        if (data.len() >= amount) break;
        if (value.type == type) data.push(value);
    }

    return data;
}

function bkShowList ( playerid ) {
    // Code
}

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
        local type = "horserace";
    }

    if (sport == 2) {
        msg(playerid, "==================================", CL_HELP_LINE);
        msg( playerid, "bk.selecthorse", BK_COLOR);

        local type = "baseball";
        }


    SportEvent.findBy({ winner = 0, type = type }, function(err, events) {
        foreach (idx, sprt in events) {
            sprt.getParticipants(function(err, teams) {
                foreach (idx, team in teams) {
                    print(team.title);
                }
            });
        }
    });


}

function bkBet ( playerid, sportid, amount ) {
    // Code
}



cmd("bk", function(playerid, sport = null) {
    bkOpen (playerid, sport);
});
