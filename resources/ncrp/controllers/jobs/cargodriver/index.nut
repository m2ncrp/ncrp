translation("en", {
"job.cargodriver.letsgo"        : "Let's go to office at City Port."
"job.cargodriver.already"       : "You're cargo delivery driver already."
"job.cargodriver.now"           : "You're a cargo delivery driver now. Welcome! Ha-ha..."
"job.cargodriver.gotoseagift"   : "Go to Seagift Co. at Chinatown, get behind wheel of truck of fish and get your ass to warehouse P3 06 at Port."
"job.cargodriver.not"           : "You're not a cargo delivery driver."
"job.cargodriver.needfishtruck" : "You need a fish truck."
"job.cargodriver.toload"        : "Go to warehouse P3 06 at Port to load fish truck."
"job.cargodriver.driving"       : "You're driving. Please stop the truck."
"job.cargodriver.loading"       : "Loading truck. Wait..."
"job.cargodriver.unloading"     : "Unloading truck. Wait..."
"job.cargodriver.alreadyloaded" : "Truck already loaded."
"job.cargodriver.loaded"        : "The truck loaded. Go back to Seagift to unload."
"job.cargodriver.empty"         : "Truck is empty. Go to Port to load."
"job.cargodriver.tounload"      : "Go to Seagift to unload."
"job.cargodriver.takemoney"     : "Go to office at City Port and take your money."
"job.cargodriver.needcomplete"  : "You must complete delivery before."
"job.cargodriver.nicejob"       : "Nice job, %s! Keep $%.2f."

"job.cargodriver.help.title"            :   "List of available commands for CARGODRIVER JOB:"
"job.cargodriver.help.job"              :   "Get cargo delivery driver job"
"job.cargodriver.help.jobleave"         :   "Leave cargo delivery driver job"
"job.cargodriver.help.load"             :   "Load cargo into truck"
"job.cargodriver.help.unload"           :   "Unload cargo"
"job.cargodriver.help.finish"           :   "Report about delivery and get money"
});

translation("ru", {
"job.cargodriver.letsgo"        : "Отправляйтесь в офис City Port."
"job.cargodriver.already"       : "Вы уже работаете водителем грузовика."
"job.cargodriver.now"           : "Вы стали водителем грузовика."
"job.cargodriver.gotoseagift"   : "Отправляйтесь к складу Seagift в Chinatown, садитесь в грузовик для доставки рыбы и поезжайте в City Port к складу P3 06."
"job.cargodriver.not"           : "Вы не работаете водителем грузовика."
"job.cargodriver.needfishtruck" : "Вам нужен грузовик для доставки рыбы."
"job.cargodriver.toload"        : "Отправляйтесь в Порт к складу P3 06 для загрузки."
"job.cargodriver.driving"       : "Остановите грузовик."
"job.cargodriver.loading"       : "Грузовик загружается. Ждите..."
"job.cargodriver.unloading"     : "Грузовик разгружается. Ждите..."
"job.cargodriver.alreadyloaded" : "Грузовик уже загружен."
"job.cargodriver.loaded"        : "Грузовик загружен. Езжайте к складу Seagift для разгрузки."
"job.cargodriver.empty"         : "Грузовик пуст. Отправляйтесь в City Port для загрузки."
"job.cargodriver.tounload"      : "Отправляйтесь к складу Seagift для разгрузки."
"job.cargodriver.takemoney"     : "Отправляйтесь в офис City Port и получите Ваш заработок."
"job.cargodriver.needcomplete"  : "Завершите доставку."
"job.cargodriver.nicejob"       : "Отличная работа, %s! Держи $%.2f."

"job.cargodriver.help.title"            :   "Список доступных команд для водителя грузовика:"
"job.cargodriver.help.job"              :   "Устроиться на работу водителем грузовика"
"job.cargodriver.help.jobleave"         :   "Уволиться с работы"
"job.cargodriver.help.load"             :   "Загрузить грузовик"
"job.cargodriver.help.unload"           :   "Разгрузить грузовик"
"job.cargodriver.help.finish"           :   "Сообщить о доставке и получить деньги"
});

include("controllers/jobs/cargodriver/commands.nut");

local job_cargo = {};
local cargocars = {};


const RADIUS_CARGO = 1.0;
//const CARGO_JOB_X = -348.071; //Derek Cabinet
//const CARGO_JOB_Y = -731.48;  //Derek Cabinet
const CARGO_JOB_X = -348.205; //Derek Door
const CARGO_JOB_Y = -731.48; //Derek Door
const CARGO_JOB_Z = -15.4205;
const CARGO_JOB_SKIN = 130;
const CARGO_SALARY = 30.0;

local cargocoords = {};
cargocoords["PortChinese"] <- [-217.298, -724.771, -21.423]; // PortPlace P3 06 Chinese


