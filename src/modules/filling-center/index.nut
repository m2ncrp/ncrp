alternativeTranslate({
    "en|fillingcenter.needfueltruck"                          : "You need a fuel truck."
    "ru|fillingcenter.needfueltruck"                          : "Вам нужен бензовоз."

    "en|fillingcenter.driving"                                : "You're driving. Please stop the fuel truck."
    "ru|fillingcenter.driving"                                : "Необходимо остановиться."

    "en|fillingcenter.gov-declined"                           : "Members of government can't make a bussiness."
    "ru|fillingcenter.gov-declined"                           : "Необходимо остановиться."

    "en|fillingcenter.stop-engine"                            : "Please, stop the engine."
    "ru|fillingcenter.stop-engine"                            : "Заглушите двигатель."

    "en|fillingcenter.already-loading"                        : "Please wait..."
    "ru|fillingcenter.already-loading"                        : "Загрузка в процессе. Ожидайте завершения."

    "en|fillingcenter.already-loaded"                         : "Fuel truck already loaded."
    "ru|fillingcenter.already-loaded"                         : "Бензовоз уже заполнен."

    "en|fillingcenter.loading-canceled"                       : "Loading was canceled."
    "ru|fillingcenter.loading-canceled"                       : "Загрузка отменена."

    "en|fillingcenter.enter-value-of-gallons-1"               : "Enter how much gallons of fuel want to buy."
    "ru|fillingcenter.enter-value-of-gallons-1"               : "Укажите сколько галлонов топлива хотите приобрести."

    "en|fillingcenter.enter-value-of-gallons-2"               : "1 gallon cost $%.2f"
    "ru|fillingcenter.enter-value-of-gallons-2"               : "Стоимость одного галлона $%.2f"

    "en|fillingcenter.enter-value-of-gallons-hint"            : "Type integer number to chat from %d to %d."
    "ru|fillingcenter.enter-value-of-gallons-hint"            : "Напишите в чат целое число от %d до %d."

    "en|fillingcenter.not-enough-gallons"                     : "Not enough gallons. Max %s"
    "ru|fillingcenter.not-enough-gallons"                     : "Нет такого количества топлива. Топливное хранилище заполнено на %s"

    "en|fillingcenter.not-enough-money"                       : "Not enough money to pay. For %s gallons need $%.2f"
    "ru|fillingcenter.not-enough-money"                       : "Недостаточно денег для оплаты. За %s нужно $%.2f"

    "en|fillingcenter.invalid-enter"                          : "Invalid enter"
    "ru|fillingcenter.invalid-enter"                          : "Введено некорректное значение"

    "en|fillingcenter.no-enough-volume"                       : "%s of fuel does not fit into the tank"
    "ru|fillingcenter.no-enough-volume"                       : "В цистерну не вместится %s."

    "en|fillingcenter.loading"                                : "Loading. Please, wait..."
    "ru|fillingcenter.loading"                                : "Идёт загрузка топлива. Ждите..."

    "en|fillingcenter.payed"                                  : "Payment amounted $%.2f for %s. Come to us again!"
    "ru|fillingcenter.payed"                                  : "Оплата составила $%.2f за %s. Рады сотрудничеству!"
})

const FILLING_CENTER_X = 156.195;
const FILLING_CENTER_Y = -876.451;
const FILLING_CENTER_Z = -21.7358;
const FILLING_CENTER_GALLON_COST = 0.2;
const FILLING_CENTER_FUELUP_SPEED = 20; // gallons in seconds

local FILLING_CENTER_IN_HOUR = 25;
local FILLING_CENTER_MAX = 1000;
local FILLING_CENTER_NOW = 100;

local FILLING_CENTER_COLOR = CL_CRUSTA;
local trucksOnLoading = [];
local trucksOnQueue = [];

event("onServerStarted", function() {
    logStr("[jobs] loading filling center...");

    createBlip(FILLING_CENTER_X, FILLING_CENTER_Y, ICON_FUEL, ICON_RANGE_VISIBLE);

    createPlace("FillingCenter", 164.143, -871.729, 145.547, -880.425);
});

event("onServerPlayerStarted", function(playerid) {
    createPrivate3DText(playerid, FILLING_CENTER_X, FILLING_CENTER_Y, FILLING_CENTER_Z-0.15, plocalize(playerid, "3dtext.job.press.load"), CL_WHITE.applyAlpha(150), 4.0);
    createPrivate3DText(playerid, FILLING_CENTER_X, FILLING_CENTER_Y, FILLING_CENTER_Z+0.35, plocalize(playerid, "3dtext.organizations.filling-center"), CL_RIPELEMON, 50.0 );
});

event("onServerHourChange", function() {
    FILLING_CENTER_NOW += FILLING_CENTER_IN_HOUR;
});

event("onPlayerPlaceEnter", function(playerid, name) {
    if (name != "FillingCenter") {
        return;
    }
    logStr("registering fillingCenterLoad")
    privateKey(playerid, "e", "fillingCenterLoad", fillingCenterLoad);
});

