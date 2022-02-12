const ELEMENT_TYPE_BUTTON = 2;
// check for 2x widht bug
local screen =  getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];
local playerLocale;
local window;
local input = [];
local button = [];
local label = [];
local translation = [];

function loadTranslation(){
    translation.clear();
    local text = {};
    if(playerLocale == "en"){
        text.CreationFirstName      <- "Firstname";
        text.CreationLastName       <- "Lastname";
        text.ExampleFName           <- "Firstname";
        text.ExampleLName           <- "Lastname";
        text.Change                 <-  "Change";
        text.Generate               <- "Generate";
        text.NicknameChange         <- "Nickname change";
        text.Cancel <- "Cancel";
        translation.push( text );
    }
    else if(playerLocale == "ru")
    {
        text.CreationFirstName      <- "Имя персонажа";
        text.CreationLastName       <- "Фамилия персонажа";
        text.ExampleFName           <- "Введите имя персонажа";
        text.ExampleLName           <- "Введите фамилию персонажа";
        text.Generate               <- "Подобрать";
        text.Change                 <- "Изменить";
        text.NicknameChange         <- "Смена имени";
        text.Cancel                 <- "Отмена";
        translation.push( text );
    }
}


function nicknameChange(playerid, price){
    if(window){//if widow created
        guiSetSize(window, 200.0, 250.0  );
        guiSetPosition(window,screen[0] /2 - 140, screen[1]/2 - 90.0);
        guiSetVisible( window, true);
    } else {//if widow doesn't created, create his
        window = guiCreateElement( ELEMENT_TYPE_WINDOW,  translation[0].NicknameChange, screen[0] /2 - 140, screen[1]/2 - 90.0, 280.0, 180.0 );


        label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationFirstName, 25.0, 15.0, 166.0, 50.0, false, window));//label[0]
        input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].ExampleFName,     20.0, 50.0, 166.0, 20.0, false, window));//input[0]

        label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[0].CreationLastName, 25.0, 65.0, 166.0, 50.0, false, window));//label[1]
        input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[0].ExampleLName,     20.0, 100.0, 166.0, 20.0, false, window));//input[1]

        button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Generate, 193.0, 50.0, 64.0, 20.0,false, window));//button[0]
        button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Generate, 193.0, 100.0, 64.0, 20.0,false, window));//button[1]
        button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Change + format(" (%s$)", price.tostring()), 20.0, 145.0, 115.0, 20.0,false, window));//button[2]
        button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[0].Cancel, 140.0, 145.0, 115.0, 20.0,false, window));//button[3]
    }
    guiSetAlwaysOnTop(window,true);
    guiSetSizable(window,false);
    showCursor(true);
}
addEventHandler("nicknameChange", nicknameChange);


addEventHandler( "onGuiElementClick",
    function(element)
    {
        if(element == button[0]){
            triggerServerEvent("generateNickname", "first");
        }
        if(element == button[1]){
            triggerServerEvent("generateNickname", "last");
        }
        if(element == button[2]){
            local name = guiGetText(input[0]);
            local lastname = guiGetText(input[1]);
            local valid = (isValidName(name) && isValidLastName(lastname));
                triggerServerEvent("changeNickname", name, lastname, valid);
            hideNicknameGUI();
        }
        if(element == button[3]){
            hideNicknameGUI();
        }
    });


function hideNicknameGUI () {
    guiSetVisible(window,false);
    delayedFunction(200, hideCursor); //todo fix
}

function hideCursor() {
    showCursor(false);
}

addEventHandler("onServerCharacterLoaded", function(locale){
    playerLocale = locale;
    loadTranslation();
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}

addEventHandler("onChangeRandomFirstname", function(value){
    guiSetText(input[0], value);
});
addEventHandler("onChangeRandomLastname", function(value){
    guiSetText(input[1], value);
});


function isValidName(name){
    local check = regexp("^[A-Z][a-z]*$");
    return check.match(name);
}
function isValidLastName(name){
    local check = regexp("^((O\'|Mc)?[A-Z][a-z]{1,16})$");
    return check.match(name);
}
