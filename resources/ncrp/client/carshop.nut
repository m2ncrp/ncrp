const ELEMENT_TYPE_BUTTON = 2;
const ELEMENT_TYPE_IMAGE = 13;
local screen =  getScreenSize();
local window;
local label;
local image;
local logo;
local buttons= array(4);


function showCarShopGUI()
{
	if(window){

		guiSetVisible(true);
	}
	else {
	    window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Австосалон", screen[0]/2 - 178, screen[1]/2 - 200, 356.0, 400.0);
		logo = guiCreateElement( ELEMENT_TYPE_IMAGE,"diamondmotors.png", 131.0, 20.0, 94.0, 57.0, false, window);
		image =  guiCreateElement( ELEMENT_TYPE_IMAGE,"id_0.jpg", 35.0, 85.0, 286.0, 178.0, false, window);
		buttons[0] = guiCreateElement(  ELEMENT_TYPE_BUTTON, "<<", 10.0, 164.0, 20.0, 20.0,false, window);
		buttons[1] = guiCreateElement(  ELEMENT_TYPE_BUTTON, ">>", 326.0, 164.0, 20.0, 20.0,false, window);
		buttons[2] = guiCreateElement(  ELEMENT_TYPE_BUTTON, "Купить", 10.0, 370.0, 100.0, 20.0,false, window);
		buttons[3] = guiCreateElement(  ELEMENT_TYPE_BUTTON, "Выход", 246.0, 370.0, 100.0, 20.0,false, window);
	}
	guiSetSizable(window,false);
	guiSetMovable(window,false);
	showCursor(false);
}
addEventHandler("showCarShopGUI", showCarShopGUI);

function hideCarShopGUI() {
	guiSetVisible(window,false);
	delayedFunction(100, hideCursor);//todo fix
}

/**
 * [switchCar description]
 * @param  {[integer]} id [id vehicle to show]
 * @return {[type]}    [description]
 */
function switchCar(id)
{

}

function hideCursor() {
    showCursor(false);
}



function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}