const MAX_INVENTORY_SLOTS = 30;
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
local playerItems = {};
local labelItems = array(30, null);
local selectedSlot = -1;
local clickedSlot = -1;
local labelItemOffset = 50.0;

local itemsPos =
[
    [10.0,25.0],    [78.0,25.0],    [146.0,25.0],   [214.0,25.0],   [282.0,25.0],
    [10.0,93.0],    [78.0,93.0],    [146.0,93.0],   [214.0,93.0],   [282.0,93.0],
    [10.0,161.0],   [78.0,161.0],   [146.0,161.0],  [214.0,161.0],  [282.0,161.0],
    [10.0,229.0],   [78.0,229.0],   [146.0,229.0],  [214.0,229.0],  [282.0,229.0],
    [10.0,297.0],   [78.0,297.0],   [146.0,297.0],  [214.0,297.0],  [282.0,297.0],
    [10.0,365.0],   [78.0,365.0],   [146.0,365.0],  [214.0,365.0],  [282.0,365.0]
];


addEventHandler("onServerSyncItems", function(slot,classname,amount, type){  //slot, classname, amout, type
    playerItems[slot.tointeger()] <- {classname = classname, amount = amount.tointeger(), type = type};
    log(format("onServerSyncItems - slot: %s, classname: %s, amount: %s, type: %s", slot, classname,amount,type));
});


function initInventory()
{
    invWindow = guiCreateElement( ELEMENT_TYPE_WINDOW, "Инвентарь", screen[0]/2, screen[1]/2 - 232.5,  356.0, 465.0 );
    //guiSetVisible(inventoryWindow, false);
    //weight[0] = guiCreateElement( 13,"weight-bg.jpg", 10.0, 435.0, 346.0, 20.0, false, inventoryWindow);
    //weight[1] = guiCreateElement( 13,"weight-front.jpg", 10.0, 435.0, 180.0, 20.0, false, inventoryWindow);
    //weight[2] = guiCreateElement( ELEMENT_TYPE_LABEL, "Переносимый груз 1.3/5.0 kg", 140.0, 435.0, 190.0, 20.0, false, invWindow);
   for(local i = 0; i < MAX_INVENTORY_SLOTS; i++){
        invItemImg[i] = guiCreateElement( ELEMENT_TYPE_IMAGE, playerItems[i].classname+".jpg", itemsPos[i][0], itemsPos[i][1], 64.0, 64.0, false, invWindow);
        labelItems[i] = guiCreateElement( ELEMENT_TYPE_LABEL, "", itemsPos[i][0]+labelItemOffset, itemsPos[i][1]+labelItemOffset, 15.0, 15.0, false, invWindow);
        guiSetAlwaysOnTop(labelItems[i], true);
        guiSetAlpha(invItemImg[i], 0.8);
    }
    //guiSetAlwaysOnTop(weight[2], true);
    guiSetSizable(invWindow,false);
    showCursor(true);
}
addEventHandler("INV", initInventory);



function updatePlayerItem(slot, itemid, amount) {
    playerItems[slot].id = itemid;
    playerItems[slot].amount = amount;
    guiSetVisible(invItemImg[slot],false);
    guiDestroyElement(invItemImg[slot]);
    invItemImg[slot] = guiCreateElement( ELEMENT_TYPE_IMAGE, items[itemid].img, itemsPos[slot][0], itemsPos[slot][1], 64.0, 64.0, false, invWindow);
    guiSetText(labelItems[slot], formatLabelText(slot));
    guiSetAlpha(invItemImg[slot], 0.8);
    guiSetVisible(invItemImg[slot], true);
}

addEventHandler("updateSlot", function(slot, itemid, amount) {
    updatePlayerItem(slot.tointeger(),itemid.tointeger(), amount.tointeger());
})


addEventHandler( "onGuiElementClick",
    function( element ){
        for(local i = 0; i < MAX_INVENTORY_SLOTS; i++){
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
                if(playerItems[i].id > 0){
                    guiSetAlpha(invItemImg[i], 1.0);
                    return selectedSlot = i;
                }
                sendMessage("clickid: "+clickedSlot+ "selectid: "+selectedSlot+"");
            }
        }
});

/*
function formatLabelText(slot){
    local itemid = playerItems[slot].id;
    if(itemid == 0){
        return "";
    }
    if(items[itemid].type == ITEM_TYPE.WEAPON){
        return playerItems[slot].amount.tostring();
    }
    return "";

}
*/