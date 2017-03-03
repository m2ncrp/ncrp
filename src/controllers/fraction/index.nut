include("controllers/fraction/classes/Fraction.nut");
include("controllers/fraction/classes/FractionRole.nut");
include("controllers/fraction/classes/FractionMember.nut");
include("controllers/fraction/classes/FractionProperty.nut");
include("controllers/fraction/classes/FractionContainer.nut");

FRACTION_FULL_PERMISSION      <- 0;
FRACTION_MONEY_PERMISSION     <- 1;
FRACTION_ROLESET_PERMISSION   <- 2;
FRACTION_INVITE_PERMISSION    <- 3;
FRACTION_VEHICLE_PERMISSION   <- 4;
FRACTION_CHAT_PERMISSION      <- 5;
FRACTION_NO_PERMISSION        <- 6;

include("controllers/fraction/functions.nut");

include("controllers/fraction/commands/general.nut");
include("controllers/fraction/commands/invite.nut");
include("controllers/fraction/commands/roles.nut");
include("controllers/fraction/commands/members.nut");
include("controllers/fraction/commands/vehicle.nut");
include("controllers/fraction/commands/money.nut");
include("controllers/fraction/commands/chat.nut");

fractions <- FractionContainer();

event("onServerStarted", function() {
    local __globalroles = {};

    Fraction.findAll(function(err, results) {
        foreach (idx, fraction in results) {
            if (fractions.has(fraction.id) || fractions.has(fraction.shortcut)) {
                dbg("fractions", "skipping duplicate:", fraction.id, fraction.shortcut);
                continue;
            }

            fractions.add(fraction.id, fraction);

            if (fraction.shortcut && fraction.shortcut != "") {
                fractions.add(fraction.shortcut, fraction);
            }
        }
    });

    // FractionRole.findAll(function(err, results) {
    ORM.Query("select * from @FractionRole order by level").getResult(function(err, results) {
        foreach (idx, role in results) {
            if (!fractions.exists(role.fractionid)) {
                dbg("fractions", "non existant fraction", role.fractionid, "with attached role", role.id);
                continue;
            }

            __globalroles[role.id] <- role;
            fractions[role.fractionid].roles.add(fractions[role.fractionid].roles.len(), role);
            // fractions[role.fractionid].__globalroles.add(role.id, role);

            if (role.shortcut && role.shortcut != "") {
                fractions[role.fractionid].sroles.add(role.shortcut, role);
            }
        }
    });

    FractionMember.findAll(function(err, results) {
        foreach (idx, member in results) {
            if (!fractions.exists(member.fractionid)) {
                dbg("fractions", "non existant fraction", member.fractionid, "with attached member", member.characterid);
                continue;
            }

            if (!(member.roleid in __globalroles)) {
                dbg("fractions", "non existant fraction role", member.roleid, "for fraction", member.fractionid, "with attached member", member.characterid);
                continue;
            }

            // fractions[member.fractionid].add(member.characterid, fractions[member.fractionid].__globalroles[member.roleid]);
            fractions[member.fractionid].memberRoles.set(member.characterid, __globalroles[member.roleid]);
        }
    });

    FractionProperty.findAll(function(err, results) {
        foreach (idx, object in results) {
            if (!fractions.exists(object.fractionid)) {
                dbg("fractions", "non existant fraction", object.fractionid, "with attached property", object.id);
                continue;
            }

            fractions[object.fractionid].property.add(object.entityid, object);
        }
    });
});








    // local f = Fraction();
    // f.title = "Testing fraction #1";
    // f.created = getTimestamp();
    // f.shortcut = "test1";
    // f.money = 100.00;
    // f.save();
// IS_DATABASE_DEBUG <- true;
//     local fr = FractionRole();
//     fr.title = "Leader";
//     fr.created = getTimestamp();
//     fr.level = 0;
//     fr.fractionid = 2;
//     fr.save();

//     dbg(fr);

    // local fr = FractionRole();
    // fr.title = "CoLeader";
    // fr.created = getTimestamp();
    // fr.level = 0;
    // fr.fractionid = 2;
    // fr.save();

    // local fr = FractionRole();
    // fr.title = "Manager";
    // fr.created = getTimestamp();
    // fr.level = 1;
    // fr.fractionid = 2;
    // fr.save();

    // local fr = FractionRole();
    // fr.title = "General Member";
    // fr.created = getTimestamp();
    // fr.level = 2;
    // fr.fractionid = 2;
    // fr.save();


    // fractions["WTF"][playerid] = fractions["WTF"].roles["Leader"]);

    // add new member to fraction (aliases)
    // fractions["brio"].add(playerid, 0);
    // fractions["brio"].add(playerid, "boss1");
    // fractions["brio"].add(playerid, fractions["brio"].roles[0]);
    // fractions["brio"].add(playerid, fractions["brio"].roles["boss1"]);

    // // check if player is int the fraction
    // fractions["brio"].has(playerid);

    // // remove player from fraction
    // fractions["brio"].remove(playerid);

    // // get player role
    // local role = fractions["brio"][playerid];

    // // operations
    // if (role.level > 3 || role.shortcut == "boss1") {
    //     dbg(playerid, "has role with title", role.title);
    // }

    // // rename role
    // role.title = "New boss";
    // role.save();

    // // add new role
    // local newrole = FractionRole();
    // newrole.fractionid = fractions["brio"].id;
    // newrole.title = "The Dvornik";
    // newrole.level = 4;
    // newrole.shortcut = "dvrn1";
    // newrole.save();
    // fractions["WTF"].roles.push(newrole);

// cmd("tune", function(playerid, level) {
//     if (!isPlayerInVehicle(playerid)) {
//         return;
//     }

//     if (!fractions["brio"].exists(playerid)) {
//         return;
//     }

//     local role = fractions["brio"][playerid];

//     if (role.level > 3) {
//         return;
//     }

//     // setVehicleTuningTable
// });


    // local customFractionMember = "select m.id, m.characterid, m.fractionid, m.roleid, c.firstname, c.lastname from @FractionMember m left join @Character c on c.id = m.characterid";
    // ORM.Query(customFractionMember).getResult(function(err, results) {
