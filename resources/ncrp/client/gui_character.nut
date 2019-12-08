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

local isCharacterCreationMenu = false;
local isCharacterSelectionMenu = false;
local fieldsErrors = 0;

local PData = {};
PData.ID <- null;
PData.Firstname <- "";
PData.Lastname <- "";
PData.BDay <- "";
PData.Sex <- 0;
PData.Race <- 0;
PData.BDay <- 0;


const DEFAULT_SPAWN_X    = 0.0;//-1620.15;
const DEFAULT_SPAWN_Y    = 0.0;// 49.2881;
const DEFAULT_SPAWN_Z    = 0.0;// -13.788;


local CHARACTER_POS = [ -479.234, -689.805, -18.9356 ];

// 375.439, 727.43, -4.09301 // Little Italy Hollywood
// -143.0, 1206.0, 84.0 // Highbrook
//-568.042, -28.7317, 22.2512 //Arcade
// -1598.5,69.0,-13.0 // Garage
// -765.704, 258.311, -20.2636  // WestSide near river
// 809.629, 357.369, 29.316 // North Milville

local WEATHER = "DTFreeRideDaySnow";
    // DT03part02FreddysBar
    // DT15_interier
    // DT_RTRfoggy_day_early_morn1
    // DT_RTRclear_day_early_morn2
    // DT15_interier
    // DT01part01sicily_svit
    // DT_RTRclear_day_late_even

local switchModelID = 0;

local characters = [];
local translation = [];

local charDesc = array(2);
local charDescButton = array(2);

local charactersCount = 0;
local migrateOldCharacter = false;
local selectedCharacter = 0;

local otherPlayerLocked = true;



local kektimer;

local modelsData =
[
    [[71,72],[118,135]],//Euro
    [[43,42],[46,47]],//Niggas
    [[51,52],[56,57]] //Asia
]


local playerLocale;


function loadTranslation(){
    translation.clear();
    local text = {};
    if(playerLocale == "en"){
        //selection
        text.Info1                  <- "IMPORTANT: Name and lastname of character";
        text.Info2                  <- "must match the America of the 1950s!";
        text.Info3                  <- "Be original and creative!";
        text.SelectionWindow        <- "Selection of character";
        text.CharacterDesc          <- "First name: %s\nLast name: %s\nRace: %s\nSex: %s\nBirthday: %s\nMoney: $%.2f\nDeposit: $%.2f";
        text.SelectButtonDesc       <- "Select character";
        text.CreateButtonDesc       <- "Create character";
        text.EmptyCharacterSlot     <- "Empty slot\nTo go to the creation of\nPress Button";
        text.CharacterSwitchlabel   <- "Character";

        //creation
        text.CreationWindow         <- "Character creation";
        text.CreationChooseRace     <- "Choose a character race";
        text.CreationChooseSkin     <- "Choose skin";
        text.ChooseSkinX            <- 100.0;

        text.CreationFirstName      <- "Firstname";
        text.CreationLastName       <- "Lastname";
        text.CreationBirthday       <- "Birthday";
        text.WrongLName             <- "Wrong firstname";
        text.WrongFName             <- "Wrong lastname";
        text.WrongDay               <- "Day: from 1 to 30'";
        text.WrongMonth             <- "Month: from 1 to 12";
        text.WrongYear              <- "Year: from 1880 to 1927";
        text.ExampleFName           <- "Firstname";
        text.ExampleLName           <- "Lastname";

        //other
        text.Male       <- "Male";
        text.Female     <- "Female";
        text.Europide   <- "Europide";
        text.Negroid    <- "Negroid";
        text.Mongoloid  <- "Mongoloid";
        text.Day        <- "Day";
        text.Month      <- "Month";
        text.Year       <- "Year";
        text.Next       <- "Continue";
        translation.push( text );
    }
    else if(playerLocale == "ru")
    {
        //selection
        text.Info1                  <- "ВАЖНО: Имя и фамилия персонажа должны";
        text.Info2                  <- "соответствовать Америке 50-х годов 20 века!";
        text.Info3                  <- "Будьте оригинальными и креативными!";
        text.SelectionWindow        <- "Выбор персонажа";
        text.CharacterDesc          <- "Имя: %s\nФамилия: %s\nРаса: %s\nПол: %s\nДата рождения: %s\nДенежных средств: $%.2f\nСчёт в банке: $%.2f";
        text.SelectButtonDesc       <- "Выбрать персонажа";
        text.CreateButtonDesc       <- "Создать персонажа"
        text.EmptyCharacterSlot     <- "Пустой слот\nЧтобы перейти к созданию\nНажмите кнопку";
        text.CharacterSwitchlabel   <- "Персонаж";

        //creation
        text.CreationWindow         <- "Создание персонажа";
        text.CreationChooseRace     <- "Выберите расу персонажа";
        text.CreationChooseSkin     <- "Выберите скин";
        text.ChooseSkinX            <- 92.0;

        text.CreationFirstName      <- "Имя";
        text.CreationLastName       <- "Фамилия";
        text.CreationBirthday       <- "Дата рождения персонажа";
        text.WrongLName             <- "Некорректное имя";
        text.WrongFName             <- "Некорректная фамилия";
        text.WrongDay               <- "День введён некорректно";
        text.WrongMonth             <- "Месяц: от 1 до 12";
        text.WrongYear              <- "Год: от 1880 до 1927";
        text.ExampleFName           <- "Имя персонажа";
        text.ExampleLName           <- "Фамилия персонажа";

        //other
        text.Male       <- "Мужской";
        text.Female     <- "Женский";
        text.Europide   <- "Европеоидная";
        text.Negroid    <- "Негроидная";
        text.Mongoloid  <- "Монголоидная";
        text.Day        <- "День";
        text.Month      <- "Месяц";
        text.Year       <- "Год";
        text.Next       <- "Продолжить";
        translation.push( text );
    }
}

