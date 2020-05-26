include("modules/organizations/police/models/PoliceTicket.nut");

cmd("help", ["police"], function(playerid) {
    msgh(playerid, "Полиция", [
        "/help police radio - про рацию в автомобиле",
        "/help police rupor - про рупор в автомобиле",
        "Клавиша B - показать значок сотрудника полиции",
        "Клавиша G - ударить дубинкой ближайшего персонажа",
        "Клавиша V - надеть наручники на ближайшего персонажа",
        "/ticket id - выдать штраф игроку. Пример: /ticket 2",
        "/uncuff id - снять наручники с ближайшего персонажа",
        // "/prison id - посадить персонажа с указанным id в тюрьму",
        // "/amnesty id - отпустить из тюрьмы персонажа с указанным id",
        "/park номер - отправить автомобиль на штрафстоянку",
        "/wanted - посмотреть список разыскиваемых автомобилей",
        "/wanted car номер - пробить номер автомобиля по базе розыска",
    ]);
});

cmd("help", ["police", "radio"], function(playerid) {
    msgh(playerid, "Рация", [
        "/r текст - сказать что-либо в рацию",
        "Клавиша V в машине - готовые короткие сообщения по рации",
        "/r get - узнать текущий канал рации в автомобиле",
        "/r set число - установить канал рации в автомобиле",
    ]);
});

cmd("help", ["police", "rupor"], function(playerid) {
    msgh(playerid, "Рупор", [
        "/m текст - сказать что-либо в рупор служебной машины",
        "Клавиша B в машине - готовые короткие сообщения в рупор",
    ]);
});

acmd("a", ["police", "danger"], function(playerid, level) {
    setDangerLevel(playerid, level);
});


// usage: /police job <id>
acmd("a", ["police", "job"], function(playerid, targetid) {
    local targetid = targetid.tointeger();
    setPoliceJob(playerid, targetid);
    msg(playerid, "organizations.police.setjob.byadmin", [ getAuthor(targetid), getLocalizedPlayerJob(targetid) ] );
    dbg( "[POLICE JOIN]" + getAuthor(playerid) + " add " + getAuthor(targetid) + "to Police" );
});


// usage: /police job leave <id>
acmd("a", ["police", "job", "leave"], function(playerid, targetid) {
    local targetid = targetid.tointeger();
    msg(playerid, "organizations.police.leavejob.byadmin", [ getAuthor(targetid), getLocalizedPlayerJob(targetid) ]);
    dbg( "[POLICE LEAVE]" + getAuthor(playerid) + " remove " + getAuthor(targetid) + "from Police" );
    leavePoliceJob(playerid, targetid, "Несоответствие требованиям ПД");
});


// usage: /police set rank <0..14>
acmd("a", ["police", "set", "rank"], function(playerid, targetid, rank) {
    targetid = targetid.tointeger();
    rank = rank.tointeger();

    if ( !isOfficer(targetid) ) {
        return msg(playerid, "organizations.police.notanofficer"); // not you, but target
    }

    if (rank >= 0 && rank <= POLICE_MAX_RANK) {
        if ( isOnPoliceDuty(playerid) ) {
            trigger("onPoliceDutyOff", playerid);
            setPoliceRank( targetid, rank );
            trigger("onPoliceDutyOn", playerid);
            setPlayerJob( targetid, POLICE_RANK[rank] );
            msg( playerid, "organizations.police.onrankset", [getAuthor(targetid), getLocalizedPlayerJob(targetid)]);
        } else {
            setPoliceRank( targetid, rank );
            setPlayerJob( targetid, POLICE_RANK[rank] );
            msg( playerid, "organizations.police.onrankset", [getAuthor(targetid), getLocalizedPlayerJob(targetid)]);
        }
    }
});


acmd("serial", function(playerid, targetid) {
    local targetid = targetid.tointeger();
    dbg( [players[targetid]["serial"]] );
    return msg( playerid, "general.admins.serial.get", [getAuthor(targetid), players[targetid]["serial"]], CL_THUNDERBIRD );
});


/*
// usage: /police Train Station
cmd("police", function(playerid, ...) {
    local place = concat(vargv);

    // local pos = getPlayerPositionObj(playerid);
    // local data = url_encode(base64_encode(format("%s: %s; coord [%.3f, %.3f, %.3f]", getAuthor(playerid), concat(vargv), pos.x, pos.y, pos.z)));
    // webRequest(HTTP_TYPE_GET, MOD_HOST, "/discord?type=police&data=" + data, function(a,b,c) {}, MOD_PORT);

});
*/

// usage in phone booth: /police
cmd("police", function(playerid) {
    __commands["call"][COMMANDS_DEFAULT](playerid, "police");
});


