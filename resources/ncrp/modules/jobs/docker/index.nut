translation("en", {
"job.docker"                    : "docker"
"job.docker.letsgo"             : "[DOCKER] Let's go to office at City Port."
"job.docker.already"            : "[DOCKER] You're docker already."
"job.docker.now"                : "[DOCKER] You're a docker now. Welcome... to hell! Ha-ha..."
"job.docker.takeboxandcarry"    : "[DOCKER] Take a crate and carry it to the truck."
"job.docker.not"                : "[DOCKER] You're not a docker."
"job.docker.takebox"            : "[DOCKER] Go and take a crate."
"job.docker.havebox"            : "[DOCKER] You have a crate already."
"job.docker.tookbox"            : "[DOCKER] You took the crate. Go to truck."
"job.docker.haventbox"          : "[DOCKER] You haven't a crate."
"job.docker.dropped"            : "[DOCKER] You dropped the crate."
"job.docker.presscapslock"      : "Press CAPS LOCK to walk."
"job.docker.gotowarehouse"      : "[DOCKER] Go to truck."
"job.docker.nicejob"            : "[DOCKER] You put the crate. You earned $%.2f."

"job.docker.help.title"         : "List of available commands for DOCKER JOB:"
"job.docker.help.job"           : "Get docker job"
"job.docker.help.jobleave"      : "Leave docker job"
"job.docker.help.take"          : "Take a crate"
"job.docker.help.put"           : "Put crate to truck"
});


include("modules/jobs/docker/commands.nut");

local job_docker = {};

const DOCKER_RADIUS = 1.5;
const DOCKER_JOB_X = -350.47;
const DOCKER_JOB_Y = -726.907;
const DOCKER_JOB_Z = -15.4207;



const DOCKER_JOB_TAKEBOX_X = -334.056;
const DOCKER_JOB_TAKEBOX_Y = -700.221;
const DOCKER_JOB_TAKEBOX_Z = -21.7302;

const DOCKER_JOB_PUTBOX_X = -331.502;
const DOCKER_JOB_PUTBOX_Y = -713.312;
const DOCKER_JOB_PUTBOX_Z = -20.7489;

/*
const DOCKER_JOB_TAKEBOX_X = -348.152;
const DOCKER_JOB_TAKEBOX_Y = -763.554;
const DOCKER_JOB_TAKEBOX_Z = -21.7457;

const DOCKER_JOB_PUTBOX_X = -368.039;
const DOCKER_JOB_PUTBOX_Y = -757.405;
const DOCKER_JOB_PUTBOX_Z = -21.7457;
*/
/*
const DOCKER_JOB_PUTBOX_X = -460.336;
const DOCKER_JOB_PUTBOX_Y = -719.601;
const DOCKER_JOB_PUTBOX_Z = -21.7312;
*/

const DOCKER_JOB_SKIN = 63;
const DOCKER_SALARY = 0.50;
      DOCKER_JOB_COLOR <- CL_CRUSTA;

event("onServerStarted", function() {
    log("[jobs] loading docker job...");

    //creating 3dtext for bus depot
    create3DText ( DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.35, "CITY PORT OFFICE", CL_ROYALBLUE );
    create3DText ( DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.20, "/help job docker", CL_WHITE.applyAlpha(100), 3.0 );

    registerPersonalJobBlip("docker", DOCKER_JOB_X, DOCKER_JOB_Y);

    createVehicle(37, -331.585, -716.952, -21.4104, -178.888, -0.0503875, -0.427005); //    Covered

});

event("onPlayerConnect", function(playerid) {
    job_docker[playerid] <- {};
    job_docker[playerid]["havebox"] <- false;
    job_docker[playerid]["blip3dtext"] <- [null, null, null];
    job_docker[playerid]["moveState"] <- null;
});

