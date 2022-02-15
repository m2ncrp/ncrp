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
PData.Nationality <- "american";
PData.Race <- 0;
PData.BDay <- 0;

local translations = {
    rotateCamera = "Hold left shift and move mouse to rotate camera.",
    newName = "You are migrating old character. All your property will be saved."
};

addEventHandler("onTranslateReturn", function (key, phrase) {
    translations[key] = phrase;
});

callEvent("onTranslate", "rotateCamera");
callEvent("onTranslate", "newName");

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

local season = "winter";
local year = "1940";
local modelIndex = 0;

local characters = [];
local translation = [];

local charDesc = array(2);
local charDescButton = array(2);

local charactersCount = 0;
local migrateOldCharacter = false;
local selectedCharacter = 0;

local otherPlayerLocked = true;



local kektimer;
/*
local modelsData =
[
    [[71,72],[118,135]],//Euro
    [[43,42],[46,47]],//Niggas
    [[51,52],[56,57]] //Asia
]
*/
local modelsData = {};
modelsData.summer <- [
    [[71,72],[118,150,152]],//Euro
    [[43,44],[47]],//Niggas
    [[51,52],[56,57]] //Asia
];
modelsData.winter <- [
    [[63,132],[120,121,122]],//Euro
    [[129,64],[70,139]],//Niggas
    [[55,65,66],[58,59]] //Asia
];

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
        text.CharacterDesc          <- "First name: %s\nLast name: %s\nNationality: %s\nRace: %s\nSex: %s\nBirthday: %s\nMoney: $%.2f\nDeposit: $%.2f";
        text.SelectButtonDesc       <- "Select character";
        text.CreateButtonDesc       <- "Create character";
        text.EmptyCharacterSlot     <- "Empty slot\nTo go to the creation of\nPress Button";
        text.CharacterSwitchlabel   <- "Character";

        //creation
        text.CreationWindow         <- "Character creation";
        text.CreationChooseNationality     <- "Choose a character nationality";
        text.CreationChooseGender     <- "Choose a character gender";
        text.CreationChooseSkin     <- "Choose skin";
        text.ChooseSkinX            <- 100.0;

        text.CreationFirstName      <- "Firstname";
        text.CreationLastName       <- "Lastname";
        text.CreationBirthday       <- "Birthday";
        text.CreationAge            <- "Age";
        text.WrongFName             <- "Wrong firstname";
        text.WrongLName             <- "Wrong lastname";
        text.WrongDay               <- "Day: from 1 to 30'";
        text.WrongMonth             <- "Month: from 1 to 12";
        text.WrongAge               <- "Age: from 18 to 70";
        text.ExampleFName           <- "Firstname";
        text.ExampleLName           <- "Lastname";

        //other
        text.Male       <- "Male";
        text.Female     <- "Female";
        text.Europide   <- "Europide";
        text.Negroid    <- "Negroid";
        text.Mongoloid  <- "Mongoloid";

        text.American   <- "American";
        text.British    <- "British";
        text.Chinese    <- "Chinese";
        text.French     <- "French";
        text.German     <- "German";
        text.Italian    <- "Italian";
        text.Irish      <- "Irish";
        text.Jewish     <- "Jewish";
        text.Mexican    <- "Mexican";

        text.Day        <- "Day";
        text.Month      <- "Month";
        text.Age        <- "Age";
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
        text.CharacterDesc          <- "Имя: %s\nФамилия: %s\nНациональность: %s\nРаса: %s\nПол: %s\nДата рождения: %s\nДенежных средств: $%.2f\nСчёт в банке: $%.2f";
        text.SelectButtonDesc       <- "Выбрать персонажа";
        text.CreateButtonDesc       <- "Создать персонажа"
        text.EmptyCharacterSlot     <- "Пустой слот\nЧтобы перейти к созданию\nНажмите кнопку";
        text.CharacterSwitchlabel   <- "Персонаж";

        //creation
        text.CreationWindow         <- "Создание персонажа";
        text.CreationChooseNationality     <- "Выберите национальность персонажа";
        text.CreationChooseGender     <- "Выберите пол персонажа";
        text.CreationChooseSkin     <- "Выберите скин";
        text.ChooseSkinX            <- 92.0;

        text.CreationFirstName      <- "Имя персонажа";
        text.CreationLastName       <- "Фамилия персонажа";
        text.CreationBirthday       <- "Дата рождения персонажа";
        text.CreationAge            <- "Возраст";
        text.WrongFName             <- "Имя должно начинаться с заглавной буквы.\r\nБез пробелов, цифр, кириллицы.";
        text.WrongLName             <- "Фамилия должна начинаться с заглавной буквы.\r\nБез пробелов, цифр, кириллицы.";
        text.WrongDay               <- "День: от 1 до 31";
        text.WrongMonth             <- "Месяц: от 1 до 12";
        text.WrongAge               <- "Возраст: от 18 до 70";
        text.ExampleFName           <- "Введите имя персонажа";
        text.ExampleLName           <- "Введите фамилию персонажа";

        //other
        text.Generate   <- "Подобрать";
        text.Male       <- "Мужской";
        text.Female     <- "Женский";

        text.Europide   <- "Европеоидная";
        text.Negroid    <- "Негроидная";
        text.Mongoloid  <- "Монголоидная";

        text.American   <- "Американцы";
        text.Afro       <- "Афроамериканцы";
        text.British    <- "Британцы";
        text.Chinese    <- "Китайцы";
        text.French     <- "Французы";
        text.German     <- "Немцы";
        text.Italian    <- "Итальянцы";
        text.Irish      <- "Ирландцы";
        text.Jewish     <- "Евреи";
        text.Mexican    <- "Мексиканцы";

        text.Day        <- "День";
        text.Month      <- "Месяц";
        text.Age        <- "Возраст";
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
    setPlayerPosition(getLocalPlayer(), CHARACTER_POS[0], CHARACTER_POS[1], CHARACTER_POS[2]);
    setPlayerRotation(getLocalPlayer(), 180.0,0.0,0.0);
    executeLua("game.game:GetActivePlayer():ShowModel(false)");
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
        executeLua("game.game:GetActivePlayer():ShowModel(true)");
        triggerServerEvent("onPlayerCharacterSelect", characters[idx].Id.tostring());
        delayedFunction(500, function() {showCursor(false);});
    }
}


