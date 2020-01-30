const ELEMENT_TYPE_BUTTON = 2;
const ELEMENT_TYPE_IMAGE = 13;

local screen = getScreenSize();
local window;
local logo;
local input = array(2);
local label = array(3);
local buttons = array(5);
local image;


function showBankGUI(){
    if(window){//if widow created
        guiSetVisible( window, true);
        guiSetText( label[0], "Доступные операции:");
        showCursor(true);
    } else {
        window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Банковский счёт", screen[0]/2 - 140, screen[1]/2 - 100.0, 280.0, 200.0 );
        image = guiCreateElement(13,"", 20.0, 20.0, 250.0, 31.0, false, window);
        label[0] = guiCreateElement( ELEMENT_TYPE_LABEL, "Доступные операции:", 22.0, 20.0, 300.0, 20.0, false, window);
        input[1]   = guiCreateElement(  ELEMENT_TYPE_EDIT, "", 20.0,   45.0, 100.0, 22.0, false, window);
        buttons[0] = guiCreateElement( ELEMENT_TYPE_BUTTON, "Пополнить",    20.0,   70.0, 115.0, 30.0,false, window);
        buttons[1] = guiCreateElement( ELEMENT_TYPE_BUTTON, "Снять",        145.0,  70.0, 115.0, 30.0,false, window);
        buttons[2] = guiCreateElement( ELEMENT_TYPE_BUTTON, "Положить всё", 20.0,   105.0, 115.0, 30.0,false, window);
        buttons[3] = guiCreateElement( ELEMENT_TYPE_BUTTON, "Снять всё",    145.0,  105.0, 115.0, 30.0,false, window);
        buttons[4] = guiCreateElement( ELEMENT_TYPE_BUTTON, "Закрыть",    90.0,  165.0, 100.0, 25.0,false, window);
        showCursor(true);
    }
}
addEventHandler("showBankGUI", showBankGUI)

function hideCursor() {
    showCursor(false);
}

function hideBankGUI(){
    guiSetVisible(window,false);
    guiSetText( label[0], "");
    delayedFunction(100, hideCursor);//todo fix
}

addEventHandler( "onGuiElementClick", function(element) {
    if(element == buttons[0]){
        //triggerServerEvent("RentCar");
        hideBankGUI();
    }

    if(element == buttons[4]){
        hideBankGUI();
    }
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}