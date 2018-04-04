local closedAreasTemp = {};

event("onServerPlayerStarted", function(playerid) {
    local characterId = getCharacterIdFromPlayerId(playerid);
    if ( !(characterId in closedAreasTemp) ) {
        closedAreasTemp[characterId] <- {};
        closedAreasTemp[characterId]["name"] <- null;
        closedAreasTemp[characterId]["points"] <- [];
        closedAreasTemp[characterId]["here"] <- null;
    }
});


/**
 * Create
 */
acmd(["areas"], ["new", "create", "-n"], function(playerid, name) {
    if (!name || name.len() < 1) return msg(playerid, "Использование: /areas new <имя>");

    local characterId = getCharacterIdFromPlayerId(playerid);

    local length = closedAreasTemp[characterId].points.len();
    if(length > 0) {
        return msg(playerid, "Ранее вы добавили точек: "+length+". Начать заново? [да/нет]");

        trigger(playerid, "hudCreateTimer", 30000, true, true);
        requestUserInput(playerid, function(playerid, text) {
            trigger(playerid, "hudDestroyTimer");
            if (text.tolower() == "да") {
                closedAreasTemp[characterId].name = name;
                closedAreasTemp[characterId].points.clear();
                msg(playerid, "Начато создано новой зоны: " + name);
                msg(playerid, "Добавление точки: /areas point");
            } else {
                msg(playerid, "Создание новой зоны отменено.");
            }
        }, 30000);
    }

    closedAreasTemp[characterId].name = name;
    closedAreasTemp[characterId].points.clear();
    msg(playerid, "Начато создано новой зоны: " + name);
    msg(playerid, "Добавление точки: /areas point");
});

/**
 * Create
 */
acmd(["areas"], ["point", "p", "-p"], function(playerid) {
    local characterId = getCharacterIdFromPlayerId(playerid);

    if ( closedAreasTemp[characterId].name == null) {
        return msg(playerid, "Прежде начните создание: /areas new <имя>");
    }

    if(closedAreasTemp[characterId].points.len() == 2) {
        msg(playerid, "Пока можно создавать только прямоугольники (2 точки)");
        msg(playerid, "Куда ТПшить: /areas here");
        return msg(playerid, "Завершить: /areas save");
    }

    local pos = getPlayerPosition(playerid);

    closedAreasTemp[characterId].points.push({x = pos[0], y = pos[1]});

    msg(playerid, "Добавлена точка к зоне: " + closedAreasTemp[characterId].name);
});


/**
 * Create
 */
acmd(["areas"], ["undo", "u", "-u"], function(playerid) {
    local characterId = getCharacterIdFromPlayerId(playerid);

    if ( closedAreasTemp[characterId].name == null) {
        return msg(playerid, "Создание не было начато. Начать: /areas new <имя>");
    }

    local length = closedAreasTemp[characterId].points.len();
    if(length == 0) {
        return msg(playerid, "Нет добавленных точек");
    }

    delete closedAreasTemp[characterId].points[length - 1];

    msg(playerid, "Добавление точки отменено");
});


/**
 * Create
 */
acmd(["areas"], ["here", "h", "-h"], function(playerid) {
    local characterId = getCharacterIdFromPlayerId(playerid);

    if ( closedAreasTemp[characterId].name == null) {
        return msg(playerid, "Прежде начните создание: /areas new <имя>");
    }

    local pos = getPlayerPosition(playerid);

    closedAreasTemp[characterId].here = Vector3(pos[0], pos[1], pos[2]);

    msg(playerid, "Установлено место возврата.");
});

/**
 * Create
 */
acmd(["areas"], ["save", "s", "-s"], function(playerid) {
    local characterId = getCharacterIdFromPlayerId(playerid);

    if ( closedAreasTemp[characterId].name == null) {
        return msg(playerid, "Создание не было начато. Начать: /areas new <имя>");
    }

    local length = closedAreasTemp[characterId].points.len();
    if(length == 0) {
        return msg(playerid, "Нет добавленных точек");
    }

    if(length < 2) {
        return msg(playerid, "Должно быть минимум две точки!");
    }

    local cl = ClosedAreas();
    local pos = getPlayerPosition(playerid);

    cl.x = pos[0];
    cl.y = pos[1];
    cl.z = pos[2];
    cl.data = []
    cl.name = name;

    tpp.save(function(err, result) {
        msg(playerid, "Создана новая зона #" + tpp.id);
    });
});


/*

/areas - список зон
/area new name




 */

/**
 * List all positions (paginated)
 */
acmd(["areas"], function(playerid, page = "0") {
    local q = ORM.Query("select * from @ClosedAreas limit :page, 10");

    q.setParameter("page", max(0, page.tointeger()) * 10);
    q.getResult(function(err, results) {
        msg(playerid, format("Страница %s (следующая: /areas <номер>):", page) );

        // list
        return results.map(function(item) {
            msg(playerid, format(" #%d. %s", item.id, item.name), CL_WHITE);
        })
    });
});

/**
 * List all positions (paginated)
 */
acmd(["areas"], ["groups", "g", "-g"], function(playerid, page = "0") {
    local q = ORM.Query("select * from @ClosedAreas where parent = 0 limit :page, 10");

    q.setParameter("page", max(0, page.tointeger()) * 10);
    q.getResult(function(err, results) {
        msg(playerid, format("Страница %s (следующая: /areas <номер>):", page) );

        // list
        return results.map(function(item) {
            msg(playerid, format(" #%d. %s", item.id, item.name), CL_WHITE);
        })
    });
});


/**
 * Remove position
 */
acmd(["areas"], ["delete", "del", "remove", "rem"], function(playerid, nameOrId) {
    local callback = function(err, item) {
        if (!item) return sendPlayerMessage(playerid, "Не найдена зона: " + nameOrId);
        sendPlayerMessage(playerid, "Удалена зона #" + item.id, 240, 240, 200);
        item.remove();
    };

    if (isInteger(nameOrId)) {
        ClosedAreas.findOneBy({ id = nameOrId.tointeger() }, callback);
    } else {
        ClosedAreas.findOneBy({ name = nameOrId }, callback);
    }
});



/*
/areas point - поставить точку

/areas save name [group] - сохранение под именем name, тут же записывается позиция возврата, если есть номер группы - записывается parent

/areas undo - отменить установку точки
/areas remove id - удалить зону
/areas reset - сброс в пустые значения

/areas - список зон
/areas groups - список групп
/areas new -


имя: areas_name_groupName (groupName если есть)


acmd("rims", function(playerid) {
    local vehicleid = vehicles.nearestVehicle(playerid).vehicleid;
    local rimsId = getVehicleWheelTexture(vehicleid, 0);
    if(rimsId == 255) rimsId = -1;
    rimsId += 1;
    setVehicleWheelTexture(vehicleid, 0, rimsId);
    setVehicleWheelTexture(vehicleid, 1, rimsId);
    setVehicleWheelTexture(vehicleid, 3, rimsId);
})
acmd("resetrims", function(playerid) {
    local vehicleid = vehicles.nearestVehicle(playerid).vehicleid;
    setVehicleWheelTexture(vehicleid, 0, 0);
    setVehicleWheelTexture(vehicleid, 1, 0);
    setVehicleWheelTexture(vehicleid, 3, 0);
})

*/
