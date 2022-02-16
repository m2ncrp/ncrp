include("modules/jobs/snowplower/nodes/SnowplowNode.nut");
include("modules/jobs/snowplower/commands.nut");
include("modules/jobs/snowplower/translations.nut");
include("modules/jobs/snowplower/nodes.nut");
include("modules/jobs/snowplower/edges.nut");

include("modules/jobs/snowplower/drawer.nut");

// game.traffic:SwitchGenerators(xx) xx = true\false
// game.traffic:Populate(##) ##=0..100
// game.traffic:PoliceReinforcements(##) ##=0..100
// game.traffic:OpenSeason(50) or (140)
// game.traffic:CloseSeason()
// game.traffic:SetPolice(xx) xx = true\false sets whether or not police car traffic should exit
// game.traffic:DespawnPolice(xx) xx = true\false
// game.traffic:SwitchRoad(Math:newVector(xx,yy,zz),false) false bloc circulation true debloc
// game.traffic:SwitchFarAmbient( ? )
// game.traffic:SetNumCars(##) ##=0..100
// game.traffic:SetNumStaticCars(##) ##=0..100
// game.traffic:SetNoAmbientRadius( ? )
// game.traffic:SetFarAmbientRadius( ? )
// game.traffic:PathFindEnableMiddlePoint( ? )
// game.traffic:PathFindReset( ? )


//include("modules/jobs/snowplow/commands.nut");

local job_snowplow = {};
local job_snowplow_blocked = {};

local routes = {};

local RADIUS_SNOWPLOW = 2.0;
local RADIUS_SNOWPLOW_SMALL = 1.0;
local SNOWPLOW_JOB_X = -388.442;
local SNOWPLOW_JOB_Y = 585.829;
local SNOWPLOW_JOB_Z = -10.2939;


local SNOWPLOW_JOB_TIMEOUT = 1800; // 30 minutes
local SNOWPLOW_JOB_SKIN = 87;

local SNOWPLOW_JOB_PAY_FOR_POINT = 0.075;

local SNOWPLOW_JOB_NAME = "snowplowdriver";
local SNOWPLOW_JOB_SNOWPLOWSTOP = "CHECKPOINT";
local SNOWPLOW_JOB_DISTANCE = 100;
local SNOWPLOW_JOB_LEVEL = 1;
      SNOWPLOW_JOB_COLOR <- CL_ROYALBLUE;
local SNOWPLOW_JOB_GET_HOUR_START        = 0  ;   // 6;
local SNOWPLOW_JOB_GET_HOUR_END          = 23 ;   // 9;
local SNOWPLOW_JOB_LEAVE_HOUR_START      = 0  ;   // 20;
local SNOWPLOW_JOB_LEAVE_HOUR_END        = 23 ;   // 22;
local SNOWPLOW_JOB_WORKING_HOUR_START    = 0  ;   // 6;
local SNOWPLOW_JOB_WORKING_HOUR_END      = 23 ;   // 21;

local SNOWPLOW_ROUTE_IN_HOUR = 2;
local SNOWPLOW_ROUTE_NOW = 2;

local edges = getSnowplowEdges();
local nodes = getSnowplowNodes();

event("onServerStarted", function() {
    logStr("[jobs] loading snowplow job...");

    createVehicle(39, -372.233, 593.342, -9.96686, -89.1468, 1.52338, 0.0686706);
    createVehicle(39, -374.524, 589.011, -9.96381, -56.7532, 1.17279, 0.934235);
    createVehicle(39, -380.797, 588.42, -9.95933, -56.3861, 1.20405, 0.900966);

    registerPersonalJobBlip("snowplowdriver", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y);
});

event("onPlayerConnect", function(playerid) {
    if ( ! (getCharacterIdFromPlayerId(playerid) in job_snowplow) ) {
     job_snowplow[getCharacterIdFromPlayerId(playerid)] <- {};
     job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"] <- false;
     job_snowplow[getCharacterIdFromPlayerId(playerid)]["snowplow3dtext"] <- [ null, null ];
     job_snowplow[getCharacterIdFromPlayerId(playerid)]["snowplowBlip"] <- null;
    }
});


