addEventHandler("animate", function(action) { // ивент для отображения анимаций
    executeLua(action);
});

addEventHandler("sync_animation", function(action) { // ивент для синхронизации анимаций на другом клиенте
    executeLua(action);
});

addEventHandler("edible", function(action, model) { // ивент для поедания
    executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,1, %d) end}) end,{l_1_0},200,1,false)", model))
    executeLua(action);
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,1,1) end}) end,{l_1_0},1500,1,false)");
});

addEventHandler("edible_sync", function(action, model, id) { // ивент для синхронизации скрипта на другом клиенте
    executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):ModelToHands(true,1, %d) end}) end,{l_1_0},700,1,false)", id, model))
    executeLua(action);
    executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):ModelToHands(true,1,1) end}) end,{l_1_0},2500,1,false)", id));
});

addEventHandler("drinkable", function(action, model) {	// ивент для питья
    executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,1, %d) end}) end,{l_1_0},200,1,false)", model))
    executeLua(action);
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,1,1) end}) end,{l_1_0},4000,1,false)");
});

addEventHandler("drinkable_sync", function(action, model, id) { // ивент для синхронизации скрипта на другом клиенте
    executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):ModelToHands(true,1, %d) end}) end,{l_1_0},200,1,false)", id, model))
    executeLua(action);
    executeLua(format("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):ModelToHands(true,1,1) end}) end,{l_1_0},4000,1,false)", id));
});