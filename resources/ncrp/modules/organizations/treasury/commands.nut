acmd(["treasury", "treas"], "get", function( playerid) {
    msg(playerid, "treasury.get", getMoneyTreasury() );
});


acmd(["treasury", "treas"], "add", function( playerid, amount = 0.0) {
    addMoneyToTreasury(amount);
    msg(playerid, "treasury.add", [ amount.tofloat(), getMoneyTreasury() ], CL_EUCALYPTUS );
});


acmd(["treasury", "treas"], "sub", function( playerid, amount = 0.0) {
    subMoneyToTreasury(amount);
    msg(playerid, "treasury.sub", [ amount.tofloat(), getMoneyTreasury() ], CL_THUNDERBIRD );
});
