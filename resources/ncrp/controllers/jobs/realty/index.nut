include("controllers/jobs/realty/commands.nut");

function isRealtor (playerid) {
    return (isPlayerHaveValidJob(playerid, "realtor"));
}

function realtyJobSell (playerid, targetid, price) {

    if (!isRealtor(playerid)) {
        return msg(playerid, "You're not a realtor.");
    }

    local price = price.tofloat();
    local targetid = targetid.tointeger();

    msg(playerid, "You send invoice to pay house.", CL_GREEN);
    msg(targetid, "You received invoice to pay house.", CL_GREEN);

    sendInvoice(playerid, targetid, price, function(playerid, senderid, result) {
        // playerid responded to invoice from senderid with result
        // (true - acepted / false - declined)
        if(result == true) {
            // get and save coords for playerid as customer from senderid as realtor
            local plaPos = getPlayerPositionObj(playerid.tointeger());
            players[playerid]["housex"]       = plaPos.x;
            players[playerid]["housey"]       = plaPos.y;
            players[playerid]["housez"]       = plaPos.z;
            msg(playerid, "You'll bought the house.", CL_GREEN);
            msg(senderid, "Customer paid. House has been sold. ", CL_GREEN);
        } else {
            msg(playerid, "You can't buy house without payment.", CL_RED);
            msg(senderid, "Customer did not pay.", CL_RED);
        }
    });
}
