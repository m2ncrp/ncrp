include("controllers/settings/models/Settings.nut");

local settingsLoadedData = [];

event("onServerStarted", function() {
    log("[admin] loading settings...");

    settingsLoadedDataRead();
});

function settingsLoadedDataRead() {
    Settings.findAll(function(err, results) {
        if(results.len()) {
          settingsLoadedData = results
        } else {
            local items = [
                {
                    name = "isWinter",
                    value = "false",
                },
                {
                    name = "donate",
                    value = "true",
                },
                {
                    name = "world_money",
                    value = "0.0",
                }
            ];

            foreach(i, item in items) {
                local field = Settings();

                // put data
                field.name = item.name;
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
    if(isInteger(value)) return value.tointeger();
    return JSONParser.parse(value);
}

function setSettingsValue(name, value) {
    local field = getSettingsField(name);
    field.value = value.tostring();
    field.save();
}

function addWorldMoney(value) {
    local money = getSettingsValue("world_money");
    setSettingsValue("world_money", money + value);
}

function subWorldMoney(value) {
    local money = getSettingsValue("world_money");
    setSettingsValue("world_money", money - value);
}