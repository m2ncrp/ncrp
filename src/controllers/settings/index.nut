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
    return JSONParser.parse(getSettingsField(name).value);
}

function setSettingsValue(name, value) {
    local field = getSettingsField(name);
    field.value = value;
    field.save();
}