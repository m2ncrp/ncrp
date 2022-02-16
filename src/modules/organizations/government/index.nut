include("modules/organizations/government/classes/ContainerPassportRequests.nut");
include("modules/organizations/government/passport.nut");
include("modules/organizations/government/ltc.nut");
include("modules/organizations/government/tax.nut");
// include("modules/organizations/government/vehicleTitle.nut");
include("modules/organizations/government/voting.nut");
include("modules/organizations/government/treasury.nut");
include("modules/organizations/government/models/Government.nut");
include("modules/organizations/government/models/PassportRequest.nut");

local coords = [-122.331, -62.9116, -12.041];
local SIDEWALK = [-118.966, -73.4, -66.4244, -52.5];

local availableActs = [
    "taxVehicleRate",
    "taxSales",
    "unemployedIncome",
    "salarySnowplowDriver",
    "busTicketPrice",
    "subwayTicketPrice",
    "hospitalTreatmentPrice",
];
local availableActsNumbers = [];
local governmentLoadedData = null;

function getGovCoords(i) {
    return coords[i];
}

event("onServerStarted", function() {
    logStr("[organizations] government...");

    create3DText ( coords[0], coords[1], coords[2]+0.20, "/tax | /passport", CL_WHITE.applyAlpha(100), 2.0 );
    createBlip  ( coords[0], coords[1], [ 24, 0 ], ICON_RANGE_VISIBLE );
    createPlace("GovernmentSidewalk", SIDEWALK[0], SIDEWALK[1], SIDEWALK[2], SIDEWALK[3]);

    governmentLoadedDataRead();

});

function governmentLoadedDataRead() {
    Government.findAll(function(err, results) {
        if (results.len()) {
            governmentLoadedData = results;

            availableActsNumbers = results.filter(function(idx, item) {
                if(availableActs.find(item.name) != null) return item;
            }).map(function(item) {
                return item.id
            })
        } else {

            local items = [
                {
                    name = "treasury",
                    unit = "$",
                    desc = "Казна",
                    value = "0.0",
                },
                {
                    name = "interestRate",
                    unit = "%",
                    desc = "Ключевая ставка",
                    value = "0.0",
                },
                {
                    name = "taxVehicleRate",
                    unit = "%",
                    desc = "Налог на автотранспорт",
                    value = "0.0",
                },
                {
                    name = "taxPropertyRate",
                    unit = "%",
                    desc = "Налог на недвижимость",
                    value = "0.0",
                },
                {
                    name = "taxSales",
                    unit = "%",
                    desc = "Налог с продаж и оплаты услуг",
                    value = "0.0",
                },
                {
                    name = "ltcPrice",
                    unit = "$",
                    desc = "Стоимость лицензии на оружие",
                    value = "0.0",
                },
                {
                    name = "driverLicensePrice",
                    unit = "$",
                    desc = "Стоимость лицензии на вождение",
                    value = "0.0",
                },
                {
                    name = "unemployedIncome",
                    unit = "$",
                    desc = "Пособие по безработице",
                    value = "10.0",
                },
                {
                    name = "salaryBusDriver",
                    unit = "$",
                    desc = "Заработок водителя автобуса за одну остановку",
                    value = "0.0",
                },
                {
                    name = "salarySnowplowDriver",
                    unit = "$",
                    desc = "Заработок водителя снегоубор. машины за один чекпоинт",
                    value = "0.0",
                },
                {
                    name = "busTicketPrice",
                    unit = "$",
                    desc = "Стоимость проезда на автобусе",
                    value = "0.4",
                },
                {
                    name = "subwayTicketPrice",
                    unit = "$",
                    desc = "Стоимость проезда на метро",
                    value = "0.15",
                },
                {
                    name = "hospitalTreatmentPrice",
                    unit = "$",
                    desc = "Стоимость лечения в госпитале",
                    value = "12.00",
                }
            ];

            foreach(i, item in items) {
                local field = Government();

                // put data
                field.name  = item.name;
                field.unit  = item.unit;
                field.desc  = item.desc;
                field.value = item.value;
                field.save();
            }

            governmentLoadedDataRead();
        }
    })
}

function getGovernmentFieldById(id) {
    foreach(i, item in governmentLoadedData) {
        if(item.id == id) {
            return item;
        }
    }
}

function getGovernmentField(name = "") {
    foreach(i, item in governmentLoadedData) {
        if(item.name == name) {
            return item;
        }
    }
}

