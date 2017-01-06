const ELEMENT_TYPE_BUTTON = 2;
// check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local window;
local input = [];
local button = [];
local label = [];
local radio = [];

local isCharacterCreationMenu;
local isCharacterSelectionMenu;
local fieldsErrors = 0;

local PData = {};
PData.ID <- null;
PData.Firstname <- "";
PData.Lastname <- "";
PData.BDay <- "";
PData.Sex <- 0;
PData.Race <- 0;
PData.BDay <- 0;


local switchModelID = 0;

local characters = [];
local char = {};

local charDesc = array(2);
local charDescButton = array(2);

local charactersCount;
local migrateOldCharacter = false;

local otherPlayerLocked = true;

local kek;

local modelsData =
[
	[[71,72],[118,135]],//Euro
	[[43,42],[46,47]],//Niggas
	[[51,52],[56,57]] //Asia
]

addEventHandler("onServerCharacterLoading", function(id,firstname, lastname, race, sex, birthdate, money, deposit, cskin){
	local char = {};
	char.Id <- id;
	char.Firstname <- firstname;
	char.Lastname <- lastname;
	char.Race <- race;
	char.Sex <- sex;
	char.Bdate <- birthdate;
	char.money <- money;
	char.deposit <- deposit;
	char.cskin <- cskin
	characters.push( char );
});

addEventHandler("onServerCharacterLoaded", function(){
		charactersCount = characters.len();
		formatCharacterSelection();
		//kek = guiCreateElement(13,"someweirdshit.png", 0, 0, screen[0], screen[1]);
});

function characterSelection(){
	hideCharacterSelection();
	isCharacterSelectionMenu = true;
	togglePlayerControls( true );
	setPlayerPosition(getLocalPlayer(), -1598.5,69.0,-13.0);
	setPlayerRotation(getLocalPlayer(), 180.0,0.0,180.0);
	window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Выберите персонажа", screen[0] - 300.0, screen[1]/2- 175.0, 190.0, 320.0 );
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, charDesc[0], 20.0, 20.0, 300.0, 100.0, false, window));//label[0]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, charDesc[1], 20.0, 180.0, 300.0, 100.0, false, window));//label[1]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, charDescButton[0], 20, 120.0, 150.0, 20.0,false, window));//button[0]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, charDescButton[1], 20, 280.0, 150.0, 20.0,false, window));//button[1]
	guiSetAlwaysOnTop(window,true);
	guiSetSizable(window,false);
	showCursor(true);
}
addEventHandler("characterSelection",characterSelection);

function formatCharacterSelection () {
	if(charactersCount == 2){
		local race = getRaceFromId(characters[0].Race);
		local sex = getSexFromId(characters[0].Sex);
	    charDesc[0] = format("Имя: %s\nФамилия: %s\nРаса: %s\n",characters[0].Firstname,characters[0].Lastname,race);
	    charDesc[0] += format("Пол: %s\nДата рождения: %s\n",sex,characters[0].Bdate.tostring());
	    charDesc[0] += format("Денежных средств: %.2f$\nСчёт в банке: %.2f$",characters[0].money.tofloat(),characters[0].deposit.tofloat());
	    charDescButton[0] = "Выбрать персонажа";
	    race = getRaceFromId(characters[1].Race);
		sex = getSexFromId(characters[1].Sex);
	    charDesc[1] = format("Имя: %s\nФамилия: %s\nРаса: %s\n",characters[1].Firstname,characters[1].Lastname,race);
	    charDesc[1] += format("Пол: %s\nДата рождения: %s\n",sex,characters[1].Bdate.tostring());
	    charDesc[1] += format("Денежных средств: %.2f$\nСчёт в банке: %.2f$",characters[1].money.tofloat(),characters[1].deposit.tofloat());
	    charDescButton[1] = "Выбрать персонажа";
	}
	if(charactersCount == 1){
		if(characters[0].Firstname == ""){
			PData.Id <- characters[0].Id; // add data to push it later
    		migrateOldCharacter = true;
    		return characterCreation();
    	}
		local race = getRaceFromId(characters[0].Race);
		local sex = getSexFromId(characters[0].Sex);
	    charDesc[0] = format("Имя: %s\nФамилия: %s\nРаса: %s\n",characters[0].Firstname,characters[0].Lastname,race);
	    charDesc[0] += format("Пол: %s\nДата рождения: %s\n",sex,characters[0].Bdate.tostring());
	    charDesc[0] += format("Денежных средств: %.2f$\nСчёт в банке: %.2f$",characters[0].money.tofloat(),characters[0].deposit.tofloat());
	    charDescButton[0] = "Выбрать персонажа";
	    charDesc[1] = "Пустой слот\nЧтобы перейти к созданию\nНажмите кнопку";
	    charDescButton[1] = "Создать персонажа";
	}
	if(charactersCount == 0){
		charDesc[0] = "Пустой слот\nЧтобы перейти к созданию\nНажмите кнопку";
	    charDescButton[0] = "Создать персонажа";
		charDesc[1] = "Пустой слот\nЧтобы перейти к созданию\nНажмите кнопку";
	    charDescButton[1] = "Создать персонажа";
	}
	characterSelection();
}

