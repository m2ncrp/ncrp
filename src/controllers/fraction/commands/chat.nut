fmd("*", ["chat.write"], ["$fc",  "$f ooc"], function(fraction, character, ...) {

    if(vargv.len() == 0) {
        return msg(character.playerid, "fraction.chat.noempty", CL_WARNING);
    }

    local message = strip(concat(vargv));

    if (!message.len()) {
        return;
    }

    local color = fraction.hasData("color") ? Color.fromHex(fraction.getData("color")) : CL_NIAGARA;

    foreach (idx, target in fraction.members.getOnline()) {
        if (!fraction.members.get(target).permitted("chat.read")) {
            continue;
        }

        msg(target.playerid, format("[Fraction OOC|%s] %s: %s", fraction.members.get(character).role.title, character.getName(), message), color);
    }
});
