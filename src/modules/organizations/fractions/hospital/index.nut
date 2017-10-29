// cmd("hl", function(playerid, targeit) {

//     local fracs = fractions.getContaining(playerid);

//     if (fracs.len() < 0) {
//         return msg(playerid, "no");
//     }

//     local fraction = fracs[0];

//         if (! (fraction.shortcut == "hospital")) {
//             return msg(playerid, "no");
//         }

//         local role = fraction[playerid];

//         if (role.shortcut == "doctor") {
//             return msg(playerid, "hey doctor");
//         }
// })

fmd("hospital", ["heal"], "$f heal", function(fraction, character, targetid) {
    msg(character.playerid, "hey hostital member with 'heal' permission");
});

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
