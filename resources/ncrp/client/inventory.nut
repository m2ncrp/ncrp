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
local labelItems = array(30, 0);
local selectedSlot = -1;
local clickedSlot = -1;

enum ITEM_TYPE {
    NONE,
    FOOD,
    DRUNK,
    CLOTHES,
    OTHER,
    WEAPON,
    AMMO,
};

local items = [
    { id = 0,   weight = 0.0,   type = ITEM_TYPE.NONE,    stackable = false,  img = "none.jpg"},
    { id = 1,   weight = 0.0,   type = ITEM_TYPE.OTHER,   stackable = true,   img = "money.jpg"},
    { id = 2,   weight = 0.5,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "12Revolver.jpg"},
    { id = 3,   weight = 1.2,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "MauserC96.jpg"},
    { id = 4,   weight = 1.1,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "ColtM1911A1.jpg"},
    { id = 5,   weight = 1.5,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "ColtM1911Spec.jpg"},
    { id = 6,   weight = 0.9,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "19Revolver.jpg"},
    { id = 7,   weight = 0.6,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "MK2.jpg"},
    { id = 8,   weight = 3.6,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Remington870"},
    { id = 9,   weight = 3.5,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "M3GreaseGun.jpg"},
    { id = 10,  weight = 4.7,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "MP40.jpg"},
    { id = 11,  weight = 4.9,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Thompson1928.jpg"},
    { id = 12,  weight = 4.8,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "M1A1Thompson.jpg"},
    { id = 13,  weight = 3.3,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Beretta38A.jpg"},
    { id = 14,  weight = 11.5,  type = ITEM_TYPE.WEAPON,  stackable = false,  img = "MG42.jpg"},
    { id = 15,  weight = 4.3,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "M1Garand.jpg"},
    { id = 16,  weight = 0.0,   type = ITEM_TYPE.AMMO,    stackable = true,   img = ""},
    { id = 17,  weight = 3.9,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Kar98k.jpg"},
    { id = 18,  weight = 0.0,   type = ITEM_TYPE.AMMO,    stackable = true,   img = ""},
    { id = 19,  weight = 0.0,   type = ITEM_TYPE.AMMO,    stackable = true,   img = ""},
    { id = 20,  weight = 0.0,   type = ITEM_TYPE.AMMO,    stackable = true,   img = ""},
    { id = 21,  weight = 1.0,   type = ITEM_TYPE.WEAPON,  stackable = false,  img = "Molotov.jpg"},

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

addEventHandler("resetClientInvItem",function (){
    for(local i = 0; i < MAX_INVENTORY_SLOTS; i++) { // reset player items
        playerItems[i] <- {id = 0, amount = 0};
    }
});

addEventHandler("onServerSyncItems", function(slot,itemid,amount){
    playerItems[slot].id = itemid;
    playerItems[slot].amount = amount;
    log("onServerSyncItems"+itemid+":"+amount);
});


function initInventory()
{
    invWindow = guiCreateElement( ELEMENT_TYPE_WINDOW, "Инвентарь", screen[0]/2, screen[1]/2 - 232.5,  356.0, 465.0 );
    //guiSetVisible(inventoryWindow, false);
    //weight[0] = guiCreateElement( 13,"weight-bg.jpg", 10.0, 435.0, 346.0, 20.0, false, inventoryWindow);
    //weight[1] = guiCreateElement( 13,"weight-front.jpg", 10.0, 435.0, 180.0, 20.0, false, inventoryWindow);
    //weight[2] = guiCreateElement( ELEMENT_TYPE_LABEL, "Переносимый груз 1.3/5.0 kg", 140.0, 435.0, 190.0, 20.0, false, invWindow);
   for(local i = 0; i < MAX_INVENTORY_SLOTS; i++){
        local id = playerItems[i].id;
        invItemImg[i] = guiCreateElement( ELEMENT_TYPE_IMAGE, items[id].img, itemsPos[i][0], itemsPos[i][1], 64.0, 64.0, false, invWindow);
        labelItems[i] = guiCreateElement( ELEMENT_TYPE_LABEL, "", itemsPos[i][0]+50.0, itemsPos[i][1]+50.0, 15.0, 15.0, false, invWindow);
        guiSetAlwaysOnTop(labelItems[i], true);
        guiSetAlpha(invItemImg[i], 0.8);
    }
    //guiSetAlwaysOnTop(weight[2], true);
    guiSetSizable(invWindow,false);
    showCursor(true);
}
addEventHandler("INV", initInventory);



function updatePlayerItem(slot, itemid, amount) {
    playerItems[slot].id = itemid.tointeger();
    playerItems[slot].amount = amount.tointeger();
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


function formatLabelText(slot){
    local itemid = playerItems[slot].id;
    if(itemid == 0){
        return "";
    }
    if(items[itemid].type == ITEM_TYPE.WEAPON){
        return playerItems[slot].amount.tostring();
    }

}