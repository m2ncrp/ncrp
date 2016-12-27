const ELEMENT_TYPE_BUTTON = 2;
local screen = getScreenSize();
local window;
local label;
local buttons = array(2);

/**
 * [showRentCarGUI description]
 * @param  {[string]} windowText  [description]
 * @param  {[string]} labelText   [description]
 * @param  {[string]} button1Text [description]
 * @param  {[string} button2Text  [description]
 * @return {[type]}               [description]
 */
function showRentCarGUI (windowText,labelText, button1Text, button2Text) {
	if(window){//if widow created
		guiSetSize(window, 270.0, 90.0  );
	    guiSetPosition(window,screen[0]/2 - 135, screen[1]/2 - 45);
	    guiSetText( window, windowText);
	    guiSetText( label, labelText);
	    guiSetText( buttons[0], button1Text);
	    guiSetText( buttons[1], button2Text);
	    guiSetVisible( window, true);
	    showCursor(true);
	    log("if widow created");
	}
	else{//if widow doesn't created, create his
		window =  guiCreateElement( ELEMENT_TYPE_WINDOW, windowText, screen[0]/2 - 135, screen[1]/2 - 45, 270.0, 90.0 );
		label =	guiCreateElement( ELEMENT_TYPE_LABEL, labelText, 20.0, 20.0, 300.0, 40.0, false, window);
		buttons[0] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button1Text, 20.0, 60.0, 115.0, 20.0,false, window);
		buttons[1] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button2Text, 140.0, 60.0, 115.0, 20.0,false, window);
		showCursor(true);
		log("if widow doesn't created, create his");
	}
	guiSetSizable(window,false);
	guiSetMovable(window,false);
}
addEventHandler("showRentCarGUI",showRentCarGUI);


function hideRentCarGUI () {
	guiSetVisible(window,false);
	guiSetText( label, "");
	delayedFunction(100, hideCursor);//todo fix
}

function hideCursor() {
    showCursor(false);
}

addEventHandler( "onGuiElementClick",
	function(element)
	{
		if(element == buttons[0]){
			triggerServerEvent("RentCar");
		}
		if(element == buttons[1]){
			hideRentCarGUI();
		}
	});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}