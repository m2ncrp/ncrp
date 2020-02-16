// usage: /job
// cmd("job", function(playerid) {
//     msg( playerid, "client.interface.job", [ getLocalizedPlayerJob(playerid) ], CL_SUCCESS );
// });

// usage: /resetjob or /resetjob id
acmd("resetjob", function(playerid, targetid = null) {
    local tid = targetid != null ? targetid.tointeger() : playerid;
    setPlayerJob(tid, null)
    msg( playerid, "Работа сброшена", CL_SUCCESS);
});
