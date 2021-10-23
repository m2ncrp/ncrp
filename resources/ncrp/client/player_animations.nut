local animations = {
    "UseItem.Drink": [["sc_drink_bottle_out"], [0, 200, 3800]],
    "UseItem.Food": [["sc_eat_ham_out"], [0, 200, 1500]],
    "UseItem.Cigarettes": [["sc_man_smoke_in", "sc_man_smoke_stat_a", "sc_man_smoke_stat_b", "sc_man_smoke_stat_c", "sc_man_smoke_stat_d", "sc_man_smoke_out"], [500]],
    "UseItem.CoffeeCup": [["sc_drink_coffee_out"], [0, 200, 3800]]
}


function createAnim(delay, id, anims) {
    local final_script = "DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{";
    if (id != -1) {
        foreach (idx, anim in anims) {
            final_script = final_script + format(" function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"%s\", false)end,", id, anim);
        }
    }
    else{
        final_script = final_script + "function(l_1_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.LOCKED)end,";
        foreach (item in anims) {
            final_script = final_script + format(" function(l_2_0)return game.game:GetActivePlayer():AnimPlay(\"%s\", false)end,", item);
        }
        final_script = final_script + " function(l_8_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.FREE)end";
    }
    final_script = final_script + format("}) end,{l_1_0},%d,1,false)", delay)
    return (final_script);
};


addEventHandler("animate", function(id, anim, model) {
    if ((model != 1) && (id != -1)) {
    executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):ModelToHands(true,1, %d) end}) end,{l_1_0},%d,1,false)", id, model, animations[anim][1][1]));
    } else if (model != 1) {
        executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,1, %d) end}) end,{l_1_0},%d,1,false)", model, animations[anim][1][1]));
    }
    executeLua(createAnim(animations[anim][1][0], id, animations[anim][0]));
    if ((model != 1) && (id != -1)) {
        executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):ModelToHands(true,1,1) end}) end,{l_1_0},%d,1,false)", id, animations[anim][1][2]));
    } else if (model != 1) {
        executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,1, 1) end}) end,{l_1_0},%d,1,false)", animations[anim][1][2]));
    }
});