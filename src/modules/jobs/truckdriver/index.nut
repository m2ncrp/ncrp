include("modules/jobs/truckdriver/commands.nut");

local job_truck = {};
local job_truck_blocked = {};
local truckcars = {};
local truck_scens = {};

    // сценарий 1: Северный Миллвиль - Мидтаун Отель (доставка материалов) | Only winter
    truck_scens[1] <- { LoadText = "job.truckdriver.scens1.load", UnloadText = "job.truckdriver.scens1.unload", vehicleid = 35,
    LoadPointX = 826.769, LoadPointY = 517.451, LoadPointZ = -11.7677,
    UnloadPointX = -602.528, UnloadPointY = -223.786, UnloadPointZ = -4.22442 };

    // сценарий 2: Хантерс Поинт - Северный Миллвиль (обломки здания) | Only summer
    truck_scens[2] <- { LoadText = "job.truckdriver.scens2.load", UnloadText = "job.truckdriver.scens2.unload", vehicleid = 35,
    LoadPointX = -1582.51, LoadPointY = 571.176, LoadPointZ = -19.8774,
    UnloadPointX = 628.368, UnloadPointY = 382.828, UnloadPointZ = -6.70368 };

    // сценарий 3: Мидтаун Разруха- Северный Миллвиль Свалка | Only winter
    truck_scens[3] <- { LoadText = "job.truckdriver.scens3.load", UnloadText = "job.truckdriver.scens3.unload", vehicleid = 35,
    LoadPointX = -370.788, LoadPointY = -347.463, LoadPointZ =  -13.3999,
    UnloadPointX = 628.368, UnloadPointY = 382.828, UnloadPointZ = -6.70368 };

    // сценарий 4: Доставка Южный Миллвилл склад 12 -> Сенд Айленд В глубине | All
    truck_scens[4] <- { LoadText = "job.truckdriver.scens4.load", UnloadText = "job.truckdriver.scens4.unload", vehicleid = 37,
    LoadPointX = 958.227, LoadPointY = -364.286, LoadPointZ =  -19.8471,
    UnloadPointX = -1526.77, UnloadPointY = 185.209, UnloadPointZ = -12.9613 };

    // сценарий 5: Мидтаун Разруха - Северный Миллвиль Свалка Далеко | Only winter
    truck_scens[5] <- { LoadText = "job.truckdriver.scens5.load", UnloadText = "job.truckdriver.scens5.unload", vehicleid = 35,
    LoadPointX = -370.788, LoadPointY = -347.463, LoadPointZ = -13.3999,
    UnloadPointX = 1189.01, UnloadPointY = 1148.07, UnloadPointZ = 3.3324 };

    // сценарий 6:  | All
    truck_scens[6] <- { LoadText = "job.truckdriver.scens6.load", UnloadText = "job.truckdriver.scens6.unload", vehicleid = 37,
    LoadPointX = -1544.27, LoadPointY = -108.465, LoadPointZ = -18.0451,
    UnloadPointX = -1163.7, UnloadPointY = 1594.2, UnloadPointZ = 6.53147 };

    // сценарий 7:  | All
    truck_scens[7] <- { LoadText = "job.truckdriver.scens7.load", UnloadText = "job.truckdriver.scens7.unload", vehicleid = 37,
    LoadPointX = -1544.27, LoadPointY = -108.465, LoadPointZ = -18.0451,
    UnloadPointX = 634.324, UnloadPointY = 906.558, UnloadPointZ = -12.4234 };

    // сценарий 8: Порт - Литейная в Северном Миллвиле | All
    truck_scens[8] <- { LoadText = "job.truckdriver.scens8.load", UnloadText = "job.truckdriver.scens8.unload", vehicleid = 35,
    LoadPointX = 167.902, LoadPointY = -760.497, LoadPointZ = -21.7744,
    UnloadPointX = 1248.75, UnloadPointY = 1239.23, UnloadPointZ = 0.823301 };

    // сценарий 9: Угольный склад в Северном Миллвиле - пристань в Кингстоне | All
    truck_scens[9] <- { LoadText = "job.truckdriver.scens9.load", UnloadText = "job.truckdriver.scens9.unload", vehicleid = 35,
    LoadPointX = 606.194, LoadPointY = 566.754, LoadPointZ = -12.0788,
    UnloadPointX = -1140.78, UnloadPointY = 1189.37, UnloadPointZ = -21.7018 };

    // сценарий 10: Мидтаун Отель - Прачечная в Маленькой Италии | Only summer
    truck_scens[10] <- { LoadText = "job.truckdriver.scens10.load", UnloadText = "job.truckdriver.scens10.unload", vehicleid = 37,
    LoadPointX = -606.833, LoadPointY = -340.543, LoadPointZ = -9.41061,
    UnloadPointX = -69.693, UnloadPointY = 500.871, UnloadPointZ = -19.7248 };

    // сценарий 11: Диптон - Аркада (товары) | All
    truck_scens[11] <- { LoadText = "job.truckdriver.scens11.load", UnloadText = "job.truckdriver.scens11.unload", vehicleid = 37,
    LoadPointX = -471.886, LoadPointY = 1735.74, LoadPointZ = -23.0622,
    UnloadPointX = -586.659, UnloadPointY = 51.6276, UnloadPointZ = 0.0326465 };

    // работы доступные в сезон
    local truck_scens_winter = [ 1, 3, 4, 5, 6, 7, 8, 9, 11 ];
    local truck_scens_summer = [ 2, 4, 6, 7, 8, 9, 10, 11 ];

    // сценарий 1: Северный Миллвиль - Мидтаун Разруха (доставка материалов) | All
    // truck_scens[10] <- { LoadText = "job.truckdriver.scens1.load", UnloadText = "job.truckdriver.scens1.unload", LoadPointX = 826.769, LoadPointY = 517.451, LoadPointZ = -11.7677, UnloadPointX = -370.788, UnloadPointY = -347.463, UnloadPointZ =  -13.3999 };

