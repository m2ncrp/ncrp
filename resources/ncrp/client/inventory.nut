/* OLD INVENTORY BY BYDLO KLOCODER

local debug = true;
local screen = getScreenSize();

local inventoryWindow;
local characterWindow;
local characterSkin;
local vehicleWindow;
local trunkWindow;
local invImage = array(30);
local invItems = array(30);
local weight = array(3);
local playerItems = array(30);
local selectedItem = -1;
local peds = array(2);
local playerSkin = 1;
local mousePos;

local items =  //id, type, img  types: 1 - gun/ 2 - eat
[
[0,0, "empty.jpg", "none",""], //0
[1,1, "TommyGun.jpg", "Tommy Gun","my little Tommy"],
[2,1, "colt38.jpg", "Colt38","nice gun"],
[3,2, "Burger.jpg", "Burger","mmmmm, burger"],
[4,2, "Hotdog.jpg", "Hotdog","dog hot :3"]
];

local desctiptionWindow;
local desctiptionWindowLabel;
local MessageShowingId = -1;

addEventHandler("onClientScriptInit", function() {
    bindKey( "i", "up", OpenCloseInventory);
	initDescription();
	initInventory();
	resetPlayerItems();
	if(debug)log("onClientScriptInit - inventory.nut");
	
});




function resetPlayerItems()
{
	for(local i = 0; i < 30; i++)
	{
		playerItems[i] = 0;
	}
	MessageShowingId = -1;
	selectedItem = -1;
	playerItems[0] = 1;
	if(debug)log("Предметы игрока сброшены!");
}



function OpenCloseInventory()
{
	if(guiIsVisible(inventoryWindow)){hideInventory();}
	else{showInvetory();}
}
addEventHandler("OpenCloseInventory",OpenCloseInventory);

local itemsPos =
[
	[10.0,25.0],[78.0,25.0],[146.0,25.0],[214.0,25.0],[282.0,25.0],
	[10.0,93.0],[78.0,93.0],[146.0,93.0],[214.0,93.0],[282.0,93.0],
	[10.0,161.0],[78.0,161.0],[146.0,161.0],[214.0,161.0],[282.0,161.0],
	[10.0,229.0],[78.0,229.0],[146.0,229.0],[214.0,229.0],[282.0,229.0],
	[10.0,297.0],[78.0,297.0],[146.0,297.0],[214.0,297.0],[282.0,297.0],
	[10.0,365.0],[78.0,365.0],[146.0,365.0],[214.0,365.0],[282.0,365.0]
];

function showInvetory()
{
	if(debug)log("Инвентарь открыт! <>");
	showCursor(true);
	guiSetPosition(inventoryWindow,screen[0]/2, screen[1]/2 - 232.5); 
	guiSetPosition(characterWindow,screen[0]/2  - 305.0, screen[1]/2 - 232.5);
	for(local i = 0; i < 30; i++){
		if(playerItems[i] > 0){
			guiDestroyElement(invImage[i]);
			invImage[i] = guiCreateElement( 13,items[playerItems[i]][2], itemsPos[i][0], itemsPos[i][1], 64.0, 64.0, false, inventoryWindow);
			guiSetAlpha(invImage[i], 0.7);
			if(debug)log("Инвентарь открыт!Cмена картинки, проход:"+i);
		}
	} 
	guiSetVisible(inventoryWindow, true);
	guiSetVisible(characterWindow, true);
	local slot = findFreeSlot();
	sendMessage("Ближайший свободный слот:"+slot.tostring());
	if(debug)log("Инвентарь открыт! <>");
	
}


function initInventory()
{
	characterWindow = guiCreateElement( ELEMENT_TYPE_WINDOW, "Персонаж", 0.0, 0.0, 300.0, 465.0);
	inventoryWindow = guiCreateElement( ELEMENT_TYPE_WINDOW, "Инвентарь", 0.0, 0.0,  356.0, 465.0 );
	guiSetVisible(inventoryWindow, false);
	guiSetVisible(characterWindow, false);
	characterSkin = guiCreateElement( 13,"1.png", 10.0, 25.0, 140.0, 308.5, false, characterWindow);
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
	if(debug)log("Инвентарь инициализирован!");
}

function updatePlayerSkin(id)
{
	guiDestroyElement(characterSkin);
	characterSkin = guiCreateElement( 13,id.tostring()+".png",10.0, 25.0, 140.0, 308.5, false, characterWindow);
	sendMessage(playerSkin.tostring());
}
addEventHandler("updatePlayerSkin", updatePlayerSkin);

addEventHandler( "onGuiElementMouseEnter",
    function( element )
    {
		for(local i = 0; i<30;i++)
		{
			if( element == invImage[i]) 
			{
				if(debug)sendMessage("Id: "+i+" PlItems: "+playerItems[i]+" Alpha: "+guiGetAlpha(invImage[i]).tostring()+"");
				if(i != selectedItem){
					if(playerItems[i] > 0){
						showDescription(i);
					}
				}
			}
		}
		
    }
);

addEventHandler( "onGuiElementMouseLeave",
    function( element )
    {
        for(local i = 0; i<30;i++)
		{
			if( element == invImage[i]) 
			{
			   hideDescription();
			}
		}
    }
);

addEventHandler( "onGuiElementClick",
    function( element )
    {
        for(local i = 0; i<30;i++)
		{
			if( element == invImage[i]) 
			{
				if(playerItems[i] >0)
				{
					if(selectedItem != i){
						if(debug)sendMessage("clickid: "+i.tostring())
						guiSetAlpha(invImage[i], 1.0);
						if(selectedItem != -1){
							guiSetAlpha(invImage[selectedItem], 0.7);
						}
						selectedItem = i;
						hideDescription();						
					}
					else{
						guiSetAlpha(invImage[selectedItem], 0.7);
						selectedItem = -1;
						hideDescription();
					}
				}
				if( playerItems[i] == 0)
				{
					if(selectedItem != -1)
					{
						playerItems[i] = items[playerItems[selectedItem]][0];
						playerItems[selectedItem] = 0;
						guiChangeImage(invImage[i],items[playerItems[i]][2]);
						guiChangeImage(invImage[selectedItem],items[0][2]);
						guiSetAlpha(invImage[selectedItem], 0.7);
						guiSetAlpha(invImage[i], 0.7);	
					}
				}
			}
		}
    }
);

function frameRender( post )
{
	mousePos = getMousePosition();
	if(MessageShowingId != -1)
	{
		guiSetPosition(desctiptionWindow,mousePos[0]+5.0,mousePos[1]+5.0);
	}
}
addEventHandler( "onClientFrameRender", frameRender );


function initDescription()
{
	desctiptionWindow = guiCreateElement( ELEMENT_TYPE_WINDOW, "", 0.0, 0.0, 150.0, 100.0 );
	desctiptionWindowLabel = guiCreateElement( ELEMENT_TYPE_LABEL, "", 20.0, 20.0, 120.0, 20.0, false, desctiptionWindow); 
	guiSetAlwaysOnTop(desctiptionWindow,true);
	guiSetSizable(desctiptionWindow, false);
	guiSetVisible(desctiptionWindow, false);
	if(debug)log("Описание инициализировано!");
}

function showDescription(id)
{
	local pos = getMousePosition();
	guiSetText( desctiptionWindow, ""+items[playerItems[id]][3]+"");
	guiDestroyElement(desctiptionWindowLabel);
	desctiptionWindowLabel = guiCreateElement( ELEMENT_TYPE_LABEL, ""+items[playerItems[id]][4]+"", 20.0, 20.0, 120.0, 20.0, false, desctiptionWindow); 
	guiSetPosition(desctiptionWindow,pos[0]+5.0, pos[1]+5.0)
	MessageShowingId = id;
	guiSetVisible(desctiptionWindow,true);
}

function hideDescription()
{
	if(MessageShowingId != -1)
	{
		guiSetVisible(desctiptionWindow,false);
		MessageShowingId = -1;
	}
}

function random(min = 0, max = RAND_MAX)
{
   return (rand() % ((max + 1) - min)) + min;
}

function hideInventory()
{
	if(debug)log("Инвентарь закрыт! <>");
	if(guiIsVisible(desctiptionWindow)){
		guiSetVisible(desctiptionWindow,false);
	}
	if(debug)log("Инвентарь закрыт! >1<");
	if(guiIsVisible(inventoryWindow)){
		guiSetVisible(inventoryWindow,false);
	}
	if(debug)log("Инвентарь закрыт! >2<");
	if(guiIsVisible(characterWindow)){
		guiSetVisible(characterWindow,false);
	}
	if(debug)log("Инвентарь закрыт! >3<");
	showCursor(false);
	if(debug)log("Инвентарь закрыт! <>");
}

function findFreeSlot(){
	local freeSlot = -1;
	for(local i = 0; i < 30; i++){
		if(playerItems[i] == 0){
			freeSlot = i;
			break;
		}
	}
	return freeSlot;
}

 */