// usage: /police job <id>
cmd("police", ["job"], function(playerid, targetid) {
    local targetid = targetid.tointeger();
    if ( getPoliceRank(playerid) == POLICE_MAX_RANK ) {
        if ( isPlayerHaveJob(targetid) ) {
            msg(playerid, "job.alreadyhavejob", getLocalizedPlayerJob(targetid), CL_RED);
            return;
        }

        if (players[targetid].xp < 1500) {
                   msg(targetid, "organizations.police.lowxp.target", CL_RED);
            return msg(playerid, "organizations.police.lowxp", [ getPlayerName(targetid) ], CL_RED);
        }

        local targetName = getKnownCharacterName(playerid, targetid);

        if(!players[targetid].inventory.isFreeSpace(1)) {
                   msg(playerid, "inventory.space.notenough-for-target", [ targetName ], CL_THUNDERBIRD);
            return msg(targetid, "inventory.space.notenough", CL_THUNDERBIRD);
        }

        local policeBadge = Item.PoliceBadge();

        if (!players[targetid].inventory.isFreeVolume(policeBadge)) {
                   msg(playerid, "inventory.volume.notenough-for-target", [ targetName ], CL_THUNDERBIRD);
            return msg(targetid, "inventory.volume.notenough", CL_THUNDERBIRD);
        }

        policeBadge.setData("number", getHashToPoliceBadge(targetName));
        policeBadge.setData("fio", targetName);

        players[targetid].inventory.push( policeBadge );
        policeBadge.save();
        players[targetid].inventory.sync();

        setPoliceJob(playerid, targetid);
        msg(playerid, "organizations.police.setjob.byadmin", [getKnownCharacterNameWithId(playerid, targetid), getLocalizedPlayerJob(targetid)]);
    }
});


// usage: /police job leave <id>
cmd("police", ["job", "leave"], function(playerid, targetid, ...) {
    local targetid = targetid.tointeger();

    if ( getPoliceRank(playerid) == POLICE_MAX_RANK ) {
        if(vargv.len() == 0) {
            msg(playerid, "Не указана причина увольнения", CL_ERROR);
        }
        local reason = concat(vargv);

        msg(playerid, "organizations.police.leavejob.byadmin", [ getKnownCharacterNameWithId(playerid, targetid), getLocalizedPlayerJob(targetid) ]);
        leavePoliceJob(playerid, targetid, reason)
    }
});


// usage: /police set rank <0..14>
cmd("police", ["set", "rank"], function(playerid, targetid, rank) {
    targetid = targetid.tointeger();
    rank = rank.tointeger();
    if ( getPoliceRank(playerid) == POLICE_MAX_RANK ) {
        if ( !isOfficer(targetid) ) {
            return msg(playerid, "organizations.police.notanofficer"); // not you, but target
        }

        if (rank >= 0 && rank <= POLICE_MAX_RANK) {
            local job = getLocalizedPlayerJob(targetid);
            if ( isOnPoliceDuty(playerid) ) {
                trigger("onPoliceDutyOff", playerid);
                setPoliceRank( targetid, rank );
                trigger("onPoliceDutyOn", playerid);
                setPlayerJob( targetid, POLICE_RANK[rank] );
                msg( playerid, "organizations.police.onrankset", [getKnownCharacterNameWithId(playerid, targetid), getLocalizedPlayerJob(targetid)]);
            } else {
                setPoliceRank( targetid, rank );
                setPlayerJob( targetid, POLICE_RANK[rank] );
                msg( playerid, "organizations.police.onrankset", [getKnownCharacterNameWithId(playerid, targetid), getLocalizedPlayerJob(targetid)]);
            }
            local newJob = getLocalizedPlayerJob(targetid);
            nano({
                "path": "discord",
                "server": "police",
                "channel": "news",
                "action": "rank",
                "author": getPlayerName(playerid),
                "title": getPlayerName(targetid),
                "description": "Изменена должность",
                "color": "blue",
                "datetime": getDateTime(),
                "fields": [
                    ["Предыдущая должность", job],
                    ["Новая должность", newJob]
                ]
            });
        }
    }
});


cmd("police", ["danger"], function(playerid, level) {
    if ( getPoliceRank(playerid) == POLICE_MAX_RANK ) {
        setDangerLevel(playerid, level);
    }
});


/*
cmd("police", ["badge"], function(playerid, targetid = null) {
    local nearestid = targetid;
    if (targetid != null) {
        nearestid = targetid.tointeger();
    } else {
        nearestid = playerList.nearestPlayer( playerid );
    }

    if ( nearestid == null) {
        return msg(playerid, "general.noonearound");
    }

    showBadge(playerid, targetid);
});


// show badge
key(["b"], function(playerid) {
    if ( !isOfficer(playerid) ) {
        return;
    }

    if ( isPlayerInVehicle(playerid) ) {
        return;
    }

    if ( isOfficer(playerid) && !isOnPoliceDuty(playerid) ) {
        return msg( playerid, "organizations.police.duty.off" );
    }

    local target = playerList.nearestPlayer( playerid );
    if ( target == null) {
        return msg(playerid, "general.noonearound");
    }

    if ( isBothInRadius(playerid, target, POLICE_BADGE_RADIUS) ) {
        showBadge(playerid);
    }
}, KEY_UP);
*/

