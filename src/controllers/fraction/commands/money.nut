cmd("f", ["money", "add"], function(playerid, amount) {
    // add money to fract (to all frac members)
});

cmd("f", ["money", "sub"], function(playerid, amount) {
    // sub money from fract, only for admins (role.level == 0)
});

cmd("f", "money", function(playerid) {
    // list amount of money
});
