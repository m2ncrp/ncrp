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