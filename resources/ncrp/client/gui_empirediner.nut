local REGEXP_INTEGER = regexp("\\d+");
local REGEXP_FLOAT   = regexp("[0-9\\.]+");

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

local currentShop = null;
local showing = false;
local window = {};
local lastWindowType;
local logo;
local labelTitle = array(8);
local labelPrice = array(8);
local label = array(16);
local items = array(8);
local buttons = array(9);
local buyText = "Buy";

local  leftColumnX = 16.0; //leftColumnX
local rightColumnX = 199.0;
local columnYfirst = 35.0;

local columnY1 =  35.0;
local columnY2 = 114.0;
local columnY3 = 193.0;
local columnY4 = 272.0;

local pBuy = [73.0, 41.0];
local pTitle = [73.0, -1.0];
local pPrice = [73.0, 16.0];

local TRANSLATIONS = {

    "en": {
        "buy"                   : "Buy"
        "close"                 : "Close"

        "Item.None"             : ""
        "Item.Revolver"         : "Revolver .38"
        "Item.MauserC96"        : "Mauser C96"
        "Item.Colt"             : "Colt M1911"
        "Item.ColtSpec"         : "Colt M1911 Special"
        "Item.Magnum"           : "Magnum"
        "Item.MK2"              : "MK2"
        "Item.Remington870"     : "Remington 870"
        "Item.M3GreaseGun"      : "MP Grease Gun"
        "Item.MP40"             : "MP-40"
        "Item.Thompson1928"     : "Thompson 1928"
        "Item.M1A1Thompson"     : "M1A1 Thompson"
        "Item.Beretta38A"       : "Beretta 38A"
        "Item.MG42"             : "MG-42"
        "Item.M1Garand"         : "M1 Garand"
        "Item.Kar98k"           : "Kar 98k"
        "Item.Molotov"          : "Molotov"
        "Item.Ammo45ACP"        : "Ammo .45 ACP"
        "Item.Ammo357Magnum"    : "Ammo .357"
        "Item.Ammo12"           : "Ammo .12"
        "Item.Ammo9x19mm"       : "Ammo 9x19 mm"
        "Item.Ammo792x57mm"     : "Ammo 7.92x57 mm"
        "Item.Ammo762x63mm"     : "Ammo 7.62x63 mm"
        "Item.Ammo38Special"    : "Ammo .38"

        "Item.Clothes"          : "Clothes"

        "Item.Whiskey"          : "Whiskey"
        "Item.MasterBeer"       : "Master Beer",
        "Item.OldEmpiricalBeer" : "Old Empirical",
        "Item.StoltzBeer"       : "Stoltz Beer",
        "Item.Wine"             : "Wine",
        "Item.Brendy"           : "Brendy",

        "Item.Burger"           : "Burger"
        "Item.Hotdog"           : "Hotdog"
        "Item.Sandwich"         : "Sandwich"
        "Item.Cola"             : "Cola"
        "Item.Gyros"            : "Gyros"
        "Item.Donut"            : "Donut"
        "Item.CoffeeCup"        : "Cup of coffee"

        "Item.Jerrycan"         : "Canister"
        "Item.VehicleTax"       : "Vehicle tax"
        "Item.VehicleKey"       : "Vehicle key"
        "Item.FirstAidKit"      : "First aid kit"
        "Item.Passport"         : "Passport"
        "Item.PoliceBadge"      : "Police badge"
        "Item.Gift"             : "Gift"
        "Item.Box"              : "Box"
        "Item.Dice"             : "Dice"

        "Item.BigBreakRed"      : "Big Break Red"
        "Item.BigBreakBlue"     : "Big Break Blue"
        "Item.BigBreakWhite"    : "Big Break White"

        "Item.Methamnetamine"   : "Methamnetamine"

    },
    "ru": {
        "buy"                   : "Купить",
        "close"                 : "Закрыть",

        "Item.None"             : ""
        "Item.Revolver"         : "Revolver .38"
        "Item.MauserC96"        : "Mauser C96"
        "Item.Colt"             : "Colt M1911"
        "Item.ColtSpec"         : "Colt M1911 Special"
        "Item.Magnum"           : "Magnum"
        "Item.MK2"              : "MK2"
        "Item.Remington870"     : "Remington 870"
        "Item.M3GreaseGun"      : "MP Grease Gun"
        "Item.MP40"             : "MP-40"
        "Item.Thompson1928"     : "Thompson 1928"
        "Item.M1A1Thompson"     : "M1A1 Thompson"
        "Item.Beretta38A"       : "Beretta 38A"
        "Item.MG42"             : "MG-42"
        "Item.M1Garand"         : "M1 Garand"
        "Item.Kar98k"           : "Kar 98k"
        "Item.Molotov"          : "Коктейль Молотова"
        "Item.Ammo45ACP"        : "Патроны .45 ACP"
        "Item.Ammo357Magnum"    : "Патроны .357"
        "Item.Ammo12"           : "Патроны .12"
        "Item.Ammo9x19mm"       : "Патроны 9x19 mm"
        "Item.Ammo792x57mm"     : "Патроны 7.92x57 mm"
        "Item.Ammo762x63mm"     : "Патроны 7.62x63 mm"
        "Item.Ammo38Special"    : "Патроны .38"

        "Item.Clothes"          : "Одежда"

        "Item.Whiskey"          : "Виски",
        "Item.MasterBeer"       : "Пиво Мастер",
        "Item.OldEmpiricalBeer" : "Старый Эмпайр",
        "Item.StoltzBeer"       : "Пиво Штольц",
        "Item.Wine"             : "Вино",
        "Item.Brandy"           : "Бренди",

        "Item.Burger"           : "Бургер"
        "Item.Hotdog"           : "Хот-дог"
        "Item.Sandwich"         : "Сэндвич"
        "Item.Cola"             : "Кола"
        "Item.Gyros"            : "Гирос"
        "Item.Donut"            : "Пончик"
        "Item.CoffeeCup"        : "Чашка кофе"

        "Item.Jerrycan"         : "Канистра"
        "Item.VehicleTax"       : "Квитанция налога на ТС"
        "Item.VehicleKey"       : "Ключ от автомобиля"
        "Item.FirstAidKit"      : "Аптечка"
        "Item.Passport"         : "Паспорт"
        "Item.PoliceBadge"      : "Полицейский жетон"
        "Item.Gift"             : "Подарок"
        "Item.Box"              : "Ящик"
        "Item.Dice"             : "Игральный кубик"

        "Item.BigBreakRed"      : "Big Break Red"
        "Item.BigBreakBlue"     : "Big Break Blue"
        "Item.BigBreakWhite"    : "Big Break White"

        "Item.Methamnetamine"   : "Метамфетамин"
    }
};