event("onServerPlayerStarted", function( playerid ){
    createPrivate3DText ( playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.35, plocalize(playerid, "3dtext.job.snowplowdriver"), CL_ROYALBLUE );
    createPrivate3DText ( playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.20, plocalize(playerid, "3dtext.job.press.action"), CL_WHITE.applyAlpha(150), RADIUS_SNOWPLOW );

    if(isSnowplowDriver(playerid)) {

        createText (playerid, "leavejob3dtext", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.05, plocalize(playerid, "3dtext.job.press.leave"), CL_WHITE.applyAlpha(100), RADIUS_SNOWPLOW_SMALL );

        if (getPlayerJobState(playerid) == "working") {
            local snowplowId = job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"].points[0];
            job_snowplow[getCharacterIdFromPlayerId(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, nodes[snowplowId].coords);
            trigger(playerid, "setGPS", nodes[snowplowId].coords.x, nodes[snowplowId].coords.y);
            msg( playerid, "job.snowplow.continuesnowplowstop", SNOWPLOW_JOB_COLOR );
            return;
        }

        if (getPlayerJobState(playerid) == "complete") {
            return msg( playerid, "job.snowplow.takeyourmoney", SNOWPLOW_JOB_COLOR );
        }

        msg( playerid, "job.snowplow.ifyouwantstart", SNOWPLOW_JOB_COLOR );
        //restorePlayerModel(playerid);
        setPlayerJobState(playerid, null);
    }
});

event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    if (!isPlayerVehicleSnowplow(playerid)) {
        return;
    }

    // skip check for non-drivers
    if (seat != 0) return;

    if(isSnowplowDriver(playerid) && getPlayerJobState(playerid) == "working") {
        unblockDriving(vehicleid);
        repairVehicle(vehicleid);
        //delayedFunction(4500, function() {
            //snowplowJobReady(playerid);
        //});
    } else {
        blockDriving(playerid, vehicleid);
    }
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (!isPlayerVehicleSnowplow(playerid)) {
        return;
    }

    // skip check for non-drivers
    if (seat != 0) return;

    blockDriving(playerid, vehicleid);
});

event("onServerHourChange", function() {
    SNOWPLOW_ROUTE_NOW = SNOWPLOW_ROUTE_IN_HOUR;
});


/**
 * Create private 3DTEXT for current snowplow stop
 * @param  {int}  playerid
 * @return {array} [idtext1, id3dtext2]
 */
function createPrivateSnowplowCheckpoint3DText(playerid, snowplowstop) {
    return [
        createText( playerid, "snowplow_3dtext", snowplowstop.x, snowplowstop.y, snowplowstop.z+0.20, plocalize(playerid, "3dtext.job.checkpoint"), CL_RIPELEMON, SNOWPLOW_JOB_DISTANCE )
    ];
}

/**
 * Check is player is a snowplow
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isSnowplowDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "snowplowdriver"));
}

/**
 * Check is player's vehicle is a snowplow truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleSnowplow(playerid) {
    return (isPlayerInValidVehicle(playerid, 39));
}

/**
Event: JOB - Snowplow driver - Already have job
*/
key("e", function(playerid) {

    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    if (getPlayerJob(playerid) && getPlayerJob(playerid) != SNOWPLOW_JOB_NAME) {
        return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), SNOWPLOW_JOB_COLOR );
    }
})


function snowplowJobGet( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    //return msg(playerid, "job.not-available", CL_ERROR );

    if(!isPlayerHaveValidPassport(playerid)) {
               msg(playerid, "job.needpassport", SNOWPLOW_JOB_COLOR );
        return msg(playerid, "passport.toofar", CL_LYNCH );
    }

    // если у игрока недостаточный уровень
    // if(!isPlayerLevelValid ( playerid, SNOWPLOW_JOB_LEVEL )) {
    //     return msg(playerid, "job.snowplow.needlevel", SNOWPLOW_JOB_LEVEL, SNOWPLOW_JOB_COLOR );
    // }

    if (getCharacterIdFromPlayerId(playerid) in job_snowplow_blocked) {
        if (getTimestamp() - job_snowplow_blocked[getCharacterIdFromPlayerId(playerid)] < SNOWPLOW_JOB_TIMEOUT) {
            return msg( playerid, "job.snowplow.badworker", SNOWPLOW_JOB_COLOR);
        }
    }
    msg( playerid, "job.snowplow.driver.now", SNOWPLOW_JOB_COLOR );
    msg( playerid, "job.snowplow.driver.togetroute", CL_LYNCH );
    setPlayerJob( playerid, "snowplowdriver");
    setPlayerJobState( playerid, null);

    //snowplowJobStartRoute( playerid );
    createText (playerid, "leavejob3dtext", SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, SNOWPLOW_JOB_Z+0.05, plocalize(playerid, "3dtext.job.press.leave"), CL_WHITE.applyAlpha(100), RADIUS_SNOWPLOW_SMALL );
}
addJobEvent("e", null,    null, snowplowJobGet);
addJobEvent("e", null, "nojob", snowplowJobGet);