alternativeTranslate({

    "ru|job.truckdriver"                   : "шофёр"

    "ru|job.truckdriver.scens1.load"       : "Садись в открытый грузовик %s и отправляйся в Северный Милвилл для загрузки строительных материалов."
    "ru|job.truckdriver.scens1.unload"     : "Грузовик загружен. Отправляйся в Мидтаун для разгрузки строительных материалов."

    "ru|job.truckdriver.scens2.load"       : "Садись в открытый грузовик %s и отправляйся в Хантерс-Пойнт для погрузки обломков сгоревшего дома."
    "ru|job.truckdriver.scens2.unload"     : "Грузовик загружен. Отправляйся в Северный Милвилл для разгрузки обломков сгоревшего дома."

    "ru|job.truckdriver.scens3.load"       : "Садись в открытый грузовик %s и отправляйся в Мидтаун для погрузки обломков разрушенного здания."
    "ru|job.truckdriver.scens3.unload"     : "Грузовик загружен. Отправляйся в Северный Милвилл для разгрузки обломков разрушенного здания."

    "ru|job.truckdriver.scens4.load"       : "Садись в крытый грузовик %s и отправляйся в Южный Милвилл для погрузки товара."
    "ru|job.truckdriver.scens4.unload"     : "Грузовик загружен. Отправляйся в Сэнд-Айленд для разгрузки."

    "ru|job.truckdriver.scens5.load"       : "Садись в открытый грузовик %s и отправляйся в Мидтаун для погрузки обломков разрушенного здания."
    "ru|job.truckdriver.scens5.unload"     : "Грузовик загружен. Отправляйся в Северный Милвилл для разгрузки обломков разрушенного здания."

    "ru|job.truckdriver.scens6.load"       : "В одном из баров намечается фуршет серьёзных людей. Нужно доставить грузовик с алкоголем. Садись в крытый грузовик %s и отправляйся к ликёро-водочному заводу для погрузки ящиков. Всё уже оплачено."
    "ru|job.truckdriver.scens6.unload"     : "Грузовик загружен. Отправляйся к бару «Зелёный холм» в Кингстоне для разгрузки ящиков с алкоголем."

    "ru|job.truckdriver.scens7.load"       : "Во время бурной пирушки в баре завязался знатный мордобой: все бутылки с алкоголем пошли в расход. Нужно восполнить ассортимент. Садись в крытый грузовик %s и отправляйся к ликёро-водочному заводу для погрузки ящиков."
    "ru|job.truckdriver.scens7.unload"     : "Грузовик загружен. Отправляйся к бару «Дрэгстрип» в Северном Милвилле для разгрузки ящиков с алкоголем."

    "ru|job.truckdriver.scens8.load"       : "Бери открытый грузовик %s и езжай в порт. Надо доставить очередную партию руды для обработки."
    "ru|job.truckdriver.scens8.unload"     : "Грузовик загружен. Отправляйся к литейной в Северный Миллвил для выгрузки руды."

    "ru|job.truckdriver.scens9.load"       : "На пристани заканчивается топливо для катеров. Садись в открытый грузовик %s и отправляйся на угольный склад в Северном Миллвиле."
    "ru|job.truckdriver.scens9.unload"     : "Грузовик загружен. Доставь уголь на пристань в Кингстоне."

    "ru|job.truckdriver.scens10.load"      : "Из отеля съехала очередная толпа гуляк, оставив после себя много грязного белья. Садись в крытый грузовик %s и побыстрее доставь эти тряпки в прачечную в Маленькой Италии."
    "ru|job.truckdriver.scens10.unload"    : "Грузовик загружен. Отвези белье в прачечную в Маленькой Италии."

    "ru|job.truckdriver.scens11.load"      : "Недавно прибыл поезд с товарами для продажи. Садись в крытый грузовик %s и поезжай на железнодорожный вокзал в Диптоне для загрузки."
    "ru|job.truckdriver.scens11.unload"    : "Грузовик загружен. Доставь товары к торговому центру Аркада в Вест-Сайде."

    "ru|job.truckdriver.badworker"         : "Robert Casey: Плохой из тебя работник. Для такого как ты у меня нет работы."
    "ru|job.truckdriver.badworker.onleave" : "Robert Casey: Значит отказываешься от задания? Хреновый ты работник, гуляй!"
    "ru|job.truckdriver.goodluck"          : "Robert Casey: Удачи тебе, пацан! Приходи, если нужна работа."
    "ru|job.truckdriver.needcomplete"      : "Robert Casey: Сначала заверши доставку."
    "ru|job.truckdriver.nicejob"           : "Robert Casey: Отличная работа! Держи $%.2f."
    "ru|job.truckdriver.now"               : "Robert Casey: Добро пожаловать в ряды шофёров!"

    "ru|job.truckdriver.needtruck"         : "Вам нужен грузовик %s."
    "ru|job.truckdriver.needlevel"         : "[TRUCK] Шофёром можно устроиться начиная с уровня %d."
    "ru|job.truckdriver.wantwork"          : "[TRUCK] Ты работаешь шофёром. Если хочешь поработать - отправляйся к транспортной базе у моста в Хайбрук."
    "ru|job.truckdriver.already"           : "[TRUCK] Ты уже работаешь шофёром."
    "ru|job.truckdriver.notpassenger"      : "[TRUCK] Доставка может осуществляться только водителем, но не пассажиром."
    "ru|job.truckdriver.loading"           : "[TRUCK] Грузовик загружается. Подожди..."
    "ru|job.truckdriver.unloading"         : "[TRUCK] Грузовик разгружается. Подожди..."
    "ru|job.truckdriver.alreadyloaded"     : "[TRUCK] Грузовик уже загружен."
    "ru|job.truckdriver.empty"             : "[TRUCK] Грузовик пуст."
    "ru|job.truckdriver.takemoney"         : "[TRUCK] Возвращайся на базу к мосту в Хайбрук, припаркуй грузовик и получи заработанные деньги."

    "ru|job.truckdriver.help.title"        : "Список команд, доступных шофёру:"
    "ru|job.truckdriver.help.job"              :   "кнопка E"
    "ru|job.truckdriver.help.jobtext"          :   "Устроиться на работу шофёром (подойти к Robert Casey)"
    "ru|job.truckdriver.help.jobleave"         :   "кнопка Q"
    "ru|job.truckdriver.help.jobleavetext"     :   "Уволиться с работы (подойти к Robert Casey)"
    "ru|job.truckdriver.help.loadunload"       :   "кнопка E"
    "ru|job.truckdriver.help.loadunloadtext"   :   "Загрузить/разгрузить грузовик (нужно быть в грузовике)"





    "en|job.truckdriver"                   : "truck driver"

    "en|job.truckdriver.scens1.load"       : "Sit into %s and go to North Millville to load construction materials."
    "en|job.truckdriver.scens1.unload"     : "The truck loaded. Go to Midtown to unload construction materials."

    "en|job.truckdriver.scens2.load"       : "Sit into %s and go to Hunters Point to load debris of burnt building."
    "en|job.truckdriver.scens2.unload"     : "The truck loaded. Go to North Millville to unload debris of burnt building."

    "en|job.truckdriver.scens3.load"       : "Sit into %s and go to Midtown to load debris of destroyed building."
    "en|job.truckdriver.scens3.unload"     : "The truck loaded. Go to North Millville to unload debris of destroyed building."

    "en|job.truckdriver.scens4.load"       : "Sit into %s and go to South Millville to load cargo."
    "en|job.truckdriver.scens4.unload"     : "The truck loaded. Go to Sand Island to unload cargo."

    "en|job.truckdriver.scens5.load"       : "Sit into %s and go to Midtown to load debris of destroyed building."
    "en|job.truckdriver.scens5.unload"     : "The truck loaded. Go to North Millville to unload debris of destroyed building."

    "en|job.truckdriver.scens6.load"       : "Sit into %s and go to the Distillery in Sand Island to load alcohol."
    "en|job.truckdriver.scens6.unload"     : "The truck loaded. Go to Hill of Tara in Kingston to unload alcohol."

    "en|job.truckdriver.scens7.load"       : "Sit into %s and go to the Distillery in Sand Island to load alcohol."
    "en|job.truckdriver.scens7.unload"     : "The truck loaded. Go to Dragsrtip in North Millville to unload alcohol."

    "en|job.truckdriver.scens8.load"       : "Бери открытый грузовик %s и езжай в порт. Надо доставить очередную партию руды для обработки."
    "en|job.truckdriver.scens8.unload"     : "Грузовик загружен. Отправляйся к литейной в Северный Миллвил для выгрузки руды."

    "en|job.truckdriver.scens9.load"       : "На пристани заканчивается топливо для катеров. Садись в открытый грузовик %s и отправляйся на угольный склад в Северном Миллвиле."
    "en|job.truckdriver.scens9.unload"     : "Грузовик загружен. Доставь уголь на пристань в Кингстоне."

    "en|job.truckdriver.scens10.load"      : "Из отеля съехала очередная толпа гуляк, оставив после себя много грязного белья. Садись в открытый грузовик %s и побыстрее доставь эти тряпки в прачечную в Маленькой Италии."
    "en|job.truckdriver.scens10.unload"    : "Грузовик загружен. Отвези белье в прачечную в Маленькой Италии."

    "en|job.truckdriver.scens11.load"      : "Недавно прибыл поезд с товарами для продажи. Садись в крытый грузовик %s и поезжай на железнодорожный вокзал в Диптоне для загрузки."
    "en|job.truckdriver.scens11.unload"    : "Грузовик загружен. Доставь товары к торговому центру Аркада в Вест-Сайде."

    "en|job.truckdriver.needtruck"         : "You need a %s."
    "en|job.truckdriver.badworker"         : "Robert Casey: You are a bad worker. I'll not give you a job."
    "en|job.truckdriver.badworker.onleave" : "Robert Casey: You are a bad worker. Get out of here."
    "en|job.truckdriver.goodluck"          : "Robert Casey: Good luck, guy! Come if you need a job."
    "en|job.truckdriver.needcomplete"      : "Robert Casey: You must complete delivery before."
    "en|job.truckdriver.nicejob"           : "Robert Casey: Nice job! Keep $%.2f."
    "en|job.truckdriver.now"               : "Robert Casey: You're a truck driver now. Welcome!"

    "en|job.truckdriver.needlevel"         : "[TRUCK] You need level %d to become truck driver."
    "en|job.truckdriver.wantwork"          : "[TRUCK] You're a truck driver. If you want to work - go to transport facilities near Highbrook Bridge."
    "en|job.truckdriver.already"           : "[TRUCK] You're truck driver already."
    "en|job.truckdriver.notpassenger"      : "[TRUCK] Delivery can be performed only by driver, but not by passenger."
    "en|job.truckdriver.loading"           : "[TRUCK] Loading truck. Wait..."
    "en|job.truckdriver.unloading"         : "[TRUCK] Unloading truck. Wait..."
    "en|job.truckdriver.alreadyloaded"     : "[TRUCK] Truck already loaded."
    "en|job.truckdriver.empty"             : "[TRUCK] Truck is empty."
    "en|job.truckdriver.takemoney"         : "[TRUCK] Go back to transport facilities near Highbrook Bridge to park truck and get money."

    "en|job.truckdriver.help.title"            :   "Controls for TRUCK DRIVER:"
    "en|job.truckdriver.help.job"              :   "E button"
    "en|job.truckdriver.help.jobtext"          :   "Get truck driver job near Robert Casey"
    "en|job.truckdriver.help.jobleave"         :   "Q button"
    "en|job.truckdriver.help.jobleavetext"     :   "Leave truck driver job near Robert Casey"
    "en|job.truckdriver.help.loadunload"       :   "E button"
    "en|job.truckdriver.help.loadunloadtext"   :   "Load/unload truck (need be in truck)"

});

