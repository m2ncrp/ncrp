addEventHandler("spawnSubway", function(x, y, z) {
    executeLua(format("game.entitywrapper:GetEntityByName(\"Subway\"):SetPos(Math:newVector(%.3f, %.3f, %.3f))", x.tofloat(), y.tofloat(), z.tofloat()));
});

addEventHandler("spawnSubwayToPlayer", function() {
    executeLua("game.entitywrapper:GetEntityByName(\"Subway\"):SetPos(game.game:GetActivePlayer():GetPos())");
});

addEventHandler("setSubwayCarPosition", function(x, y, z) {
    executeLua(format("game.entitywrapper:GetEntityByName(\"Subway\"):SetPos(Math:newVector(%.3f, %.3f, %.3f))", x.tofloat(), y.tofloat(), z.tofloat()));
});

addEventHandler("setSubwayCarRotation", function(x, y, z) {
    executeLua(format("game.entitywrapper:GetEntityByName(\"Subway\"):SetDir(Math:newVector(%.3f, %.3f, %.3f))", x.tofloat(), y.tofloat(), z.tofloat()));
});

function concat(vars, symbol = " ") {
    return vars.reduce(function(carry, item) {
        return item ? carry + symbol + item : "";
    });
}

addEventHandler("setSubwayCarReady", function() {
    local points = [
        [
            -281.67303466797,
            558.40948486328,
            2.1261413097382
        ],
        [
            -281.67993164063,
            537.76257324219,
            2.1259756088257
        ],
        [
            -281.33142089844,
            532.8330078125,
            2.1259918212891
        ],
        [
            -280.43872070313,
            527.47479248047,
            2.1260221004486
        ],
        [
            -278.5436706543,
            521.13092041016,
            2.1260221004486
        ],
        [
            -275.75155639648,
            514.94708251953,
            2.1260221004486
        ],
        [
            -271.00408935547,
            507.87438964844,
            2.1260223388672
        ],
        [
            -264.86282348633,
            501.96942138672,
            2.1260228157043
        ],
        [
            -259.08819580078,
            497.78384399414,
            2.1260228157043
        ],
        [
            -250.34150695801,
            493.93615722656,
            2.1260228157043
        ],
        [
            -241.5570526123,
            491.77420043945,
            2.1260342597961
        ],
        [
            -232.41567993164,
            491.38745117188,
            2.1260344982147
        ],
        [
            -220.48559570313,
            492.13250732422,
            2.1260344982147
        ],
        [
            -210.6669921875,
            493.33529663086,
            1.7260344028473
        ],
        [
            -196.00082397461,
            495.74282836914,
            1.3260407447815
        ],
        [
            -183.68446350098,
            498.32827758789,
            0.92604076862335
        ],
        [
            -170.8406829834,
            501.28561401367,
            0.32604098320007
        ],
        [
            -132.37191772461,
            511.13436889648,
            -0.87380892038345
        ],
        [
            -121.66921234131,
            513.50299072266,
            -0.87379467487335
        ],
        [
            -109.16870880127,
            515.83618164063,
            -1.4737745523453
        ],
        [
            -96.35245513916,
            517.44116210938,
            -1.4737533330917
        ],
        [
            -80.272727966309,
            518.33178710938,
            -2.0737524032593
        ],
        [
            -75.392753601074,
            518.44305419922,
            -2.0737512111664
        ],
        [
            26.036043167114,
            518.22680664063,
            -4.873715877533
        ],
        [
            132.74435424805,
            518.33178710938,
            -4.473662853241
        ]
    ];


    local arr = [
    "POINT_X={-281.67303466797,-281.67993164063,-281.33142089844,-280.43872070313,-278.5436706543,-275.75155639648,-271.00408935547,-264.86282348633,-259.08819580078,-250.34150695801,-241.5570526123,-232.41567993164,-220.48559570313,-210.6669921875,-196.00082397461,-183.68446350098,-170.8406829834,-132.37191772461,-121.66921234131,-109.16870880127,-96.35245513916,-80.272727966309,-75.392753601074,26.036043167114,132.74435424805}",
    "POINT_Y={558.40948486328,537.76257324219,532.8330078125,527.47479248047,521.13092041016,514.94708251953,507.87438964844,501.96942138672,497.78384399414,493.93615722656,491.77420043945,491.38745117188,492.13250732422,493.33529663086,495.74282836914,498.32827758789,501.28561401367,511.13436889648,513.50299072266,515.83618164063,517.44116210938,518.33178710938,518.44305419922,518.22680664063,518.33178710938}",
    "POINT_Z={2.1261413097382,2.1259756088257,2.1259918212891,2.1260221004486,2.1260221004486,2.1260221004486,2.1260223388672,2.1260228157043,2.1260228157043,2.1260228157043,2.1260342597961,2.1260344982147,2.1260344982147,1.7260344028473,1.3260407447815,0.92604076862335,0.32604098320007,-0.87380892038345,-0.87379467487335,-1.4737745523453,-1.4737533330917,-2.0737524032593,-2.0737512111664,-4.873715877533,-4.473662853241}",
    "Subway=game.entitywrapper:GetEntityByName(\"Subway\")",
    "player=game.game:GetActivePlayer()",
    "PointENT=game.entitywrapper:GetEntityByName(\"Dummy_00\")",
    "pointNUMBER=1 Blocker=game.game:CreateBlocker(Subway:GetPos(), Subway:GetDir(), Math:newVector(3, 9, 2), enums.BlockingType.E_BLCK_PLAYER)",
    "Blocker:Activate()",
    "DelayBuffer:Insert(function(l_1_0)",
        "CommandBuffer:Insert(l_1_0,{ function(l_1_0)",
            "PointENT:SetPos(Math:newVector(POINT_X[pointNUMBER], POINT_Y[pointNUMBER], POINT_Z[pointNUMBER]))",
        "end})",
    "end,{l_1_0},5,0,false)",
    "DelayBuffer:Insert(function(l_1_0)",
        "CommandBuffer:Insert(l_1_0, {",
            "function(l_1_0)",
                "POSx=Subway:GetPos().x - PointENT:GetPos().x",
                "POSy=Subway:GetPos().y - PointENT:GetPos().y",
                "POSz=Subway:GetPos().z - PointENT:GetPos().z",
                "POS_DELIC=math.abs(POSx)+math.abs(POSy)+math.abs(POSz)",
                "Subway:SetDir (Math:newVector(POSx/POS_DELIC,POSy/POS_DELIC,POSz/POS_DELIC)*-1)",
            "end,",
            "function(l_2_0)",
                "if  (Subway:GetPos() - PointENT:GetPos()):magnitude2() < 5",
                "then",
                "pointNUMBER = pointNUMBER + 1",
            "end",
        "end })",
    "end,{l_1_0},10,0,false)",
    "DelayBuffer:Insert(",
        "function(l_1_0)",
        "if  game.datastore:GetBool(\"SubwayGo\")==true",
        "then",
        "Subway:SetPos(Subway:GetPos() + Subway:GetDir() *0.15)",
        "Blocker:SetPos(Subway:GetPos())",
        "Blocker:SetDir(Subway:GetDir())",
            "else Subway:SetPos(Subway:GetPos())",
        "end",
    "end,{},1,0,false)"
    ];

    executeLua(concat(arr," "))

});

