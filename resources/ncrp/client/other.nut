
addEventHandler( "onClientPlayerMoveStateChange", function( playerid, oldMoveState, newMoveState ){
	triggerServerEvent("updateMoveState",newMoveState);
});

/*
addEventHandler( "getClientMoveState", getMoveStatefunction(){
	local state = getPlayerMoveState(getLocalPlayer());
	return state;
});
*/