function setGovernmentValue(name, value) {
    local field = getGovernmentField(name);
    field.value = value.tostring();
    field.save();
}

function getGovernmentValue(name = "") {
    local value = getGovernmentField(name).value;
    if(isFloat(value)) return value.tofloat();
    if(value.slice(0, 1) == "-" && isFloat(value.slice(1))) return value.tofloat();
    if(isInteger(value)) return value.tointeger();
    if(regexp(@"[a-zA-Z]+$").match(value) && value != "false" && value != "true") return value;
    return JSONParser.parse(value);
}

event("onServerPlayerStarted", function( playerid ) {
    createPrivate3DText ( playerid, coords[0], coords[1], coords[2]+0.35, plocalize(playerid, "3dtext.organizations.meria"), CL_ROYALBLUE);
});

event("onPlayerAreaEnter", function(playerid, name) {
    if (isPlayerInVehicle(playerid) && name == "GovernmentSidewalk") {
        local vehicleid = getPlayerVehicle(playerid);
        local vehSpeed = getVehicleSpeed(vehicleid);
        local vehPos = getVehiclePosition(vehicleid);

        local vehSpeedNew = [];

        if (vehPos[0] > SIDEWALK[0] && vehPos[0] < SIDEWALK[2]) {
            // для нижней границы
            if (vehPos[1] > (SIDEWALK[1] - 4.0) && vehPos[1] < (SIDEWALK[1] + 4.0)) {
                if (vehSpeed[1] >= 0) vehSpeed[1] = (vehSpeed[1] + 1) * -1;
            }
            // для верхней границы
            if (vehPos[1] > (SIDEWALK[3] - 4.0) && vehPos[1] < (SIDEWALK[3] + 4.0)) {
                if (vehSpeed[1] <= 0) vehSpeed[1] = (vehSpeed[1] - 1) * -1;
            }
        }

        // для правой боковой границы
        if (vehPos[0] > (SIDEWALK[2] - 4.0) && vehPos[0] < (SIDEWALK[2] + 4.0)) {
            if (vehPos[1] > SIDEWALK[1] && vehPos[1] < SIDEWALK[3]) {
                if (vehSpeed[0] <= 0) vehSpeed[0] = (vehSpeed[0] - 1) * -1;
            }
        }

        setVehicleSpeed(vehicleid, vehSpeed[0], vehSpeed[1], vehSpeed[2]);
    }
});

/**
 * Check vehicleid/plate/vehInstance is government
 * @param  {any}  plate, vehicleid or instance
 * @return {boolean}
**/
function isGovVehicle(value) {

  function checkGovPlate(plate) {
    return plate.find("GOV-") == 0;
  }

  if(typeof value == "string") {
    return checkGovPlate(value);
  }
  if(typeof value == "integer") {
    local plate = getVehiclePlateText(value);
    return checkGovPlate(plate);
  }
  if(typeof value == "instance") {
    return checkGovPlate(value.entity.plate);
  }

}

fmd("gov", ["gov.act"], "$f acts", function(fraction, character, article = null, value = null) {

    if (!isPlayerInValidPoint(character.playerid, getGovCoords(0), getGovCoords(1), 3.0 )) {
        return msg(character.playerid, "gov.acts.toofar", CL_THUNDERBIRD);
    }

    if (article == null && value == null) {
        local acts = [];
        foreach(i, item in governmentLoadedData) {
            local str;
            if(item.unit == "$") {
                str = format("%s: %s%s", item.desc, item.unit, item.value.tostring())
            } else if(item.unit == "%") {
                str = format("%s: %s %s", item.desc, item.value.tostring(), declOfNum(item.value.tofloat(), ["процент", "процента", "процентов"]) )
            }

            acts.push(str)
        }
        return msgh(character.playerid, "Сводка", acts);
    }
});

