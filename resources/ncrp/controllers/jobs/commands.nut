// usage: /help job
cmd("help", "job", function(playerid) {
    jobHelp ( playerid );
});

// usage: /job
cmd("job", function(playerid) {
    jobHelp ( playerid );
});

function jobHelp ( playerid ) {
    local title = "List of available commands for JOB:";
    local commands = [
        { name = "/help job docker",       desc = "Info about docker job in Port" },
        { name = "/help job bus",          desc = "Info about bus driver job" },
        { name = "/help job cargo",        desc = "Info about cargo driver job" },
        { name = "/help job fuel",         desc = "Info about fuel driver job" },
        { name = "/help job milk",         desc = "Info about milk driver job" },
        { name = "/help job taxi",         desc = "Info about taxi driver job" }
    ];
    msg_help(playerid, title, commands);
}
