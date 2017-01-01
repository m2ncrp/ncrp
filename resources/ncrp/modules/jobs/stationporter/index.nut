translation("en", {
"job.porter"                    : "station porter"
"job.porter.letsgo"             : "[PORTER] Go inside to Dipton Train Station."
"job.porter.already"            : "[PORTER] You're station porter already."
"job.porter.now"                : "[PORTER] You're a station porter now. Welcome!"
"job.porter.takeboxandcarry"    : "[PORTER] Take a box and carry it to the railway carriage."
"job.porter.not"                : "[PORTER] You're not a station porter."
"job.porter.takebox"            : "[PORTER] Go and take a box."
"job.porter.havebox"            : "[PORTER] You have a box already."
"job.porter.tookbox"            : "[PORTER] You took the box. Go to the railway carriage."
"job.porter.haventbox"          : "[PORTER] You haven't a box."
"job.porter.gotowarehouse"      : "[PORTER] Go to the railway carriage."
"job.porter.nicejob"            : "[PORTER] You put the box. You earned $%.2f."

"job.porter.help.title"         : "List of available commands for STATION PORTER JOB:"
"job.porter.help.job"           : "Get station porter job"
"job.porter.help.jobleave"      : "Leave station porter job"
"job.porter.help.take"          : "Take a box"
"job.porter.help.put"           : "Put box to the railway carriage"
});


include("modules/jobs/stationporter/commands.nut");

local job_porter = {};

const PORTER_RADIUS = 4.0;
const PORTER_JOB_X = -583.78; //Dipton Station Inside
const PORTER_JOB_Y = 1620.02; //Dipton Station Inside
const PORTER_JOB_Z = -15.6957; //Dipton Station Inside
const PORTER_JOB_TAKEBOX_X = -658.107;
const PORTER_JOB_TAKEBOX_Y = 1722.11;
const PORTER_JOB_TAKEBOX_Z = -23.2408;
const PORTER_JOB_PUTBOX_X = -632.416;
const PORTER_JOB_PUTBOX_Y = 1645.35;
const PORTER_JOB_PUTBOX_Z = -23.2408;
const PORTER_JOB_SKIN = 131;
const PORTER_SALARY = 0.50;
      PORTER_JOB_COLOR <- CL_CRUSTA;

event("onServerStarted", function() {
    log("[jobs] loading porter job...");

    //creating 3dtext for bus depot
    create3DText ( PORTER_JOB_X, PORTER_JOB_Y, PORTER_JOB_Z+0.35, "TRAIN STATION", CL_ROYALBLUE );
    create3DText ( PORTER_JOB_X, PORTER_JOB_Y, PORTER_JOB_Z+0.20, "/help job porter", CL_WHITE.applyAlpha(100), 3.0 );

    registerPersonalJobBlip("porter", PORTER_JOB_X, PORTER_JOB_Y);

});

event("onPlayerConnect", function(playerid, name, ip, serial ){
    job_porter[playerid] <- {};
    job_porter[playerid]["havebox"] <- false;
    job_porter[playerid]["blip3dtext"] <- [null, null, null];
});

event("onServerPlayerStarted", function( playerid ){
    if(players[playerid]["job"] == "porter") {
        job_porter[playerid]["blip3dtext"] = porterJobCreatePrivateBlipText(playerid, PORTER_JOB_TAKEBOX_X, PORTER_JOB_TAKEBOX_Y, PORTER_JOB_TAKEBOX_Z, "TAKE BOX HERE", "press E");
    }
});


/**
 * Create private 3DTEXT AND BLIP
 * @param  {int}  playerid
 * @param  {float} x
 * @param  {float} y
 * @param  {float} z
 * @param  {string} text
 * @param  {string} cmd
 * @return {array} [idtext1, id3dtext2, idblip]
 */
function porterJobCreatePrivateBlipText(playerid, x, y, z, text, cmd) {
    return [
            createPrivate3DText (playerid, x, y, z+0.35, text, CL_RIPELEMON, 30 ),
            createPrivate3DText (playerid, x, y, z+0.20, cmd, CL_WHITE.applyAlpha(150), PORTER_RADIUS ),
            createPrivateBlip (playerid, x, y, ICON_YELLOW, 300.0)
    ];
}

/**
 * Remove private 3DTEXT AND BLIP
 * @param  {int}  playerid
 */
function porterJobRemovePrivateBlipText ( playerid ) {
    if(job_porter[playerid]["blip3dtext"][0] != null) {
        remove3DText ( job_porter[playerid]["blip3dtext"][0] );
        remove3DText ( job_porter[playerid]["blip3dtext"][1] );
        removeBlip   ( job_porter[playerid]["blip3dtext"][2] );
    }
}


