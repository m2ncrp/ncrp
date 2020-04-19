
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
