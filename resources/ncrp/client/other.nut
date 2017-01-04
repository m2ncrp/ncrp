const ELEMENT_TYPE_BUTTON = 2;

// added check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local window;
local label;
local button;
local oldCursorState;

addEventHandler("onAlert", function (message) {
	oldCursorState = isCursorShowing();
	if(window){
		guiSetText(label, message);
		guiSetVisible(window,true);
	}
	else{
		window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Ошибка!", screen[0]/2 - 100, screen[1]/2 - 50, 200.0, 100.0 );
		label = guiCreateElement( ELEMENT_TYPE_LABEL, message.tostring(), 10.0, 20.0, 300.0, 50.0, false, window);
		button = guiCreateElement( ELEMENT_TYPE_BUTTON, "ОК" ,  10.0, 80, 180.0, 20.0, false, window);
	}
	showCursor(true);
	guiSetMovable(window,false);
	guiSetSizable(window,false);
});

addEventHandler( "onGuiElementClick",function(element){
	if(element == button){
		guiSetVisible(window,false);
		delayedFunction(200, function() {
			showCursor(oldCursorState);
		});
	}
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}

addEventHandler( "onClientPlayerMoveStateChange", function( playerid, oldMoveState, newMoveState ){
	triggerServerEvent("updateMoveState",newMoveState);
});

/*
addEventHandler( "getClientMoveState", getMoveStatefunction(){
	local state = getPlayerMoveState(getLocalPlayer());
	return state;
});
*/