event("onServerStarted", function() {
    log("[jobs] loading cargodriver job...");
    cargocars[createVehicle(38, 396.5, 101.977, -20.9432, -89.836, 0.40721, 0.0879066 )]  <- [ false ]; // SeagiftTruck0
    cargocars[createVehicle(38, 396.5, 98.0385, -20.9359, -88.4165, 0.479715, -0.0220962)]  <- [ false ];  //SeagiftTruck1

    //creating 3dtext for bus depot
    //create3DText ( DOCKER_JOB_X, DOCKER_JOB_Y, DOCKER_JOB_Z+0.35, "CITY PORT", CL_ROYALBLUE );
    create3DText ( CARGO_JOB_X, CARGO_JOB_Y, CARGO_JOB_Z+0.10, "/help job cargo", CL_WHITE.applyAlpha(75), 3 );

    registerPersonalJobBlip("cargodriver", CARGO_JOB_X, CARGO_JOB_Y);
});

event("onPlayerConnect", function(playerid, name, ip, serial) {
     job_cargo[playerid] <- {};
     job_cargo[playerid]["cargostatus"] <- false;
});


/**
 * Check is player is a cargo delivery driver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isCargoDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "cargodriver"));
}

/**
 * Check is player's vehicle is a fish truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleCargo(playerid) {
    return (isPlayerInValidVehicle(playerid, 38));
}

// working good, check
function cargoJob( playerid ) {

    if(!isPlayerInValidPoint(playerid, CARGO_JOB_X, CARGO_JOB_Y, RADIUS_CARGO)) {
        return msg( playerid, "job.cargodriver.letsgo" );
    }

    if(isCargoDriver( playerid )) {
        return msg( playerid, "job.cargodriver.already" );
    }

    if(isPlayerHaveJob(playerid)) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid));
    }

    msg( playerid, "job.cargodriver.now" );
    msg( playerid, "job.cargodriver.gotoseagift" );

    players[playerid]["job"] = "cargodriver";

    players[playerid]["skin"] = CARGO_JOB_SKIN;
    setPlayerModel( playerid, CARGO_JOB_SKIN );
}

// working good, check
function cargoJobLeave( playerid ) {

    if(!isPlayerInValidPoint(playerid, CARGO_JOB_X, CARGO_JOB_Y, RADIUS_CARGO)) {
        return msg( playerid, "job.cargodriver.letsgo" );
    }

    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.cargodriver.not");
    } else {
        msg( playerid, "job.leave" );

        players[playerid]["job"] = null;

        players[playerid]["skin"] = players[playerid]["default_skin"];
        setPlayerModel( playerid, players[playerid]["default_skin"]);

        job_cargo[playerid]["cargostatus"] = false;
    }
}

// working good, check
function cargoJobLoad( playerid ) {
    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.cargodriver.not");
    }

    if (!isPlayerVehicleCargo(playerid)) {
        return msg( playerid, "job.cargodriver.needfishtruck");
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(cargocars[vehicleid][0]) {
        return msg( playerid, "job.cargodriver.alreadyloaded");
    }

    if(!isVehicleInValidPoint(playerid, cargocoords["PortChinese"][0], cargocoords["PortChinese"][1], 4.0 )) {
        return msg( playerid, "job.cargodriver.toload");
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.cargodriver.driving");
    }

    msg( playerid, "job.cargodriver.loading");
    screenFadeinFadeoutEx(playerid, 1000, 3000, null, function() {
        cargocars[vehicleid][0] = true;
        msg( playerid, "job.cargodriver.loaded");
    });

}

// working good, check
function cargoJobUnload( playerid ) {
    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.cargodriver.not");
    }

    if (!isPlayerVehicleCargo(playerid)) {
        return msg( playerid, "job.cargodriver.needfishtruck");
    }

    local vehicleid = getPlayerVehicle(playerid);
    if(!cargocars[vehicleid][0]) {
        return msg( playerid, "job.cargodriver.empty" );
    }

    if(!isVehicleInValidPoint(playerid, 396.5, 98.0385, 4.0 )) {
        return msg( playerid, "job.cargodriver.tounload");
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.cargodriver.driving");
    }

    msg( playerid, "job.cargodriver.unloading");
    screenFadeinFadeoutEx(playerid, 1000, 3000, null, function() {
        job_cargo[playerid]["cargostatus"] = true;
        cargocars[vehicleid][0] = false;
        msg( playerid, "job.cargodriver.takemoney" );
        removePlayerFromVehicle( playerid );
    });

}


// working good, check
function cargoJobFinish( playerid ) {

    if(!isCargoDriver(playerid)) {
        return msg( playerid, "job.cargodriver.not");
    }

    if(!job_cargo[playerid]["cargostatus"]) {
        return msg( playerid, "job.cargodriver.needcomplete");
    }

    if(!isPlayerInValidPoint(playerid, CARGO_JOB_X, CARGO_JOB_Y, RADIUS_CARGO)) {
        return msg( playerid, "job.cargodriver.letsgo" );
    }

    job_cargo[playerid]["cargostatus"] = false;
    msg( playerid, "job.cargodriver.nicejob", [getPlayerName( playerid ), CARGO_SALARY] );
    addMoneyToPlayer(playerid, CARGO_SALARY);
}
