 include("modules/organizations/bookmakers/models/SportMember.nut");
 include("modules/organizations/bookmakers/models/SportEvent.nut");
 include("modules/organizations/bookmakers/models/SportBet.nut");

 const BK_RADIUS = 2.0;

 const BK_X =  -50.2636;
 const BK_Y = 743.157;
 const BK_Z = -17.851;
 /*
 const BK_X = -416.889;
 const BK_Y = 474.576;
 const BK_Z = -0.238935;
 */
 const BK_HORSE_MIN = 50.0;
 const BK_HORSE_MAX = 12000.0;
 const BK_GREYHOUND_MIN = 30.0;
 const BK_GREYHOUND_MAX = 8000.0;
 const BK_TEAM_MIN = 100.0;
 const BK_TEAM_MAX = 15000.0;
       BK_COLOR <- CL_PICTONBLUEDARK;

 local BOOKMAKER_ENABLED = true;
 local bk_player = {};
 local bkSpotTypes = [
     "baseball",
     "horserace",
     "greyhoundrace"
 ];

 local bkLoadedData = {
     members = [],
     events  = [],
     current = {
         horses = [],
         greyhounds = [],
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

     create3DText ( BK_X, BK_Y, BK_Z+0.35, "BOOKMAKER", CL_ROYALBLUE, 4.0 );
     create3DText ( BK_X, BK_Y, BK_Z+0.20, "/bk  or  /bm", CL_WHITE.applyAlpha(100), 2.0 );

     createBlip  (  BK_X, BK_Y, [ 0, 9 ], 4000.0);

 });

 event("onServerHourChange", function() {
     local winners = [];

     if (getHour() != 19) return;

     SportEvent.findBy({ winner = 0 }, function(err, events) {
         foreach (idx, sprt in events) {
             sprt.getParticipants(function(err, teams) {

                 // add win to random winner
                 local chances = split( sprt.chances , ",");
                 chances.remove(0);
                 //dbg( chances );

                 local winner = null;
                 local max = 0;

                 local winner = teams[random(0, teams.len() - 1)];
                 winner.wins++;

                 foreach (idx, team in teams) {
                     team.total++;
                     team.save();
                 }

                 // save winner id
                 sprt.winner = winner.id;
                 winners.push(winner.id);
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

                 local playerid = getPlayerIdFromName( value.name );
                 local prize = value.amount.tofloat() * value.fraction.tofloat();
                 if( playerid != INVALID_ENTITY_ID )
                 {
                     addMoneyToDeposit(playerid, prize );
                     msg( playerid, "bk.betwin", [bkLoadedData.members[(value.participant-1)].title, prize ] );
                 } else {
                     dbg( playerid+" - player not found!" );
                     ORM.Query("update @Character set deposit = deposit + :prize where name = ':name'")
                     .setParameter("prize", prize)
                     .setParameter("name", value.name)
                     .execute();
                 }
             }
             value.remove();
         }
     });

     // load current events
     SportEvent.findAll(function(err, results) {
         bkLoadedData.events = (!results.len()) ? bkCreateEvent() : results;
     });

     // add new bets
     if (getHour() == 0)  {
         bkCreateEvent();
     }
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

     print("horserace saved with id: " + sprt.id);

 // create greyhound race events 8 shtuk
     local data = bkSelectFixedAmount("greyhoundrace", 8);
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
         bkLoadedData.current.greyhounds.push(value);
     }

     sprt.type = "greyhoundrace";
     sprt.date = getDate();
     sprt.save();

     print("greyhoundrace saved with id: " + sprt.id);

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
             sprt.addChance(  bkFindCoefBaseBall (coefwins[idx], coefob)  );
             bkLoadedData.current.teams.push(value);
         }

         sprt.type = "baseball";
         sprt.date = getDate();
         sprt.save();

         print("baseball saved with id: " + sprt.id);
     }

     // load current events
     SportEvent.findAll(function(err, results) {
         bkLoadedData.events = (!results.len()) ? bkCreateEvent() : results;
     });
 }

 function bkFindCoef (coefwins, coefob) {
     local veroyat = 100 * coefwins / coefob;
     local coef_eng = 1 / (veroyat / 100);
     local offset = randomf(-100.0, 100.0)/randomf(25, 75);
     local coef_eng_bk = coef_eng - offset;
     coef_eng_bk = round( coef_eng_bk, 2);
     return coef_eng_bk;
 }

 function bkFindCoefBaseBall (coefwins, coefob) {
     local veroyat = 100 * coefwins / coefob;
     local coef_eng = 1 / (veroyat / 100);
     local offset = randomf(-15.0, 35.0)/randomf(15, 35);
     local coef_eng_bk = coef_eng - offset + 1.0;
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
     if (type == "greyhoundrace") {
         ORM.Query("delete from @SportEvent where type = 'greyhoundrace'").execute();
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

     local greyhounds = [
         "Riley", "Oscar", "Bandit", "Pepper", "Beau", "Sparky", "Lucky", "Sam", "Shadow", "Rusty", "Ben", "Felix", "Gaius", "Jack", "Archie", "Apollo", "Gideon", "Jesse", "Mickey", "Rudy", "Maximus", "Buster", "Cody", "Cain", "Ezra", "Duke", "Bobby", "Murphy", "Rufus", "Chaos", "Jett", "Jinx", "Bruno", "Rocky", "Bailey", "Winston", "Toby", "Josh", "Jake", "Sammy", "Casey", "Ragnor", "Rogue", "Sabre", "Charlie", "Tucker", "Teddy", "Gizmo", "Samson", "Jagger", "Scout", "Max", "Buddy", "Spike", "Simba", "Gus", "Dylan", "Smoky", "Wolf", "Vulcan", "Pluto", "Pax", "Caesar", "Duke", "Prince", "Juno", "Misty", "Lady", "Sasha", "Abby", "Roxy", "Missy", "Brandy", "Coco", "Annie", "Daisy", "Lucy", "Sadie", "Ginger", "Precious", "Bella", "Angel", "Leah", "Mara", "Persis", "Candy", "Princess", "Kishi", "Rosie", "Misty", "Duchess", "Vicki", "Venus", "Flora", "Cassie", "Zoe", "Dixie", "Sugar", "Zara", "Lola", "Honey", "Sophie", "Bella", "Cinders", "Empress", "Bobbi", "Chloe", "Emma", "Sandy", "Lily", "Penny", "Maddy", "Pepper", "Sheba", "Tasha", "Baby", "Cleo", "Sammy", "Molly", "Maggie", "Phoebe", "Reba", "Katie", "Gracie", "Abby", "Charlie", "Jasmine", "Holly", "Ruby", "Sassy"
     ];

     foreach (idx, value in greyhounds) {
         // crate
         local member = SportMember();

         // put data
         member.type  = bkSpotTypes[2];
         member.title = value;
         member.wins  = random(3, 5);
         member.total = member.wins + random(4, 8);

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
     "bk.disabled"           : "[BM] Bookmaker's office closed. Come later."
     "bk.goto"               : "[BM] Go to bookmaker at Freddy's Bar on second floor."
     "bk.selectsport"        : "[BM] Select sport:"
     "bk.toselectsport"      : "[BM] To select sport use: /bk ID"
     "bk.horseriding"        : "1. Horse riding"
     "bk.greyhound"          : "2. Greyhound racing"
     "bk.baseball"           : "3. Baseball"

     "bk.selectteam"         : "[BM] Select team to bet:"
     "bk.selecthorse"        : "[BM] Select horse to bet:"
     "bk.selectdog"          : "[BM] Select greyhound to bet:"
     "bk.emptylist"          : "[BM] No available bets. Come later."
     "bk.toselectteam"       : "[BM] Min: $%s, Max: $%s. To put money use: /bk ID AMOUNT"
     "bk.toselecthorse"      : "[BM] Min: $%s, Max: $%s. To put money use: /bk ID AMOUNT"
     "bk.toselectdog"        : "[BM] Min: $%s, Max: $%s. To put money use: /bk ID AMOUNT"

     "bk.needselectsport"    : "[BM] You need select sport before to bet."
     "bk.notenough"          : "[BM] Not enough money."
     "bk.bettoomuch"         : "[BM] Amount of bet is too high."
     "bk.bettoolow"          : "[BM] Amount of bet is too low."
     "bk.betnotfound"        : "[BM] You can put money only to participants from list."
     "bk.betmade"            : "[BM] You bet $%.2f to win on %s."
     "bk.betwin"             : "[BM] Your bet on %s has won. You earn $%.2f."
     "bk.betlose"            : "[BM] Your bet on %s has lost. You lose $%.2f."
 });

 /*
 Bet a horse to win, and if he finishes first, you collect.
 For example: "$5 to win on Number 1."
 Example: If you bet a "$5 Perfecta Number 5 and 6",you collect if horses 5 and 6 finish first and second. Can also be called an Exacta.
  */
 //---------------------------------------------------------------------------------------------------------------


 function bkOpen ( playerid, type = null) {

     if(!isPlayerInValidPoint3D(playerid, BK_X, BK_Y, BK_Z, BK_RADIUS)) {
         return msg( playerid, "bk.goto", BK_COLOR );
     }

     if (type == null) {
         msg(playerid, "==================================", CL_HELP_LINE);
         msg( playerid, "bk.selectsport", BK_COLOR);
         msg( playerid, "bk.horseriding");
         msg( playerid, "bk.greyhound");
         msg( playerid, "bk.baseball");
        msg( playerid , "bk.toselectsport", BK_COLOR);
         return;
     }

     local count = 1;
     if (type == "3") {
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
         msg( playerid, "bk.toselectteam", [BK_TEAM_MIN.tostring(), BK_TEAM_MAX.tostring()], BK_COLOR);
         bk_player[playerid]["bet"] <- "baseball";
     }
      if (type == "2") {
         msg( playerid, "==================================", CL_HELP_LINE );
         msg( playerid, "bk.selectdog", BK_COLOR);
         local pusto = true;
         foreach (idx, event in bkLoadedData.events) {
             if (event.winner == 0 && event.type == "greyhoundrace") {
                 local currentmembers = split(event.participants, ",");
                 local currentchances = split(event.chances, ",");

                     foreach (i, member in currentmembers) {
                         if (member == "0") continue;
                         local mid = bkLoadedData.members[ (member.tointeger() - 1)]
                         local coef = currentchances[i]; //bkFindCoef(mid.wins, mid.total);
                         msg( playerid, i+". "+mid.title+" ("+coef+")");
                         pusto = false;
                     }
             }
         }
         if (pusto == true) { msg( playerid, "bk.emptylist"); }
         msg( playerid, "bk.toselectdog", [BK_GREYHOUND_MIN.tostring(), BK_GREYHOUND_MAX.tostring()], BK_COLOR);
         bk_player[playerid]["bet"] <- "greyhoundrace";
     }
      if (type == "1") {
         msg( playerid, "==================================", CL_HELP_LINE );
         msg( playerid, "bk.selecthorse", BK_COLOR);
         local pusto = true;
         foreach (idx, event in bkLoadedData.events) {
             if (event.winner == 0 && event.type == "horserace") {
                 local currentmembers = split(event.participants, ",");
                 local currentchances = split(event.chances, ",");

                     foreach (i, member in currentmembers) {
                         if (member == "0") continue;
                         local mid = bkLoadedData.members[ (member.tointeger() - 1)]
                         local coef = currentchances[i]; //bkFindCoef(mid.wins, mid.total);
                         msg( playerid, i+". "+mid.title+" ("+coef+")");
                         pusto = false;
                     }
             }
         }
         if (pusto == true) { msg( playerid, "bk.emptylist"); }
         msg( playerid, "bk.toselecthorse", [BK_HORSE_MIN.tostring(), BK_HORSE_MAX.tostring()], BK_COLOR);
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
                     return [member.tointeger(), stavka ];
                 }
             }
         }
     }
 }

 function bkGetGreyhoundIdByNumber( id = null) {
     foreach (idx, event in bkLoadedData.events) {
         local currentmembers = split(event.participants, ",");
         local currentchances = split(event.chances, ",");
         if (event.type == "greyhoundrace" && event.winner == 0) {
             foreach (i, member in currentmembers) {
                 if (member == "0") continue;
                 if (i == id) {
                     local stavka = currentchances[(i)];
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

       local participant = null;
         if(type == "horserace") {

             if ( amount > BK_HORSE_MAX) {
                 return msg(playerid, "bk.bettoomuch", CL_RED);
             }

             if ( amount < BK_HORSE_MIN) {
                 return msg(playerid, "bk.bettoolow", CL_RED);
             }

             participant = bkGetHorseIdByNumber( number.tointeger() );
         }
         else if(type == "greyhoundace") {

             if ( amount > BK_GREYHOUND_MAX) {
                 return msg(playerid, "bk.bettoomuch", CL_RED);
             }

             if ( amount < BK_GREYHOUND_MIN) {
                 return msg(playerid, "bk.bettoolow", CL_RED);
             }

             participant = bkGetGreyhoundIdByNumber( number.tointeger() );
         }
         else if(type == "baseball") {

             if ( amount > BK_TEAM_MAX) {
                 return msg(playerid, "bk.bettoomuch", CL_RED);
             }

             if ( amount < BK_TEAM_MIN) {
                 return msg(playerid, "bk.bettoolow", CL_RED);
             }

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

 cmd(["bk", "bm"], function(playerid, sportORnumber = null, amount = null) {
     if (!BOOKMAKER_ENABLED) {
         return msg(playerid, "bk.disabled", BK_COLOR);
     }
     if (amount != null) {
         bkBet (playerid, sportORnumber, amount);
         return;
     }
     bkOpen ( playerid, sportORnumber );
 });

// used: /bk status on/off
 acmd(["bk", "bm"], "status", function(playerid, status) {
     if (status == "on") {
         BOOKMAKER_ENABLED = true;
         return msg(playerid, "[BM] Bookmaker's office has been enabled.", BK_COLOR);
     } else {
         BOOKMAKER_ENABLED = false;
         return msg(playerid, "[BM] Bookmaker's office has been disabled.", BK_COLOR);
     }
 });

