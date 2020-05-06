const ELEMENT_TYPE_BUTTON = 2;
const ELEMENT_TYPE_IMAGE = 13;

local screen = getScreenSize();
local window;
local input = array(2);
local label = array(7);

local buttons = array(5);

local decor = array(8);
local titles = array(2);

local buttonLock = false;

local stationName;
local stationState;
local lang;

local moneyLabel;
local moneyInput;
local moneyAddButton;
local moneySubButton;

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
local saleBizPriceInput;


local windowWidth = 418.0;
local windowHeight = 342.0;
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

function showFuelStationGUI(dataSrc){
    local data = compilestring.call(getroottable(), format("return %s", dataSrc))();
    stationName = data.stationName;
    stationState = data.state;
    lang = data.lang;
    if(window) {//if widow created
        guiSetVisible(window, true);
        delayedFunction(5, function() {
          guiSetText(saleAmountLabel, data.amount);
          guiSetText(salePriceInput, data.price);
          guiSetText(purchaseAmountInput, data.amountIn);
          guiSetText(purchasePriceInput, data.priceIn);
          guiSetText(stateLabel, TRANSLATIONS[data.lang][data.state]);
          guiSetText(actionButton, TRANSLATIONS[data.lang].actionButton[data.state]);
          guiSetText(saleBizPriceInput, data.saleprice);
          guiSetText(label[6], "Продать городу за $ "+data.saleToCityPrice+" сейчас");
          guiSetText(moneyLabel, "Баланс: $ "+data.money);
          guiSetText(titles[0], "Продажа");
        });

        showCursor(true);
    } else {
        window = guiCreateElement(ELEMENT_TYPE_WINDOW, "Автозаправка "+data.name, screen[0]/2 - windowWidth/2, screen[1]/2 - windowHeight/2, windowWidth, windowHeight);
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


        moneyLabel = createElem(window, ELEMENT_TYPE_LABEL, "Баланс: $ "+data.money, windowWidth/2 - 40.0, 145.0, 80.0, 20.0);
        moneyInput = createElem(window, ELEMENT_TYPE_EDIT, "0",  windowWidth/2 - 25.0, 170.0, 50.0, 20.0);

        moneyAddButton = createElem(window, ELEMENT_TYPE_BUTTON, "Добавить", windowWidth/2 - 30.0 - 100.0, 170.0, 100.0, 21.0);
        moneySubButton = createElem(window, ELEMENT_TYPE_BUTTON, "Забрать", windowWidth/2 + 30.0, 170.0, 100.0, 21.0);

        local y = 200;

        // Разделитель
        decor[4] = createElem(window, 13, "dot.jpg", 0, y, windowWidth, 1.0);
        decor[5] = createElem(window, 13, "shadow.jpg", 0, y + 1.0, windowWidth, 1.0);

        // Строка состояния
        label[4] = createElem(window, ELEMENT_TYPE_LABEL, "Статус:", 40.0, y + 10.0, 50.0, 20.0);
        stateLabel = createElem(window, ELEMENT_TYPE_LABEL, TRANSLATIONS[data.lang][data.state], 90.0, y + 10.0, 150.0, 20.0);
        actionButton = createElem(window, ELEMENT_TYPE_BUTTON, TRANSLATIONS[data.lang].actionButton[data.state], windowWidth/2 + 40.0, y + 10.0, 110.0, 21.0);

        // Строка выставления на продажу
        label[5] = createElem(window, ELEMENT_TYPE_LABEL, "Выставить на продажу за", 40.0, y + 35.0, 170.0, 20.0);
        saleBizPriceInput = createElem(window, ELEMENT_TYPE_EDIT, data.saleprice, windowWidth/2 - 25.0, y + 36.0, 50.0, 20.0);
        saleButton = createElem(window, ELEMENT_TYPE_BUTTON, "Выставить", windowWidth/2 + 40.0, y + 35.0, 110.0, 21.0);

        // Строка продажи городу
        label[6] = createElem(window, ELEMENT_TYPE_LABEL, "Продать городу за $ "+data.saleToCityPrice+" сейчас", 40.0, y + 60.0, 190.0, 20.0);
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

        if(data.state == "onsale") {
            // for onsale
            guiSetVisible(label[5], false);
            guiSetVisible(saleBizPriceInput, false);
            guiSetVisible(saleButton, false);
        }

        guiSetAlwaysOnTop(decor[0], true);
        guiSetAlwaysOnTop(decor[1], true);
        guiSetMovable(window,false);
        guiSetSizable(window,false);
        closeWindowButton = createElem(window, ELEMENT_TYPE_BUTTON, "Закрыть", windowWidth/2 - 50.0, windowHeight - 38.0, 100.0, 25.0);
        showCursor(true);
    }
}
addEventHandler("showFuelStationGUI", showFuelStationGUI)

addEventHandler("redrawFuelStationGUI", showFuelStationGUI)

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
    if(buttonLock) return;
    buttonLock = true;
    delayedFunction(1000, function() {
        buttonLock = false;
    })
    // 1. save price, priceIn, amountIn
    // 2. money deposit, money withdraw
    // 3. changeStatus
    // 4. onSalse
    // 5. saleNow
    log("onGuiElementClick")


    if(element == saveButton){
        triggerServerEvent("bizFuelStationSave", stationName, guiGetText(salePriceInput), guiGetText(purchaseAmountInput), guiGetText(purchasePriceInput));
    }

    if(element == actionButton){
        if(stationState == "opened" || stationState == "onsale") {
            stationState = "closed";
            triggerServerEvent("bizFuelStationClose", stationName);

            // for onsale -> closed
            guiSetVisible(label[5], true);
            guiSetVisible(saleBizPriceInput, true);
            guiSetVisible(saleButton, true);
        } else if(stationState == "closed") {
            stationState = "opened";
            triggerServerEvent("bizFuelStationOpen", stationName);
        }

        guiSetText(actionButton, TRANSLATIONS[lang].actionButton[stationState]);
        guiSetText(stateLabel, TRANSLATIONS[lang][stationState]);
    }

    if(element == saleButton) {
        stationState = "onsale";
        guiSetText(actionButton, TRANSLATIONS[lang].actionButton[stationState]);
        guiSetText(stateLabel, TRANSLATIONS[lang][stationState]);
        triggerServerEvent("bizFuelStationOnSale", stationName, guiGetText(saleBizPriceInput));
        guiSetVisible(label[5], false);
        guiSetVisible(saleBizPriceInput, false);
        guiSetVisible(saleButton, false);
    }

    if(element == saleNowButton) {
        triggerServerEvent("bizFuelStationOnSaleToCity", stationName);
    }

    if(element == moneyAddButton) {
        triggerServerEvent("bizFuelStationOnAddBalanceMoney", stationName, guiGetText(moneyInput));
        guiSetText(moneyInput, "0");
    }

    if(element == moneySubButton) {
        triggerServerEvent("bizFuelStationOnSubBalanceMoney", stationName, guiGetText(moneyInput));
        guiSetText(moneyInput, "0");
    }

    if(element == closeWindowButton){
        hideFuelStaionGUI();
    }
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}