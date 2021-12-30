// Открытие ворот для въезда на подгруженную в данный момент мойку
addEventHandler("doorOpen", function(name) {
  executeLua(format("game.entitywrapper:GetEntityByName(\"%s\"):Open(game.entitywrapper:GetEntityByName(\"%s\"):GetPos() + game.entitywrapper:GetEntityByName(\"%s\"):GetDir(), true)", name, name, name))
});

addEventHandler("doorClose", function(name) {
  executeLua(format("game.entitywrapper:GetEntityByName(\"%s\"):Close(game.entitywrapper:GetEntityByName(\"%s\"):GetPos() + game.entitywrapper:GetEntityByName(\"%s\"):GetDir(), true)", name, name, name))
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