//function characterSelection(){
//    hideCharacterCreation();
//    isCharacterSelectionMenu = true;
//    togglePlayerControls( true );
//    window = guiCreateElement( ELEMENT_TYPE_WINDOW, translation[0].SelectionWindow, screen[0] - 300.0, screen[1]/2- 90.0, 190.0, 180.0 );
//    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, charDesc[0], 20.0, 20.0, 300.0, 100.0, false, window));//label[0]
//    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, charDescButton[0], 20, 125.0, 150.0, 20.0,false, window));//button[0]
//    //button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "<<", 20.0, 150.0, 30.0, 20.0,false, window));//button[2]
//    //label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CharacterSwitchlabel, 70.0, 148.0, 300.0, 20.0, false, window))
//    //button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, ">>", 140.0, 150.0, 30.0, 20.0,false, window));//button[3]
//    guiSetAlwaysOnTop(window,true);
//    guiSetSizable(window,false);
//    showCursor(true);
//}
//addEventHandler("characterSelection",characterSelection);


function formatCharacterSelection () {
    local idx = selectedCharacter;
    // setWeather(WEATHER);
    setPlayerPosition(getLocalPlayer(), CHARACTER_POS[0], CHARACTER_POS[1], CHARACTER_POS[2]);
    setPlayerRotation(getLocalPlayer(), 180.0,0.0,0.0);
    if(charactersCount == 0){
        return characterCreation();
    }
    else{
        if(characters[0].Firstname == ""){
            PData.Id <- characters[0].Id; // add data to push it later
            migrateOldCharacter = true;
            return characterCreation();
        }

        togglePlayerControls( true );
        otherPlayerLocked = false;
        triggerServerEvent("onPlayerCharacterSelect", characters[idx].Id.tostring());
        delayedFunction(500, function() {showCursor(false);});
    }
}


function characterCreation(){
    hideCharacterSelection();
    isCharacterCreationMenu = true;
    togglePlayerControls( true );
    // setWeather(WEATHER);
    setPlayerPosition(getLocalPlayer(), CHARACTER_POS[0], CHARACTER_POS[1], CHARACTER_POS[2]);
    setPlayerRotation(getLocalPlayer(), 180.0,0.0,180.0);
    window = guiCreateElement( ELEMENT_TYPE_WINDOW,  translation[0].CreationWindow, screen[0] - 400.0, screen[1]/2- 175.0, 260.0, 350.0 );


    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationFirstName 12.0,  80.0, 105.0, 20.0, false, window));//label[0]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].ExampleFName,     12.0, 100.0, 105.0, 20.0, false, window));//input[0]

    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationLastName, 122.0, 80.0, 125.0, 20.0, false, window));//label[1]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].ExampleLName,     122.0, 100.0, 125.0, 20.0, false, window));//input[1]


    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationBirthday, 12.0,   120.0, 256.0, 20.0, false, window));//label[2]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].Day,              12.0,   140.0, 74.0, 20.0, false, window));//input[2]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].Month,            92.0,   140.0, 75.0, 20.0, false, window));//input[3]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].Year,            173.0,   140.0, 74.0, 20.0, false, window));//input[4]


    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Male,    57, 170.0, 70.0, 22.0,false, window));//button[0]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Female, 133, 170.0, 70.0, 22.0,false, window));//button[1]

    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationChooseRace, 65.0, 195.0, 300.0, 20.0, false, window));//label[3]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Europide,           100.0, 215.0, 300.0, 20.0, false, window));//label[4]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Negroid,            100.0, 235.0, 300.0, 20.0, false, window));//label[5]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Mongoloid,          100.0, 255.0, 300.0, 20.0, false, window));//label[6]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          75.0, 220.0, 15.0, 15.0, false, window));//radio[0]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          75.0, 240.0, 15.0, 15.0, false, window));//radio[1]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          75.0, 260.0, 15.0, 15.0, false, window));//radio[2]







    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationChooseSkin, translation[0].ChooseSkinX, 285.0, 300.0, 20.0, false, window));//label[7]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "<<",                            57.0, 285.0, 30.0, 20.0,false, window));//button[2]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, ">>",                           173.0, 285.0, 30.0, 20.0,false, window));//button[3]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Next,             57.0, 310.0, 146.0, 30.0,false, window));//button[4]

    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Info1, 12.0, 20.0, 236.0, 20.0, false, window));//label[7]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Info2, 12.0, 35.0, 236.0, 20.0, false, window));//label[7]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Info3, 12.0, 57.0, 236.0, 20.0, false, window));//label[7]
    guiSetAlwaysOnTop(window,true);
    guiSetSizable(window,false);
    showCursor(true);
}
addEventHandler("characterCreation",characterCreation);