event("onPlayerPlaceExit", function(playerid, name) {
    if (name != "FillingCenter") {
        return;
    }

    logStr("unregistering fillingCenterLoad")
    removePrivateKey(playerid, "e", "fillingCenterLoad")
});


/**
 * Check is player is a fuel driver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isFuelDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "fueldriver"));
}

/**
 * Check is player's vehicle is a fuel truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleFuel(playerid) {
    return (isPlayerInValidVehicle(playerid, 5));
}

function removeTruckFromQueue(vehid) {
    local index = trucksOnQueue.find(vehid);
    if(index != null) trucksOnQueue.remove(index);
}

function removeTruckFromLoading(vehid) {
    local index = trucksOnLoading.find(vehid);
    if(index != null) trucksOnLoading.remove(index);
}

function fillingCenterLoad(playerid) {
    msg(playerid, "fillingCenterLoad")

    if(!isPlayerInVehicle(playerid) || !isPlayerVehicleDriver(playerid) || !isPlayerVehicleFuel(playerid)) {
        return msg(playerid, "fillingcenter.needfueltruck", FILLING_CENTER_COLOR);
    }

    if(isPlayerVehicleMoving(playerid)){
        return msg(playerid, "fillingcenter.driving", CL_ERROR);
    }

    local vehicleid = getPlayerVehicle(playerid);

    if(isVehicleEngineStarted(vehicleid)) {
        return msg(playerid, "fillingcenter.stop-engine", CL_ERROR);
    }

    if(!isPlayerFractionMember(playerid, "gov")) {
        return msg(playerid, "fillingcenter.driving", CL_ERROR);
    }

    local veh = getVehicleEntity(vehicleid);

    if(trucksOnLoading.find(veh.id) != null) {
        return msg(playerid, "fillingcenter.already-loading", FILLING_CENTER_COLOR);
    }

    if(trucksOnQueue.find(veh.id) != null) {
        return;
    }

    local vehInfo = getVehicleInfo(veh.model);

    if(veh.data.parts.cargo == vehInfo.cargoLimit) {
        return msg(playerid, "fillingcenter.already-loaded", FILLING_CENTER_COLOR);
    }

    msg(playerid, "fillingcenter.enter-value-of-gallons-1", FILLING_CENTER_COLOR);
    msg(playerid, "fillingcenter.enter-value-of-gallons-2", [FILLING_CENTER_GALLON_COST], FILLING_CENTER_COLOR);
    msg(playerid, "fillingcenter.enter-value-of-gallons-hint", [1, Math.min(vehInfo.cargoLimit - veh.data.parts.cargo, FILLING_CENTER_NOW)] CL_GRAY);

    local isSuccess = false;

    // Поставить бензовоз в очередь получения действия от игрока
    trucksOnQueue.push(veh.id);

    delayedFunction(30000, function() {
        if (!isSuccess) {
            msg(playerid, "fillingcenter.loading-canceled");
            removeTruckFromQueue(veh.id);
        }
    });

    trigger(playerid, "hudCreateTimer", 30.0, true, true);

    requestUserInput(playerid, function(playerid, text) {
        trigger(playerid, "hudDestroyTimer");

        if (!text || !isNumeric(text)) {
            return msg(playerid, "fillingcenter.invalid-enter", CL_ERROR);
        }

        local gallons = text.tointeger();

        if(gallons > FILLING_CENTER_NOW) {
            return msg(playerid, "fillingcenter.not-enough-gallons", [formatGallons(FILLING_CENTER_NOW)], FILLING_CENTER_COLOR);
        }

        if(veh.data.parts.cargo + gallons > vehInfo.cargoLimit) {
            return msg(playerid, "fillingcenter.no-enough-volume", [formatGallons(gallons)], FILLING_CENTER_COLOR);
        }

        local amount = round(FILLING_CENTER_GALLON_COST * gallons, 2);

        if (!canMoneyBeSubstracted(playerid, amount)) {
            return msg(playerid, "fillingcenter.not-enough-money", [formatGallons(gallons), amount], CL_ERROR);
        }

        isSuccess = true;
        msg(playerid, "");
        subMoneyToPlayer(playerid, amount);
        addWorldMoney(amount);
        FILLING_CENTER_NOW -= gallons;

        local fuelUpSeconds = (gallons / FILLING_CENTER_FUELUP_SPEED).tointeger();
        msg(playerid, "fillingcenter.loading", FILLING_CENTER_COLOR);
        freezePlayer(playerid, true);
        trucksOnLoading.push(veh.id);
        dbg(trucksOnLoading)
        setVehicleEngineState(vehicleid, false);
        trigger(playerid, "hudCreateTimer", fuelUpSeconds, true, true);
        delayedFunction(fuelUpSeconds * 1000, function () {
            if(isPlayerConnected(playerid)) {
                freezePlayer( playerid, false);
                delayedFunction(1000, function () { freezePlayer( playerid, false); });
                msg(playerid, "fillingcenter.payed", [amount, formatGallons(gallons)], FILLING_CENTER_COLOR);
            }
            removeTruckFromQueue(veh.id);
            removeTruckFromLoading(veh.id);
            veh.data.parts.cargo += gallons;
            dbg(trucksOnLoading)
        });

    }, 30);
}