/**
Event: JOB - Snowplow driver - Need complete
*/
function snowplowJobNeedComplete( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    msg( playerid, "job.snowplow.route.needcomplete", SNOWPLOW_JOB_COLOR );
}
addJobEvent("e", SNOWPLOW_JOB_NAME,  "working", snowplowJobNeedComplete);


/**
Event: JOB - Snowplow driver - Completed
*/
function snowplowJobCompleted( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    setPlayerJobState(playerid, null);
    snowplowGetSalary( playerid );
    job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"] = false;
    jobRestorePlayerModel(playerid);
    return;
}
addJobEvent("e", SNOWPLOW_JOB_NAME,  "complete", snowplowJobCompleted);


/**
Event: JOB - Snowplow driver - Leave job
*/
function snowplowJobLeave( playerid ) {
    if(!isSnowplowDriver(playerid)) {
        return;
    }

    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW_SMALL)) {
        return;
    }

    if(getPlayerJobState(playerid) == null) {
        msg( playerid, "job.snowplow.goodluck", SNOWPLOW_JOB_COLOR);
    }

    if(getPlayerJobState(playerid) == "working") {
        return msg( playerid, "job.snowplow.needCompleteToLeave", SNOWPLOW_JOB_COLOR );
    }

    if(getPlayerJobState(playerid) == "complete") {
        setPlayerJobState(playerid, null);
        snowplowGetSalary( playerid );
        job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"] = false;
        msg( playerid, "job.snowplow.goodluck", SNOWPLOW_JOB_COLOR);
    }

    removeText(playerid, "leavejob3dtext");
    trigger(playerid, "removeGPS");

    setPlayerJob( playerid, null );
    jobRestorePlayerModel(playerid);
    msg( playerid, "job.leave", SNOWPLOW_JOB_COLOR );

    // remove private blip job
    removePersonalJobBlip ( playerid );

}
addJobEvent("q", SNOWPLOW_JOB_NAME,       null, snowplowJobLeave);
addJobEvent("q", SNOWPLOW_JOB_NAME,  "working", snowplowJobLeave);
addJobEvent("q", SNOWPLOW_JOB_NAME, "complete", snowplowJobLeave);


/**
Event: JOB - Snowplow driver - Get salary
*/
function snowplowGetSalary( playerid ) {
    local amount = getGovernmentValue("salarySnowplowDriver") + getSalaryBonus();
    players[playerid].data.jobs.snowplowdriver.count += 1;
    addPlayerMoney(playerid, amount);
    subTreasuryMoney(amount);
    local moneyInTreasuryNow = getTreasuryMoney();
    msg(playerid, "job.snowplow.nicejob", amount, SNOWPLOW_JOB_COLOR);
    nano({
        "path": "discord",
        "server": "gov",
        "channel": "treasury",
        "action": "sub",
        "author": getPlayerName(playerid),
        "description": "Расход",
        "color": "red",
        "datetime": getVirtualDate(),
        "direction": false,
        "fields": [
            ["Сумма", format("$ %.2f", amount)],
            ["Основание", "Заработная плата водителю снегоуборочной машины за пройденный маршрут"],
            ["Баланс", format("$ %.2f", moneyInTreasuryNow)],
        ]
    })
}

/**
Event: JOB - SNOWPLOW driver - Start route
*/
function snowplowJobStartRoute( playerid ) {
    if(!isPlayerInValidPoint(playerid, SNOWPLOW_JOB_X, SNOWPLOW_JOB_Y, RADIUS_SNOWPLOW)) {
        return;
    }

    if(!isPlayerHaveValidPassport(playerid)) {
               msg(playerid, "job.needpassport", SNOWPLOW_JOB_COLOR );
        return msg(playerid, "passport.toofar", CL_LYNCH );
    }

    if(SNOWPLOW_ROUTE_NOW < 1) {
        return msg( playerid, "job.snowplow.nojob", SNOWPLOW_JOB_COLOR );
    }

    setPlayerJobState( playerid, "working");
    //jobSetPlayerModel( playerid, SNOWPLOW_JOB_SKIN );

    SNOWPLOW_ROUTE_NOW -= 1;

    local targetPointsCount = random(100, 200);

    local ts1 = getSnowplowNodeTimestamp(1);
    local ts101 = getSnowplowNodeTimestamp(101);
    local snowplowId = ts101 >= ts1 ? 101 : 1; // 1 or 101

    job_snowplow[getCharacterIdFromPlayerId(playerid)]["route"] <- {
        targetPointsCount = targetPointsCount,
        currentPointsCount = 0,
        lastPointId = snowplowId
    };

    // msg( playerid, "Route: %d", [routeNumber] );
    msg( playerid, "job.snowplow.startroute" , SNOWPLOW_JOB_COLOR );
    msg( playerid, "job.snowplow.startroute2", SNOWPLOW_JOB_COLOR );
    job_snowplow[getCharacterIdFromPlayerId(playerid)]["snowplow3dtext"] = createPrivateSnowplowCheckpoint3DText(playerid, nodes[snowplowId].coords);

    createPrivatePlace(playerid, "snowplowZone",
        nodes[snowplowId].coords.x - 1.5,
        nodes[snowplowId].coords.y + 1.5,
        nodes[snowplowId].coords.x + 1.5,
        nodes[snowplowId].coords.y - 1.5
    );

    trigger(playerid, "setGPS", nodes[snowplowId].coords.x, nodes[snowplowId].coords.y);
}
addJobEvent("e", SNOWPLOW_JOB_NAME, null, snowplowJobStartRoute);



