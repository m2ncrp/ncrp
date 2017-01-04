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
local oldCursorState = isCursorShowing();

addEventHandler("onAlert", function (message) {
	if(window){
		guiSetText(label, message);
		guiSetVisible(window,true);
	}
	else{
		window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Ошибка!/Error!", screen[0]/2 - 100, screen[1]/2 - 50, 200.0, 100.0 );
		label = guiCreateElement( ELEMENT_TYPE_LABEL, message.tostring(), 10.0, 20.0, 300.0, 20.0, false, window);
		button = guiCreateElement( ELEMENT_TYPE_BUTTON, "ОК" ,  10.0, 70, 190.0, 20.0, false, window);
	}
	if(!oldCursorState){
		showCursor(true);
	}
	guiSetSizible(window,false);
	guiSetMovable(window, false)
});

addEventHandler( "onGuiElementClick",function(element){
	if(element == button){
		guiSetVisible(window,false);
		delayedFunction(200, function() {
			showCursor(oldCursorState);
		});
	}
});

addEventHandler( "onClientPlayerMoveStateChange", function( playerid, oldMoveState, newMoveState ){
	triggerServerEvent("updateMoveState",newMoveState);
});

/*
addEventHandler( "getClientMoveState", getMoveStatefunction(){
	local state = getPlayerMoveState(getLocalPlayer());
	return state;
});
*/