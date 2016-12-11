include("modules/organizations/bookmakers/models/SportMember.nut");
include("modules/organizations/bookmakers/models/SportEvent.nut");

const BK_RADIUS = 4.0;
/*
const BK_X =  -682.184;
const BK_Y = -54.8196;
const BK_Z = 1.0381;
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
    local winners = [];
    //dbg(getHour());


   // if (getHour() != 19) return;

    SportEvent.findBy({ winner = 0 }, function(err, events) {
        foreach (idx, sprt in events) {
            sprt.getParticipants(function(err, teams) {

                // add win to random winner
                local chances = split( sprt.chances , ",");
                chances.remove(0);
                //dbg( chances );

                local winner = null;
                local max = 0;

                foreach (idy, team in teams) {
                    //dbg(idy+". "+team.id);
                    local v =  pow(chances[idy].tofloat(), (team.wins.tofloat() / team.total.tofloat()));
                    if (v > max) {
                        winner = idy;
                        max = v;
                    }
                    team.total++;
                    team.save();
                }

                teams[winner].wins++;
                // save winner id
                sprt.winner = teams[winner].id;
                winners.push(teams[winner].id);

                sprt.save();

/*
                // add totals to all and save
                foreach (idx, team in teams) {
                    team.total++;
                    team.save();
                }
*/




                //local winner = teams[random(0, teams.len() - 1)];
//                winner.wins++;

                // add totals to all and save
//                foreach (idx, team in teams) {
//                    team.total++;
//                    team.save();
//                }

                // save winner id
//                sprt.winner = winner.id;

//                winners.push(winner.id);
//                sprt.save();
            });
        }
    });


    //dbg( array_unique(winners) );


    SportBet.findAll(function(err, bets) {
        foreach (idx, value in bets) {
            if(winners.find(value.participant) != null)
            {
/*
                local wins  = bkLoadedData.members[value.participant].wins.tofloat();
                local total = bkLoadedData.members[value.participant].total.tofloat();

                return 10-round( (wins.tofloat() / total.tofloat()), 1)*10;
*/
                local playerid = getPlayerIdFromName( value.name );
                local prize = value.amount.tofloat() * value.fraction.tofloat();
                if( playerid != INVALID_ENTITY_ID )
                {
                    addMoneyToDeposit(playerid, prize );
                    msg( playerid, "bk.betwin", [bkLoadedData.members[(value.participant-1)].title, prize ] );
                }
                else
                {
                    dbg( playerid+" - player not found!" );
                    ORM.Query("update @Character set deposit = deposit + :prize where name = ':name'")
                    .setParameter("prize", prize)
                    .setParameter("name", value.name)
                    .execute();
                }
            }
            value.remove();
        }

        //          //return 10-round( (wins.tofloat() / total.tofloat()), 1)*10;
    });


    // add new bets
    if (getHour() == 0)  { bkCreateEvent(); }


});




//-------------------------------------------------------------------------------------------------------------------------------------------------------------------


function bkCreateEvent () {

// create horserace events 8 shtuk
    local data = bkSelectFixedAmount("horserace", 8);
    local sprt = SportEvent();
    local coefob = 0;
    local coefwins = [];

    foreach (idx, value in data) {
        local coefwin = value.wins.tofloat() / (value.wins.tofloat()+value.total.tofloat());
        coefwins.push( coefwin );
        coefob = coefob + coefwin;
    }

    foreach (idx, value in data) {
        sprt.addParticipant(value);
        sprt.addChance(  bkFindCoef (coefwins[idx], coefob)  );
        bkLoadedData.current.horses.push(value);
    }

    sprt.type = "horserace";
    sprt.date = getDate();
    sprt.save();

    print("saved with id: " + sprt.id);



// create baseball events PARA
    for (local i = 0; i < 5; i++) {

        local data = bkSelectFixedAmount("baseball", 2);
        local sprt = SportEvent();
        local coefob = 0;
        local coefwins = [];

        foreach (idx, value in data) {
            local coefwin = value.wins.tofloat() / (value.wins.tofloat()+value.total.tofloat());
            coefwins.push( coefwin );
            coefob = coefob + coefwin;
        }

        foreach (idx, value in data) {
            sprt.addParticipant(value);
            sprt.addChance(  bkFindCoef (coefwins[idx], coefob)  );
            bkLoadedData.current.teams.push(value);
        }

        sprt.type = "baseball";
        sprt.date = getDate();
        sprt.save();

        print("saved with id: " + sprt.id);
    }

    // load current events
    SportEvent.findAll(function(err, results) {
        bkLoadedData.events = (!results.len()) ? bkCreateEvent() : results;
    });
}