function characterCreation(){
	hideCharacterSelection();
	isCharacterCreationMenu = true;
	togglePlayerControls( true );
	setPlayerPosition(getLocalPlayer(), -1598.5,69.0,-13.0);
	setPlayerRotation(getLocalPlayer(), 180.0,0.0,180.0);
	window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Создание персонажа", screen[0] - 300.0, screen[1]/2- 175.0, 190.0, 320.0 );
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Имя" 20.0, 20.0, 300.0, 20.0, false, window));//label[0]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Фамилия", 20.0, 60.0, 300.0, 20.0, false, window));//label[1]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Дата рождения", 20.0, 100.0, 300.0, 20.0, false, window));//label[2]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Выберите расу персонажа", 28.0, 175.0, 300.0, 20.0, false, window));//label[3]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Европеоидная", 55.0, 195.0, 300.0, 20.0, false, window));//label[4]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Негроидная", 55.0, 215.0, 300.0, 20.0, false, window));//label[5]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Монголоидная", 55.0, 235.0, 300.0, 20.0, false, window));//label[6]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Выберите скин", 57.0, 260.0, 300.0, 20.0, false, window));//label[7]
	input.push(guiCreateElement( ELEMENT_TYPE_EDIT, "Например: John", 20.0, 40.0, 150.0, 20.0, false, window));//input[0]
	input.push(guiCreateElement( ELEMENT_TYPE_EDIT, "Например: Douglas", 20.0, 80.0, 150.0, 20.0, false, window));//input[1]
	input.push(guiCreateElement( ELEMENT_TYPE_EDIT, "День", 20.0, 120.0, 50.0, 20.0, false, window));//input[2]
	input.push(guiCreateElement( ELEMENT_TYPE_EDIT, "Месяц", 70.0, 120.0, 50.0, 20.0, false, window));//input[3]
	input.push(guiCreateElement( ELEMENT_TYPE_EDIT, "Год", 120.0, 120.0, 50.0, 20.0, false, window));//input[4]
	radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 200.0, 15.0, 15.0,false, window));//radio[0]
	radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 220.0, 15.0, 15.0,false, window));//radio[1]
	radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 240.0, 15.0, 15.0,false, window));//radio[2]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "Мужчина", 20, 150.0, 70.0, 20.0,false, window));//button[0]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "Женщина", 100, 150.0, 70.0, 20.0,false, window));//button[1]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "<<", 20.0, 260.0, 30.0, 20.0,false, window));//button[2]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, ">>", 140.0, 260.0, 30.0, 20.0,false, window));//button[3]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "Продолжить", 20.0, 290.0, 150.0, 20.0,false, window));//button[4]
	guiSetAlwaysOnTop(window,true);
	guiSetSizable(window,false);
	showCursor(true);
}
addEventHandler("characterCreation",characterCreation);

addEventHandler( "onGuiElementClick",function(element){
	if(isCharacterCreationMenu){
		if(element == button[0]){ PData.Sex <- 0; changeModel();}
		if(element == button[1]){ PData.Sex <- 1; changeModel();}
		if(element == radio[0]) {PData.Race <- 0; changeModel();}
		if(element == radio[1]) {PData.Race <- 1; changeModel();}
		if(element == radio[2]) {PData.Race <- 2; changeModel();}
		if(element == button[2]) {switchModel();}
		if(element == button[3]) {switchModel();}
		if(element == input[0]) {guiSetText(input[0], "");}
		if(element == input[1]) {guiSetText(input[1], "");}
		if(element == input[2]) {guiSetText(input[2], "");}
		if(element == input[3]) {guiSetText(input[3], "");}
		if(element == input[4]) {guiSetText(input[4], "");}
		if(element == button[4]) {checkFields();}
	}
	if(isCharacterSelectionMenu)
	{
		if(charactersCount == 2){
			if(element == button[0]) return  selectCharacter(0);
			if(element == button[1]) return  selectCharacter(1);
		}
		if(charactersCount == 1){
			if(element == button[0]) return  selectCharacter(0);
			if(element == button[1]) return  characterCreation();
		}
		if(charactersCount == 0){
			if(element == button[0]) return  characterCreation();
			if(element == button[1]) return  characterCreation();
		}
	}
});

bindKey("shift", "down", function() {
	if(isCharacterCreationMenu || isCharacterSelectionMenu){
		showCursor(false);
	}
});

bindKey("shift", "up", function() {
   if(isCharacterCreationMenu || isCharacterSelectionMenu){
   		showCursor(true);
   }
});

function switchModel(){
	if(switchModelID == 0){
		switchModelID = 1;
	}
	else {
	    switchModelID = 0;
	}
	changeModel();
}

function changeModel () {
	setPlayerRotation(getLocalPlayer(), 180.0,0.0,0.0);
	local model = modelsData[PData.Race][PData.Sex][switchModelID];
    triggerServerEvent("changeModel", model);
    togglePlayerControls( true );
}

