//fmd("hospital", ["heal"], "$f heal", function(fraction, character, targetid) {
//    msg(character.playerid, "hey hostital member with 'heal' permission");
//});

/*
fmd("*", ["admin.kick2"], "$f hhh", function(fraction, character) {
    msg(character.playerid, "тесто");
});*/

event("onServerStarted", function() {
    log("[hospital]=========================================...");
});

/*
1. fractions.exists(shortcut)
2.
                    if (!fraction.members.exists(characterID)) {
                     fractions.hospital.members.exists(4)
                        return;
                    }
3.
                   if (!fraction.members.get(character).permitted(permissions)) {
                        return msg(vargv[0], "fraction.permission.error", CL_ERROR);
                    }
        */
/* EXAMPLE:
function killEveryone() {
    local hospital = Fraction();
    hospital.title = "Hospital";
    hospital.type = "government";
    hospital.shortcut = "hos";
    hospital.save();

    local doctor = FractionRole();
    doctor.title = "Doctor";
    doctor.fractionid = hospital.id;
    doctor.data.permissions <- [ "hospital.heal", "hospital.kill"];
    doctor.save();

    local member = FractionMember();
    member.fractionid = hospital.id;
    member.roleid = doctor.id;
    member.characterid = 1;
    member.save();

    hospital.roles.push(doctor);

}



                                           //it's true
fmd("police", ["police.kill"], ["$f kill",     "$fk"     ], function (fraction, character, targetid) {
    killPlayer(targetid);
    msg(character.playerid, "You killed Johny");
});

*/


/*
select * from tbl_vehicles where ownerid = 256 or ownerid = 1090

select * from tbl_characters where accountid = 138 or accountid = 969
*/