function bkFindCoef (coefwins, coefob) {
    local veroyat = 100 * coefwins / coefob;
    local coef_eng = 1 / (veroyat / 100);
    local offset = randomf(-100.0, 100.0)/78.0;
    local coef_eng_bk = coef_eng - offset;
    coef_eng_bk = round( coef_eng_bk, 2);
    return coef_eng_bk;
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
    local source = shuffle(bkLoadedData.members);

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
    "bk.goto"               : "Go to betting office in West Side"
    "bk.selectsport"        : "Select sport:"
    "bk.toselectsport"      : "To select sport use: /bk ID"
    "bk.baseball"           : "1. Horse riding"
    "bk.horseriding"        : "2. Baseball"

    "bk.selectteam"         : "Select team to bet:"
    "bk.selecthorse"        : "Select horse to bet:"
    "bk.emptylist"          : "No available bets. Come later."
    "bk.toselectteam"       : "To put money use: /bk ID AMOUNT"
    "bk.toselecthorse"      : "To put money use: /bk ID AMOUNT"

    "bk.needselectsport"    : "You need select sport before to bet."
    "bk.notenough"          : "Not enough money."
    "bk.bettoomuch"         : "Amount of bet is too high."
    "bk.betnotfound"        : "You can put money only to participants from list."
    "bk.betmade"            : "You bet $%.2f to win on %s."
    "bk.betwin"             : "You bet on %s has won. You earn $%.2f."

});

/*
Bet a horse to win, and if he finishes first, you collect.
For example: "$5 to win on Number 1."
Example: If you bet a "$5 Perfecta Number 5 and 6",you collect if horses 5 and 6 finish first and second. Can also be called an Exacta.
 */
//---------------------------------------------------------------------------------------------------------------




function bkOpen ( playerid, type = null) {

    if(!isPlayerInValidPoint(playerid, BK_X, BK_Y, BK_RADIUS)) {
        return msg( playerid, "bk.goto", BK_COLOR );
    }

    if (type == null) {
        msg(playerid, "==================================", CL_HELP_LINE);
        msg( playerid, "bk.selectsport", BK_COLOR);
        msg( playerid, "bk.baseball");
        msg( playerid, "bk.horseriding");
        msg( playerid, "bk.toselectsport", BK_COLOR);
        return;
    }

    local count = 1;
    if (type == "2") {
        msg( playerid, "==================================", CL_HELP_LINE );
        msg( playerid, "bk.selectteam", BK_COLOR);
        local pusto = false;
        foreach (idx, event in bkLoadedData.events) {
            if (event.winner==0) {
                local currentmembers = split(event.participants, ",");
                local currentchances = split(event.chances, ",");
                if (event.type == "baseball") {

                    local id1 = bkLoadedData.members[ (currentmembers[1].tointeger() - 1)];
                    local id2 = bkLoadedData.members[ (currentmembers[2].tointeger() - 1)];

                    local coef1 = currentchances[1];
                    local coef2 = currentchances[2];

                    msg( playerid, "["+count+"] "+id1.title+" ("+coef1+")   -   ["+(count+1)+"] "+id2.title+" ("+coef2+")");
                    count += 2;
                    pusto = false;
                }
            } else { pusto = true; }
        }
        if (pusto == true) { msg( playerid, "bk.emptylist"); }
        msg( playerid, "bk.toselectteam", BK_COLOR);
        bk_player[playerid]["bet"] <- "baseball";
    }
     if (type == "1") {
        msg( playerid, "==================================", CL_HELP_LINE );
        msg( playerid, "bk.selecthorse", BK_COLOR);
        local pusto = false;
        foreach (idx, event in bkLoadedData.events) {
            if (event.winner == 0) {
                local currentmembers = split(event.participants, ",");
                local currentchances = split(event.chances, ",");
                if (event.type == "horserace") {
                    foreach (i, member in currentmembers) {
                        if (member == "0") continue;
                        local mid = bkLoadedData.members[ (member.tointeger() - 1)]
                        local coef = currentchances[i]; //bkFindCoef(mid.wins, mid.total);
                        msg( playerid, i+". "+mid.title+" ("+coef+")");
                        pusto = false;
                    }
                }
            } else { pusto = true; }
        }
        if (pusto == true) { msg( playerid, "bk.emptylist"); }
        msg( playerid, "bk.toselecthorse", BK_COLOR);
        bk_player[playerid]["bet"] <- "horserace";
    }
}


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------

