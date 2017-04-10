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
local label = array(4);
local button = array(2);
local image;
local isAuth = null;

local blackRoundFrame;
local langs = array(2);

// stuff needed for hiding players
local otherPlayerLocked = true;
const DEFAULT_SPAWN_X    = -1027.02;
const DEFAULT_SPAWN_Y    =  1746.63;
const DEFAULT_SPAWN_Z    =  10.2325;

function showAuthGUI(windowLabel,labelText,inputText,buttonText){
    //setPlayerPosition( getLocalPlayer(), -412.0, 1371.0, 36.0 );
    //setPlayerPosition( getLocalPlayer(), -746.0, 1278.0, 15.5 );
    blackRoundFrame = guiCreateElement(13,"other_mask.png", 0, 0, screen[0], screen[1]);
    image = guiCreateElement(13,"logo.png", screen[0]/2 - 148.0, screen[1]/2 - 220.0, 296.0, 102.0);
    window = guiCreateElement( ELEMENT_TYPE_WINDOW, windowLabel, screen[0]/2 - 192.5, screen[1]/2 - 65.2, 385.0, 150.0 );
    label[0] = guiCreateElement( ELEMENT_TYPE_LABEL, labelText, 58.0, 30.0, 300.0, 20.0, false, window);
    input[0] = guiCreateElement( ELEMENT_TYPE_EDIT, inputText, 92.0, 60.0, 200.0, 20.0, false, window);
    button[0] = guiCreateElement( ELEMENT_TYPE_BUTTON, buttonText, 92.0, 90.0, 200.0, 20.0,false, window);
    langs[0] = guiCreateElement(13, "lang_en.png", screen[0]/2 - 16.0 - 20.0, screen[1]/2 + (135.0 / 2) - 14.0, 32.0, 18.0, false);
    langs[1] = guiCreateElement(13, "lang_ru.png", screen[0]/2 - 16.0 + 20.0, screen[1]/2 + (135.0 / 2) - 14.0, 32.0, 18.0, false);
    guiSetAlwaysOnTop(langs[0], true);
    guiSetAlwaysOnTop(langs[1], true);
    guiSetMovable(window,false);
    guiSetSizable(window,false);
    showCursor(true);    // guiSetAlpha(window, 0.1);
    isAuth = true;
}
addEventHandler("showAuthGUI", showAuthGUI);

function showRegGUI(windowText,labelText, inputpText, inputrpText, inputEmailText, buttonText){
    blackRoundFrame = guiCreateElement(13,"someweirdshit.png", 0, 0, screen[0], screen[1]);
    image = guiCreateElement(13,"logo.png", screen[0]/2 - 148.0, screen[1]/2 - 220.0, 296.0, 102.0);
    window = guiCreateElement( ELEMENT_TYPE_WINDOW, windowText, screen[0]/2 - 222.5, screen[1]/2 - 100.0, 445.0, 210.0 );
    label[0] = guiCreateElement( ELEMENT_TYPE_LABEL, labelText, 85.0, 30.0, 300.0, 20.0, false, window);
    label[1] = guiCreateElement( ELEMENT_TYPE_LABEL, inputpText, 90.0, 60.0, 300.0, 20.0, false, window);
    label[2] = guiCreateElement( ELEMENT_TYPE_LABEL, inputrpText, 90.0, 90.0, 300.0, 20.0, false, window);
    label[3] = guiCreateElement( ELEMENT_TYPE_LABEL, inputEmailText, 90.0, 120.0, 300.0, 20.0, false, window);
    input[0] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 200.0, 60.0, 150.0, 20.0, false, window);
    input[1] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 200.0, 90.0, 150.0, 20.0, false, window);
    input[2] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 150.0, 120.0, 200.0, 20.0, false, window);
    button[1] = guiCreateElement( 2, buttonText ,  150.0, 150.0, 150.0, 20.0, false, window);
    langs[0] = guiCreateElement(13, "lang_en.png", screen[0]/2 - 16.0 - 20.0, screen[1]/2 + (200.0 / 2) - 20.0, 32.0, 18.0);
    langs[1] = guiCreateElement(13, "lang_ru.png", screen[0]/2 - 16.0 + 20.0, screen[1]/2 + (200.0 / 2) - 20.0, 32.0, 18.0);
    guiSetAlwaysOnTop(langs[0], true);
    guiSetAlwaysOnTop(langs[1], true);
    guiSetInputMasked( input[0], true );
    guiSetInputMasked( input[1], true );
    guiSetMovable(window,false);
    guiSetSizable(window,false);
    input.map(guiBringToFront);
    showCursor(true);
    // guiSetAlpha(window, 0.1);
    isAuth = false;
}
addEventHandler("showRegGUI", showRegGUI);

