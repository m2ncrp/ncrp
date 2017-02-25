include("controllers/fraction/classes/Fraction.nut");
include("controllers/fraction/classes/FractionRole.nut");
include("controllers/fraction/classes/FractionMember.nut");
include("controllers/fraction/classes/FractionContainer.nut");
// require("controllers/fraction/classes/FractionRoleContainer.nut");

fractions <- FractionContainer();

event("onServerStarted", function() {
    local __globalroles = {};

    Fraction.findAll(function(err, results) {
        foreach (idx, fraction in results) {
            fractions.add(fraction.id, fraction);

            if (fraction.shortcut) {
                fractions.add(fraction.shortcut, fraction);
            }
        }
    });

    FractionRole.findAll(function(err, results) {
        foreach (idx, role in results) {
            if (!fractions.exists(role.fractionid)) {
                dbg("fractions", "non existant fraction", role.fractionid, "with attached role", role.id);
                continue;
            }

            __globalroles[role.id] <- role;
            fractions[role.fractionid].roles.add(fractions[role.fractionid].roles.len(), role);
            // fractions[role.fractionid].__globalroles.add(role.id, role);

            if (role.shortcut) {
                fractions[role.fractionid].roles.add(role.shortcut, role);
            }
        }
    });

    local customFractionMember = "select m.id, m.characterid, m.fractionid, m.roleid, c.firstname, c.lastname from @FractionMember m left join @Character c on c.id = m.characterid";
    ORM.Query(customFractionMember).getResult(function(err, results) {
    // FractionMember.findAll(function(err, results) {
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
            fractions[member.fractionid].add(member.characterid, __globalroles[member.roleid], false);
            fractions[member.fractionid].members.set(member.characterid, { firstname = member.firstname, lastname = member.lastname, id = member.id });
        }
    });

    // local f = Fraction();
    // f.title = "ZE WATAFUCKZ";
    // f.created = getTimestamp();
    // f.shortcut = "WTF";
    // f.money = 124242.42;
    // f.save();

    // local fr = FractionRole();
    // fr.title = "BIG BO$$";
    // fr.created = getTimestamp();
    // fr.level = 0;
    // fr.fractionid = 1;
    // fr.save();

    // dbg(fr);

    // local fm = FractionMember();
    // fm.characterid = 1069;
    // fm.roleid = fr.id;
    // fm.fractionid = 1;
    // fm.created = getTimestamp();
    // fm.save();


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


});

cmd("f", "roles", function(playerid) {
    local fracs = fractions.getManaged(playerid);

    if (!fracs.len()) {
        return msg(playerid, "You are not fraction admin.", CL_WARNING);
    }

    // for now take the first one
    local fraction = fracs[0];

    msg(playerid, "List of roles in %s:", fraction.title, CL_INFO);

    foreach (idx, role in fraction.roles) {
        // skip duplicates for shortcuts
        if (idx == role.shortcut) continue;

        msg(playerid, format("#%d, Title: %s, Level: %d", idx, role.title, role.level));
    }
});

cmd("f", "list", function(playerid) {
    local fracs = fractions.getManaged(playerid);

    if (!fracs.len()) {
        return; // just silently close
    }

    // for now take the first one
    local fraction = fracs[0];

    msg(playerid, "List of members in %s:", fraction.title, CL_INFO);

    local counter = 0;
    foreach (idx, role in fraction.getMembers()) {
        // skip duplicates for shortcuts
        // if (idx == role.shortcut) continue;

        local callback = function(character) {
            if (!xPlayers.has(idx)) {
                xPlayers.add(idx, character);
            }

            msg(playerid, format("#%d, Name: %s, Role: %s, Level: %d", ++counter, character.firstname + " " + character.lastname, role.title, role.level));
        };

        if (xPlayers.has(idx)) {
            callback(xPlayers[idx]);
        } else {
            Character.findOneBy({ id = idx }, callback);
        }

        // local string = format("#%d, Title: %s, Level: %d", idx, role.title, role.level);
        // msg(playerid, string);
        // dbg(string);
    }
});

cmd("f", "invite", function(playerid, invitee, rolenum) {

});

cmd("tune", function(playerid, level) {
    if (!isPlayerInVehicle(playerid)) {
        return;
    }

    if (!fractions["brio"].exists(playerid)) {
        return;
    }

    local role = fractions["brio"][playerid];

    if (role.level > 3) {
        return;
    }

    // setVehicleTuningTable
});
