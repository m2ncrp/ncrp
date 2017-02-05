acmd("setmlvl", function(playerid, targetid = null, lvl = null) {
    if(!targetid || !lvl){
        return msg(playerid, "USE: /setmlvl targetid lvl");
    }
    targetid = targetid.tointeger();
    lvl = lvl.tointeger();
    players[targetid].mlvl = lvl;
    msg(targetid, format("Вас назначили модератором '%i' уровня.", lvl),CL_RED);
    msg(playerid, format("Вы назначили '%s' модератором '%i' уровня.",getPlayerName(targetid),lvl ),CL_RED);
});

acmd("getmlvl", function(playerid, targetid = null) {
    if(!targetid){
        return msg(playerid, "USE: /getmlvl targetid ");
    }
    targetid = targetid.tointeger();
    msg(playerid, format("Игрок '%s' | Уровень - '%i'.",getPlayerName(targetid),players[targetid].mlvl),CL_RED);
});

cmd("h",function(playerid, ...) {
    if(vargv.len() < 1){
        return msg(playerid, "USE: /h text")
    }
    local text = concat(vargv);
    foreach (id, value in players) {
        if(players[id].mlvl > 0)
        {
            msg(id, "[question] " + getAuthor( playerid ) + ": " + text, CL_INFO);
        }
    }
});