addEventHandler("showShopGUI", function(dataSrc, lang, uid) {
    //log("assortment");
    //log(dataSrc);
    local data = compilestring.call(getroottable(), format("return %s", dataSrc))();
    currentShop = uid;
    //local data2 = JSONParser.parse("{\"type\":\"empirediner\",\"items\":[4,8,15,16]}");
    //log(data.type);
    //log(data.items.len().tostring());
    //log("------------------------------------------------------------------------------------");

    showing = true;
    local yoffset = 151.0;


    // if widow created
    if (lastWindowType == data.type) {
        guiSetSize(window[lastWindowType], 378.0, 548.0 - yoffset);
        guiSetPosition(window[lastWindowType], screen[0]/2 - 383.0, screen[1]/2 - (548.0 - yoffset)/2);
        guiSetVisible( window[lastWindowType], true);
    }
    // if widow doesn't created, create his
    else {

        lastWindowType = data.type;
        window[lastWindowType] <- guiCreateElement( ELEMENT_TYPE_WINDOW, data.title, screen[0]/2 - 383.0, screen[1]/2 - (548.0 - yoffset)/2, 378.0, 548.0 - yoffset);

        delayedFunction(0, function() {
            createItems(data.items, lang);
        });
        // logo     =  guiCreateElement( ELEMENT_TYPE_IMAGE, "shop.logo.empirediner.png",    16.0, 29.0, 248.0, 151.0, false, window);

        buttons[8] = guiCreateElement(  ELEMENT_TYPE_BUTTON, TRANSLATIONS[lang].close,   378/2 - 38.0,  508.0 - yoffset, 76.0, 24.0, false, window[lastWindowType]);

        // buttons.map(guiBringToFront);
        // items.map(guiBringToFront);
        // guiBringToFront(logo);
    }

    // // for repaint! It's final visible values
    // delayedFunction(5, function() {
    //     guiSetText( window, "Restaurant");
    //     guiSetText( buttons[0], "Buy"   );
    //     guiSetText( buttons[1], "Close" );

    //     guiSetText( label[0]  , "Burger"    );
    //     guiSetText( label[1]  , "$0.50"     );
    //     // guiSetText( label[2]  , "128 ккал"  );
    //     guiSetText( label[3]  , "0"         );
    //     guiSetText( label[4]  , "Hotdog"    );
    //     guiSetText( label[5]  , "$0.10"     );
    //     // guiSetText( label[6]  , "128 ккал"  );
    //     guiSetText( label[7]  , "0"         );
    //     guiSetText( label[8]  , "Sandwich"  );
    //     guiSetText( label[9]  , "$0.25"     );
    //     // guiSetText( label[10] , "128 ккал"  );
    //     guiSetText( label[11] , "0"         );
    //     guiSetText( label[12] , "Cola"      );
    //     guiSetText( label[13] , "$0.50"     );
    //     // guiSetText( label[14] , "128 ккал"  );
    //     guiSetText( label[15] , "0"         );
    // });

    if (typeof window[lastWindowType] != "userdata") return;

    guiSetSizable(window[lastWindowType], false);
    guiSetMovable(window[lastWindowType], false);
    // showCursor(true);
});