/**
 * Check is player is a porter
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPorter(playerid) {
    return (isPlayerHaveValidJob(playerid, "porter"));
}


/**
 * Check is porter have box
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPorterHaveBox(playerid) {
    return job_porter[playerid]["havebox"];
}


function porterJob( playerid ) {

    if(!isPlayerInValidPoint(playerid, PORTER_JOB_X, PORTER_JOB_Y, PORTER_RADIUS)) {
        return msg( playerid, "job.porter.letsgo", PORTER_JOB_COLOR );
    }

    if(isPorter( playerid )) {
        return msg( playerid, "job.porter.already", PORTER_JOB_COLOR );
    }

    if(isPlayerHaveJob(playerid)) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), PORTER_JOB_COLOR );
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.porter.now", PORTER_JOB_COLOR );
        msg( playerid, "job.porter.takeboxandcarry", PORTER_JOB_COLOR );

        setPlayerJob( playerid, "porter");
        setPlayerModel( playerid, PORTER_JOB_SKIN );

        // create private blip job
        // createPersonalJobBlip( playerid, PORTER_JOB_X, PORTER_JOB_Y);

        job_porter[playerid]["blip3dtext"] = porterJobCreatePrivateBlipText(playerid, PORTER_JOB_TAKEBOX_X, PORTER_JOB_TAKEBOX_Y, PORTER_JOB_TAKEBOX_Z, "TAKE BOX HERE", "press E");

    });
}

// working good, check
function porterJobLeave( playerid ) {

    if(!isPlayerInValidPoint(playerid, PORTER_JOB_X, PORTER_JOB_Y, PORTER_RADIUS)) {
        return msg( playerid, "job.porter.letsgo", PORTER_JOB_COLOR );
    }

    if(!isPorter( playerid )) {
        return msg( playerid, "job.porter.not", PORTER_JOB_COLOR );
    }
    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.leave", PORTER_JOB_COLOR );

        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);

        job_porter[playerid]["havebox"] = false;

        //setPlayerAnimStyle(playerid, "common", "default");
        //setPlayerHandModel(playerid, 1, 0);

        // remove private blip job
        removePersonalJobBlip ( playerid );

        porterJobRemovePrivateBlipText ( playerid );

    });
}

// working good, check
function porterJobTakeBox( playerid ) {
    if(!isPorter( playerid )) {
        return msg( playerid, "job.porter.not", PORTER_JOB_COLOR );
    }

    if(!isPlayerInValidPoint(playerid, PORTER_JOB_TAKEBOX_X , PORTER_JOB_TAKEBOX_Y, PORTER_RADIUS)) {
        return msg( playerid, "job.porter.takebox", PORTER_JOB_COLOR );
    }

    if (isPorterHaveBox(playerid)) {
        return msg( playerid, "job.porter.havebox", PORTER_JOB_COLOR );
    }

    porterJobRemovePrivateBlipText ( playerid );

    job_porter[playerid]["havebox"] = true;
    //setPlayerAnimStyle(playerid, "common", "CarryBox");
    //setPlayerHandModel(playerid, 1, 98); // put box in hands
    msg( playerid, "job.porter.tookbox", PORTER_JOB_COLOR );

    job_porter[playerid]["blip3dtext"] = porterJobCreatePrivateBlipText(playerid, PORTER_JOB_PUTBOX_X, PORTER_JOB_PUTBOX_Y, PORTER_JOB_PUTBOX_Z, "PUT BOX HERE", "press E");

}

// working good, check
function porterJobPutBox( playerid ) {
    if(!isPorter( playerid )) {
        return msg( playerid, "job.porter.not", PORTER_JOB_COLOR );
    }

    if (!isPorterHaveBox(playerid)) {
        return msg( playerid, "job.porter.haventbox", PORTER_JOB_COLOR );
    }

    if(!isPlayerInValidPoint(playerid, PORTER_JOB_PUTBOX_X, PORTER_JOB_PUTBOX_Y, PORTER_RADIUS)) {
        return msg( playerid, "job.porter.gotowarehouse", PORTER_JOB_COLOR );
    }

    //setPlayerAnimStyle(playerid, "common", "default");
    //setPlayerHandModel(playerid, 1, 0);

    porterJobRemovePrivateBlipText ( playerid );

    job_porter[playerid]["havebox"] = false;
    msg( playerid, "job.porter.nicejob", PORTER_SALARY, PORTER_JOB_COLOR );
    addMoneyToPlayer(playerid, PORTER_SALARY);

    job_porter[playerid]["blip3dtext"] = porterJobCreatePrivateBlipText(playerid, PORTER_JOB_TAKEBOX_X, PORTER_JOB_TAKEBOX_Y, PORTER_JOB_TAKEBOX_Z, "TAKE BOX HERE", "press E");
}
