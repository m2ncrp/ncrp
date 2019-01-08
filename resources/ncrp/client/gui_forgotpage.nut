const ELEMENT_TYPE_BUTTON = 2;
const ELEMENT_TYPE_IMAGE  = 13;
// check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];

local window;
local input = array(3);
local label = array(6);
local button = array(6);
local locale;

local emailInput = null

local blackRoundFrame;
local decor = array(2);
local shadow = array(2);

local searchCount = 0;

local tr = {
    "en" : {
        "rememberEmail": "I remember email"
        "forgotEmail": "I forgot email"
        "invalidEmail" : "Invalid email"
        "enterEmail": "Enter your email here:"
        "search": "Search"
        "detectTitle" : "Or try to detect:"
        "detect" : "Detect"

        "requestTooMuch" : "Too much requests"
        "tip": "If you remember password, go back and try to auth.\r\nOr you can change password here:"
        "newpass": "New password"
        "repeatpass": "Repeat password"
        "setPass": "Confirm"
        "enterPassword" : "Enter password"
        "notEqualPasswords" : "Passwords are not equal"

        "passwordChanged" : "Password is successfully changed"
        "passwordChangedFail" : "Changing password failed"

        "goBack": "Back"
    },
    "ru": {
        "rememberEmail": "Я помню email"
        "forgotEmail": "Я забыл email"
        "invalidEmail" : "Некорректный email"
        "enterEmail": "Введите свой email:"
        "search": "Поиск"
        "detectTitle" : "Или попробуйте определить:"
        "detect" : "Определить"

        "requestTooMuch" : "Превышено число попыток"
        "tip": "Если помните пароль, вернитесь назад и войдите.\r\nИли же установите новый пароль:"
        "newpass": "Новый пароль"
        "repeatpass": "Повторите пароль"
        "setPass": "Подтвердить"
        "enterPassword" : "Введите пароль"
        "notEqualPasswords" : "Пароли не совпадают"

        "passwordChanged" : "Пароль изменён успешно"
        "passwordChangedFail" : "Не удалось изменить пароль"

        "goBack": "Назад"
    }
}

function random(min = 0, max = RAND_MAX) {
    return (rand() % ((max + 1) - min)) + min;
}

function showForgotGUI(userLocale, windowText){
    locale = userLocale;
    searchCount = 0;

    blackRoundFrame = guiCreateElement(13,"other_mask.png", 0, 0, screen[0], screen[1]);

    local width = 400.0;
    local height = 335.0;
    local yOffset = -65.0;
    window = guiCreateElement( ELEMENT_TYPE_WINDOW, windowText, screen[0]/2 - width/2, screen[1]/2 - height/2, width, height );

    decor[0] = guiCreateElement(13, "dot.jpg", screen[0]/2, screen[1]/2 - height/2 + 18.0, 1.0, 100.0, false);
    shadow[0] = guiCreateElement(13, "shadow.jpg", screen[0]/2 + 1, screen[1]/2 - height/2 + 18.0, 1.0, 100.0, false);

    decor[1] = guiCreateElement(13, "dot.jpg", screen[0]/2 - width/2, screen[1]/2 + height/2 - 50.0, width, 1.0, false);
    shadow[1] = guiCreateElement(13, "shadow.jpg", screen[0]/2 - width/2, screen[1]/2 + height/2 - 51.0, width, 1.0, false);

    guiSetAlpha(decor[0], 0.5);
    guiSetAlpha(decor[1], 0.5);

    label[0] = guiCreateElement( ELEMENT_TYPE_LABEL, tr[locale].enterEmail, width/2 - width/4 - 75.0, 25.0, 150.0, 20.0, false, window);
    emailInput = guiCreateElement( ELEMENT_TYPE_EDIT, "",  width/2 - width/4 - 75.0, 50.0, 150.0, 20.0, false, window);
    button[0] = guiCreateElement( 2, tr[locale].search ,  width/2 - width/4 - 75.0, 75.0, 150.0, 30.0, false, window);

    label[1] = guiCreateElement( ELEMENT_TYPE_LABEL, tr[locale].detectTitle, width/2 + width/4 - 75.0, 25.0, 150.0, 20.0, false, window);
    button[1] = guiCreateElement( 2, tr[locale].detect ,  width/2 + width/4 - 75.0, 50.0, 150.0, 30.0, false, window);


    label[2] = guiCreateElement( ELEMENT_TYPE_LABEL, "",  width/2 - 50.0, 125.0, 150.0, 20.0, false, window);
    label[3] = guiCreateElement( ELEMENT_TYPE_LABEL, tr[locale].tip, width/2 - 130.0, 150.0, 260.0, 30.0, false, window);
    label[4] = guiCreateElement( ELEMENT_TYPE_LABEL, tr[locale].newpass, 70.0, 190.0, 300.0, 20.0, false, window);
    label[5] = guiCreateElement( ELEMENT_TYPE_LABEL, tr[locale].repeatpass, 70.0, 215.0, 300.0, 20.0, false, window);
    input[0] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 180.0, 190.0, 150.0, 20.0, false, window);
    input[1] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 180.0, 215.0, 150.0, 20.0, false, window);
    button[2] = guiCreateElement( 2, tr[locale].setPass,  width/2 - 75.0, 245.0, 150.0, 30.0, false, window);

    button[3] = guiCreateElement( 2, tr[locale].goBack,  width/2 - 75.0, height - 40.0, 150.0, 30.0, false, window);

    guiSetVisible(label[3], false);
    guiSetVisible(label[4], false);
    guiSetVisible(label[5], false);
    guiSetVisible(input[0], false);
    guiSetVisible(input[1], false);
    guiSetVisible(button[2], false);

    guiSetInputMasked( input[0], true );
    guiSetInputMasked( input[1], true );

    guiSetAlwaysOnTop(decor[0], true);
    guiSetAlwaysOnTop(decor[1], true);
    guiSetAlwaysOnTop(shadow[0], true);
    guiSetAlwaysOnTop(shadow[1], true);

    guiSetMovable(window,false);
    guiSetSizable(window,false);
    //input.map(guiBringToFront);
    delayedFunction(1000, function() {
        showCursor(true);
    })
    showCursor(true);
}

