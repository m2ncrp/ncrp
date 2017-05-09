cmd("hl", function(playerid, targeit) {

    local fracs = fractions.getContaining(playerid);

    if (fracs.len() < 0) {
        return msg(playerid, "no");
    }

    local fraction = fracs[0];

        if (! (fraction.shortcut == "hospital")) {
            return msg(playerid, "no");
        }

        local role = fraction[playerid];

        if (role.shortcut == "doctor") {
            return msg(playerid, "hey doctor");
        }
})

/*
select * from tbl_vehicles where ownerid = 256 or ownerid = 1090

select * from tbl_characters where accountid = 138 or accountid = 969
*/
