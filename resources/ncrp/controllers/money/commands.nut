cmd( ["money"], function( playerid ) {
    msg( playerid, "Your balance: $" + getPlayerBalance(playerid) );
});


cmd( ["send"], function( playerid, targetid, amount ){ 
	transfer(playerid, targetid, amount);
});