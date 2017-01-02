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

local isCharacterMenu;

local PlayerData = {};
PlayerData.Gender <- 0;
PlayerData.Race <- 0;

local switchModelID = 0;


local modelsData = 
[
	[[71,72],[118,135]],//Euro
	[[43,42],[46,47]],//Niggas
	[[51,52],[56,57]] //Asia
]

// modelsData[0][0][0] -> output: 73


function characterSelection(){

}
addEventHandler("wp",characterSelection);

function characterCreation(){
	changeModel();
	showCursor(true);
	setPlayerPosition(getLocalPlayer(), -1598.5,69.0,-13.0);
	setPlayerRotation(getLocalPlayer(), 180.0,0.0,0.0);
	window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Создание персонажа", screen[0] - 300.0, screen[1]/2- 175.0, 190.0, 320.0 );
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Имя" 20.0, 20.0, 300.0, 20.0, false, window));//label[0]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Фамилия", 20.0, 60.0, 300.0, 20.0, false, window));//label[1]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Дата рождения", 20.0, 100.0, 300.0, 20.0, false, window));//label[2]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Выберите расу персонажа", 28.0, 175.0, 300.0, 20.0, false, window));//label[3]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Европеоидная", 55.0, 195.0, 300.0, 20.0, false, window));//label[4]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Негроидная", 55.0, 215.0, 300.0, 20.0, false, window));//label[5]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Монголоидная", 55.0, 235.0, 300.0, 20.0, false, window));//label[6]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Выберите скин", 57.0, 260.0, 300.0, 20.0, false, window));//label[7]
	input.push(guiCreateElement( ELEMENT_TYPE_EDIT, "", 20.0, 40.0, 150.0, 20.0, false, window));//input[0]
	input.push(guiCreateElement( ELEMENT_TYPE_EDIT, "", 20.0, 80.0, 150.0, 20.0, false, window));//input[1]
	input.push(guiCreateElement( ELEMENT_TYPE_EDIT, "Например: 27.01.1931", 20.0, 120.0, 150.0, 20.0, false, window));//input[2]
	radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 200.0, 15.0, 15.0,false, window));//radio[0]
	radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 220.0, 15.0, 15.0,false, window));//radio[1]
	radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 240.0, 15.0, 15.0,false, window));//radio[2]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "Мужчина", 20, 150.0, 70.0, 20.0,false, window));//button[0]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "Женщина", 100, 150.0, 70.0, 20.0,false, window));//button[1]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "<<", 20.0, 260.0, 30.0, 20.0,false, window));//button[3]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, ">>", 140.0, 260.0, 30.0, 20.0,false, window));//button[4]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "Продолжить", 20.0, 290.0, 150.0, 20.0,false, window));//button[5]
	guiSetSizable(window,false);
	isCharacterMenu = true;
}
addEventHandler("gg",characterCreation);

addEventHandler( "onGuiElementClick",function(element){
	if(element == button[0]) PlayerData.Gender <- 0; changeModel();
	if(element == button[1]) PlayerData.Gender <- 1; changeModel();
	if(element == radio[0]) PlayerData.Race <- 0; changeModel();
	if(element == radio[1]) PlayerData.Race <- 1; changeModel();
	if(element == radio[2]) PlayerData.Race <- 2; changeModel();
	if(element == button[3]) switchModel();
	if(element == button[4]) switchModel();
});





bindKey("shift", "down", function() {
	if(isCharacterMenu){
		showCursor(false);
	}
});

bindKey("shift", "up", function() {
   if(isCharacterMenu){
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
	local model = modelsData[PlayerData.Race][PlayerData.Gender][switchModelID];
    triggerServerEvent("changeModel", model)
}



function checkFields () {
	//code
}

function creatCharacte () {
	//code
}


function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}


function isValidName (name) {
    local check = regexp("[A-Z][a-z]*");
    return check.match(email);
}

function isValidBday (bday) {
	//code
}
/* Бэкапчик
	window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Создание персонажа", screen[0] - 300.0, screen[1]/2- 175.0, 190.0, 320.0 );
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Имя" 20.0, 20.0, 300.0, 20.0, false, window));//label[0]
	input.push(guiCreateElement( ELEMENT_TYPE_EDIT, "", 20.0, 40.0, 150.0, 20.0, false, window));//input[0]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Фамилия", 20.0, 60.0, 300.0, 20.0, false, window));//label[1]
	input.push(guiCreateElement( ELEMENT_TYPE_EDIT, "", 20.0, 80.0, 150.0, 20.0, false, window));//input[1]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Дата рождения", 20.0, 100.0, 300.0, 20.0, false, window));//label[2]
	input.push(guiCreateElement( ELEMENT_TYPE_EDIT, "Например: 27.01.1931", 20.0, 120.0, 150.0, 20.0, false, window));//input[2]
	label.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "Мужчина", 20, 150.0, 70.0, 20.0,false, window));//button[0]
	label.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "Женщина", 100, 150.0, 70.0, 20.0,false, window));//button[1]
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Выберите расу персонажа", 28.0, 175.0, 300.0, 20.0, false, window));
	radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 200.0, 15.0, 15.0,false, window));
	radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 220.0, 15.0, 15.0,false, window));
	radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "", 25, 240.0, 15.0, 15.0,false, window));
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Европеоидная", 55.0, 195.0, 300.0, 20.0, false, window));
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Негроидная", 55.0, 215.0, 300.0, 20.0, false, window));
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Монголоидная", 55.0, 235.0, 300.0, 20.0, false, window));
	label.push(guiCreateElement( ELEMENT_TYPE_LABEL, "Выберите скин", 57.0, 260.0, 300.0, 20.0, false, window));
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "<<", 20.0, 260.0, 30.0, 20.0,false, window));//button[3]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, ">>", 140.0, 260.0, 30.0, 20.0,false, window));//button[4]
	button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "Продолжить", 20.0, 290.0, 150.0, 20.0,false, window));//button[5]
 */
