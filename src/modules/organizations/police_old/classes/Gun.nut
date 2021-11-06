local gunRegistry = {};

/**
 * Check if vehicle plate is registered
 * @param  {[type]}  plateText [description]
 * @return {Boolean}           [description]
 */
local function isVehilclePlateRegistered(serial) {
    return (serial in gunRegistry);
}

/**
 * Function that creates random unique text serial
 *
 * @param  {String} prefix [optional] prefix to use for serial text
 * @return {[type]}        [description]
 */
local function getRandomGunSerial() {
    // generate serial text
    local number = random(0, 99999).tostring();
    local length = number.len();
    for (local i = 5; i > length; i--) {
        number = "0" + number;
    }
    dbg( "Generated serial gun number is " + number );

    // if exists - regenerate
    if ( isVehilclePlateRegistered(number) ) {
        return getRandomGunSerial();
    }

    // register serial
    gunRegistry[number] <- null;

    return number;
}

/**
 * Remove provided text from the registry
 *
 * @param  {String} plateText
 * @return {Boolean} result
 */
local function removeGunSerial(serial) {
    if ( isVehilclePlateRegistered(serial) ) {
        delete gunRegistry[serial];
        return true;
    }
    return false;
}


class Gun {
    model = null;
    serial = null;
    ammo = null;
    gunshop = null;

    constructor (model, ammo, gunshop) {
        this.model = model;
        this.ammo = ammo;
        this.gunshop = gunshop;
        this.serial = getRandomGunSerial();
    }

    function setSerial() {
        local oldtext = serial;

        if (isVehilclePlateRegistered(oldtext)) {
            removeVehiclePlateText(oldtext);
        }

        plateRegistry[plateText] <- vehicleid;
        return old__setVehiclePlateText(vehicleid, plateText);
    }
}


// У полицейских должен быть уникальный четырехзначный полицейский жетон


// Офицер
// Транспортный отдел <- Капитан
    // Проверка номеров, поимка говнюков
    // патрульный



// Ивенты без участия игроков
// Всем по радио приходит сообщение от диспетчера об некотором нарушении. Чтобы его принять надо передать соответствующий тен-код. Первый экипаж, который примет вызов и получит это задание.
    // Исследование брошенных авто
    // Избиение одного из супругов (+ ложные вызовы)
    // Ложные вызовы от "граждан"

// Ивенты с участием игроков
    // Попытка угона авто
    // Ношение оружия в публичном месте
    // Стрельба





// Процесс исследования места происшествия
    // Поиск улик (офицеры)
    // Осмотр улик
    // Опрос свидетелей


// Технический паспорт на транспортное средство
