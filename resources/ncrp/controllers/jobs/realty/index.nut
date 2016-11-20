include("controllers/jobs/realty/commands.nut");

function isRealtor (playerid) {
    return (isPlayerHaveValidJob(playerid, "realtor"));
}

function realtyJobSell (playerid, targetid, price) {

    if (!isRealtor(playerid)) {
        return msg(playerid, "You're not a realtor.");
    }

    local targetPos = getPlayerPositionObj(targetid.tointeger());
    local price = price.tofloat();
    local targetid = target.tointeger();
    sendInvoice(playerid, targetid, price);

}