/*
826.769, 517.451, -11.7677, 89.8741, -0.213281, 0.213751, NorthMillVilleLoadMaterials
-370.788, -347.463, -13.3999, -179.469, -0.0121328, -1.44906, MidtownUnloadMaterials
*/


const RADIUS_TRUCK = 2.0;

const TRUCK_JOB_X =  -704.88; //under Red Bridge
const TRUCK_JOB_Y =  1461.06; //
const TRUCK_JOB_Z = -6.86539; //

const TRUCK_JOB_TIMEOUT = 1800; // 30 minutes
const TRUCK_JOB_SKIN = 130;
const TRUCK_JOB_SALARY = 10.0;
const TRUCK_JOB_LEVEL = 1;
      TRUCK_JOB_COLOR <- CL_CRUSTA;
local TRUCK_JOB_GET_HOUR_START     = 0;
local TRUCK_JOB_GET_HOUR_END       = 23;
local TRUCK_JOB_LEAVE_HOUR_START   = 0;
local TRUCK_JOB_LEAVE_HOUR_END     = 23;
local TRUCK_JOB_WORKING_HOUR_START = 0;
local TRUCK_JOB_WORKING_HOUR_END   = 23;
local TRUCK_ROUTE_IN_HOUR = 4;
local TRUCK_ROUTE_NOW = 3;