// set duty on or off
key(["e"], function(playerid) {
    if ( isPlayerInVehicle(playerid) ) {
        return;
    }
    if ( !isOfficer(playerid) && isPlayerNearPoliceDepartment(playerid) ) {
        return msg( playerid, "organizations.police.notanofficer" );
    }
    if ( isOfficer(playerid) && isPlayerNearPoliceDepartment(playerid) ) {
        local bool = isOnPoliceDuty(playerid);
        policeSetOnDuty(playerid, !bool);
    }
}, KEY_UP);


policecmd("m", function(playerid, text) {
    if ( !isOfficer(playerid) ) {
        return;
    }
    if ( !isPlayerInPoliceVehicle(playerid) ) {
        return msg( playerid, "organizations.police.notinpolicevehicle");
    }

    sendLocalizedMsgToAll(playerid, "[POLICE RUPOR] "+text, [], RUPOR_RADIUS, CL_ROYALBLUE);
});

// local function policetestitout(playerid, targetid, vehid) {
//     putPlayerInVehicle(targetid, vehid, 1);
// }

// acmd(["transport", "suspect"], function(playerid, targetid) {
//     targetid = targetid.tointeger();
//     local veh = getPlayerVehicle(playerid);
//     policetestitout(playerid, targetid, veh);
// });

// put nearest cuffed player in jail
// cmd(["prison", "jail"], function(playerid, targetid, ...) {
//     if ( !isOfficer(playerid) ) {
//         return;
//     }
//     if(targetid == null) return msg(playerid, "Формат: /jail id причина+срок");
//     if(vargv.len() == 0) return msg(playerid, "Не указана причина", CL_ERROR);
//     targetid = targetid.tointeger();
//     if(getPoliceRank(playerid) < 2) return msg( playerid, "organizations.police.lowrank" );
//     local reason = concat(vargv);
//     putInJail(playerid, targetid, reason);
// });


// take out player from jail
// cmd(["amnesty"], function(playerid, targetid) {
//     if ( !isOfficer(playerid) ) {
//         return;
//     }
//     if(targetid == null) return msg(playerid, "Формат: /amnesty id");
//     if(getPoliceRank(playerid) < 2) return msg( playerid, "organizations.police.lowrank" );
//     targetid = targetid.tointeger();
//     takeOutOfJail(playerid, targetid);
// });

 // /park plate_number
cmd("park", function ( playerid, plate) {
    if ( isPlayerInVehicle(playerid) ) {
        return;
    }
    if ( !isOfficer(playerid) ) { // check if not officer
        return;
    }
    if ( !isOnPoliceDuty(playerid) ) {
        return msg( playerid, "organizations.police.duty.not", CL_ERROR );
    }
    if ( getPoliceRank(playerid) < 1) {
        return msg( playerid, "organizations.police.lowrank", CL_ERROR );
    }

    if ( getDistanceBtwPlayerAndVehicle(playerid, getVehicleByPlateText(plate.toupper())) > 3.0) {
        return msg( playerid, "organizations.police.toofarfromvehicle", CL_ERROR );
    }

    trigger("onVehicleSetToCarPound", playerid, plate);
});

// player need to be in car
cmd("unpark", function ( playerid ) {
    trigger("onVehicleGetFromCarPound", playerid);
});


// player need to be in car
cmd("wanted", function ( playerid ) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.notanofficer");
    }

    if( !isPlayerInPoliceVehicle(playerid) ) {
        return msg( playerid, "organizations.police.notinpolicevehicle");
    }

    if ( !isOnPoliceDuty(playerid) ) {
        return msg( playerid, "organizations.police.duty.not" );
    }
    local list = "";
    local count = vehicleWanted.len()
    for (local i = 0; i < count; i++) {
        list += vehicleWanted[i];
        if(i < count-1) list += ", ";
    }
    msg(playerid, "organizations.police.carwantedtax", [ list ], CL_ROYALBLUE);
});

// player need to be in car
cmd("wanted", "car", function ( playerid, plate = null) {
    if ( !isOfficer(playerid) ) {
        return msg(playerid, "organizations.police.notanofficer");
    }

    if( !isPlayerInPoliceVehicle(playerid) ) {
        return msg( playerid, "organizations.police.notinpolicevehicle");
    }

    if ( !isOnPoliceDuty(playerid) ) {
        return msg( playerid, "organizations.police.duty.not" );
    }

    if (plate == null || plate.len() < 6) {
        return msg( playerid, "parking.needEnterPlate");
    }

    local vehicleid = getVehicleByPlateText(plate.toupper());
    if(vehicleid == null) {
        return msg( playerid, "parking.checkPlate");
    }

    if(vehicleWanted.find(plate.toupper()) == null) {
        return msg(playerid, "organizations.police.carnotwanted", plate.toupper(), CL_SUCCESS);
    }

    return msg(playerid, "organizations.police.carwanted", plate.toupper(), CL_ERROR);
});