addEventHandler( "onGuiElementClick",function(element){
    if(isCharacterCreationMenu){
        if(element == button[0]){
            PData.Sex <- 0;
            return changeModel();
        }
        if(element == button[1]){
            PData.Sex <- 1;
            return changeModel();
        }
        if(element == radio[0]) {
            PData.Race <- 0;
            return changeModel();
        }
        if(element == radio[1]) {
            PData.Race <- 1;
            return changeModel();
        }
        if(element == radio[2]) {
            PData.Race <- 2;
            return changeModel();
        }
        if(element == button[2]) return switchModel();
        if(element == button[3]) return switchModel();
        if(element == input[0])  return guiSetText(input[0], "");
        if(element == input[1])  return guiSetText(input[1], "");
        if(element == input[2])  return guiSetText(input[2], "");
        if(element == input[3])  return guiSetText(input[3], "");
        if(element == input[4])  return guiSetText(input[4], "");
        if(element == button[4]) return checkFields();
    }


    if(isCharacterSelectionMenu)
    {
        if(element == button[0]){
            if(selectedCharacter in characters){
                return selectCharacter(selectedCharacter);
            }
            else{
                return characterCreation();
            }
        }
        //if(element == button[1] || element == button[2]){
        //    if(selectedCharacter == 0){
        //        selectedCharacter = 1;
        //    }
        //    else {
        //        selectedCharacter = 0;
        //    }
        //    return switchCharacterSlot();
        //}
    }
});

function switchCharacterSlot(){
    if(charactersCount == 0){
        return characterCreation();
    }
    local idx = selectedCharacter;
    if(idx in characters){
        if(characters[idx].Firstname == ""){
            PData.Id <- characters[idx].Id;
            migrateOldCharacter = true;
            return characterCreation();
        }
        local race = getRaceFromId(characters[idx].Race);
        local sex = getSexFromId(characters[idx].Sex);
        local fname = characters[idx].Firstname;
        local lname = characters[idx].Lastname;
        local bday = characters[idx].Bdate.tostring()
        local money = characters[idx].money.tofloat();
        local deposit = characters[idx].deposit.tofloat();
        charDesc[0] = format(translation[0].CharacterDesc,fname,lname,race,sex,bday,money,deposit);
        charDescButton[0] = translation[0].SelectButtonDesc;
        guiSetText(label[0], charDesc[0]);
        guiSetText(button[0], charDescButton[0]);
        triggerServerEvent("changeModel", characters[idx].cskin.tostring());
        setPlayerRotation(getLocalPlayer(), 180.0,0.0,0.0);
    }
    else {
        setPlayerRotation(getLocalPlayer(), 180.0,0.0,180.0);
        charDesc[0] = translation[0].EmptyCharacterSlot;
        charDescButton[0] = translation[0].CreateButtonDesc;
        guiSetText(label[0], charDesc[0]);
        guiSetText(button[0], charDescButton[0]);
    }
}