local carp = false;
local carp2 = false;


event("onServerStarted", function() {
    log("[jobs] loading truckdriver job...");
                                                                                            //  loaded, playerid
    //truckcars[createVehicle(35, -705.155, 1456, -6.48204, -43.0174, -0.252974, -0.64192)]     <- [ false, null ]; //    Flatbed
    truckcars[createVehicle(37, -708.151, 1453.25, -6.50832, -43.1396, -0.445434, -1.12674)]  <- [ false, null ]; //    Covered
    truckcars[createVehicle(35, -711.119, 1450.54, -6.52765, -41.8644, -0.613728, -1.6044)]   <- [ false, null ]; //    Flatbed
    truckcars[createVehicle(35, -714.315, 1447.55, -6.52792, -41.1587, -1.82778, -0.432325)]  <- [ false, null ]; //    Flatbed
    truckcars[createVehicle(37, -717.422, 1444.53, -6.33198, -39.2871, -1.59798, 3.26338)]    <- [ false, null ]; //    Covered
/*
    carp = createVehicle(42, -364.809, -348.672, -13.5259, -0.540874, -0.0051816, -1.09775); // police Midtown

    createVehicle(27, -368.761, -330.329, -13.1167, 113.28, -0.503684, -1.39627); //Bron1
    createVehicle(27, -368.435, -366.052, -13.8605, 63.8406, -0.365066, -1.26762); //Bron2

    if (isSummer()) {
        carp2 = createVehicle(42, -1604.3, 569.969, -19.9775, -54.2438, 0.27688, -0.144837); // police Most
    }
*/
    create3DText ( TRUCK_JOB_X, TRUCK_JOB_Y, TRUCK_JOB_Z+0.35, "TRANSPORT COMPANY", CL_ROYALBLUE );
    create3DText ( TRUCK_JOB_X, TRUCK_JOB_Y, TRUCK_JOB_Z+0.20, "Press E to action", CL_WHITE.applyAlpha(150), RADIUS_TRUCK );

    registerPersonalJobBlip("truckdriver", TRUCK_JOB_X, TRUCK_JOB_Y);
});

