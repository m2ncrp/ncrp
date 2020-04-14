local places = [
    "",
    {
        name = "Автобусное депо",
        x = -417.277,
        y = 479.403
    },
    {
        name = "Автосалон Diamond Motors",
        x = -199.046,
        y = 829.401
    },
    {
        name = "Банк",
        x = -323.211,
        y = -99.6398
    },
    {
        name = "Вокзал",
        x = -573.259,
        y = 1598.71
    },
    {
        name = "Госпиталь",
        x = -392.446,
        y = 900.243
    },
    {
        name = "Мэрия",
        x = -122.331,
        y = -62.9116
    },
    {
        name = "Полицейский участок",
        x = -381.906,
        y = 642.781
    },
    {
        name = "Порт",
        x = -372.436,
        y = -746.01
    },
    {
        name = "Рыбный склад Seagift (Дары моря)",
        x = 367.556,
        y = 99.3746
    },
    {
        name = "Скотобойня",
        x = 33.1325,
        y = 1766.6
    },
    {
        name = "Топливная компания Trago Oil",
        x = 535.448,
        y = -275.97
    },
    {
        name = "Штрафстоянка",
        x = -1300.0,
        y = 1358.0
    }
]

cmd(["map"], function(playerid, id = "-1") {
    local len = places.len()-1;
    if(id == "-1") {
        local placesText = [];
        for (local i = 1; i <= len; i++) {
            placesText.push(format("%s: /map %d", places[i].name, i))
        }
        return msgh(playerid, "Места", placesText);
    }

    id = toInteger(id);

    if(id < 1 || id > len) {
        return msg(playerid, "Неверно указан номер места");
    }

    local place = places[id];
    local sblip_hash = createPrivateBlip(playerid, place.x, place.y, ICON_YELLOW, 4000.0);
    msg(playerid, format("Место «%s» отображено на карте жёлтым кругом на 20 секунд.", place.name), CL_SUCCESS);
    delayedFunction(20000, function() {
        removeBlip( sblip_hash );
    });
});