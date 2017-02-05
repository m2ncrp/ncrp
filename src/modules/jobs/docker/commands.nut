// usage: /docker job
cmd("docker", "job", function(playerid) {
    dockerJob( playerid );
});

// usage: /docker job leave
cmd("docker", ["job", "leave"], function(playerid) {
    dockerJobLeave( playerid );
});

// usage: /docker ready
cmd("docker", "take", function(playerid) {
    dockerJobTakeBox( playerid );
});

// usage: /docker load
cmd("docker", "put", function(playerid) {
    dockerJobPutBox( playerid );
});

key("e", function(playerid) {
    if ( isPlayerInVehicle(playerid) ) {
        return;
    }
    if ( !isDocker(playerid) ) {
        return dockerJob( playerid );
    }
    if ( !isDockerHaveBox(playerid) ) {
        dockerJobTakeBox( playerid );
    } else {
        dockerJobPutBox( playerid );
    }
}, KEY_UP);

key("q", function(playerid) {
    if ( isDocker(playerid) ) {
        dockerJobLeave( playerid );
    }
}, KEY_UP);

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