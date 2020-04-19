const ELEMENT_TYPE_BUTTON = 2;
const ELEMENT_TYPE_IMAGE = 13;

local screen = getScreenSize();
local window;
local input = array(2);
local label = array(7);

local buttons = array(5);

local decor = array(8);
local titles = array(2);

local saveButton;
local actionButton;
local saleButton;
local saleNowButton;

local saleAmountLabel;
local salePriceInput;
local purchaseAmountInput;
local purchasePriceInput;
local stateLabel;
local closeWindowButton;
local salePriceInput;


local windowWidth = 418.0;
local windowHeight = 312.0;
local labelTextEnterAmount = "Укажите сумму";

function createElem(window, type, text, x, y, W, H) {
    return guiCreateElement(type, text, x, y, W, H, false, window);
}

addCommandHandler( "mvv",
    function( playerid )
    {
     guiSetText(saleAmountLabel, "abc");
    }
);

local TRANSLATIONS = {
    "en": {
      "opened" : "Opened",
      "closed" : "Closed",
      "onsale" : "Sale",
  
      "actionButton": {
        "opened" : "Close",
        "closed" : "Open",
        "onsale" : "Out of sale",
      }
    },
    "ru": {
      "opened" : "Работает",
      "closed" : "Закрыто",
      "onsale" : "Выставлена на продажу",

      "actionButton": {
        "opened" : "Закрыть",
        "closed" : "Открыть",
        "onsale" : "Снять с продажи",
      }
    }
}

