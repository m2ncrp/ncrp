const MAX_HEALTH = 720.00;
const DEFAULT_MONEY = 500.0;
const AFK_TIME = 180000; // 3 minutes
const NORMAL_RADIUS = 20.0;
const SHOUT_RADIUS = 35.0;
const DEFAULT_LANGUAGE = "ru";
const STRUCT_PRISON_BLOCK3 = 13;
const VEHICLE_PREFIX = "NC-";
const MAX_VEHICLES = 1000;

const AUTOSAVE_TIME = 10;

const WORLD_SECONDS_PER_MINUTE = 30;
const WORLD_MINUTES_PER_HOUR = 60;
const WORLD_HOURS_PER_DAY = 24;
const WORLD_DAYS_PER_MONTH = 30;
const WORLD_MONTH_PER_YEAR = 12;
const WEATHER_PHASE_CHANGE = 2;

const STRICT_POINTS = 0;
const RANDOM_POINTS = 1;
const ROUTE_POINT_RADIUS = 10.0;

_player_prison_skins <- [140,138,141,139,143,144,149,150,152];

_vehicle_colors <- [
	[rgb(79,  72,  65 ), rgb(143, 137, 124)],
	[rgb(120, 111, 68 ), rgb(143, 137, 124)],
	[rgb(15,  32,  24 ), rgb(120, 111, 68 )],
	[rgb(18,  44,  69 ), rgb(154, 154, 154)],
	[rgb(35,  22,  8  ), rgb(132, 112, 78 )],
	[rgb(57,  49,  29 ), rgb(73,  75,  33 )],
	[rgb(102, 70,  18 ), rgb(145, 114, 33 )],
	[rgb(121, 113, 31 ), rgb(74,  43,  8  )],
	[rgb(255, 255, 255), rgb(0  , 0  , 0  )], // police
	[rgb(0,   0,   0  ), rgb(0,   0,   0  )], // black
];

_vehicle_prices <- [
	[0,2497.50,11], [1,2500.00,10],
	[4,1600.00,10], [6,1250.00,10],
	[7,900.00,10],  [8,1050.00,10],
	[9,750.00,10],	[10,4500.00,10],
	[12,455.00,11],	[13,800.00,10],
	[14,1600.00,10],[15,1750.00,10],
	[16,1750.00,10],[17,10340.00,11],
	[18,2585.00,11],[22,600.00,10],
	[23,650.00,10],	[25,400.00,10],
	[28,700.00,10],	[29,1750.00,11],
	[30,450.00,10],	[31,400.00,10],
	[32,400.00,10],	[41,1100.00,10],
	[43,250.00,10],	[44,600.00,10],
	[45,1350.00,11],[47,350.00,10],
	[48,300.00,10],	[50,650.00,10],
	[52,650.00,10],	[53,450.00,10]
];

metroInfos <- [
	[ 234.378662, 396.031830, -9.407516, "Китайский квартал" ], 		// sub Китайский квартал вход справа
	[ -293.068512, 553.138000, -2.273677, "Аптаун" ],  					// sub Аптаун вход справа
	[ -555.864136, 1592.924927, -21.863888, "Вокзал" ], 				// sub вокзал
	[ -1117.546509, 1363.452026, -17.572432, "Кингстон" ],				// sub кингстон
	[ -1550.738159, -231.029968, -13.589154, "Сэнд-Айленд" ], 			// sub Сэнд-Айленд вход справа
	[ -511.283478, 21.851606, -5.709612, "Вест-сайд" ],					// sub вест-сайд
	[ -98.685043, -481.715393, -8.921828, "Сауспорт" ] 					// sub Сауспорт вход справа
]; 

_weapons <- [
	[2],		// Model 12 Revolver
	[3],		// Mauser C96
	[4],		// Colt M1911A1
	[5],		// Colt M1911 Special
	[6],		// Model 19 Revolver
	[8],		// Remington Model 870 Field gun
	[9],		// M3 Grease Gun
	[10],		// MP40
	[11],		// Thompson 1928
	[12],		// M1A1 Thompson
	[13],		// Beretta Model 38A
	[15],		// M1 Garand
	[17],		// Kar98k
	[7],		// MK2 Frag Grenade
	[21],		// Molotov Cocktail
	[14],		// MG42 Buggy
];