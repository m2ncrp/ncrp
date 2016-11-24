include("controllers/jobs/docker/commands.nut");

local job_docker = {};

const RADIUS_DOCKER = 5.0;
const DOCKER_JOB_X = -348.205; //Derek Door
const DOCKER_JOB_Y = -731.48; //Derek Door
const DOCKER_JOB_Z = -15.4205;
const DOCKER_JOB_SKIN = 63;

addEventHandlerEx("onServerStarted", function() {
    log("[jobs] loading docker job...");

    //creating 3dtext for bus depot
    create3DText ( DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.35, "CITY PORT", CL_ROYALBLUE );
    create3DText ( DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z-0.15, "/help job docker", CL_WHITE.applyAlpha(75) );

    registerPersonalJobBlip("docker", DOCKER_JOB_X, DOCKER_JOB_Y);
});

addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial ){
    job_docker[playerid] <- {};
    job_docker[playerid]["havebox"] <- false;
});


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

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_X, DOCKER_JOB_Y, RADIUS_DOCKER)) {
        return msg( playerid, "Let's go to Derek office at City Port." );
    }

    if(isDocker( playerid )) {
        return msg( playerid, "You're docker already." );
    }

    if(isPlayerHaveJob(playerid)) {
        return msg( playerid, "You already have a job: " + getPlayerJob(playerid) + ".");
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "You're a docker now. Welcome! Ha-ha..." );
        msg( playerid, "Take a box and carry it to the warehouse." );

        players[playerid]["job"] = "docker";

        players[playerid]["skin"] = DOCKER_JOB_SKIN;
        setPlayerModel( playerid, DOCKER_JOB_SKIN );

        // create private blip job
        createPersonalJobBlip( playerid, DOCKER_JOB_X, DOCKER_JOB_Y);
    });
}

// working good, check
function dockerJobLeave( playerid ) {

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_X, DOCKER_JOB_Y, RADIUS_DOCKER)) {
        return msg( playerid, "Let's go to Derek office at City Port." );
    }

    if(!isDocker( playerid )) {
        return msg( playerid, "You're not a docker." );
    }
    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "You leave this job." );

        players[playerid]["job"] = null;

        players[playerid]["skin"] = players[playerid]["default_skin"];
        setPlayerModel( playerid, players[playerid]["default_skin"]);

        job_docker[playerid]["havebox"] = false;

        // remove private blip job
        removePersonalJobBlip ( playerid );
    });
}

// working good, check
function dockerJobTakeBox( playerid ) {
    if(!isDocker( playerid )) {
        return msg( playerid, "You're not a docker." );
    }

    if(!isPlayerInValidPoint(playerid, -348.152, -763.554, RADIUS_DOCKER)) {
        return msg( playerid, "Go and take a box." );
    }

    if (isDockerHaveBox(playerid)) {
        return msg( playerid, "You have a box already.");
    }

    job_docker[playerid]["havebox"] = true;
    setPlayerAnimStyle(playerid, "common", "CarryBox");
    setPlayerHandModel(playerid, 1, 98); // put box in hands
    msg( playerid, "You took the box. Go to warehouse.")
}

// working good, check
function dockerJobPutBox( playerid ) {
    if(!isDocker( playerid )) {
        return msg( playerid, "You're not a docker." );
    }

    if (!isDockerHaveBox(playerid)) {
        return msg( playerid, "You haven't a box.");
    }

    if(!isPlayerInValidPoint(playerid, -460.336, -719.601, RADIUS_DOCKER)) {
        return msg( playerid, "Go to warehouse." );
    }

    job_docker[playerid]["havebox"] = false;
    addMoneyToPlayer(playerid, 0.5);
    msg( playerid, "You put the box. You earned $0.5.");
}