function destroyAuthGUI(){
    if(window){
        guiSetVisible(window,false);
        guiSetVisible(image,false);
        guiSetVisible(blackRoundFrame,false);
        guiSetVisible(langs[0],false);
        guiSetVisible(langs[1],false);

        //guiDestroyElement(window);
        //guiDestroyElement(image);

        delayedFunction(500, function() {
            showCursor(false);
        })
        blackRoundFrame = null;
        image = null;
        window = null;
    }
}
addEventHandler("destroyAuthGUI", destroyAuthGUI);

addEventHandler("changeAuthLanguage", function(lwindow, llabel, linput, lbutton, rwindow, rlabel, rinputp, rinputrp, riptemail, rbutton) {
    if (isAuth) {
        guiSetText(window, lwindow);
        guiSetText(label[0], llabel);
        guiSetText(input[0], linput);
        guiSetText(button[0], lbutton);
    } else {
        guiSetText(window, rwindow);
        guiSetText(label[0], rlabel);
        guiSetText(label[1], rinputp);
        guiSetText(label[2], rinputrp);
        guiSetText(label[3], riptemail);
        guiSetText(button[1], rbutton);
    }
});

addEventHandler( "onGuiElementClick",function(element){ //this shit need some refactor
    if(element == button[0]){
        if(isAuth) {
           buttonLoginClick();
        }
    }
    if(element == button[1]){
       buttonRegisterClick();
    }
    if(element == input[0]){
        if(isAuth) {
            guiSetText(input[0], "");
            guiSetInputMasked(input[0], true );
        }
    }
    if(element == input[2]){
        guiSetText(input[2], "");
    }

    if (element == langs[0]) {
        triggerServerEvent("onPlayerLanguageChange", "en");
    }
    if (element == langs[1]) {
        triggerServerEvent("onPlayerLanguageChange", "ru");
    }
});

/**
 * Trigger button login click
 */
function buttonLoginClick() {
    local password = guiGetText(input[0]);
    if(password.len() > 0){
        triggerServerEvent("loginGUIFunction", password);
    }
    else{
        guiSetInputMasked( input[0], false);
        guiSetText(input[0], "Пароль");
    }
}

/**
 * Trigger button register click
 */
function buttonRegisterClick() {
     if(guiGetText(input[0]) == guiGetText(input[1])){
        if(guiGetText(input[2]).len() > 0){
            if(isValidEmail(guiGetText(input[2]))){
                guiSetText(input[2], "Введён некорректный email");
            }
            else {
                local password = guiGetText(input[0]);
                local email = guiGetText(input[2]);
                triggerServerEvent("registerGUIFunction", password, email.tolower());
            }
        }
        else {
            guiSetText(label[0], "Введите ваш email адресс!");
        }
    }
}

function isValidEmail(email)
{
    local check = regexp("^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$"); //Email Validation Regex
    return check.match(email);
}

function setPlayerIntroScreen () {
    setPlayerRotation(getLocalPlayer(), 0.0, 0.0, 180.0);
}
addEventHandler("setPlayerIntroScreen",setPlayerIntroScreen);

function resetPlayerIntroScreen () {
    isAuth = null;
    showChat(true);
    delayedFunction(500, function() {
        showChat(true);
    });
}
addEventHandler("resetPlayerIntroScreen",resetPlayerIntroScreen);

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}

addEventHandler("authErrorMessage", function (errorText) {
    guiSetText(label[0], errorText);
});

addEventHandler("onClientScriptInit", function() {
    showChat(false);
});

/**
 * Handling enter key for
 * passing registraion or login
 */
addEventHandler("onServerPressEnter", function() {
    if (isAuth != null) {
        if (isAuth) {
            buttonLoginClick();
        } else {
            buttonRegisterClick();
        }
    }
});
