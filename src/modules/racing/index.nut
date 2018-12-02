include("modules/racing/raceStartCounter.nut");

local raceName = null;
local raceStatus = "notload"
local raceLaps = 0;
local raceMembers = {};


local raceBlockingCars = [

  // автобусы задающие путь
  ["FK-982", [-1563.25,535.811,-19.9256], [-0.018497,7.00359,0.227692]],
  ["JV-549", [-1563.1, 546.62, -20.0368], [1.61849,3.98685,2.36474]],
  ["MF-607", [-1562.88,557.589,-20.0167], [1.53384,1.2131,-1.78192]],

  ["VS-803", [-1465.91,553.16,-20.2219], [1.81326,0.000696636,-0.0440211]], // бас поворот на 180 где лоун стар
  ["KB-861", [-1500.61,388.854,-19.4177], [47.833,2.50416,8.59472]], // левая колонна
  ["FE-389", [-1485.35,402.609,-19.3511], [-130.086,6.41275,-5.84381]], // правая колонна

  // бас справа от колонны чтобы направо не шли
  ["JC-667", [-1498.92,415.435,-20.1348], [-61.1471,0.129968,0.219995]],

  // бас у спуска на печаную дорогу
  ["XB-128", [-1659.33,591.33,-20.0263], [-171.183,-0.8381,1.77159]],
  // полицейская у спуска на печануню дорогу
  ["PD-619", [-1638.11,585.681,-19.9781], [-31.208,0.498955,-0.164777]],

  // бас перекрывает дорогу у поворота на между домами
  ["PT-102", [-1649.55,366.728,-19.2007], [91.6659,-0.206044,-0.0653862]],

  // полицейская над тоннелем метро
  ["PD-054", [-1636.54,683.937,-9.4598], [-173.885,-11.4418,-0.40165]],

  // автобус при поовроте на колонны
  ["KN-886", [-1464.23,354.252,-20.2715], [0.602768,-0.00122011,0.231951]],

  // Военный грузовик
  ["SL-195", [-1489.96,369.096,-20.2351], [159.315,-1.23142,-4.26945]],
  ["MA-795", [-1557.41,369.276,-20.3753], [-179.77,3.71914,-1.8192]],
  ["UC-619", [-1560.95,377.485,-20.1324], [142.281,1.25718,0.730254]], // бас рядом с военным грузовиком

  // басы на старте
  ["QN-719", [-1575.42,133.533,-13.0116], [123.328,-0.20093,-0.0678875]],
  ["VK-519", [-1565.42,132.969,-13.0115], [-115.497,0.235615,-0.0844986]],
  ["NY-982", [-1645.13,157.929,-6.99077], [1.66173,-3.58532,0.246166]], // верх
  ["GP-827", [-1424.12,157.792,-20.1024], [0.756442,-6.42782,0.51005]], // низ
];


event("onServerStarted", function() {
    log("[racing] loading racing module...");

    createPlace("RACE-DISCV-1", -1625.59,395.884, -1614.41,422.028 );
    createPlace("RACE-DISCV-2", -1637.21,573.284, -1631.73,538.236 );


    createPlace("RACE-POINT-1", -1523.69, 538.134, -1533.42, 576.564 );   // Чекпоинт на повороте около трамплина
    createPlace("RACE-POINT-2", -1618.67, 384.108, -1610.78, 367.152 );  // чекпоинт между домами
    createPlace("RACE-POINT-3", -1498.72, 397.0, -1487.56, 393.0 ); // Зона арки между колоннами

    createPlace("RACE-FINISH",  -1572.35,576.321, -1565.78,580.074 );

});

event("onPlayerConnect", function(playerid) {
  if(raceStatus != "notload") {
    syncRaceBlockingCar();
  }
});

event("onServerMinuteChange", function() {
  if(raceStatus != "notload") {
    syncRaceBlockingCar();
  }
});