fmd("gov", ["gov.act"], "$f act", function(fraction, character) {
    if (!isPlayerInValidPoint(character.playerid, getGovCoords(0), getGovCoords(1), 3.0 )) {
        return msg(character.playerid, "gov.act.toofar", CL_THUNDERBIRD);
    }

    local defaulttogooc = getPlayerOOC(character.playerid);
    setPlayerOOC(character.playerid, false);

    local helps = [];
    foreach(i, item in governmentLoadedData) {
        if(availableActs.find(item.name) == null) continue;

        local value = convertFieldToString(item.value, item.unit);

        if(item.next != 0.0) {
            value += " -> "+item.next.tostring();
        }
        helps.push(format("%d. %s, %s", item.id, item.desc, value))
    }

    msgh(character.playerid, "Издание постановлений", helps);

    local timer = delayedFunction(30000, function() {
        if (character.playerid != -1) {
            setPlayerOOC(character.playerid, defaulttogooc);
            return msg(character.playerid, "gov.act.nodata", CL_THUNDERBIRD);
        }
    });

    msg(character.playerid, "gov.acts.enter-field", CL_CHESTNUT2);
    msg(character.playerid, "gov.acts.enter-field-help", CL_GRAY);
    trigger(character.playerid, "hudCreateTimer", 30, true, true);

    requestUserInput(character.playerid, function(playerid, text) {
        trigger(playerid, "hudDestroyTimer");
        setPlayerOOC(character.playerid, defaulttogooc);

        local arr = split(text, " ");

        if (arr.len() != 2 || !isNumeric(arr[0]) || availableActsNumbers.find(arr[0].tointeger()) == null) {
            if(defaulttogooc) setPlayerOOC(playerid, true);
            return msg(playerid, "gov.act.incorrect", CL_THUNDERBIRD);
        }

        local field = getGovernmentFieldById(arr[0].tointeger());

        timer.Kill();

        field.next = arr[1];
        field.until = getTimestamp() + 432000;
        field.save();

        msg(character.playerid, "gov.acts.completed", [field.desc, arr[1]], CL_CHESTNUT2);
        msg(character.playerid, "gov.acts.completed-hint", CL_GRAY);
    }, 30);

});

function convertFieldToString(value, unit) {
    if(unit == "%") {
        return format("%s %s", value.tostring(), declOfNum(value, ["процент", "процента", "процентов"]));
    }

    if(unit == "$") {
        return format("$ %s", value.tostring())
    }

    return value;
}

event("onServerHourChange", function() {
    if(getHour() % 2 == 0) return;

    local acts = [];

    foreach(i, field in governmentLoadedData) {
        if(field.until == 0) continue;

        local timestamp = getTimestamp();

        local when;
        local diff = field.until - timestamp;

        if(diff >= 108000) {
            when = "Уже скоро";
        }

        if(diff < 108000) {
            when = "С завтрашнего дня";
        }

        acts.push(format("Новости часа: %s вступает в силу постановление правительства Эмпайр-Бэй, согласно которому «%s» будет составлять %s.", when, field.desc, convertFieldToString(field.next, field.unit)));
    }

    if(acts.len() > 0) {
        local rand = random(0, acts.len()-1);
        sendMsgToRadio(acts[rand]);
    }
});

event("onServerDayChange", function() {
    foreach(i, field in governmentLoadedData) {
        if(field.until == 0) continue;

        local timestamp = getTimestamp();

        if(timestamp > field.until) {
            field.value = field.next;
            field.next = 0.0;
            field.until = 0;
            field.save();

            sendMsgToRadio(format("Новости в полночь: Вступило в силу постановление правительства Эмпайр-Бэй, согласно которому «%s» теперь составляет %s.", field.desc, convertFieldToString(field.value, field.unit)));
        }
    }
});

fmd("gov", [], "$f help", function(fraction, character) {
    msgh(character.playerid, "Правительство", [
        "/gov - базовые команды управления правительством",
        "/gov acts - сводка текущих значений",
        "/gov act - принять новое постановление",
    ]);
});

alternativeTranslate({
    "en|gov.act.toofar"        : ""
    "ru|gov.act.toofar"        : "Издание постановлений возможно только в здании мэрии"

    "en|gov.act.nodata"     : ""
    "ru|gov.act.nodata"     : "Ничего не введено"

    "en|gov.act.incorrect"     : ""
    "ru|gov.act.incorrect"     : "Некорректное значение"

    "en|gov.acts.toofar"       : ""
    "ru|gov.acts.toofar"       : "Ознакомиться с постановлениями можно только в здании мэрии"

    "en|gov.acts.enter-field" : ""
    "ru|gov.acts.enter-field" : "Введите номер постановления и его новое значение через пробел"

    "en|gov.acts.enter-field-help" : ""
    "ru|gov.acts.enter-field-help" : "Пример: 8 15"

    "en|gov.acts.completed" : ""
    "ru|gov.acts.completed" : "Издано постановление об установлении нового значения «%s» равное %s."

    "en|gov.acts.completed-hint" : ""
    "ru|gov.acts.completed-hint" : "Постановление вступит в силу через 5 реальных дней."
});