/*
        truckcars[createVehicle(39, -714.917, 1448.12, -6.50445, -40.4398, -1.22047, 0.221121)]  <- [ false, false ]; //    SnowTruck1
        truckcars[createVehicle(39, -718.038, 1445.28, -6.35813, -39.2938, -1.00603, 3.70481)]  <- [ false, false ]; //     SnowTruck2
        truckcars[createVehicle(39, -721.274, 1442.58, -6.09918, -38.2308, -0.808422, 5.6408)]  <- [ false, false ]; //     SnowTruck3

-1582.32, 572.606, -19.7032, 179.534, 0.265915, 0.166093, TruckFireLoad
-1582.55, 571.041, -19.8709, -177.697, -0.325503, -0.0581149, TruckNewFireLoad
627.969, 382.268, -6.70534, -88.2257, 0.220177, -0.0782472, TruckNewFireUNLoad


-1603.78, 568.653, -19.9782, -50.4648, 0.293502, -0.120968, PoliceFireLoad


826.237, 519.311, -11.7672, 92.6744, -0.229025, 0.218576, TruckNewMidtownLoad


    //creating 3dtext for bus depot
    //create3DText ( TRUCK_JOB_X, TRUCK_JOB_Y, TRUCK_JOB_Z+0.35, "SEAGIFT's OFFICE", CL_ROYALBLUE );



job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] == null;         -  если есть работа для игрока
job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] == "nojob";      -  если нет работы для игрока
job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] == "working";    -  если игрок работает
job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] == "complete";    -  если игрок выполнил работу
*/


key("e", function(playerid) {
    truckJobTalk( playerid );
    truckJobLoadUnload( playerid )
}, KEY_UP);

key("q", function(playerid) {
    truckJobRefuseLeave( playerid );
}, KEY_UP);

event("onPlayerConnect", function(playerid) {
     job_truck[getCharacterIdFromPlayerId(playerid)] <- {};
     job_truck[getCharacterIdFromPlayerId(playerid)]["userjob"] <- null;
     job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] <- null;
     job_truck[getCharacterIdFromPlayerId(playerid)]["leavejob3dtext"] <- null;
     job_truck[getCharacterIdFromPlayerId(playerid)]["truckblip3dtext"] <- [null, null, null];
});

