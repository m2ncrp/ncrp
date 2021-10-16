alternativeTranslate({
    "en|fillingcenter.needfueltruck"                          : "You need a fuel truck."
    "ru|fillingcenter.needfueltruck"                          : "Вам нужен бензовоз."

    "en|fillingcenter.toofar"                                 : "You are too far from filling center!"
    "ru|fillingcenter.toofar"                                 : "Вы слишком далеко от топливного хранилища!"

    "en|fillingcenter.driving"                                : "You're driving. Please stop the fuel truck."
    "ru|fillingcenter.driving"                                : "Необходимо остановиться."

    "en|fillingcenter.gov-declined"                           : "Members of government can't make a bussiness."
    "ru|fillingcenter.gov-declined"                           : "Члены правительства не могут заниматься бизнесом."

    "en|fillingcenter.bizman-declined"                        : "Bussiness owners can't fulfill fuel orders."
    "ru|fillingcenter.bizman-declined"                        : "Владельцы бизнесов не могут выполнять заказы на поставку топлива."

    "en|fillingcenter.stop-engine"                            : "Please, stop the engine."
    "ru|fillingcenter.stop-engine"                            : "Заглушите двигатель."

    "en|fillingcenter.already-loading"                        : "Please wait..."
    "ru|fillingcenter.already-loading"                        : "Загрузка в процессе. Ожидайте завершения."

    "en|fillingcenter.already-loaded"                         : "Fuel truck already loaded."
    "ru|fillingcenter.already-loaded"                         : "Бензовоз уже заполнен."

    "en|fillingcenter.loading-canceled"                       : "No response has been received. Loading was canceled."
    "ru|fillingcenter.loading-canceled"                       : "Ответ не получен. Загрузка отменена."

    "en|fillingcenter.enter-value-of-gallons-1"               : "Enter how much gallons of fuel want to buy."
    "ru|fillingcenter.enter-value-of-gallons-1"               : "Укажите сколько галлонов топлива хотите приобрести."

    "en|fillingcenter.enter-value-of-gallons-2"               : "1 gallon cost $%.2f"
    "ru|fillingcenter.enter-value-of-gallons-2"               : "Стоимость одного галлона $%.2f"

    "en|fillingcenter.enter-value-of-gallons-hint"            : "Type integer number to chat from %d to %d."
    "ru|fillingcenter.enter-value-of-gallons-hint"            : "Напишите в чат целое число от %d до %d."

    "en|fillingcenter.empty"                                  : "Filling center is empty. Try later."
    "ru|fillingcenter.empty"                                  : "Топливное хранилище пусто. Загляни в другой раз."

    "en|fillingcenter.not-enough-gallons"                     : "Not enough gallons. Max %s"
    "ru|fillingcenter.not-enough-gallons"                     : "Нет такого количества топлива. Топливное хранилище заполнено на %s"

    "en|fillingcenter.not-enough-money"                       : "Not enough money to pay. For %s gallons need $%.2f"
    "ru|fillingcenter.not-enough-money"                       : "Недостаточно денег для оплаты. За %s нужно $%.2f"

    "en|fillingcenter.invalid-enter"                          : "Invalid enter"
    "ru|fillingcenter.invalid-enter"                          : "Введено некорректное значение"

    "en|fillingcenter.no-enough-volume"                       : "%s of fuel does not fit into the tank"
    "ru|fillingcenter.no-enough-volume"                       : "В цистерну не вместится %s."

    "en|fillingcenter.payed"                                  : "Payment amounted $%.2f for %s."
    "ru|fillingcenter.payed"                                  : "Оплата составила $%.2f за %s."
})

const FILLING_CENTER_X = 156.195;
const FILLING_CENTER_Y = -876.451;
const FILLING_CENTER_Z = -21.7358;
const FILLING_CENTER_FUELUP_SPEED = 20; // gallons in seconds

local FILLING_CENTER_IN_HOUR = 25;
local FILLING_CENTER_MAX = 1000;
local FILLING_CENTER_NOW = 100;

local FILLING_CENTER_COLOR = CL_CRUSTA;

// Перечень грузовиков в ожидании действия от игрока
local trucksOnQueue = [];

event("onServerStarted", function() {
    logStr("[jobs] loading filling center...");

    createBlip(FILLING_CENTER_X, FILLING_CENTER_Y, ICON_FUEL, ICON_RANGE_VISIBLE);

    createPlace("FillingCenter", 164.143, -871.729, 145.547, -880.425);

});

