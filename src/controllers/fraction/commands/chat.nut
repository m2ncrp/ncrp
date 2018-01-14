fmd("*", ["chat.write"], ["$fc",  "$f ooc"], function(fraction, character, ...) {

    if(vargv.len() == 0) {
        return msg(character.playerid, "fraction.chat.noempty", CL_WARNING);
    }

    local message = strip(concat(vargv));

    if (!message.len()) {
        return;
    }

    local color = fraction.hasData("color") ? getroottable()[fraction.getData("color")] : CL_NIAGARA;

    foreach (idx, target in fraction.members.getOnline()) {
        if (!fraction.members.get(target).permitted("chat.read")) {
            continue;
        }

        msg(target.playerid, "fraction.chat.msg", [plocalize(character.playerid, fraction.title), plocalize(character.playerid, fraction.members.get(character).role.title), character.getName(), message], color);
    }
});
