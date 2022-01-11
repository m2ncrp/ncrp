const ELEMENT_TYPE_BUTTON = 2;
const ELEMENT_TYPE_IMAGE = 13;

local screen = getScreenSize();
local window;
local input = array(2);
local label = array(3);
local buttons = array(5);
local image;

local windowWidth = 418.0;
local labelTextEnterAmount = "Укажите сумму";

function createElem(window, type, text, x, y, W, H) {
    return guiCreateElement(type, text, x, y, W, H, false, window);
}

function showHelpGUI(balance){
    if(window){//if widow created
        guiSetVisible( window, true);
        guiSetText( label[0], "Баланс: $" + balance);
        guiSetText( label[1], "Доступные операции:");
        guiSetText( input[1], labelTextEnterAmount);
        showCursor(true);
    } else {
        window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Помощь", screen[0]/2 - 140, screen[1]/2 - 150.0, windowWidth, 300.0 );
        image = createElem(window, 13, "bank.png", 0.0, 15.0, 418.0, 76.0);
        label[0] = createElem(window, ELEMENT_TYPE_LABEL, "Баланс: $"+balance,            windowWidth/2 - 50.0, 83.0, 100.0, 20.0);
        label[1] = createElem(window ELEMENT_TYPE_LABEL, "Доступные операции:", windowWidth/2 - 56.0, 106.0, 300.0, 20.0);
        input[1]   = createElem(window, ELEMENT_TYPE_EDIT, labelTextEnterAmount,                  windowWidth/2 - 120.0, 135.0, 240.0, 22.0);
        buttons[0] = createElem(window, ELEMENT_TYPE_BUTTON, "Пополнить",       windowWidth/2 - 120.0, 165.0, 115.0, 30.0);
        buttons[1] = createElem(window, ELEMENT_TYPE_BUTTON, "Снять",           windowWidth/2 + 5.0, 165.0, 115.0, 30.0);
        buttons[2] = createElem(window, ELEMENT_TYPE_BUTTON, "Положить всё",    windowWidth/2 - 120.0, 202.0, 115.0, 30.0);
        buttons[3] = createElem(window, ELEMENT_TYPE_BUTTON, "Снять всё",       windowWidth/2 + 5.0, 202.0, 115.0, 30.0);
        label[2]   = createElem(window ELEMENT_TYPE_LABEL, "", windowWidth/2 - 90.0, 238.0, 180.0, 20.0);
        buttons[4] = createElem(window, ELEMENT_TYPE_BUTTON, "Закрыть",         windowWidth/2 - 50.0, 262.0, 100.0, 25.0);
        showCursor(true);
    }
}
addEventHandler("showHelpGUI", showHelpGUI)


function hideCursor() {
    showCursor(false);
}

function hideHelpGUI(){
    guiSetVisible(window,false);
    guiSetText( label[0], "");
    delayedFunction(100, hideCursor);//todo fix
}
addEventHandler("hideHelpGUI", hideHelpGUI);

addEventHandler( "onGuiElementClick", function(element) {
    if(element == input[1] && strip(guiGetText(input[1])) == labelTextEnterAmount){
        guiSetText(input[1], "");
        guiSetText(label[2], "");
    }
    // Deposit amount
    if(element == buttons[0]){
        triggerServerEvent("bankPlayerDeposit", strip(guiGetText(input[1])));
        guiSetText(input[1], labelTextEnterAmount);
    }

    // Withdraw amount
    if(element == buttons[1]){
        triggerServerEvent("bankPlayerWithdraw", strip(guiGetText(input[1])));
        guiSetText(input[1], labelTextEnterAmount);
    }

    // Deposit all
    if(element == buttons[2]){
        triggerServerEvent("bankPlayerDeposit", "all");
    }

    // Withdraw all
    if(element == buttons[3]){
        triggerServerEvent("bankPlayerWithdraw", "all");
    }

    if(element == buttons[4]){
        hideBankGUI();
    }
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}