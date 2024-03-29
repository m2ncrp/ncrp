
local nodes = {};
local nodesTimestamps = {};

event("onServerStarted", function() {
    snowplowNodesLoadedData();
});

// event(["onServerAutosaveEarly", "onServerStopping"], function() {
//     foreach (idx, nodeTimestamp in nodesTimestamps) {
//         nodeTimestamp.save();
//     }
// });

function snowplowNodesLoadedData() {
    local ts = getTimestamp();
    SnowplowNode.findAll(function(err, results) {
        if(results.len()) {
            nodesTimestamps = results
        } else {
            for (local i = 0; i <= 50; i++) {
                local node = SnowplowNode();

                if(i == 504) continue;

                node.timestamp = ts;
                node.save();
            }

            snowplowNodesLoadedData();
        };
    });
}

function snowplowv3(a, b, c, isTunnel = false) {
    return { coords = { x = a.tofloat(), y = b.tofloat(), z = c.tofloat() }, isTunnel = isTunnel };
}

function getSnowplowNodesTimestamps() {
  return nodesTimestamps;
}

function getSnowplowNodeTimestamp(id) {
    foreach (idx, value in nodesTimestamps) {
        if(value.id == id) return value;
    }

    return false;
}

nodes[0] <-   snowplowv3( -380.799,  593.685,   -9.966);
nodes[1] <-   snowplowv3( -417.715,  587.210,  -9.966 );  // первая точка налево вверх (не к мосту)
nodes[2] <-   snowplowv3( -470.229,  587.062,  -7.843 );  // вторая точка налево вверх (не к мосту)
nodes[3] <-   snowplowv3( -523.579,  586.835,  -5.166 );
nodes[4] <-   snowplowv3( -575.882,  586.884,  -2.396 );
nodes[5] <-   snowplowv3( -649.879,  587.195,  1.201 );
nodes[6] <-   snowplowv3( -673.944,  565.359,  1.190 );
nodes[7] <-   snowplowv3( -674.191,  525.957,  1.198 );
nodes[8] <-   snowplowv3( -674.372,  467.027,  1.200 );
nodes[9] <-   snowplowv3( -653.736,  445.228,  1.194 );
nodes[10] <-   snowplowv3( -604.320,  445.083,  1.200 );
nodes[11] <-   snowplowv3( -566.473,  445.225,  1.203 );
nodes[12] <-   snowplowv3( -483.208,  425.666,  1.130 );
nodes[13] <-   snowplowv3( -467.987,  395.075,  1.199 );
nodes[14] <-   snowplowv3( -468.046,  354.380,  1.200 );
nodes[15] <-   snowplowv3( -463.646,  319.628,  1.206 );
nodes[16] <-   snowplowv3( -463.928,  291.804,  1.201 );
nodes[17] <-   snowplowv3( -435.164,  269.656,  1.279 );
nodes[18] <-   snowplowv3( -391.031,  268.169,  1.879 );
nodes[19] <-   snowplowv3( -336.967,  267.348,  2.225 );
nodes[20] <-   snowplowv3( -292.101,  267.806,  2.255 );
nodes[21] <-   snowplowv3( -227.516,  286.845,  -6.001 );
nodes[22] <-   snowplowv3( -215.476,  273.079,  -6.244 );
nodes[23] <-   snowplowv3( -215.704,  212.836,  -8.792 );
nodes[24] <-   snowplowv3( -215.554,  145.309,  -10.395 );
nodes[25] <-   snowplowv3( -215.499,  70.519,  -11.108 );
nodes[26] <-   snowplowv3( -209.033,  -4.605,  -11.822 );
nodes[27] <-   snowplowv3( -225.178,  -21.337,  -11.728 );
nodes[28] <-   snowplowv3( -275.607,  -21.182,  -9.527 );
nodes[29] <-   snowplowv3( -344.584,  -21.453,  -5.208 );
nodes[30] <-   snowplowv3( -367.005,  -43.651,  -5.566 );
nodes[31] <-   snowplowv3( -367.135,  -90.450,  -9.585 );
nodes[32] <-   snowplowv3( -345.733,  -113.779,  -10.163 );
nodes[33] <-   snowplowv3( -298.513,  -113.907,  -10.778 );
nodes[34] <-   snowplowv3( -219.655,  -113.869,  -11.803 );
nodes[35] <-   snowplowv3( -196.987,  -91.494,  -11.872 );
nodes[36] <-   snowplowv3( -194.103,  -42.543,  -11.874 );
nodes[37] <-   snowplowv3( -175.427,  -22.316,  -11.875 );
nodes[38] <-   snowplowv3( -128.438,  -22.519,  -12.431 );
nodes[39] <-   snowplowv3( -71.271,  -22.590,  -14.261 );
nodes[40] <-   snowplowv3( -57.253,  -38.865,  -14.286 );
nodes[41] <-   snowplowv3( -57.150,  -92.070,  -14.279 );
nodes[42] <-   snowplowv3( -57.881,  -131.854,  -14.273 );
nodes[43] <-   snowplowv3( -60.700,  -164.161,  -14.276 );
nodes[44] <-   snowplowv3( -60.585,  -196.946,  -14.276 );
nodes[45] <-   snowplowv3( -78.162,  -212.449,  -14.103 );
nodes[46] <-   snowplowv3( -121.652,  -212.332,  -13.115 );
nodes[47] <-   snowplowv3( -181.825,  -212.276,  -11.921 );
nodes[48] <-   snowplowv3( -201.982,  -232.748,  -12.158 );
nodes[49] <-   snowplowv3( -218.264,  -293.618,  -15.742 );
nodes[50] <-   snowplowv3( -273.220,  -293.195,  -14.419 );
nodes[51] <-   snowplowv3( -346.228,  -293.412,  -12.663 );
nodes[52] <-   snowplowv3( -359.455,  -277.726,  -12.349 );
nodes[53] <-   snowplowv3( -362.453,  -232.831,  -10.278 );
nodes[54] <-   snowplowv3( -381.241,  -211.858,  -10.057 );
nodes[55] <-   snowplowv3( -421.273,  -211.700,  -8.444 );
nodes[56] <-   snowplowv3( -465.363,  -208.964,  -6.648 );
nodes[57] <-   snowplowv3( -515.447,  -208.942,  -4.626 );
nodes[58] <-   snowplowv3( -529.616,  -196.880,  -4.406 );
nodes[59] <-   snowplowv3( -541.203,  -157.930,  -1.840 );
nodes[60] <-   snowplowv3( -547.692,  -125.759,  0.050 );
nodes[61] <-   snowplowv3( -547.180,  -87.667,  0.828 );
nodes[62] <-   snowplowv3( -567.413,  -67.492,  1.202 );
nodes[63] <-   snowplowv3( -614.935,  -67.108,  1.203 );
nodes[64] <-   snowplowv3( -655.166,  -67.121,  1.194 );
nodes[65] <-   snowplowv3( -670.185,  -50.157,  1.196 );
nodes[66] <-   snowplowv3( -670.162,  -1.630,  1.198 );
nodes[67] <-   snowplowv3( -669.954,  54.183,  1.200 );
nodes[68] <-   snowplowv3( -669.963,  110.485,  1.201 );
nodes[69] <-   snowplowv3( -670.152,  163.118,  1.202 );
nodes[70] <-   snowplowv3( -670.081,  254.499,  0.055 );
nodes[71] <-   snowplowv3( -655.069,  271.083,  -0.064 );
nodes[72] <-   snowplowv3( -607.492,  270.960,  -0.103 );
nodes[73] <-   snowplowv3( -565.221,  270.723,  -0.145 );
nodes[74] <-   snowplowv3( -549.691,  255.168,  -0.020 );
nodes[75] <-   snowplowv3( -549.504,  218.866,  0.788 );
nodes[76] <-   snowplowv3( -549.627,  187.741,  1.485 );
nodes[77] <-   snowplowv3( -549.615,  151.127,  1.099 );
nodes[78] <-   snowplowv3( -549.542,  96.732,  -0.379 );
nodes[79] <-   snowplowv3( -535.960,  77.786,  -0.575 );
nodes[80] <-   snowplowv3( -484.133,  76.857,  -0.944 );
nodes[81] <-   snowplowv3( -454.905,  94.572,  -0.881 );
nodes[82] <-   snowplowv3( -450.243,  189.349,  1.201 );
nodes[83] <-   snowplowv3( -450.191,  251.104,  1.203 );
nodes[84] <-   snowplowv3( -450.214,  295.023,  1.202 );
nodes[85] <-   snowplowv3( -454.941,  351.221,  1.201 );
nodes[86] <-   snowplowv3( -483.686,  373.149,  1.202 );
nodes[87] <-   snowplowv3( -534.336,  372.975,  1.204 );
nodes[88] <-   snowplowv3( -549.329,  353.008,  1.079 );
nodes[89] <-   snowplowv3( -549.509,  291.924,  -0.017 );
nodes[90] <-   snowplowv3( -533.479,  270.826,  0.020 );
nodes[91] <-   snowplowv3( -484.149,  270.626,  1.060 );
nodes[92] <-   snowplowv3( -455.008,  289.924,  1.200 );
nodes[93] <-   snowplowv3( -450.290,  338.848,  1.201 );
nodes[94] <-   snowplowv3( -450.515,  389.914,  1.200 );
nodes[95] <-   snowplowv3( -452.410,  441.507,  1.202 );
nodes[96] <-   snowplowv3( -461.629,  498.527,  1.203 );
nodes[97] <-   snowplowv3( -473.857,  540.121,  1.198 );  // сразу после автобусов
nodes[98] <-   snowplowv3( -482.704,  595.720,  1.201 ); // перед поворотом направо
nodes[99] <-   snowplowv3( -463.792,  613.145,  0.481 ); // после поворота направо
nodes[100] <-  snowplowv3( -410.722,  613.360,  -9.773 ); // в самом низу спуска перед финишем
nodes[101] <-  snowplowv3( -391.231,  600.650,  -10.105 ); // выезд из депо
nodes[102] <-  snowplowv3( -409.713,  618.913,  -9.862 );  // подъём вверх сразу после поворота налево
nodes[103] <-  snowplowv3( -465.000,  626.097,  0.634 );   // на горе при повороте направо в сторону дороги на сауспорт
nodes[104] <-  snowplowv3( -482.750,  647.098,  1.243 );
nodes[105] <-  snowplowv3( -527.588,  695.417,  2.578 );
nodes[106] <-  snowplowv3( -538.375,  707.673,  2.782 );
nodes[107] <-  snowplowv3( -573.311,  733.975,  -0.993 );
nodes[108] <-  snowplowv3( -639.793,  733.968,  -10.075 );
nodes[109] <-  snowplowv3( -684.669,  734.041,  -12.589 );
nodes[110] <-  snowplowv3( -728.069,  734.068,  -16.880 ); // до поворота на М-отель
nodes[111] <-  snowplowv3( -744.957,  713.429,  -17.131 );
nodes[112] <-  snowplowv3( -745.092,  669.362,  -17.661 );
nodes[113] <-  snowplowv3( -740.005,  610.043,  -19.041 );
nodes[114] <-  snowplowv3( -739.338,  527.208,  -20.103 );
nodes[115] <-  snowplowv3( -739.362,  450.697,  -20.105 );
nodes[116] <-  snowplowv3( -739.516,  384.249,  -20.101 );
nodes[117] <-  snowplowv3( -739.429,  305.521,  -20.101 );
nodes[118] <-  snowplowv3( -739.457,  219.941,  -20.101 );
nodes[119] <-  snowplowv3( -739.379,  149.694,  -20.101 );
nodes[120] <-  snowplowv3( -739.644,  76.143,  -20.100 );
nodes[121] <-  snowplowv3( -739.422,  7.261,  -20.101 );
nodes[122] <-  snowplowv3( -739.502,  -71.991,  -20.101 );
nodes[123] <-  snowplowv3( -739.493,  -144.384,  -20.101 );
nodes[124] <-  snowplowv3( -739.658,  -217.215,  -20.100 );
nodes[125] <-  snowplowv3( -745.101,  -296.930,  -20.093 );
nodes[126] <-  snowplowv3( -755.195,  -361.758,  -20.078 );
nodes[127] <-  snowplowv3( -755.765,  -449.953,  -22.601 );
nodes[128] <-  snowplowv3( -742.268,  -469.797,  -22.721 );
nodes[129] <-  snowplowv3( -701.425,  -469.961,  -22.098 );
nodes[130] <-  snowplowv3( -635.889,  -469.877,  -20.018 );
nodes[131] <-  snowplowv3( -586.118,  -469.995,  -20.016 );
nodes[132] <-  snowplowv3( -543.482,  -469.800,  -19.988 );
nodes[133] <-  snowplowv3( -495.921,  -472.794,  -19.993 );
nodes[134] <-  snowplowv3( -421.049,  -472.705,  -18.071 );
nodes[135] <-  snowplowv3( -407.382,  -486.329,  -17.960 );
nodes[136] <-  snowplowv3( -407.348,  -533.812,  -18.904 );
nodes[137] <-  snowplowv3( -404.656,  -583.688,  -19.890 );
nodes[138] <-  snowplowv3( -386.590,  -606.859,  -20.000 );
nodes[139] <-  snowplowv3( -326.051,  -606.880,  -20.000 );
nodes[140] <-  snowplowv3( -253.994,  -606.861,  -20.000 );
nodes[141] <-  snowplowv3( -188.598,  -607.019,  -20.000 );
nodes[142] <-  snowplowv3( -121.891,  -607.258,  -20.001 );
nodes[143] <-  snowplowv3( -104.432,  -590.581,  -19.910 );
nodes[144] <-  snowplowv3( -104.517,  -542.616,  -17.886 );
nodes[145] <-  snowplowv3( -104.330,  -482.837,  -14.932 );
nodes[146] <-  snowplowv3(-86.992, -469.31, -14.998)
nodes[147] <-  snowplowv3(-31.31, -469.802, -16.514)
nodes[148] <-  snowplowv3(41.642, -469.937, -19.649)
nodes[149] <-  snowplowv3(84.744, -469.882, -20.786)
nodes[150] <-  snowplowv3(143.643, -469.987, -20.262)
nodes[151] <-  snowplowv3(159.303, -453.109, -19.992)
nodes[152] <-  snowplowv3(159.74, -412.181, -19.989)
nodes[153] <-  snowplowv3(167.951, -399.834, -19.997)
nodes[154] <-  snowplowv3(208.336, -399.602, -19.86)
nodes[155] <-  snowplowv3(275.66, -399.586, -19.999)
nodes[156] <-  snowplowv3(305.017, -391.866, -19.998)
nodes[157] <-  snowplowv3(380.808, -392.481, -19.998)
nodes[158] <-  snowplowv3(451.649, -392.429, -19.999)
nodes[159] <-  snowplowv3(551.088, -392.042, -20.002)
nodes[160] <-  snowplowv3(568.341, -378.958, -20)
nodes[161] <-  snowplowv3(568.556, -339.594, -19.996)
nodes[162] <-  snowplowv3(568.623, -298.68, -19.998)
nodes[163] <-  snowplowv3(568.342, -266.279, -19.999)
nodes[164] <-  snowplowv3(568.384, -221.235, -19.999)
nodes[165] <-  snowplowv3(568.294, -171.249, -19.999)
nodes[166] <-  snowplowv3(551.507, -152.397, -19.99)
nodes[167] <-  snowplowv3(502.696, -151.725, -19.148)
nodes[168] <-  snowplowv3(453.581, -151.609, -12.941)
nodes[169] <-  snowplowv3(413.471, -151.647, -6.694)
nodes[170] <-  snowplowv3(400.858, -135.562, -6.582)
nodes[171] <-  snowplowv3(383.322, -118.475, -6.476)
nodes[172] <-  snowplowv3(358.891, -118.254, -6.564)
nodes[173] <-  snowplowv3(340.915, -133.898, -6.559)
nodes[174] <-  snowplowv3(340.772, -160.967, -6.339)
nodes[175] <-  snowplowv3(265.533, -142.703, -12.034)
nodes[176] <-  snowplowv3(247.323, -125.577, -12.285)
nodes[177] <-  snowplowv3(201.412, -125.231, -19.677)
nodes[178] <-  snowplowv3(187.427, -112.161, -19.992)
nodes[179] <-  snowplowv3(187.896, -56.85, -20)
nodes[180] <-  snowplowv3(187.649, 6.861, -19.999)
nodes[181] <-  snowplowv3(187.483, 37.667, -20.025)
nodes[182] <-  snowplowv3(187.458, 76.64, -19.992)
nodes[183] <-  snowplowv3(210.097, 109.774, -19.126)
nodes[184] <-  snowplowv3(253.983, 125.05, -20.676)
nodes[185] <-  snowplowv3(270.544, 158.292, -21.483)
nodes[186] <-  snowplowv3(270.852, 200.811, -23.148)
nodes[187] <-  snowplowv3(284.121, 216.631, -23.348)
nodes[188] <-  snowplowv3(343.037, 216.212, -21.725)
nodes[189] <-  snowplowv3(383.389, 216.228, -20.959)
nodes[190] <-  snowplowv3(433.428, 216.256, -20.046)
nodes[191] <-  snowplowv3(450.154, 235.548, -19.975)
nodes[192] <-  snowplowv3(450.321, 292.863, -19.942)
nodes[193] <-  snowplowv3(450.309, 352.016, -19.998)
nodes[194] <-  snowplowv3(450.24, 430.653, -22.945)
nodes[195] <-  snowplowv3(433.314, 448.301, -23.35)
nodes[196] <-  snowplowv3(377.877, 448.382, -21.303)
nodes[197] <-  snowplowv3(330.049, 448.668, -20.822)
nodes[198] <-  snowplowv3(282.777, 448.361, -20.058)
nodes[199] <-  snowplowv3(265.902, 430.292, -20.177)
nodes[200] <-  snowplowv3(266.192, 370.053, -21.391)
nodes[201] <-  snowplowv3(266.363, 323.021, -21.407)
nodes[202] <-  snowplowv3(266.353, 284.062, -21.431)
nodes[203] <-  snowplowv3(251.794, 270.423, -21.351)
nodes[204] <-  snowplowv3(219.744, 270.474, -20.059)
nodes[205] <-  snowplowv3(192.717, 244.767, -19.964)
nodes[206] <-  snowplowv3(176.862, 224.406, -19.875)
nodes[207] <-  snowplowv3(142.685, 224.376, -19.858)
nodes[208] <-  snowplowv3(133.092, 236.753, -20.765)
nodes[209] <-  snowplowv3(133.287, 284.276, -20.98)
nodes[210] <-  snowplowv3(133.219, 351.176, -21.064)
nodes[211] <-  snowplowv3(112.803, 376.808, -20.331)
nodes[212] <-  snowplowv3(65.594, 383.232, -14.469)
nodes[213] <-  snowplowv3(50.484, 382.959, -13.796)
nodes[214] <-  snowplowv3(43.028, 348.302, -13.868)
nodes[215] <-  snowplowv3(43.087, 316.422, -14.419)
nodes[216] <-  snowplowv3(40.325, 270.668, -15.212)
nodes[217] <-  snowplowv3(40.387, 236.079, -15.802)
nodes[218] <-  snowplowv3(28.924, 224.336, -15.842)
nodes[219] <-  snowplowv3(-8.198, 224.436, -15.334)
nodes[220] <-  snowplowv3(-63.714, 224.567, -14.569)
nodes[221] <-  snowplowv3(-117.411, 224.552, -13.834)
nodes[222] <-  snowplowv3(-127.964, 234.546, -13.77)
nodes[223] <-  snowplowv3(-130.925, 273.257, -12.039)
nodes[224] <-  snowplowv3(-152.389, 290.231, -11.696)
nodes[225] <-  snowplowv3(-192.201, 294.305, -6.363)
nodes[226] <-  snowplowv3(-201.709, 304.967, -6.288)
nodes[227] <-  snowplowv3(-201.498, 358.276, -6.198)
nodes[228] <-  snowplowv3(-201.736, 399.754, -6.124)
nodes[229] <-  snowplowv3(-225.717, 429.088, -6.132)
nodes[230] <-  snowplowv3(-270.485, 429.506, -6.174)
nodes[231] <-  snowplowv3(-318.787, 429.385, -4.18)
nodes[232] <-  snowplowv3(-369.648, 429.615, -1.295)
nodes[233] <-  snowplowv3(-383.661, 443.503, -1.054)
nodes[234] <-  snowplowv3(-384.124, 499.362, -1.054)
nodes[235] <-  snowplowv3(-400.909, 518.184, -0.887)
nodes[236] <-  snowplowv3(-453.875, 518.362, 1.166)
nodes[237] <-  snowplowv3(-391.234, 635.645, -10.714)
nodes[238] <-  snowplowv3(-391.146, 672.151, -12.91)
nodes[239] <-  snowplowv3(-391.225, 720.035, -15.742)
nodes[240] <-  snowplowv3(-391.102, 785.083, -19.628)
nodes[241] <-  snowplowv3(-377.599, 800.645, -19.981)
nodes[242] <-  snowplowv3(-329.238, 800.831, -19.985)
nodes[243] <-  snowplowv3(-281.142, 800.831, -19.991)
nodes[244] <-  snowplowv3(-242.478, 800.831, -19.991)
nodes[245] <-  snowplowv3(-185.855, 801.293, -20.553)
nodes[246] <-  snowplowv3(-168.038, 785.042, -20.658)
nodes[247] <-  snowplowv3(-167.964, 747.656, -20.465)
nodes[248] <-  snowplowv3(-167.869, 706.518, -20.244)
nodes[249] <-  snowplowv3(-150.436, 688.12, -20.209)
nodes[250] <-  snowplowv3(-119.599, 702.146, -20.74)
nodes[251] <-  snowplowv3(-86.201, 716.297, -21.361)
nodes[252] <-  snowplowv3(-53.743, 716.332, -21.8)
nodes[253] <-  snowplowv3(-38.756, 704.837, -21.822)
nodes[254] <-  snowplowv3(-39.062, 682.238, -21.415)
nodes[255] <-  snowplowv3(-39.319, 656.978, -19.963)
nodes[256] <-  snowplowv3(-57.393, 641.253, -19.984)
nodes[257] <-  snowplowv3(-98.782, 641.56, -19.858)
nodes[258] <-  snowplowv3(-148.029, 641.427, -19.973)
nodes[259] <-  snowplowv3(-168.239, 620.26, -20.014)
nodes[260] <-  snowplowv3(-167.871, 584.719, -20.133)
nodes[261] <-  snowplowv3(-125.701, 541.703, -20.082)
nodes[262] <-  snowplowv3(-65.874, 541.594, -19.656)
nodes[263] <-  snowplowv3(-14.812, 541.715, -19.284)
nodes[264] <-  snowplowv3(25.217, 542.035, -18.994)
nodes[265] <-  snowplowv3(49.06, 556.728, -19.007)
nodes[266] <-  snowplowv3(52.581, 588.643, -19.8)
nodes[267] <-  snowplowv3(52.544, 620.492, -19.965)
nodes[268] <-  snowplowv3(65.132, 633.384, -19.917)
nodes[269] <-  snowplowv3(106.874, 658.057, -19.238)
nodes[270] <-  snowplowv3(121.982, 658.595, -18.394)
nodes[271] <-  snowplowv3(147.998, 660.564, -19.332)
nodes[272] <-  snowplowv3(182.094, 689.054, -21.867)
nodes[273] <-  snowplowv3(248.351, 688.942, -24.263)
nodes[274] <-  snowplowv3(284.392, 688.916, -24.657)
nodes[275] <-  snowplowv3(317.272, 688.939, -24.716)
nodes[276] <-  snowplowv3(353.432, 688.89, -24.732)
nodes[277] <-  snowplowv3(380.768, 688.541, -24.727)
nodes[278] <-  snowplowv3(397.418, 673.108, -24.728)
nodes[279] <-  snowplowv3(397.44, 636.774, -24.732)
nodes[280] <-  snowplowv3(385.479, 624.8, -24.722)
nodes[281] <-  snowplowv3(353.139, 624.977, -24.567)
nodes[282] <-  snowplowv3(318.336, 624.988, -24.522)
nodes[283] <-  snowplowv3(284.212, 625.073, -24.419)
nodes[284] <-  snowplowv3(265.91, 606.649, -24.402)
nodes[285] <-  snowplowv3(265.711, 567.51, -24.364)
nodes[286] <-  snowplowv3(265.67, 530.24, -22.978)
nodes[287] <-  snowplowv3(265.613, 462.586, -20.179)
nodes[288] <-  snowplowv3(282.135, 444.669, -20.041)
nodes[289] <-  snowplowv3(341.816, 444.687, -21.014)
nodes[290] <-  snowplowv3(432.65, 444.594, -23.317)
nodes[291] <-  snowplowv3(446.231, 429.696, -22.983)
nodes[292] <-  snowplowv3(446.167, 391.346, -20.321)
nodes[293] <-  snowplowv3(446.276, 346.151, -19.993)
nodes[294] <-  snowplowv3(446.19, 303.086, -19.982)
nodes[295] <-  snowplowv3(446.12, 236.74, -19.994)
nodes[296] <-  snowplowv3(446.202, 200.794, -19.997)
nodes[297] <-  snowplowv3(446.171, 163.592, -19.93)
nodes[298] <-  snowplowv3(446.254, 124.107, -20.109)
nodes[299] <-  snowplowv3(446.369, 67.552, -22.818)
nodes[300] <-  snowplowv3(435.211, 54.272, -23.042)
nodes[301] <-  snowplowv3(406.711, 54.573, -23.4)
nodes[302] <-  snowplowv3(372.615, 54.727, -23.835)
nodes[303] <-  snowplowv3(358.259, 36.837, -23.969)
nodes[304] <-  snowplowv3(374.418, 19.34, -24.259)
nodes[305] <-  snowplowv3(429.57, 19.213, -24.907)
nodes[306] <-  snowplowv3(442.355, 5.896, -24.926)
nodes[307] <-  snowplowv3(437.571, -33.617, -20.111)
nodes[308] <-  snowplowv3(412.46, -69.237, -12.418)
nodes[309] <-  snowplowv3(397.471, -105.596, -6.712)
nodes[310] <-  snowplowv3(397.175, -134.897, -6.538)
nodes[311] <-  snowplowv3(397.046, -163.776, -6.461)
nodes[312] <-  snowplowv3(384.986, -175.412, -6.454)
nodes[313] <-  snowplowv3(356.202, -175.216, -6.461)
nodes[314] <-  snowplowv3(328.168, -175.282, -6.291)
nodes[315] <-  snowplowv3(277.054, -175.435, -11.978)
nodes[316] <-  snowplowv3(265.78, -164.31, -12.024)
nodes[317] <-  snowplowv3(265.511, -113.704, -12.129)
nodes[318] <-  snowplowv3(265.253, -60.991, -16.591)
nodes[319] <-  snowplowv3(265.678, 6.114, -22.943)
nodes[320] <-  snowplowv3(249.092, 23.58, -22.999)
nodes[321] <-  snowplowv3(200.602, 23.829, -20.179)
nodes[322] <-  snowplowv3(183.768, 7.571, -19.99)
nodes[323] <-  snowplowv3(183.927, -54.709, -20.002)
nodes[324] <-  snowplowv3(183.921, -111.794, -20)
nodes[325] <-  snowplowv3(184.12, -141.579, -20.003)
nodes[326] <-  snowplowv3(200.656, -177.533, -19.999)
nodes[327] <-  snowplowv3(219.656, -228.33, -20.009)
nodes[328] <-  snowplowv3(203.825, -261.547, -19.999)
nodes[329] <-  snowplowv3(175.198, -268.9, -19.998)
nodes[330] <-  snowplowv3(144.003, -268.724, -19.996)
nodes[331] <-  snowplowv3(133.736, -258.919, -19.99)
nodes[332] <-  snowplowv3(133.673, -212.215, -19.953)
nodes[333] <-  snowplowv3(133.802, -169.726, -19.917)
nodes[334] <-  snowplowv3(133.573, -122.833, -19.878)
nodes[335] <-  snowplowv3(133.494, -77.802, -19.861)
nodes[336] <-  snowplowv3(133.529, -28.14, -19.859)
nodes[337] <-  snowplowv3(133.799, 28.083, -19.862)
nodes[338] <-  snowplowv3(114.39, 50.026, -19.294)
nodes[339] <-  snowplowv3(66.006, 54.167, -13.263)
nodes[340] <-  snowplowv3(52.777, 64.01, -12.851)
nodes[341] <-  snowplowv3(52.625, 125.684, -14.07)
nodes[342] <-  snowplowv3(52.58, 202.833, -15.834)
nodes[343] <-  snowplowv3(52.594, 233.314, -15.828)
nodes[344] <-  snowplowv3(52.435, 281.762, -15.017)
nodes[345] <-  snowplowv3(49.789, 321.398, -14.336)
nodes[346] <-  snowplowv3(49.764, 348.372, -13.872)
nodes[347] <-  snowplowv3(30.005, 368.805, -13.821)
nodes[348] <-  snowplowv3(-5.68, 369.281, -13.821)
nodes[349] <-  snowplowv3(-37.021, 369.361, -13.827)
nodes[350] <-  snowplowv3(-72.107, 369.126, -13.823)
nodes[351] <-  snowplowv3(-119.296, 369.268, -13.822)
nodes[352] <-  snowplowv3(-136.657, 353.822, -13.823)
nodes[353] <-  snowplowv3(-136.833, 303.323, -12.062)
nodes[354] <-  snowplowv3(-136.957, 274.812, -12.036)
nodes[355] <-  snowplowv3(-137.029, 232.566, -13.821)
nodes[356] <-  snowplowv3(-118.46, 216.841, -13.834)
nodes[357] <-  snowplowv3(-74.37, 216.754, -14.42)
nodes[358] <-  snowplowv3(-28.649, 214.114, -15.053)
nodes[359] <-  snowplowv3(29.608, 214.187, -15.848)
nodes[360] <-  snowplowv3(40.074, 204.227, -15.852)
nodes[361] <-  snowplowv3(40.228, 127.276, -14.161)
nodes[362] <-  snowplowv3(40.3, 63.137, -12.862)
nodes[363] <-  snowplowv3(25.898, 50.002, -12.914)
nodes[364] <-  snowplowv3(-24.224, 49.957, -13.458)
nodes[365] <-  snowplowv3(-56.593, 22.789, -13.91)
nodes[366] <-  snowplowv3(-57.039, -8.026, -14.284)
nodes[367] <-  snowplowv3(-67.864, -19.128, -14.268)
nodes[368] <-  snowplowv3(-123.517, -19.151, -12.722)
nodes[369] <-  snowplowv3(-183.282, -19.221, -11.877)
nodes[370] <-  snowplowv3(-196.061, -7.354, -11.842)
nodes[371] <-  snowplowv3(-201.603, 61.23, -11.193)
nodes[372] <-  snowplowv3(-205.103, 107.296, -10.762)
nodes[373] <-  snowplowv3(-205.134, 161.515, -10.378)
nodes[374] <-  snowplowv3(-205.308, 262.391, -6.649)
nodes[375] <-  snowplowv3(-205.269, 303.805, -6.285)
nodes[376] <-  snowplowv3(-205.333, 347.188, -6.215)
nodes[377] <-  snowplowv3(-205.608, 396.105, -6.127)
nodes[378] <-  snowplowv3(-223.436, 425.255, -6.118)
nodes[379] <-  snowplowv3(-272.58, 424.88, -6.179)
nodes[380] <-  snowplowv3(-370.468, 425.114, -1.253)
nodes[381] <-  snowplowv3(-508.554, 629.084, 1.414)
nodes[382] <-  snowplowv3(-576.171, 628.978, 5.191)
nodes[383] <-  snowplowv3(-647.106, 633.431, 10.12)
nodes[384] <-  snowplowv3(-720.401, 633.134, 14.353)
nodes[385] <-  snowplowv3(-793.115, 633.143, 17.64)
nodes[386] <-  snowplowv3(-861.903, 633.318, 19.975)
nodes[387] <-  snowplowv3(-930.541, 633.25, 21.568)
nodes[388] <-  snowplowv3(-1002.642, 633.222, 22.349)
nodes[389] <-  snowplowv3(-1071.702, 633.403, 22.328)
nodes[390] <-  snowplowv3(-1150.73, 633.42, 20.985)
nodes[391] <-  snowplowv3(-1223.594, 633.292, 17.67)
nodes[392] <-  snowplowv3(-1349.232, 633.313, 7.443)
nodes[393] <-  snowplowv3(-1447.146, 633.323, -2.259)
nodes[394] <-  snowplowv3(-1588.159, 633.377, -10.06)
nodes[395] <-  snowplowv3(-1602.355, 645.144, -10.051)
nodes[396] <-  snowplowv3(-1602.02, 711.589, -10.047)
nodes[397] <-  snowplowv3(-1602.293, 745.862, -9.897)
nodes[398] <-  snowplowv3(-1602.484, 808.713, -5.06)
nodes[399] <-  snowplowv3(-1606.361, 908.171, -4.846)
nodes[400] <-  snowplowv3(-1614.454, 970.928, -5.488)
nodes[401] <-  snowplowv3(-1624.595, 1020.722, -5.993)
nodes[402] <-  snowplowv3(-1614.915, 1032.969, -6.045)
nodes[403] <-  snowplowv3(-1531.449, 1032.712, -9.211)
nodes[404] <-  snowplowv3(-1417.967, 1032.869, -13.429)
nodes[405] <-  snowplowv3(-1408.075, 1022.382, -13.423)
nodes[406] <-  snowplowv3(-1408.256, 937.701, -13.503)
nodes[407] <-  snowplowv3(-1396.874, 923.836, -13.758)
nodes[408] <-  snowplowv3(-1339.039, 923.627, -18.315)
nodes[409] <-  snowplowv3(-1331.144, 915.46, -18.345)
nodes[410] <-  snowplowv3(-1330.887, 853.535, -18.357)
nodes[411] <-  snowplowv3(-1342.1, 842.876, -18.078)
nodes[412] <-  snowplowv3(-1381.382, 842.858, -12.756)
nodes[413] <-  snowplowv3(-1398.402, 826.574, -12.208)
nodes[414] <-  snowplowv3(-1408.636, 813.175, -11.825)
nodes[415] <-  snowplowv3(-1438.869, 814.974, -10.222)
nodes[416] <-  snowplowv3(-1448.842, 800.687, -10.447)
nodes[417] <-  snowplowv3(-1449.249, 742.544, -12.749)
nodes[418] <-  snowplowv3(-1449.101, 689.049, -15)
nodes[419] <-  snowplowv3(-1434.213, 676.126, -15.173)
nodes[420] <-  snowplowv3(-1331.538, 676.337, -19.519)
nodes[421] <-  snowplowv3(-1310.18, 685.271, -19.186)
nodes[422] <-  snowplowv3(-1324.749, 759.598, -15.325)
nodes[423] <-  snowplowv3(-1383.505, 808.354, -13.103)
nodes[424] <-  snowplowv3(-1393.807, 825.335, -12.291)
nodes[425] <-  snowplowv3(-1381.392, 838.635, -12.76)
nodes[426] <-  snowplowv3(-1342.305, 838.589, -18.046)
nodes[427] <-  snowplowv3(-1326.707, 854.213, -18.363)
nodes[428] <-  snowplowv3(-1326.904, 913.849, -18.357)
nodes[429] <-  snowplowv3(-1326.934, 986.998, -18.357)
nodes[430] <-  snowplowv3(-1326.648, 1049.154, -18.355)
nodes[431] <-  snowplowv3(-1326.747, 1115.58, -18.356)
nodes[432] <-  snowplowv3(-1326.68, 1167.215, -13.466)
nodes[433] <-  snowplowv3(-1336.77, 1177.294, -13.412)
nodes[434] <-  snowplowv3(-1391.893, 1177.37, -13.418)
nodes[435] <-  snowplowv3(-1408.177, 1166.034, -13.425)
nodes[436] <-  snowplowv3(-1408.267, 1141.741, -13.435)
nodes[437] <-  snowplowv3(-1408.406, 1121.319, -13.427)
nodes[438] <-  snowplowv3(-1408.173, 1049.049, -13.429)
nodes[439] <-  snowplowv3(-1418.835, 1036.253, -13.418)
nodes[440] <-  snowplowv3(-1531.093, 1036.099, -9.235)
nodes[441] <-  snowplowv3(-1615.691, 1036.293, -6.086)
nodes[442] <-  snowplowv3(-1637.738, 1019.687, -6.013)
nodes[443] <-  snowplowv3(-1622.515, 938.589, -5.18)
nodes[444] <-  snowplowv3(-1597.352, 923.972, -4.941)
nodes[445] <-  snowplowv3(-1524.787, 924.061, -6.942)
nodes[446] <-  snowplowv3(-1423.781, 923.894, -13.458)
nodes[447] <-  snowplowv3(-1404.797, 938.54, -13.487)
nodes[448] <-  snowplowv3(-1404.684, 988.355, -13.426)
nodes[449] <-  snowplowv3(-1404.677, 1048.009, -13.435)
nodes[450] <-  snowplowv3(-1397.976, 1059.342, -13.31)
nodes[451] <-  snowplowv3(-1389.917, 1052.842, -13.363)
nodes[452] <-  snowplowv3(-1390.027, 1030.673, -13.363)
nodes[453] <-  snowplowv3(-1377.171, 1007.573, -15.29)
nodes[454] <-  snowplowv3(-1369.612, 991.754, -15.363)
nodes[455] <-  snowplowv3(-1358.841, 989.18, -15.47)
nodes[456] <-  snowplowv3(-1344.545, 969.21, -17.31)
nodes[457] <-  snowplowv3(-1343.738, 945.889, -17.32)
nodes[458] <-  snowplowv3(-1349.847, 940.799, -17.043)
nodes[459] <-  snowplowv3(-1384.438, 940.719, -13.787)
nodes[460] <-  snowplowv3(-1390.212, 945.959, -13.368)
nodes[461] <-  snowplowv3(-1390.3, 968.157, -13.364)
nodes[462] <-  snowplowv3(-1376.17, 991.122, -15.339)
nodes[463] <-  snowplowv3(-1369.229, 1005.3, -15.36)
nodes[464] <-  snowplowv3(-1358.993, 1008.042, -15.438)
nodes[465] <-  snowplowv3(-1345.622, 1025.525, -17.282)
nodes[466] <-  snowplowv3(-1348.295, 1033.03, -17.077)
nodes[467] <-  snowplowv3(-1358.072, 1033.468, -16.159)
nodes[468] <-  snowplowv3(-1365.93, 1040.24, -16.111)
nodes[469] <-  snowplowv3(-1372.759, 1033.786, -16.126)
nodes[470] <-  snowplowv3(-1366.26, 1026.476, -16.119)
nodes[471] <-  snowplowv3(-1367.722, 1033.449, -16.121)
nodes[472] <-  snowplowv3(-1387.542, 1033.236, -13.699)
nodes[473] <-  snowplowv3(-1390.396, 1026.542, -13.363)
nodes[474] <-  snowplowv3(-1390.204, 993.618, -13.369)
nodes[475] <-  snowplowv3(-1385.388, 964.48, -14.16)
nodes[476] <-  snowplowv3(-1376.929, 964.54, -15.858)
nodes[477] <-  snowplowv3(-1366.714, 958.616, -16.124)
nodes[478] <-  snowplowv3(-1359.603, 964.202, -16.114)
nodes[479] <-  snowplowv3(-1367.043, 971.215, -16.115)
nodes[480] <-  snowplowv3(-1367.514, 964.388, -16.107)
nodes[481] <-  snowplowv3(-1350.324, 964.651, -16.857)
nodes[482] <-  snowplowv3(-1344.003, 996.874, -17.323)
nodes[483] <-  snowplowv3(-1344.685, 1029.644, -17.32)
nodes[484] <-  snowplowv3(-1343.886, 1054.321, -17.319)
nodes[485] <-  snowplowv3(-1349.136, 1058.671, -17.087)
nodes[486] <-  snowplowv3(-1383.805, 1059.201, -13.478)
nodes[487] <-  snowplowv3(-1405.091, 1067.72, -13.425)
nodes[488] <-  snowplowv3(-1405.076, 1120.023, -13.426)
nodes[489] <-  snowplowv3(-1419.514, 1132.551, -13.419)
nodes[490] <-  snowplowv3(-1495.149, 1132.673, -10.683)
nodes[491] <-  snowplowv3(-1560.233, 1132.795, -8.645)
nodes[492] <-  snowplowv3(-1647.913, 1132.561, -6.98)
nodes[493] <-  snowplowv3(-1662.287, 1142.13, -6.975)
nodes[494] <-  snowplowv3(-1672.917, 1195.316, -5.733)
nodes[495] <-  snowplowv3(-1677.595, 1278.007, -6.339)
nodes[496] <-  snowplowv3(-1683.568, 1365.112, -7.191)
nodes[497] <-  snowplowv3(-1694.13, 1430.845, -7.782)
nodes[498] <-  snowplowv3(-1631.437, 1521.728, -12.015)
nodes[499] <-  snowplowv3(-1561.783, 1556.98, -5.922)
nodes[500] <-  snowplowv3(-1509.006, 1514.941, -9.112)
nodes[501] <-  snowplowv3(-1486.93, 1436.689, -12.713)
nodes[502] <-  snowplowv3(-1420.945, 1387.591, -13.49)
nodes[503] <-  snowplowv3(-1408.755, 1367.675, -13.521)
// nodes[504] <-  snowplowv3(-1408.597, 1291.759, -13.409)
nodes[505] <-  snowplowv3(-1408.355, 1186.324, -13.411)
nodes[506] <-  snowplowv3(-1392.561, 1174.219, -13.404)
nodes[507] <-  snowplowv3(-1337.887, 1174.097, -13.408)
nodes[508] <-  snowplowv3(-1331.66, 1166.068, -13.51)
nodes[509] <-  snowplowv3(-1331.351, 1116.254, -18.354)
nodes[510] <-  snowplowv3(-1331.39, 1050.341, -18.364)
nodes[511] <-  snowplowv3(-1331.516, 986.88, -18.351)
nodes[512] <-  snowplowv3(-1331.347, 933.814, -18.354)
nodes[513] <-  snowplowv3(-1339.239, 928.07, -18.301)
nodes[514] <-  snowplowv3(-1394.836, 928.066, -13.935)
nodes[515] <-  snowplowv3(-1423.59, 927.912, -13.438)
nodes[516] <-  snowplowv3(-1511.473, 927.819, -7.794)
nodes[517] <-  snowplowv3(-1596.995, 927.769, -4.933)
nodes[518] <-  snowplowv3(-1619.432, 910.581, -4.894)
nodes[519] <-  snowplowv3(-1615.103, 823.785, -4.211)
nodes[520] <-  snowplowv3(-1615.12, 745.842, -9.889)
nodes[521] <-  snowplowv3(-1615.06, 649.308, -10.047)
nodes[522] <-  snowplowv3(-1615.031, 620.966, -10.043)
nodes[523] <-  snowplowv3(-1588.813, 610.263, -10.046)
nodes[524] <-  snowplowv3(-1527.642, 610.304, -8.231)
nodes[525] <-  snowplowv3(-1462.368, 610.262, -3.712)
nodes[526] <-  snowplowv3(-1392.179, 610.299, 3.298)
nodes[527] <-  snowplowv3(-1322.505, 610.193, 9.845)
nodes[528] <-  snowplowv3(-1251.756, 610.52, 15.654)
nodes[529] <-  snowplowv3(-1182.731, 610.116, 19.888)
nodes[530] <-  snowplowv3(-1114.985, 610.404, 21.83)
nodes[531] <-  snowplowv3(-1042.932, 610.388, 22.435)
nodes[532] <-  snowplowv3(-974.013, 610.101, 22.154)
nodes[533] <-  snowplowv3(-906.72, 610.035, 21.08)
nodes[534] <-  snowplowv3(-833.574, 610.246, 19.109)
nodes[535] <-  snowplowv3(-764.161, 610.182, 16.454)
nodes[536] <-  snowplowv3(-696.112, 610.297, 13.027)
nodes[537] <-  snowplowv3(-625.681, 610.347, 8.717)
nodes[538] <-  snowplowv3(-558.082, 610.293, 3.827)
nodes[539] <-  snowplowv3(-511.563, 610.226, 1.517)
nodes[540] <-  snowplowv3(-378.818, 614.172, -10.261)    // спуск вниз направо 1
nodes[541] <-  snowplowv3(-320.779, 640.056, -16.782)    // спуск вниз направо 2
nodes[542] <-  snowplowv3(-283.347, 686.835, -19.93)     // спуск вниз направо 3
nodes[543] <-  snowplowv3(-243.208, 689.001, -19.984)    // спуск вниз направо 4 у арки
nodes[544] <-  snowplowv3(-230.135, 700.445, -19.995)    // после арки налево 1
nodes[545] <-  snowplowv3(-229.847, 785.937, -19.992)    // после арки налево 2
nodes[546] <-  snowplowv3(-242.572, 804.227, -19.981)
nodes[547] <-  snowplowv3(-304.638, 804.227, -19.988)
nodes[548] <-  snowplowv3(-390.836, 816.655, -19.956)
nodes[549] <-  snowplowv3(-390.675, 879.278, -19.841)
nodes[550] <-  snowplowv3(-391.329, 898.241, -19.837)
nodes[551] <-  snowplowv3(-396.152, 878.983, -19.834)
nodes[552] <-  snowplowv3(-395.836, 816.886, -19.957)
nodes[553] <-  snowplowv3(-407.962, 804.454, -19.95)
nodes[554] <-  snowplowv3(-464.473, 804.836, -19.599)
nodes[555] <-  snowplowv3(-496.763, 831.61, -19.342)
nodes[556] <-  snowplowv3(-497.075, 907.692, -18.922)
nodes[557] <-  snowplowv3(-488.827, 922.764, -18.8)
nodes[558] <-  snowplowv3(-397.951, 981.665, -6.436)
nodes[559] <-  snowplowv3(-288.791, 1003.502, 5.357)
nodes[560] <-  snowplowv3(-362.239, 1030.026, 13.807)
nodes[561] <-  snowplowv3(-446.313, 1025.439, 20.98)
nodes[562] <-  snowplowv3(-515.182, 1053.704, 28.812)
nodes[563] <-  snowplowv3(-518.678, 1135.102, 32.141)
nodes[564] <-  snowplowv3(-533.134, 1151.863, 32.186)
nodes[565] <-  snowplowv3(-599.848, 1157.503, 30.635)
nodes[566] <-  snowplowv3(-661.317, 1220.98, 22.911)
nodes[567] <-  snowplowv3(-601.409, 1262.281, 20.167)
nodes[568] <-  snowplowv3(-505.842, 1310.361, 25.328)
nodes[569] <-  snowplowv3(-493.383, 1317.017, 26.601)
nodes[570] <-  snowplowv3(-458.481, 1334.654, 30.864)
nodes[571] <-  snowplowv3(-379.919, 1362.23, 39.531)
nodes[572] <-  snowplowv3(-294.427, 1353.026, 46.933)
nodes[573] <-  snowplowv3(-220.257, 1277.531, 54.096)
nodes[574] <-  snowplowv3(-201.133, 1258.197, 54.162)
nodes[575] <-  snowplowv3(-115.811, 1261.585, 63.158)
nodes[576] <-  snowplowv3(-48.788, 1254.543, 64.722)
nodes[577] <-  snowplowv3(13.204, 1226.067, 66.648)
nodes[578] <-  snowplowv3(75.619, 1211.015, 66.845)
nodes[579] <-  snowplowv3(133.131, 1211.113, 63.237)
nodes[580] <-  snowplowv3(177.864, 1211.983, 61.999)
nodes[581] <-  snowplowv3(221.472, 1212.184, 62.739)
nodes[582] <-  snowplowv3(273.87, 1212.403, 63.557)
nodes[583] <-  snowplowv3(286.668, 1228.531, 63.537)
nodes[584] <-  snowplowv3(277.069, 1275.378, 60.319)
nodes[585] <-  snowplowv3(215.878, 1274.51, 57.096)
nodes[586] <-  snowplowv3(150.539, 1269.267, 59.243)
nodes[587] <-  snowplowv3(142.466, 1227.241, 63.112)
nodes[588] <-  snowplowv3(132.618, 1214.851, 63.256)
nodes[589] <-  snowplowv3(75.615, 1215.286, 66.819)
nodes[590] <-  snowplowv3(10.753, 1231.814, 66.278)
nodes[591] <-  snowplowv3(-80.268, 1265.898, 64.176)
nodes[592] <-  snowplowv3(-141.392, 1264.892, 61.698)
nodes[593] <-  snowplowv3(-200.579, 1262.228, 54.18)
nodes[594] <-  snowplowv3(-219.991, 1243.822, 53.952)
nodes[595] <-  snowplowv3(-225.889, 1172.411, 52.52)
nodes[596] <-  snowplowv3(-243.104, 1092.357, 50.168)
nodes[597] <-  snowplowv3(-311.207, 1063.574, 45.652)
nodes[598] <-  snowplowv3(-372.008, 1078.815, 44.234)
nodes[599] <-  snowplowv3(-445.954, 1136.961, 36.621)
nodes[600] <-  snowplowv3(-507.991, 1151.956, 32.212)
nodes[601] <-  snowplowv3(-518.907, 1166.693, 32.324)
nodes[602] <-  snowplowv3(-504.286, 1234.353, 38.434)
nodes[603] <-  snowplowv3(-459.64, 1249.611, 43.83)
nodes[604] <-  snowplowv3(-384.15, 1250.514, 50.453)
nodes[605] <-  snowplowv3(-313.956, 1261.314, 54.392)
nodes[606] <-  snowplowv3(-232.148, 1257.885, 54.193)
nodes[607] <-  snowplowv3(-215.787, 1277.927, 54.097)
nodes[608] <-  snowplowv3(-242.606, 1345.758, 51.257)
nodes[609] <-  snowplowv3(-292.471, 1357.06, 47.076)
nodes[610] <-  snowplowv3(-379.065, 1366.382, 39.617)
nodes[611] <-  snowplowv3(-460.219, 1338.74, 30.929)
nodes[612] <-  snowplowv3(-493.361, 1320.852, 26.607)
nodes[613] <-  snowplowv3(-509.69, 1312.527, 25.05)
nodes[614] <-  snowplowv3(-599.609, 1266.792, 20.21)
nodes[615] <-  snowplowv3(-665.889, 1220.14, 23.003)
nodes[616] <-  snowplowv3(-598.867, 1152.417, 30.718)
nodes[617] <-  snowplowv3(-533.818, 1147.581, 32.178)
nodes[618] <-  snowplowv3(-523.315, 1134.878, 32.133)
nodes[619] <-  snowplowv3(-519.093, 1053.028, 28.861)
nodes[620] <-  snowplowv3(-446.639, 1021.301, 20.993)
nodes[621] <-  snowplowv3(-362.42, 1025.834, 13.829)
nodes[622] <-  snowplowv3(-294.907, 1003.788, 5.385)
nodes[623] <-  snowplowv3(-397.724, 985.754, -6.419)
nodes[624] <-  snowplowv3(-474.512, 938.632, -17.5709)
nodes[625] <-  snowplowv3(-511.883, 918.811, -18.906)
nodes[626] <-  snowplowv3(-572.054, 918.806, -18.903)
nodes[627] <-  snowplowv3(-621.987, 919.154, -18.76)
nodes[628] <-  snowplowv3(-633.579, 905.404, -18.752)
nodes[629] <-  snowplowv3(-633.721, 867.672, -18.754)
nodes[630] <-  snowplowv3(-633.714, 815.356, -18.751)
nodes[631] <-  snowplowv3(-646.041, 804.126, -18.749)
nodes[632] <-  snowplowv3(-678.706, 804.126, -18.752)
nodes[633] <-  snowplowv3(-731.169, 804.017, -18.753)
nodes[634] <-  snowplowv3(-744.676, 789.705, -18.692)
nodes[635] <-  snowplowv3(-744.779, 740.364, -17.121)
nodes[636] <-  snowplowv3(-729.913, 730.245, -17.013)
nodes[637] <-  snowplowv3(-686.082, 729.755, -12.676)
nodes[638] <-  snowplowv3(-673.93, 716.917, -12.114)
nodes[639] <-  snowplowv3(-674.485, 655.447, -4.451)
nodes[640] <-  snowplowv3(-674.256, 599.183, 1.049)
nodes[641] <-  snowplowv3(-655.77, 582.935, 1.196)
nodes[642] <-  snowplowv3(-600.096, 582.867, -1.065)
nodes[643] <-  snowplowv3(-545.93, 582.965, -4.007)
nodes[644] <-  snowplowv3(-485.002, 582.927, -7.102)
nodes[645] <-  snowplowv3(-416.893, 583.142, -9.963)
nodes[646] <-  snowplowv3(-219.067, 800.898, -20.019)
nodes[647] <-  snowplowv3(-149.292, 801.504, -20.811)
nodes[648] <-  snowplowv3(-94.695, 813.33, -22.702)
nodes[649] <-  snowplowv3(-54.601, 823.026, -24.312)
nodes[650] <-  snowplowv3(-39.192, 806.069, -24.054)
nodes[651] <-  snowplowv3(-39.137, 772.327, -21.915)
nodes[652] <-  snowplowv3(-39.057, 732.756, -21.835)
nodes[653] <-  snowplowv3(-39.031, 718.475, -21.826)
nodes[654] <-  snowplowv3(-22.138, 705.868, -21.818)
nodes[655] <-  snowplowv3(20.7, 705.896, -21.727)
nodes[656] <-  snowplowv3(37.193, 723.921, -21.838)
nodes[657] <-  snowplowv3(33.204, 805.181, -24.196)
nodes[658] <-  snowplowv3(43.927, 818.848, -24.411)
nodes[659] <-  snowplowv3(77.344, 823.299, -22.039)
nodes[660] <-  snowplowv3(113.624, 823.285, -19.553)
nodes[661] <-  snowplowv3(126.304, 841.644, -19.639)
nodes[662] <-  snowplowv3(126.345, 894.451, -21.796)
nodes[663] <-  snowplowv3(126.377, 938.589, -22.09)
nodes[664] <-  snowplowv3(91.001, 990.793, -18.745)
nodes[665] <-  snowplowv3(44.868, 1000.588, -14.811)
nodes[666] <-  snowplowv3(-22.676, 1029.284, -11.009)
nodes[667] <-  snowplowv3(-46.997,  1091.273, -10.992, true) // is tunnel
nodes[668] <-  snowplowv3(-82.928,  1203.184, -13.629, true) // is tunnel
nodes[669] <-  snowplowv3(-117.032, 1302.424, -15.138, true) // is tunnel
nodes[670] <-  snowplowv3(-118.122, 1388.627, -15.143)
nodes[671] <-  snowplowv3(-117.918, 1458.643, -15.144)
nodes[672] <-  snowplowv3(-152.716, 1541.564, -18.031)
nodes[673] <-  snowplowv3(-231.177, 1575.4, -24.161)
nodes[674] <-  snowplowv3(-291.328, 1575.899, -23.448)
nodes[675] <-  snowplowv3(-299.425, 1589.434, -23.342)
nodes[676] <-  snowplowv3(-288.549, 1606.029, -23.1)
nodes[677] <-  snowplowv3(-241.185, 1606.417, -22.675)
nodes[678] <-  snowplowv3(-199.78, 1607.589, -23.424)
nodes[679] <-  snowplowv3(-181.25, 1593.241, -23.425)
nodes[680] <-  snowplowv3(-160.574, 1566.395, -23.422)
nodes[681] <-  snowplowv3(-130.036, 1568.647, -23.415)
nodes[682] <-  snowplowv3(-85.702, 1595.506, -22.514)
nodes[683] <-  snowplowv3(-41.32, 1629.3, -19.742)
nodes[684] <-  snowplowv3(-10.202, 1649.957, -19.912)
nodes[685] <-  snowplowv3(-8.637, 1668.964, -19.816)
nodes[686] <-  snowplowv3(4.372, 1658.342, -19.901)
nodes[687] <-  snowplowv3(-12.545, 1653.269, -19.908)
nodes[688] <-  snowplowv3(-45.313, 1632.284, -19.854)
nodes[689] <-  snowplowv3(-95.607, 1596.331, -23.017)
nodes[690] <-  snowplowv3(-132.352, 1574.478, -23.412)
nodes[691] <-  snowplowv3(-160.522, 1572.974, -23.423)
nodes[692] <-  snowplowv3(-174.232, 1593.323, -23.424)
nodes[693] <-  snowplowv3(-200.399, 1612.886, -23.431)
nodes[694] <-  snowplowv3(-241.369, 1613.05, -22.667)
nodes[695] <-  snowplowv3(-289.008, 1613.971, -23.102)
nodes[696] <-  snowplowv3(-299.898, 1624.274, -23.086)
nodes[697] <-  snowplowv3(-300.061, 1665.796, -22.115)
nodes[698] <-  snowplowv3(-300.21, 1728.77, -22.713)
nodes[699] <-  snowplowv3(-299.731, 1784.456, -23.391)
nodes[700] <-  snowplowv3(-314.308, 1796.333, -23.412)
nodes[701] <-  snowplowv3(-371.424, 1796.126, -23.431)
nodes[702] <-  snowplowv3(-406.859, 1796.807, -23.428)
nodes[703] <-  snowplowv3(-460.925, 1796.647, -19.243)
nodes[704] <-  snowplowv3(-502.28, 1796.695, -15.15)
nodes[705] <-  snowplowv3(-563.376, 1796.744, -14.942)
nodes[706] <-  snowplowv3(-620.365, 1796.697, -14.934)
nodes[707] <-  snowplowv3(-700.159, 1796.529, -14.902)
nodes[708] <-  snowplowv3(-734.144, 1776.538, -14.888)
nodes[709] <-  snowplowv3(-739.462, 1753.963, -14.882)
nodes[710] <-  snowplowv3(-739.555, 1700.608, -14.802)
nodes[711] <-  snowplowv3(-739.563, 1647.868, -14.77)
nodes[712] <-  snowplowv3(-735.329, 1612.609, -13.905)
nodes[713] <-  snowplowv3(-728.584, 1577.835, -12.47)
nodes[714] <-  snowplowv3(-708.615, 1562.186, -13.572)
nodes[715] <-  snowplowv3(-650.575, 1564.13, -16.355)
nodes[716] <-  snowplowv3(-577.107, 1564.252, -16.731)
nodes[717] <-  snowplowv3(-522.555, 1564.546, -14.952)
nodes[718] <-  snowplowv3(-505.43, 1576.547, -16.103)
nodes[719] <-  snowplowv3(-503.235, 1591.515, -16.445)
nodes[720] <-  snowplowv3(-517.351, 1598.66, -15.913)
nodes[721] <-  snowplowv3(-531.48, 1593.755, -16.296)
nodes[722] <-  snowplowv3(-551.662, 1594.086, -16.302)
nodes[723] <-  snowplowv3(-563.397, 1599.634, -16.29)
nodes[724] <-  snowplowv3(-585.008, 1599.904, -16.294)
nodes[725] <-  snowplowv3(-598.805, 1595.049, -16.307)
nodes[726] <-  snowplowv3(-632.513, 1593.99, -16.48)
nodes[727] <-  snowplowv3(-643.887, 1582.262, -16.485)
nodes[728] <-  snowplowv3(-652.625, 1575.561, -16.476)
nodes[729] <-  snowplowv3(-709.663, 1572.83, -13.717)
nodes[730] <-  snowplowv3(-744.594, 1562.723, -10.854)
nodes[731] <-  snowplowv3(-788.918, 1545.887, -6.281)
nodes[732] <-  snowplowv3(-832.575, 1527.161, -5.902)
nodes[733] <-  snowplowv3(-848.91, 1502.344, -5.541)
nodes[734] <-  snowplowv3(-873.512, 1480.256, -4.836)
nodes[735] <-  snowplowv3(-883.349, 1493.212, -4.327)
nodes[736] <-  snowplowv3(-883.204, 1557.402, 5.097)
nodes[737] <-  snowplowv3(-899.569, 1570.643, 5.168)
nodes[738] <-  snowplowv3(-928.367, 1570.861, 5.169)
nodes[739] <-  snowplowv3(-1009.442, 1570.855, 5.164)
nodes[740] <-  snowplowv3(-1024.873, 1554.683, 4.811)
nodes[741] <-  snowplowv3(-1025.487, 1491.422, -4.375)
nodes[742] <-  snowplowv3(-1037.394, 1479.855, -4.535)
nodes[743] <-  snowplowv3(-1103.467, 1479.687, -2.713)
nodes[744] <-  snowplowv3(-1115.323, 1491.737, -2.381)
nodes[745] <-  snowplowv3(-1115.367, 1556.244, 6.932)
nodes[746] <-  snowplowv3(-1132.015, 1570.965, 6.998)
nodes[747] <-  snowplowv3(-1197.462, 1571.138, 5.236)
nodes[748] <-  snowplowv3(-1213.567, 1556.467, 5.003)
nodes[749] <-  snowplowv3(-1213.611, 1492.351, -4.289)
nodes[750] <-  snowplowv3(-1226.076, 1479.576, -4.656)
nodes[751] <-  snowplowv3(-1278.871, 1475.327, -5.906)
nodes[752] <-  snowplowv3(-1299.827, 1469.587, -5.946)
nodes[753] <-  snowplowv3(-1304.14, 1451.669, -6.315)
nodes[754] <-  snowplowv3(-1308.258, 1406.593, -13.058)
nodes[755] <-  snowplowv3(-1320.256, 1393.909, -13.403)
nodes[756] <-  snowplowv3(-1391.915, 1397.795, -13.405)
nodes[757] <-  snowplowv3(-1449.431, 1413.382, -13.409)
nodes[758] <-  snowplowv3(-1477.696, 1454.94, -12.215)
nodes[759] <-  snowplowv3(-1497.637, 1526.131, -8.783)
nodes[760] <-  snowplowv3(-1528.337, 1562.834, -6.313)
nodes[761] <-  snowplowv3(-1537.698, 1578.947, -5.775)
nodes[762] <-  snowplowv3(-1537.579, 1619.419, -4.65)
nodes[763] <-  snowplowv3(-1537.328, 1672.97, -0.122)
nodes[764] <-  snowplowv3(-1525.492, 1685.384, 0.092)
nodes[765] <-  snowplowv3(-1460.531, 1685.255, 6.213)
nodes[766] <-  snowplowv3(-1449.191, 1672.425, 6.172)
nodes[767] <-  snowplowv3(-1449.209, 1630.63, 4.396)
nodes[768] <-  snowplowv3(-1430.223, 1584.075, 1.599)
nodes[769] <-  snowplowv3(-1419.155, 1528.265, -1.239)
nodes[770] <-  snowplowv3(-1408.096, 1481.212, -4.161)
nodes[771] <-  snowplowv3(-1321.696, 1476.08, -5.942)
nodes[772] <-  snowplowv3(-1304.488, 1491.974, -5.653)
nodes[773] <-  snowplowv3(-1304.16, 1554.731, 3.453)
nodes[774] <-  snowplowv3(-1291.763, 1567.542, 3.865)
nodes[775] <-  snowplowv3(-1225.159, 1567.136, 5.117)
nodes[776] <-  snowplowv3(-1210.117, 1582.776, 5.289)
nodes[777] <-  snowplowv3(-1209.434, 1623.953, 8.05)
nodes[778] <-  snowplowv3(-1209.582, 1673.329, 11.348)
nodes[779] <-  snowplowv3(-1197.442, 1685.223, 11.456)
nodes[780] <-  snowplowv3(-1144.808, 1685.202, 11.175)
nodes[781] <-  snowplowv3(-1097.012, 1685.372, 10.91)
nodes[782] <-  snowplowv3(-1036.04, 1685.25, 10.581)
nodes[783] <-  snowplowv3(-991.241, 1667.135, 8.984)
nodes[784] <-  snowplowv3(-943.439, 1618.201, 6.178)
nodes[785] <-  snowplowv3(-918.23, 1591.577, 5.497)
nodes[786] <-  snowplowv3(-913.847, 1577.876, 5.173)
nodes[787] <-  snowplowv3(-899.5, 1566.732, 5.165)
nodes[788] <-  snowplowv3(-887.597, 1556.827, 5.065)
nodes[789] <-  snowplowv3(-887.34, 1492.696, -4.331)
nodes[790] <-  snowplowv3(-887.548, 1454.548, -4.763)
nodes[791] <-  snowplowv3(-887.463, 1417.167, -11.042)
nodes[792] <-  snowplowv3(-899.075, 1406.644, -11.174)
nodes[793] <-  snowplowv3(-944.899, 1406.689, -12.093)
nodes[794] <-  snowplowv3(-1010.709, 1406.641, -13.412)
nodes[795] <-  snowplowv3(-1025.399, 1393.298, -13.417)
nodes[796] <-  snowplowv3(-1009.929, 1377.937, -13.407)
nodes[797] <-  snowplowv3(-970.127, 1378.184, -13.897)
nodes[798] <-  snowplowv3(-927.954, 1378.314, -21.49)
nodes[799] <-  snowplowv3(-881.683, 1378.557, -23.667)
nodes[800] <-  snowplowv3(-792.533, 1378.538, -31.802, true) // is tunnel
nodes[801] <-  snowplowv3(-672.738, 1363.065, -35.076, true) // is tunnel
nodes[802] <-  snowplowv3(-563.533, 1293.002, -31.983, true) // is tunnel
nodes[803] <-  snowplowv3(-512.051, 1208.157, -25.280, true) // is tunnel
nodes[804] <-  snowplowv3(-504.946, 1117.481, -19.721, true) // is tunnel
nodes[805] <-  snowplowv3(-501.523, 994.051, -15.974)
nodes[806] <-  snowplowv3(-500.83, 930.927, -18.913)
nodes[807] <-  snowplowv3(-501.078, 903.736, -18.938)  // у телефонной будки
nodes[808] <-  snowplowv3(-501.36, 839.395, -19.305) // вдоль магазинов
nodes[809] <-  snowplowv3(-487.314, 807.221, -19.493) // на повороте у хотдогов
nodes[810] <-  snowplowv3(-457.144, 800.46, -19.643) // у бюро
nodes[811] <-  snowplowv3(-407.29, 800.622, -19.962) // перед перекрёстком
nodes[812] <-  snowplowv3(-395.081, 787.674, -19.777) // после поворота в сторону ПД снизу от бюро 1
nodes[813] <-  snowplowv3(-395.359, 714.952, -15.507) // после поворота в сторону ПД снизу от бюро 2
nodes[814] <-  snowplowv3(-395.675, 635.631, -10.7596) // после поворота в сторону ПД снизу от бюро 3
nodes[815] <-  snowplowv3(-396.086, 602.248, -10.103) // въезд в депо
nodes[816] <-  snowplowv3(-741.248, 744.748, -17.176)
nodes[817] <-  snowplowv3(-741.398, 788.334, -18.655)
nodes[818] <-  snowplowv3(-741.904, 815.119, -18.753)
nodes[819] <-  snowplowv3(-741.987, 850.286, -18.752)
nodes[820] <-  snowplowv3(-742.01, 902.792, -18.764)
nodes[821] <-  snowplowv3(-731.423, 915.641, -18.75)
nodes[822] <-  snowplowv3(-698.398, 915.847, -18.759)
nodes[823] <-  snowplowv3(-645.398, 916.052, -18.757)
nodes[824] <-  snowplowv3(-621.16, 916.079, -18.773)
nodes[825] <-  snowplowv3(-573.388, 916.133, -18.894)
nodes[826] <-  snowplowv3(-509.037, 916.074, -18.912)
nodes[827] <-  snowplowv3(-505.029, 1148.343, 32.21)
nodes[828] <-  snowplowv3(-442.174, 1130.139, 37.418)
nodes[829] <-  snowplowv3(-396.202, 1097.791, 42.495)
nodes[830] <-  snowplowv3(-329.002, 1059.792, 45.085)
nodes[831] <-  snowplowv3(-247.046, 1076.876, 49.249)
nodes[832] <-  snowplowv3(-222.585, 1166.275, 52.408)
nodes[833] <-  snowplowv3(-216.056, 1244.526, 53.977)
nodes[834] <-  snowplowv3(-231.591, 1261.759, 54.174)
nodes[835] <-  snowplowv3(-302.691, 1266.747, 54.726)
nodes[836] <-  snowplowv3(-389.578, 1254.328, 50.109)
nodes[837] <-  snowplowv3(-472.435, 1252.474, 42.527)
nodes[838] <-  snowplowv3(-520.231, 1219.673, 36.256)
nodes[839] <-  snowplowv3(-522.842, 1165.121, 32.272)
nodes[840] <-  snowplowv3(-514.603, 1327.105, 23.498)
nodes[841] <-  snowplowv3(-525.801, 1362.995, 18.762)
nodes[842] <-  snowplowv3(-549.557, 1382.622, 16.056)
nodes[843] <-  snowplowv3(-574.351, 1353.417, 12.947)
nodes[844] <-  snowplowv3(-573.948, 1301.404, 9.425)
nodes[845] <-  snowplowv3(-614.225, 1301.429, 4.807)
nodes[846] <-  snowplowv3(-652.791, 1341.338, 2.394)
nodes[847] <-  snowplowv3(-713.961, 1414.803, 2.395)
nodes[848] <-  snowplowv3(-796.4, 1518.029, -6.027)
nodes[849] <-  snowplowv3(-790.269, 1528.362, -6.038)
nodes[850] <-  snowplowv3(-732.259, 1555.768, -11.737)
nodes[851] <-  snowplowv3(-725.33, 1582.096, -12.852)
nodes[852] <-  snowplowv3(-731.972, 1639.932, -14.807)
nodes[853] <-  snowplowv3(-731.846, 1701.066, -14.835)
nodes[854] <-  snowplowv3(-731.744, 1756.282, -14.864)
nodes[855] <-  snowplowv3(-700.299, 1789.113, -14.881)
nodes[856] <-  snowplowv3(-612.617, 1789.162, -14.893)
nodes[857] <-  snowplowv3(-560.309, 1789.344, -14.917)
nodes[858] <-  snowplowv3(-505.365, 1789.155, -14.935)
nodes[859] <-  snowplowv3(-459.922, 1786.526, -19.318)
nodes[860] <-  snowplowv3(-405.406, 1786.636, -23.426)
nodes[861] <-  snowplowv3(-397.229, 1775.675, -23.36)
nodes[862] <-  snowplowv3(-397.47, 1724.423, -22.955)
nodes[863] <-  snowplowv3(-397.395, 1661.038, -23.173)
nodes[864] <-  snowplowv3(-397.43, 1584.477, -23.424)
nodes[865] <-  snowplowv3(-408.178, 1575.586, -23.317)
nodes[866] <-  snowplowv3(-484.832, 1575.419, -17.578)
nodes[867] <-  snowplowv3(-523.769, 1575.084, -14.93)
nodes[868] <-  snowplowv3(-569.329, 1575.33, -16.6)
nodes[869] <-  snowplowv3(-625.04, 1575.204, -16.499)
nodes[870] <-  snowplowv3(-636.988, 1584.205, -16.487)
nodes[871] <-  snowplowv3(-628.235, 1589.661, -16.467)
nodes[872] <-  snowplowv3(-599.941, 1588.396, -16.317)
nodes[873] <-  snowplowv3(-587.167, 1584.839, -16.286)
nodes[874] <-  snowplowv3(-563.948, 1584.723, -16.282)
nodes[875] <-  snowplowv3(-552.308, 1589.543, -16.285)
nodes[876] <-  snowplowv3(-531.323, 1589.19, -16.303)
nodes[877] <-  snowplowv3(-519.127, 1594.823, -15.94)
nodes[878] <-  snowplowv3(-508.959, 1582.659, -16.011)
nodes[879] <-  snowplowv3(-495.816, 1564.173, -16.754)
nodes[880] <-  snowplowv3(-454.383, 1560.145, -19.89)
nodes[881] <-  snowplowv3(-407.738, 1559.699, -23.334)
nodes[882] <-  snowplowv3(-397.231, 1548.403, -23.411)
nodes[883] <-  snowplowv3(-397.572, 1534.52, -23.466)
nodes[884] <-  snowplowv3(-405.365, 1527.363, -23.534)
nodes[885] <-  snowplowv3(-444.68, 1516.444, -22.212)
nodes[886] <-  snowplowv3(-507.742, 1518.519, -19.651)
nodes[887] <-  snowplowv3(-566.172, 1507.745, -16.023)
nodes[888] <-  snowplowv3(-623.109, 1505.976, -13.383)
nodes[889] <-  snowplowv3(-672.19, 1505.121, -12.172)
nodes[890] <-  snowplowv3(-694.49, 1512.061, -9.559)
nodes[891] <-  snowplowv3(-696.706, 1549.824, -14.113)
nodes[892] <-  snowplowv3(-688.473, 1559.72, -15.332)
nodes[893] <-  snowplowv3(-631.748, 1560.079, -16.434)
nodes[894] <-  snowplowv3(-575.645, 1560.063, -16.738)
nodes[895] <-  snowplowv3(-524.763, 1559.911, -14.92)
nodes[896] <-  snowplowv3(-496.152, 1559.854, -16.721)
nodes[897] <-  snowplowv3(-454.993, 1564.312, -19.833)
nodes[898] <-  snowplowv3(-408.127, 1564.548, -23.314)
nodes[899] <-  snowplowv3(-390.526, 1585.152, -23.417)
nodes[900] <-  snowplowv3(-390.206, 1661.937, -23.168)
nodes[901] <-  snowplowv3(-387.553, 1725.346, -22.96)
nodes[902] <-  snowplowv3(-387.89, 1775.601, -23.328)
nodes[903] <-  snowplowv3(-374.213, 1792.202, -23.427)
nodes[904] <-  snowplowv3(-312.911, 1792.351, -23.409)
nodes[905] <-  snowplowv3(-292.348, 1792.876, -23.426)
nodes[906] <-  snowplowv3(-253.607, 1801.269, -24.044)
nodes[907] <-  snowplowv3(-232.817, 1816.825, -21.2)
nodes[908] <-  snowplowv3(-210.924, 1823.431, -20.387)
nodes[909] <-  snowplowv3(-190.839, 1819.916, -20.383)
nodes[910] <-  snowplowv3(-196.017, 1833.83, -20.388)
nodes[911] <-  snowplowv3(-239.706, 1827.682, -20.945)
nodes[912] <-  snowplowv3(-268.817, 1805.508, -23.357)
nodes[913] <-  snowplowv3(-292.137, 1797.134, -23.42)
nodes[914] <-  snowplowv3(-303.163, 1783.655, -23.371)
nodes[915] <-  snowplowv3(-303.558, 1733.203, -22.647)
nodes[916] <-  snowplowv3(-303.473, 1677.348, -22.126)
nodes[917] <-  snowplowv3(-303.298, 1585.614, -23.409)
nodes[918] <-  snowplowv3(-289.792, 1564.136, -23.465)
nodes[919] <-  snowplowv3(-236.221, 1563.554, -24.424)
nodes[920] <-  snowplowv3(-161.597, 1532.572, -18.027)
nodes[921] <-  snowplowv3(-130.884, 1455.69, -15.142)
nodes[922] <-  snowplowv3(-130.704, 1389.555, -15.142)
nodes[923] <-  snowplowv3(-136.098, 1326.358, -15.149)
nodes[924] <-  snowplowv3(-136.904, 1286.747, -15.183, true)  // is tunnel
nodes[925] <-  snowplowv3(-111.607, 1213.181, -14.121, true)  // is tunnel
nodes[926] <-  snowplowv3( -76.655, 1124.615, -11.378, true)  // is tunnel
nodes[927] <-  snowplowv3(-58.078, 1044.211, -11.013)
nodes[928] <-  snowplowv3(-69.906, 980.745, -12.444)
nodes[929] <-  snowplowv3(-109.189, 954.237, -15.574)
nodes[930] <-  snowplowv3(-162.876, 882.439, -20.235)
nodes[931] <-  snowplowv3(-168.675, 814.805, -20.696)
nodes[932] <-  snowplowv3(-179.935, 803.966, -20.639)
nodes[933] <-  snowplowv3(-221.903, 804.191, -20.004)
nodes[934] <-  snowplowv3(-232.468, 791.569, -19.997)
nodes[935] <-  snowplowv3(-232.542, 753.238, -19.996)
nodes[936] <-  snowplowv3(-232.765, 702.992, -19.995)
nodes[937] <-  snowplowv3(-243.481, 694.009, -19.977)
nodes[938] <-  snowplowv3(-270.902, 693.23, -19.797)
nodes[939] <-  snowplowv3(-305.378, 669.139, -19.136)
nodes[940] <-  snowplowv3(-378.714, 620.386, -10.265)
nodes[941] <-  snowplowv3(-465.157, 621.926, 0.654)
nodes[942] <-  snowplowv3(-494.001, 594.45, 1.202)
nodes[943] <-  snowplowv3(-482.998, 530.424, 1.199)
nodes[944] <-  snowplowv3(-472.408, 494.164, 1.192)
nodes[945] <-  snowplowv3(-463.928, 445.99, 1.202)
nodes[946] <-  snowplowv3(-463.965, 394.62, 1.202)
nodes[947] <-  snowplowv3(-463.946, 354.128, 1.205)
nodes[948] <-  snowplowv3(-468.064, 319.188, 1.202)
nodes[949] <-  snowplowv3(-468.078, 291.885, 1.202)
nodes[950] <-  snowplowv3(-468.123, 256.297, 1.201)
nodes[951] <-  snowplowv3(-464.123, 256.299, 1.202)
nodes[952] <-  snowplowv3(-464.188, 191.194, 1.199)
nodes[953] <-  snowplowv3(-468.188, 191.193, 1.202)
nodes[954] <-  snowplowv3(-468.274, 161.855, 1.031)
nodes[955] <-  snowplowv3(-464.274, 161.855, 1.031)
nodes[956] <-  snowplowv3(-463.974, 96.973, -0.814)
nodes[957] <-  snowplowv3(-468.265, 97.057, -0.816)
nodes[958] <-  snowplowv3(-468.098, 60.938, -1.011)
nodes[959] <-  snowplowv3(-464.098, 60.938, -1.009)
nodes[960] <-  snowplowv3(-463.705, -4.427, -1.207)
nodes[961] <-  snowplowv3(-467.705, -4.434, -1.202)
nodes[962] <-  snowplowv3(-467.882, -43.35, -1.764)
nodes[963] <-  snowplowv3(-463.881, -43.333, -1.76)
nodes[964] <-  snowplowv3(-463.788, -89.85, -3.01)
nodes[965] <-  snowplowv3(-467.788, -89.85, -3.012)
nodes[966] <-  snowplowv3(-498.528, 594.674, 1.207)
nodes[967] <-  snowplowv3(-487.322, 530.456, 1.2)
nodes[968] <-  snowplowv3(-476.826, 492.682, 1.2)
nodes[969] <-  snowplowv3(-468.235, 445.69, 1.203)
nodes[970] <-  snowplowv3(-459.186, -116.422, -3.676)
nodes[971] <-  snowplowv3(-459.187, -112.422, -3.678)
nodes[972] <-  snowplowv3(-454.711, -89.157, -3.091)
nodes[973] <-  snowplowv3(-450.711, -89.156, -3.09)
nodes[974] <-  snowplowv3(-450.722, -45.322, -1.872)
nodes[975] <-  snowplowv3(-454.722, -45.322, -1.872)
nodes[976] <-  snowplowv3(-454.708, -4.388, -1.2)
nodes[977] <-  snowplowv3(-450.709, -4.388, -1.202)
nodes[978] <-  snowplowv3(-450.59, 59.857, -1.013)
nodes[979] <-  snowplowv3(-454.59, 59.857, -1.013)
nodes[980] <-  snowplowv3(-450.272, 97.195, -0.806)
nodes[981] <-  snowplowv3(-455.254, 155.685, 0.856)
nodes[982] <-  snowplowv3(-450.522, 156.075, 0.867)
nodes[983] <-  snowplowv3(-455.103, 191.413, 1.203)
nodes[984] <-  snowplowv3(-454.896, 251.601, 1.202)
nodes[985] <-  snowplowv3(-454.855, 390.853, 1.198)
nodes[986] <-  snowplowv3(-456.792, 444.813, 1.196)
nodes[987] <-  snowplowv3(-465.587, 495.966, 1.199)
nodes[988] <-  snowplowv3(-476.079, 532.718, 1.198)
nodes[989] <-  snowplowv3(-486.955, 592.034, 1.199)
nodes[990] <-  snowplowv3(-487.341, 646.598, 1.236)
nodes[991] <-  snowplowv3(-528.399, 691.642, 2.562)
nodes[992] <-  snowplowv3(-569.651, 696.374, 3.319)
nodes[993] <-  snowplowv3(-638.519, 695.787, 3.879)
nodes[994] <-  snowplowv3(-709.935, 643.183, 0.163)
nodes[995] <-  snowplowv3(-729.177, 532.517, -6.963)
nodes[996] <-  snowplowv3(-729.445, 399.103, -12.166)
nodes[997] <-  snowplowv3(-729.405, 262.074, -12.481)
nodes[998] <-  snowplowv3(-729.06, 179.233, -12.479)
nodes[999] <-  snowplowv3(-729.482, 107.439, -12.486)
nodes[1000] <- snowplowv3(-729.212, 36.312, -12.481)
nodes[1001] <- snowplowv3(-729.258, -61.56, -12.484)
nodes[1002] <- snowplowv3(-730.876, -165.143, -12.483)
nodes[1003] <- snowplowv3(-732.265, -269.648, -12.479)
nodes[1004] <- snowplowv3(-729.487, -354.365, -12.294)
nodes[1005] <- snowplowv3(-713.051, -425.154, -11.793)
nodes[1006] <- snowplowv3(-658.97, -519.589, -11.199)
nodes[1007] <- snowplowv3(-586.342, -576.802, -10.892)
nodes[1008] <- snowplowv3(-482.191, -614.496, -10.862)
nodes[1009] <- snowplowv3(-360.799, -626.617, -10.898)
nodes[1010] <- snowplowv3(-244.796, -626.091, -10.828)
nodes[1011] <- snowplowv3(-136.42, -626.061, -10.169)
nodes[1012] <- snowplowv3(-18.992, -626.227, -8.221)
nodes[1013] <- snowplowv3(119.134, -573.287, -7.213)
nodes[1014] <- snowplowv3(185.098, -510.261, -7.685)
nodes[1015] <- snowplowv3(270.602, -487.984, -10.041)
nodes[1016] <- snowplowv3(313.75, -487.569, -10.686)
nodes[1017] <- snowplowv3(399.613, -487.729, -10.921)
nodes[1018] <- snowplowv3(473.692, -487.73, -10.921)
nodes[1019] <- snowplowv3(531.988, -487.606, -10.921)
nodes[1020] <- snowplowv3(588.797, -487.711, -10.921)
nodes[1021] <- snowplowv3(647.932, -487.709, -10.922)
nodes[1022] <- snowplowv3(696.288, -487.474, -10.922)
nodes[1023] <- snowplowv3(752.008, -483.449, -10.922)
nodes[1024] <- snowplowv3(799.11, -460.381, -10.923)
nodes[1025] <- snowplowv3(835.195, -415.349, -10.923)
nodes[1026] <- snowplowv3(849.518, -353.825, -10.421)
nodes[1027] <- snowplowv3(849.338, -297.857, -7.975)
nodes[1028] <- snowplowv3(849.227, -236.077, -5.283)
nodes[1029] <- snowplowv3(849.21, -169.34, -2.375)
nodes[1030] <- snowplowv3(847.39, -104.538, 0.344)
nodes[1031] <- snowplowv3(826, -38.903, 2.942)
nodes[1032] <- snowplowv3(782.363, 19.005, 4.389)
nodes[1033] <- snowplowv3(716.281, 61.905, 4.941)
nodes[1034] <- snowplowv3(643.172, 97.358, 4.802)
nodes[1035] <- snowplowv3(577.04, 157.288, 2.447)
nodes[1036] <- snowplowv3(549.443, 226.333, -1.46)
nodes[1037] <- snowplowv3(546.228, 314.61, -5.849)
nodes[1038] <- snowplowv3(543.131, 390.83, -6.586)
nodes[1039] <- snowplowv3(499.313, 468.714, -8.164)
nodes[1040] <- snowplowv3(424.527, 504.564, -10.883)
nodes[1041] <- snowplowv3(346.046, 528.073, -10.985)
nodes[1042] <- snowplowv3(253.001, 556.593, -10.995)
nodes[1043] <- snowplowv3(174.704, 572.598, -10.996)
nodes[1044] <- snowplowv3(102.616, 604.845, -10.997)
nodes[1045] <- snowplowv3(59.671, 671.318, -10.991)
nodes[1046] <- snowplowv3(40.489, 741.267, -11.002)
nodes[1047] <- snowplowv3(19.104, 819.368, -11.014)
nodes[1048] <- snowplowv3(-7.598, 920.819, -11.016)
nodes[1049] <- snowplowv3(-22.027, 974.848, -11.015)
nodes[1050] <- snowplowv3( -51.371, 1090.277, -11.003, true) // is tunnel
nodes[1051] <- snowplowv3( -86.002, 1199.012, -13.575, true) // is tunnel
nodes[1052] <- snowplowv3(-122.032, 1300.044, -15.152, true) // is tunnel
nodes[1053] <- snowplowv3(-122.345, 1386.394, -15.142)
nodes[1054] <- snowplowv3(-122.232, 1456.921, -15.142)
nodes[1055] <- snowplowv3(-154.093, 1537.369, -17.93)
nodes[1056] <- snowplowv3(-229.148, 1571.003, -24.015)
nodes[1057] <- snowplowv3(-284.478, 1571.22, -23.593)
nodes[1058] <- snowplowv3(-567.259, 700.575, 3.281)
nodes[1059] <- snowplowv3(-637.3, 700.228, 3.93)
nodes[1060] <- snowplowv3(-711.099, 649.667, 0.585)
nodes[1061] <- snowplowv3(-732.944, 536.993, -6.673)
nodes[1062] <- snowplowv3(-732.891, 464.595, -11.211)
nodes[1063] <- snowplowv3(-732.892, 338.165, -12.348)
nodes[1064] <- snowplowv3(-732.986, 235.165, -12.479)
nodes[1065] <- snowplowv3(-732.923, 147.947, -12.479)
nodes[1066] <- snowplowv3(-732.78, 72.093, -12.48)
nodes[1067] <- snowplowv3(-732.977, -1.467, -12.48)
nodes[1068] <- snowplowv3(-733.005, -108.541, -12.476)
nodes[1069] <- snowplowv3(-734.986, -165.432, -12.48)
nodes[1070] <- snowplowv3(-736.647, -238.26, -12.48)
nodes[1071] <- snowplowv3(-735.944, -326.954, -12.475)
nodes[1072] <- snowplowv3(-718.282, -422.595, -11.815)
nodes[1073] <- snowplowv3(-681.093, -497.439, -11.347)
nodes[1074] <- snowplowv3(-638.912, -545.235, -11.026)
nodes[1075] <- snowplowv3(-587.5, -580.697, -10.92)
nodes[1076] <- snowplowv3(-484.615, -617.533, -10.876)
nodes[1077] <- snowplowv3(-362.886, -630.238, -10.901)
nodes[1078] <- snowplowv3(-245.608, -629.637, -10.827)
nodes[1079] <- snowplowv3(-190.273, -629.597, -10.581)
nodes[1080] <- snowplowv3(-90.133, -629.745, -9.607)
nodes[1081] <- snowplowv3(7.901, -629.761, -7.58)
nodes[1082] <- snowplowv3(97.486, -601.133, -6.766)
nodes[1083] <- snowplowv3(147.391, -548.181, -7.342)
nodes[1084] <- snowplowv3(235.074, -494.331, -9.097)
nodes[1085] <- snowplowv3(292.102, -491.211, -10.428)
nodes[1086] <- snowplowv3(353.806, -491.428, -10.902)
nodes[1087] <- snowplowv3(434.13, -491.197, -10.921)
nodes[1088] <- snowplowv3(501.481, -491.24, -10.921)
nodes[1089] <- snowplowv3(563.56, -491.295, -10.921)
nodes[1090] <- snowplowv3(617.863, -491.277, -10.921)
nodes[1091] <- snowplowv3(672.151, -491.308, -10.921)
nodes[1092] <- snowplowv3(725.18, -491.17, -10.921)
nodes[1093] <- snowplowv3(778.074, -478.05, -10.922)
nodes[1094] <- snowplowv3(820.963, -444.318, -10.921)
nodes[1095] <- snowplowv3(848.763, -392.177, -10.923)
nodes[1096] <- snowplowv3(852.866, -327.916, -9.284)
nodes[1097] <- snowplowv3(852.956, -268.835, -6.71)
nodes[1098] <- snowplowv3(852.968, -203.132, -3.847)
nodes[1099] <- snowplowv3(852.963, -139.703, -1.084)
nodes[1100] <- snowplowv3(841.759, -63.862, 1.946)
nodes[1101] <- snowplowv3(810.594, -7.158, 3.851)
nodes[1102] <- snowplowv3(748.097, 49.557, 4.653)
nodes[1103] <- snowplowv3(650.546, 97.405, 4.749)
nodes[1104] <- snowplowv3(582.534, 156.356, 2.616)
nodes[1105] <- snowplowv3(553.415, 225.569, -1.369)
nodes[1106] <- snowplowv3(550.118, 314.115, -5.832)
nodes[1107] <- snowplowv3(546.908, 389.336, -6.582)
nodes[1108] <- snowplowv3(523.563, 449.869, -7.442)
nodes[1109] <- snowplowv3(465.774, 493.532, -9.722)
nodes[1110] <- snowplowv3(389.636, 519.049, -10.928)
nodes[1111] <- snowplowv3(296.757, 549.095, -10.996)
nodes[1112] <- snowplowv3(215.817, 568.206, -10.996)
nodes[1113] <- snowplowv3(136.531, 587.734, -10.995)
nodes[1114] <- snowplowv3(82.841, 631.803, -10.996)
nodes[1115] <- snowplowv3(55.287, 702.011, -10.996)
nodes[1116] <- snowplowv3(33.082, 782.361, -11.007)
nodes[1117] <- snowplowv3(15.981, 845.387, -11.014)
nodes[1118] <- snowplowv3(-5.377, 927.29, -11.015)
nodes[1119] <- snowplowv3(-22.521, 991.317, -11.018)
nodes[1120] <- snowplowv3(3.916, 908.854, -11.019)
nodes[1121] <- snowplowv3(4.196, 943.215, -11.149)
nodes[1122] <- snowplowv3(50.662, 992.092, -15.795)
nodes[1123] <- snowplowv3(88.804, 988.649, -18.794)
nodes[1124] <- snowplowv3(119.187, 955.731, -22.085)
nodes[1125] <- snowplowv3(123.162, 917.545, -22.098)
nodes[1126] <- snowplowv3(123.114, 849.45, -19.946)
nodes[1127] <- snowplowv3(122.748, 800.87, -19.512)
nodes[1128] <- snowplowv3(123.178, 743.064, -17.019)
nodes[1129] <- snowplowv3(117.52, 683.397, -17.141)
nodes[1130] <- snowplowv3(101.423, 658.377, -19.511)
nodes[1131] <- snowplowv3(65.639, 636.263, -19.932)
nodes[1132] <- snowplowv3(17.429, 640.187, -19.966)
nodes[1133] <- snowplowv3(-12.955, 640.499, -19.692)
nodes[1134] <- snowplowv3(17.625, 643.419, -20)
nodes[1135] <- snowplowv3(-12.663, 643.715, -19.722)
nodes[1136] <- snowplowv3(-375.349, 805.089, -19.985)
nodes[1137] <- snowplowv3(-232.922, 671.506, -19.993)
nodes[1138] <- snowplowv3(-229.422, 671.506, -19.996)
nodes[1139] <- snowplowv3(-230.49, 640.277, -20.002)
nodes[1140] <- snowplowv3(-208.98, 636.365, -19.957)
nodes[1141] <- snowplowv3(-187.5, 636.363, -19.97)
nodes[1142] <- snowplowv3(-147.092, 636.541, -19.944)
nodes[1143] <- snowplowv3(-105.918, 636.455, -19.839)
nodes[1144] <- snowplowv3(-62.358, 636.46, -19.957)
nodes[1145] <- snowplowv3(-15.233, 636.361, -19.688)
nodes[1146] <- snowplowv3(16.608, 636.348, -19.962)
nodes[1147] <- snowplowv3(-209.552, 632.828, -20)
nodes[1148] <- snowplowv3(-187.609, 632.622, -19.992)
nodes[1149] <- snowplowv3(-147.146, 632.883, -19.98)
nodes[1150] <- snowplowv3(-118.243, 632.842, -19.912)
nodes[1151] <- snowplowv3(-86.178, 632.872, -19.879)
nodes[1152] <- snowplowv3(-61.988, 632.961, -20.005)
nodes[1153] <- snowplowv3(-16.008, 632.947, -19.749)
nodes[1154] <- snowplowv3(16.448, 633.022, -20.012)
nodes[1155] <- snowplowv3(38.962, 617.47, -19.979)
nodes[1156] <- snowplowv3(42.962, 617.47, -19.979)
nodes[1157] <- snowplowv3(42.617, 559.602, -19.071)
nodes[1158] <- snowplowv3(39.123, 558.669, -19.041)
nodes[1159] <- snowplowv3(39.25, 526.628, -18.789)
nodes[1160] <- snowplowv3(42.751, 526.625, -18.786)
nodes[1161] <- snowplowv3(43.311, 454.098, -16.488)
nodes[1162] <- snowplowv3(39.817, 453.749, -16.491)
nodes[1163] <- snowplowv3(10.557, 429.146, -15.113)
nodes[1164] <- snowplowv3(9.895, 425.672, -15.054)
nodes[1165] <- snowplowv3(-24.237, 412.745, -13.817)
nodes[1166] <- snowplowv3(-26.742, 416.911, -13.807)
nodes[1167] <- snowplowv3(-27.844, 388.867, -13.82)
nodes[1168] <- snowplowv3(-23.849, 388.872, -13.823)
nodes[1169] <- snowplowv3(-5.743, 364.493, -13.824)
nodes[1170] <- snowplowv3(24.767, 364.35, -13.828)
nodes[1171] <- snowplowv3(47.291, 368.317, -13.818)
nodes[1172] <- snowplowv3(66.406, 378.817, -14.677)
nodes[1173] <- snowplowv3(106.825, 373.218, -20.025)
nodes[1174] <- snowplowv3(128.034, 352.353, -20.998)
nodes[1175] <- snowplowv3(128.044, 320.57, -20.954)
nodes[1176] <- snowplowv3(128.083, 242.77, -20.958)
nodes[1177] <- snowplowv3(70.069, 221.963, -16.414)
nodes[1178] <- snowplowv3(49.389, 236.902, -15.781)
nodes[1179] <- snowplowv3(49.486, 274.679, -15.129)
nodes[1180] <- snowplowv3(43.315, 274.51, -15.134)
nodes[1181] <- snowplowv3(43.196, 240.439, -15.708)
nodes[1182] <- snowplowv3(43.664, 203.436, -15.835)
nodes[1183] <- snowplowv3(43.429, 145.145, -14.425)
nodes[1184] <- snowplowv3(43.301, 68.136, -12.837)
nodes[1185] <- snowplowv3(43.107, 31.292, -12.956)
nodes[1186] <- snowplowv3(43.216, -17.015, -14.901)
nodes[1187] <- snowplowv3(43.337, -91.902, -17.838)
nodes[1188] <- snowplowv3(27.313, -109.079, -17.844)
nodes[1189] <- snowplowv3(-32.818, -109.088, -14.673)
nodes[1190] <- snowplowv3(-76.032, -109.27, -14.151)
nodes[1191] <- snowplowv3(-121.837, -109.296, -13.188)
nodes[1192] <- snowplowv3(-179.875, -108.995, -11.967)
nodes[1193] <- snowplowv3(-217.957, -109.151, -11.824)
nodes[1194] <- snowplowv3(-271.351, -109.054, -11.131)
nodes[1195] <- snowplowv3(-344.631, -108.991, -10.179)
nodes[1196] <- snowplowv3(-382.44, -109.073, -10.077)
nodes[1197] <- snowplowv3(-437.654, -109.045, -3.779)
nodes[1198] <- snowplowv3(-481.451, -112.343, -3.536)
nodes[1199] <- snowplowv3(-528.354, -112.161, -0.232)
nodes[1200] <- snowplowv3(-528.007, -115.503, -0.237)
nodes[1201] <- snowplowv3(-482.141, -115.627, -3.515)
nodes[1202] <- snowplowv3(-437.553, -113.671, -3.794)
nodes[1203] <- snowplowv3(-382.661, -114.04, -10.051)
nodes[1204] <- snowplowv3(-201.64, -131.176, -11.875)
nodes[1205] <- snowplowv3(-201.976, -193.871, -11.893)
nodes[1206] <- snowplowv3(-201.833, -275.351, -15.296)
nodes[1207] <- snowplowv3(-201.73, -309.82, -15.981)
nodes[1208] <- snowplowv3(-201.835, -357.897, -19.311)
nodes[1209] <- snowplowv3(-181.515, -382.019, -20.026)
nodes[1210] <- snowplowv3(-129.392, -382.006, -20.016)
nodes[1211] <- snowplowv3(-69.287, -382.102, -20.003)
nodes[1212] <- snowplowv3(-32.012, -382.099, -20)
nodes[1213] <- snowplowv3(6.341, -384.237, -20.005)
nodes[1214] <- snowplowv3(46.97, -391.497, -19.996)
nodes[1215] <- snowplowv3(58.683, -408.499, -20)
nodes[1216] <- snowplowv3(58.925, -446.941, -19.998)
nodes[1217] <- snowplowv3(42.058, -465.89, -19.67)
nodes[1218] <- snowplowv3(-25.372, -465.655, -16.676)
nodes[1219] <- snowplowv3(-75.08, -465.904, -15.285)
nodes[1220] <- snowplowv3(-125.436, -465.95, -14.905)
nodes[1221] <- snowplowv3(-192.709, -465.774, -15.936)
nodes[1222] <- snowplowv3(-252.278, -465.724, -15.964)
nodes[1223] <- snowplowv3(-304.626, -465.625, -15.572)
nodes[1224] <- snowplowv3(-343.337, -465.762, -15.697)
nodes[1225] <- snowplowv3(-381.526, -465.757, -17.572)
nodes[1226] <- snowplowv3(-421.359, -465.112, -18.084)
nodes[1227] <- snowplowv3(-482.725, -465.06, -19.997)
nodes[1228] <- snowplowv3(-542.783, -464.872, -19.992)
nodes[1229] <- snowplowv3(-582.203, -465.069, -20.015)
nodes[1230] <- snowplowv3(-615.977, -465.191, -20.019)
nodes[1231] <- snowplowv3(-649.851, -465.164, -20.017)
nodes[1232] <- snowplowv3(-704.198, -465.148, -22.279)
nodes[1233] <- snowplowv3(-738.517, -465.136, -22.726)
nodes[1234] <- snowplowv3(-781.043, -465.308, -24.091)
nodes[1235] <- snowplowv3(-836.958, -465.01, -26.24)
nodes[1236] <- snowplowv3(-906.607, -461.699, -34.623)
nodes[1237] <- snowplowv3( -998.707, -459.168, -34.643, true) // is tunnel
nodes[1238] <- snowplowv3(-1084.302, -429.869, -34.645, true) // is tunnel
nodes[1239] <- snowplowv3(-1149.316, -375.906, -34.645, true) // is tunnel
nodes[1240] <- snowplowv3(-1226.024,  -317.08, -34.644, true) // is tunnel
nodes[1241] <- snowplowv3(-1307.125, -294.747, -34.642, true) // is tunnel
nodes[1242] <- snowplowv3(-1403.493, -294.116, -34.397)
nodes[1243] <- snowplowv3(-1468.379, -297.022, -26.649)
nodes[1244] <- snowplowv3(-1521.275, -297.304, -20.337)
nodes[1245] <- snowplowv3(-1561.229, -297.479, -20.031)
nodes[1246] <- snowplowv3(-1612.385, -296.978, -20.106)
nodes[1247] <- snowplowv3(-1649.255, -272.017, -20.105)
nodes[1248] <- snowplowv3(-1655.364, -221.669, -20.14)
nodes[1249] <- snowplowv3(-1402.894, -13.14, -17.675)
nodes[1250] <- snowplowv3(-1456.186, -13.488, -17.684)
nodes[1251] <- snowplowv3(-1502.957, -13.515, -17.683)
nodes[1252] <- snowplowv3(-1549.744, -13.413, -17.676)
nodes[1253] <- snowplowv3(-1590.502, -13.441, -17.077)
nodes[1254] <- snowplowv3(-1640.063, -13.929, -12.396)
nodes[1255] <- snowplowv3(-1674.36, -13.578, -11.262)
nodes[1256] <- snowplowv3(-1708.59, -13.613, -9.047)
nodes[1257] <- snowplowv3(-1746.234, -13.881, -6.619)
nodes[1258] <- snowplowv3(-1777.32, -13.915, -5.779)
nodes[1259] <- snowplowv3(-1820.237, -13.541, -3.102)
nodes[1260] <- snowplowv3(-1820.762, -17.405, -3.111)
nodes[1261] <- snowplowv3(-1778.683, -17.415, -5.782)
nodes[1262] <- snowplowv3(-1746.86, -17.315, -6.582)
nodes[1263] <- snowplowv3(-1710.029, -17.388, -8.965)
nodes[1264] <- snowplowv3(-1673.978, -17.351, -11.285)
nodes[1265] <- snowplowv3(-1640.171, -17.474, -12.392)
nodes[1266] <- snowplowv3(-1589.934, -17.5, -17.132)
nodes[1267] <- snowplowv3(-1549.776, -17.871, -17.684)
nodes[1268] <- snowplowv3(-1504.088, -17.582, -17.683)
nodes[1269] <- snowplowv3(-1457.851, -17.495, -17.683)
nodes[1270] <- snowplowv3(-1400.702, -16.978, -17.676)
nodes[1271] <- snowplowv3(-1400.638, -19.807, -17.667)
nodes[1272] <- snowplowv3(-674.383, 429.555, 1.25)
nodes[1273] <- snowplowv3(-674.358, 390.148, 1.58)
nodes[1274] <- snowplowv3(-674.387, 354.817, 1.534)
nodes[1275] <- snowplowv3(-674.349, 293.108, 0.132)
nodes[1276] <- snowplowv3(-674.41, 256.195, 0.03)
nodes[1277] <- snowplowv3(-674.333, 199.769, 0.936)
nodes[1278] <- snowplowv3(-674.264, 159.017, 1.204)
nodes[1279] <- snowplowv3(-674.336, 106.978, 1.202)
nodes[1280] <- snowplowv3(-674.552, 60.735, 1.202)
nodes[1281] <- snowplowv3(-674.295, 8.965, 1.201)
nodes[1282] <- snowplowv3(-674.599, -49.141, 1.199)
nodes[1283] <- snowplowv3(-654.904, -71.253, 1.199)
nodes[1284] <- snowplowv3(-615.803, -71.309, 1.2)
nodes[1285] <- snowplowv3(-569.613, -71.497, 1.202)
nodes[1286] <- snowplowv3(-531.771, -71.349, 1.144)
nodes[1287] <- snowplowv3(-488.214, -71.288, -1.599)
nodes[1288] <- snowplowv3(-487.845, -67.053, -1.634)
nodes[1289] <- snowplowv3(-530.302, -67.06, 1.102)
nodes[1290] <- snowplowv3(-670.179, 292.501, 0.127)
nodes[1291] <- snowplowv3(-670.239, 352.457, 1.484)
nodes[1292] <- snowplowv3(-670.123, 386.641, 1.61)
nodes[1293] <- snowplowv3(-670.058, 428.35, 1.258)
nodes[1294] <- snowplowv3(-670.128, 465.944, 1.2)
nodes[1295] <- snowplowv3(-670.242, 513.607, 1.2)
nodes[1296] <- snowplowv3(-670.408, 565.086, 1.201)
nodes[1297] <- snowplowv3(-670.409, 598.87, 1.058)
nodes[1298] <- snowplowv3(-670.207, 657.36, -4.686)
nodes[1299] <- snowplowv3(-670.105, 711.756, -11.483)
nodes[1300] <- snowplowv3(-640.353, 730.023, -10.149)
nodes[1301] <- snowplowv3(-573.28, 730.08, -0.98)
nodes[1302] <- snowplowv3(-542.151, 708.515, 2.76)
nodes[1303] <- snowplowv3(-483.179, 429.739, 1.127)
nodes[1304] <- snowplowv3(-530.584, 443.97, 1.12)
nodes[1305] <- snowplowv3(-581.893, 449.255, 1.2)
nodes[1306] <- snowplowv3(-650.839, 449.386, 1.196)
nodes[1307] <- snowplowv3(-653.104, 369.159, 1.606)
nodes[1308] <- snowplowv3(-612.03, 368.994, 1.435)
nodes[1309] <- snowplowv3(-565.979, 368.795, 1.233)
nodes[1310] <- snowplowv3(-535.61, 368.746, 1.2)
nodes[1311] <- snowplowv3(-484.194, 368.958, 1.198)
nodes[1312] <- snowplowv3(-565.525, 372.879, 1.234)
nodes[1313] <- snowplowv3(-606.157, 373.116, 1.408)
nodes[1314] <- snowplowv3(-653.186, 373.101, 1.601)
nodes[1315] <- snowplowv3(-484.126, 274.706, 1.068)
nodes[1316] <- snowplowv3(-532.605, 274.777, 0.03)
nodes[1317] <- snowplowv3(-564.435, 274.849, -0.142)
nodes[1318] <- snowplowv3(-607.702, 274.715, -0.106)
nodes[1319] <- snowplowv3(-654.43, 274.758, -0.065)
nodes[1320] <- snowplowv3(-651.662, 77.368, 1.043)
nodes[1321] <- snowplowv3(-610.867, 77.121, 0.361)
nodes[1322] <- snowplowv3(-561.762, 77.292, -0.475)
nodes[1323] <- snowplowv3(-484.162, 80.933, -0.946)
nodes[1324] <- snowplowv3(-536.451, 81.246, -0.575)
nodes[1325] <- snowplowv3(-563.373, 81.151, -0.447)
nodes[1326] <- snowplowv3(-602.964, 80.951, 0.225)
nodes[1327] <- snowplowv3(-651.982, 80.978, 1.058)
nodes[1328] <- snowplowv3(-551.503, -88.366, 0.787)
nodes[1329] <- snowplowv3(-551.33, -100.004, 0.177)
nodes[1330] <- snowplowv3(-551.312, -125.224, 0.081)
nodes[1331] <- snowplowv3(-544.922, -158.631, -1.783)
nodes[1332] <- snowplowv3(-533.731, -195.2, -4.313)
nodes[1333] <- snowplowv3(-513.092, -216.506, -4.71)
nodes[1334] <- snowplowv3(-465.174, -216.191, -6.665)
nodes[1335] <- snowplowv3(-424.992, -216.286, -8.289)
nodes[1336] <- snowplowv3(-383.187, -216.422, -9.983)
nodes[1337] <- snowplowv3(-346.906, -216.36, -10.15)
nodes[1338] <- snowplowv3(-311.693, -216.363, -10.609)
nodes[1339] <- snowplowv3(-271.274, -216.374, -11.137)
nodes[1340] <- snowplowv3(-222.215, -216.347, -11.776)
nodes[1341] <- snowplowv3(-181.825, -215.987, -11.906)
nodes[1342] <- snowplowv3(-134.133, -215.846, -12.731)
nodes[1343] <- snowplowv3(-77.222, -215.834, -14.123)
nodes[1344] <- snowplowv3(-220.362, -211.974, -11.814)
nodes[1345] <- snowplowv3(-272.198, -212.018, -11.126)
nodes[1346] <- snowplowv3(-310.55, -211.911, -10.628)
nodes[1347] <- snowplowv3(-345.824, -212.083, -10.165)
nodes[1348] <- snowplowv3(-366.981, -232.819, -10.281)
nodes[1349] <- snowplowv3(-366.997, -277.369, -12.32)
nodes[1350] <- snowplowv3(-367.071, -308.401, -12.599)
nodes[1351] <- snowplowv3(-366.822, -360.051, -13.676)
nodes[1352] <- snowplowv3(-345.406, -381.537, -13.87)
nodes[1353] <- snowplowv3(-307.308, -382.06, -14.313)
nodes[1354] <- snowplowv3(-264.901, -381.989, -16.877)
nodes[1355] <- snowplowv3(-221.214, -381.982, -19.512)
nodes[1356] <- snowplowv3(63.258, -449.541, -19.998)
nodes[1357] <- snowplowv3(63.273, -405.249, -20.001)
nodes[1358] <- snowplowv3(44.164, -386.697, -20.004)
nodes[1359] <- snowplowv3(8.915, -380.334, -20.001)
nodes[1360] <- snowplowv3(-29.761, -377.801, -20)
nodes[1361] <- snowplowv3(-69.197, -377.923, -19.994)
nodes[1362] <- snowplowv3(-127.34, -378.089, -20.013)
nodes[1363] <- snowplowv3(-176.43, -378.016, -20.028)
nodes[1364] <- snowplowv3(-220.518, -378.029, -19.552)
nodes[1365] <- snowplowv3(-264.853, -378.03, -16.875)
nodes[1366] <- snowplowv3(-304.764, -378.011, -14.469)
nodes[1367] <- snowplowv3(-344.93, -377.719, -13.873)
nodes[1368] <- snowplowv3(-362.579, -360.359, -13.678)
nodes[1369] <- snowplowv3(-362.383, -310.22, -12.63)
nodes[1370] <- snowplowv3(-362.641, -276.785, -12.308)
nodes[1371] <- snowplowv3(-359.613, -233.264, -10.303)
nodes[1372] <- snowplowv3(-362.596, -195.45, -10.114)
nodes[1373] <- snowplowv3(-362.72, -132.196, -10.113)
nodes[1374] <- snowplowv3(-362.275, -91.5, -9.667)
nodes[1375] <- snowplowv3(-362.599, -42.638, -5.481)
nodes[1376] <- snowplowv3(-366.998, -131.197, -10.111)
nodes[1377] <- snowplowv3(-366.957, -195.265, -10.113)
nodes[1378] <- snowplowv3(-383.096, -21.71, -4.681)
nodes[1379] <- snowplowv3(-432.051, -21.497, -1.749)
nodes[1380] <- snowplowv3(-432.418, -24.688, -1.732)
nodes[1381] <- snowplowv3(-383.973, -24.617, -4.621)
nodes[1382] <- snowplowv3(-344.976, -24.694, -5.184)
nodes[1383] <- snowplowv3(-292.421, -24.766, -8.469)
nodes[1384] <- snowplowv3(-223.581, -24.788, -11.751)
nodes[1385] <- snowplowv3(-201.612, -41.415, -11.871)
nodes[1386] <- snowplowv3(-201.694, -91.625, -11.875)
nodes[1387] <- snowplowv3(-197.118, -357.509, -19.287)
nodes[1388] <- snowplowv3(-197.202, -312.005, -16.124)
nodes[1389] <- snowplowv3(-197.286, -279.688, -15.633)
nodes[1390] <- snowplowv3(-197.408, -235.427, -12.341)
nodes[1391] <- snowplowv3(-197.185, -195.321, -11.882)
nodes[1392] <- snowplowv3(-197.403, -132.281, -11.876)
nodes[1393] <- snowplowv3(-178.811, -113.901, -11.986)
nodes[1394] <- snowplowv3(-123.918, -113.467, -13.146)
nodes[1395] <- snowplowv3(-78.185, -113.507, -14.106)
nodes[1396] <- snowplowv3(-32.132, -113.755, -14.711)
nodes[1397] <- snowplowv3(25.208, -113.72, -17.739)
nodes[1398] <- snowplowv3(45.467, -110.465, -18.031)
nodes[1399] <- snowplowv3(49.424, -92.354, -17.849)
nodes[1400] <- snowplowv3(49.572, -47.015, -16.052)
nodes[1401] <- snowplowv3(49.482, -12.502, -14.68)
nodes[1402] <- snowplowv3(49.609, 29.273, -13.018)
nodes[1403] <- snowplowv3(49.614, 63.559, -12.862)
nodes[1404] <- snowplowv3(49.479, 124.692, -14.047)
nodes[1405] <- snowplowv3(49.532, 201.783, -15.814)
nodes[1406] <- snowplowv3(27.485, 221.292, -15.82)
nodes[1407] <- snowplowv3(-22.354, 221.259, -15.137)
nodes[1408] <- snowplowv3(-67.644, 221.299, -14.515)
nodes[1409] <- snowplowv3(-116.738, 221.176, -13.847)
nodes[1410] <- snowplowv3(-131.382, 234.441, -13.773)
nodes[1411] <- snowplowv3(-127.8, 270.653, -12.092)
nodes[1412] <- snowplowv3(-127.889, 305.63, -12.124)
nodes[1413] <- snowplowv3(-128.004, 350.663, -13.773)
nodes[1414] <- snowplowv3(-115.899, 361.732, -13.825)
nodes[1415] <- snowplowv3(-78.325, 361.718, -13.824)
nodes[1416] <- snowplowv3(-39.842, 361.896, -13.821)
nodes[1417] <- snowplowv3(-6.023, 361.875, -13.825)
nodes[1418] <- snowplowv3(23.88, 361.715, -13.826)
nodes[1419] <- snowplowv3(-131.248, 306.41, -12.145)
nodes[1420] <- snowplowv3(-131.661, 350.515, -13.768)
nodes[1421] <- snowplowv3(-116.094, 364.815, -13.824)
nodes[1422] <- snowplowv3(-85.971, 364.967, -13.826)
nodes[1423] <- snowplowv3(-39.759, 364.962, -13.823)
nodes[1424] <- snowplowv3(-18.9, 386.563, -13.819)
nodes[1425] <- snowplowv3(-19.25, 409.464, -13.828)
nodes[1426] <- snowplowv3(-5.558, 422.376, -13.911)
nodes[1427] <- snowplowv3(31.41, 422.093, -16.533)
nodes[1428] <- snowplowv3(49.11, 447.641, -16.498)
nodes[1429] <- snowplowv3(49.192, 488.488, -17.122)
nodes[1430] <- snowplowv3(49.085, 528.53, -18.872)
nodes[1431] <- snowplowv3(25.861, 545.175, -18.987)
nodes[1432] <- snowplowv3(-18.642, 544.98, -19.312)
nodes[1433] <- snowplowv3(-58.276, 544.918, -19.601)
nodes[1434] <- snowplowv3(-95.667, 544.825, -19.874)
nodes[1435] <- snowplowv3(-132.264, 545.652, -20.09)
nodes[1436] <- snowplowv3(-162.378, 570.758, -20.118)
nodes[1437] <- snowplowv3(-164.911, 619.241, -20.019)
nodes[1438] <- snowplowv3(-165.173, 662.634, -20.084)
nodes[1439] <- snowplowv3(-165.191, 708.308, -20.255)
nodes[1440] <- snowplowv3(-165.107, 746.143, -20.455)
nodes[1441] <- snowplowv3(-164.947, 782.646, -20.641)
nodes[1442] <- snowplowv3(-167.902, 664.775, -20.094)
nodes[1443] <- snowplowv3(-187.664, 640.33, -19.975)
nodes[1444] <- snowplowv3(-209.685, 640.343, -19.973)
nodes[1445] <- snowplowv3(-229.573, 652.279, -20.003)
nodes[1446] <- snowplowv3(-36.309, 658.545, -19.956)
nodes[1447] <- snowplowv3(-36.258, 689.689, -21.857)
nodes[1448] <- snowplowv3(-36.038, 733.538, -21.842)
nodes[1449] <- snowplowv3(-36.345, 802.625, -23.934)
nodes[1450] <- snowplowv3(-54.657, 826.281, -24.315)
nodes[1451] <- snowplowv3(-94.602, 816.558, -22.689)
nodes[1452] <- snowplowv3(-145.436, 804.582, -20.852)
nodes[1453] <- snowplowv3(35.127, 690.242, -21.277)
nodes[1454] <- snowplowv3(38.531, 658.794, -19.905)
nodes[1455] <- snowplowv3(41.698, 657.651, -19.896)
nodes[1456] <- snowplowv3(38.679, 688.906, -21.193)
nodes[1457] <- snowplowv3(18.352, 709.033, -21.732)
nodes[1458] <- snowplowv3(-18.432, 709.108, -21.804)
nodes[1459] <- snowplowv3(-55.67, 719.05, -21.786)
nodes[1460] <- snowplowv3(-88.932, 718.991, -21.338)
nodes[1461] <- snowplowv3(-146.588, 691.868, -20.219)
nodes[1462] <- snowplowv3(30.245, 803.778, -24.108)
nodes[1463] <- snowplowv3(30.432, 765.573, -22.541)
nodes[1464] <- snowplowv3(34.154, 726.098, -21.872)
nodes[1465] <- snowplowv3(-15.826, 386.836, -13.819)
nodes[1466] <- snowplowv3(-15.751, 406.411, -13.821)
nodes[1467] <- snowplowv3(-5.27, 418.743, -13.918)
nodes[1468] <- snowplowv3(43.664, 423.311, -16.523)
nodes[1469] <- snowplowv3(52.74, 447.305, -16.495)
nodes[1470] <- snowplowv3(52.563, 489.163, -17.156)
nodes[1471] <- snowplowv3(52.48, 526.538, -18.79)
nodes[1472] <- snowplowv3(49.013, 586.66, -19.744)
nodes[1473] <- snowplowv3(48.856, 619.343, -19.991)
nodes[1474] <- snowplowv3(120.086, 679.745, -17.188)
nodes[1475] <- snowplowv3(126.359, 720.11, -16.529)
nodes[1476] <- snowplowv3(126.457, 799.467, -19.509)
nodes[1477] <- snowplowv3(-18.675, 823.047, -24.504)
nodes[1478] <- snowplowv3(10.679, 822.984, -24.508)
nodes[1479] <- snowplowv3(43.442, 822.921, -24.396)
nodes[1480] <- snowplowv3(78.003, 818.939, -22.042)
nodes[1481] <- snowplowv3(111.166, 819.089, -19.751)
nodes[1482] <- snowplowv3(380.737, 692.721, -24.728)
nodes[1483] <- snowplowv3(355.44, 692.614, -24.724)
nodes[1484] <- snowplowv3(318.672, 692.437, -24.708)
nodes[1485] <- snowplowv3(290.829, 692.674, -24.67)
nodes[1486] <- snowplowv3(249.511, 692.693, -24.303)
nodes[1487] <- snowplowv3(180.985, 692.641, -21.785)
nodes[1488] <- snowplowv3(156.266, 681.593, -19.88)
nodes[1489] <- snowplowv3(141.145, 661.824, -18.873)
nodes[1490] <- snowplowv3(125.189, 662.937, -18.145)
nodes[1491] <- snowplowv3(337.451, 641.871, -24.563)
nodes[1492] <- snowplowv3(337.567, 670.738, -24.698)
nodes[1493] <- snowplowv3(333.51, 673.002, -24.7)
nodes[1494] <- snowplowv3(333.476, 644.421, -24.585)
nodes[1495] <- snowplowv3(270.798, 239.726, -22.922)
nodes[1496] <- snowplowv3(270.727, 282.538, -21.416)
nodes[1497] <- snowplowv3(270.612, 323.051, -21.394)
nodes[1498] <- snowplowv3(270.652, 370.122, -21.385)
nodes[1499] <- snowplowv3(269.9, 426.668, -20.328)
nodes[1500] <- snowplowv3(269.957, 463.685, -20.195)
nodes[1501] <- snowplowv3(269.758, 528.688, -22.929)
nodes[1502] <- snowplowv3(269.711, 598.16, -24.413)
nodes[1503] <- snowplowv3(285.26, 621.206, -24.423)
nodes[1504] <- snowplowv3(311.019, 620.933, -24.492)
nodes[1505] <- snowplowv3(352.558, 621.025, -24.566)
nodes[1506] <- snowplowv3(389.807, 621.33, -24.735)
nodes[1507] <- snowplowv3(401.083, 667.28, -24.734)
nodes[1508] <- snowplowv3(401.694, 707.872, -24.632)
nodes[1509] <- snowplowv3(422.194, 738.507, -21.585)
nodes[1510] <- snowplowv3(461.471, 740.214, -21.084)
nodes[1511] <- snowplowv3(517.383, 740.686, -20.834)
nodes[1512] <- snowplowv3(582.396, 764.52, -17.235)
nodes[1513] <- snowplowv3(624.226, 834.472, -13.033)
nodes[1514] <- snowplowv3(620.136, 837.054, -12.923)
nodes[1515] <- snowplowv3(591.128, 777.358, -16.46)
nodes[1516] <- snowplowv3(529.039, 746.016, -20.181)
nodes[1517] <- snowplowv3(467.361, 744.281, -21.085)
nodes[1518] <- snowplowv3(424.975, 743.35, -21.347)
nodes[1519] <- snowplowv3(397.277, 714.077, -24.278)
nodes[1520] <- snowplowv3(445.911, 761.474, -21.091)
nodes[1521] <- snowplowv3(445.992, 798.675, -21.087)
nodes[1522] <- snowplowv3(425.566, 808.857, -21.087)
nodes[1523] <- snowplowv3(365.452, 802.998, -21.094)
nodes[1524] <- snowplowv3(343.868, 816.688, -21.088)
nodes[1525] <- snowplowv3(344.011, 839.875, -21.089)
nodes[1526] <- snowplowv3(340.757, 843.868, -21.089)
nodes[1527] <- snowplowv3(340.763, 820.406, -21.09)
nodes[1528] <- snowplowv3(356.078, 799.027, -21.086)
nodes[1529] <- snowplowv3(395.593, 802.676, -21.083)
nodes[1530] <- snowplowv3(436.954, 806.178, -21.092)
nodes[1531] <- snowplowv3(442.538, 765.015, -21.088)
nodes[1532] <- snowplowv3(609.35, 858.734, -12.475)
nodes[1533] <- snowplowv3(559.898, 859.951, -12.496)
nodes[1534] <- snowplowv3(489.848, 860.28, -15.958)
nodes[1535] <- snowplowv3(421.398, 861.226, -17.371)
nodes[1536] <- snowplowv3(365.41, 861.512, -20.54)
nodes[1537] <- snowplowv3(327.117, 861.711, -21.112)
nodes[1538] <- snowplowv3(287.682, 860.825, -20.873)
nodes[1539] <- snowplowv3(250.05, 844.612, -19.826)
nodes[1540] <- snowplowv3(207.059, 826.967, -19.424)
nodes[1541] <- snowplowv3(149.105, 826.86, -19.495)
nodes[1542] <- snowplowv3(110.378, 826.806, -19.773)
nodes[1543] <- snowplowv3(48.102, 826.648, -24.079)
nodes[1544] <- snowplowv3(13.768, 826.513, -24.514)
nodes[1545] <- snowplowv3(-16.996, 826.437, -24.512)
nodes[1546] <- snowplowv3(-17.695, 818.936, -24.547)
nodes[1547] <- snowplowv3(10.809, 819.185, -24.548)
nodes[1548] <- snowplowv3(146.822, 822.588, -19.498)
nodes[1549] <- snowplowv3(204.779, 822.771, -19.41)
nodes[1550] <- snowplowv3(241.444, 832.708, -19.681)
nodes[1551] <- snowplowv3(267.426, 852.87, -20.232)
nodes[1552] <- snowplowv3(325.112, 857.731, -21.123)
nodes[1553] <- snowplowv3(361.861, 857.723, -20.796)
nodes[1554] <- snowplowv3(409.442, 857.539, -17.686)
nodes[1555] <- snowplowv3(471.31, 857.322, -17.007)
nodes[1556] <- snowplowv3(532.579, 856.502, -12.746)
nodes[1557] <- snowplowv3(603.372, 854.781, -12.507)
nodes[1558] <- snowplowv3(639.226, 854.476, -12.414)
nodes[1559] <- snowplowv3(668.938, 854.483, -11.922)
nodes[1560] <- snowplowv3(684.704, 874.813, -11.921)
nodes[1561] <- snowplowv3(694.078, 888.324, -11.92)
nodes[1562] <- snowplowv3(702.952, 871.729, -11.914)
nodes[1563] <- snowplowv3(689.716, 855.001, -11.917)
nodes[1564] <- snowplowv3(722.656, 855.004, -11.92)
nodes[1565] <- snowplowv3(780.236, 855.044, -11.92)
nodes[1566] <- snowplowv3(855.542, 855.49, -11.895)
nodes[1567] <- snowplowv3(918.389, 865.093, -10.294)
nodes[1568] <- snowplowv3(974.909, 892.541, -6.015)
nodes[1569] <- snowplowv3(1027.986, 942.316, -2.657)
nodes[1570] <- snowplowv3(1081.103, 999.576, -1.221)
nodes[1571] <- snowplowv3(1132.231, 1055.697, -0.062)
nodes[1572] <- snowplowv3(1183.039, 1111.272, 1.256)
nodes[1573] <- snowplowv3(1232.304, 1143.026, 0.294)
nodes[1574] <- snowplowv3(1273.581, 1169.772, 0.877)
nodes[1575] <- snowplowv3(1295.191, 1217.931, 0.505)
nodes[1576] <- snowplowv3(1278.378, 1254.896, 1.381)
nodes[1577] <- snowplowv3(1244.773, 1273.671, 0.83)
nodes[1578] <- snowplowv3(1244.416, 1262.062, 1.036)
nodes[1579] <- snowplowv3(1264.698, 1260.538, 1.372)
nodes[1580] <- snowplowv3(1290.229, 1208.297, 0.593)
nodes[1581] <- snowplowv3(1250.833, 1158.748, 0.52)
nodes[1582] <- snowplowv3(1211.125, 1135.455, 0.925)
nodes[1583] <- snowplowv3(1171.594, 1105.444, 1.181)
nodes[1584] <- snowplowv3(1120.075, 1048.225, -0.269)
nodes[1585] <- snowplowv3(1064.464, 987.301, -1.599)
nodes[1586] <- snowplowv3(1006.214, 924.209, -3.278)
nodes[1587] <- snowplowv3(947.83, 880.575, -8.633)
nodes[1588] <- snowplowv3(888.078, 860.923, -10.881)
nodes[1589] <- snowplowv3(822.704, 858.481, -11.92)
nodes[1590] <- snowplowv3(727.163, 858.708, -11.872)
nodes[1591] <- snowplowv3(694.622, 858.54, -11.919)
nodes[1592] <- snowplowv3(669.226, 858.606, -11.923)
nodes[1593] <- snowplowv3(641.737, 858.56, -12.331)
nodes[1594] <- snowplowv3( -644.843,  919.332,  -18.761 );
nodes[1595] <- snowplowv3( -699.321,  919.030,  -18.755 );
nodes[1596] <- snowplowv3( -730.654,  919.230,  -18.752 );
nodes[1597] <- snowplowv3( -745.153,  903.165,  -18.746 );
nodes[1598] <- snowplowv3( -744.902,  850.285,  -18.758 );
nodes[1599] <- snowplowv3( -744.951,  818.820,  -18.763 );
nodes[1600] <- snowplowv3( -729.844,  800.732,  -18.750 );
nodes[1601] <- snowplowv3( -678.640,  800.817,  -18.753 );
nodes[1602] <- snowplowv3( -646.380,  800.722,  -18.755 );
nodes[1603] <- snowplowv3( -630.770,  815.672,  -18.756 );
nodes[1604] <- snowplowv3( -630.701,  868.235,  -18.751 );
nodes[1605] <- snowplowv3( -630.287,  900.376,  -18.755 );
nodes[1606] <- snowplowv3( 250.891,  448.385,  -20.003  );
nodes[1607] <- snowplowv3( 225.821,  434.638,  -19.995  );
nodes[1608] <- snowplowv3( 212.749,  420.472,  -19.981  );
nodes[1609] <- snowplowv3( 185.841,  420.533,  -19.835  );
nodes[1610] <- snowplowv3( 170.560,  404.169,  -19.842  );
nodes[1611] <- snowplowv3( 169.532,  351.630,  -19.838  );
nodes[1612] <- snowplowv3( 169.573,  306.238,  -19.863  );
nodes[1613] <- snowplowv3( 168.784,  236.904,  -19.745  );
nodes[1614] <- snowplowv3( 172.096,  237.627,  -19.734  );
nodes[1615] <- snowplowv3( 172.275,  291.448,  -19.852  );
nodes[1616] <- snowplowv3( 172.445,  340.643,  -19.824  );
nodes[1617] <- snowplowv3( 173.029,  401.463,  -19.843  );
nodes[1618] <- snowplowv3( 185.110,  416.499,  -19.824  );
nodes[1619] <- snowplowv3( 214.438,  416.476,  -19.989  );
nodes[1620] <- snowplowv3( 229.525,  431.663,  -19.997  );
nodes[1621] <- snowplowv3( 247.152,  444.552,  -20.003  );
nodes[1622] <- snowplowv3( 280.763,  395.520,  -21.361  );
nodes[1623] <- snowplowv3( 314.925,  381.685,  -20.244  );
nodes[1624] <- snowplowv3( 359.041,  382.540,  -19.381  );
nodes[1625] <- snowplowv3( 364.072,  431.095,  -20.983  );
nodes[1626] <- snowplowv3( -37.442,  216.939,  -14.930  );
nodes[1627] <- snowplowv3( 23.530,  216.842,  -15.759   );
nodes[1628] <- snowplowv3( 67.358,  216.859,  -16.229   );
nodes[1629] <- snowplowv3( 112.613,  216.944,  -19.533  );
nodes[1630] <- snowplowv3( 146.329,  217.049,  -19.865  );
nodes[1631] <- snowplowv3( 181.919,  217.636,  -19.869  );
nodes[1632] <- snowplowv3( 199.550,  235.264,  -19.870  );
nodes[1633] <- snowplowv3( 208.675,  259.998,  -20.030  );
nodes[1634] <- snowplowv3( 247.588,  262.886,  -21.301  );
nodes[1635] <- snowplowv3( 251.471,  267.610,  -21.350  );
nodes[1636] <- snowplowv3( 210.587,  266.014,  -20.026  );
nodes[1637] <- snowplowv3( 194.564,  236.480,  -19.864  );
nodes[1638] <- snowplowv3( 152.175,  221.499,  -19.861  );
nodes[1639] <- snowplowv3( 114.015,  221.747,  -19.645  );
nodes[1640] <- snowplowv3( 431.111,  150.339,  -20.174  );
nodes[1641] <- snowplowv3( 390.246,  150.711,  -21.004  );
nodes[1642] <- snowplowv3( 322.893,  148.289,  -21.052  );
nodes[1643] <- snowplowv3( 316.638,  126.890,  -21.185  );
nodes[1644] <- snowplowv3( 318.070,  108.535,  -21.224  );
nodes[1645] <- snowplowv3( 323.938,  129.833,  -21.221  );
nodes[1646] <- snowplowv3( 337.269,  145.982,  -21.086  );
nodes[1647] <- snowplowv3( 378.109,  146.391,  -21.009  );
nodes[1648] <- snowplowv3( 429.061,  146.164,  -20.211  );
nodes[1649] <- snowplowv3( 401.204,  -103.264,  -6.884  );
nodes[1650] <- snowplowv3( 426.269,  -58.198,  -15.557  );
nodes[1651] <- snowplowv3( 446.425,  2.856,  -24.810    );
nodes[1652] <- snowplowv3( 425.486,  23.459,  -24.859   );
nodes[1653] <- snowplowv3( 381.928,  23.456,  -24.351   );
nodes[1654] <- snowplowv3( 362.785,  36.901,  -24.011   );
nodes[1655] <- snowplowv3( 371.000,  50.596,  -23.839   );
nodes[1656] <- snowplowv3( 400.780,  50.395,  -23.480   );
nodes[1657] <- snowplowv3( 439.384,  51.019,  -23.011   );
nodes[1658] <- snowplowv3( 450.241,  81.714,  -21.973   );
nodes[1659] <- snowplowv3( 450.359,  130.936,  -20.001  );
nodes[1660] <- snowplowv3( 450.448,  161.542,  -19.864  );
nodes[1661] <- snowplowv3( 450.506,  193.332,  -19.938  );
nodes[1662] <- snowplowv3( 431.793,  220.212,  -20.086  );
nodes[1663] <- snowplowv3( 395.422,  220.422,  -20.722  );
nodes[1664] <- snowplowv3( 358.446,  220.473,  -21.365  );
nodes[1665] <- snowplowv3( 293.362,  220.536,  -23.105  );
nodes[1666] <- snowplowv3( 266.262,  239.651,  -22.703  );
nodes[1667] <- snowplowv3( 266.152,  201.471,  -23.026  );
nodes[1668] <- snowplowv3( 263.583,  142.933,  -21.330  );
nodes[1669] <- snowplowv3( 234.248,  119.834,  -19.980  );
nodes[1670] <- snowplowv3( 194.956,  106.727,  -19.004  );
nodes[1671] <- snowplowv3( 183.672,  42.176,  -20.051   );
nodes[1672] <- snowplowv3( 201.141,  19.796,  -20.209   );
nodes[1673] <- snowplowv3( 244.165,  19.954,  -22.720   );
nodes[1674] <- snowplowv3( 277.880,  20.011,  -23.197   );
nodes[1675] <- snowplowv3( 339.900,  19.572,  -23.886   );
nodes[1676] <- snowplowv3( 344.973,  22.753,  -23.931   );
nodes[1677] <- snowplowv3( 285.092,  23.583,  -23.274   );
nodes[1678] <- snowplowv3( 261.980,  6.208,  -22.955    );
nodes[1679] <- snowplowv3( 261.373,  -41.634,  -17.964  );
nodes[1680] <- snowplowv3( 261.717,  -110.275,  -12.282 );
nodes[1681] <- snowplowv3( 261.633,  -143.081,  -12.034 );
nodes[1682] <- snowplowv3( 263.922,  -172.803,  -12.042 );
nodes[1683] <- snowplowv3( 323.897,  -179.598,  -6.641  );
nodes[1684] <- snowplowv3( 356.786,  -179.330,  -6.462  );
nodes[1685] <- snowplowv3( 383.076,  -179.716,  -6.469  );
nodes[1686] <- snowplowv3( 400.949,  -168.022,  -6.461  );
nodes[1687] <- snowplowv3( 344.965,  -161.849,  -6.395  );
nodes[1688] <- snowplowv3( 346.567,  -128.774,  -6.583  );
nodes[1689] <- snowplowv3( 379.500,  -122.635,  -6.498  );
nodes[1690] <- snowplowv3( 413.576,  -155.644,  -6.709  );
nodes[1691] <- snowplowv3( 454.729,  -155.784,  -13.104 );
nodes[1692] <- snowplowv3( 501.682,  -155.766,  -19.263 );
nodes[1693] <- snowplowv3( 547.511,  -156.005,  -20.001 );
nodes[1694] <- snowplowv3( 564.315,  -171.479,  -19.994 );
nodes[1695] <- snowplowv3( 564.303,  -220.232,  -20.000 );
nodes[1696] <- snowplowv3( 564.439,  -262.127,  -20.008 );
nodes[1697] <- snowplowv3( 564.451,  -295.207,  -20.000 );
nodes[1698] <- snowplowv3( 564.316,  -335.116,  -19.998 );
nodes[1699] <- snowplowv3( 564.450,  -374.237,  -20.000 );
nodes[1700] <- snowplowv3( 551.549,  -389.934,  -19.992 );
nodes[1701] <- snowplowv3( 507.565,  -389.942,  -19.999 );
nodes[1702] <- snowplowv3( 427.146,  -389.888,  -19.998 );
nodes[1703] <- snowplowv3( 307.809,  -389.905,  -19.998 );
nodes[1704] <- snowplowv3( 273.984,  -396.634,  -19.998 );
nodes[1705] <- snowplowv3( 233.254,  -396.404,  -19.914 );
nodes[1706] <- snowplowv3( 175.292,  -396.154,  -19.998 );
nodes[1707] <- snowplowv3( 156.500,  -408.311,  -19.988 );
nodes[1708] <- snowplowv3( 156.369,  -449.423,  -19.993 );
nodes[1709] <- snowplowv3( 142.552,  -465.951,  -20.315 );
nodes[1710] <- snowplowv3( 84.677,  -465.775,  -20.777  );
nodes[1711] <- snowplowv3( -47.235,  -450.886,  -16.147 );
nodes[1712] <- snowplowv3( -46.898,  -398.222,  -19.896 );
nodes[1713] <- snowplowv3( -50.694,  -397.909,  -19.880 );
nodes[1714] <- snowplowv3( -50.917,  -451.604,  -16.078 );
nodes[1715] <- snowplowv3( 169.200,  -469.757,  -19.999 );
nodes[1716] <- snowplowv3( 219.918,  -469.874,  -19.998 );
nodes[1717] <- snowplowv3( 269.966,  -469.900,  -19.999 );
nodes[1718] <- snowplowv3( 304.917,  -469.814,  -20.000 );
nodes[1719] <- snowplowv3( 361.555,  -469.638,  -19.995 );
nodes[1720] <- snowplowv3( 446.332,  -469.790,  -20.000 );
nodes[1721] <- snowplowv3( 542.478,  -469.890,  -19.999 );
nodes[1722] <- snowplowv3( 568.069,  -450.902,  -19.989 );
nodes[1723] <- snowplowv3( 568.261,  -411.088,  -19.999 );
nodes[1724] <- snowplowv3( 564.339,  -402.441,  -19.995 );
nodes[1725] <- snowplowv3( 563.927,  -449.908,  -20.003 );
nodes[1726] <- snowplowv3( 549.926,  -466.199,  -20.001 );
nodes[1727] <- snowplowv3( 493.020,  -465.735,  -20.000 );
nodes[1728] <- snowplowv3( 411.944,  -465.725,  -19.999 );
nodes[1729] <- snowplowv3( 316.964,  -465.907,  -19.998 );
nodes[1730] <- snowplowv3( 277.400,  -466.024,  -19.995 );
nodes[1731] <- snowplowv3( 233.375,  -465.682,  -19.999 );
nodes[1732] <- snowplowv3( 176.220,  -465.865,  -20.000 );
nodes[1733] <- snowplowv3( 292.603,  -449.571,  -19.995 );
nodes[1734] <- snowplowv3( 292.795,  -414.373,  -19.993 );
nodes[1735] <- snowplowv3( 292.680,  -379.794,  -19.999 );
nodes[1736] <- snowplowv3( 292.635,  -313.467,  -20.006 );
nodes[1737] <- snowplowv3( 288.756,  -305.395,  -19.999 );
nodes[1738] <- snowplowv3( 288.717,  -373.386,  -19.997 );
nodes[1739] <- snowplowv3( 288.672,  -408.356,  -19.999 );
nodes[1740] <- snowplowv3( 288.543,  -442.972,  -19.998 );
nodes[1741] <- snowplowv3( 580.941,  -469.832,  -20.001 );
nodes[1742] <- snowplowv3( 678.038,  -469.223,  -19.996 );
nodes[1743] <- snowplowv3( 753.163,  -464.143,  -19.996 );
nodes[1744] <- snowplowv3( 812.791,  -458.685,  -19.993 );
nodes[1745] <- snowplowv3( 818.856,  -377.717,  -19.994 );
nodes[1746] <- snowplowv3( 819.050,  -304.561,  -20.007 );
nodes[1747] <- snowplowv3( 801.013,  -279.509,  -19.994 );
nodes[1748] <- snowplowv3( 757.995,  -279.447,  -19.998 );
nodes[1749] <- snowplowv3( 722.875,  -279.380,  -19.996 );
nodes[1750] <- snowplowv3( 664.515,  -279.488,  -20.000 );
nodes[1751] <- snowplowv3( 590.060,  -279.385,  -19.996 );
nodes[1752] <- snowplowv3( 552.494,  -279.204,  -20.001 );
nodes[1753] <- snowplowv3( 531.476,  -294.536,  -20.003 );
nodes[1754] <- snowplowv3( 498.732,  -313.912,  -19.990 );
nodes[1755] <- snowplowv3( 436.831,  -313.690,  -19.978 );
nodes[1756] <- snowplowv3( 363.554,  -313.789,  -19.964 );
nodes[1757] <- snowplowv3( 335.095,  -301.570,  -19.894 );
nodes[1758] <- snowplowv3( 309.838,  -285.784,  -19.990 );
nodes[1759] <- snowplowv3( 305.167,  -290.779,  -19.994 );
nodes[1760] <- snowplowv3( 322.956,  -297.315,  -19.998 );
nodes[1761] <- snowplowv3( 344.860,  -314.455,  -20.034 );
nodes[1762] <- snowplowv3( 392.204,  -317.866,  -19.987 );
nodes[1763] <- snowplowv3( 449.391,  -317.600,  -19.991 );
nodes[1764] <- snowplowv3( 506.711,  -316.930,  -20.001 );
nodes[1765] <- snowplowv3( 533.315,  -298.023,  -20.016 );
nodes[1766] <- snowplowv3( 546.629,  -284.073,  -20.006 );
nodes[1767] <- snowplowv3( 579.074,  -283.353,  -19.995 );
nodes[1768] <- snowplowv3( 633.561,  -283.424,  -19.994 );
nodes[1769] <- snowplowv3( 702.487,  -283.507,  -19.997 );
nodes[1770] <- snowplowv3( 752.598,  -283.339,  -19.994 );
nodes[1771] <- snowplowv3( 795.096,  -283.369,  -19.997 );
nodes[1772] <- snowplowv3( 815.048,  -298.449,  -19.991 );
nodes[1773] <- snowplowv3( 814.975,  -359.048,  -19.993 );
nodes[1774] <- snowplowv3( 813.500,  -453.394,  -20.002 );
nodes[1775] <- snowplowv3( 733.363,  -461.827,  -19.991 );
nodes[1776] <- snowplowv3( 666.657,  -465.470,  -19.995 );
nodes[1777] <- snowplowv3( 588.510,  -465.931,  -19.998 );
nodes[1778] <- snowplowv3( 832.369,  -283.235,  -19.998 );
nodes[1779] <- snowplowv3( 846.987,  -264.037,  -20.111 );
nodes[1780] <- snowplowv3( 846.986,  -186.782,  -22.866 );
nodes[1781] <- snowplowv3( 847.163,  -105.210,  -24.052 );
nodes[1782] <- snowplowv3( 832.790,  -52.286,  -21.565  );
nodes[1783] <- snowplowv3( 819.865,  3.139,  -19.373    );
nodes[1784] <- snowplowv3( 802.121,  23.245,  -19.320   );
nodes[1785] <- snowplowv3( 753.520,  23.286,  -19.312   );
nodes[1786] <- snowplowv3( 714.862,  23.162,  -18.848   );
nodes[1787] <- snowplowv3( 655.867,  23.363,  -18.116   );
nodes[1788] <- snowplowv3( 589.002,  23.262,  -18.116   );
nodes[1789] <- snowplowv3( 551.882,  23.396,  -18.144   );
nodes[1790] <- snowplowv3( 510.699,  23.304,  -19.573   );
nodes[1791] <- snowplowv3( 465.717,  23.358,  -24.550   );
nodes[1792] <- snowplowv3( 458.228,  19.845,  -24.922   );
nodes[1793] <- snowplowv3( 510.545,  19.386,  -19.491   );
nodes[1794] <- snowplowv3( 545.077,  18.914,  -18.213   );
nodes[1795] <- snowplowv3( 579.149,  19.168,  -18.115   );
nodes[1796] <- snowplowv3( 627.716,  19.234,  -18.115   );
nodes[1797] <- snowplowv3( 706.785,  19.162,  -18.777   );
nodes[1798] <- snowplowv3( 748.994,  19.199,  -19.318   );
nodes[1799] <- snowplowv3( 799.956,  19.327,  -19.310   );
nodes[1800] <- snowplowv3( 815.224,  6.338,  -19.358    );
nodes[1801] <- snowplowv3( 822.536,  -40.642,  -21.011  );
nodes[1802] <- snowplowv3( 841.126,  -77.104,  -22.854  );
nodes[1803] <- snowplowv3( 842.769,  -122.493,  -23.915 );
nodes[1804] <- snowplowv3( 842.845,  -197.444,  -22.691 );
nodes[1805] <- snowplowv3( 840.219,  -276.925,  -19.993 );
nodes[1806] <- snowplowv3( 567.957,  -139.217,  -19.990 );
nodes[1807] <- snowplowv3( 568.158,  -80.990,  -19.268  );
nodes[1808] <- snowplowv3( 567.970,  -34.105,  -18.097  );
nodes[1809] <- snowplowv3( 568.464,  2.328,  -18.114    );
nodes[1810] <- snowplowv3( 564.886,  5.743,  -18.114    );
nodes[1811] <- snowplowv3( 564.269,  -24.623,  -18.097  );
nodes[1812] <- snowplowv3( 564.306,  -72.275,  -19.008  );
nodes[1813] <- snowplowv3( 564.383,  -130.396,  -19.998 );
nodes[1814] <- snowplowv3( 274.388,  -285.278,  -19.997 );
nodes[1815] <- snowplowv3( 243.211,  -285.973,  -20.007 );
nodes[1816] <- snowplowv3( 226.532,  -269.275,  -19.991 );
nodes[1817] <- snowplowv3( 224.384,  -210.316,  -20.000 );
nodes[1818] <- snowplowv3( 201.811,  -172.789,  -19.998 );
nodes[1819] <- snowplowv3( 188.363,  -147.217,  -20.000 );
nodes[1820] <- snowplowv3( 202.885,  -129.484,  -19.552 );
nodes[1821] <- snowplowv3( 245.906,  -129.597,  -12.369 );
nodes[1822] <- snowplowv3( 217.178,  -200.961,  -19.997 );
nodes[1823] <- snowplowv3( 222.465,  -266.816,  -20.009 );
nodes[1824] <- snowplowv3( 239.846,  -290.653,  -19.991 );
nodes[1825] <- snowplowv3( 270.466,  -290.613,  -20.003 );
nodes[1826] <- snowplowv3( 209.979,  -284.256,  -20.005 );
nodes[1827] <- snowplowv3( 179.214,  -272.843,  -19.994 );
nodes[1828] <- snowplowv3( 140.461,  -273.324,  -20.004 );
nodes[1829] <- snowplowv3( 114.871,  -281.224,  -20.002 );
nodes[1830] <- snowplowv3( 83.515,  -286.920,  -19.992  );
nodes[1831] <- snowplowv3( 32.291,  -286.790,  -19.749  );
nodes[1832] <- snowplowv3( -29.634,  -290.206,  -14.639 );
nodes[1833] <- snowplowv3( -73.409,  -293.515,  -14.268 );
nodes[1834] <- snowplowv3( -127.601,  -293.116,  -14.924);
nodes[1835] <- snowplowv3( -177.250,  -293.233,  -15.708);
nodes[1836] <- snowplowv3( -379.995,  -293.656,  -12.559);
nodes[1837] <- snowplowv3( -423.919,  -293.417,  -11.667);
nodes[1838] <- snowplowv3( -469.003,  -293.382,  -10.743);
nodes[1839] <- snowplowv3( -505.801,  -293.095,  -9.980 );
nodes[1840] <- snowplowv3( -529.815,  -282.605,  -9.658 );
nodes[1841] <- snowplowv3( -529.759,  -237.553,  -5.212 );
nodes[1842] <- snowplowv3( -533.454,  -229.505,  -4.541 );
nodes[1843] <- snowplowv3( -531.670,  -291.855,  -9.720 );
nodes[1844] <- snowplowv3( -503.042,  -296.909,  -10.042);
nodes[1845] <- snowplowv3( -469.483,  -296.850,  -10.731);
nodes[1846] <- snowplowv3( -388.164,  -296.686,  -12.417);
nodes[1847] <- snowplowv3( -350.682,  -296.460,  -12.576);
nodes[1848] <- snowplowv3( -289.829,  -296.664,  -14.019);
nodes[1849] <- snowplowv3( -222.947,  -296.552,  -15.627);
nodes[1850] <- snowplowv3( -185.336,  -296.519,  -15.818);
nodes[1851] <- snowplowv3( -134.934,  -296.525,  -15.098);
nodes[1852] <- snowplowv3( -79.746,  -296.642,  -14.340 );
nodes[1853] <- snowplowv3( -37.050,  -294.674,  -14.323 );
nodes[1854] <- snowplowv3( 16.713,  -291.987,  -18.808  );
nodes[1855] <- snowplowv3( 74.431,  -291.247,  -19.992  );
nodes[1856] <- snowplowv3( 131.610,  -291.149,  -19.993 );
nodes[1857] <- snowplowv3( 202.670,  -291.431,  -20.007 );
nodes[1858] <- snowplowv3( -37.496,  -297.768,  -14.309 );
nodes[1859] <- snowplowv3( 5.647,  -295.696,  -17.844   );
nodes[1860] <- snowplowv3( 65.809,  -294.242,  -19.994  );
nodes[1861] <- snowplowv3( 127.253,  -294.362,  -19.996 );
nodes[1862] <- snowplowv3( 202.877,  -294.434,  -20.003 );
nodes[1863] <- snowplowv3( 238.570,  -294.252,  -20.000 );
nodes[1864] <- snowplowv3( 270.102,  -294.211,  -20.006 );
nodes[1865] <- snowplowv3( 133.737,  66.420,  -19.852   );
nodes[1866] <- snowplowv3( 133.729,  125.525,  -19.862  );
nodes[1867] <- snowplowv3( 133.344,  200.600,  -19.865  );
nodes[1868] <- snowplowv3( 128.396,  200.795,  -19.855  );
nodes[1869] <- snowplowv3( 127.903,  125.536,  -19.857  );
nodes[1870] <- snowplowv3( 127.833,  73.833,  -19.861   );
nodes[1871] <- snowplowv3( 127.881,  28.093,  -19.859   );
nodes[1872] <- snowplowv3( 127.806,  -16.867,  -19.852  );
nodes[1873] <- snowplowv3( 127.772,  -98.150,  -19.852  );
nodes[1874] <- snowplowv3( 127.810,  -123.278,  -19.872 );
nodes[1875] <- snowplowv3( 128.357,  -173.207,  -19.918 );
nodes[1876] <- snowplowv3( 128.513,  -259.833,  -19.999 );
nodes[1877] <- snowplowv3( 117.391,  -275.913,  -19.996 );
nodes[1878] <- snowplowv3( 75.566,  -283.516,  -19.996  );
nodes[1879] <- snowplowv3( 25.481,  -283.887,  -19.358  );
nodes[1880] <- snowplowv3( -30.422,  -287.237,  -14.599 );
nodes[1881] <- snowplowv3( -50.366,  -276.292,  -14.204 );
nodes[1882] <- snowplowv3( -50.303,  -232.669,  -14.268 );
nodes[1883] <- snowplowv3( -50.279,  -202.328,  -14.274 );
nodes[1884] <- snowplowv3( -50.314,  -137.868,  -14.282 );
nodes[1885] <- snowplowv3( -35.311,  -116.747,  -14.542 );
nodes[1886] <- snowplowv3( 19.775,  -116.817,  -17.454  );
nodes[1887] <- snowplowv3( 58.617,  -115.483,  -18.132  );
nodes[1888] <- snowplowv3( 117.493,  -115.341,  -19.854 );
nodes[1889] <- snowplowv3( 118.667,  -112.081,  -19.855 );
nodes[1890] <- snowplowv3( 64.525,  -111.900,  -18.139  );
nodes[1891] <- snowplowv3( 52.427,  -94.807,  -17.947   );
nodes[1892] <- snowplowv3( 52.702,  -53.471,  -16.312   );
nodes[1893] <- snowplowv3( 52.599,  26.297,  -13.132    );
nodes[1894] <- snowplowv3( 67.415,  45.909,  -13.368    );
nodes[1895] <- snowplowv3( 107.091,  46.006,  -18.388   );
nodes[1896] <- snowplowv3( 113.308,  53.510,  -19.224   );
nodes[1897] <- snowplowv3( 69.588,  49.921,  -13.557    );
nodes[1898] <- snowplowv3( 65.927,  42.734,  -13.264    );
nodes[1899] <- snowplowv3( 108.010,  42.544,  -18.595   );
nodes[1900] <- snowplowv3( -53.389,  -276.155,  -14.216 );
nodes[1901] <- snowplowv3( -53.091,  -232.250,  -14.273 );
nodes[1902] <- snowplowv3( -53.022,  -201.870,  -14.275 );
nodes[1903] <- snowplowv3( -53.171,  -136.317,  -14.280 );
nodes[1904] <- snowplowv3( -53.523,  -96.148,  -14.283  );
nodes[1905] <- snowplowv3( -53.460,  -43.341,  -14.295  );
nodes[1906] <- snowplowv3( -53.456,  -9.866,  -14.297   );
nodes[1907] <- snowplowv3( -50.294,  31.282,  -13.784   );
nodes[1908] <- snowplowv3( -29.584,  45.625,  -13.544   );
nodes[1909] <- snowplowv3( 21.319,  46.339,  -12.971    );
nodes[1910] <- snowplowv3( 40.447,  32.678,  -12.928    );
nodes[1911] <- snowplowv3( 40.462,  -9.230,  -14.670    );
nodes[1912] <- snowplowv3( 40.312,  -90.479,  -17.786   );
nodes[1913] <- snowplowv3( 30.497,  -106.255,  -17.961  );
nodes[1914] <- snowplowv3( -30.831,  -106.210,  -14.779 );
nodes[1915] <- snowplowv3( -73.724,  -106.313,  -14.208 );
nodes[1916] <- snowplowv3( -117.630,  -106.284,  -13.282);
nodes[1917] <- snowplowv3( -177.302,  -106.143,  -12.025);
nodes[1918] <- snowplowv3( -216.337,  -106.414,  -11.845);
nodes[1919] <- snowplowv3( -266.423,  -106.269,  -11.195);
nodes[1920] <- snowplowv3( -343.946,  -106.387,  -10.182);
nodes[1921] <- snowplowv3( -380.034,  -106.438,  -10.107);
nodes[1922] <- snowplowv3( -434.399,  -106.362,  -4.043 );
nodes[1923] <- snowplowv3( -438.013,  -116.683,  -3.793 );
nodes[1924] <- snowplowv3( -384.360,  -116.858,  -9.993 );
nodes[1925] <- snowplowv3( -350.101,  -116.603,  -10.120);
nodes[1926] <- snowplowv3( -290.545,  -116.609,  -10.884);
nodes[1927] <- snowplowv3( -222.203,  -116.732,  -11.772);
nodes[1928] <- snowplowv3( -184.683,  -116.660,  -11.877);
nodes[1929] <- snowplowv3( -134.289,  -116.641,  -12.927);
nodes[1930] <- snowplowv3( -82.991,  -116.684,  -14.005 );
nodes[1931] <- snowplowv3( -60.238,  -130.730,  -14.273 );
nodes[1932] <- snowplowv3( -57.504,  -160.724,  -14.270 );
nodes[1933] <- snowplowv3( -57.511,  -194.329,  -14.277 );
nodes[1934] <- snowplowv3( -57.733,  -226.276,  -14.275 );
nodes[1935] <- snowplowv3( -57.391,  -271.067,  -14.217 );
nodes[1936] <- snowplowv3( -60.482,  -226.937,  -14.277 );
nodes[1937] <- snowplowv3( -60.313,  -270.836,  -14.229 );
nodes[1938] <- snowplowv3( -463.283,  -211.898,  -6.744 );
nodes[1939] <- snowplowv3( -513.241,  -212.065,  -4.714 );
nodes[1940] <- snowplowv3( -382.210,  -378.332,  -13.850);
nodes[1941] <- snowplowv3( -425.632,  -377.985,  -13.902);
nodes[1942] <- snowplowv3( -476.131,  -377.701,  -13.907);
nodes[1943] <- snowplowv3( -482.673,  -316.646,  -10.975);
nodes[1944] <- snowplowv3( -485.921,  -308.791,  -10.488);
nodes[1945] <- snowplowv3( -485.339,  -373.215,  -13.893);
nodes[1946] <- snowplowv3( -436.436,  -381.878,  -13.897);
nodes[1947] <- snowplowv3( -391.524,  -382.333,  -13.879);
nodes[1948] <- snowplowv3( -327.976,  -398.010,  -14.058);
nodes[1949] <- snowplowv3( -328.040,  -447.940,  -15.299);
nodes[1950] <- snowplowv3( -324.128,  -452.363,  -15.398);
nodes[1951] <- snowplowv3( -323.822,  -400.909,  -14.135);
nodes[1952] <- snowplowv3( -739.674,  -181.145,  -12.478);
nodes[1953] <- snowplowv3( -741.077,  -232.444,  -12.479);
nodes[1954] <- snowplowv3( -747.180,  -305.357,  -12.476);
nodes[1955] <- snowplowv3( -774.421,  -335.430,  -14.284);
nodes[1956] <- snowplowv3( -812.501,  -362.905,  -20.073);
nodes[1957] <- snowplowv3( -818.484,  -446.249,  -25.468);
nodes[1958] <- snowplowv3( -745.156,  -309.857,  -12.478);
nodes[1959] <- snowplowv3( -784.527,  -344.169,  -15.741);
nodes[1960] <- snowplowv3( -813.423,  -373.981,  -21.122);
nodes[1961] <- snowplowv3( -815.201,  -445.801,  -25.441);
nodes[1962] <- snowplowv3( -652.313,  -454.460,  -19.695 );
nodes[1963] <- snowplowv3( -685.770,  -433.069,  -11.730 );
nodes[1964] <- snowplowv3( -418.235,  -462.491,  -17.944 );
nodes[1965] <- snowplowv3( -470.707,  -462.500,  -19.999 );
nodes[1966] <- snowplowv3( -539.414,  -462.355,  -19.995 );
nodes[1967] <- snowplowv3( -579.470,  -462.401,  -20.013 );
nodes[1968] <- snowplowv3( -636.758,  -455.752,  -20.020 );
nodes[1969] <- snowplowv3( -691.713,  -421.202,  -11.490 );
nodes[1970] <- snowplowv3( -707.882,  -378.248,  -11.485 );
nodes[1971] <- snowplowv3( -715.034,  -318.621,  -11.185 );
nodes[1972] <- snowplowv3( -794.692,  -469.881,  -25.433 );
nodes[1973] <- snowplowv3( -771.154,  -469.626,  -23.121 );
nodes[1974] <- snowplowv3( -796.681,  -472.737,  -25.565 );
nodes[1975] <- snowplowv3( -772.189,  -472.796,  -23.201 );
nodes[1976] <- snowplowv3( -741.457,  -472.828,  -22.725 );
nodes[1977] <- snowplowv3( -707.778,  -472.660,  -22.352 );
nodes[1978] <- snowplowv3( -654.153,  -472.806,  -20.017 );
nodes[1979] <- snowplowv3( -586.131,  -472.784,  -20.016 );
nodes[1980] <- snowplowv3( -547.726,  -472.758,  -19.999 );
nodes[1981] <- snowplowv3( -501.188,  -469.416,  -19.987 );
nodes[1982] <- snowplowv3( -425.683,  -469.784,  -18.298 );
nodes[1983] <- snowplowv3( -386.193,  -469.815,  -17.776 );
nodes[1984] <- snowplowv3( -352.092,  -469.799,  -16.123 );
nodes[1985] <- snowplowv3( -311.579,  -469.661,  -15.513 );
nodes[1986] <- snowplowv3( -246.210,  -469.639,  -16.009 );
nodes[1987] <- snowplowv3( -197.913,  -469.604,  -15.997 );
nodes[1988] <- snowplowv3( -129.636,  -469.586,  -14.983 );
nodes[1989] <- snowplowv3( -107.602,  -482.183,  -14.911 );
nodes[1990] <- snowplowv3( -107.873,  -534.332,  -17.417 );
nodes[1991] <- snowplowv3( -107.817,  -587.020,  -19.721 );
nodes[1992] <- snowplowv3( -122.850,  -603.817,  -19.994 );
nodes[1993] <- snowplowv3( -178.113,  -603.516,  -20.001 );
nodes[1994] <- snowplowv3( -238.383,  -603.637,  -20.002 );
nodes[1995] <- snowplowv3( -298.030,  -603.668,  -20.002 );
nodes[1996] <- snowplowv3( -379.731,  -603.542,  -20.003 );
nodes[1997] <- snowplowv3( -400.024,  -585.064,  -19.906 );
nodes[1998] <- snowplowv3( -399.785,  -535.063,  -18.930 );
nodes[1999] <- snowplowv3( -399.899,  -486.996,  -17.973 );
nodes[2000] <- snowplowv3( -404.269,  -484.922,  -17.938 );
nodes[2001] <- snowplowv3( -404.612,  -529.956,  -18.828 );
nodes[2002] <- snowplowv3( -407.281,  -579.039,  -19.798 );
nodes[2003] <- snowplowv3( -419.657,  -597.526,  -19.997 );
nodes[2004] <- snowplowv3( -482.498,  -598.326,  -19.992 );
nodes[2005] <- snowplowv3( -573.858,  -585.930,  -19.952 );
nodes[2006] <- snowplowv3( -632.317,  -575.091,  -19.931 );
nodes[2007] <- snowplowv3( -678.487,  -543.257,  -21.595 );
nodes[2008] <- snowplowv3( -714.716,  -488.084,  -22.624 );
nodes[2009] <- snowplowv3( -719.094,  -486.529,  -22.612 );
nodes[2010] <- snowplowv3( -674.732,  -552.452,  -21.379 );
nodes[2011] <- snowplowv3( -610.169,  -582.884,  -19.913 );
nodes[2012] <- snowplowv3( -539.935,  -595.289,  -19.984 );
nodes[2013] <- snowplowv3( -457.555,  -604.930,  -20.010 );
nodes[2014] <- snowplowv3( -420.656,  -604.215,  -19.993 );
nodes[2015] <- snowplowv3( -396.954,  -585.662,  -19.929 );
nodes[2016] <- snowplowv3( -396.961,  -542.092,  -19.061 );
nodes[2017] <- snowplowv3( -397.027,  -488.121,  -17.991 );
nodes[2018] <- snowplowv3( -653.452,  -462.458,  -20.020 );
nodes[2019] <- snowplowv3( -710.849,  -462.415,  -22.606 );
nodes[2020] <- snowplowv3( -781.887,  -462.307,  -24.183 );
nodes[2021] <- snowplowv3( -807.613,  -450.729,  -25.671 );
nodes[2022] <- snowplowv3( -806.900,  -387.843,  -22.113 );
nodes[2023] <- snowplowv3( -779.897,  -353.759,  -15.459 );
nodes[2024] <- snowplowv3( -738.178,  -374.815,  -12.182 );
nodes[2025] <- snowplowv3( -722.379,  -423.532,  -11.831 );
nodes[2026] <- snowplowv3( -687.514,  -495.843,  -11.408 );
nodes[2027] <- snowplowv3( -638.201,  -551.649,  -11.031 );
nodes[2028] <- snowplowv3( -595.180,  -590.334,  -10.975 );
nodes[2029] <- snowplowv3( -547.817,  -612.729,  -17.269 );
nodes[2030] <- snowplowv3( -473.479,  -612.311,  -20.003 );
nodes[2031] <- snowplowv3( -420.756,  -607.801,  -19.994 );
nodes[2032] <- snowplowv3( -592.085,  -587.875,  -10.956 );
nodes[2033] <- snowplowv3( -532.543,  -610.717,  -19.228 );
nodes[2034] <- snowplowv3( -485.935,  -609.239,  -20.002 );
nodes[2035] <- snowplowv3( -420.891,  -600.520,  -19.990 );
nodes[2036] <- snowplowv3( -568.371,  -486.245,  -19.940 );
nodes[2037] <- snowplowv3( -576.528,  -523.338,  -13.995 );
nodes[2038] <- snowplowv3( -613.447,  -530.981,  -10.935 );
nodes[2039] <- snowplowv3( -653.995,  -496.287,  -11.271 );
nodes[2040] <- snowplowv3( -565.292,  -485.345,  -19.954 );
nodes[2041] <- snowplowv3( -579.038,  -530.204,  -13.018 );
nodes[2042] <- snowplowv3( -616.285,  -533.740,  -10.919 );
nodes[2043] <- snowplowv3( -409.032,  -607.722,  -10.878 );
nodes[2044] <- snowplowv3( -479.813,  -597.061,  -10.868 );
nodes[2045] <- snowplowv3( -540.607,  -573.002,  -10.923 );
nodes[2046] <- snowplowv3( -557.864,  -491.281,  -19.756 );
nodes[2047] <- snowplowv3( -548.728,  -569.079,  -11.001 );
nodes[2048] <- snowplowv3( -560.957,  -491.124,  -19.760 );
nodes[2049] <- snowplowv3( -751.755,  -451.471,  -22.633 );
nodes[2050] <- snowplowv3( -751.535,  -379.444,  -20.525 );
nodes[2051] <- snowplowv3( -746.892,  -323.196,  -20.094 );
nodes[2052] <- snowplowv3( -736.472,  -240.617,  -20.099 );
nodes[2053] <- snowplowv3( -735.689,  -167.797,  -20.097 );
nodes[2054] <- snowplowv3( -735.673,  -104.503,  -20.098 );
nodes[2055] <- snowplowv3( -735.615,  -22.532,  -20.098 );
nodes[2056] <- snowplowv3( -735.710,  51.965,  -20.099 );
nodes[2057] <- snowplowv3( -735.675,  109.098,  -20.099 );
nodes[2058] <- snowplowv3( -735.759,  185.656,  -20.099 );
nodes[2059] <- snowplowv3( -735.957,  268.142,  -20.099 );
nodes[2060] <- snowplowv3( -735.667,  345.074,  -20.099 );
nodes[2061] <- snowplowv3( -735.617,  428.310,  -20.100 );
nodes[2062] <- snowplowv3( -735.749,  495.531,  -20.100 );
nodes[2063] <- snowplowv3( -735.598,  569.336,  -19.559 );
nodes[2064] <- snowplowv3( -738.121,  634.153,  -18.654 );
nodes[2065] <- snowplowv3( -741.276,  708.984,  -17.132 );
nodes[2066] <- snowplowv3( -451.936,  514.115,  1.143 );
nodes[2067] <- snowplowv3( -393.445,  513.250,  -1.057 );
nodes[2068] <- snowplowv3( -388.379,  477.780,  -1.053 );
nodes[2069] <- snowplowv3( -388.150,  442.294,  -1.053 );
nodes[2070] <- snowplowv3( -370.309,  418.236,  -1.247 );
nodes[2071] <- snowplowv3( -290.727,  417.969,  -5.676 );
nodes[2072] <- snowplowv3( -228.683,  418.126,  -6.139 );
nodes[2073] <- snowplowv3( -211.353,  395.413,  -6.123 );
nodes[2074] <- snowplowv3( -211.629,  344.272,  -6.223 );
nodes[2075] <- snowplowv3( -211.501,  306.389,  -6.278 );
nodes[2076] <- snowplowv3( -211.697,  271.810,  -6.291 );
nodes[2077] <- snowplowv3( -211.727,  213.310,  -8.772 );
nodes[2078] <- snowplowv3( -211.633,  145.408,  -10.391 );
nodes[2079] <- snowplowv3( -211.333,  70.290,  -11.106 );
nodes[2080] <- snowplowv3( -205.995,  -0.107,  -11.773 );
nodes[2081] <- snowplowv3( -199.616,  -6.374,  -11.828 );
nodes[2082] <- snowplowv3( -205.350,  58.569,  -11.219 );
nodes[2083] <- snowplowv3( -201.479,  107.955,  -10.752 );
nodes[2084] <- snowplowv3( -201.628,  165.307,  -10.385 );
nodes[2085] <- snowplowv3( -201.816,  260.844,  -6.717 );
nodes[2086] <- snowplowv3( -228.315,  290.092,  -5.981 );
nodes[2087] <- snowplowv3( -279.577,  272.597,  2.238 );
nodes[2088] <- snowplowv3( -329.714,  271.615,  2.226 );
nodes[2089] <- snowplowv3( -372.036,  271.688,  2.137 );
nodes[2090] <- snowplowv3( -434.047,  273.261,  1.295 );
nodes[2091] <- snowplowv3( 29.541,  371.937,  -13.830 );
nodes[2092] <- snowplowv3( -2.721,  372.077,  -13.827 );
nodes[2093] <- snowplowv3( -38.372,  372.405,  -13.828 );
nodes[2094] <- snowplowv3( -75.987,  372.100,  -13.824 );
nodes[2095] <- snowplowv3( -121.356,  371.789,  -13.823 );
nodes[2096] <- snowplowv3( -139.735,  351.774,  -13.789 );
nodes[2097] <- snowplowv3( -140.064,  312.602,  -12.373 );
nodes[2098] <- snowplowv3( -140.211,  273.135,  -12.043 );
nodes[2099] <- snowplowv3( -138.256,  224.346,  -13.812 );
nodes[2100] <- snowplowv3( -113.738,  214.014,  -13.884 );
nodes[2101] <- snowplowv3( -66.977,  214.138,  -14.527 );
nodes[2102] <- snowplowv3( 65.813,  214.027,  -16.108 );
nodes[2103] <- snowplowv3( 111.105,  213.866,  -19.422 );
nodes[2104] <- snowplowv3( 144.454,  213.888,  -19.863 );
nodes[2105] <- snowplowv3( 176.575,  214.036,  -19.868 );
nodes[2106] <- snowplowv3( 200.299,  229.126,  -19.861 );
nodes[2107] <- snowplowv3( 205.897,  252.232,  -20.033 );
nodes[2108] <- snowplowv3( 248.273,  260.012,  -21.325 );
nodes[2109] <- snowplowv3( 815.070,  37.079,  -19.320 );
nodes[2110] <- snowplowv3( 754.100,  84.099,  -14.066 );
nodes[2111] <- snowplowv3( 659.455,  110.361,  4.355 );
nodes[2112] <- snowplowv3( 613.629,  129.489,  4.181 );
nodes[2113] <- snowplowv3( 811.553,  36.856,  -19.333 );
nodes[2114] <- snowplowv3( 747.868,  83.223,  -13.120 );
nodes[2115] <- snowplowv3( 650.850,  109.352,  4.792 );
nodes[2116] <- snowplowv3( 557.944,  285.219,  -4.960 );
nodes[2117] <- snowplowv3( 571.152,  356.837,  -7.801 );
nodes[2118] <- snowplowv3( 567.553,  422.346,  -15.262 );
nodes[2119] <- snowplowv3( 532.881,  452.055,  -20.507 );
nodes[2120] <- snowplowv3( 471.981,  453.041,  -22.867 );
nodes[2121] <- snowplowv3( 559.598,  310.923,  -5.782 );
nodes[2122] <- snowplowv3( 568.510,  379.973,  -9.841 );
nodes[2123] <- snowplowv3( 556.213,  435.154,  -17.851 );
nodes[2124] <- snowplowv3( 525.691,  448.804,  -20.682 );
nodes[2125] <- snowplowv3( 470.950,  449.393,  -22.920 );
nodes[2126] <- snowplowv3( -408.385,  1793.365,  -23.423 );
nodes[2127] <- snowplowv3( -452.269,  1793.682,  -20.047 );
nodes[2128] <- snowplowv3( -505.681,  1793.615,  -14.932 );
nodes[2129] <- snowplowv3( -578.713,  1793.595,  -14.924 );
nodes[2130] <- snowplowv3( -646.677,  1793.725,  -14.912 );
nodes[2131] <- snowplowv3( -714.432,  1790.562,  -14.893 );
nodes[2132] <- snowplowv3( -736.424,  1754.022,  -14.869 );
nodes[2133] <- snowplowv3( -736.545,  1712.037,  -14.848 );
nodes[2134] <- snowplowv3( -736.453,  1664.375,  -14.827 );
nodes[2135] <- snowplowv3( -733.237,  1583.042,  -12.418 );
nodes[2136] <- snowplowv3( -722.586,  1583.532,  -13.088 );
nodes[2137] <- snowplowv3( -729.078,  1646.578,  -14.796 );
nodes[2138] <- snowplowv3( -729.127,  1708.039,  -14.823 );
nodes[2139] <- snowplowv3( -722.355,  1775.596,  -14.866 );
nodes[2140] <- snowplowv3( -687.863,  1786.358,  -14.863 );
nodes[2141] <- snowplowv3( -596.256,  1786.376,  -14.884 );
nodes[2142] <- snowplowv3( -512.848,  1786.388,  -14.916 );
nodes[2143] <- snowplowv3( -412.441,  1789.344,  -23.424 );
nodes[2144] <- snowplowv3( -394.289,  1773.007,  -23.309 );
nodes[2145] <- snowplowv3( -394.736,  1736.328,  -22.915 );
nodes[2146] <- snowplowv3( -394.648,  1681.859,  -23.102 );
nodes[2147] <- snowplowv3( -394.689,  1592.948,  -23.402 );
nodes[2148] <- snowplowv3( -387.603,  1586.766,  -23.421 );
nodes[2149] <- snowplowv3( -387.653,  1650.241,  -23.205 );
nodes[2150] <- snowplowv3( -390.550,  1720.702,  -22.975 );
nodes[2151] <- snowplowv3( -390.341,  1771.784,  -23.268 );
nodes[2152] <- snowplowv3( -384.729,  1525.298,  -23.860 );
nodes[2153] <- snowplowv3( -331.237,  1521.653,  -23.948 );
nodes[2154] <- snowplowv3( -286.078,  1518.196,  -23.950 );
nodes[2155] <- snowplowv3( -239.677,  1527.716,  -24.039 );
nodes[2156] <- snowplowv3( -271.594,  1530.050,  -24.453 );
nodes[2157] <- snowplowv3( -281.468,  1521.721,  -23.928 );
nodes[2158] <- snowplowv3( -320.746,  1524.463,  -23.928 );
nodes[2159] <- snowplowv3( -377.283,  1527.246,  -23.802 );
nodes[2160] <- snowplowv3( -393.918,  1541.849,  -23.391 );
nodes[2161] <- snowplowv3( -407.820,  1570.540,  -23.318 );
nodes[2162] <- snowplowv3( -449.560,  1570.636,  -20.236 );
nodes[2163] <- snowplowv3( -523.322,  1571.094,  -14.938 );
nodes[2164] <- snowplowv3( -580.199,  1571.172,  -16.706 );
nodes[2165] <- snowplowv3( -652.174,  1571.090,  -16.399 );
nodes[2166] <- snowplowv3( -709.880,  1569.068,  -13.625 );
nodes[2167] <- snowplowv3( -746.508,  1557.765,  -10.527 );
nodes[2168] <- snowplowv3( -785.686,  1542.568,  -6.428 );
nodes[2169] <- snowplowv3( -822.931,  1527.799,  -6.012 );
nodes[2170] <- snowplowv3( -844.035,  1503.366,  -5.568 );
nodes[2171] <- snowplowv3( -868.591,  1477.315,  -4.945 );
nodes[2172] <- snowplowv3( -906.532,  1475.588,  -4.594 );
nodes[2173] <- snowplowv3( -956.374,  1475.577,  -4.596 );
nodes[2174] <- snowplowv3( -994.344,  1475.299,  -4.597 );
nodes[2175] <- snowplowv3( -1036.311,  1474.890,  -4.564 );
nodes[2176] <- snowplowv3( -1096.070,  1474.618,  -2.917 );
nodes[2177] <- snowplowv3( -1130.499,  1474.539,  -2.678 );
nodes[2178] <- snowplowv3( -1186.428,  1474.680,  -4.223 );
nodes[2179] <- snowplowv3( -1226.003,  1474.704,  -4.650 );
nodes[2180] <- snowplowv3( -1278.871,  1480.032,  -5.763 );
nodes[2181] <- snowplowv3( -1321.356,  1479.834,  -5.941 );
nodes[2182] <- snowplowv3( -1390.305,  1480.256,  -5.331 );
nodes[2183] <- snowplowv3( -1416.077,  1508.558,  -2.225 );
nodes[2184] <- snowplowv3( -1415.493,  1562.844,  0.430 );
nodes[2185] <- snowplowv3( -1439.122,  1607.201,  2.761 );
nodes[2186] <- snowplowv3( -1445.015,  1664.849,  5.864 );
nodes[2187] <- snowplowv3( -1462.097,  1689.375,  6.124 );
nodes[2188] <- snowplowv3( -1520.204,  1689.354,  0.537 );
nodes[2189] <- snowplowv3( -1541.345,  1674.170,  -0.071 );
nodes[2190] <- snowplowv3( -1541.595,  1625.229,  -4.155 );
nodes[2191] <- snowplowv3( -1540.954,  1583.014,  -5.770 );
nodes[2192] <- snowplowv3( -1209.557,  1493.367,  -4.180 );
nodes[2193] <- snowplowv3( -1209.834,  1548.823,  3.964 );
nodes[2194] <- snowplowv3( -1197.340,  1567.370,  5.238 );
nodes[2195] <- snowplowv3( -1138.725,  1567.264,  6.722 );
nodes[2196] <- snowplowv3( -1119.028,  1554.678,  6.731 );
nodes[2197] <- snowplowv3( -1119.382,  1498.421,  -1.428 );
nodes[2198] <- snowplowv3( -1134.030,  1479.768,  -2.784 );
nodes[2199] <- snowplowv3( -1186.673,  1479.806,  -4.232 );
nodes[2200] <- snowplowv3( -1226.990,  1571.067,  5.101 );
nodes[2201] <- snowplowv3( -1286.479,  1571.465,  3.981 );
nodes[2202] <- snowplowv3( -1308.150,  1552.975,  3.203 );
nodes[2203] <- snowplowv3( -1307.986,  1502.182,  -4.179 );
nodes[2204] <- snowplowv3( -1308.060,  1451.396,  -6.356 );
nodes[2205] <- snowplowv3( -1303.770,  1410.666,  -12.495 );
nodes[2206] <- snowplowv3( -1296.753,  1407.158,  -12.999 );
nodes[2207] <- snowplowv3( -1296.749,  1447.537,  -6.934 );
nodes[2208] <- snowplowv3( -1292.471,  1406.732,  -13.070 );
nodes[2209] <- snowplowv3( -1292.448,  1447.446,  -6.942 );
nodes[2210] <- snowplowv3( -1278.871,  1468.579,  -5.862 );
nodes[2211] <- snowplowv3( -1231.642,  1468.695,  -4.784 );
nodes[2212] <- snowplowv3( -1196.655,  1469.348,  -4.508 );
nodes[2213] <- snowplowv3( -1138.267,  1469.062,  -2.897 );
nodes[2214] <- snowplowv3( -1102.638,  1469.304,  -2.736 );
nodes[2215] <- snowplowv3( -1046.659,  1469.651,  -4.276 );
nodes[2216] <- snowplowv3( -1008.935,  1469.657,  -4.595 );
nodes[2217] <- snowplowv3( -953.954,  1469.042,  -4.596 );
nodes[2218] <- snowplowv3( -909.205,  1469.179,  -4.593 );
nodes[2219] <- snowplowv3( -866.339,  1470.419,  -4.964 );
nodes[2220] <- snowplowv3( -839.492,  1494.465,  -5.466 );
nodes[2221] <- snowplowv3( -818.210,  1522.133,  -6.028 );
nodes[2222] <- snowplowv3( -789.318,  1533.692,  -6.065 );
nodes[2223] <- snowplowv3( -742.319,  1546.794,  -10.518 );
nodes[2224] <- snowplowv3( -902.914,  1479.733,  -4.600 );
nodes[2225] <- snowplowv3( -958.043,  1480.189,  -4.595 );
nodes[2226] <- snowplowv3( -995.608,  1480.042,  -4.596 );
nodes[2227] <- snowplowv3( -1021.435,  1492.442,  -4.306 );
nodes[2228] <- snowplowv3( -1021.222,  1548.912,  3.964 );
nodes[2229] <- snowplowv3( -1103.164,  1567.457,  7.046 );
nodes[2230] <- snowplowv3( -1049.754,  1567.072,  5.573 );
nodes[2231] <- snowplowv3( -1009.393,  1567.091,  5.164 );
nodes[2232] <- snowplowv3( -933.691,  1567.219,  5.166 );
nodes[2233] <- snowplowv3( -909.519,  1581.088,  5.189 );
nodes[2234] <- snowplowv3( -914.787,  1593.512,  5.499 );
nodes[2235] <- snowplowv3( -938.621,  1619.109,  6.093 );
nodes[2236] <- snowplowv3( -974.472,  1657.766,  8.173 );
nodes[2237] <- snowplowv3( -1015.178,  1685.348,  10.135 );
nodes[2238] <- snowplowv3( -1063.078,  1689.260,  10.725 );
nodes[2239] <- snowplowv3( -1116.318,  1689.492,  11.019 );
nodes[2240] <- snowplowv3( -1182.669,  1689.335,  11.378 );
nodes[2241] <- snowplowv3( -1213.586,  1672.944,  11.323 );
nodes[2242] <- snowplowv3( -1213.748,  1630.162,  8.451 );
nodes[2243] <- snowplowv3( -1213.739,  1591.802,  5.892 );
nodes[2244] <- snowplowv3( -1038.170,  1571.165,  5.248 );
nodes[2245] <- snowplowv3( -1094.960,  1571.326,  6.815 );
nodes[2246] <- snowplowv3( -1279.005,  1464.346,  -5.864 );
nodes[2247] <- snowplowv3( -1232.132,  1464.561,  -4.791 );
nodes[2248] <- snowplowv3( -1196.723,  1464.468,  -4.512 );
nodes[2249] <- snowplowv3( -1139.066,  1464.599,  -2.922 );
nodes[2250] <- snowplowv3( -1103.089,  1464.621,  -2.728 );
nodes[2251] <- snowplowv3( -1048.177,  1464.549,  -4.232 );
nodes[2252] <- snowplowv3( -1009.677,  1464.419,  -4.597 );
nodes[2253] <- snowplowv3( -960.296,  1464.192,  -4.598 );
nodes[2254] <- snowplowv3( -907.005,  1464.242,  -4.596 );
nodes[2255] <- snowplowv3( -870.711,  1464.922,  -4.893 );
nodes[2256] <- snowplowv3( -842.620,  1479.630,  -5.279 );
nodes[2257] <- snowplowv3( -830.561,  1507.160,  -5.712 );
nodes[2258] <- snowplowv3( -815.704,  1518.418,  -6.041 );
nodes[2259] <- snowplowv3( -799.984,  1512.664,  -5.999 );
nodes[2260] <- snowplowv3( -765.715,  1469.929,  -1.748 );
nodes[2261] <- snowplowv3( -722.991,  1418.749,  2.399 );
nodes[2262] <- snowplowv3( -665.578,  1350.678,  2.395 );
nodes[2263] <- snowplowv3( -606.847,  1292.373,  5.998 );
nodes[2264] <- snowplowv3( -566.045,  1302.214,  9.955 );
nodes[2265] <- snowplowv3( -565.695,  1335.762,  11.815 );
nodes[2266] <- snowplowv3( -561.744,  1371.875,  14.729 );
nodes[2267] <- snowplowv3( -530.503,  1365.191,  18.359 );
nodes[2268] <- snowplowv3( -518.613,  1326.356,  23.198 );
nodes[2269] <- snowplowv3( -237.364,  1335.290,  52.098 );
nodes[2270] <- snowplowv3( 145.223,  1227.821,  63.102 );
nodes[2271] <- snowplowv3( 148.090,  1259.433,  60.503 );
nodes[2272] <- snowplowv3( 181.636,  1273.435,  57.661 );
nodes[2273] <- snowplowv3( 257.477,  1276.541,  58.524 );
nodes[2274] <- snowplowv3( 284.259,  1233.450,  63.401 );
nodes[2275] <- snowplowv3( 273.503,  1216.331,  63.551 );
nodes[2276] <- snowplowv3( 227.010,  1215.899,  62.989 );
nodes[2277] <- snowplowv3( 160.715,  1215.030,  62.733 );
nodes[2278] <- snowplowv3( -1320.565,  1389.506,  -13.404 );
nodes[2279] <- snowplowv3( -1383.809,  1392.378,  -13.414 );
nodes[2280] <- snowplowv3( -1418.512,  1397.987,  -13.407 );
nodes[2281] <- snowplowv3( -1460.648,  1416.055,  -13.383 );
nodes[2282] <- snowplowv3( -1484.957,  1466.672,  -11.688 );
nodes[2283] <- snowplowv3( -1523.382,  1553.754,  -6.752 );
nodes[2284] <- snowplowv3( -1560.218,  1567.698,  -5.896 );
nodes[2285] <- snowplowv3( -1623.374,  1542.826,  -10.674 );
nodes[2286] <- snowplowv3( -1681.658,  1481.945,  -11.588 );
nodes[2287] <- snowplowv3( -1705.300,  1425.785,  -7.496 );
nodes[2288] <- snowplowv3( -1699.554,  1384.555,  -6.965 );
nodes[2289] <- snowplowv3( -1689.507,  1327.448,  -6.986 );
nodes[2290] <- snowplowv3( -1688.094,  1281.860,  -6.422 );
nodes[2291] <- snowplowv3( -1686.444,  1230.963,  -5.758 );
nodes[2292] <- snowplowv3( -1682.619,  1188.320,  -5.775 );
nodes[2293] <- snowplowv3( -1674.915,  1148.189,  -6.903 );
nodes[2294] <- snowplowv3( -1664.848,  1111.775,  -6.981 );
nodes[2295] <- snowplowv3( -1645.997,  1052.331,  -6.358 );
nodes[2296] <- snowplowv3( -1607.203,  647.443,  -10.048 );
nodes[2297] <- snowplowv3( -1606.897,  709.132,  -10.046 );
nodes[2298] <- snowplowv3( -1607.073,  744.621,  -9.953 );
nodes[2299] <- snowplowv3( -1607.460,  797.737,  -5.916 );
nodes[2300] <- snowplowv3( -1609.568,  892.888,  -4.710 );
nodes[2301] <- snowplowv3( -1616.772,  953.494,  -5.321 );
nodes[2302] <- snowplowv3( -1636.588,  1047.512,  -6.290 );
nodes[2303] <- snowplowv3( -1658.523,  1115.661,  -6.977 );
nodes[2304] <- snowplowv3( -1670.674,  1156.365,  -6.716 );
nodes[2305] <- snowplowv3( -1680.921,  1242.416,  -5.871 );
nodes[2306] <- snowplowv3( -1682.238,  1303.746,  -6.725 );
nodes[2307] <- snowplowv3( -1685.695,  1350.118,  -7.201 );
nodes[2308] <- snowplowv3( -1695.863,  1396.671,  -6.879 );
nodes[2309] <- snowplowv3( -1670.603,  1485.157,  -12.115 );
nodes[2310] <- snowplowv3( -1605.884,  1548.047,  -9.269 );
nodes[2311] <- snowplowv3( -1558.150,  1561.099,  -5.838 );
nodes[2312] <- snowplowv3( -1528.843,  1549.527,  -6.635 );
nodes[2313] <- snowplowv3( -1501.888,  1507.696,  -9.623 );
nodes[2314] <- snowplowv3( -1488.655,  1455.453,  -12.084 );
nodes[2315] <- snowplowv3( -1462.082,  1408.457,  -13.402 );
nodes[2316] <- snowplowv3( -1395.551,  1387.287,  -13.503 );
nodes[2317] <- snowplowv3( -1333.975,  1383.088,  -13.404 );
nodes[2318] <- snowplowv3( -1391.763,  1382.572,  -13.510 );
nodes[2319] <- snowplowv3( -1330.657,  1378.531,  -13.414 );
nodes[2320] <- snowplowv3( -1279.697,  1378.612,  -13.414 );
nodes[2321] <- snowplowv3( -1217.013,  1378.224,  -13.411 );
nodes[2322] <- snowplowv3( -1183.545,  1378.378,  -13.409 );
nodes[2323] <- snowplowv3( -1120.069,  1378.170,  -13.229 );
nodes[2324] <- snowplowv3( -1047.911,  1378.231,  -13.415 );
nodes[2325] <- snowplowv3( -1021.350,  1392.376,  -13.421 );
nodes[2326] <- snowplowv3( -1010.937,  1402.362,  -13.422 );
nodes[2327] <- snowplowv3( -959.207,  1402.510,  -12.381 );
nodes[2328] <- snowplowv3( -891.599,  1403.975,  -11.136 );
nodes[2329] <- snowplowv3( -883.127,  1447.628,  -5.760 );
nodes[2330] <- snowplowv3( -1040.355,  1381.978,  -13.396 );
nodes[2331] <- snowplowv3( -1097.890,  1382.266,  -13.391 );
nodes[2332] <- snowplowv3( -1175.992,  1382.224,  -13.405 );
nodes[2333] <- snowplowv3( -1208.925,  1382.182,  -13.406 );
nodes[2334] <- snowplowv3( -1270.826,  1382.177,  -13.414 );
nodes[2335] <- snowplowv3( -1197.622,  1365.415,  -13.401 );
nodes[2336] <- snowplowv3( -1197.721,  1343.835,  -13.408 );
nodes[2337] <- snowplowv3( -1197.776,  1321.993,  -13.409 );
nodes[2338] <- snowplowv3( -1197.707,  1272.225,  -13.411 );
nodes[2339] <- snowplowv3( -1197.600,  1228.151,  -13.416 );
nodes[2340] <- snowplowv3( -1204.265,  1196.175,  -13.407 );
nodes[2341] <- snowplowv3( -1235.130,  1177.645,  -13.413 );
nodes[2342] <- snowplowv3( -1272.828,  1177.378,  -13.411 );
nodes[2343] <- snowplowv3( -1314.970,  1177.488,  -13.414 );
nodes[2344] <- snowplowv3( -1319.070,  1174.403,  -13.404 );
nodes[2345] <- snowplowv3( -1279.687,  1174.505,  -13.411 );
nodes[2346] <- snowplowv3( -1216.391,  1180.058,  -13.405 );
nodes[2347] <- snowplowv3( -1195.507,  1210.808,  -13.412 );
nodes[2348] <- snowplowv3( -1195.019,  1247.035,  -13.407 );
nodes[2349] <- snowplowv3( -1194.827,  1313.471,  -13.412 );
nodes[2350] <- snowplowv3( -1194.668,  1339.265,  -13.409 );
nodes[2351] <- snowplowv3( -1194.731,  1360.399,  -13.407 );
nodes[2352] <- snowplowv3( -1208.971,  1331.160,  -13.407 );
nodes[2353] <- snowplowv3( -1273.750,  1331.211,  -13.409 );
nodes[2354] <- snowplowv3( -1328.790,  1331.262,  -13.411 );
nodes[2355] <- snowplowv3( -1389.705,  1331.297,  -13.411 );
nodes[2356] <- snowplowv3( -1392.183,  1329.185,  -13.412 );
nodes[2357] <- snowplowv3( -1352.508,  1329.258,  -13.403 );
nodes[2358] <- snowplowv3( -1299.697,  1329.292,  -13.408 );
nodes[2359] <- snowplowv3( -1255.821,  1329.223,  -13.419 );
nodes[2360] <- snowplowv3( -1211.916,  1329.062,  -13.410 );
nodes[2361] <- snowplowv3( -1408.591,  1318.656,  -13.403 );
nodes[2362] <- snowplowv3( -1408.637,  1238.279,  -13.411 );
nodes[2363] <- snowplowv3( -1644.553,  1129.664,  -6.972 );
nodes[2364] <- snowplowv3( -1551.800,  1129.265,  -8.903 );
nodes[2365] <- snowplowv3( -1424.520,  1129.398,  -13.431 );
nodes[2366] <- snowplowv3( -1404.787,  1141.022,  -13.421 );
nodes[2367] <- snowplowv3( -1404.756,  1159.691,  -13.432 );
nodes[2368] <- snowplowv3( -1404.534,  1187.385,  -13.405 );
nodes[2369] <- snowplowv3( -1404.684,  1241.510,  -13.406 );
nodes[2370] <- snowplowv3( -1404.674,  1314.336,  -13.405 );
nodes[2371] <- snowplowv3( -1404.682,  1366.285,  -13.513 );
nodes[2372] <- snowplowv3( -1559.061,  1571.831,  -5.873 );
nodes[2373] <- snowplowv3( -1604.390,  1561.435,  -8.581 );
nodes[2374] <- snowplowv3( -1655.120,  1518.014,  -12.715 );
nodes[2375] <- snowplowv3( -1697.599,  1467.355,  -10.147 );
nodes[2376] <- snowplowv3( -1709.396,  1425.528,  -7.492 );
nodes[2377] <- snowplowv3( -1716.420,  1409.297,  -6.943 );
nodes[2378] <- snowplowv3( -1738.122,  1405.109,  -5.204 );
nodes[2379] <- snowplowv3( -1758.539,  1397.934,  -4.664 );
nodes[2380] <- snowplowv3( -1744.888,  1393.059,  -4.769 );
nodes[2381] <- snowplowv3( -1721.897,  1398.198,  -6.468 );
nodes[2382] <- snowplowv3( -1704.021,  1387.705,  -6.915 );
nodes[2383] <- snowplowv3( -1693.427,  1327.733,  -6.937 );
nodes[2384] <- snowplowv3( -1701.675,  1304.508,  -6.427 );
nodes[2385] <- snowplowv3( -1727.176,  1304.847,  -4.486 );
nodes[2386] <- snowplowv3( -1744.193,  1302.038,  -4.181 );
nodes[2387] <- snowplowv3( -1729.486,  1294.763,  -4.391 );
nodes[2388] <- snowplowv3( -1705.459,  1295.241,  -6.224 );
nodes[2389] <- snowplowv3( -1692.421,  1280.972,  -6.387 );
nodes[2390] <- snowplowv3( -1690.864,  1241.384,  -5.869 );
nodes[2391] <- snowplowv3( -1703.230,  1222.047,  -5.344 );
nodes[2392] <- snowplowv3( -1726.229,  1221.422,  -3.549 );
nodes[2393] <- snowplowv3( -1741.148,  1216.711,  -3.325 );
nodes[2394] <- snowplowv3( -1732.299,  1209.955,  -3.327 );
nodes[2395] <- snowplowv3( -1705.662,  1212.905,  -5.034 );
nodes[2396] <- snowplowv3( -1687.622,  1197.994,  -5.653 );
nodes[2397] <- snowplowv3( -1675.955,  1135.198,  -6.978 );
nodes[2398] <- snowplowv3( -1661.677,  1087.187,  -6.738 );
nodes[2399] <- snowplowv3( -1642.836,  1021.076,  -6.052 );
nodes[2400] <- snowplowv3( -1632.229,  971.820,  -5.523 );
nodes[2401] <- snowplowv3( -1621.764,  886.087,  -4.640 );
nodes[2402] <- snowplowv3( -1619.631,  813.283,  -4.718 );
nodes[2403] <- snowplowv3( -1615.510,  713.668,  -10.043 );
nodes[2404] <- snowplowv3( -1619.967,  736.331,  -10.043 );
nodes[2405] <- snowplowv3( -1619.608,  701.913,  -10.042 );
nodes[2406] <- snowplowv3( -1619.648,  670.966,  -10.045 );
nodes[2407] <- snowplowv3( -1619.724,  633.337,  -10.045 );
nodes[2408] <- snowplowv3( -1588.988,  729.269,  -10.296 );
nodes[2409] <- snowplowv3( -1568.588,  738.498,  -11.047 );
nodes[2410] <- snowplowv3( -1547.820,  753.741,  -11.346 );
nodes[2411] <- snowplowv3( -1499.592,  793.042,  -10.539 );
nodes[2412] <- snowplowv3( -1465.456,  808.789,  -10.024 );
nodes[2413] <- snowplowv3( -1437.537,  811.681,  -10.403 );
nodes[2414] <- snowplowv3( -1411.151,  810.402,  -11.794 );
nodes[2415] <- snowplowv3( -1387.655,  805.986,  -13.018 );
nodes[2416] <- snowplowv3( -1344.318,  779.927,  -14.823 );
nodes[2417] <- snowplowv3( -1320.209,  745.030,  -16.239 );
nodes[2418] <- snowplowv3( -1314.345,  696.696,  -18.737 );
nodes[2419] <- snowplowv3( -1319.326,  665.082,  -19.964 );
nodes[2420] <- snowplowv3( -1335.427,  618.862,  -21.571 );
nodes[2421] <- snowplowv3( -1353.850,  571.973,  -23.185 );
nodes[2422] <- snowplowv3( -1358.038,  512.252,  -23.573 );
nodes[2423] <- snowplowv3( -1358.096,  481.199,  -23.562 );
nodes[2424] <- snowplowv3( -1358.292,  429.985,  -23.570 );
nodes[2425] <- snowplowv3( -1358.189,  375.675,  -23.567 );
nodes[2426] <- snowplowv3( -1373.418,  357.461,  -23.373 );
nodes[2427] <- snowplowv3( -1392.606,  357.198,  -22.401 );
nodes[2428] <- snowplowv3( -1426.851,  357.170,  -20.662 );
nodes[2429] <- snowplowv3( -1464.573,  357.363,  -20.385 );
nodes[2430] <- snowplowv3( -1507.391,  357.422,  -20.385 );
nodes[2431] <- snowplowv3( -1551.766,  357.543,  -20.386 );
nodes[2432] <- snowplowv3( -1572.541,  338.828,  -20.294 );
nodes[2433] <- snowplowv3( -1572.213,  282.562,  -17.476 );
nodes[2434] <- snowplowv3( -1572.151,  234.199,  -15.750 );
nodes[2435] <- snowplowv3( -1572.031,  175.897,  -13.313 );
nodes[2436] <- snowplowv3( -1572.157,  144.757,  -13.127 );
nodes[2437] <- snowplowv3( -1571.988,  111.471,  -13.122 );
nodes[2438] <- snowplowv3( -1571.920,  85.113,  -13.133 );
nodes[2439] <- snowplowv3( -1571.990,  58.754,  -13.308 );
nodes[2440] <- snowplowv3( -1571.866,  7.067,  -16.907 );
nodes[2441] <- snowplowv3( -1567.601,  -0.405,  -17.496 );
nodes[2442] <- snowplowv3( -1568.094,  53.096,  -13.701 );
nodes[2443] <- snowplowv3( -1568.167,  83.565,  -13.126 );
nodes[2444] <- snowplowv3( -1568.171,  139.193,  -13.125 );
nodes[2445] <- snowplowv3( -1568.040,  169.754,  -13.170 );
nodes[2446] <- snowplowv3( -1568.165,  223.213,  -15.076 );
nodes[2447] <- snowplowv3( -1568.107,  274.319,  -17.174 );
nodes[2448] <- snowplowv3( -1568.154,  330.219,  -19.930 );
nodes[2449] <- snowplowv3( -1554.608,  352.102,  -20.391 );
nodes[2450] <- snowplowv3( -1514.902,  352.057,  -20.385 );
nodes[2451] <- snowplowv3( -1467.804,  352.199,  -20.394 );
nodes[2452] <- snowplowv3( -1427.267,  352.387,  -20.616 );
nodes[2453] <- snowplowv3( -1393.122,  351.829,  -22.265 );
nodes[2454] <- snowplowv3( -1370.947,  351.940,  -23.487 );
nodes[2455] <- snowplowv3( -1353.914,  368.411,  -23.565 );
nodes[2456] <- snowplowv3( -1353.203,  412.345,  -23.568 );
nodes[2457] <- snowplowv3( -1353.086,  474.245,  -23.570 );
nodes[2458] <- snowplowv3( -1353.077,  504.889,  -23.561 );
nodes[2459] <- snowplowv3( -1352.015,  554.951,  -23.444 );
nodes[2460] <- snowplowv3( -1334.413,  607.961,  -21.981 );
nodes[2461] <- snowplowv3( -1316.346,  655.754,  -20.225 );
nodes[2462] <- snowplowv3( -1329.701,  679.457,  -19.486 );
nodes[2463] <- snowplowv3( -1380.415,  679.428,  -17.479 );
nodes[2464] <- snowplowv3( -1427.487,  679.391,  -15.496 );
nodes[2465] <- snowplowv3( -1390.144,  676.125,  -17.067 );
nodes[2466] <- snowplowv3( -1445.595,  688.474,  -15.012 );
nodes[2467] <- snowplowv3( -1445.585,  743.266,  -12.744 );
nodes[2468] <- snowplowv3( -1445.675,  798.312,  -10.472 );
nodes[2469] <- snowplowv3( -1458.816,  813.516,  -9.822 );
nodes[2470] <- snowplowv3( -1503.433,  794.643,  -10.383 );
nodes[2471] <- snowplowv3( -1546.230,  759.351,  -11.288 );
nodes[2472] <- snowplowv3( -1566.830,  743.162,  -11.105 );
nodes[2473] <- snowplowv3( -1587.065,  733.263,  -10.365 );
nodes[2474] <- snowplowv3( -1449.430,  665.317,  -15.186 );
nodes[2475] <- snowplowv3( -1449.266,  636.417,  -18.787 );
nodes[2476] <- snowplowv3( -1449.096,  569.714,  -20.385 );
nodes[2477] <- snowplowv3( -1449.156,  543.748,  -20.382 );
nodes[2478] <- snowplowv3( -1448.876,  510.717,  -20.381 );
nodes[2479] <- snowplowv3( -1449.142,  482.865,  -20.382 );
nodes[2480] <- snowplowv3( -1449.094,  438.720,  -20.387 );
nodes[2481] <- snowplowv3( -1448.912,  377.290,  -20.383 );
nodes[2482] <- snowplowv3( -1443.773,  370.005,  -20.386 );
nodes[2483] <- snowplowv3( -1443.536,  415.271,  -20.379 );
nodes[2484] <- snowplowv3( -1443.597,  470.806,  -20.389 );
nodes[2485] <- snowplowv3( -1443.743,  503.000,  -20.388 );
nodes[2486] <- snowplowv3( -1443.668,  536.980,  -20.384 );
nodes[2487] <- snowplowv3( -1443.616,  583.466,  -20.384 );
nodes[2488] <- snowplowv3( -1443.721,  656.455,  -15.890 );
nodes[2489] <- snowplowv3( -1327.049,  934.584,  -18.354 );
nodes[2490] <- snowplowv3( -1404.699,  1018.581, -13.427 );
nodes[2491] <- snowplowv3( -1372.367,  493.715,  -23.434 );
nodes[2492] <- snowplowv3( -1424.992,  493.873,  -20.764 );
nodes[2493] <- snowplowv3( -1430.384,  490.928,  -20.488 );
nodes[2494] <- snowplowv3( -1377.326,  490.446,  -23.177 );
nodes[2495] <- snowplowv3( 340.829,  785.685,  -21.095 );
nodes[2496] <- snowplowv3( 339.147,  762.027,  -21.094 );
nodes[2497] <- snowplowv3( 308.831,  758.053,  -21.093 );
nodes[2498] <- snowplowv3( 271.304,  755.361,  -21.098 );
nodes[2499] <- snowplowv3( 267.823,  709.123,  -24.108 );
nodes[2500] <- snowplowv3( 271.042,  704.558,  -24.484 );
nodes[2501] <- snowplowv3( 272.751,  750.676,  -21.096 );
nodes[2502] <- snowplowv3( 302.655,  754.563,  -21.087 );
nodes[2503] <- snowplowv3( 338.263,  756.341,  -21.089 );
nodes[2504] <- snowplowv3( 343.859,  777.412,  -21.094 );
nodes[2505] <- snowplowv3( 207.985,  830.496,  -19.435 );
nodes[2506] <- snowplowv3( 149.227,  830.573,  -19.503 );
nodes[2507] <- snowplowv3( 111.058,  830.648,  -19.751 );
nodes[2508] <- snowplowv3( 48.442,  830.676,  -24.090 );
nodes[2509] <- snowplowv3( 13.867,  830.711,  -24.550 );
nodes[2510] <- snowplowv3( -15.894,  830.827,  -24.550 );
nodes[2511] <- snowplowv3( 143.991,  818.629,  -19.501 );
nodes[2512] <- snowplowv3( 204.380,  818.655,  -19.456 );
nodes[2513] <- snowplowv3( 462.031,  215.651,  -19.763 );
nodes[2514] <- snowplowv3( 507.534,  206.231,  -16.046 );
nodes[2515] <- snowplowv3( 541.248,  156.069,  -7.193 );
nodes[2516] <- snowplowv3( 601.019,  99.132,  4.518 );
nodes[2517] <- snowplowv3( 680.260,  64.412,  4.621 );
nodes[2518] <- snowplowv3( 522.430,  377.442,  -6.542 );
nodes[2519] <- snowplowv3( 514.631,  325.687,  -8.280 );
nodes[2520] <- snowplowv3( 509.865,  256.498,  -16.010 );
nodes[2521] <- snowplowv3( 471.710,  225.722,  -19.673 );
nodes[2522] <- snowplowv3( 462.189,  211.749,  -19.762 );
nodes[2523] <- snowplowv3( 509.955,  199.726,  -15.261 );
nodes[2524] <- snowplowv3( 542.288,  147.347,  -5.942 );
nodes[2525] <- snowplowv3( 585.427,  103.661,  3.489 );
nodes[2526] <- snowplowv3( 628.201,  83.186,  4.812 );
nodes[2527] <- snowplowv3( 522.488,  360.424,  -6.497 );
nodes[2528] <- snowplowv3( 516.920,  303.101,  -10.579 );
nodes[2529] <- snowplowv3( 511.778,  247.804,  -16.936 );
nodes[2530] <- snowplowv3( 471.465,  221.881,  -19.673 );
nodes[2531] <- snowplowv3( -314.508,  1575.634,  -23.416 );
nodes[2532] <- snowplowv3( -367.620,  1575.786,  -23.436 );
nodes[2533] <- snowplowv3( -380.740,  1559.507,  -23.425 );
nodes[2534] <- snowplowv3( -318.137,  1559.803,  -23.426 );
nodes[2535] <- snowplowv3( -264.743,  1559.591,  -24.026 );
nodes[2536] <- snowplowv3( -208.156,  1555.460,  -22.222 );
nodes[2537] <- snowplowv3( -155.986,  1521.045,  -17.263 );
nodes[2538] <- snowplowv3( -134.731,  1453.300,  -15.140 );
nodes[2539] <- snowplowv3( -135.254,  1386.549,  -15.138 );
nodes[2540] <- snowplowv3( -131.462,  1328.052,  -15.144 );
nodes[2541] <- snowplowv3( -131.895,  1281.312,  -15.175, true); // is tunnel
nodes[2542] <- snowplowv3( -103.781,  1210.684,  -14.013, true); // is tunnel
nodes[2543] <- snowplowv3( -68.892,   1115.217,  -11.235, true); // is tunnel
nodes[2544] <- snowplowv3( -43.063,  1020.042,  -11.020 );
nodes[2545] <- snowplowv3( -314.404,  1571.306,  -23.428 );
nodes[2546] <- snowplowv3( -366.551,  1571.123,  -23.428 );
nodes[2547] <- snowplowv3( -379.205,  1564.213,  -23.430 );
nodes[2548] <- snowplowv3( -320.436,  1564.458,  -23.434 );
nodes[2549] <- snowplowv3( -750.324,  1457.903,  0.051 );
nodes[2550] <- snowplowv3( -1224.877,  1689.223,  11.463 );
nodes[2551] <- snowplowv3( -1264.866,  1689.190,  11.129 );
nodes[2552] <- snowplowv3( -1330.659,  1689.363,  10.581 );
nodes[2553] <- snowplowv3( -1421.822,  1689.421,  7.124 );
nodes[2554] <- snowplowv3( -1431.387,  1685.105,  6.384 );
nodes[2555] <- snowplowv3( -1362.518,  1685.264,  10.323 );
nodes[2556] <- snowplowv3( -1297.301,  1685.239,  10.862 );
nodes[2557] <- snowplowv3( -1235.834,  1685.170,  11.368 );
nodes[2558] <- snowplowv3( -1588.631,  605.762,  -10.048 );
nodes[2559] <- snowplowv3( -1524.526,  605.862,  -8.071 );
nodes[2560] <- snowplowv3( -1434.970,  605.895,  -1.105 );
nodes[2561] <- snowplowv3( -1358.918,  606.061,  6.513 );
nodes[2562] <- snowplowv3( -1283.616,  605.749,  13.163 );
nodes[2563] <- snowplowv3( -1216.255,  605.610,  18.067 );
nodes[2564] <- snowplowv3( -1144.100,  605.632,  21.228 );
nodes[2565] <- snowplowv3( -1074.053,  605.857,  22.314 );
nodes[2566] <- snowplowv3( -1007.273,  605.692,  22.388 );
nodes[2567] <- snowplowv3( -943.154,  605.758,  21.740 );
nodes[2568] <- snowplowv3( -872.288,  605.763,  20.252 );
nodes[2569] <- snowplowv3( -802.831,  605.608,  18.051 );
nodes[2570] <- snowplowv3( -734.393,  605.606,  15.033 );
nodes[2571] <- snowplowv3( -664.673,  605.801,  11.192 );
nodes[2572] <- snowplowv3( -597.536,  605.979,  6.784 );
nodes[2573] <- snowplowv3( -524.037,  605.825,  2.020 );
nodes[2574] <- snowplowv3( -508.908,  633.240,  1.419 );
nodes[2575] <- snowplowv3( -561.852,  633.257,  4.121 );
nodes[2576] <- snowplowv3( -635.738,  629.053,  9.402 );
nodes[2577] <- snowplowv3( -749.999,  629.097,  15.781 );
nodes[2578] <- snowplowv3( -831.569,  629.172,  19.039 );
nodes[2579] <- snowplowv3( -892.301,  629.158,  20.793 );
nodes[2580] <- snowplowv3( -962.317,  629.166,  22.004 );
nodes[2581] <- snowplowv3( -1033.134,  629.258,  22.432 );
nodes[2582] <- snowplowv3( -1109.259,  628.863,  21.931 );
nodes[2583] <- snowplowv3( -1183.401,  628.975,  19.871 );
nodes[2584] <- snowplowv3( -1276.868,  629.109,  13.711 );
nodes[2585] <- snowplowv3( -1390.184,  628.940,  3.493 );
nodes[2586] <- snowplowv3( -1494.441,  628.880,  -6.197 );
nodes[2587] <- snowplowv3( -1578.859,  628.653,  -10.064 );
nodes[2588] <- snowplowv3( -1615.354,  593.418,  -9.996 );
nodes[2589] <- snowplowv3( -1596.126,  524.355,  -5.482 );
nodes[2590] <- snowplowv3( -1558.254,  471.508,  -1.977 );
nodes[2591] <- snowplowv3( -1515.558,  419.645,  0.155 );
nodes[2592] <- snowplowv3( -1469.531,  365.822,  0.913 );
nodes[2593] <- snowplowv3( -1425.278,  312.716,  0.074 );
nodes[2594] <- snowplowv3( -1390.948,  252.776,  -3.217 );
nodes[2595] <- snowplowv3( -1381.599,  188.809,  -7.269 );
nodes[2596] <- snowplowv3( -1381.578,  123.006,  -11.167 );
nodes[2597] <- snowplowv3( -1381.344,  67.564,  -14.431 );
nodes[2598] <- snowplowv3( -1380.531,  7.771,  -16.874 );
nodes[2599] <- snowplowv3( -1376.769,  2.191,  -17.064 );
nodes[2600] <- snowplowv3( -1377.999,  54.051,  -15.226 );
nodes[2601] <- snowplowv3( -1377.663,  112.946,  -11.759 );
nodes[2602] <- snowplowv3( -1377.687,  180.046,  -7.788 );
nodes[2603] <- snowplowv3( -1384.407,  247.552,  -3.640 );
nodes[2604] <- snowplowv3( -1413.085,  304.494,  -0.382 );
nodes[2605] <- snowplowv3( -1456.254,  356.562,  0.876 );
nodes[2606] <- snowplowv3( -1505.310,  414.549,  0.359 );
nodes[2607] <- snowplowv3( -1548.053,  466.142,  -1.548 );
nodes[2608] <- snowplowv3( -1587.190,  518.235,  -4.882 );
nodes[2609] <- snowplowv3( -1610.769,  579.680,  -9.547 );
nodes[2610] <- snowplowv3( -1608.132,  620.093,  -10.047 );
nodes[2611] <- snowplowv3( -1620.234,  593.179,  -9.995 );
nodes[2612] <- snowplowv3( -1603.798,  529.190,  -5.947 );
nodes[2613] <- snowplowv3( -1565.456,  473.136,  -2.239 );
nodes[2614] <- snowplowv3( -1518.056,  415.698,  0.185 );
nodes[2615] <- snowplowv3( -1473.640,  363.625,  0.917 );
nodes[2616] <- snowplowv3( -1430.693,  312.473,  0.163 );
nodes[2617] <- snowplowv3( -1395.512,  252.622,  -3.117 );
nodes[2618] <- snowplowv3( -1386.261,  189.501,  -7.226 );
nodes[2619] <- snowplowv3( -1386.023,  122.826,  -11.171 );
nodes[2620] <- snowplowv3( -1385.919,  66.525,  -14.504 );
nodes[2621] <- snowplowv3( -1384.933,  7.903,  -16.880 );
nodes[2622] <- snowplowv3( -1372.219,  -2.238,  -17.150 );
nodes[2623] <- snowplowv3( -1373.368,  47.572,  -15.555 );
nodes[2624] <- snowplowv3( -1373.198,  117.100,  -11.508 );
nodes[2625] <- snowplowv3( -1373.166,  182.246,  -7.655 );
nodes[2626] <- snowplowv3( -1380.263,  248.417,  -3.663 );
nodes[2627] <- snowplowv3( -1410.827,  308.365,  -0.310 );
nodes[2628] <- snowplowv3( -1454.901,  361.598,  0.885 );
nodes[2629] <- snowplowv3( -1504.468,  420.025,  0.293 );
nodes[2630] <- snowplowv3( -1548.424,  472.949,  -1.758 );
nodes[2631] <- snowplowv3( -1584.327,  521.319,  -4.978 );
nodes[2632] <- snowplowv3( -1606.310,  578.119,  -9.448 );
nodes[2633] <- snowplowv3( -1761.267,  1.775,  -6.029 );
nodes[2634] <- snowplowv3( -1761.380,  61.435,  -4.342 );
nodes[2635] <- snowplowv3( -1760.157,  94.993,  -4.013 );
nodes[2636] <- snowplowv3( -1727.351,  144.615,  -5.604 );
nodes[2637] <- snowplowv3( -1677.960,  157.462,  -6.907 );
nodes[2638] <- snowplowv3( -1646.019,  156.647,  -7.071 );
nodes[2639] <- snowplowv3( -1593.034,  156.353,  -12.333 );
nodes[2640] <- snowplowv3( -1553.467,  156.283,  -13.145 );
nodes[2641] <- snowplowv3( -1490.208,  156.419,  -14.457 );
nodes[2642] <- snowplowv3( -1428.621,  156.351,  -19.621 );
nodes[2643] <- snowplowv3( -1426.175,  159.922,  -19.970 );
nodes[2644] <- snowplowv3( -1482.455,  159.768,  -14.573 );
nodes[2645] <- snowplowv3( -1547.631,  159.501,  -13.148 );
nodes[2646] <- snowplowv3( -1585.788,  159.579,  -13.015 );
nodes[2647] <- snowplowv3( -1639.750,  159.666,  -7.441 );
nodes[2648] <- snowplowv3( -1669.979,  159.756,  -6.930 );
nodes[2649] <- snowplowv3( -1704.205,  159.564,  -6.345 );
nodes[2650] <- snowplowv3( -1743.867,  134.145,  -5.255 );
nodes[2651] <- snowplowv3( -1762.868,  97.935,  -4.033 );
nodes[2652] <- snowplowv3( -1764.716,  64.725,  -4.310 );
nodes[2653] <- snowplowv3( -1764.832,  3.359,  -5.881 );
nodes[2654] <- snowplowv3( -1774.352,  83.278,  -3.455 );
nodes[2655] <- snowplowv3( -1808.130,  83.266,  -0.407 );
nodes[2656] <- snowplowv3( -1835.690,  66.159,  -1.215 );
nodes[2657] <- snowplowv3( -1843.500,  -0.062,  -2.548 );
nodes[2658] <- snowplowv3( -1843.326,  -29.035,  -2.774 );
nodes[2659] <- snowplowv3( -1822.430,  -65.735,  -5.269 );
nodes[2660] <- snowplowv3( -1785.631,  -98.856,  -10.114 );
nodes[2661] <- snowplowv3( -1758.681,  -133.233,  -14.023 );
nodes[2662] <- snowplowv3( -1736.816,  -180.343,  -18.203 );
nodes[2663] <- snowplowv3( -1715.803,  -202.745,  -20.016 );
nodes[2664] <- snowplowv3( -1674.210,  -203.697,  -19.892 );
nodes[2665] <- snowplowv3( -1672.760,  -198.610,  -19.887 );
nodes[2666] <- snowplowv3( -1711.557,  -197.466,  -20.069 );
nodes[2667] <- snowplowv3( -1734.029,  -173.313,  -17.818 );
nodes[2668] <- snowplowv3( -1754.316,  -129.551,  -13.847 );
nodes[2669] <- snowplowv3( -1780.695,  -95.625,  -10.119 );
nodes[2670] <- snowplowv3( -1835.430,  -37.814,  -3.058 );
nodes[2671] <- snowplowv3( -1837.287,  -3.201,  -2.665 );
nodes[2672] <- snowplowv3( -1837.032,  45.355,  -1.502 );
nodes[2673] <- snowplowv3( -1814.052,  75.865,  -0.675 );
nodes[2674] <- snowplowv3( -1778.591,  78.063,  -3.034 );
nodes[2675] <- snowplowv3( -1657.154,  -184.789,  -19.884 );
nodes[2676] <- snowplowv3( -1656.614,  -104.547,  -15.476 );
nodes[2677] <- snowplowv3( -1656.548,  -36.161,  -12.342 );
nodes[2678] <- snowplowv3( -1656.869,  -0.497,  -11.534 );
nodes[2679] <- snowplowv3( -1656.718,  72.947,  -9.078 );
nodes[2680] <- snowplowv3( -1656.685,  136.357,  -6.845 );
nodes[2681] <- snowplowv3( -1660.011,  144.815,  -6.890 );
nodes[2682] <- snowplowv3( -1660.164,  78.914,  -9.010 );
nodes[2683] <- snowplowv3( -1660.193,  4.897,  -11.351 );
nodes[2684] <- snowplowv3( -1659.847,  -29.021,  -11.776 );
nodes[2685] <- snowplowv3( -1660.040,  -98.862,  -15.458 );
nodes[2686] <- snowplowv3( -1660.473,  -179.656,  -19.618 );
nodes[2687] <- snowplowv3( -831.941,  -461.840,  -25.908 );
nodes[2688] <- snowplowv3( -903.638,  -457.973,  -34.542 );
nodes[2689] <- snowplowv3( -996.8610,  -455.037,  -34.644, true); // is tunnel
nodes[2690] <- snowplowv3( -1077.966,  -428.092,  -34.641, true); // is tunnel
nodes[2691] <- snowplowv3( -1143.447,  -375.524,  -34.644, true); // is tunnel
nodes[2692] <- snowplowv3( -1223.670,  -313.739,  -34.643, true); // is tunnel
nodes[2693] <- snowplowv3( -1302.618,  -291.043,  -34.643, true); // is tunnel
nodes[2694] <- snowplowv3( -1400.986,  -289.736,  -34.536 );
nodes[2695] <- snowplowv3( -1445.243,  -291.578,  -29.572 );
nodes[2696] <- snowplowv3( -1516.190,  -293.647,  -20.766 );
nodes[2697] <- snowplowv3( -1559.081,  -293.802,  -20.032 );
nodes[2698] <- snowplowv3( -1609.473,  -293.219,  -20.107 );
nodes[2699] <- snowplowv3( -1642.478,  -275.362,  -20.106 );
nodes[2700] <- snowplowv3( -1651.688,  -222.138,  -20.133 );
nodes[2701] <- snowplowv3( -1659.378,  -218.360,  -20.154 );
nodes[2702] <- snowplowv3( -1656.121,  -269.296,  -20.107 );
nodes[2703] <- snowplowv3( -1617.003,  -300.885,  -20.108 );
nodes[2704] <- snowplowv3( -1566.493,  -302.211,  -20.034 );
nodes[2705] <- snowplowv3( -1528.194,  -302.165,  -20.040 );
nodes[2706] <- snowplowv3( -1471.090,  -302.253,  -26.294 );
nodes[2707] <- snowplowv3( -1413.715,  -305.379,  -33.336 );
nodes[2708] <- snowplowv3( -1322.090,  -308.076,  -34.639, true); // is tunnel
nodes[2709] <- snowplowv3( -1244.397,  -332.915,  -34.643, true); // is tunnel
nodes[2710] <- snowplowv3( -1182.036,  -379.779,  -34.643, true); // is tunnel
nodes[2711] <- snowplowv3( -1098.997,  -447.447,  -34.651, true); // is tunnel
nodes[2712] <- snowplowv3( -1007.929,  -472.665,  -34.644, true); // is tunnel
nodes[2713] <- snowplowv3( -917.002,  -473.010,  -34.642 );
nodes[2714] <- snowplowv3( -836.215,  -469.215,  -26.182 );
nodes[2715] <- snowplowv3( -1663.106,  -218.456,  -20.158 );
nodes[2716] <- snowplowv3( -1662.648,  -256.698,  -20.113 );
nodes[2717] <- snowplowv3( -1638.161,  -296.079,  -20.106 );
nodes[2718] <- snowplowv3( -1610.382,  -305.521,  -20.106 );
nodes[2719] <- snowplowv3( -1560.055,  -305.751,  -20.028 );
nodes[2720] <- snowplowv3( -1525.715,  -305.527,  -20.033 );
nodes[2721] <- snowplowv3( -1471.582,  -306.209,  -26.235 );
nodes[2722] <- snowplowv3( -1414.333,  -309.680,  -33.277 );
nodes[2723] <- snowplowv3( -1327.741,  -311.483,  -34.645, true); // is tunnel
nodes[2724] <- snowplowv3( -1251.689,  -334.530,  -34.645, true); // is tunnel
nodes[2725] <- snowplowv3( -1187.728,  -380.355,  -34.641, true); // is tunnel
nodes[2726] <- snowplowv3( -1106.074,  -449.056,  -34.642, true); // is tunnel
nodes[2727] <- snowplowv3( -1011.781,  -476.923,  -34.645, true); // is tunnel
nodes[2728] <- snowplowv3( -917.134,  -477.314,  -34.644 );
nodes[2729] <- snowplowv3( -836.698,  -473.083,  -26.216 );
nodes[2730] <- snowplowv3( -811.085,  -452.042,  -25.713 );
nodes[2731] <- snowplowv3( -810.381,  -388.908,  -22.232 );
nodes[2732] <- snowplowv3( -784.200,  -351.146,  -15.988 );
nodes[2733] <- snowplowv3( -740.665,  -363.987,  -12.216 );
nodes[2734] <- snowplowv3( -92.072,  -606.784,  -19.996 );
nodes[2735] <- snowplowv3( -30.655,  -607.073,  -19.999 );
nodes[2736] <- snowplowv3( 50.020,  -607.347,  -19.997 );
nodes[2737] <- snowplowv3( 69.938,  -605.876,  -19.998 );
nodes[2738] <- snowplowv3( 50.614,  -603.272,  -19.993 );
nodes[2739] <- snowplowv3( -19.304,  -603.486,  -20.002 );
nodes[2740] <- snowplowv3( -86.249,  -603.434,  -20.007 );
nodes[2741] <- snowplowv3( -426.648,  -296.840,  -11.616 );
nodes[2742] <- snowplowv3( -464.940,  617.331,  0.622 );
nodes[2743] <- snowplowv3( -164.655,  815.456,  -20.692 );
nodes[2744] <- snowplowv3( -160.396,  877.578,  -20.402 );
nodes[2745] <- snowplowv3( -119.432,  939.934,  -16.743 );
nodes[2746] <- snowplowv3( -71.833,  951.550,  -13.674 );
nodes[2747] <- snowplowv3( -34.019,  928.096,  -11.073 );
nodes[2748] <- snowplowv3( -39.859,  991.016,  -11.010 );
nodes[2749] <- snowplowv3( -7.005,  867.393,  -11.016 );
nodes[2750] <- snowplowv3( 15.344,  784.089,  -11.007 );
nodes[2751] <- snowplowv3( 39.308,  696.303,  -11.000 );
nodes[2752] <- snowplowv3( 76.317,  612.549,  -10.995 );
nodes[2753] <- snowplowv3( 153.557,  563.913,  -10.997 );
nodes[2754] <- snowplowv3( 251.469,  543.736,  -10.996 );
nodes[2755] <- snowplowv3( 350.902,  513.481,  -10.972 );
nodes[2756] <- snowplowv3( 449.356,  482.765,  -10.149 );
nodes[2757] <- snowplowv3( 519.065,  427.163,  -7.072 );
nodes[2758] <- snowplowv3( -1644.885,  -204.153,  -19.873 );
nodes[2759] <- snowplowv3( -1600.580,  -204.064,  -19.870 );
nodes[2760] <- snowplowv3( -1556.074,  -204.171,  -19.873 );
nodes[2761] <- snowplowv3( -1529.005,  -204.120,  -19.867 );
nodes[2762] <- snowplowv3( -1471.800,  -204.327,  -19.874 );
nodes[2763] <- snowplowv3( -1417.197,  -204.502,  -19.883 );
nodes[2764] <- snowplowv3( -1367.046,  -201.822,  -19.895 );
nodes[2765] <- snowplowv3( -1332.715,  -167.929,  -20.235 );
nodes[2766] <- snowplowv3( -1325.008,  -130.767,  -20.214 );
nodes[2767] <- snowplowv3( -1339.127,  -95.954,  -19.354 );
nodes[2768] <- snowplowv3( -1371.710,  -32.878,  -17.717 );
nodes[2769] <- snowplowv3( -1378.214,  -29.878,  -17.705 );
nodes[2770] <- snowplowv3( -1347.197,  -94.331,  -19.251 );
nodes[2771] <- snowplowv3( -1331.936,  -128.767,  -20.188 );
nodes[2772] <- snowplowv3( -1339.664,  -167.147,  -20.238 );
nodes[2773] <- snowplowv3( -1364.645,  -193.945,  -19.916 );
nodes[2774] <- snowplowv3( -1411.845,  -198.007,  -19.879 );
nodes[2775] <- snowplowv3( -1468.427,  -198.127,  -19.880 );
nodes[2776] <- snowplowv3( -1525.377,  -198.418,  -19.865 );
nodes[2777] <- snowplowv3( -1554.917,  -198.448,  -19.867 );
nodes[2778] <- snowplowv3( -1598.932,  -198.352,  -19.870 );
nodes[2779] <- snowplowv3( -1640.215,  -198.350,  -19.870 );
nodes[2780] <- snowplowv3( -1540.884,  -282.427,  -20.038 );
nodes[2781] <- snowplowv3( -1538.637,  -248.305,  -20.027 );
nodes[2782] <- snowplowv3( -1471.650,  -244.025,  -20.029 );
nodes[2783] <- snowplowv3( -1435.635,  -239.788,  -20.033 );
nodes[2784] <- snowplowv3( -1378.432,  -225.666,  -20.032 );
nodes[2785] <- snowplowv3( -1312.311,  -217.127,  -23.411 );
nodes[2786] <- snowplowv3( -1308.094,  -163.666,  -23.423 );
nodes[2787] <- snowplowv3( -1308.334,  -122.465,  -23.424 );
nodes[2788] <- snowplowv3( -1323.865,  -86.174,  -23.425 );
nodes[2789] <- snowplowv3( -1341.347,  -53.772,  -23.433 );
nodes[2790] <- snowplowv3( -1342.464,  10.024,  -23.427 );
nodes[2791] <- snowplowv3( -1345.071,  51.736,  -23.420 );
nodes[2792] <- snowplowv3( -1344.195,  87.836,  -23.430 );
nodes[2793] <- snowplowv3( -1344.038,  139.861,  -23.433 );
nodes[2794] <- snowplowv3( -1343.952,  196.678,  -23.423 );
nodes[2795] <- snowplowv3( -1347.280,  196.883,  -23.429 );
nodes[2796] <- snowplowv3( -1347.388,  140.654,  -23.425 );
nodes[2797] <- snowplowv3( -1347.700,  95.290,  -23.429 );
nodes[2798] <- snowplowv3( -1348.486,  63.355,  -23.427 );
nodes[2799] <- snowplowv3( -1346.266,  10.748,  -23.428 );
nodes[2800] <- snowplowv3( -1346.972,  -25.960,  -23.425 );
nodes[2801] <- snowplowv3( -1347.936,  -46.699,  -23.431 );
nodes[2802] <- snowplowv3( -1330.163,  -83.180,  -23.428 );
nodes[2803] <- snowplowv3( -1312.667,  -122.714,  -23.428 );
nodes[2804] <- snowplowv3( -1312.597,  -160.131,  -23.426 );
nodes[2805] <- snowplowv3( -1315.887,  -212.439,  -23.134 );
nodes[2806] <- snowplowv3( -1349.412,  -215.286,  -20.031 );
nodes[2807] <- snowplowv3( -1403.073,  -226.372,  -20.032 );
nodes[2808] <- snowplowv3( -1450.183,  -237.978,  -20.034 );
nodes[2809] <- snowplowv3( -1540.547,  -243.949,  -20.034 );
nodes[2810] <- snowplowv3( -1545.136,  -282.782,  -20.035 );
nodes[2811] <- snowplowv3( -1412.865,  144.515,  -20.564 );
nodes[2812] <- snowplowv3( -1413.108,  93.891,  -21.250 );
nodes[2813] <- snowplowv3( -1400.378,  73.162,  -21.530 );
nodes[2814] <- snowplowv3( -1361.372,  71.990,  -23.435 );
nodes[2815] <- snowplowv3( -1356.810,  76.730,  -23.414 );
nodes[2816] <- snowplowv3( -1396.821,  76.661,  -21.889 );
nodes[2817] <- snowplowv3( -1409.474,  88.332,  -21.348 );
nodes[2818] <- snowplowv3( -1410.035,  143.513,  -20.623 );
nodes[2819] <- snowplowv3( -1409.898,  170.737,  -20.673 );
nodes[2820] <- snowplowv3( -1409.938,  196.626,  -24.376 );
nodes[2821] <- snowplowv3( -1400.636,  206.980,  -24.554 );
nodes[2822] <- snowplowv3( -1362.326,  207.377,  -23.428 );
nodes[2823] <- snowplowv3( -1335.278,  207.300,  -23.428 );
nodes[2824] <- snowplowv3( -1288.824,  206.846,  -23.428 );
nodes[2825] <- snowplowv3( -1268.663,  225.495,  -23.432 );
nodes[2826] <- snowplowv3( -1268.849,  281.862,  -23.433 );
nodes[2827] <- snowplowv3( -1282.217,  298.488,  -23.395 );
nodes[2828] <- snowplowv3( -1338.131,  298.920,  -22.590 );
nodes[2829] <- snowplowv3( -1392.775,  298.845,  -21.747 );
nodes[2830] <- snowplowv3( -1405.862,  309.472,  -21.370 );
nodes[2831] <- snowplowv3( -1406.109,  335.485,  -21.503 );
nodes[2832] <- snowplowv3( -1409.771,  336.314,  -21.307 );
nodes[2833] <- snowplowv3( -1409.953,  312.007,  -21.268 );
nodes[2834] <- snowplowv3( -1395.413,  294.962,  -21.830 );
nodes[2835] <- snowplowv3( -1345.982,  295.547,  -22.478 );
nodes[2836] <- snowplowv3( -1285.116,  295.481,  -23.367 );
nodes[2837] <- snowplowv3( -1272.068,  280.933,  -23.419 );
nodes[2838] <- snowplowv3( -1272.321,  230.529,  -23.433 );
nodes[2839] <- snowplowv3( -1289.518,  210.289,  -23.429 );
nodes[2840] <- snowplowv3( -1330.217,  210.757,  -23.425 );
nodes[2841] <- snowplowv3( -1356.915,  210.697,  -23.430 );
nodes[2842] <- snowplowv3( -1396.228,  210.689,  -24.399 );
nodes[2843] <- snowplowv3( -1413.574,  195.219,  -24.244 );
nodes[2844] <- snowplowv3( -1413.265,  172.835,  -20.915 );
nodes[2845] <- snowplowv3( -1410.094,  218.287,  -24.623 );
nodes[2846] <- snowplowv3( -1408.692,  284.265,  -22.264 );
nodes[2847] <- snowplowv3( -1411.617,  289.598,  -21.996 );
nodes[2848] <- snowplowv3( -1413.551,  224.309,  -24.803 );
nodes[2849] <- snowplowv3( -1350.723,  346.651,  -23.440 );
nodes[2850] <- snowplowv3( -1310.653,  341.244,  -23.428 );
nodes[2851] <- snowplowv3( -1277.234,  339.077,  -23.429 );
nodes[2852] <- snowplowv3( -1272.107,  312.841,  -23.431 );
nodes[2853] <- snowplowv3( -1269.021,  309.890,  -23.429 );
nodes[2854] <- snowplowv3( -1271.199,  339.967,  -23.431 );
nodes[2855] <- snowplowv3( -1302.999,  345.053,  -23.425 );
nodes[2856] <- snowplowv3( -1343.111,  346.564,  -23.430 );
nodes[2857] <- snowplowv3( -481.038,  176.093,  1.220 );
nodes[2858] <- snowplowv3( -534.342,  176.115,  1.516 );
nodes[2859] <- snowplowv3( -197.102,  -42.643,  -11.878 );
nodes[2860] <- snowplowv3( -496.835,  942.053,  -18.895 );
nodes[2861] <- snowplowv3( -496.956,  986.999,  -16.051 );
nodes[2862] <- snowplowv3( -497.902,  1070.996,  -17.236, true); // is tunnel
nodes[2863] <- snowplowv3( -501.332,  1153.307,  -21.754, true); // is tunnel
nodes[2864] <- snowplowv3( -515.209,  1233.275,  -27.193, true); // is tunnel
nodes[2865] <- snowplowv3( -572.666,  1309.255,  -32.737, true); // is tunnel
nodes[2866] <- snowplowv3( -670.536,  1368.128,  -35.078, true); // is tunnel
nodes[2867] <- snowplowv3( -768.017,  1382.971,  -33.813, true); // is tunnel
nodes[2868] <- snowplowv3( -849.437,  1382.949,  -25.577, true); // is tunnel
nodes[2869] <- snowplowv3( -929.854,  1382.650,  -21.307 );
nodes[2870] <- snowplowv3( -967.612,  1382.719,  -14.325 );
nodes[2871] <- snowplowv3( -1004.307,  1382.346,  -13.411 );
nodes[2872] <- snowplowv3( -370.382,  413.812,  -1.260 );
nodes[2873] <- snowplowv3( -299.258,  413.806,  -5.391 );
nodes[2874] <- snowplowv3( -225.649,  413.655,  -6.133 );
nodes[2875] <- snowplowv3( -215.225,  396.322,  -6.130 );
nodes[2876] <- snowplowv3( -215.628,  346.341,  -6.170 );
nodes[2877] <- snowplowv3( -215.593,  308.173,  -6.241 );
nodes[2878] <- snowplowv3( -196.421,  284.587,  -6.295 );
nodes[2879] <- snowplowv3( -157.497,  284.096,  -10.980 );
nodes[2880] <- snowplowv3( -151.589,  293.823,  -11.793 );
nodes[2881] <- snowplowv3( -191.155,  290.126,  -6.422 );
nodes[2882] <- snowplowv3( -194.521,  280.679,  -6.290 );
nodes[2883] <- snowplowv3( -157.760,  280.478,  -10.945 );
nodes[2884] <- snowplowv3( -26.105,  956.645,  -11.018 );
nodes[2885] <- snowplowv3( -6.031,  881.389,  -11.016 );
nodes[2886] <- snowplowv3( 17.916,  791.894,  -11.009 );
nodes[2887] <- snowplowv3( 41.882,  703.007,  -10.999 );
nodes[2888] <- snowplowv3( 65.648,  635.590,  -10.996 );
nodes[2889] <- snowplowv3( 137.164,  573.911,  -10.997 );
nodes[2890] <- snowplowv3( 239.025,  550.201,  -10.996 );
nodes[2891] <- snowplowv3( 334.574,  522.573,  -10.994 );
nodes[2892] <- snowplowv3( 436.120,  491.606,  -10.649 );
nodes[2893] <- snowplowv3( 525.854,  422.146,  -6.912 );
nodes[2894] <- snowplowv3( 539.015,  253.774,  -3.271 );
nodes[2895] <- snowplowv3( 591.493,  126.558,  3.781 );
nodes[2896] <- snowplowv3( 740.654,  39.363,  4.673 );
nodes[2897] <- snowplowv3( 814.200,  -35.625,  3.215 );
nodes[2898] <- snowplowv3( 839.871,  -118.161,  -0.174 );
nodes[2899] <- snowplowv3( 840.317,  -219.794,  -4.574 );
nodes[2900] <- snowplowv3( 840.296,  -319.959,  -8.939 );
nodes[2901] <- snowplowv3( 825.956,  -414.420,  -10.928 );
nodes[2902] <- snowplowv3( 757.933,  -472.371,  -10.923 );
nodes[2903] <- snowplowv3( 661.113,  -478.688,  -10.921 );
nodes[2904] <- snowplowv3( 517.623,  -478.652,  -10.923 );
nodes[2905] <- snowplowv3( 411.839,  -478.680,  -10.923 );
nodes[2906] <- snowplowv3( 316.569,  -478.673,  -10.716 );
nodes[2907] <- snowplowv3( 209.100,  -488.149,  -8.155 );
nodes[2908] <- snowplowv3( 125.725,  -552.553,  -7.173 );
nodes[2909] <- snowplowv3( 66.166,  -607.809,  -6.864 );
nodes[2910] <- snowplowv3( -16.282,  -617.217,  -8.258 );
nodes[2911] <- snowplowv3( -111.014,  -617.047,  -9.851 );
nodes[2912] <- snowplowv3( -192.723,  -617.031,  -10.598 );
nodes[2913] <- snowplowv3( -276.171,  -617.028,  -10.885 );
nodes[2914] <- snowplowv3( -359.497,  -617.621,  -10.904 );
nodes[2915] <- snowplowv3( -486.944,  -604.569,  -10.859 );
nodes[2916] <- snowplowv3( -564.209,  -578.389,  -10.886 );
nodes[2917] <- snowplowv3( -631.320,  -534.444,  -11.032 );
nodes[2918] <- snowplowv3( -683.208,  -468.524,  -11.477 );
nodes[2919] <- snowplowv3( -713.338,  -391.495,  -11.486 );
nodes[2920] <- snowplowv3( -723.372,  -308.117,  -10.941 );
nodes[2921] <- snowplowv3( -724.358,  -211.664,  -5.630 );
nodes[2922] <- snowplowv3( -727.008,  -120.108,  -5.640 );
nodes[2923] <- snowplowv3( -727.175,  -21.713,  -5.637 );
nodes[2924] <- snowplowv3( -726.944,  102.113,  -5.638 );
nodes[2925] <- snowplowv3( -727.184,  220.135,  -5.639 );
nodes[2926] <- snowplowv3( -725.896,  339.338,  -5.639 );
nodes[2927] <- snowplowv3( -721.064,  434.044,  -5.639 );
nodes[2928] <- snowplowv3( -720.638,  522.432,  -6.443 );
nodes[2929] <- snowplowv3( -696.118,  649.757,  1.102 );
nodes[2930] <- snowplowv3( -622.312,  688.975,  4.261 );
nodes[2931] <- snowplowv3( -557.851,  688.626,  3.094 );
nodes[2932] <- snowplowv3( -526.505,  683.840,  2.461 );
nodes[2933] <- snowplowv3( -494.219,  646.917,  1.251 );
nodes[2934] <- snowplowv3( 532.879,  350.356,  -6.323 );
nodes[2935] <- snowplowv3( 535.660,  241.431,  -2.487 );
nodes[2936] <- snowplowv3( 587.113,  125.556,  3.700 );
nodes[2937] <- snowplowv3( 766.081,  16.776,  4.433 );
nodes[2938] <- snowplowv3( 821.096,  -57.149,  2.494 );
nodes[2939] <- snowplowv3( 836.268,  -157.871,  -1.877 );
nodes[2940] <- snowplowv3( 836.615,  -256.847,  -6.189 );
nodes[2941] <- snowplowv3( 836.790,  -351.673,  -10.320 );
nodes[2942] <- snowplowv3( 809.064,  -432.581,  -10.922 );
nodes[2943] <- snowplowv3( 730.661,  -474.451,  -10.927 );
nodes[2944] <- snowplowv3( 627.867,  -474.974,  -10.924 );
nodes[2945] <- snowplowv3( 535.760,  -475.005,  -10.926 );
nodes[2946] <- snowplowv3( 438.250,  -475.020,  -10.921 );
nodes[2947] <- snowplowv3( 342.833,  -475.012,  -10.884 );
nodes[2948] <- snowplowv3( 240.770,  -476.872,  -9.128 );
nodes[2949] <- snowplowv3( 147.440,  -524.164,  -7.019 );
nodes[2950] <- snowplowv3( 82.723,  -592.262,  -7.131 );
nodes[2951] <- snowplowv3( -1.450,  -613.492,  -8.032 );
nodes[2952] <- snowplowv3( -84.488,  -613.182,  -9.509 );
nodes[2953] <- snowplowv3( -165.790,  -613.440,  -10.430 );
nodes[2954] <- snowplowv3( -251.085,  -613.432,  -10.835 );
nodes[2955] <- snowplowv3( -341.301,  -613.595,  -10.910 );
nodes[2956] <- snowplowv3( -421.804,  -610.539,  -10.932 );
nodes[2957] <- snowplowv3( -521.135,  -591.558,  -10.922 );
nodes[2958] <- snowplowv3( -593.359,  -558.221,  -10.910 );
nodes[2959] <- snowplowv3( -658.662,  -498.526,  -11.279 );
nodes[2960] <- snowplowv3( -690.259,  -446.194,  -11.486 );
nodes[2961] <- snowplowv3( -707.022,  -398.176,  -11.487 );
nodes[2962] <- snowplowv3( -717.319,  -346.424,  -11.484 );
nodes[2963] <- snowplowv3( -719.464,  -282.759,  -9.620 );
nodes[2964] <- snowplowv3( -720.593,  -214.146,  -5.641 );
nodes[2965] <- snowplowv3( -722.833,  -123.577,  -5.638 );
nodes[2966] <- snowplowv3( -723.359,  -30.001,  -5.638 );
nodes[2967] <- snowplowv3( -723.436,  73.939,  -5.638 );
nodes[2968] <- snowplowv3( -723.528,  185.552,  -5.640 );
nodes[2969] <- snowplowv3( -723.273,  295.354,  -5.639 );
nodes[2970] <- snowplowv3( -718.336,  406.426,  -5.639 );
nodes[2971] <- snowplowv3( -716.486,  519.079,  -6.404 );
nodes[2972] <- snowplowv3( -701.597,  631.603,  -0.416 );
nodes[2973] <- snowplowv3( -632.910,  683.965,  3.985 );
nodes[2974] <- snowplowv3( -566.073,  684.868,  3.231 );
nodes[2975] <- snowplowv3( -524.808,  678.652,  2.375 );
nodes[2976] <- snowplowv3( -498.315,  648.224,  1.259 );
nodes[2977] <- snowplowv3( 53.219,  346.074,  -13.929 );
nodes[2978] <- snowplowv3( -1631.717,  1048.299,  -6.284 );
nodes[2979] <- snowplowv3( -1652.041,  1114.120,  -6.967 );

function getSnowplowNodes() {
  return nodes;
}

function getSnowplowNode(id) {
    return (id in nodes) ? nodes[id] : false;
}