function characterCreation(){
    hideCharacterSelection();
    isCharacterCreationMenu = true;
    togglePlayerControls( true );
    setPlayerPosition(getLocalPlayer(), CHARACTER_POS[0], CHARACTER_POS[1], CHARACTER_POS[2]);
    executeLua("game.game:GetActivePlayer():ShowModel(false)");
    //setPlayerRotation(getLocalPlayer(), 180.0,0.0,180.0);
    window = guiCreateElement( ELEMENT_TYPE_WINDOW,  translation[0].CreationWindow, screen[0] - 400.0, screen[1]/2- 175.0, 260.0, 410.0 );


    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationFirstName 12.0, 190.0, 166.0, 20.0, false, window));//label[0]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].ExampleFName,     12.0, 212.0, 166.0, 20.0, false, window));//input[0]

    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationLastName, 12.0, 239.0, 166.0, 20.0, false, window));//label[1]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].ExampleLName,     12.0, 261.0, 166.0, 20.0, false, window));//input[1]

    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationBirthday, 12.0, 288.0, 256.0, 20.0, false, window));//label[2]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationAge,     173.0, 288.0, 50.0, 20.0, false, window));//label[3]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].Day,              12.0, 310.0, 74.0, 20.0, false, window));//input[2]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].Month,            92.0, 310.0, 75.0, 20.0, false, window));//input[3]
    input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].Age,            173.0, 310.0, 74.0, 20.0, false, window));//input[4]

    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationChooseGender, 65.0, 20.0, 300.0, 20.0, false, window));//label[5]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Male,    57, 42.0, 70.0, 22.0,false, window));//button[0]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Female, 133, 42.0, 70.0, 22.0,false, window));//button[1]

    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationChooseNationality, 35.0, 68.0, 300.0, 20.0, false, window));//label[6]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].American,          44.0,   88.0, 300.0, 20.0, false, window));//label[7]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].British ,          45.0,  108.0, 300.0, 20.0, false, window));//label[8]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Italian ,          45.0,  128.0, 300.0, 20.0, false, window));//label[9]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Chinese ,          45.0,  148.0, 300.0, 20.0, false, window));//label[10]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].French  ,          45.0,  168.0, 300.0, 20.0, false, window));//label[11]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Afro    ,          154.0,  88.0, 300.0, 20.0, false, window));//label[12]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Irish   ,          155.0, 108.0, 300.0, 20.0, false, window));//label[13]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Jewish  ,          155.0, 128.0, 300.0, 20.0, false, window));//label[14]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].German  ,          155.0, 148.0, 300.0, 20.0, false, window));//label[15]
    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Mexican ,          155.0, 168.0, 300.0, 20.0, false, window));//label[16]

    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          25.0,   91.0, 15.0, 15.0, false, window));//radio[0]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          25.0,  111.0, 15.0, 15.0, false, window));//radio[1]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          25.0,  131.0, 15.0, 15.0, false, window));//radio[2]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          25.0,  151.0, 15.0, 15.0, false, window));//radio[3]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          25.0,  171.0, 15.0, 15.0, false, window));//radio[4]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          135.0,  91.0, 15.0, 15.0, false, window));//radio[5]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          135.0, 111.0, 15.0, 15.0, false, window));//radio[6]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          135.0, 131.0, 15.0, 15.0, false, window));//radio[7]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          135.0, 151.0, 15.0, 15.0, false, window));//radio[8]
    radio.push(guiCreateElement( ELEMENT_TYPE_RADIOBUTTON, "",                          135.0, 171.0, 15.0, 15.0, false, window));//radio[9]

    label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationChooseSkin, translation[0].ChooseSkinX, 340.0, 300.0, 20.0, false, window));//label[14]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, "<<",                            57.0, 340.0, 30.0, 20.0,false, window));//button[2]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, ">>",                           173.0, 340.0, 30.0, 20.0,false, window));//button[3]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Next,             57.0, 370.0, 146.0, 30.0,false, window));//button[4]

    // label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Info1, 12.0, 20.0, 236.0, 20.0, false, window));//label[7]
    // label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Info2, 12.0, 35.0, 236.0, 20.0, false, window));//label[7]
    // label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].Info3, 12.0, 57.0, 236.0, 20.0, false, window));//label[7]

    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Generate, 183.0, 212.0, 64.0, 20.0,false, window));//button[5]
    button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Generate, 183.0, 261.0, 64.0, 20.0,false, window));//button[6]

    guiSetAlwaysOnTop(window,true);
    guiSetSizable(window,false);
    showCursor(true);

}
addEventHandler("characterCreation",characterCreation);