event("onPlayerPlaceEnter", function(playerid, name) {
  if(name.find("RACE-") == null) return;
  if(raceStatus != "running") return;

  local charid = getCharacterIdFromPlayerId(playerid);

  if(raceMembers[charid].nextPoint == -1) return msg(playerid, "[ГОНКА] Вы дисквалифированы", CL_THUNDERBIRD);

  if(name == "RACE-DISCV-1" || name == "RACE-DISCV-2") {
    raceMembers[charid].nextPoint = -1;
    msga(format("[ГОНКА] %s на автомобиле %s дисквалифицирован за «срезание» трассы", raceMembers[charid].playerName, raceMembers[charid].carPlate), [], CL_THUNDERBIRD);
    return;
  }

  if(name == "RACE-POINT-1" || name == "RACE-POINT-2" || name == "RACE-POINT-3") {
    msg(playerid, "RACE-POINT-"+raceMembers[charid].nextPoint + " "+ name);
    if("RACE-POINT-"+raceMembers[charid].nextPoint != name) {
      return msga( format("[ГОНКА] Чекпоинт не засчитан для %s", getPlayerName(playerid)), [], CL_CHAT_MONEY_SUB);
    }

    raceMembers[charid].counterPoint++;

    if(raceMembers[charid].counterPoint == raceLaps * 3 + 1 ) {
      msg(playerid, format("[ГОНКА] Чекпоинт %d из %d. Финишная прямая!!!", raceMembers[charid].counterPoint, raceLaps * 3 + 2), CL_CHAT_MONEY_ADD);
    } else {
      msg(playerid, format("[ГОНКА] Чекпоинт %d из %d", raceMembers[charid].counterPoint, raceLaps * 3 + 2), CL_CHAT_MONEY_ADD);
    }
  }

  if(name == "RACE-POINT-1" && raceMembers[charid].nextPoint == 1) {
    raceMembers[charid].nextPoint = 2;
  }

  if(name == "RACE-POINT-2" && raceMembers[charid].nextPoint == 2) {
    raceMembers[charid].nextPoint = 3;
  }

  if(name == "RACE-POINT-3" && raceMembers[charid].nextPoint == 3) {
    if(raceLaps * 3 + 1 == raceMembers[charid].counterPoint) {
      raceMembers[charid].nextPoint = "FINISH";
    } else {
      raceMembers[charid].nextPoint = 1;
    }
  }

  if(name == "RACE-FINISH" && raceMembers[charid].nextPoint == "FINISH") {
    msga(format("[ГОНКА] %s финишировал", getPlayerName(playerid)), [], CL_CHAT_MONEY_ADD);
    raceMembers[charid].nextPoint = "END";
  }
});

function raceCarsParkSync (x, y) {

   for(local i = 1; i <= 8; i++) {

    local vehicleid = getVehicleByPlateText("RACE0"+i);

    if(vehicleid) {
      setVehiclePosition(vehicleid, x, y, -13.1953);
      setVehicleRotation(vehicleid, 0.0, 0.0, 0.0);
      repairVehicle( vehicleid );
      setVehicleFuel( vehicleid, 50.0);
      setVehicleDirtLevel(vehicleid, 0.0);
      x -= 2.5;
    }
  }
}


acmd( "race", "carpark", function( playerid ) {
  raceCarsParkSync(-1694.44, 234.617);
});

acmd( "race", "carsync", function( playerid ) {
  raceCarsParkSync(-1560.7, 157.342);
});


/*
0. все команды админские
1. команда создания гонки (название, тип: кольцевая или спринт)
2. команда установления взносов (по умолчанию без взносов) и возврата денег после заверешения гонки
1 и 2 объединить в одну - иницализация


. команда добавления старта (рельсы, узкая полоса)
. команда добавления финиша (широкая полоса на два направления, нужен счётчик кругов)
. команда добавления участника гонки
. команда удаления участника гонки (
. команда дисквалификации участника гонки (смена статуса)
. команда старта гонки с отсчётом в чате
. команда отмены гонки из-за фальш-старта участника
. команда завершения гонки
. команда отмены гонки (ну не сложилось)
. команда для вывода списка команд
. команда для вывода списка участников гонки (всем в радиусе)
. команда жёлтый флаг
. команда продолжения гонки
. починка всех тачек
. починка конкретной машины по playerid
. переворот конкретной машины по playerid

*/



