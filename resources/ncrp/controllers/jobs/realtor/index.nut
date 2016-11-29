translation("en", {
"job.realtor" : "realtor"
"job.realtor.not" : "You're not a realtor."
"job.realtor.sendinvoice" : "You send invoice to pay house."
"job.realtor.receivedinvoice" : "You received invoice to pay house."
"job.realtor.boughthouse" : "You'll bought the house."
"job.realtor.customerpaid" : "Customer paid. House has been sold. "
"job.realtor.youcantbuy" : "You can't buy house without payment."
"job.realtor.customer" : "Customer did not pay."
});

translation("ru", {
"job.realtor" : "риэлтор"
"job.realtor.not" : "Вы не риэлтор."
"job.realtor.sendinvoice" : "Вы отправили запрос на оплату покупки дома."
"job.realtor.receivedinvoice" : "Вы получили запрос на оплату покупки дома."
"job.realtor.boughthouse" : "Поздравляем с приобретением дома!."
"job.realtor.customerpaid" : "Покупатель подтвердил оплату. Дом продан. "
"job.realtor.youcantbuy" : "Вы должны оплатить покупку дома."
"job.realtor.customer" : "Покупатель не подтвердил оплату."
});

include("controllers/jobs/realtor/commands.nut");

event("onServerStarted", function() {
    log("[jobs] loading realtor job...");
});

function isRealtor (playerid) {
    return (isPlayerHaveValidJob(playerid, "realtor"));
}

function realtyJobSell (playerid, targetid, price) {

    if (!isRealtor(playerid)) {
        return msg(playerid, "job.realtor.not");
    }

    local price = price.tofloat();
    local targetid = targetid.tointeger();

    msg(playerid, "job.realtor.sendinvoice", CL_GREEN);
    msg(targetid, "job.realtor.receivedinvoice", CL_GREEN);

    sendInvoice(playerid, targetid, price, function(playerid, senderid, result) {
        // playerid responded to invoice from senderid with result
        // (true - acepted / false - declined)
        if(result == true) {
            // get and save coords for playerid as customer from senderid as realtor
            local plaPos = getPlayerPositionObj(playerid.tointeger());
            players[playerid]["housex"]       = plaPos.x;
            players[playerid]["housey"]       = plaPos.y;
            players[playerid]["housez"]       = plaPos.z;
            msg(playerid, "job.realtor.boughthouse", CL_GREEN);
            msg(senderid, "job.realtor.customerpaid", CL_GREEN);
        } else {
            msg(playerid, "job.realtor.youcantbuy", CL_RED);
            msg(senderid, "job.realtor.customer", CL_RED);
        }
    });
}
