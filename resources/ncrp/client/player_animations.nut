local animations = {
    "UseItem.Drink": [["sc_drink_bottle_out"], [0, 200, 3800]],
    "UseItem.Food": [["sc_eat_ham_out"], [0, 200, 1500]],
    "UseItem.Cigarettes": [["sc_man_smoke_in", "sc_man_smoke_stat_a", "sc_man_smoke_stat_b", "sc_man_smoke_stat_c", "sc_man_smoke_stat_d", "sc_man_smoke_out"], [500]],
    "UseItem.CoffeeCup": [["sc_drink_coffee_out"], [0, 200, 3300]]
}


function createAnim(delay, id, anims) {
    local finalScript = "DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{";
    if (id != -1) {
        foreach (idx, anim in anims) {
            finalScript = finalScript + format(" function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"%s\", false)end,", id, anim);
        }
    } else {
        finalScript = finalScript + "function(l_1_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.LOCKED)end,";
        foreach (item in anims) {
            finalScript = finalScript + format(" function(l_2_0)return game.game:GetActivePlayer():AnimPlay(\"%s\", false)end,", item);
        }
        finalScript = finalScript + " function(l_8_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.FREE)end";
    }
    finalScript = finalScript + format("}) end,{l_1_0},%d,1,false)", delay)
    return finalScript;
};


addEventHandler("animate", function(id, anim, model) {
    local haveModel = model != 1;
    local needSync = id != -1;
    if (haveModel && needSync) {
    executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):ModelToHands(true,1, %d) end}) end,{l_1_0},%d,1,false)", id, model, animations[anim][1][1]));
    } else if (haveModel) {
        executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,1, %d) end}) end,{l_1_0},%d,1,false)", model, animations[anim][1][1]));
    }
    executeLua(createAnim(animations[anim][1][0], id, animations[anim][0]));
    if (haveModel && needSync) {
        executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):ModelToHands(true,1,1) end}) end,{l_1_0},%d,1,false)", id, animations[anim][1][2]));
    } else if (haveModel) {
        executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,1, 1) end}) end,{l_1_0},%d,1,false)", animations[anim][1][2]));
    }
});