acmd( "race", "add", function( playerid, targetid = null, numberCar = null) {

    if ( targetid == null || numberCar == null) {
      return msg(playerid, "Формат: /race add targetId numberCar | /race add 2 7", CL_THUNDERBIRD);
    }

    if ( !players[playerid].hands.exists(0) || !players[playerid].hands.get(0) instanceof Item.Race) {
        return msg(playerid, "Нет бланка гонки в руках", CL_THUNDERBIRD);
    }

    local formItem = players[playerid].hands.get(0);
    local members = formItem.data.members;

    local targetid = targetid.tointeger();

    local newMember = [getCharacterIdFromPlayerId(targetid), getPlayerName(targetid)];

    if(numberCar in members) {
      members[numberCar] = newMember
    } else {
      members[numberCar] <- newMember
    }

    players[playerid].hands.get(0).save();
    msga( format("[ГОНКА] %s занимает автомобиль RACE0%s", getPlayerName(targetid), numberCar), [], CL_CHAT_MONEY_ADD );

});

acmd( "race", "remove", function( playerid, charid = null) {

    if ( charid == null) {
      return msg(playerid, "Формат: /race remove charid | /race remove 2", CL_THUNDERBIRD);
    }

    if ( !players[playerid].hands.exists(0) || !players[playerid].hands.get(0) instanceof Item.Race) {
        return msg(playerid, "Нет бланка гонки в руках", CL_THUNDERBIRD);
    }

    local formItem = players[playerid].hands.get(0);
    local members = formItem.data.members;

    local charid = charid.tointeger();

    foreach(carNumber, member in members) {

      if(member[0] == charid) {
        msga( format("[ГОНКА] %s освобождает автомобиль RACE0%s", member[1], carNumber), [], CL_CHAT_MONEY_SUB );
        delete members[carNumber];
        players[playerid].hands.get(0).save();
        return;
      }
    }

    msg(playerid, "Игрок не заявлен в участники гонки", CL_THUNDERBIRD);

});


acmd( "race", "members", function( playerid) {

    if ( !players[playerid].hands.exists(0) || !players[playerid].hands.get(0) instanceof Item.Race) {
        return msg(playerid, "Нет бланка гонки в руках", CL_THUNDERBIRD);
    }

    local formItem = players[playerid].hands.get(0);
    local members = formItem.data.members;

    msg(playerid, "=====  УЧАСТНИКИ ГОНКИ  =====", CL_HELP_TITLE);

    foreach(carNumber, member in members) {
      local message = format("RACE0%s: %s (charId: %d)", carNumber, member[1], member[0]);
      msg( playerid, message, CL_CASCADE );
    }

});

acmd( "race", "forget", function( playerid, targetid = null) {

    if ( targetid == null) {
      return msg(playerid, "Формат: /race forget targetid||all | /race forget 2||all", CL_THUNDERBIRD);
    }

    if ( !players[playerid].hands.exists(0) || !players[playerid].hands.get(0) instanceof Item.Race) {
        return msg(playerid, "Нет бланка гонки в руках", CL_THUNDERBIRD);
    }

    local formItem = players[playerid].hands.get(0);
    local members = formItem.data.members;

    if(targetid == "all") {
      msg(playerid, "=====  УЧАСТНИКИ ГОНКИ  =====", CL_HELP_TITLE);
      foreach(carNumber, member in members) {
        msga( format("%s занимает автомобиль RACE0%s", member[1], carNumber), [], CL_CHAT_MONEY_ADD );
      }
    } else {
      local targetid = targetid.tointeger();
      local charid = getCharacterIdFromPlayerId(targetid);

      foreach(carNumber, member in members) {
        if(member[0] == charid) {
          return msga( format("[ГОНКА] %s занимает автомобиль RACE0%s", member[1], carNumber), [], CL_CHAT_MONEY_ADD );
        }
      }
      msga( format("[ГОНКА] %s не является участником гонки", getPlayerName(targetid)), [], CL_CHAT_MONEY_SUB );
    }
});

acmd( "race", "setlaps", function( playerid, laps = null) {

    if ( laps == null) {
      return msg(playerid, "Формат: /race setlaps count | /race setlaps 5", CL_THUNDERBIRD);
    }

    if ( !players[playerid].hands.exists(0) || !players[playerid].hands.get(0) instanceof Item.Race) {
        return msg(playerid, "Нет бланка гонки в руках", CL_THUNDERBIRD);
    }

    players[playerid].hands.get(0).data.laps <- laps.tointeger();
    players[playerid].hands.get(0).save();

    msg(playerid, format("Установлено гоночных кругов: %s", laps), CL_CHAT_MONEY_ADD );

});

