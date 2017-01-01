include("modules/organizations/hobos/commands.nut");

translation("en", {
    "organizations.hobos.trash.toofar"  : "You are too far from any trash!",
    "organizations.hobos.tired"         : "You got tired. Take a nap.",
    "organizations.hobos.trash.found"   : "You found $%.2f. Now you can buy yourself cookies with $%s."
    "organizations.unemployed.income"   : "You've recieved $%.2f as unemployment compensation."
});

const hobos_spawnID = 1;
const DIG_RADIUS = 1.5;
const HOBO_MODEL = 153;
const DIG_TIME_DELAY = 150; // ~ 5 minutes in game or 2.5 minutes
const UNEMPLOYED_MONEY_INCOME = 3.0; // randomf(X - 1, X + 2.5)

local hobosSkins = [
    87, 153, 154
];

const maxCouldFind = 0.15;
const minCouldFind = 0.03;

local hoboses = {};

hobos_points <- [
    [-5.23929, 1636.06,  -20.0261], //0
    [-64.5537, 1632.1,   -20.8239], //1
    [-63.5895, 1636.18,   -20.786], //2
    [-139.316, 1600.6,   -23.4732], //3
    [-155.958, 1656.25,  -20.1336], //4
    [-144.238, 1706.73,  -18.8845], //5
    [-232.55, 1723.99,    -22.835], //6
    [-267.238, 1713.69,  -22.3303], //7
    [-379.075, 1610.94,  -23.5621], //8
    [-488.782, 1589.42,  -23.7144], //9
    [-494.615, 1611.79,   -23.822], //10
    [-502.976, 1603.23,  -23.6832], //11
    [-499.01, 1631.17,   -23.8832], //12
    [-500.003, 1640.04,  -23.8807], //13
    [-781.458, 1424.24,  -7.11043], //14
    [-847.382, 1417.18,  -9.10485], //15
    [-954.159, 1509.52,  -4.76123], //16
    [-1367.64, 1670.03,   10.4289], //17
    [-1310.25, 1705.88,   10.5392], //18
    [-1170.91, 1653.91,   10.9497], //19
    [-1162.7, 1588.45,    6.14638], //20
    [-1161.21, 1526.97,     6.541], //21
    [-1062.16, 1613.85,   5.36248], //22
    [-997.204, 1698.84,   9.68199], //23
    [-1077.64, 1672.04,   10.6457], //24
    [-1488.83, 1705.72,   2.70115], //25
    [627.56, 1332.33,     74.1859], //26
    [-1431.3, 1436.07,   -13.2827], //27
    [-1244.71, 1425.49,  -13.5724], //28
    [-930.151, 1425.23,  -12.0779], //29
    [-1456.79, 1373.17,  -13.5724], //30
    [-1290.43, 1128.37,  -21.7018], //31
    [-1398.63, 448.546,  -22.2588], //32
    [-1714.8, 91.4707,    -5.9803], //33
    [-1530.82, -80.8658, -18.5166], //34
    [-1646.19, -250.919, -20.3176], //35
    [-1569.39, -250.682, -20.3327], //36
    [-1564.16, -250.961, -20.3338], //37
    [-1560.18, -250.051, -20.3346], //38
    [-1472.12, -226.167, -20.3355], //39
    [-406.699, -615.687, -20.3037], //40
    [-398.631, -615.106, -20.3037], //41
    [-378.821, -677.372,  -21.581], //42
    [-377.513, -671.195,  -21.466], //43
    [-306.309, -668.644, -21.6677], //44
    [-272.064, -674.978, -21.6955], //45
    [-277.712, -674.334, -21.6927], //46
    [-5.34258, -683.939, -21.7457], //47
    [-1.64423, -690.768, -21.7457], //48
    [22.0747, -688.483,  -21.7457], //49
    [-8.44736, -750.834, -21.7456], //50
    [7.13744, -760.636,  -21.7456], //51
    [35.3133, -760.926,  -21.7456], //52
    [46.4487, -761.397,  -21.7456], //53
    [59.9265, -733.909,  -21.7456], //54
    [157.421, -776.329,  -21.7456], //55
    [171.055, -753.382,  -21.7853], //56
    [113.283, -779.338,  -21.7937], //57
    [114.858, -736.298,  -21.7456], //58
    [140.548, -744.422,  -21.7456], //59
    [118.105, -693.057,  -21.7456], //60
    [143.59, -690.419,   -21.7456], //61
    [-93.1251, -556.321, -18.6479], //62
    [389.09, -270.773,   -20.0698], //63
    [494.217, -220.6,    -20.1642], //64
    [660.272, -299.54,   -20.1636], //65
    [681.353, 1337.01,    73.5351], //66
    [516.07, -20.2688,   -18.3459], //67
    [594.428, 36.9467,   -18.2496], //68
    [612.155, 36.7275,   -18.2711], //69
    [216.255, 460.16,    -20.2791], //70
    [178.47, 249.048,    -20.1004], //71
    [175.745, 647.678,   -22.1402], //72
    [108.095, 593.867,   -20.0352], //73
    [76.3242, 576.273,   -19.7368], //74
    [0.116291, 485.945,  -19.8444], //75
    [-143.88, 500.504,   -20.2487], //76
    [-184.539, 555.91,   -20.2988], //77
    [-123.426, 833.682,  -21.7064], //78
    [-120.272, 860.465,  -21.4553], //79
    [-26.8927, 853.944,  -24.3635], //80
    [47.5316, 957.145,   -19.7858], //81
    [-275.631, 707.233,   -20.053], //82
    [-508.747, 768.151,  -18.8415], //83
    [-557.539, 770.759,  -18.8415], //84
    [-608.171, 772.21,   -18.9186], //85
    [-639.162, 771.409,  -18.8415], //86
    [-690.286, 765.601,  -18.8415], //87
    [-463.121, 722.671,  -20.0238], //88
    [-41.0699, 68.4161,  -14.3253], //89
    [-692.851, 290.153, -0.090662], //90
    [-39.9175, -28.4576, -14.4931], //91
    [-685.006, 482.542,   1.03802], //92
    [-1282.18, 1612.62,   4.03744], //93
    [-1055.32, 1738.21,   10.2671], //94
    [-173.792, 863.807,   -20.979], //95
    [-198.242, 868.185,  -20.9749], //96
    [39.5701,  1201.61,   67.1089], //97
    [-1132.18, 1288.17,  -21.7018], //98
    [-1164.57, 1215.55,  -21.7018], //99
    [827.166, -144.277,  -20.3568], //100
    [-231.881, -676.135, -14.5929], //101
];


// addEventHandlerEx("onPlayerConnect", function(playerid, name, ip, serial) {
//     if ( isHobos(playerid) ) {
//         // players[playerid]["skin"] <- hobosSkins[random(0, hobosSkins.len() - 1)];
//         hoboses[playerid] <- {};
//     }
// });


event("onServerStarted", function() {
    log("[hobos] loading trash containers...");
    //creating public 3dtext
    foreach (trashContainer in hobos_points) {
        create3DText ( trashContainer[0], trashContainer[1], trashContainer[2]+0.35, "Press E or use /dig to find something in that", CL_EUCALYPTUS, DIG_RADIUS );
    }
});

event("onServerHourChange", function() {
    local originalAmount = randomf(UNEMPLOYED_MONEY_INCOME - 1.0, UNEMPLOYED_MONEY_INCOME + 2.5);

    foreach (playerid, value in players) {
        if (!getPlayerJob(playerid)) {
            local amount = originalAmount;

            // give only 10% of current amount for afk
            if (isPlayerAfk(playerid)) {
                amount = originalAmount * 0.1;
            }

            addMoneyToPlayer(playerid, amount);
            msg(playerid, "organizations.unemployed.income", [amount], CL_SUCCESS);
        }
    }
});
