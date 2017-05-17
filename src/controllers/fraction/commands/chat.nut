// chatcmd("fc", function(playerid, message) {
//     local fracs = fractions.getContaining(playerid);

//     if (!fracs.len()) {
//         return msg(playerid, "fraction.notmember", CL_WARNING);
//     }

//     // for now take the first one
//     local fraction = fracs[0];

//     foreach (idx, targetid in fraction.getOnlineMembers()) {
//         if (fraction[targetid].level <= FRACTION_CHAT_PERMISSION) {
//             msg(targetid, format("[Fraction OOC|%s] %s: %s", fraction[playerid].title, getPlayerName(playerid), message), CL_NIAGARA);
//         }
//     }
// });

fmd("*", "chat", ["$fc",  "$f ooc"], function(fraction, character, ...) {
    local message = strip(concat(vargv));

    if (!message.len()) {
        return;
    }

    foreach (idx, target in fraction.getOnlineMembers()) {
        if (fraction[target.id].permitted("chat")) {
            msg(target.playerid, format("[Fraction OOC|%s] %s: %s", fraction[character].title, character.getName(), message), CL_NIAGARA);
        }
    }
});