addEventHandler( "onGuiElementClick",function(element){
    if(isCharacterCreationMenu){
        if(element == button[0]){
            PData.Sex <- 0;
            resetName();
            return changeModel();
        }
        if(element == button[1]){
            PData.Sex <- 1;
            resetName();
            return changeModel();
        }


        if(element == radio[0]) {
            PData.Race <- 0;
            PData.Nationality <- "american";
            return changeNationality();
        }
        if(element == radio[1]) {
            PData.Race <- 0;
            PData.Nationality <- "british";
            return changeNationality();
        }
        if(element == radio[2]) {
            PData.Race <- 0;
            PData.Nationality <- "italian";
            return changeNationality();
        }
        if(element == radio[3]) {
            PData.Race <- 2;
            PData.Nationality <- "chinese";
            return changeNationality();
        }
        if(element == radio[4]) {
            PData.Race <- 0;
            PData.Nationality <- "french";
            return changeNationality();
        }
        if(element == radio[5]) {
            PData.Race <- 1;
            PData.Nationality <- "afro";
            return changeNationality();
        }
        if(element == radio[6]) {
            PData.Race <- 0;
            PData.Nationality <- "irish";
            return changeNationality();
        }
        if(element == radio[7]) {
            PData.Race <- 0;
            PData.Nationality <- "jewish";
            return changeNationality();
        }
        if(element == radio[8]) {
            PData.Race <- 0;
            PData.Nationality <- "german";
            return changeNationality();
        }
        if(element == radio[9]) {
            PData.Race <- 0;
            PData.Nationality <- "mexican";
            return changeNationality();
        }

        if(element == button[2]) return modelDec();
        if(element == button[3]) return modelInc();
        if(element == input[0] && guiGetText(input[0]) == translation[0].ExampleFName) return guiSetText(input[0], "");
        if(element == input[1] && guiGetText(input[1]) == translation[0].ExampleLName)  return guiSetText(input[1], "");
        if(element == input[2] && guiGetText(input[2]) == translation[0].Day)  return guiSetText(input[2], "");
        if(element == input[3] && guiGetText(input[3]) == translation[0].Month)  return guiSetText(input[3], "");
        if(element == input[4] && guiGetText(input[4]) == translation[0].Age)  return guiSetText(input[4], "");
        if(element == button[4]) return checkFields();
        if(element == button[5]) return generateFirstname();
        if(element == button[6]) return generateLastname();
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
        local nationality = characters[idx].Nationality;
        local sex = getSexFromId(characters[idx].Sex);
        local fname = characters[idx].Firstname;
        local lname = characters[idx].Lastname;
        local bday = characters[idx].Bdate.tostring()
        local money = characters[idx].money.tofloat();
        local deposit = characters[idx].deposit.tofloat();
        charDesc[0] = format(translation[0].CharacterDesc,fname,lname,nationality,race,sex,bday,money,deposit);
        charDescButton[0] = translation[0].SelectButtonDesc;
        guiSetText(label[0], charDesc[0]);
        guiSetText(button[0], charDescButton[0]);
        triggerServerEvent("changeModel", characters[idx].cskin.tostring());
        //setPlayerRotation(getLocalPlayer(), 180.0,0.0,0.0);
    }
    else {
        //setPlayerRotation(getLocalPlayer(), 180.0,0.0,180.0);
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

addEventHandler("onChangeRandomFirstname", function(value){
    guiSetText(input[0], value);
});

addEventHandler("onChangeRandomLastname", function(value){
    guiSetText(input[1], value);
});

function generateFirstname() {
    triggerServerEvent("onGenerateFirstname", PData.Sex, PData.Nationality);
}

function generateLastname() {
    triggerServerEvent("onGenerateLastname", PData.Nationality);
}

function resetName() {
    guiSetText(input[0], "");
    guiSetText(input[1], "");
}

function changeNationality() {
    modelIndex = 0;
    resetName();
    changeModel();
}

function modelDec() {
    local len = modelsData[season][PData.Race][PData.Sex].len();
    if(modelIndex > 0) {
        modelIndex -= 1;
    } else {
        modelIndex = len - 1;
    }
    changeModel();
}

function modelInc() {
    local len = modelsData[season][PData.Race][PData.Sex].len();
    if(modelIndex < len-1) {
        modelIndex += 1;
    } else {
        modelIndex = 0;
    }
    changeModel();
}

function changeModel() {
    setPlayerRotation(getLocalPlayer(), 180.0,0.0,0.0);
    local model = modelsData[season][PData.Race][PData.Sex][modelIndex];
    triggerServerEvent("changeModel", model.tostring());
    togglePlayerControls( true );
}

function checkFields () {
    fieldsErrors = 0;
    PData.Firstname <- guiGetText(input[0]);
    PData.Lastname <- guiGetText(input[1]);
    if(!isValidName(PData.Firstname)){
        guiSetText(input[0], translation[0].ExampleFName);
        callEvent("onAlert", translation[0].ExampleFName, translation[0].WrongFName, 2);
        // guiSetText(label[0], translation[0].WrongFName);
        return fieldsErrors++;
    }
    else {guiSetText(label[0],translation[0].CreationFirstName);}

    if(!isValidLastName(PData.Lastname)){
        guiSetText(input[1], translation[0].ExampleLName);
        callEvent("onAlert", translation[0].ExampleLName, translation[0].WrongLName, 2);
        //guiSetText(label[1], translation[0].WrongFName);
        return fieldsErrors++;
    }
    else {guiSetText(label[1],translation[0].CreationLastName);}

    if(!isValidRange(guiGetText(input[2]), 0,32)){
        guiSetText(input[2],translation[0].Day);
        callEvent("onAlert", translation[0].Day, translation[0].WrongDay, 1);
        // guiSetText(label[2],translation[0].WrongDay);
        return fieldsErrors++;
    }
    else {guiSetText(label[2],translation[0].CreationBirthday);}

    if(!isValidRange(guiGetText(input[3]),0,13)){
        guiSetText(input[3],translation[0].Month);
        callEvent("onAlert", translation[0].Month, translation[0].WrongMonth, 1);
        // guiSetText(label[2],translation[0].WrongMonth);
        return fieldsErrors++;
    }
    else {guiSetText(label[2],translation[0].CreationBirthday);}

    if(!isValidRange(guiGetText(input[4]),18,70)) {
        guiSetText(input[4],translation[0].Age);
        callEvent("onAlert", translation[0].Age, translation[0].WrongAge, 1);
        //guiSetText(label[2],translation[0].WrongAge);
        return fieldsErrors++;
    }
    else {guiSetText(label[2],translation[0].CreationBirthday);}
    createCharacter();
}

function createCharacter() {
    local first = PData.Firstname;
    local last = PData.Lastname;
    local race = PData.Race;
    local nationality = PData.Nationality;
    local sex = PData.Sex;
    local bday = format("%02d.%02d.%04d",guiGetText(input[2]).tointeger(),guiGetText(input[3]).tointeger(), year - guiGetText(input[4]).tointeger());
    local model = modelsData[season][PData.Race][PData.Sex][modelIndex];
    triggerServerEvent("onPlayerCharacterCreate",first,last,nationality,race.tostring(),sex.tostring(),bday,model.tostring(),(migrateOldCharacter && "Id" in PData) ? PData.Id.tostring() : "0");
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

function isValidLastName(name){
    local check = regexp("^((O\'|Mc)?[A-Z][a-z]{1,16})$");
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

    local text   = translations.rotateCamera;
    local offset = dxGetTextDimensions(text, 2.0, "tahoma-bold")[1];
    dxDrawText(text, 25.0, screenY - offset - 25.0, 0xAAFFFFFF, false, "tahoma-bold", 2.0);

    if (migrateOldCharacter) {
        local text   = translations.newName;
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

addEventHandler("onServerCharacterLoading", function(id,firstname, lastname, nationality, race, sex, birthdate, money, deposit, cskin){
    local char = {};
    char.Id <- id.tointeger();
    char.Firstname <- firstname;
    char.Lastname <- lastname;
    char.Nationality <- nationality;
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

addEventHandler("onServerSeasonSet", function(name = "summer") {
    season = name;
});

addEventHandler("onServerYearSet", function(value) {
    year = value.tointeger();
});

addEventHandler("onClientScriptInit", function() {
    kektimer = timer(otherPlayerLock, 100, -1);
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}
