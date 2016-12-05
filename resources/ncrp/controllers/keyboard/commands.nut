cmd("layout", function(playerid, layout = null) {
    if (!layout) {
        return msg(playerid, "keyboard.layout.info", CL_INFO);
    }

    if (!setPlayerLayout(playerid, layout)) {
        return msg(playerid, "kayboard.layout.list", [concat(getKeyboardLayouts(), ",")], CL_WARNING);
    }

    msg(playerid, "keyboard.layout.success", CL_SUCCESS);
});