addEventHandler("showForgotGUI", showForgotGUI);

function destroyForgotGUI(){
    if(window){
        //guiSetVisible(window,false);
        //guiSetVisible(blackRoundFrame,false);


        // button.map(guiDestroyElement);
        // input.map(guiDestroyElement);
        // label.map(guiDestroyElement);

        guiDestroyElement(window);
        guiDestroyElement(blackRoundFrame);
        guiDestroyElement(emailInput);

        decor.map(guiDestroyElement);
        shadow.map(guiDestroyElement);

        blackRoundFrame = null;
        emailInput = null;
        window = null;
    }
}
addEventHandler("destroyForgotGUI", destroyForgotGUI);

function showFindLoginResult(result, text) {
    if(window){
        guiSetText(label[2], text);
        if(result) {
            guiSetVisible(label[3], true);
            guiSetVisible(label[4], true);
            guiSetVisible(label[5], true);
            guiSetVisible(input[0], true);
            guiSetVisible(input[1], true);
            guiSetVisible(button[2], true);
        } else {
            guiSetVisible(label[3], false);
            guiSetVisible(label[4], false);
            guiSetVisible(label[5], false);
            guiSetVisible(input[0], false);
            guiSetVisible(input[1], false);
            guiSetVisible(button[2], false);
        }
    }
}
addEventHandler("showFindLoginResult", showFindLoginResult);

function showFindEmailResult(result, text) {
    if(window){
        guiSetText(label[2], text);

        guiSetVisible(label[3], false);
        guiSetVisible(label[4], false);
        guiSetVisible(label[5], false);
        guiSetVisible(input[0], false);
        guiSetVisible(input[1], false);
        guiSetVisible(button[2], false);
    }
}
addEventHandler("showFindEmailResult", showFindEmailResult);

function onChangedPassword(result) {
    if(window){
        delayedFunction(50,  function() {
            guiSetText(input[1], "");
            guiSetText(input[0], "");
        });

        if(result) {
            callEvent("onAlert", "", tr[locale].passwordChanged);
        } else {
            callEvent("onAlert", "", tr[locale].passwordChangedFail);
        }
    }
}
addEventHandler("onChangedPassword", onChangedPassword);


addEventHandler( "onGuiElementClick",function(element) {

    // Search
    if(element == button[0]) {

        if(searchCount == 3) {
            destroyForgotGUI();
            triggerServerEvent("onPlayerKicked", tr[locale].requestTooMuch);
            callEvent("onAlert", "", tr[locale].requestTooMuch);
            return;
        }

        searchCount++;

        local email = guiGetText(emailInput);

        if(!isValidEmail(email)){
            return callEvent("onAlert", "", tr[locale].invalidEmail);
        }

        triggerServerEvent("onPlayerGetLoginByEmail", email)
    }

    // Detect
    if(element == button[1]) {

        if(searchCount == 3) {
            destroyForgotGUI();
            triggerServerEvent("onPlayerKicked", tr[locale].requestTooMuch);
            callEvent("onAlert", "", tr[locale].requestTooMuch);
            return;
        }

        searchCount++;

        triggerServerEvent("onPlayerGetEmailBySerial")
    }

    // Confirm
    if(element == button[2]) {

        local password = guiGetText(input[0]);
        local passwordRepeat = guiGetText(input[1]);

        if (password.len() == 0 && passwordRepeat.len() == 0) {
            callEvent("onAlert", "", tr[locale].enterPassword);
            return;
        }

        if (password != passwordRepeat) {
            callEvent("onAlert", "", tr[locale].notEqualPasswords);
            return;
        }

        triggerServerEvent("onPlayerChangePassword", guiGetText(emailInput), password);
    }

    // go back
    if(element == button[3]){
        triggerServerEvent("onPlayerHideForgotGUI");
    }

    if (element == blackRoundFrame) {
        guiSendToBack(blackRoundFrame);
    }

    if (element == blackRoundFrame) {
        guiBringToFront( window );
    }

});

function isValidEmail(email)
{
    local check = regexp(@"([a-zA-Z0-9\_\.\+\-]{4,})+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-]+$"); //Email Validation Regex
    return check.match(email);
}


function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}