acmd( "race", "setname", function( playerid, name = null) {

    if ( name == null) {
      return msg(playerid, "Формат: /race setlaps count | /race setlaps 5", CL_THUNDERBIRD);
    }

    if ( !players[playerid].hands.exists(0) || !players[playerid].hands.get(0) instanceof Item.Race) {
        return msg(playerid, "Нет бланка гонки в руках", CL_THUNDERBIRD);
    }

    players[playerid].hands.get(0).data.name <- name;
    players[playerid].hands.get(0).save();

    msg(playerid, format("Установлено название гонки: %s", name), CL_CHAT_MONEY_ADD );

});

acmd( "race", "load", function( playerid ) {

    if ( !players[playerid].hands.exists(0) || !players[playerid].hands.get(0) instanceof Item.Race) {
        return msg(playerid, "Нет бланка гонки в руках", CL_THUNDERBIRD);
    }

    local formItem = players[playerid].hands.get(0);

    local members = formItem.data.members;

    if("name" in formItem.data == false) return msg(playerid, "Название гонки не установлено", CL_THUNDERBIRD );
    if("laps" in formItem.data == false) return msg(playerid, "Количество кругов не установлено", CL_THUNDERBIRD );

    raceName = formItem.data.name;
    raceStatus = "load";
    raceLaps = formItem.data.laps;

    foreach (carNumber, member in members) {
      raceMembers[member[0]] <- {
        "playerName": member[1],
        "carPlate": "RACE0"+carNumber,
        "counterPoint": 0,
        "nextPoint": 3
      };
    }

    msg(playerid, format("[ГОНКА] Информация по гонке «%s» загружена", raceName), CL_CHAT_MONEY_ADD );
});


acmd( "race", "start", function( playerid ) {

    if(raceStatus != "load") return msg(playerid, "Гонка не загружена", CL_THUNDERBIRD);

    msga(format("[ГОНКА] Старт гонки «%s» через 10 секунд. Приготовьтесь!", raceName), [], CL_CHAT_MONEY_ADD );

    delayedFunction(12000, function () {
      raceStatus = "running";
      raceStartCounter();
    });
});

acmd( "race", "end", function( playerid ) {

    if(raceStatus != "running") return msg(playerid, "Гонка не начата", CL_THUNDERBIRD);
    raceStatus = "end";

    msga(format("[ГОНКА] Гонка завершена!", raceName), [], CL_CHAT_MONEY_ADD );

});

acmd( "race", "status", function( playerid ) {

    if(raceStatus == "notload") return msg(playerid, "Гонка не загружена", CL_THUNDERBIRD);
    msg(playerid, "==================================", CL_HELP_LINE);
    msg(playerid, format("Название: %s", raceName), CL_CASCADE );
    msg(playerid, format("Статус: %s", raceStatus), CL_CASCADE );
    msg(playerid, format("Количество кругов: %d", raceLaps), CL_CASCADE );
});


acmd( "race", "timer", function( playerid ) {
  raceStartCounter();
});

acmd( "race", "reset", function( playerid ) {
  raceName = null;
  raceStatus = "notload";
  raceLaps = 0;
  raceMembers = {};
});

function syncRaceBlockingCar() {
  foreach(car in raceBlockingCars) {
    local vehicleid = getVehicleByPlateText(car[0]);
    if(vehicleid) {
      setVehiclePosition(vehicleid, car[1][0], car[1][1], car[1][2])
      setVehicleRotation(vehicleid, car[2][0], car[2][1], car[2][2]);
      repairVehicle( vehicleid );
    }
  }
}

acmd( "race", "sync", function( playerid ) {
  syncRaceBlockingCar();
});

acmd( "race", "park", function( playerid ) {
  local i = 0;
  local x = -1566.5;
  local y = 535.7;
  local z = -20.1;
  local rx = 0.0;

  foreach(car in raceBlockingCars) {

    local vehicleid = getVehicleByPlateText(car[0]);

    if(vehicleid && getVehicleModel(vehicleid) == 21) {

      setVehiclePosition(vehicleid, x, y, z);
      setVehicleRotation(vehicleid, rx, 0.0, 0.0);
      repairVehicle( vehicleid );

      i++;
      y -= 12.5;

      if(i == 7) {
        y = 535.7;
      }

      if(i >= 7) {
        x = -1575.0;
        rx = 180.0
      }
    }
  }
});