addEventHandler("setSubwayCarGo", function() {
    executeLua("game.datastore:SetBool(\"SubwayGo\", true)");
})

addEventHandler("setSubwayCarStop", function() {
    executeLua("game.datastore:SetBool(\"SubwayGo\", false)");
})


function random(min = 0, max = RAND_MAX) {
    return (rand() % ((max + 1) - min)) + min;
}

addEventHandler("moveBoxRandomByName1", function() {
    // log("1 " + executeLua("game.entitywrapper:GetEntityByName(\"green_door_brana_drevena00\"):Deactivate()"));
    log("1 " + executeLua("game.entitywrapper:GetEntityByGuid(\"3608900026607858036\"):Deactivate()"));

})

addEventHandler("moveBoxRandomByName2", function() {
    log("2 " + executeLua("DelayBuffer:Insert( function(l_1_0) game.entitywrapper:GetEntityByName(\"bedna_6sten00\"):SetPos(game.game:GetActivePlayer():GetPos()) end,{},1,1,false)"));
})

addEventHandler("moveBoxRandomById", function() {
    log("3 " + executeLua("DelayBuffer:Insert( function(l_1_0) game.entitywrapper:GetEntityByGUID(\"3896\"):SetPos(game.game:GetActivePlayer():GetPos()) end,{},1,1,false)"));
})