event("onPlayerAreaEnter", function(playerid, name) {
    if (isSnowplowDriver(playerid) && isPlayerVehicleSnowplow(playerid) && getPlayerJobState(playerid) == "working") {
        if(name == "snowplowZone") {
            local vehicleid = getPlayerVehicle(playerid);
            local speed = getVehicleSpeed(vehicleid);
            local maxsp = max(fabs(speed[0]), fabs(speed[1]));
            if(maxsp > 14) {
                return msg(playerid, "job.snowplow.driving", CL_RED);
            }
            removePrivateArea(playerid, "snowplowZone");
            removeText( playerid, "snowplow_3dtext");
            trigger(playerid, "removeGPS");

            local charId = getCharacterIdFromPlayerId(playerid);

            local route = job_snowplow[charId].route;

            route.currentPointsCount += 1;

            if (route.currentPointsCount == route.targetPointsCount) { // TODO
                blockDriving(playerid, vehicleid);
                msg(playerid, "job.snowplow.gototakemoney", SNOWPLOW_JOB_COLOR);
                setPlayerJobState(playerid, "complete");
                return;
            }

            local nextPoints = edges[route.lastPointId];
            local snowplowId = nextPoints[random(0, nextPoints.len() - 1)];

            trigger(playerid, "setGPS", nodes[snowplowId].coords.x, nodes[snowplowId].coords.y);
            job_snowplow[charId].snowplow3dtext = createPrivateSnowplowCheckpoint3DText(playerid, nodes[snowplowId].coords);
            createPrivatePlace(playerid, "snowplowZone",
                nodes[snowplowId].coords.x - 1.5,
                nodes[snowplowId].coords.y + 1.5,
                nodes[snowplowId].coords.x + 1.5,
                nodes[snowplowId].coords.y - 1.5
            );
        }
    }
});


function findPath(indexStart, indexEnd) {
    local path = [];
    local nodesData = {};

    nodesData[indexStart] <- {
        "g": 0,
        "h": 0,
        "f": 0,
        "parent": null
     };


    local activePoint = indexStart;

    local open = [indexStart];
    local close = [];

    function resolvePath() {
        local path = [ indexEnd ];
        local n = indexEnd;

        while (n != null && n != indexStart) {
            foreach (idx, node in nodesData) {
                if(n == indexStart) {
                    break;
                }
                if(idx == n) {
                    n = node.parent;
                    array_unshift(path, node.parent);
                    continue;
                }
            }
        }

        return path;
    }

    // Стоимость пути от предыдущей вершины до вершины «n»;
    function G(n) {
        // dbg("find distance G", activePoint, n)
        local disG = getDistanceXYZ(
            nodes[activePoint].coords.x,
            nodes[activePoint].coords.y,
            nodes[activePoint].coords.z,
            nodes[n].coords.x,
            nodes[n].coords.y,
            nodes[n].coords.z
        ) + nodesData[activePoint].g;

        if (disG < nodesData[n].g) {
            nodesData[n].g = disG;
            nodesData[n].parent = activePoint;
        }

        return disG;
    }

    // Эвристический показатель стоимости пути от вершины «n» до конечной вершины.
    function H(n) {
        local disH = getDistanceXYZ(
            nodes[n].coords.x,
            nodes[n].coords.y,
            nodes[n].coords.z,
            nodes[indexEnd].coords.x,
            nodes[indexEnd].coords.y,
            nodes[indexEnd].coords.z
        )

        if (disH < nodesData[n].h)
            nodesData[n].h = disH;

        return disH;
    }

    function F(n) {
        local fn = G(n) + H(n);

        if (fn < nodesData[n].f)
            nodesData[n].f = fn;

        // dbg(format("nodesData[%d]", n), nodesData[n])

        return fn;
    }

    function find(id) {
        // Берём точку с наименьшим суммарным расстоянием из списка открытых
        // От неё находим расстояния, эвристику и сумму до всех доступных next-точек
        // Каждой точке записываем откуда пришли
        // Удаляем исходную точку из открытых

        // Если следующая точка == конечной точке,

        activePoint = id;
        // dbg("change activePoint to:", activePoint)

        foreach(idx, pointId in edges[id]) {
            if(!(pointId in nodesData)) {
                nodesData[pointId] <- {
                    "g": 9999.0,
                    "h": 9999.0,
                    "f": 9999.0,
                    "parent": id
                };
            }

            if(close.find(pointId) != null) {
                continue;
            }

            if(open.find(pointId) == null) {
                open.push(pointId);
            }

            F(pointId);

        }

        // Удалить текущую вершину из открытых
        open.remove(open.find(id));
        close.push(id);
        // dbg("open", open)

        local distances = open.map(function(pointId) {
            return nodesData[pointId].f;
        });

        // dbg("distances", distances)

        local minDistance = minOfArray(distances);
        // dbg("minDistance", minDistance)

        local idx = distances.find(minDistance);
        // dbg("idx", idx)
        local nextPointId = open[idx];

        // dbg("nextPointId", nextPointId)
        // dbg("________________________")

        if(nextPointId != indexEnd)
            find(nextPointId)

    }

    find(indexStart)

    return resolvePath();
}



