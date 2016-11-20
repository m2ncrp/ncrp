cmd( ["money"], function( playerid ) {
    msg( playerid, "Your cash: $" + getPlayerBalance(playerid) );
});

cmd( ["give", "send"], function( playerid, targetid, amount ){
    sendMoney(playerid, targetid, amount)
});

cmd( ["invoice"], function( playerid, targetid, amount ){
    sendInvoice(playerid, targetid, amount);
});

cmd( ["accept"], function( playerid, senderid ){
    invoiceAccept(playerid, senderid);
});

cmd( ["decline"], function( playerid, senderid){
    invoiceDecline(playerid, senderid);
});
