local screen = getScreenSize();
local window;
local label;
local buttons = array(2);

/*
addEventHandler("onServerClientStarted", function(...){
	window =  guiCreateElement( ELEMENT_TYPE_WINDOW, "Аренда автомобиля", screen[0]/2 - 135, screen[1]/2 - 45, 270.0, 90.0 );
	label =	guiCreateElement( ELEMENT_TYPE_LABEL, "", 20.0, 20.0, 300.0, 40.0, false, window);
	buttons[0] = guiCreateElement(  2, "Арендовать", 20.0, 60.0, 115.0, 20.0,false, window);
	buttons[1] = guiCreateElement(  2, "Отказаться", 140.0, 60.0, 115.0, 20.0,false, window);
	guiSetVisible( window, false);
});
*/

function showRentCarGUI (labelText) {
    guiSetSize(window, 270.0, 90.0  );
    guiSetPosition(window,screen[0]/2 - 135, screen[1]/2 - 45);
    guiSetText( label, labelText);
    guiSetVisible( window, true);
    showCursor(true);
}
addEventHandler("showRentCarGUI",showRentCarGUI);

function hideRentCarGUI () {
	if( guiIsVisible( window ) ){
	    guiSetVisible( window, !guiIsVisible( window ));
	}

}
addEventHandler("hideRentCarGUI",hideRentCarGUI);