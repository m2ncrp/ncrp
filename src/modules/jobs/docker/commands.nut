// usage: /help job docker
cmd("help", ["job", "docker"], function(playerid) {
    dockerJobHelp ( playerid );
});

// usage: /help docker job
cmd("help", ["docker", "job"], function(playerid) {
    dockerJobHelp ( playerid );
});

// usage: /docker
cmd("docker", function(playerid) {
    dockerJobHelp ( playerid );
});

// usage: /help docker
cmd("help", "docker", function(playerid) {
    dockerJobHelp ( playerid );
});

function dockerJobHelp ( playerid ) {
    local title = "job.docker.help.title";
    local commands = [
        { name = "/docker job",       desc = "job.docker.help.job" },
        { name = "/docker job leave", desc = "job.docker.help.jobleave" },
        { name = "/docker take",      desc = "job.docker.help.take" },
        { name = "/docker put",       desc = "job.docker.help.put" }
    ];
    msg_help(playerid, title, commands);
}