addEventHandler("onServerKeyboard", function(key, state) {
    if (key == "shift" && state == "down") {
        if(isCharacterCreationMenu || isCharacterSelectionMenu) {
            showCursor(false);
        }
    }
    if (key == "shift" && state == "up") {
        if(isCharacterCreationMenu || isCharacterSelectionMenu) {
            showCursor(true);
        }
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
    triggerServerEvent("changeModel", model.tostring());
    togglePlayerControls( true );
}

function checkFields () {
    fieldsErrors = 0;
    PData.Firstname <- guiGetText(input[0]);
    PData.Lastname <- guiGetText(input[1]);
    if(!isValidName(PData.Firstname)){
        guiSetText(label[0], translation[0].WrongLName);
        guiSetText(input[0], translation[0].ExampleFName);
        return fieldsErrors++;
    }
    else {guiSetText(label[0],translation[0].CreationFirstName);}

    if(!isValidName(PData.Lastname)){
        guiSetText(label[1], translation[0].WrongFName);
        guiSetText(input[1], translation[0].ExampleLName);
        return fieldsErrors++;
    }
    else {guiSetText(label[1],translation[0].CreationLastName);}

    if(!isValidRange(guiGetText(input[2]), 0,32)){
        guiSetText(label[2],translation[0].WrongDay);
        guiSetText(input[2],translation[0].Day);
        return fieldsErrors++;
    }
    else {guiSetText(label[2],translation[0].CreationBirthday);}

    if(!isValidRange(guiGetText(input[3]),0,13)){
        guiSetText(label[2],translation[0].WrongMonth);
        guiSetText(input[3],translation[0].Month);
        return fieldsErrors++;
    }
    else {guiSetText(label[2],translation[0].CreationBirthday);}

    if(!isValidRange(guiGetText(input[4]),1879,1928)){
        guiSetText(label[2],translation[0].WrongYear);
        guiSetText(input[4],translation[0].Year);
        return fieldsErrors++;
    }
    else {guiSetText(label[2],translation[0].CreationBirthday);}
    createCharacter();
}

function createCharacter() {
    local first = PData.Firstname;
    local last = PData.Lastname;
    local race = PData.Race;
    local sex = PData.Sex
    local bday = format("%02d.%02d.%04d",guiGetText(input[2]).tointeger(),guiGetText(input[3]).tointeger(),guiGetText(input[4]).tointeger());
    local model = modelsData[PData.Race][PData.Sex][switchModelID];
    triggerServerEvent("onPlayerCharacterCreate",first,last,race.tostring(),sex.tostring(),bday,model.tostring(),(migrateOldCharacter && "Id" in PData) ? PData.Id.tostring() : "0");
}

function selectCharacter (id) {
    hideCharacterSelection();
    triggerServerEvent("onPlayerCharacterSelect",characters[id].Id.tostring());
    delayedFunction(500, function() {showCursor(false);});
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
        otherPlayerLocked = false;
        //delayedFunction(500, function() { showCursor(true); showCursor(false); });
        delayedFunction(1000, function() { showCursor(false); });
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
            return translation[0].Europide;
        break;
        case 1:
            return translation[0].Negroid;
        break;
        case 2:
            return translation[0].Mongoloid;
        break;
    }
}

function getSexFromId (id) {
    switch (id) {
        case 0:
            return translation[0].Male;
        break;
        case 1:
            return translation[0].Female;
        break;
    }
}



addEventHandler("onClientFrameRender", function(a) {
    if (a) return;

    if (!isCharacterSelectionMenu && !isCharacterCreationMenu) return;

    local text   = "Hold left shift and move mouse to rotate camera.";
    local offset = dxGetTextDimensions(text, 2.0, "tahoma-bold")[1];
    dxDrawText(text, 25.0, screenY - offset - 25.0, 0xAAFFFFFF, false, "tahoma-bold", 2.0);

    if (migrateOldCharacter) {
        local text   = "You are migrating old character. All your property will be saved.";
        local offset = dxGetTextDimensions(text, 2.0, "tahoma-bold")[1];
        dxDrawText(text, 25.0, screenY - offset - 25.0 - offset - 4.0, 0xAAFFFFFF, false, "tahoma-bold", 2.0);
    }
});

function otherPlayerLock(){
    if (!otherPlayerLocked){
        if(kektimer.IsActive()){
            return kektimer.Kill();
        }
    }
    foreach (idx, value in getPlayers()) {
        if (idx == getLocalPlayer()) continue;
        setPlayerPosition(idx, DEFAULT_SPAWN_X, DEFAULT_SPAWN_Y, DEFAULT_SPAWN_Z);
    }
}

addEventHandler("onServerCharacterLoading", function(id,firstname, lastname, race, sex, birthdate, money, deposit, cskin){
    local char = {};
    char.Id <- id.tointeger();
    char.Firstname <- firstname;
    char.Lastname <- lastname;
    char.Race <- race.tointeger();
    char.Sex <- sex.tointeger();
    char.Bdate <- birthdate;
    char.money <- money.tofloat();
    char.deposit <- deposit.tofloat();
    char.cskin <- cskin.tointeger();
    characters.push( char );

    log("pushing character with name: " + firstname + " " + lastname);
});

addEventHandler("onServerCharacterLoaded", function(locale){
    playerLocale = locale;
    loadTranslation();
    charactersCount = characters.len();
    formatCharacterSelection();
    showChat(false);
    toggleHud(false);
});


addEventHandler("onClientScriptInit", function() {
    kektimer = timer(otherPlayerLock, 100, -1);
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}
