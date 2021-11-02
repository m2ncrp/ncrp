translation("en", {

"job.docker.letsgo"             : "[DOCKER] Let's go to office at City Port."
"job.docker.already"            : "[DOCKER] You're docker already."
"job.docker.now"                : "[DOCKER] You're a docker now. Welcome... to hell! Ha-ha..."
"job.docker.takeboxandcarry"    : "[DOCKER] Take a crate and carry it to the truck."
"job.docker.not"                : "[DOCKER] You're not a docker."
"job.docker.havebox"            : "[DOCKER] You have a crate already."
"job.docker.tookbox"            : "[DOCKER] You took the crate. Go to truck."

"job.docker.dropped"            : "[DOCKER] You dropped the crate."
"job.docker.presscapslock"      : "Press CAPS LOCK to walk."

"job.docker.nicejob"            : "[DOCKER] You put the crate. You earned $%.2f."
"job.docker.nojob"              : "Boxes are over. Come another time."

"job.docker.haventbox"          : "[DOCKER] You haven't a crate."
"job.docker.gotowarehouse"      : "[DOCKER] Go to truck."

"job.docker.ifyouwantstart"    :   "[DOCKER] You're bus docker. If you want to work - go to warehouse and take box."


"job.docker.help.title"         : "List of available commands for DOCKER JOB:"
"job.docker.help.job"           : "Get docker job"
"job.docker.help.jobleave"      : "Leave docker job"
"job.docker.help.take"          : "Take a crate"
"job.docker.help.put"           : "Put crate to truck"
});

translation("ru", {

    "job.docker.letsgo"                 :   "Отправляйтесь в офис City Port."
    "job.docker.already"                :   "Ты уже работаешь портовым рабочим."
    "job.docker.now"                    :   "Ты стал портовым рабочим. Добро пожаловать... в ад! Аха-ха..."
    "job.docker.takeboxandcarry"        :   "Бери ящик и неси к грузовику."
    "job.docker.not"                    :   "Вы не работаете портовым рабочим."
    "job.docker.havebox"                :   "У тебя уже есть ящик. Тебе мало что ли?"
    "job.docker.tookbox"                :   "Неси ящик в кузов грузовика."
    "job.docker.haventbox"              :   "Ты не брал ящик."
    "job.docker.dropped"                :   "Ты уронил ящик."
    "job.docker.presscapslock"          :   "Нажми CAPS LOCK для включения режима ходьбы."
    "job.docker.nicejob"                :   "Молодец! Держи $%.2f."
    "job.docker.nojob"                  :   "Ящики закончились. Приходи в другой раз."

    "ru|job.bus.ifyouwantstart"            :   "[BUS] Ты работаешь водителем автобуса. Если хочешь выйти в рейс - возьми маршрут в автобусном депо."


    "job.docker.haventbox"              :   "[DOCKER] You haven't a crate."
    "job.docker.gotowarehouse"          :   "[DOCKER] Неси ящик к грузовику."

    "job.docker.ifyouwantstart"         :  "Ты - портовый рабочий. Если хочешь поработать - иди на склад и возьми ящик."

    "job.docker.help.title"             :   "Список команд, доступных портовому рабочему:"
    "job.docker.help.job"               :   "Устроиться на работу портовым рабочим"
    "job.docker.help.jobleave"          :   "Уволиться с работы"
    "job.docker.help.take"              :   "Взять ящик"
    "job.docker.help.put"               :   "Положить ящик на склад"

});

local job_docker = {};

const DOCKER_RADIUS = 1.5;
const DOCKER_JOB_X = -350.47;
const DOCKER_JOB_Y = -726.907;
const DOCKER_JOB_Z = -15.4207;

const DOCKER_JOB_TAKEBOX_X = -334.056;
const DOCKER_JOB_TAKEBOX_Y = -700.221;
const DOCKER_JOB_TAKEBOX_Z = -21.7302;

const DOCKER_JOB_PUTBOX_X = -331.502;
const DOCKER_JOB_PUTBOX_Y = -717.26;
const DOCKER_JOB_PUTBOX_Z = -20.6;

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
const DOCKER_SALARY = 0.20;
      DOCKER_JOB_COLOR <- CL_CRUSTA;

// local DOCKER_RANGS_MAX = 20;

