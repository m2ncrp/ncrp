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
                    name = "worldMoney",
                    value = "0.0",
                },
                {
                    name = "isTruckShopEnabled",
                    value = "false",
                },
                {
                    name = "isUnderConstruction",
                    value = "false",
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
    value = value.tofloat();
    local money = getSettingsValue("worldMoney");
    setSettingsValue("worldMoney", money + value);
}

function subWorldMoney(value) {
    value = value.tofloat();
    local money = getSettingsValue("worldMoney");
    setSettingsValue("worldMoney", money - value);
}