function showFuelStaionGUI(dataSrc){
    local data = compilestring.call(getroottable(), format("return %s", dataSrc))();
    if(window) {//if widow created
        guiSetVisible(window, true);
        delayedFunction(5, function() {
          guiSetText(saleAmountLabel, data.amount);
          guiSetText(salePriceInput, data.price);
          guiSetText(purchaseAmountInput, data.amountIn);
          guiSetText(purchasePriceInput, data.priceIn);
          guiSetText(stateLabel, TRANSLATIONS[data.lang][data.state]);
          guiSetText(actionButton, TRANSLATIONS[data.lang].actionButton[data.state]);
          guiSetText(label[6], "Продать городу за $"+(data.baseprice.tofloat() * 0.8)+" сейчас");
          guiSetText(titles[0], "Продажа");
        });

        showCursor(true);
    } else {
        window = guiCreateElement(ELEMENT_TYPE_WINDOW, "Автозаправка "+data.name, screen[0]/2 - 140, screen[1]/2 - windowHeight/2, windowWidth, windowHeight);
        decor[0] = createElem(window, 13, "dot.jpg", windowWidth/2, 22.0, 1.0, 75.0);
        decor[1] = createElem(window, 13, "shadow.jpg", windowWidth/2 + 1, 22.0, 1.0, 75.0);
        titles[0] = createElem(window, ELEMENT_TYPE_LABEL, "Продажа", windowWidth/4 - 25.0, 20.0, 100.0, 20.0);
        titles[1] = createElem(window, ELEMENT_TYPE_LABEL, "Покупка", windowWidth/2 + windowWidth/4 - 25.0, 20.0, 100.0, 20.0);
        label[0] = createElem(window, ELEMENT_TYPE_LABEL, "Количество:",                 40.0, 45.0, 70.0, 20.0);
        label[1] = createElem(window, ELEMENT_TYPE_LABEL, "Цена:",                       40.0, 70.0, 70.0, 20.0);
        label[2] = createElem(window, ELEMENT_TYPE_LABEL, "Количество:", windowWidth/2 + 40.0, 45.0, 70.0, 20.0);
        label[3] = createElem(window, ELEMENT_TYPE_LABEL, "Цена:",       windowWidth/2 + 40.0, 70.0, 70.0, 20.0);
        saleAmountLabel = createElem(window, ELEMENT_TYPE_LABEL, data.amount,  120.0, 45.0, 30.0, 20.0);
        salePriceInput = createElem(window, ELEMENT_TYPE_EDIT, data.price,  120.0, 71.0, 50.0, 20.0);

        saveButton = createElem(window, ELEMENT_TYPE_BUTTON, "Сохранить", windowWidth/2 - 50.0, 105.0, 100.0, 25.0);

        purchaseAmountInput = createElem(window, ELEMENT_TYPE_EDIT, data.amountIn, windowWidth/2 + 120.0, 46.0, 50.0, 20.0);
        purchasePriceInput = createElem(window, ELEMENT_TYPE_EDIT, data.priceIn, windowWidth/2 + 120.0, 71.0, 50.0, 20.0);

        // Разделитель
        decor[2] = createElem(window, 13, "dot.jpg", 0, 140.0, windowWidth, 1.0);
        decor[3] = createElem(window, 13, "shadow.jpg", 0, 141.0, windowWidth, 1.0);

        local y = 170;

        // Разделитель
        decor[4] = createElem(window, 13, "dot.jpg", 0, y, windowWidth, 1.0);
        decor[5] = createElem(window, 13, "shadow.jpg", 0, y + 1.0, windowWidth, 1.0);

        // Строка состояния
        label[4] = createElem(window, ELEMENT_TYPE_LABEL, "Статус:", 40.0, y + 10.0, 50.0, 20.0);
        stateLabel = createElem(window, ELEMENT_TYPE_LABEL, TRANSLATIONS[data.lang][data.state], 90.0, y + 10.0, 150.0, 20.0);
        actionButton = createElem(window, ELEMENT_TYPE_BUTTON, TRANSLATIONS[data.lang].actionButton[data.state], windowWidth/2 + 40.0, y + 10.0, 110.0, 21.0);

        // Строка выставления на продажу
        label[5] = createElem(window, ELEMENT_TYPE_LABEL, "Выставить на продажу за", 40.0, y + 35.0, 170.0, 20.0);
        salePriceInput = createElem(window, ELEMENT_TYPE_EDIT, data.saleprice, 180.0, y + 36.0, 50.0, 20.0);
        saleButton = createElem(window, ELEMENT_TYPE_BUTTON, "Выставить", windowWidth/2 + 40.0, y + 35.0, 110.0, 21.0);

        // Строка продажи городу
        local p = data.baseprice.tofloat() * 0.8;
        label[6] = createElem(window, ELEMENT_TYPE_LABEL, "Продать городу за $"+p+" сейчас", 40.0, y + 60.0, 170.0, 20.0);
        saleNowButton = createElem(window, ELEMENT_TYPE_BUTTON, "Продать", windowWidth/2 + 40.0, y + 60.0, 110.0, 21.0);

        // Разделитель
        decor[6] = createElem(window, 13, "dot.jpg", 0, windowHeight - 51.0, windowWidth, 1.0);
        decor[7] = createElem(window, 13, "shadow.jpg", 0, windowHeight - 50.0, windowWidth, 1.0);

        guiSetAlpha(decor[0], 0.5);
        guiSetAlpha(decor[1], 0.5);
        guiSetAlpha(decor[2], 0.5);
        guiSetAlpha(decor[3], 0.5);
        guiSetAlpha(decor[4], 0.5);
        guiSetAlpha(decor[5], 0.5);
        guiSetAlpha(decor[6], 0.5);
        guiSetAlpha(decor[7], 0.5);

        // label[1] = createElem(window ELEMENT_TYPE_LABEL, "Доступные операции:", windowWidth/2 - 56.0, 106.0, 300.0, 20.0);
        // input[1]   = createElem(window, ELEMENT_TYPE_EDIT, labelTextEnterAmount,                  windowWidth/2 - 120.0, 135.0, 240.0, 22.0);
        // buttons[0] = createElem(window, ELEMENT_TYPE_BUTTON, "Пополнить",       windowWidth/2 - 120.0, 165.0, 115.0, 30.0);
        // buttons[1] = createElem(window, ELEMENT_TYPE_BUTTON, "Снять",           windowWidth/2 + 5.0, 165.0, 115.0, 30.0);
        // buttons[2] = createElem(window, ELEMENT_TYPE_BUTTON, "Положить всё",    windowWidth/2 - 120.0, 202.0, 115.0, 30.0);
        // buttons[3] = createElem(window, ELEMENT_TYPE_BUTTON, "Снять всё",       windowWidth/2 + 5.0, 202.0, 115.0, 30.0);
        // label[2]   = createElem(window ELEMENT_TYPE_LABEL, "", windowWidth/2 - 90.0, 238.0, 180.0, 20.0);

        guiSetAlwaysOnTop(decor[0], true);
        guiSetAlwaysOnTop(decor[1], true);
        guiSetMovable(window,false);
        guiSetSizable(window,false);
        closeWindowButton = createElem(window, ELEMENT_TYPE_BUTTON, "Закрыть", windowWidth/2 - 50.0, windowHeight - 38.0, 100.0, 25.0);
        showCursor(true);
    }
}
addEventHandler("showFuelStaionGUI", showFuelStaionGUI)
/*
addEventHandler("bankSetErrorText", function(text){
    if(window){
        guiSetText( label[2], text);
    }
})

addEventHandler("bankUpdateBalance", function(balance){
    if(window){
        guiSetText( label[0], "Баланс: $" + balance);
    }
})
*/
function hideCursor() {
    showCursor(false);
}

function hideFuelStaionGUI(){
    guiSetVisible(window, false);
    guiSetText(titles[0], "");
    delayedFunction(100, hideCursor);//todo fix
}
addEventHandler("hideFuelStaionGUI", hideFuelStaionGUI);

addEventHandler( "onGuiElementClick", function(element) {
    //if(element == input[1] && strip(guiGetText(input[1])) == labelTextEnterAmount){
    //    guiSetText(input[1], "");
    //    guiSetText(label[2], "");
    //}
    // Deposit amount
    //if(element == buttons[0]){
    //    triggerServerEvent("bankPlayerDeposit", strip(guiGetText(input[1])));
    //    guiSetText(input[1], labelTextEnterAmount);
    //}

    // Withdraw amount
    //if(element == buttons[1]){
    //    triggerServerEvent("bankPlayerWithdraw", strip(guiGetText(input[1])));
    //    guiSetText(input[1], labelTextEnterAmount);
    //}

    // Deposit all
    //if(element == buttons[2]){
    //    triggerServerEvent("bankPlayerDeposit", "all");
    //}

    // Withdraw all
    //if(element == buttons[3]){
    //    triggerServerEvent("bankPlayerWithdraw", "all");
    //}

    if(element == closeWindowButton){
        hideFuelStaionGUI();
    }
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}