local DOCKER_JOB_GET_HOUR_START     = 0;    //6;
local DOCKER_JOB_GET_HOUR_END       = 23;   //18;
local DOCKER_JOB_LEAVE_HOUR_START   = 0;    //6;
local DOCKER_JOB_LEAVE_HOUR_END     = 23;   //18;
local DOCKER_JOB_WORKING_HOUR_START = 0;    //6;
local DOCKER_JOB_WORKING_HOUR_END   = 23;   //18;
local DOCKER_BOX_IN_HOUR = 30;
local DOCKER_BOX_NOW = 25;

// local TRUCKID = -1;


event("onServerStarted", function() {
    logStr("[jobs] loading docker job...");

    registerPersonalJobBlip("docker", DOCKER_JOB_X, DOCKER_JOB_Y);

    //TRUCKID = createVehicle(35, -331.585, -717.952, -21.4104, -178.888, -0.0503875, -0.427005);

});

event("onPlayerConnect", function(playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);
    if ( ! (charId in job_docker) ) {
        job_docker[charId] <- {};
        job_docker[charId]["havebox"] <- false;
        job_docker[charId]["blip3dtext"] <- [null, null, null];
        job_docker[charId]["moveState"] <- null;
        job_docker[charId]["press3Dtext"] <- null;
    }
});

event("onServerPlayerStarted", function( playerid ) {

    //creating 3dtext for bus depot
    createPrivate3DText ( playerid, DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.35, plocalize(playerid, "3dtext.job.port"), CL_ROYALBLUE );
    // setVehiclePartOpen(TRUCKID, 1, true);

    if(players[playerid]["job"] == "docker") {
        dockerJobRegisterPrivateKeys(playerid);

        local charId = getCharacterIdFromPlayerId(playerid);

        if(job_docker[charId]["havebox"]) {
            triggerClientEvent(playerid, "setWithBoxPlayerState");

            job_docker[getCharacterIdFromPlayerId(playerid)]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_PUTBOX_X, DOCKER_JOB_PUTBOX_Y, DOCKER_JOB_PUTBOX_Z, plocalize(playerid, "PUTBOXHERE"), plocalize(playerid, "3dtext.job.press.E"));
        } else {
            msg( playerid, "job.docker.ifyouwantstart", DOCKER_JOB_COLOR );
            triggerClientEvent(playerid, "setDefaultPlayerState");
            job_docker[charId]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_TAKEBOX_X, DOCKER_JOB_TAKEBOX_Y, DOCKER_JOB_TAKEBOX_Z, plocalize(playerid, "TAKEBOXHERE"), plocalize(playerid, "3dtext.job.press.E"));
        }

        job_docker[getCharacterIdFromPlayerId(playerid)]["press3Dtext"] = createPrivate3DText (playerid, DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.20, plocalize(playerid, "3dtext.job.press.leave"), CL_WHITE.applyAlpha(100), 3.0 );
    } else {
        privateKey(playerid, "e", "dockerJobGet", dockerJob);
        job_docker[getCharacterIdFromPlayerId(playerid)]["press3Dtext"] = createPrivate3DText (playerid, DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.20, plocalize(playerid, "3dtext.job.press.getjob"), CL_WHITE.applyAlpha(100), 3.0 );
    }
});

event("onServerHourChange", function() {
    DOCKER_BOX_NOW = DOCKER_BOX_IN_HOUR + random(-5, 5);
});

function dockerJobRegisterPrivateKeys(playerid) {
    privateKey(playerid, "q", "dockerJobLeave", dockerJobLeave);
    privateKey(playerid, "e", "dockerJobTakeBox", dockerJobTakeBox);
    privateKey(playerid, "e", "dockerJobPutBox", dockerJobPutBox);
    privateKey(playerid, "c", "dockerJobBoxCanDroppedC", dockerJobBoxCanDropped);
    privateKey(playerid, "ctrl", "dockerJobBoxCanDroppedCtrl", dockerJobBoxCanDropped);
    privateKey(playerid, "space", "dockerJobBoxCanDroppedSpace", dockerJobBoxCanDropped);

    removePrivateKey(playerid, "e", "dockerJobGet");
}

