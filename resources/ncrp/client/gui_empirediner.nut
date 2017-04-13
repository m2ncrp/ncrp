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

local window;
local logo;
local label = array(16);
local items = array(4);
local buttons = array(10);
local buyText = "Buy";

addEventHandler("showShopGUI", function() {
    local yoffset = 151.0;
    // if widow created
    if (window) {
        guiSetSize(window, 280.0, 548.0 - yoffset);
        guiSetPosition(window,screen[0]/2 - 285.0, screen[1]/2 - (548.0 - yoffset)/2);
        guiSetVisible( window, true);
    }
    // if widow doesn't created, create his
    else {
        window   =  guiCreateElement( ELEMENT_TYPE_WINDOW, "Restaurant", screen[0]/2 - 285.0, screen[1]/2 - (548.0 - yoffset)/2, 280.0, 548.0 - yoffset);
        // logo     =  guiCreateElement( ELEMENT_TYPE_IMAGE, "shop.logo.empirediner.png",    16.0, 29.0, 248.0, 151.0, false, window);
        items[0] =  guiCreateElement( ELEMENT_TYPE_IMAGE, "Item.Burger.jpg",    23.0, 199.0 - yoffset, 64.0, 64.0, false, window);
        items[1] =  guiCreateElement( ELEMENT_TYPE_IMAGE, "Item.Hotdog.jpg",    23.0, 275.0 - yoffset, 64.0, 64.0, false, window);
        items[2] =  guiCreateElement( ELEMENT_TYPE_IMAGE, "Item.Sandwich.jpg",  23.0, 351.0 - yoffset, 64.0, 64.0, false, window);
        items[3] =  guiCreateElement( ELEMENT_TYPE_IMAGE, "Item.Cola.jpg",      23.0, 427.0 - yoffset, 64.0, 64.0, false, window);

        buttons[0] = guiCreateElement(  ELEMENT_TYPE_BUTTON, "Buy"  ,     280/2 - 110.0, 508.0 - yoffset, 135.0, 24.0, false, window);
        buttons[1] = guiCreateElement(  ELEMENT_TYPE_BUTTON, "Close"  ,   280/2 + 35.0,  508.0 - yoffset, 75.0, 24.0, false, window);

        buttons[2] = guiCreateElement(  ELEMENT_TYPE_BUTTON, "<"  ,      183.0, 232.0 - yoffset, 26.0, 22.0, false, window);      // for
        buttons[3] = guiCreateElement(  ELEMENT_TYPE_BUTTON, ">"  ,      232.0, 232.0 - yoffset, 26.0, 22.0, false, window);      // 3
        buttons[4] = guiCreateElement(  ELEMENT_TYPE_BUTTON, "<"  ,      183.0, 308.0 - yoffset, 26.0, 22.0, false, window);      // for
        buttons[5] = guiCreateElement(  ELEMENT_TYPE_BUTTON, ">"  ,      232.0, 308.0 - yoffset, 26.0, 22.0, false, window);      // 7
        buttons[6] = guiCreateElement(  ELEMENT_TYPE_BUTTON, "<"  ,      183.0, 384.0 - yoffset, 26.0, 22.0, false, window);      // for
        buttons[7] = guiCreateElement(  ELEMENT_TYPE_BUTTON, ">"  ,      232.0, 384.0 - yoffset, 26.0, 22.0, false, window);      // 11
        buttons[8] = guiCreateElement(  ELEMENT_TYPE_BUTTON, "<"  ,      183.0, 460.0 - yoffset, 26.0, 22.0, false, window);      // for
        buttons[9] = guiCreateElement(  ELEMENT_TYPE_BUTTON, ">"  ,      232.0, 460.0 - yoffset, 26.0, 22.0, false, window);      // 15


        label[0]  =  guiCreateElement( ELEMENT_TYPE_LABEL, "Burger",        102.0, 208.0 - yoffset, 100.0, 15.0, false, window);
        label[1]  =  guiCreateElement( ELEMENT_TYPE_LABEL, "$2.67",         207.0, 208.0 - yoffset, 100.0, 15.0, false, window);
        // label[2]  =  guiCreateElement( ELEMENT_TYPE_LABEL, "256 ккал",       102.0, 234.0 - yoffset, 100.0, 15.0, false, window);
        label[3]  =  guiCreateElement( ELEMENT_TYPE_LABEL, "0",             218.0, 234.0 - yoffset, 100.0, 15.0, false, window);
        label[4]  =  guiCreateElement( ELEMENT_TYPE_LABEL, "Hotdog",        102.0, 284.0 - yoffset, 100.0, 15.0, false, window);
        label[5]  =  guiCreateElement( ELEMENT_TYPE_LABEL, "$1.75",         207.0, 284.0 - yoffset, 100.0, 15.0, false, window);
        // label[6]  =  guiCreateElement( ELEMENT_TYPE_LABEL, "256 ккал",       102.0, 310.0 - yoffset, 100.0, 15.0, false, window);
        label[7]  =  guiCreateElement( ELEMENT_TYPE_LABEL, "0",             218.0, 310.0 - yoffset, 100.0, 15.0, false, window);
        label[8]  =  guiCreateElement( ELEMENT_TYPE_LABEL, "Sandwich",      102.0, 360.0 - yoffset, 100.0, 15.0, false, window);
        label[9]  =  guiCreateElement( ELEMENT_TYPE_LABEL, "$0.62",         207.0, 360.0 - yoffset, 100.0, 15.0, false, window);
        // label[10] =  guiCreateElement( ELEMENT_TYPE_LABEL, "256 ккал",       102.0, 386.0 - yoffset, 100.0, 15.0, false, window);
        label[11] =  guiCreateElement( ELEMENT_TYPE_LABEL, "0",             218.0, 386.0 - yoffset, 100.0, 15.0, false, window);
        label[12] =  guiCreateElement( ELEMENT_TYPE_LABEL, "Cola",          102.0, 436.0 - yoffset, 100.0, 15.0, false, window);
        label[13] =  guiCreateElement( ELEMENT_TYPE_LABEL, "$1.53",         207.0, 436.0 - yoffset, 100.0, 15.0, false, window);
        // label[14] =  guiCreateElement( ELEMENT_TYPE_LABEL, "256 ккал",       102.0, 462.0 - yoffset, 100.0, 15.0, false, window);
        label[15] =  guiCreateElement( ELEMENT_TYPE_LABEL, "0",             218.0, 462.0 - yoffset, 100.0, 15.0, false, window);

        buttons.map(guiBringToFront);
        image.map(guiBringToFront);
        guiBringToFront(logo);
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

    guiSetSizable(window, false);
    guiSetMovable(window, false);
    // showCursor(true);
});

function hideShopGUI () {
    resetShopValues();
    delayedFunction(1, function() {
        guiSetVisible(window,false);
    })
    //guiSetText( label[0], ""); //don't touch, it's magic. Doesn't work without it
    // delayedFunction(100, hideCursor); //todo fix
}

addEventHandler("onPlayerInventoryHide", hideShopGUI);

function resetShopValues() {
    [3, 7, 11, 15].map(function(id) {
        local data = label[id];
        if (typeof data == "userdata") {
            guiSetText(data, "0");
        }
    });

    guiSetText(buttons[0], "Buy");
}

function hideCursor() {
    // showCursor(false);
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
    guiSetText( buttons[0], format("Buy ($%.2f)", count ));
}

addEventHandler("onGuiElementClick", function(element) {
    if(element == buttons[0]){
        // BUY HERE
        //triggerServerEvent("PhoneCallGUI", number);

        local items = [3, 7, 11, 15].map(function(item) {
            return guiGetText(label[item]);
        }).reduce(function(curr, next) {
            return curr + "," + next;
        });

        triggerServerEvent("shop:purchase", format("{\"type\":\"%s\",\"items\":[%s]}", "empirediner", items));
        resetShopValues();
    }
    if(element == buttons[1]){
        triggerServerEvent("shop:close", "empirediner");
        return hideShopGUI();
    }
    if(element == buttons[2]){
        shopChangeCount(label[3], -1);
    }
    if(element == buttons[3]){
        shopChangeCount(label[3], 1);
    }
    if(element == buttons[4]){
        shopChangeCount(label[7], -1);
    }
    if(element == buttons[5]){
        shopChangeCount(label[7], 1);
    }
    if(element == buttons[6]){
        shopChangeCount(label[11], -1);
    }
    if(element == buttons[7]){
        shopChangeCount(label[11], 1);
    }
    if(element == buttons[8]){
        shopChangeCount(label[15], -1);
    }
    if(element == buttons[9]){
        shopChangeCount(label[15], 1);
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
