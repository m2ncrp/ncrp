//---------------------грайдлист-------------------------
screen  <- getScreenSize();
screenX <- screen[0].tofloat();
screenY <- screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];
centerX <- screenX * 0.5;
centerY <- screenY * 0.5;

ELEMENT_TYPE_WINDOW <- 0;
ELEMENT_TYPE_EDIT <- 1;
ELEMENT_TYPE_BUTTON <- 2;
ELEMENT_TYPE_CHECKBOX <- 3;
ELEMENT_TYPE_COMBOBOX <- 4;
ELEMENT_TYPE_GRIDLIST <- 5;
ELEMENT_TYPE_LABEL <- 6;
ELEMENT_TYPE_PROGRESSBAR <- 7;
ELEMENT_TYPE_RADIOBUTTON <- 8;
ELEMENT_TYPE_SCROLLBAR <- 9;
ELEMENT_TYPE_SCROLLPANE <- 10;
ELEMENT_TYPE_TABPANEL <- 11;
ELEMENT_TYPE_TAB <- 12;
ELEMENT_TYPE_IMAGE <- 13;

local window;
local title = "Список";
local components = {};

local gridlist_table_window = {}; //таблица созданных окон
local gridlist_table_text = {}; //таблица созданных текстов
local gridlist_window = false; //окно в котором выделяется текст
local gridlist_lable = false; //текст который будет выделяться
local gridlist_row = -1; //номер текста который будет выделяться
local gridlist_select = false; //выделение текста
local gridlist_button_width_height = [0.0, 0.0]; //ширина и высота кнопки купить
local max_lable = 30; //максимум сообщений на 1 стр



addEventHandler("showCraftWindow", function() {
		local width = 380.0;
		local height = 500.0;
		local offsetX = 135.0;
		local offsetY = 45.0;


    if(window){//if widow created
        guiSetSize(window, width, height);
        guiSetPosition(window,screen[0]/2 - offsetX, screen[1]/2 - offsetY);
        guiSetText(window, title);
        // guiSetText( label, labelText);
        // guiSetText( buttons[0], button1Text);
        // guiSetText( buttons[1], button2Text);
        guiSetVisible( window, true);
    }
    else{//if widow doesn't created, create his
        window =  guiCreateElement( ELEMENT_TYPE_WINDOW, title, screen[0]/2 - 135, screen[1]/2 - 45, width, height);


local labels = [];
local images = [];

local im = [
	"Item.Burger.png",
	"Item.Sandwich.png",
	"Item.Colt.png",
	"Item.BigBreakRed.png",
	"Item.Passport.png",
	"Item.PoliceBadge.png",
	"Item.Cola.png",
	"Item.Gift.png",
	"Item.Revolver.png",
	"Item.Hotdog.png"
];


local x = 14.0;
local y;



for (local i = 0; i <= 9; i++) {
	y = i;
	if(i >= 5) {
		x = 170.0;
		y = i - 5;
	}
	images.push(guiCreateElement(13, im[i], x, 20.0 + 70.0 * y + 6.0, 64.0, 64.0, false, window));
	labels.push(guiCreateElement(6, "Пункт "+(i+1).tostring(), x + 70.0, 20.0 + 70.0 * y, 140.0 - 64.0, 70.0, false, window));
}

local tabpanel = guiCreateElement(11, "", 9.0, 19.0 * 1, 140.0, 72.0 , false, window);
guiSendToBack(tabpanel)


addEventHandler( "onGuiElementClick", function(element) {
    if(element == components["btn_close"]){
        hideCraftWindow();
    }

		foreach (i, v in labels) {
			if(v == element || element == images[i]) {
					y = i;
					if(i >= 5) {
						x = 170.0;
						y = i - 5;
					} else {
						x = 14.0;
					}
				guiSetPosition(tabpanel, x - 5.0, 19.0 + 70.0 * y);
				break;
			}

		}


		if(element == components["btn_close"]){
        hideCraftWindow();
    }


});



function dxdrawtext(text, x, y, color, shadow, font, scale)
{
	if (shadow)
	{
		dxDrawText ( text, x+1, y+1, fromRGB ( 0, 0, 0 ), false, font, scale )

		dxDrawText ( text, x, y, color, false, font, scale )
	}
	else
	{
		dxDrawText ( text, x, y, color, false, font, scale )
	}
}

function dxdrawline_h (x1,y1, x2,y2, color, scale)
{
	for (local i = 0; i <= scale; i++)
	{
		local j = i/2
		dxDrawLine(x1,y1-j, x2,y2-j, color)
		dxDrawLine(x1,y1+j, x2,y2+j, color)
	}
}

function dxdrawline_w (x1,y1, x2,y2, color, scale)
{
	for (local i = 0; i <= scale; i++)
	{
		local j = i/2
		dxDrawLine(x1-j,y1, x2-j,y2, color)
		dxDrawLine(x1+j,y1, x2+j,y2, color)
	}
}



function setProgress() {
    log(combobox.tostring());
}
    delayedFunction(2000, setProgress);


/*
	for (local i = 1; i <= 10;  i++) {
			guiCreateElement(
            5,
            ["1", "2"],
            10.0,
            15.0 * i,
            width,
            15.0,
            true,
            window
        );
	}
*/

        // label = guiCreateElement( ELEMENT_TYPE_LABEL, labelText, 20.0, 20.0, 300.0, 40.0, false, window);
        components["btn_close"] <- guiCreateElement(ELEMENT_TYPE_BUTTON, "Close", width - 70.0, 30.0, 50.0, 20.0, false, window);
        //components[1] = guiCreateElement(  ELEMENT_TYPE_BUTTON, button2Text, 140.0, 60.0, 115.0, 20.0,false, window);
    }
    guiSetMovable(window, true);
    guiSetSizable(window, true);
    showCursor(true);
});



function hideCursor() {
    showCursor(false);
}

function hideCraftWindow () {
    guiSetVisible(window, false);
    //delayedFunction(100, hideCursor);
}

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}




function guiGridListAddRow(window, text) {
    if (window[0]) {
        local table_len = gridlist_table_text[window[1]].len();
        local guiSize_window = guiGetSize(window[0]);
        local text_gui = guiCreateElement(
            6,
            text,
            10.0,
            15.0 * table_len,
            guiSize_window[0],
            15.0,
            false,
            window[0]
        );

        gridlist_table_text[window[1]][table_len] <- text_gui;
        return true;
    } else {
        return false;
    }
}

function guiGridListGetItemText() {
    if (gridlist_lable) {
        local text = guiGetText(gridlist_lable);
        return text;
    } else {
        return false;
    }
}

function guiGridListGetSelectedItem() {
    if (gridlist_row != -1) {
        return gridlist_row;
    } else {
        return false;
    }
}

function guiSetVisibleGridList(window, bool) {
    if (window) {
        guiSetVisible(window[0], bool);

        gridlist_window = false;
        gridlist_lable = false;
        gridlist_row = -1;
        gridlist_select = false;

        return true;
    } else {
        return false;
    }
}

function guiGetVisibleGridList(window) {
    if (window) {
        return guiIsVisible(window[0]);
    }
}

function guiGetCountGridList(window) {
    if (window) {
        return gridlist_table_text[window[1]].len();
    } else {
        return false;
    }
}

function guiSetTextGridList(window, slot, text) {
    if (window) {
        return guiSetText(gridlist_table_text[window[1]][slot], text);
    } else {
        return false;
    }
}
//-------------------------------------------------------------------------------------------------