event("onServerPlayerStarted", function( playerid ){
    if(players[playerid]["job"] == "docker") {
        job_docker[playerid]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_TAKEBOX_X, DOCKER_JOB_TAKEBOX_Y, DOCKER_JOB_TAKEBOX_Z, "TAKE BOX HERE", "press E");
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
function dockerJobCreatePrivateBlipText(playerid, x, y, z, text, cmd) {
    return [
            createPrivate3DText (playerid, x, y, z+0.35, text, CL_RIPELEMON, 15 ),
            createPrivate3DText (playerid, x, y, z+0.20, cmd, CL_WHITE.applyAlpha(150), DOCKER_RADIUS ),
            createPrivateBlip (playerid, x, y, ICON_YELLOW, 200.0)
    ];
}

/**
 * Remove private 3DTEXT AND BLIP
 * @param  {int}  playerid
 */
function dockerJobRemovePrivateBlipText ( playerid ) {
    if(job_docker[playerid]["blip3dtext"][0] != null) {
        remove3DText ( job_docker[playerid]["blip3dtext"][0] );
        remove3DText ( job_docker[playerid]["blip3dtext"][1] );
        removeBlip   ( job_docker[playerid]["blip3dtext"][2] );
    }
}


/**
 * Check is player is a docker
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isDocker(playerid) {
    return (isPlayerHaveValidJob(playerid, "docker"));
}


/**
 * Check is docker have box
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isDockerHaveBox(playerid) {
    return job_docker[playerid]["havebox"];
}


function dockerJob( playerid ) {

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_RADIUS)) {
        return msg( playerid, "job.docker.letsgo", DOCKER_JOB_COLOR );
    }

    if(isDocker( playerid )) {
        return msg( playerid, "job.docker.already", DOCKER_JOB_COLOR );
    }

    if(isPlayerHaveJob(playerid)) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), DOCKER_JOB_COLOR );
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.docker.now", DOCKER_JOB_COLOR );
        msg( playerid, "job.docker.takeboxandcarry", DOCKER_JOB_COLOR );

        setPlayerJob( playerid, "docker");
        setPlayerModel( playerid, DOCKER_JOB_SKIN );

        // create private blip job
        // createPersonalJobBlip( playerid, DOCKER_JOB_X, DOCKER_JOB_Y);

        job_docker[playerid]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_TAKEBOX_X, DOCKER_JOB_TAKEBOX_Y, DOCKER_JOB_TAKEBOX_Z, "TAKE BOX HERE", "press E");

    });
}

// working good, check
function dockerJobLeave( playerid ) {

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_RADIUS)) {
        return msg( playerid, "job.docker.letsgo", DOCKER_JOB_COLOR );
    }

    if(!isDocker( playerid )) {
        return msg( playerid, "job.docker.not", DOCKER_JOB_COLOR );
    }
    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.leave", DOCKER_JOB_COLOR );

        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);

        job_docker[playerid]["havebox"] = false;

        //setPlayerAnimStyle(playerid, "common", "default");
        //setPlayerHandModel(playerid, 1, 0);

        // remove private blip job
        removePersonalJobBlip ( playerid );

        dockerJobRemovePrivateBlipText ( playerid );

    });
}

// working good, check
function dockerJobTakeBox( playerid ) {
    if(!isDocker( playerid )) {
        return msg( playerid, "job.docker.not", DOCKER_JOB_COLOR );
    }

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_TAKEBOX_X , DOCKER_JOB_TAKEBOX_Y, DOCKER_RADIUS)) {
        //return msg( playerid, "job.docker.takebox", DOCKER_JOB_COLOR );
        return;
    }

    if (isDockerHaveBox(playerid)) {
        return msg( playerid, "job.docker.havebox", DOCKER_JOB_COLOR );
    }

    dockerJobRemovePrivateBlipText ( playerid );

    job_docker[playerid]["havebox"] = true;

    setPlayerAnimStyle(playerid, "common", "CarryBox");
    setPlayerHandModel(playerid, 1, 98); // put box in hands
    msg( playerid, "job.docker.tookbox", DOCKER_JOB_COLOR );

    job_docker[playerid]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_PUTBOX_X, DOCKER_JOB_PUTBOX_Y, DOCKER_JOB_PUTBOX_Z, "PUT BOX HERE", "press E");
    delayedFunction(250, function () { setPlayerAnimStyle(playerid, "common", "CarryBox"); });
    delayedFunction(500, function () { setPlayerAnimStyle(playerid, "common", "CarryBox"); });
    delayedFunction(750, function () { setPlayerAnimStyle(playerid, "common", "CarryBox"); });
    delayedFunction(1000, function () { setPlayerAnimStyle(playerid, "common", "CarryBox"); });
}

// working good, check
function dockerJobPutBox( playerid ) {
    if(!isDocker( playerid )) {
        return msg( playerid, "job.docker.not", DOCKER_JOB_COLOR );
    }

    if (!isDockerHaveBox(playerid)) {
        return msg( playerid, "job.docker.haventbox", DOCKER_JOB_COLOR );
    }

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_PUTBOX_X, DOCKER_JOB_PUTBOX_Y, DOCKER_RADIUS)) {
        return msg( playerid, "job.docker.gotowarehouse", DOCKER_JOB_COLOR );
    }

    setPlayerAnimStyle(playerid, "common", "default");
    setPlayerHandModel(playerid, 1, 0);

    dockerJobRemovePrivateBlipText ( playerid );

    job_docker[playerid]["havebox"] = false;
    msg( playerid, "job.docker.nicejob", DOCKER_SALARY, DOCKER_JOB_COLOR );
    addMoneyToPlayer(playerid, DOCKER_SALARY);

    job_docker[playerid]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_TAKEBOX_X, DOCKER_JOB_TAKEBOX_Y, DOCKER_JOB_TAKEBOX_Z, "TAKE BOX HERE", "press E");
    delayedFunction(250, function () { setPlayerAnimStyle(playerid, "common", "default"); });
    delayedFunction(500, function () { setPlayerAnimStyle(playerid, "common", "default"); });
    delayedFunction(750, function () { setPlayerAnimStyle(playerid, "common", "default"); });
    delayedFunction(1000, function () { setPlayerAnimStyle(playerid, "common", "default"); });
}


event("updateMoveState", function(playerid, state) {
    job_docker[playerid]["moveState"] = state;
    if(isDocker( playerid ) && isDockerHaveBox(playerid)) {
        if(state == 1 || state == 2) {
            setPlayerAnimStyle(playerid, "common", "default");
            setPlayerHandModel(playerid, 1, 0);


            dockerJobRemovePrivateBlipText ( playerid );

            job_docker[playerid]["havebox"] = false;
            msg( playerid, "job.docker.dropped", DOCKER_JOB_COLOR );
            msg( playerid, "job.docker.presscapslock" )
            job_docker[playerid]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_TAKEBOX_X, DOCKER_JOB_TAKEBOX_Y, DOCKER_JOB_TAKEBOX_Z, "TAKE BOX HERE", "press E");
            delayedFunction(250, function () { setPlayerAnimStyle(playerid, "common", "default"); });
            delayedFunction(500, function () { setPlayerAnimStyle(playerid, "common", "default"); });
            delayedFunction(750, function () { setPlayerAnimStyle(playerid, "common", "default"); });
            delayedFunction(1000, function () { setPlayerAnimStyle(playerid, "common", "default"); });
        }
    }
});