function dockerJobUnregisterPrivateKeys(playerid) {
    removePrivateKey(playerid, "q", "dockerJobLeave");
    removePrivateKey(playerid, "e", "dockerJobTakeBox");
    removePrivateKey(playerid, "e", "dockerJobPutBox");
    removePrivateKey(playerid, "c", "dockerJobBoxCanDroppedC")
    removePrivateKey(playerid, "ctrl", "dockerJobBoxCanDroppedCtrl");
    removePrivateKey(playerid, "space", "dockerJobBoxCanDroppedSpace");

    privateKey(playerid, "e", "dockerJobGet", dockerJob);
}

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
    local charId = getCharacterIdFromPlayerId(playerid);
    if(job_docker[charId]["blip3dtext"][0] != null) {
        remove3DText ( job_docker[charId]["blip3dtext"][0] );
        remove3DText ( job_docker[charId]["blip3dtext"][1] );
        removeBlip   ( job_docker[charId]["blip3dtext"][2] );
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
    return job_docker[getCharacterIdFromPlayerId(playerid)]["havebox"];
}


function dockerJob( playerid ) {

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_RADIUS)) {
        //return msg( playerid, "job.docker.letsgo", DOCKER_JOB_COLOR );
        return;
    }

    if(isDocker( playerid )) {
        return msg( playerid, "job.docker.already", DOCKER_JOB_COLOR );
    }

    if(isPlayerHaveJob(playerid)) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), DOCKER_JOB_COLOR );
    }

    setPlayerJob( playerid, "docker");
    dockerJobRegisterPrivateKeys(playerid);

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.docker.now", DOCKER_JOB_COLOR );
        msg( playerid, "job.docker.takeboxandcarry", DOCKER_JOB_COLOR );

        //setPlayerModel( playerid, DOCKER_JOB_SKIN );

        // create private blip job
        // createPersonalJobBlip( playerid, DOCKER_JOB_X, DOCKER_JOB_Y);
        local charId = getCharacterIdFromPlayerId(playerid);
        remove3DText(job_docker[charId]["press3Dtext"]);
        job_docker[charId]["press3Dtext"] = createPrivate3DText (playerid, DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.20, plocalize(playerid, "3dtext.job.press.leave"), CL_WHITE.applyAlpha(100), 3.0 );
        job_docker[charId]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_TAKEBOX_X, DOCKER_JOB_TAKEBOX_Y, DOCKER_JOB_TAKEBOX_Z, plocalize(playerid, "TAKEBOXHERE"), plocalize(playerid, "3dtext.job.press.E"));

    });
}

// working good, check
function dockerJobLeave( playerid ) {

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_RADIUS)) {
        //return msg( playerid, "job.docker.letsgo", DOCKER_JOB_COLOR );
        return;
    }

    if(!isDocker( playerid )) {
        return msg( playerid, "job.docker.not", DOCKER_JOB_COLOR );
    }

    if (isDockerHaveBox(playerid)) {
        delayedFunction(250, function() {
            triggerClientEvent(playerid, "setDefaultPlayerState");
        })
    }

    setPlayerJob( playerid, null );
    dockerJobUnregisterPrivateKeys( playerid );

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.leave", DOCKER_JOB_COLOR );

        //restorePlayerModel(playerid);

        local charId = getCharacterIdFromPlayerId(playerid);
        job_docker[charId]["havebox"] = false;

        // remove private blip job
        removePersonalJobBlip ( playerid );
        dockerJobRemovePrivateBlipText ( playerid );

        remove3DText(job_docker[charId]["press3Dtext"]);
        job_docker[charId]["press3Dtext"] = createPrivate3DText (playerid, DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.20, plocalize(playerid, "3dtext.job.press.getjob"), CL_WHITE.applyAlpha(100), 3.0 );
    });
}