event("onPlayerSpawn", function(playerid) {
    //setVehicleBeaconLightState(carp, true);
    //if (isSummer()) { setVehicleBeaconLightState(carp2, true); }
});

event("onServerPlayerStarted", function( playerid ){


    if(players[playerid]["job"] == "truckdriver") {
        msg( playerid, "job.truckdriver.wantwork", TRUCK_JOB_COLOR );
        job_truck[getCharacterIdFromPlayerId(playerid)]["leavejob3dtext"] = createPrivate3DText (playerid, TRUCK_JOB_X, TRUCK_JOB_Y, TRUCK_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_TRUCK );
    }
});

event("onPlayerVehicleEnter", function (playerid, vehicleid, seat) {
    if (!isPlayerVehicleTruck(playerid, 35) && !isPlayerVehicleTruck(playerid, 37) ) {
        return;
    }

    if (seat != 0) return;

    if (isTruckDriver(playerid)) {
        unblockVehicle(vehicleid);
    } else {
        blockVehicle(vehicleid);
    }
});

event("onPlayerVehicleExit", function(playerid, vehicleid, seat) {
    if (!isPlayerVehicleTruck(playerid, 35) && !isPlayerVehicleTruck(playerid, 37) ) {
        return;
    }

    if (seat == 0) {
        blockVehicle(vehicleid);
    }
});

event("onServerHourChange", function() {
    TRUCK_ROUTE_NOW = TRUCK_ROUTE_IN_HOUR + random(-1, 1);
});

/**
 * Create private 3DTEXT AND BLIP
 * @param  {int}  playerid
 * @param  {float} x
 * @param  {float} y
 * @param  {float} z
 * @param  {string} text
 * @param  {string} cmd
 * @return {array} [idtext1, id3dtext2, idblip]
 */
function truckJobCreatePrivateBlipText(playerid, x, y, z, text, cmd) {
    return [
            createPrivate3DText (playerid, x, y, z+0.35, text, CL_RIPELEMON, 40 ),
            createPrivate3DText (playerid, x, y, z+0.20, cmd, CL_WHITE.applyAlpha(150), 4.0 ),
            createPrivateBlip (playerid, x, y, ICON_YELLOW, 4000.0)
    ];
}

/**
 * Remove private 3DTEXT AND BLIP
 * @param  {int}  playerid
 */
function truckJobRemovePrivateBlipText ( playerid ) {
    if(job_truck[getCharacterIdFromPlayerId(playerid)]["truckblip3dtext"][0] != null) {
        remove3DText ( job_truck[getCharacterIdFromPlayerId(playerid)]["truckblip3dtext"][0] );
        remove3DText ( job_truck[getCharacterIdFromPlayerId(playerid)]["truckblip3dtext"][1] );
        removeBlip   ( job_truck[getCharacterIdFromPlayerId(playerid)]["truckblip3dtext"][2] );
        job_truck[getCharacterIdFromPlayerId(playerid)]["truckblip3dtext"][0] = null;
    }
}


/**
 * Check is player is a truck truck driver
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isTruckDriver(playerid) {
    return (isPlayerHaveValidJob(playerid, "truckdriver"));
}

/**
 * Check is player's vehicle is a truck
 * @param  {int}  playerid
 * @return {Boolean} true/false
 */
function isPlayerVehicleTruck(playerid, vehicleid) {
    return (isPlayerInValidVehicle(playerid, vehicleid));
}