event("onServerPlayerStarted", function(playerid) {
    createPrivate3DText(playerid, FILLING_CENTER_X, FILLING_CENTER_Y, FILLING_CENTER_Z+0.35, plocalize(playerid, "3dtext.organizations.filling-center"), CL_RIPELEMON, 50.0 );
    createPrivate3DText(playerid, FILLING_CENTER_X, FILLING_CENTER_Y, FILLING_CENTER_Z-0.15, plocalize(playerid, "3dtext.job.press.load"), CL_WHITE.applyAlpha(150), 4.0);
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

function removeTruckFromLoadingQueue(vehid) {
    local index = trucksOnQueue.find(vehid);
    if(index != null) trucksOnQueue.remove(index);
}

function fillingCenterLoad(playerid) {
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

    if(!isPlayerAdmin(playerid) && isPlayerFractionMember(playerid, "gov")) {
        return msg(playerid, "fillingcenter.gov-declined", CL_ERROR);
    }

    if(!isPlayerAdmin(playerid) && getPlayerBizCount(playerid) > 0) {
        return msg(playerid, "fillingcenter.bizman-declined", CL_ERROR);
    }

    local veh = getVehicleEntity(vehicleid);

    if(getVehicleState(vehicleid) == "loading") {
        return msg(playerid, "fillingcenter.already-loading", FILLING_CENTER_COLOR);
    }

    if(trucksOnQueue.find(veh.id) != null) {
        return;
    }

    local vehInfo = getVehicleInfo(veh.model);

    if(veh.data.parts.cargo == vehInfo.cargoLimit) {
        return msg(playerid, "fillingcenter.already-loaded", FILLING_CENTER_COLOR);
    }

    if(FILLING_CENTER_NOW == 0) {
        return msg(playerid, "fillingcenter.empty", FILLING_CENTER_COLOR);
    }

    msg(playerid, "fillingcenter.enter-value-of-gallons-1", FILLING_CENTER_COLOR);
    msg(playerid, "fillingcenter.enter-value-of-gallons-2", [getSettingsValue("baseFuelPrice")], FILLING_CENTER_COLOR);
    msg(playerid, "fillingcenter.enter-value-of-gallons-hint", [1, Math.min(vehInfo.cargoLimit - veh.data.parts.cargo, FILLING_CENTER_NOW)], CL_GRAY);

    local isEntered = false;

    // Поставить бензовоз в очередь получения действия от игрока
    trucksOnQueue.push(veh.id);

    delayedFunction(15000, function() {
        if (!isEntered) {
            msg(playerid, "fillingcenter.loading-canceled");
            removeTruckFromLoadingQueue(veh.id);
        }
    });

    trigger(playerid, "hudCreateTimer", 15.0, true, true);

    requestUserInput(playerid, function(playerid, text) {
        trigger(playerid, "hudDestroyTimer");

        if (!text || !isNumeric(text)) {
            return msg(playerid, "fillingcenter.invalid-enter", CL_ERROR);
        }

        isEntered = true;
        removeTruckFromLoadingQueue(veh.id);

        if (!isInRadius(playerid, FILLING_CENTER_X, FILLING_CENTER_Y, FILLING_CENTER_Z, 4.0) ) {
            return msg(playerid, "fillingcenter.toofar", CL_ERROR);
        }

        local gallons = text.tointeger();

        if(gallons > FILLING_CENTER_NOW) {
            return msg(playerid, "fillingcenter.not-enough-gallons", [formatGallons(FILLING_CENTER_NOW)], FILLING_CENTER_COLOR);
        }

        if(veh.data.parts.cargo + gallons > vehInfo.cargoLimit) {
            return msg(playerid, "fillingcenter.no-enough-volume", [formatGallons(gallons)], FILLING_CENTER_COLOR);
        }

        local amount = round(getSettingsValue("baseFuelPrice") * gallons, 2);

        if (!canMoneyBeSubstracted(playerid, amount)) {
            return msg(playerid, "fillingcenter.not-enough-money", [formatGallons(gallons), amount], CL_ERROR);
        }

        // запомним персонажа
        local charid = getCharacterIdFromPlayerId(playerid);

        subPlayerMoney(playerid, amount);
        addWorldMoney(amount);
        FILLING_CENTER_NOW -= gallons;

        setVehicleState(vehicleid, "loading");
        blockDriving(playerid, vehicleid);

        local fuelUpSeconds = (gallons / FILLING_CENTER_FUELUP_SPEED).tointeger();
        msg(playerid, "vehicle.state.loading", FILLING_CENTER_COLOR);
        msg(playerid, "fillingcenter.payed", [amount, formatGallons(gallons)], FILLING_CENTER_COLOR);

        trigger(playerid, "hudCreateTimer", fuelUpSeconds, true, true);
        delayedFunction(fuelUpSeconds * 1000, function () {
            // получим водителя, и разблочим бензовоз если водитель есть и персонаж совпадает с тем, кто иницировал загрузку
            local driverid = getVehicleDriver(vehicleid);
            if(driverid != null) {
                local currentCharid = getCharacterIdFromPlayerId(driverid);
                if(charid == currentCharid) {
                    unblockDriving(vehicleid);
                }
                msg(driverid, "vehicle.state.loaded", FILLING_CENTER_COLOR);
            }
            setVehicleState(vehicleid, "free");
            veh.data.parts.cargo += gallons;
        });

    }, 15);
}
