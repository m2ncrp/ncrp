const ELEMENT_TYPE_BUTTON = 2;
// check for 2x widht bug
local screen =  getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];
local userLocale = "ru";
local window;
local input = [];
local button = [];
local label = [];
local y = 0;
local translation =
{
    "en": {
        "nicknameChange":    "Nickname change",
        "nationality":       "Nationality: %s",
        "hint":              "You can't change nationality.\r\nChoose names according to nationality.",
        "creationFirstName": "New firstname",
        "creationLastName":  "New lastname",
        "exampleFName":      "Enter new firstname",
        "exampleLName":      "Enter new lastname",
        "change":            "Change ($%s)",
        "generate":          "Generate",
        "cancel":            "Cancel",
    },
    "ru": {
        "nicknameChange":    "Смена имени",
        "nationality":       "Национальность: %s",
        "hint":              "Поменять национальность нельзя.\r\nВыбирайте имя и фамилию под национальность.",
        "creationFirstName": "Новое имя персонажа",
        "creationLastName":  "Новая фамилия персонажа",
        "exampleFName":      "Введите новое имя",
        "exampleLName":      "Введите новую фамилию",
        "change":            "Изменить ($%s)",
        "generate":          "Подобрать",
        "cancel":            "Отмена",
    }
};


function nicknameChange(playerid, price, locale, nationality) {
    userLocale = locale;
    if(window){//if widow created
        guiSetSize(window, 280.0, 240.0);
        guiSetPosition(window,screen[0] /2 - 140, screen[1]/2 - 90.0);
        guiSetText(label[1], translation[locale].hint);
        guiSetVisible( window, true);
    } else {//if widow doesn't created, create his
        window = guiCreateElement( ELEMENT_TYPE_WINDOW,  translation[userLocale].nicknameChange, screen[0] /2 - 140, screen[1]/2 - 90.0, 280.0, 240.0 );

        y += 25.0;
        label.push(guiCreateElement( ELEMENT_TYPE_LABEL, format(translation[userLocale].nationality, nationality), 22.0, y, 250.0, 20.0, false, window));//label[0]

        y += 18.0;
        label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[userLocale].hint, 22.0, y, 250.0, 45.0, false, window));//label[0]


        y += 43.0;
        label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[userLocale].creationFirstName, 22.0, y, 166.0, 20.0, false, window));//label[1]

        y += 22.0;
        input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[userLocale].exampleFName,      20.0, y, 166.0, 20.0, false, window));//input[0]
        button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[userLocale].generate,       191.0, y, 64.0, 20.0, false, window));//button[0]

        y += 28.0;
        label.push(guiCreateElement( ELEMENT_TYPE_LABEL, translation[userLocale].creationLastName, 22.0, y, 166.0, 20.0, false, window));//label[2]

        y += 22.0;
        input.push(guiCreateElement( ELEMENT_TYPE_EDIT,  translation[userLocale].exampleLName,     20.0, y, 166.0, 20.0, false, window));//input[1]
        button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[userLocale].generate,      191.0, y, 64.0, 20.0, false, window));//button[1]

        y += 35.0;
        button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, format(translation[userLocale].change, price.tostring()), 20.0, y, 115.0, 30.0, false, window));//button[2]
        button.push(guiCreateElement( ELEMENT_TYPE_BUTTON, translation[userLocale].cancel, 140.0, y, 115.0, 30.0, false, window));//button[3]
    }
    guiSetAlwaysOnTop(window,true);
    guiSetSizable(window,false);
    showCursor(true);
}
addEventHandler("nicknameChange", nicknameChange);


addEventHandler( "onGuiElementClick", function(element) {
    if(element == input[0]) {
        if(guiGetText(input[0]) == translation[userLocale].exampleFName) {
            guiSetText(input[0], "");
        }
    }

    if(element == input[1]) {
        if(guiGetText(input[1]) == translation[userLocale].exampleLName) {
            guiSetText(input[1], "");
        }
    }

    if(element == button[0]) {
        triggerServerEvent("onGenerateNickname", "first");
    }

    if(element == button[1]) {
        triggerServerEvent("onGenerateNickname", "last");
    }

    if(element == button[2]) {
        local name = guiGetText(input[0]);
        local lastname = guiGetText(input[1]);
        local valid = (isValidName(name) && isValidLastName(lastname));
        triggerServerEvent("onChangeNickname", name, lastname, valid);
        // hideNicknameGUI();
    }

    if(element == button[3]) {
        hideNicknameGUI();
    }
});


function hideNicknameGUI () {
    guiSetVisible(window, false);
    guiSetText(label[1], "");
    delayedFunction(200, hideCursor); //todo fix
}

function hideCursor() {
    showCursor(false);
}

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
    local check = regexp("[A-Z][a-z]{1,16}");
    return check.match(name);
}
function isValidLastName(name){
    local check = regexp("[A-Z][a-z]{1,16}");
    return check.match(name);
}