// function findPath(indexStart, indexEnd) {
//     local result = [];

//     function find(id, nextPoints) {
//         local bestNextPointId;
//         if(edges[id].len() > 1) {
//             local distances = nextPoints.map(function(pointId) {
//                 return getDistanceXYZ(
//                     nodes[pointId].coords.x,
//                     nodes[pointId].coords.y,
//                     nodes[pointId].coords.z,
//                     nodes[indexEnd].coords.x,
//                     nodes[indexEnd].coords.y,
//                     nodes[indexEnd].coords.z
//                 )
//             });

//             dbg("distances", distances)

//             local minDistance = minOfArray(distances);

//             dbg("minDistance", minDistance)
//             local idx = distances.find(minDistance);
//             dbg("idx", idx)
//             bestNextPointId = nextPoints[idx];
//         } else {
//             bestNextPointId = nextPoints[0];
//         }

//         dbg("edges[id]", edges[id])
//         dbg("bestNextPointId", bestNextPointId)

//         if(result.find(bestNextPointId) != null) {
//             local clonedPoints = edges[id].filter(function(i, item) {
//                 return item != bestNextPointId;
//             })
//             find(id, clonedPoints);
//             return;
//         }

//         result.push(bestNextPointId);

//         dbg("result")

//         if(bestNextPointId == indexEnd) return;

//         find(bestNextPointId, clone edges[bestNextPointId]);
//     }

//     find(indexStart, clone edges[indexStart]);

//     return result;
// }

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (isSnowplowDriver(playerid) && getVehicleModel(vehicleid) == 39 && getPlayerJobState(playerid) == "complete") {
        delayedFunction(6000, function () {
            tryRespawnVehicleById(vehicleid, true);
        });
    }
});


function getNearestSnowplowStationForPlayer(playerid) {
    local pos = getPlayerPositionObj( playerid );
    local dis = 5;
    local snowplowStopid = null;
    foreach (key, value in nodes) {
        local distance = getDistanceBetweenPoints3D( pos.x, pos.y, pos.z, value.public.x, value.public.y, value.public.z );
        if (distance < dis) {
           dis = distance;
           snowplowStopid = key;
        }
    }
    return snowplowStopid;
}

acmd("snow", "setroutesall", function(playerid, ...) {
    if (!vargv.len()) msg(playerid, "Need to write numbers of snowplower routes separated by space.");

    routes_list_all = [];
    foreach (idx, value in vargv) {
        routes_list_all.push(value.tointeger());
    }
    routes_list = clone (routes_list_all);
    msg(playerid, "New list of snowplower routes: "+concat(routes_list_all) );
});


acmd("snow", "getroutes", function(playerid) {
    msg(playerid, "List of available snowplower routes: "+concat(routes_list) );
});

acmd("snow", "getroutesall", function(playerid) {
    msg(playerid, "List of all snowplower routes: "+concat(routes_list_all) );
});

acmd("snow", "goto", function(playerid, snowplowId) {
    local pos = nodes[snowplowId.tointeger()].coords;
    setPlayerPosition(playerid, pos.x, pos.y, pos.z)
});
