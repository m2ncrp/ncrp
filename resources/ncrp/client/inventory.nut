const MAX_INVENTORY_ITEMS = 30;
const ELEMENT_TYPE_IMAGE = 13;
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local invWindow;
local invItemImg = array(30, null);
local playerItems = array(30, 0);
local labelItems = array(30, 0);
local selectedSlot = -1;
local clickedSlot = -1;


local items = [
    { id = 0, title = "ёбаное ничего", img = "none.jpg"},
    { id = 1, title = "Бургер",        img = "burger.jpg"},
    { id = 2, title = "Хотдог",        img = "hotdog.jpg"},
    { id = 3, title = "Виски",         img = "whiskey.jpg"},
    { id = 4, title = "Свифт кола",    img = "swift-cola.jpg"},
    { id = 5, title = "Деньги",        img = "money.jpg"},
    { id = 6, title = "Квитанция",     img = "fine.jpg"},
];

local itemsPos =
[
    [10.0,25.0],    [78.0,25.0],    [146.0,25.0],   [214.0,25.0],   [282.0,25.0],
    [10.0,93.0],    [78.0,93.0],    [146.0,93.0],   [214.0,93.0],   [282.0,93.0],
    [10.0,161.0],   [78.0,161.0],   [146.0,161.0],  [214.0,161.0],  [282.0,161.0],
    [10.0,229.0],   [78.0,229.0],   [146.0,229.0],  [214.0,229.0],  [282.0,229.0],
    [10.0,297.0],   [78.0,297.0],   [146.0,297.0],  [214.0,297.0],  [282.0,297.0],
    [10.0,365.0],   [78.0,365.0],   [146.0,365.0],  [214.0,365.0],  [282.0,365.0]
];

addEventHandler("onServerSyncItems", function(slot,itemid){
    playerItems[slot] = itemid;
    log("onServerSyncItems"+itemid);
});


function initInventory()
{
    invWindow = guiCreateElement( ELEMENT_TYPE_WINDOW, "Инвентарь", screen[0]/2, screen[1]/2 - 232.5,  356.0, 465.0 );
    //guiSetVisible(inventoryWindow, false);
    //weight[0] = guiCreateElement( 13,"weight-bg.jpg", 10.0, 435.0, 346.0, 20.0, false, inventoryWindow);
    //weight[1] = guiCreateElement( 13,"weight-front.jpg", 10.0, 435.0, 180.0, 20.0, false, inventoryWindow);
    //weight[2] = guiCreateElement( ELEMENT_TYPE_LABEL, "Переносимый груз 1.3/5.0 kg", 140.0, 435.0, 190.0, 20.0, false, invWindow);
   for(local i = 0; i < MAX_INVENTORY_ITEMS; i++){
        local id = playerItems[i];
        invItemImg[i] = guiCreateElement( ELEMENT_TYPE_IMAGE, items[id].img, itemsPos[i][0], itemsPos[i][1], 64.0, 64.0, false, invWindow);
        guiSetAlpha(invItemImg[i], 0.8);
    }
    //guiSetAlwaysOnTop(weight[2], true);
    guiSetSizable(invWindow,false);
    showCursor(true);
}
addEventHandler("INV", initInventory);



function updatePlayerItem(slot, itemid) {
    playerItems[slot] = itemid.tointeger();
    guiSetVisible(invItemImg[slot],false);
    guiDestroyElement(invItemImg[slot]);
    local id = playerItems[slot];
    invItemImg[slot] = guiCreateElement( ELEMENT_TYPE_IMAGE, items[id].img, itemsPos[slot][0], itemsPos[slot][1], 64.0, 64.0, false, invWindow);
    guiSetAlpha(invItemImg[slot], 0.8);
    guiSetVisible(invItemImg[slot], true);
}

addEventHandler("updateSlot", function(slot, itemid) {
    updatePlayerItem(slot.tointeger(),itemid.tointeger());
})


addEventHandler( "onGuiElementClick",
    function( element ){
        for(local i = 0; i < MAX_INVENTORY_ITEMS; i++){
            if(element == invItemImg[i])
            {
               clickedSlot = i;
                if(selectedSlot != -1 && i != selectedSlot)
                {
                    triggerServerEvent("onPlayerMoveItem", selectedSlot, clickedSlot)
                    sendMessage("onPlayerMoveItem: selected: "+selectedSlot+ "clicked: "+clickedSlot);
                    guiSetAlpha(invItemImg[selectedSlot], 0.8);
                    return selectedSlot = -1; //reset select
                }
                if(selectedSlot != -1 && i == selectedSlot){
                    sendMessage("DOUBLE CLICK: selected: "+selectedSlot+ "clicked: "+clickedSlot);
                    guiSetAlpha(invItemImg[selectedSlot], 0.8);
                    return selectedSlot = -1;
                }
                if(playerItems[i] > 0){
                    guiSetAlpha(invItemImg[i], 1.0);
                    return selectedSlot = i;
                }
                sendMessage("clickid: "+clickedSlot+ "selectid: "+selectedSlot+"");
            }
        }
});