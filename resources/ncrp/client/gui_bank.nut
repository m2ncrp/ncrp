local screen = getScreenSize();
local window;
local logo;
local input = array(2);
local label = array(3);
local button;
local image;


function showBankGUI(){
    window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Банковский счёт: Klo_Douglas [1000$]", screen[0]/2 - 140, screen[1]/2 - 100.0, 280.0, 200.0 );
    image = guiCreateElement(13,"", 20.0, 20.0, 250.0, 31.0, false, window);
    label[1] = guiCreateElement( ELEMENT_TYPE_LABEL, "Пополнить: ", 22.0, 60.0, 300.0, 20.0, false, window);
    label[2] = guiCreateElement( ELEMENT_TYPE_LABEL, "Снять:", 22.0, 90.0, 300.0, 20.0, false, window);
    showCursor(true);
}
addEventHandler("showBankGUI",showBankGUI)

function hideBankGUI(){
    guiSetVisivle(window,false);
    showCursor(false);
}
