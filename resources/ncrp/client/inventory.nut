const MAX_INVENTORY_ITEMS = 30;
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local invWindow;
local invitemImg;
local playerItems = array(30, 0);

local itemsPos =
[
    [10.0,25.0],    [78.0,25.0],    [146.0,25.0],   [214.0,25.0],   [282.0,25.0],
    [10.0,93.0],    [78.0,93.0],    [146.0,93.0],   [214.0,93.0],   [282.0,93.0],
    [10.0,161.0],   [78.0,161.0],   [146.0,161.0],  [214.0,161.0],  [282.0,161.0],
    [10.0,229.0],   [78.0,229.0],   [146.0,229.0],  [214.0,229.0],  [282.0,229.0],
    [10.0,297.0],   [78.0,297.0],   [146.0,297.0],  [214.0,297.0],  [282.0,297.0],
    [10.0,365.0],   [78.0,365.0],   [146.0,365.0],  [214.0,365.0],  [282.0,365.0]
];

function initInventory()
{
    inventoryWindow = guiCreateElement( ELEMENT_TYPE_WINDOW, "Инвентарь", 0.0, 0.0,  356.0, 465.0 );
    guiSetVisible(inventoryWindow, false);
    weight[0] = guiCreateElement( 13,"weight-bg.jpg", 10.0, 435.0, 346.0, 20.0, false, inventoryWindow);
    weight[1] = guiCreateElement( 13,"weight-front.jpg", 10.0, 435.0, 180.0, 20.0, false, inventoryWindow);
    weight[2] = guiCreateElement( ELEMENT_TYPE_LABEL, "Переносимый груз 1.3/5.0 kg", 140.0, 435.0, 190.0, 20.0, false, inventoryWindow);
    for(local i = 0; i < 5; i++){
        invImage[i] = guiCreateElement( 13,"empty.jpg", 10.0 +(68.0*i), 25.0, 64.0, 64.0, false, inventoryWindow);guiSetAlpha(invImage[i], 0.7);
        invImage[i+5] = guiCreateElement( 13,"empty.jpg", 10.0 +(68.0*i), 93.0, 64.0, 64.0, false, inventoryWindow);guiSetAlpha(invImage[i+5], 0.7);
        invImage[i+10] = guiCreateElement( 13,"empty.jpg", 10.0 +(68.0*i), 161.0, 64.0, 64.0, false, inventoryWindow);guiSetAlpha(invImage[i+10], 0.7);
        invImage[i+15] = guiCreateElement( 13,"empty.jpg", 10.0 +(68.0*i), 229.0, 64.0, 64.0, false, inventoryWindow);guiSetAlpha(invImage[i+15], 0.7);
        invImage[i+20] = guiCreateElement( 13,"empty.jpg", 10.0 +(68.0*i), 297.0, 64.0, 64.0, false, inventoryWindow);guiSetAlpha(invImage[i+20], 0.7);
        invImage[i+25] = guiCreateElement( 13,"empty.jpg", 10.0 +(68.0*i), 365.0, 64.0, 64.0, false, inventoryWindow);guiSetAlpha(invImage[i+25], 0.7);
    }
    guiSetAlwaysOnTop(weight[2], true);
    guiSetSizable(inventoryWindow,false);
    guiSetSizable(characterWindow,false);
}