function truckJobTalk( playerid ) {
    // если игрок не в нужной точке
    if(!isPlayerInValidPoint(playerid, TRUCK_JOB_X, TRUCK_JOB_Y, RADIUS_TRUCK)) {
        return;
    }
    // если у игрока недостаточный уровень
    if(!isPlayerLevelValid ( playerid, TRUCK_JOB_LEVEL )) {
        return msg(playerid, "job.truckdriver.needlevel", TRUCK_JOB_LEVEL, TRUCK_JOB_COLOR );
    }

    if (getCharacterIdFromPlayerId(playerid) in job_truck_blocked) {
        if (getTimestamp() - job_truck_blocked[getCharacterIdFromPlayerId(playerid)] < TRUCK_JOB_TIMEOUT) {
            return msg( playerid, "job.truckdriver.badworker");
        }
    }

    // если у игрока статус работы == null
    if(job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] == null) {
/*
        // если игрок уже работает водителем грузовика
        if(!isTruckDriver( playerid )) {
            return msg( playerid, "job.truckdriver.already", TRUCK_JOB_COLOR );
        }
*/
        // если игрок уже есть другая работа
        if(isPlayerHaveJob(playerid) && getPlayerJob(playerid) != "truckdriver") {
            return msg( playerid, "job.alreadyhavejob", getLocalizedPlayerJob(playerid), TRUCK_JOB_COLOR );
        }

        local hour = getHour();
        if(hour < TRUCK_JOB_WORKING_HOUR_START || hour >= TRUCK_JOB_WORKING_HOUR_END) {
            return msg( playerid, "job.closed", [ TRUCK_JOB_WORKING_HOUR_START.tostring(), TRUCK_JOB_WORKING_HOUR_END.tostring()], TRUCK_JOB_COLOR );
        }

        if(TRUCK_ROUTE_NOW < 1) {
            return msg( playerid, "job.nojob", BUS_JOB_COLOR );
        }

        // create private blip job
        //createPersonalJobBlip( playerid, TRUCK_JOB_X, TRUCK_JOB_Y);
        //

        if(!isPlayerHaveJob(playerid)) {
            msg( playerid, "job.truckdriver.now" );
            setPlayerJob( playerid, "truckdriver");
            screenFadeinFadeoutEx(playerid, 250, 200, function() {
                setPlayerModel( playerid, TRUCK_JOB_SKIN );
            });
        }

        local userjob = null;
        if(isSummer()) {
            userjob = truck_scens[truck_scens_summer[random(0, truck_scens_summer.len()-1)]];
        } else {
            userjob = truck_scens[truck_scens_winter[random(0, truck_scens_winter.len()-1)]];
        }

        job_truck[getCharacterIdFromPlayerId(playerid)]["userjob"] = userjob;
        msg( playerid, userjob.LoadText, getVehicleNameByModelId( userjob.vehicleid ), TRUCK_JOB_COLOR );
        job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] = "working";



        job_truck[getCharacterIdFromPlayerId(playerid)]["truckblip3dtext"] = truckJobCreatePrivateBlipText(playerid, userjob.LoadPointX, userjob.LoadPointY, userjob.LoadPointZ, "LOAD HERE", "Press E to load");
        if(job_truck[getCharacterIdFromPlayerId(playerid)]["leavejob3dtext"] == null) {
            job_truck[getCharacterIdFromPlayerId(playerid)]["leavejob3dtext"] = createPrivate3DText (playerid, TRUCK_JOB_X, TRUCK_JOB_Y, TRUCK_JOB_Z+0.05, "Press Q to leave job", CL_WHITE.applyAlpha(100), RADIUS_TRUCK );
        }
        return;
    }

    // если у игрока статус работы == для тебя нет работы
    // if (job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] == "nojob") {
    //     return msg( playerid, "job.truckdriver.badworker");
    // }

    // если у игрока статус работы == выполняет работу
    if (job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] == "working") {
        return msg( playerid, "job.truckdriver.needcomplete" );
    }
    // если у игрока статус работы == завершил работу
    if (job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] == "complete") {
        job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] = null;
        truckGetSalary( playerid );
        return;
    }
}


function truckJobRefuseLeave( playerid ) {
    if(!isPlayerInValidPoint(playerid, TRUCK_JOB_X, TRUCK_JOB_Y, RADIUS_TRUCK)) {
        return;
    }

    if(!isTruckDriver(playerid)) {
        return;
    }

    local hour = getHour();
    if(hour < TRUCK_JOB_LEAVE_HOUR_START || hour >= TRUCK_JOB_LEAVE_HOUR_END) {
        return msg( playerid, "job.closed", [ TRUCK_JOB_LEAVE_HOUR_START.tostring(), TRUCK_JOB_LEAVE_HOUR_END.tostring()], TRUCK_JOB_COLOR );
    }

    if(job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] == null) {
        msg( playerid, "job.truckdriver.goodluck");
    }

    if (job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] == "working") {
        msg( playerid, "job.truckdriver.badworker.onleave");
        job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] = null;
        job_truck_blocked[getCharacterIdFromPlayerId(playerid)] <- getTimestamp();
    }

    if (job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] == "complete") {
        truckGetSalary( playerid );
        msg( playerid, "job.truckdriver.goodluck");
        job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] = null;
    }

    screenFadeinFadeoutEx(playerid, 250, 200, function() {
        msg( playerid, "job.leave", TRUCK_JOB_COLOR );
        remove3DText ( job_truck[getCharacterIdFromPlayerId(playerid)]["leavejob3dtext"] );
        job_truck[getCharacterIdFromPlayerId(playerid)]["leavejob3dtext"] = null;

        setPlayerJob( playerid, null );
        restorePlayerModel(playerid);

        // remove private blip job
        removePersonalJobBlip ( playerid );

        truckJobRemovePrivateBlipText ( playerid );
    });

}


function truckGetSalary( playerid ) {
    local amount = TRUCK_JOB_SALARY + (random(-1, 3)).tofloat();
    addMoneyToPlayer(playerid, amount);
    msg( playerid, "job.truckdriver.nicejob", [amount] );
}


