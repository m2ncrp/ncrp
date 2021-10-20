
addEventHandler("clementeOpen", function() {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('HlavniVrata'):Open(game.entitywrapper:GetEntityByName('HlavniVrata'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
});

addEventHandler("clementeClose", function() {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('HlavniVrata'):Close(game.entitywrapper:GetEntityByName('HlavniVrata'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
});

addEventHandler("forgeOpen", function() {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('FNDR_Vrata_Exter'):Open(game.entitywrapper:GetEntityByName('FNDR_Vrata_Exter'):GetPos() + game.entitywrapper:GetEntityByName('FNDR_Vrata_Exter'):GetDir(), true) end}) end,{l_1_0},500,1,false)")
});

addEventHandler("forgeClose", function() {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('FNDR_Vrata_Exter'):Close(game.entitywrapper:GetEntityByName('FNDR_Vrata_Exter'):GetPos() + game.entitywrapper:GetEntityByName('FNDR_Vrata_Exter'):GetDir(), true) end}) end,{l_1_0},500,1,false)")
});

addEventHandler("seagiftOpen", function() {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('SG_gate01'):Open(Math:newVector(-2, 0, 0) + game.entitywrapper:GetEntityByName('SG_gate01'):GetPos(), true) end}) end,{l_1_0},500,1,false)")
});

addEventHandler("seagiftClose", function() {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('SG_gate01'):Close(Math:newVector(-2, 0, 0) + game.entitywrapper:GetEntityByName('SG_gate01'):GetPos(), true) end}) end,{l_1_0},500,1,false)")
});

// Открытие ворот для въезда на подгруженную в данный момент мойку
addCommandHandler("wash", function(playerid) {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('Wash_gate00'):Open(Math:newVector(0, 0, 2) + game.entitywrapper:GetEntityByName('Wash_gate00'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
});

// Закрытие ворот для въезда на подгруженную в данный момент мойку
addCommandHandler("washclose", function(playerid) {
	executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('Wash_gate00'):Close(Math:newVector(0, 0, 2) + game.entitywrapper:GetEntityByName('Wash_gate00'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
});


// Открытие ворот для выезда с подгруженной в данный момент мойки
addCommandHandler("wash1", function(playerid) {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('Wash_gate01'):Open(Math:newVector(0, 0, 2) + game.entitywrapper:GetEntityByName('Wash_gate01'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
});

// Закрытие ворот для выезда с подгруженной в данный момент мойки
addCommandHandler("wash1close", function(playerid) {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('Wash_gate01'):Close(Math:newVector(0, 0, 2) + game.entitywrapper:GetEntityByName('Wash_gate01'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
});

// Поднять ворота в подгруженную в данный момент мастерскую
addCommandHandler("sprayopen", function(playerid) {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('RS_vrata01'):Open(Math:newVector(0, 0, 2) + game.entitywrapper:GetEntityByName('RS_vrata01'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
});

// Опустить ворота в подгруженную в данный момент мастерскую
addCommandHandler("sprayclose", function(playerid) {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('RS_vrata01'):Close(Math:newVector(0, 0, 2) + game.entitywrapper:GetEntityByName('RS_vrata01'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
});

addEventHandler("setRadio", function(stationName) {
	executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.radio:SwitchPlayerStation('"+stationName+"') end}) end,{l_1_0},500,1,false)")
});

addEventHandler("setRadioOff", function() {
	executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.radio:TurnPlayerRadioOff(true) end}) end,{l_1_0},500,1,false)")
});

addEventHandler("setRadioOn", function() {
	executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.radio:TurnPlayerRadioOn(true) end}) end,{l_1_0},500,1,false)")
});


addCommandHandler( "radio_switch",
    function( playerid )
	{
		executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.radio:SwitchPlayerStation('Empire') end}) end,{l_1_0},500,1,false)")
    }
);

addCommandHandler( "radio_default",
    function( playerid )
	{
		executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.radio:ForceDefaultStation('Delta') end}) end,{l_1_0},500,1,false)")
    }
);

addCommandHandler( "radio_off",
    function( playerid )
	{
		executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.radio:TurnPlayerRadioOff(true) end}) end,{l_1_0},500,1,false)")
    }
);

addCommandHandler( "radio_on",
    function( playerid )
	{
		executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.radio:TurnPlayerRadioOn(true) end}) end,{l_1_0},500,1,false)")
    }
);

addCommandHandler( "next",
    function( playerid )
	{
		executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.radio:AdvanceTime() end}) end,{l_1_0},500,1,false)")
    }
);

addEventHandler("setRadioContent", function(stationName, contentName) {
	executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.radio:SetContent('"+stationName+"','all','"+contentName+"') end}) end,{l_1_0},500,1,false)")
});


addEventHandler("portOpen", function() {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('LDOgate01'):Open(game.entitywrapper:GetEntityByName('LDOgate01'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
});

addEventHandler("portClose", function() {
  executeLua("DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.entitywrapper:GetEntityByName('LDOgate01'):Close(game.entitywrapper:GetEntityByName('LDOgate01'):GetPos(), true) end }) end,{l_1_0},500,1,false)")
});
