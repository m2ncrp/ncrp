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


// usage: /help job docker
cmd("help", ["job", "docker"], function(playerid) {
    local title = "List of available commands for DOCKER JOB:";
    local commands = [
        { name = "/docker job",       desc = "Get docker job." },
        { name = "/docker job leave", desc = "Leave docker job." },
        { name = "/docker take",      desc = "Take a box." },
        { name = "/docker put",       desc = "Put box to warehouse." }
    ];
    msg_help(playerid, title, commands);
});
