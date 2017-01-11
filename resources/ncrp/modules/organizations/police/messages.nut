/**
 * That file contain commands that operate with police radio in duty vehicles and messages translations through it.
 */


translation("ru", {
    "organizations.police.tencode.10-1"   : "подозреваемый %s обнаружен",
    "organizations.police.tencode.10-80"  : "веду преследование нарушителя",
});


// Fix: send message in player locale, not only sender locale
function sendLocalizedPoliceRadioMsgToAll(sender, phrase_key, ...) {
    local players = playerList.getPlayers();
    local message = concat(vargv);
    foreach(playerid, player in players) {
        if ( isPlayerInPoliceVehicle(playerid) ) {
            if ( isOfficer(playerid) ) {
                msg(playerid, "[POLICE RADIO] " + getAuthor(playerid) + ": " + localize("organizations.police.tencode." + phrase_key, [message], getPlayerLocale(playerid)), CL_ROYALBLUE);
            } else {
                msg(playerid, "[POLICE RADIO] " + getAuthor(playerid) + ": " + phrase_key + " " + message, CL_ROYALBLUE);
            }
        }
    }
}



// ------------------- COMMANDS
cmd(["police"],["10-1"], function(playerid, message) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        sendLocalizedPoliceRadioMsgToAll( playerid, "10-1", message );
    }
    // dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-2"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-3"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-4"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-5"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-6"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-7"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-8"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-9"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-10"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-11"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-12"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-13"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-14"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-15"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-16"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-17"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-18"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-19"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-20"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-21"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-22"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-23"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-24"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-25"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-26"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});

cmd(["police"],["10-27"], function(playerid, ...) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        
    }
    dbg( "----------------------------- kek -----------------------------" );
});


cmd(["r"],["10-80"], function(playerid) {
    if ( isPlayerInPoliceVehicle(playerid) ) {
        sendLocalizedPoliceRadioMsgToAll( playerid, "10-80" );

        foreach (player in players) {
            local id = player.playerid;
            if ( isOfficer(id) && isOnPoliceDuty(id) && isPlayerInPoliceVehicle(id) ) {
                local crime_hash = createPrivateBlip(id, pos.x, pos.y, ICON_YELLOW, 4000.0);

                delayedFunction(60000, function() {
                    removeBlip( crime_hash );
                });
            }
        }
    }
});


//     ["10-41", "organizations.police.tencode.10-41"], // Офицер заступил на смену
//     ["10-41", "organizations.police.tencode.10-41"], // Офицер закончил смену

//     ["10-1", "organizations.police.tencode.10-1"],  // Код 1 » Возможны человеческие жертвы, прибыть как можно скорее, действовать аккуратно
//     ["10-2", "organizations.police.tencode.10-2"],  // Код 2 » Отбой по вызову, ситуация под контролем, преступник нейтрализован
//     ["10-3", "organizations.police.tencode.10-3"], // Тишина в эфире / Stop transmitting
//     ["10-4", "organizations.police.tencode.10-4"], // Сообщение получено / Affirmative
//     ["10-5", "organizations.police.tencode.10-5"], // Передача сообщения от кого-то кому-то / Relay To/From
//     ["10-6", "organizations.police.tencode.10-6"], // Нет ответа от экипажа / Out of service; Код 6 » Держаться по периметру оцепления, не стрелять
//     ["10-7", "organizations.police.tencode.10-7"], // Есть ответ от экипажа / In service
//     ["10-8", "organizations.police.tencode.10-8"], // Повторите сообщение / Repeat last message
//     ["10-9", "organizations.police.tencode.10-9"], // Прибыл на место происшествия / Arrived at Scene
//     ["10-10", "organizations.police.tencode.10-10"], // Идет перестрелка / Fight in progress
//     ["10-11", "organizations.police.tencode.10-11"], // Код 11 » Приготовиться к штурму/операции/захвату
//     ["10-12", "organizations.police.tencode.10-12"], // Погоня / Dog chase
//     ["10-13", "organizations.police.tencode.10-13"], // Ожидайте / stand by
//     ["10-14", "organizations.police.tencode.10-14"], // Вандализм / Vandalism
//     ["10-15", "organizations.police.tencode.10-15"], // Опасные погодные условия / Dangerous weather conditions
//     ["10-16", "organizations.police.tencode.10-16"], // 10-16 _место_ » Передача местонахождения <в точке/место> / Location <place>
//     ["10-17", "organizations.police.tencode.10-17"], // Возможен взлом/угон / Investigate possible Break in
//     ["10-18", "organizations.police.tencode.10-18"], // Ожидаемое время пребытия / Estimated Arrival Time (ETA)
//     ["10-19", "organizations.police.tencode.10-19"], // 10-17 Срочное сообщение
//     ["10-20", "organizations.police.tencode.10-20"], // 10-26 Последняя информация отменяется (отставить!)
//     ["10-21", "organizations.police.tencode.10-21"], // 10-34 (место) » Офицер запрашивает подмогу (место)
//     ["10-22", "organizations.police.tencode.10-22"], // Мятеж / Riot
//     ["10-23", "organizations.police.tencode.10-23"], // Происшествие / Caution
//     ["10-24", "organizations.police.tencode.10-24"], // Подозрительный автомобиль / Suspicius vehicle
//     ["10-25", "organizations.police.tencode.10-25"], // Использовать мигалку и сирены / Use light and siren
//     ["10-26", "organizations.police.tencode.10-26"], // Не использовать мигалку, только сирену / No light, siren
//     ["10-27", "organizations.police.tencode.10-27"], // Ведется погоня / In pursuit
//     ["10-28", "organizations.police.tencode.10-28"], // Запрос покинуть (место) для (причина) / Permission to leave (place) for (reason)
//     ["10-29", "organizations.police.tencode.10-29"], // Сработала охранная сигнализация банка / Bank alarm
//     ["10-30", "organizations.police.tencode.10-30"], // Дорожные работы в (место) / Road repair at (place)
//     ["10-31", "organizations.police.tencode.10-31"], // Требуется таран / Dispatch wrecker
//     ["10-32", "organizations.police.tencode.10-32"], // Перекрытие дороги / Road blocked
//     ["10-33", "organizations.police.tencode.10-33"], // Пьяный водитель / Intoxicated driver
//     ["10-34", "organizations.police.tencode.10-34"], // Пьяный гражданин / Intoxicated pedestrian
//     ["10-35", "organizations.police.tencode.10-35"], // Сопровождение / Escort
//     ["10-36", "organizations.police.tencode.10-36"], // Вооруженное ограбление / armed robbety
//     ["10-37", "organizations.police.tencode.10-37"], // Есть пострадавшие / Report of injury
//     ["10-38", "organizations.police.tencode.10-38"], // Побег из тюрьмы / Jail break
//     ["10-39", "organizations.police.tencode.10-39"], // Розыскивается или украден / Wanted or Stolen
//     ["10-40", "organizations.police.tencode.10-40"], // Не использовать мигалку и сирену / No lights or siren

//     ["10-42", "organizations.police.tencode.10-42"], // Превышение скорости / Drag racing
//     ["10-43", "organizations.police.tencode.10-43"], // Подозреваемый (имя) под охраной / Subject (name) in custody
//     ["10-44", "organizations.police.tencode.10-44"], // Проверка связи / Check signal
//     ["10-45", "organizations.police.tencode.10-45"], // Доложите ваш статус / What is your status
//     ["10-46", "organizations.police.tencode.10-46"], // 
//     ["10-200", "organizations.police.tencode.10-200"], // 10-200 место » Нужна полиция туда то тудато
// ];
