// usage: /help job truck
cmd("help", ["job", "truck"], function(playerid) {
    truckJobHelp ( playerid );
});

// usage: /help truck job
cmd("help", ["truck", "job"], function(playerid) {
    truckJobHelp ( playerid );
});

function truckJobHelp ( playerid ) {
    local title = "job.truckdriver.help.title";
    local commands = [
        { name = "job.truckdriver.help.job",            desc = "job.truckdriver.help.jobtext"           },
        { name = "job.truckdriver.help.jobleave",       desc = "job.truckdriver.help.jobleavetext"      },
        { name = "job.truckdriver.help.loadunload",     desc = "job.truckdriver.help.loadunloadtext"    }
    ];
    msg_help(playerid, title, commands);
}
