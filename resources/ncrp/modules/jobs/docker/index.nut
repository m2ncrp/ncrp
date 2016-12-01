translation("en", {
"job.docker"                    : "docker"
"job.docker.letsgo"             : "Let's go to office at City Port."
"job.docker.already"            : "You're docker already."
"job.docker.now"                : "You're a docker now. Welcome... to hell! Ha-ha..."
"job.docker.takeboxandcarry"    : "Take a box and carry it to the warehouse."
"job.docker.not"                : "You're not a docker."
"job.docker.takebox"            : "Go and take a box."
"job.docker.havebox"            : "You have a box already."
"job.docker.tookbox"            : "You took the box. Go to warehouse."
"job.docker.haventbox"          : "You haven't a box."
"job.docker.gotowarehouse"      : "Go to warehouse."
"job.docker.nicejob"            : "You put the box. You earned $%.2f."

"job.docker.help.title"         :   "List of available commands for DOCKER JOB:"
"job.docker.help.job"           :   "Get docker job."
"job.docker.help.jobleave"      :   "Leave docker job."
"job.docker.help.take"          :   "Take a box."
"job.docker.help.put"           :   "Put box to warehouse."
});

translation("ru", {
"job.docker"                    : "портовый рабочий"
"job.docker.letsgo"             : "Отправляйтесь в офис City Port."
"job.docker.already"            : "Ты уже работаешь портовым рабочим."
"job.docker.now"                : "Ты стал портовым рабочим. Добро пожаловать... в ад! Аха-ха..."
"job.docker.takeboxandcarry"    : "Бери ящик и неси на склад."
"job.docker.not"                : "Вы не работаете портовым рабочим."
"job.docker.takebox"            : "Иди и возьми ящик."
"job.docker.havebox"            : "Ты уже несёшь ящик. Тебе мало что ли?"
"job.docker.tookbox"            : "Ты взял ящик. Теперь неси его на склад."
"job.docker.haventbox"          : "Ты не брал ящик."
"job.docker.gotowarehouse"      : "Иди на склад."
"job.docker.nicejob"            : "Ты принёс ящик. Твой заработок $%.2f."

"job.docker.help.title"         : "Список команд, доступных портовому рабочему:"
"job.docker.help.job"           : "Устроиться на работу портовым рабочим"
"job.docker.help.jobleave"      : "Уволиться с работы"
"job.docker.help.take"          : "Взять ящик"
"job.docker.help.put"           : "Положить ящик на склад"
});

include("modules/jobs/docker/commands.nut");

local job_docker = {};

const DOCKER_RADIUS = 5.0;
const DOCKER_JOB_X = -348.205; //Derek Door
const DOCKER_JOB_Y = -731.48; //Derek Door
const DOCKER_JOB_Z = -15.4205;
const DOCKER_JOB_TAKEBOX_X = -348.152;
const DOCKER_JOB_TAKEBOX_Y = -763.554;
const DOCKER_JOB_TAKEBOX_Z = -21.7457;
const DOCKER_JOB_PUTBOX_X = -460.336;
const DOCKER_JOB_PUTBOX_Y = -719.601;
const DOCKER_JOB_PUTBOX_Z = -21.7312;
const DOCKER_JOB_SKIN = 63;
const DOCKER_SALARY = 0.50;

event("onServerStarted", function() {
    log("[jobs] loading docker job...");

    //creating 3dtext for bus depot
    create3DText ( DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.35, "CITY PORT OFFICE", CL_ROYALBLUE );
    create3DText ( DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.20, "/help job docker", CL_WHITE.applyAlpha(75), 3 );

    registerPersonalJobBlip("docker", DOCKER_JOB_X, DOCKER_JOB_Y);

});

event("onPlayerConnect", function(playerid, name, ip, serial ){
    job_docker[playerid] <- {};
    job_docker[playerid]["havebox"] <- false;
    job_docker[playerid]["blip3dtext"] <- [null, null, null];
});

event("onPlayerSpawn", function( playerid ){
    if(players[playerid]["job"] == "docker") {
        job_docker[playerid]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_TAKEBOX_X, DOCKER_JOB_TAKEBOX_Y, DOCKER_JOB_TAKEBOX_Z, "TAKE BOX HERE", "/docker take");
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
            createPrivateBlip (playerid, x, y, ICON_RED, 200.0)
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
        return msg( playerid, "job.docker.letsgo" );
    }

    if(isDocker( playerid )) {
        return msg( playerid, "job.docker.already" );
    }

    if(isPlayerHaveJob(playerid)) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid));
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.docker.now" );
        msg( playerid, "job.docker.takeboxandcarry" );

        setPlayerJob( playerid, "docker");

        players[playerid]["skin"] = DOCKER_JOB_SKIN;
        setPlayerModel( playerid, DOCKER_JOB_SKIN );

        // create private blip job
        createPersonalJobBlip( playerid, DOCKER_JOB_X, DOCKER_JOB_Y);

        job_docker[playerid]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_TAKEBOX_X, DOCKER_JOB_TAKEBOX_Y, DOCKER_JOB_TAKEBOX_Z, "TAKE BOX HERE", "/docker take");

    });
}

// working good, check
function dockerJobLeave( playerid ) {

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_RADIUS)) {
        return msg( playerid, "job.docker.letsgo" );
    }

    if(!isDocker( playerid )) {
        return msg( playerid, "job.docker.not" );
    }
    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.leave" );

        setPlayerJob( playerid, null );

        players[playerid]["skin"] = players[playerid]["default_skin"];
        setPlayerModel( playerid, players[playerid]["default_skin"]);

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
        return msg( playerid, "job.docker.not" );
    }

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_TAKEBOX_X , DOCKER_JOB_TAKEBOX_Y, DOCKER_RADIUS)) {
        return msg( playerid, "job.docker.takebox" );
    }

    if (isDockerHaveBox(playerid)) {
        return msg( playerid, "job.docker.havebox");
    }

    dockerJobRemovePrivateBlipText ( playerid );

    job_docker[playerid]["havebox"] = true;
    //setPlayerAnimStyle(playerid, "common", "CarryBox");
    //setPlayerHandModel(playerid, 1, 98); // put box in hands
    msg( playerid, "job.docker.tookbox");

    job_docker[playerid]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_PUTBOX_X, DOCKER_JOB_PUTBOX_Y, DOCKER_JOB_PUTBOX_Z, "PUT BOX HERE", "/docker put");

}

// working good, check
function dockerJobPutBox( playerid ) {
    if(!isDocker( playerid )) {
        return msg( playerid, "job.docker.not" );
    }

    if (!isDockerHaveBox(playerid)) {
        return msg( playerid, "job.docker.haventbox");
    }

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_PUTBOX_X, DOCKER_JOB_PUTBOX_Y, DOCKER_RADIUS)) {
        return msg( playerid, "job.docker.gotowarehouse" );
    }

    //setPlayerAnimStyle(playerid, "common", "default");
    //setPlayerHandModel(playerid, 1, 0);

    dockerJobRemovePrivateBlipText ( playerid );

    job_docker[playerid]["havebox"] = false;
    msg( playerid, "job.docker.nicejob", DOCKER_SALARY);
    addMoneyToPlayer(playerid, DOCKER_SALARY);

    job_docker[playerid]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_TAKEBOX_X, DOCKER_JOB_TAKEBOX_Y, DOCKER_JOB_TAKEBOX_Z, "TAKE BOX HERE", "/docker take");
}
