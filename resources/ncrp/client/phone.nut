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
local label = array(2);
local buttons = array(4);
local input = array(1);

/**
 * [showPhoneGUI description]
 * @param  {[string]} windowText  [description]
 * @param  {[string]} labelText   [description]
 * @param  {[string]} button1Text [description]
 * @param  {[string} button2Text  [description]
 * @return {[type]}               [description]
 */
function showPhoneGUI (windowText, label0Callto, label1insertNumber, button0Police, button1Taxi, button2Call, button3Refuse, input0exampleNumber) {
	if(window){//if widow created
		guiSetSize(window, 200.0, 250.0  );
	    guiSetPosition(window,screen[0]/2 - 100, screen[1]/2 - 125);
	    guiSetText( window, windowText);
	    guiSetText( label[0], label0Callto);
	    guiSetText( label[1], label1insertNumber);
	    guiSetText( buttons[0], button0Police);
	    guiSetText( buttons[1], button1Taxi);
	    guiSetText( buttons[2], button2Call);
	    guiSetText( buttons[3], button3Refuse);
	    guiSetText( input[0], input0exampleNumber);
	    guiSetVisible( window, true);
	}
	else{//if widow doesn't created, create his
		window =  guiCreateElement( ELEMENT_TYPE_WINDOW, windowText, screen[0]/2 - 100, screen[1]/2 - 125, 200.0, 250.0 );
		label[0]   = guiCreateElement(  ELEMENT_TYPE_LABEL, label0Callto, 		50.0, 	23.0, 150.0, 20.0, false, window);
		buttons[0] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button0Police, 	15.0, 	50.0, 170.0, 25.0, false, window);
		buttons[1] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button1Taxi, 		15.0, 	80.0, 170.0, 25.0, false, window);

		label[1]   = guiCreateElement(  ELEMENT_TYPE_LABEL, label1insertNumber, 52.0, 	110.0, 120.0, 20.0, false, window);

		input[0]   = guiCreateElement(  ELEMENT_TYPE_EDIT,  input0exampleNumber,15.0,   137.0, 170.0, 22.0, false, window);
		buttons[2] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button2Call, 		15.0, 	165.0, 170.0, 25.0, false, window);
		buttons[3] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button3Refuse, 	15.0,	208.0, 170.0, 25.0, false, window);
	}
	guiSetSizable(window,false);
	guiSetMovable(window,false);
	showCursor(true);
}
addEventHandler("showPhoneGUI",showPhoneGUI);


function hidePhoneGUI () {
	guiSetVisible(window,false);
	guiSetText( label[0], "");
	delayedFunction(100, hideCursor); //todo fix
}

function hideCursor() {
    showCursor(false);
}


addEventHandler( "onGuiElementClick",
	function(element)
	{
		if(element == buttons[0]){
			triggerServerEvent("PhoneCallGUI", "police");
			hidePhoneGUI();
		}
		if(element == buttons[1]){
			log("call taxi");
			triggerServerEvent("PhoneCallGUI", "taxi");
			hidePhoneGUI();
		}
		if(element == buttons[2]){
			local number = guiGetText(input[0]);
			triggerServerEvent("PhoneCallGUI", number);
			hidePhoneGUI();
		}
		if(element == buttons[3]){
			hidePhoneGUI();
		}
		if(element == input[0]){
            guiSetText(input[0], "555-");
        }
	});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}
