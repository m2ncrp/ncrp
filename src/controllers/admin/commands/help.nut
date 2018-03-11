function adminCmdHelp ( playerid ) {
    local title = "Команды администраторов";
    local commands = [
        { name = "", desc = "" },
        { name = "", desc = "" }
    ];
    msg_help(playerid, title, commands);
}

cmd("help", "admin", adminCmdHelp );