// working good, check
function truckJobLoadUnload( playerid ) {

    local vehicleid = getPlayerVehicle( playerid );
    if(job_truck[getCharacterIdFromPlayerId(playerid)]["userjob"] == null || !isPlayerInVehicle(playerid) || !isPlayerVehicleDriver(playerid) || !(vehicleid in truckcars)) {
        return;
    }
    if (isPlayerVehicleMoving(playerid)) {
        return;
    }


/*
    if(!isTruckDriver(playerid)) {
        return msg( playerid, "job.truckdriver.not", TRUCK_JOB_COLOR );
    }
*/


    local userjob = job_truck[getCharacterIdFromPlayerId(playerid)]["userjob"];

    if (!isPlayerVehicleTruck(playerid, userjob.vehicleid) && isVehicleInValidPoint(playerid, userjob.LoadPointX, userjob.LoadPointY, 4.0 )) {
        return msg( playerid, "job.truckdriver.needtruck", getVehicleNameByModelId( userjob.vehicleid ), TRUCK_JOB_COLOR );
    }

    if(truckcars[vehicleid][0] && truckcars[vehicleid][1] == playerid && isVehicleInValidPoint(playerid, userjob.LoadPointX, userjob.LoadPointY, 4.0 )) {
        return msg( playerid, "job.truckdriver.alreadyloaded", TRUCK_JOB_COLOR );
    }

    if(!truckcars[vehicleid][0] && isVehicleInValidPoint(playerid, userjob.UnloadPointX, userjob.UnloadPointY, 4.0 )) {
        return msg( playerid, "job.truckdriver.empty", TRUCK_JOB_COLOR );
    }


/*
    if(isPlayerVehicleMoving(playerid)){
        return msg( playerid, "job.truckdriver.driving", CL_RED );
    }
*/
    if(!isPlayerInVehicleSeat(playerid, 0)) {
        return msg( playerid, "job.truckdriver.notpassenger", TRUCK_JOB_COLOR );
    }

    if( ( !truckcars[vehicleid][0] || ( truckcars[vehicleid][0] && truckcars[vehicleid][1] != playerid  ) ) && isVehicleInValidPoint(playerid, userjob.LoadPointX, userjob.LoadPointY, 4.0 )) {
        //loading
        truckJobRemovePrivateBlipText ( playerid );
        freezePlayer( playerid, true);
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
        setVehiclePartOpen(vehicleid, 1, true);
        setVehicleEngineState(vehicleid, false);
        msg( playerid, "job.truckdriver.loading", TRUCK_JOB_COLOR );
        trigger(playerid, "hudCreateTimer", 45.0, true, true);

        playerDelayedFunction(playerid, 45000, function() {
            dbg("[JOB TRUCK] "+getPlayerName(playerid)+"["+playerid+"] load truck.");
            freezePlayer( playerid, false);
            delayedFunction(1000, function () { freezePlayer( playerid, false); });
            truckcars[vehicleid][0] = true;
            truckcars[vehicleid][1] = playerid;
            job_truck[getCharacterIdFromPlayerId(playerid)]["truckblip3dtext"] = truckJobCreatePrivateBlipText(playerid, userjob.UnloadPointX, userjob.UnloadPointY, userjob.UnloadPointZ, "UNLOAD HERE", "Press E to unload");
            msg( playerid, userjob.UnloadText, TRUCK_JOB_COLOR );
            setVehiclePartOpen(vehicleid, 1, false);

        });

    }


    if(truckcars[vehicleid][0] && isVehicleInValidPoint(playerid, userjob.UnloadPointX, userjob.UnloadPointY, 4.0 )) {
        // UNloading
        truckJobRemovePrivateBlipText ( playerid );
        //truck_limit_in_hour_current -= 1;
        freezePlayer( playerid, true );
        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
        setVehiclePartOpen(vehicleid, 1, true);
        setVehicleEngineState(vehicleid, false);

        msg( playerid, "job.truckdriver.unloading", TRUCK_JOB_COLOR );
        trigger(playerid, "hudCreateTimer", 45.0, true, true);

        playerDelayedFunction(playerid, 45000, function() {
                dbg("[JOB TRUCK] "+getPlayerName(playerid)+"["+playerid+"] unload truck.");
                freezePlayer( playerid, false);
                delayedFunction(1000, function () { freezePlayer( playerid, false); });
                job_truck[getCharacterIdFromPlayerId(playerid)]["userstatus"] = "complete";
                truckcars[vehicleid][0] = false;
                truckcars[vehicleid][1] = null;
                msg( playerid, "job.truckdriver.takemoney", TRUCK_JOB_COLOR );
                setVehiclePartOpen(vehicleid, 1, false);
        });
    }
}