function bkGetHorseIdByNumber( id = null) {
    foreach (idx, event in bkLoadedData.events) {
        local currentmembers = split(event.participants, ",");
        local currentchances = split(event.chances, ",");
        if (event.type == "horserace" && event.winner == 0) {
            foreach (i, member in currentmembers) {
                if (member == "0") continue;
                if (i == id) {
                    local stavka = currentchances[(i)];
                    dbg("stavka: "+stavka);
                    return [member.tointeger(), stavka ];
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
        local currentchances = split(event.chances, ",");
        if (event.type == "baseball" && event.winner == 0) {
            if (id == (count+pos) ) {
            local id = bkLoadedData.members[ (currentmembers[(1+pos)].tointeger() - 1)].id;
            local stavka = currentchances[(pos)];
            dbg("stavka: "+stavka);
            return [id.tointeger(), stavka ];
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

    local amount = round(fabs(amount.tofloat()), 2);

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
    bet.participant = participant[0].tointeger();
    bet.amount = amount;

    bet.fraction = participant[1].tofloat();
    bet.save();

    subMoneyToPlayer( playerid, amount );
    msg(playerid, "bk.betmade", [amount, bkLoadedData.members[(participant[0]-1)].title], BK_COLOR);
}


//-------------------------------------------------------------------------------------------------------------------------------------------------------------------

//BOOKMAKER_ENABLED <- true;
// sq BOOKMAKER_ENABLED = false

cmd("bk", function(playerid, sportORnumber = null, amount = null) {
    if (amount != null) {
        bkBet (playerid, sportORnumber, amount);
        return;
    }
    bkOpen ( playerid, sportORnumber );
});


function drob (a, b) {
    local nod = nod (a, b);
    local a1 = a / nod;
    local b1 = b / nod;
    return a1+"/"+b1;
}


function nod (a, b) {
    local a = abs(a);
    local b = abs(b);
    while (a != b) {
        if (a > b) {
            a -= b;
        } else {
            b -= a;
        }
    }
    return a;
}


function bkFindCoefHernya ( a, b ) {
    //return 10-round( (wins.tofloat() / total.tofloat()), 1)*10;

    local nod = nod (a, b);
    local a1 = a / nod;
    local b1 = b / nod;

return a1+"/"+b1;

/* (a1.tofloat()/b1.tofloat()+1.0) */

}





function bkSimple (num) {

    local num = num.tofloat();
    local chis = (num%1)*100;
        dbg("chis: "+chis);
    local tseloe = floor(num);
        dbg("tseloe: "+tseloe);
    local nodd = nod(chis, 100);
        dbg("nodd: "+nodd);
    local znam = 100 / nodd;
    local chis = (tseloe * znam) + (chis / nodd);
    dbg("chis|znam "+chis+"|"+znam);
}


function bkPeriodic (num) {

    local num = num.tostring();
        dbg("num: "+num);
    num = num.slice(0, 4);
        dbg("num slice: "+num);
    local posle = num.slice(2, 4);
        dbg("posle: "+posle);
    if (posle.find("0")) {
        posle = posle.slice(1, 2);
            dbg("if posle: "+posle);
    }  // если [0,]66 => 66, если [0,]06 => 6

    local val_do = posle.slice(0, 1);
        dbg("val_do: "+val_do);
    local chis = posle.tofloat() - fabs(val_do.tofloat());   // выполнили 6 пункт
        dbg("chis: "+chis);
    local znam = 90.0;
    local nd = nod(chis, znam);
    local ekran_chis = chis/nd;
    local ekran_znam = znam/nd;
        dbg("ekran: "+ekran_chis+"|"+ekran_znam);
    //return ekran;
}