function createItems(itemsData, lang) {
    for (local i = 0; i < 8; i++) {
        if(i in itemsData) {
            local posX = leftColumnX;
            if(i % 2 == 1) {
                posX = rightColumnX;
            }

            local posY = columnYfirst + 79 * floor(i / 2);
            local title = "";
            if (itemsData[i].itemName == "Item.Clothes") {
                title = TRANSLATIONS[lang][itemsData[i].itemName]+" ["+itemsData[i].amount+"]";
            } else {
                title = TRANSLATIONS[lang][itemsData[i].itemName];
            }
            items[i]      = guiCreateElement( ELEMENT_TYPE_IMAGE,   itemsData[i].itemName.tostring()+".png",    posX           ,  posY           ,   64.0, 64.0, false, window[lastWindowType]);
            buttons[i]    = guiCreateElement( ELEMENT_TYPE_BUTTON,  TRANSLATIONS[lang].buy,                     posX+pBuy[0]   ,  posY+pBuy[1]   ,   70.0, 22.0, false, window[lastWindowType]);
            labelTitle[i] = guiCreateElement( ELEMENT_TYPE_LABEL,   title,                                      posX+pTitle[0] ,  posY+pTitle[1] ,  100.0, 15.0, false, window[lastWindowType]);
            labelPrice[i] = guiCreateElement( ELEMENT_TYPE_LABEL,   "$"+itemsData[i].price.tostring(),          posX+pPrice[0] ,  posY+pPrice[1] ,  100.0, 15.0, false, window[lastWindowType]);

            guiBringToFront(buttons[i]);
            guiBringToFront(items[i]);
        }
    }

}

function hideShopGUI () {
    if (!showing) {
        return;
    }

    showing = false;

    delayedFunction(1, function() {
        guiSetVisible(window[lastWindowType],false);
        //window = null;
        //guiDestroyElement( window );
    })
    // guiSetText( label[0], ""); //don't touch, it's magic. Doesn't work without it
    delayedFunction(100, hideCursor); //todo fix
}

addEventHandler("onPlayerInventoryHide", hideShopGUI);

function resetShopValues() {
    [3, 7, 11, 15].map(function(id) {
        local data = label[id];
        if (typeof data == "userdata") {
            guiSetText(data, "0");
        }
    });

}

function hideCursor() {
    showCursor(false);
}

function shopChangeCount(objname, offset) {
    local count = guiGetText( objname ).tointeger() + offset;
    if (count < 0) count = 0;
    if (count > 9) count = 9;
    guiSetText( objname, count.tostring());
    shopCalculate();
}

function shopCalculate() {
     local count = toFloat(guiGetText( label[1] )) * toInteger(guiGetText( label[3] ))+
                   toFloat(guiGetText( label[5] )) * toInteger(guiGetText( label[7] ))+
                   toFloat(guiGetText( label[9] )) * toInteger(guiGetText( label[11] ))+
                   toFloat(guiGetText( label[13] )) * toInteger(guiGetText( label[15] ));
}

function buyItem(index) {
    triggerServerEvent("shop:purchase", format("{\"type\":\"%s\",\"shop\":\"%s\",\"itemIndex\":%s}", lastWindowType, currentShop, index.tostring()));
}

addEventHandler("onGuiElementClick", function(element) {
    if(element == buttons[8]){
        triggerServerEvent("shop:close", lastWindowType);
        return hideShopGUI();
    }
    if(element == buttons[0]){
        buyItem(0);
    }
    if(element == buttons[1]){
        buyItem(1);
    }
    if(element == buttons[2]){
        buyItem(2);
    }
    if(element == buttons[3]){
        buyItem(3);
    }
    if(element == buttons[4]){
        buyItem(4);
    }
    if(element == buttons[5]){
        buyItem(5);
    }
    if(element == buttons[6]){
        buyItem(6);
    }
    if(element == buttons[7]){
        buyItem(7);
    }
});


function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}

function isInteger(value) {
    return (value != null && (typeof value == "integer" || REGEXP_INTEGER.match(value)));
}

function isFloat(value) {
    return (value != null && (typeof value == "float" || REGEXP_FLOAT.match(value)));
}

function toInteger(value) {
    if (isInteger(value)) {
        return value.tointeger();
    }

    if (value == null) {
        return 0;
    }

    local result = REGEXP_INTEGER.search(value);

    if (result != null) {
        return value.slice(result.begin, result.end).tointeger();
    }

    return 0;
}


function toFloat(value) {
    if (isFloat(value)) {
        return value.tofloat();
    }

    if (value == null) {
        return 0;
    }

    local result = REGEXP_FLOAT.search(value);

    if (result != null) {
        return value.slice(result.begin, result.end).tofloat();
    }

    return 0;
}