function checkFields () {
	fieldsErrors = 0;
	PData.Firstname <- guiGetText(input[0]);
	PData.Lastname <- guiGetText(input[1]);
	if(!isValidName(PData.Firstname)){
		guiSetText(label[0],"Некорректное Имя");
		guiSetText(input[0], "Например: John");
		return fieldsErrors++;
	}
	else {guiSetText(label[0],"Имя");}

	if(!isValidName(PData.Lastname)){
		guiSetText(label[1],"Некорректная Фамилия");
		guiSetText(input[1], "Например: John");
		return fieldsErrors++;
	}
	else {guiSetText(label[1],"Фамилия");}

	if(!isValidRange(guiGetText(input[2]), 0,32)){
		guiSetText(label[2],"'День' введен не корректно");
		guiSetText(input[2],"День");
		return fieldsErrors++;
	}
	else {guiSetText(label[2],"Дата рождения");}

	if(!isValidRange(guiGetText(input[3]),0,13)){
		guiSetText(label[2],"'Месяц' введен не корректно");
		guiSetText(input[3],"Месяц");
		return fieldsErrors++;
	}
	else {guiSetText(label[2],"Дата рождения");}

	if(!isValidRange(guiGetText(input[4]),1871,1933)){
		guiSetText(label[2],"'Год' введен не корректно");
		guiSetText(input[4],"Год");
		return fieldsErrors++;
	}
	else {guiSetText(label[2],"Дата рождения");}
	createCharacter();
}

function createCharacter() {
	local first = PData.Firstname;
	local last = PData.Lastname;
	local race = PData.Race;
	local sex = PData.Sex
	local bday = format("%02d.%02d.%04d",guiGetText(input[2]).tointeger(),guiGetText(input[3]).tointeger(),guiGetText(input[4]).tointeger());
	local model = modelsData[PData.Race][PData.Sex][switchModelID];
	triggerServerEvent("onPlayerCharacterCreate",first,last,race,sex,bday,model,(migrateOldCharacter && "Id" in PData) ? PData.Id : 0);
	log("migrating character: " + [first,last,race,sex,bday,model,(migrateOldCharacter && "Id" in PData) ? PData.Id : 0].reduce(@(a,b) a + " " + b));
}

function selectCharacter (id) {
	hideCharacterSelection();
	triggerServerEvent("onPlayerCharacterSelect",characters[id].Id);
	delayedFunction(200, function() {showCursor(false);});
}

function hideCharacterCreation() {
	if(isCharacterCreationMenu){
		guiSetVisible(window,false);
		window = null;
		input.clear();
		button.clear();
		label.clear();
		radio.clear();
    	isCharacterCreationMenu = false;
    	otherPlayerLocked = false
    	delayedFunction(200, function() {showCursor(false);});
	}
}
addEventHandler("hideCharacterCreation",hideCharacterCreation);

function hideCharacterSelection () {
    if(isCharacterSelectionMenu){
	    guiSetVisible(window,false);
	    window = null;
	    input.clear();
		button.clear();
		label.clear();
		radio.clear();
		otherPlayerLocked = false;
	    isCharacterSelectionMenu = false;
	    /*
	    if(kek){
	    	guiSetVisible(kek,false);
	    	kek = null;
	    }
	    */
	}
}

function isValidRange(input, a, b) {
    try {return (input.tointeger() > a && input.tointeger() < b); } catch (e) { return false; }
}

function isValidName(name){
    local check = regexp("^[A-Z][a-z]*$");
    return check.match(name);
}

function getRaceFromId (id) {
	switch (id) {
	    case 0:
	     	return "Eропеоидная"
	    break;
	    case 1:
	     	return "Негроидная"
	    break;
	    case 2:
	     	return "Монголоидная"
	    break;
	}
}

function getSexFromId (id) {
    switch (id) {
	    case 0:
	     	return "Мужской"
	    break;
	    case 1:
	     	return "Женский"
	    break;
	}
}

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}

addEventHandler( "onGuiElementMouseEnter",
    function( element ){
        if(isCharacterSelectionMenu) {
        	if(element == label[0] || element == button[0]){
        		if(charactersCount == 1){
        			triggerServerEvent("changeModel", characters[0].cskin);
        			setPlayerRotation(getLocalPlayer(), 180.0,0.0,0.0);
        		}
        		else {
        			setPlayerRotation(getLocalPlayer(), 180.0,0.0,180.0);
        		}
        	}
        	if(element == label[1] || element == button[1]){
        		if(charactersCount == 2){
        			triggerServerEvent("changeModel", characters[1].cskin);
        		}
        		else {
        		    setPlayerRotation(getLocalPlayer(), 180.0,0.0,180.0);
        		}
        	}
        }
    }
);

addEventHandler("onClientFrameRender", function(a) {
	if (!otherPlayerLocked || a) return;

	foreach (idx, value in getPlayers()) {
		if (idx == getLocalPlayer()) continue;
		setPlayerPosition(idx, DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z);
	}
	showChat(false);
});
