addEventHandler("hidePlayerModel", function() {
    executeLua("game.game:GetActivePlayer():ShowModel(false)");
});

addEventHandler("showPlayerModel", function() {
    executeLua("game.game:GetActivePlayer():ShowModel(true)");
});

addCommandHandler("takeBox", function(playerid) {
    /* # Ставим ограничительный контроль стиль */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetControlStyleStr('CS_HSH_BARBER_CRATES') end}) end,{l_1_0},500,1,false)")
    /* # Включаем Анимацию Для Поднятия Ящика */
    executeLua("ply=game.game:GetActivePlayer() DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return ply:SetControlStyle(enums.ControlStyle.LOCKED)end, function(l_2_0)return ply:SetPhysState(enums.PhysicsState.DISABLED)end, function(l_5_0)return ply:AnimPlay('51-case_in_lo', false)end, function(l_14_0)return ply:SetControlStyle(enums.ControlStyle.FREE)end, function(l_15_0)return ply:SetPhysState(enums.PhysicsState.ENABLE)end}) end,{l_1_0},500,1,false)")
    /* # Добавляем ящик в руку */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():ModelToHands(true,1,98) end}) end,{l_1_0},1000,1,false)")
    /* # Выставляем стиль ходьбы с ящиком */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetAnimStyle('common', 'CarryBox') end}) end,{l_1_0},1000,1,false)")
});

addEventHandler("takeBox", function() {
    /* # Ставим ограничительный контроль стиль */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetControlStyleStr('CS_HSH_BARBER_CRATES') end}) end,{l_1_0},500,1,false)")
    /* # Включаем Анимацию Для Поднятия Ящика */
    executeLua("ply=game.game:GetActivePlayer() DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return ply:SetControlStyle(enums.ControlStyle.LOCKED)end, function(l_2_0)return ply:SetPhysState(enums.PhysicsState.DISABLED)end, function(l_5_0)return ply:AnimPlay('51-case_in_lo', false)end, function(l_14_0)return ply:SetControlStyle(enums.ControlStyle.FREE)end, function(l_15_0)return ply:SetPhysState(enums.PhysicsState.ENABLE)end}) end,{l_1_0},500,1,false)")
    /* # Добавляем ящик в руку */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():ModelToHands(true,1,98) end}) end,{l_1_0},1000,1,false)")
    /* # Выставляем стиль ходьбы с ящиком */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetAnimStyle('common', 'CarryBox') end}) end,{l_1_0},1000,1,false)")
});

addEventHandler("putBox", function() {
    /* Включаем Анимацию Для Погрузки Ящика */
    executeLua("ply=game.game:GetActivePlayer() DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return ply:SetControlStyle(enums.ControlStyle.LOCKED)end, function(l_2_0)return ply:SetPhysState(enums.PhysicsState.DISABLED)end, function(l_5_0)return ply:AnimPlay('51-case_out_lo', false)end, function(l_14_0)return ply:SetControlStyle(enums.ControlStyle.FREE)end, function(l_15_0)return ply:SetPhysState(enums.PhysicsState.ENABLE)end}) end,{l_1_0},500,1,false)");
    /* # Убираем ящик из руки */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():ModelToHands(true,1,0) end}) end,{l_1_0},4000,1,false)")
     /* # Выставляем стандартный стиль ходьбы */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetAnimStyle('common', 'default') end}) end,{l_1_0},1000,1,false)")
    /* # Выставляем стандартный контроль стиль */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetControlStyleStr('RESIDENCE') end}) end,{l_1_0},500,1,false)")
});

addEventHandler("setDefaultPlayerState", function() {
    /* # Вызываем свободный контроль стиль */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetControlStyleStr('RESIDENCE') end}) end,{l_1_0},500,1,false)")
    /* # Сбрасываем предмет в руке */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():ModelToHands(true,1,0) end}) end,{l_1_0},500,1,false)")
    /* # Сбрасываем стиль ходьбы */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetAnimStyle('common', 'default') end}) end,{l_1_0},500,1,false)")
    }
);

addEventHandler("setWithBoxPlayerState", function() {
    /* # Ставим ограничительный контроль стиль */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetControlStyleStr('CS_HSH_BARBER_CRATES') end}) end,{l_1_0},500,1,false)")
    /* # Добавляем ящик в руку */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():ModelToHands(true,1,98) end}) end,{l_1_0},1000,1,false)")
    /* # Выставляем стиль ходьбы с ящиком */
    executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetAnimStyle('common', 'CarryBox') end}) end,{l_1_0},1000,1,false)")
});


addCommandHandler( "vrata",
    function( playerid )
    {

		executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('HlavniVrata'):Open(game.entitywrapper:GetEntityByName('HlavniVrata'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
    }
);

addCommandHandler( "vrataclose",
    function( playerid )
    {

		executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('HlavniVrata'):Close(game.entitywrapper:GetEntityByName('HlavniVrata'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
    }
);