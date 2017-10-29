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
local buttons = array(7);
local input = array(1);

/**
 * [showPhoneGUI description]
 * @param  {[string]} windowText  [description]
 * @param  {[string]} labelText   [description]
 * @param  {[string]} button1Text [description]
 * @param  {[string} button2Text  [description]
 * @return {[type]}               [description]
 */
function showMetroGUI (windowText, label1Text, button1Text, button2Text, button3Text, button4Text, button5Text, button6Text, label2Text, button7Text) {
    if(window){//if widow created
        guiSetSize(window, 200.0, 294.0  );
        guiSetPosition(window,screen[0]/2 - 100, screen[1]/2 - 147);
        guiSetVisible( window, true);
    }
    else{//if widow doesn't created, create his
        window =  guiCreateElement( ELEMENT_TYPE_WINDOW, windowText, screen[0]/2 - 100, screen[1]/2 - 147, 200.0, 294.0 );

        label[0]   = guiCreateElement(  ELEMENT_TYPE_LABEL, label1Text,       15.0,   23.0, 170.0, 20.0, false, window);
        label[1]   = guiCreateElement(  ELEMENT_TYPE_LABEL, label2Text,       52.0,   227.0, 170.0, 20.0, false, window);

        metroAlignToCenter( label[0] );

        buttons[0] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button1Text  ,     15.0,   50.0, 170.0, 25.0, false, window);
        buttons[1] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button2Text  ,     15.0,   80.0, 170.0, 25.0, false, window);
        buttons[2] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button3Text  ,     15.0,   110.0, 170.0, 25.0, false, window);
        buttons[3] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button4Text  ,     15.0,   140.0, 170.0, 25.0, false, window);
        buttons[4] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button5Text  ,     15.0,   170.0, 170.0, 25.0, false, window);
        buttons[5] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button6Text  ,     15.0,   200.0, 170.0, 25.0, false, window);

        buttons[6] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button7Text  ,     15.0,   253.0, 170.0, 25.0, false, window);
    }

delayedFunction(5, function() { //todo fix
        guiSetText( window, windowText);
        guiSetText( label[0], label1Text);
        guiSetText( label[1], label2Text);

        guiSetText( buttons[0], button1Text );
        guiSetText( buttons[1], button2Text );
        guiSetText( buttons[2], button3Text );
        guiSetText( buttons[3], button4Text );
        guiSetText( buttons[4], button5Text );
        guiSetText( buttons[5], button6Text );
        guiSetText( buttons[6], button7Text );

        metroAlignToCenter( label[0] );
});

    guiSetSizable(window,false);
    guiSetMovable(window,false);
    showCursor(true);
}
addEventHandler("showMetroGUI",showMetroGUI);


function metroAlignToCenter( obj ) {
        local text = guiGetText( obj );
        log (text);
        local len = text.len();
        local offset = 8;
        if (len > 20) { len = floor(len / 2); offset = -2; }
        local w = len * 6;
        local x = 100 - w / 2 + offset;
        guiSetPosition( obj, x, 23.0 );
        guiSetSize( label[0], w, 20.0 );
}

function hideMetroGUI () {
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
            triggerServerEvent("travelToStationGUI", 0);
            hideMetroGUI();
        }
        if(element == buttons[1]){
            triggerServerEvent("travelToStationGUI", 1);
            hideMetroGUI();
        }
        if(element == buttons[2]){
            triggerServerEvent("travelToStationGUI", 2);
            hideMetroGUI();
        }
        if(element == buttons[3]){
            triggerServerEvent("travelToStationGUI", 3);
            hideMetroGUI();
        }
        if(element == buttons[4]){
            triggerServerEvent("travelToStationGUI", 4);
            hideMetroGUI();
        }
        if(element == buttons[5]){
            triggerServerEvent("travelToStationGUI", 5);
            hideMetroGUI();
        }

        if(element == buttons[6]){
            hideMetroGUI();
        }
    });

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}
