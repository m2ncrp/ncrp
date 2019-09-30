cmd( ["money"], function( playerid ) {
    msg( playerid, "money.cash", [ getPlayerBalance(playerid) ], CL_SUCCESS );
});

cmd( ["give", "send"], sendMoney );
//cmd( ["invoice"], sendInvoice );
//cmd( ["accept"], invoiceAccept );
//cmd( ["decline"], invoiceDecline );

cmd( ["pay"], invoiceAcceptNew );
cmd( ["cancel"], invoiceDeclineNew );
