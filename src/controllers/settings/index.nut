include("controllers/settings/models/Settings.nut");

local settingsLoadedData = [];

event("onServerStarted", function() {
    logStr("[admin] loading settings...");

    settingsLoadedDataRead();
});

function settingsLoadedDataRead() {
    Settings.findAll(function(err, results) {
        if(results.len()) {
          settingsLoadedData = results
        } else {
            local items = [
                {
                    name = "season",
                    desc = "Сезон",
                    value = "summer",
                },
                {
                    name = "donate",
                    desc = "Доступность доната",
                    value = "true",
                },
                {
                    name = "weaponsAvailable",
                    desc = "Доступность оружия",
                    value = "false",
                },
                {
                    name = "worldMoney",
                    desc = "Сумма денег игрового мира",
                    value = "0.0",
                },
                {
                    name = "isTruckShopEnabled",
                    desc = "Доступность магазина грузовиков",
                    value = "false",
                },
                {
                    name = "isUnderConstruction",
                    desc = "Технические работы",
                    value = "false",
                },
                {
                    name = "startedIncomeMin",
                    desc = "Мин. стартовый капитал игрока",
                    value = "10.0",
                },
                {
                    name = "startedIncomeMax",
                    desc = "Макс. стартовый капитал игрока",
                    value = "20.0",
                },
                {
                    name = "baseFuelPrice",
                    desc = "Базовая стоимость галона топлива",
                    value = "0.12",
                },
                {
                    name = "saleBizToCityCoef",
                    desc = "Коэффициент продажи недвижимости городу",
                    value = "0.8",
                },
            ];

            foreach(i, item in items) {
                local field = Settings();

                // put data
                field.name = item.name;
                field.desc = item.desc;
                field.value = item.value;
                field.save();
            }

            settingsLoadedDataRead();
        };
    });
}

function getSettingsFieldById(id) {
    foreach(i, item in settingsLoadedData) {
        if(item.id == id) {
            return item;
        }
    }
}

function getSettingsField(name = "") {
    foreach(i, item in settingsLoadedData) {
        if(item.name == name) {
            return item;
        }
    }
}

function getSettingsValue(name = "") {
    local value = getSettingsField(name).value;
    if(isFloat(value)) return value.tofloat();
    if(value.slice(0, 1) == "-" && isFloat(value.slice(1))) return value.tofloat();
    if(isInteger(value)) return value.tointeger();
    if(regexp(@"[a-zA-Z]+$").match(value) && value != "false" && value != "true") return value;
    return JSONParser.parse(value);
}

function setSettingsValue(name, value) {
    local field = getSettingsField(name);
    field.value = value.tostring();
    field.save();
}

function addWorldMoney(value) {
    value = value.tofloat();
    local money = getSettingsValue("worldMoney");
    setSettingsValue("worldMoney", money + value);
}

function subWorldMoney(value) {
    value = value.tofloat();
    local money = getSettingsValue("worldMoney");
    setSettingsValue("worldMoney", money - value);
}

acmd("settings", function(playerid) {
    local lines = [];
    foreach(idx, setting in settingsLoadedData) {
        lines.push(format("%d. %s (%s): %s", setting.id, setting.desc, setting.name, setting.value.tostring()))
    }
    msgh(playerid, "Настройки", lines);
})

acmd("settings", ["set"], function(playerid) {
    local lines = [];
    foreach(idx, setting in settingsLoadedData) {
        lines.push(format("%d. %s (%s): %s", setting.id, setting.desc, setting.name, setting.value.tostring()))
    }
    msgh(playerid, "Настройки", lines);

    msg(playerid, "Введите номер настройки и его новое значение через пробел", CL_CHESTNUT2);
    msg(playerid, "Пример: 1 winter", CL_GRAY);
    trigger(playerid, "hudCreateTimer", 30, true, true);

    local complete = false;

    delayedFunction(15000, function() {
        if (complete == false && character.playerid != -1) {
            return msg(character.playerid, "Значение не указано", CL_THUNDERBIRD);
        }
    });

    requestUserInput(playerid, function(playerid, text) {
        trigger(playerid, "hudDestroyTimer");

        local arr = split(text, " ");

        if (arr.len() != 2 || !isNumeric(arr[0]) || arr[0].tointeger() < 1 || arr[0].tointeger() > settingsLoadedData.len()) {
            return msg(playerid, "Некорректное значение", CL_THUNDERBIRD);
        }

        local field = getSettingsFieldById(arr[0].tointeger());

        complete = true;

        field.value = arr[1];
        field.save();

        msg(playerid, "Установлена настройка: «%s» в значение %s", [field.desc, arr[1]], CL_CHESTNUT2);
    }, 15);


})