// working good, check
function dockerJobTakeBox( playerid ) {
    if(!isDocker( playerid )) {
        return msg( playerid, "job.docker.not", DOCKER_JOB_COLOR );
    }

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_TAKEBOX_X , DOCKER_JOB_TAKEBOX_Y, DOCKER_RADIUS)) {
        return;
    }

    if (isDockerHaveBox(playerid)) {
        return msg( playerid, "job.docker.havebox", DOCKER_JOB_COLOR );
    }

    if(DOCKER_BOX_NOW < 1) {
        return msg( playerid, "job.docker.nojob", DOCKER_JOB_COLOR );
    }

    if (job_docker[getCharacterIdFromPlayerId(playerid)]["moveState"] == 1 || job_docker[getCharacterIdFromPlayerId(playerid)]["moveState"] == 2){
        return  msg( playerid, "job.docker.presscapslock" );
    }

    dockerJobRemovePrivateBlipText ( playerid );

    job_docker[getCharacterIdFromPlayerId(playerid)]["havebox"] = true;
    DOCKER_BOX_NOW -= 1;
    //setVehiclePartOpen(TRUCKID, 1, true);

    triggerClientEvent(playerid, "takeBox");

    msg( playerid, "job.docker.tookbox", DOCKER_JOB_COLOR );

    job_docker[getCharacterIdFromPlayerId(playerid)]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_PUTBOX_X, DOCKER_JOB_PUTBOX_Y, DOCKER_JOB_PUTBOX_Z, plocalize(playerid, "PUTBOXHERE"), plocalize(playerid, "3dtext.job.press.E"));
}

// working good, check
function dockerJobPutBox( playerid ) {
    if(!isDocker( playerid )) {
        return msg( playerid, "job.docker.not", DOCKER_JOB_COLOR );
    }

    if (!isDockerHaveBox(playerid)) {
        return;// msg( playerid, "job.docker.haventbox", DOCKER_JOB_COLOR );
    }

    if(!isPlayerInValidPoint(playerid, DOCKER_JOB_PUTBOX_X, DOCKER_JOB_PUTBOX_Y, DOCKER_RADIUS)) {
        return; // msg( playerid, "job.docker.gotowarehouse", DOCKER_JOB_COLOR );
    }

    triggerClientEvent(playerid, "putBox");

    dockerJobRemovePrivateBlipText ( playerid );

    job_docker[getCharacterIdFromPlayerId(playerid)]["havebox"] = false;

    // local rang = players[playerid].data.jobsrang.docker.rang;

    // coef for max 20 level == $0.8
    // local amount = round(DOCKER_SALARY * pow(1.07177345, rang), 2) + round(getSalaryBonus() / 50, 2);
    local amount = DOCKER_SALARY + round(getSalaryBonus() / 50, 2);

    players[playerid].data.jobs.docker.count += 1;

    msg( playerid, "job.docker.nicejob", amount, DOCKER_JOB_COLOR );
    addPlayerMoney(playerid, amount);
    subWorldMoney(amount);

    job_docker[getCharacterIdFromPlayerId(playerid)]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_TAKEBOX_X, DOCKER_JOB_TAKEBOX_Y, DOCKER_JOB_TAKEBOX_Z, plocalize(playerid, "TAKEBOXHERE"), plocalize(playerid, "3dtext.job.press.E"));
}


event("updateMoveState", function(playerid, state) {
    if (getCharacterIdFromPlayerId(playerid) in job_docker) {
        job_docker[getCharacterIdFromPlayerId(playerid)]["moveState"] = state;
    }

    if(isDocker( playerid ) && isDockerHaveBox(playerid)) {
        if(state == 1 || state == 2) {
            msg( playerid, "job.docker.dropped", DOCKER_JOB_COLOR );
            msg( playerid, "job.docker.presscapslock" );

            dockerJobDropBox( playerid );
        }
    }
});

function dockerJobBoxCanDropped(playerid) {
    logStr("dockerJobBoxCanDropped");
    if(isDocker( playerid ) && isDockerHaveBox(playerid)) {
        msg( playerid, "job.docker.dropped", DOCKER_JOB_COLOR );

        dockerJobDropBox( playerid );
    }
}


function dockerJobDropBox( playerid ) {
    triggerClientEvent(playerid, "setDefaultPlayerState");
    dockerJobRemovePrivateBlipText ( playerid );
    job_docker[getCharacterIdFromPlayerId(playerid)]["havebox"] = false;
    job_docker[getCharacterIdFromPlayerId(playerid)]["blip3dtext"] = dockerJobCreatePrivateBlipText(playerid, DOCKER_JOB_TAKEBOX_X, DOCKER_JOB_TAKEBOX_Y, DOCKER_JOB_TAKEBOX_Z, plocalize(playerid, "TAKEBOXHERE"), plocalize(playerid, "3dtext.job.press.E"));
}
