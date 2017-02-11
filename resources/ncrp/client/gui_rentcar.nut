const ELEMENT_TYPE_BUTTON = 2;
const ELEMENT_TYPE_IMAGE = 13;
// check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];


local window;
local label;
local buttons = array(2);

addEventHandler("showRentCarGUI", function(windowText,labelText, button1Text, button2Text) {
    if(window){//if widow created
        guiSetSize(window, 270.0, 90.0  );
        guiSetPosition(window,screen[0]/2 - 135, screen[1]/2 - 45);
        guiSetText( window, windowText);
        guiSetText( label, labelText);
        guiSetText( buttons[0], button1Text);
        guiSetText( buttons[1], button2Text);
        guiSetVisible( window, true);
    }
    else{//if widow doesn't created, create his
        window =  guiCreateElement( ELEMENT_TYPE_WINDOW, windowText, screen[0]/2 - 135, screen[1]/2 - 45, 270.0, 90.0 );
        label = guiCreateElement( ELEMENT_TYPE_LABEL, labelText, 20.0, 20.0, 300.0, 40.0, false, window);
        buttons[0] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button1Text, 20.0, 60.0, 115.0, 20.0,false, window);
        buttons[1] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button2Text, 140.0, 60.0, 115.0, 20.0,false, window);
    }
    guiSetSizable(window,false);
    guiSetMovable(window,false);
    showCursor(true);
});

function hideCursor() {
    showCursor(false);
}

function hideRentCarGUI () {
    guiSetVisible(window,false);
    guiSetText( label, "");
    delayedFunction(100, hideCursor);//todo fix
}

addEventHandler( "onGuiElementClick", function(element) {
    if(element == buttons[0]){
        triggerServerEvent("RentCar");
        hideRentCarGUI();
    }

    if(element == buttons[1]){
        hideRentCarGUI();
    }
});
