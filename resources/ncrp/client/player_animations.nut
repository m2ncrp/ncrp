local animations = {
    "UseItem.Drink": [["sc_drink_bottle_out"], [0, 200, 3800], "right"],
    "UseItem.Food": [["sc_eat_ham_out"], [0, 200, 1500], "right"],
    "UseItem.Cigarettes": [["sc_man_smoke_in", "sc_man_smoke_stat_a", "sc_man_smoke_stat_b", "sc_man_smoke_stat_c", "sc_man_smoke_stat_d", "sc_man_smoke_out"], [500], "right"],
    "UseItem.CoffeeCup": [["sc_drink_coffee_out"], [0, 200, 3300], "right"],
    "PhoneBooth.Static": [["sc_phone_stat_a"], [0], "right"],
    "PhoneBooth.PickUp": [["sc_phone_PLAYER_in"], [0], "right"],
    "PhoneBooth.Put": [["sc_phone_PLAYER_out"], [0], "right"],
    "Phone.PickUp": [["sc_pult_tele_in"], [0, 1000], "left"],
    "Phone.Static": [["sc_pult_tele_stat"], [200, 0], "left"],
    "Phone.Put": [["sc_pult_tele_out"], [0, 0, 1500], "left"],
}


function createAnim(delay, id, anims, endless, block, unblock) {
    local finalScript = "DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{";
    if (id != -1) {
        foreach (idx, anim in anims) {
            finalScript = finalScript + format(" function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"%s\", %s)end,", id, anim, endless.tostring());
        }
    } else {
        if (block) {
            finalScript = finalScript + "function(l_1_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.LOCKED)end,";
        }
        foreach (item in anims) {
            finalScript = finalScript + format(" function(l_2_0)return game.game:GetActivePlayer():AnimPlay(\"%s\", %s)end,", item, endless.tostring());
        }
        if (unblock) {
            finalScript = finalScript + " function(l_8_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.FREE)end";
        }
    }
    finalScript = finalScript + format("}) end,{l_1_0},%d, 1, false)", delay)
    return finalScript;
};


addEventHandler("animate", function(id, anim, model, endless, block, unblock) {
    local haveModel = model != 1;
    local needSync = id != -1;
    local arm = animations[anim][2] == "right";
    if (haveModel && needSync) {
        if (arm) {
            executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):ModelToHands(true,1, %d) end}) end,{l_1_0},%d,1,false)", id, model, animations[anim][1][1]));
        } else {
            executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):ModelToHands(true,%d, 1) end}) end,{l_1_0},%d,1,false)", id, model, animations[anim][1][1]));
        }
    } else if (haveModel) {
        if (arm) {
            executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,1, %d) end}) end,{l_1_0},%d,1,false)", model, animations[anim][1][1]));
        } else {
            executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,%d, 1) end}) end,{l_1_0},%d,1,false)", model, animations[anim][1][1]));
        }
    }
    executeLua(createAnim(animations[anim][1][0], id, animations[anim][0], endless, block, unblock));
    if (haveModel && needSync && unblock) {
        executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):ModelToHands(true,1,1) end}) end,{l_1_0},%d,1,false)", id, animations[anim][1][2]));
    } else if (haveModel && unblock) {
        executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,1, 1) end}) end,{l_1_0},%d,1,false)", animations[anim][1][2]));
    }
});
