// police car binder

local phrases = {
    "1": "Прижмитесь к обочине и остановитесь!"
    "2": "Заглушите двигатель и положите руки на руль!"
    "3": "Уступите дорогу служебному транспорту!"
    "4": "Немедленно остановитесь, иначе мы откроем по вам огонь!"
    "5": "Проезжайте-проезжайте, не затрудняйте движение!"
    "6": "Граждане, расходитесь! Ситуация под контролем полиции."
    "7": "Полиция Эмпайр-Бэй. Вы окружены. Сдавайтесь!"
    "8": "Выходите с поднятыми руками!"
}

local timers = {};

function isCopInPoliceCarOnDuty(playerid) {
    if ( !isOfficer(playerid) ) {
        return false;
    }
    if ( isOfficer(playerid) && !isOnPoliceDuty(playerid) ) {
        return false;
    }

    if ( !isPlayerInPoliceVehicle(playerid) ) {
        return false;
    }
    return true;
}


function policeVehicleBinder (playerid) {
    if (!isCopInPoliceCarOnDuty(playerid) || (playerid in timers && timers[playerid].IsActive() )) return;

    setPlayerBinderState(playerid, "b_policecar");

    msg(playerid, "===========================================", CL_HELP_LINE);
    msg(playerid, "ПОЛИЦЕЙСКИЙ РУПОР", CL_HELP_TITLE);

    for (local i = 1; i <= phrases.len(); i++) {

        local text = format("%d. %s", i, phrases[i.tostring()]);

        if ((i % 2) == 0) {
            msg(playerid, text, CL_HELP);
        } else {
            msg(playerid, text);
        }
    }

    trigger(playerid, "hudCreateTimer", 3.0, true, true);
    timers[playerid] <- delayedFunction(3000, function () {
        clearPlayerBinderState(playerid);
        msg(playerid, "Действие отменено");
    });

}

/**
 * Create private bindings for playerid
 */
function policeCarRuporBinderCreator(playerid) {
    for (local i = 1; i <= phrases.len(); i++) {
        local keyButton = i.tostring();
        privateKey(playerid, keyButton, "policeBinder"+keyButton, function(playerid) {
            sendLocalizedMsgToAll(playerid, "[POLICE RUPOR] "+phrases[keyButton], [], RUPOR_RADIUS, CL_ROYALBLUE);
            clearPlayerBinderState(playerid);
            trigger(playerid, "hudDestroyTimer");
            if( timers[playerid].IsActive() ) {
                timers[playerid].Kill()
            }
        });
    }
}

/**
 * Remove private bindings for playerid
 */
function policeCarRuporBinderRemover(playerid) {
    for (local i = 1; i <= phrases.len(); i++) {
        local keyButton = i.tostring();
        removePrivateKey(playerid, keyButton, "policeBinder"+keyButton);
    }
}
