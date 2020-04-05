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
local label = array(5);
local button = array(2);
local image;
local question;

local isAuth = null;
local locale = "ru";

local blackRoundFrame;
local langs = array(2);

local logos = [
    {
        "imgsrc": "logo.png",
        "offsetX": 203.0,
        "offsetY": 145.0,
        "width": 406.0,
        "height": 266.0,
    },
    {
        "imgsrc": "logo-ny1.png",
        "offsetX": 217.0,
        "offsetY": 154.0,
        "width": 420.0,
        "height": 275.0,
    },
    {
        "imgsrc": "logo-ny2.png",
        "offsetX": 203.0,
        "offsetY": 277.0,
        "width": 406.0,
        "height": 398.0,
    },
    {
        "imgsrc": "logo-ny3.png",
        "offsetX": 203.0,
        "offsetY": 277.0,
        "width": 406.0,
        "height": 398.0,
    },
    {
        "imgsrc": "logo-ny4.png",
        "offsetX": 203.0,
        "offsetY": 261.0,
        "width": 406.0,
        "height": 382.0,
    }
];

function random(min = 0, max = RAND_MAX) {
    return (rand() % ((max + 1) - min)) + min;
}

//local logorand = random(1, logos.len()-1);
local logorand = 0;

//image = guiCreateElement(13, "logo.png", screen[0]/2 - 203.0, screen[1]/2 - 145.0, 406.0, 266.0);

function showAuthGUI(windowLabel, labelText, inputText, buttonText, helpText, forgotText){
    //setPlayerPosition( getLocalPlayer(), -412.0, 1371.0, 36.0 );
    //setPlayerPosition( getLocalPlayer(), -746.0, 1278.0, 15.5 );
    blackRoundFrame = guiCreateElement(13,"other_mask.png", 0, 0, screen[0], screen[1]);
    image = guiCreateElement(13, logos[logorand].imgsrc, screen[0]/2 - logos[logorand].offsetX, screen[1]/2 - logos[logorand].offsetY, logos[logorand].width, logos[logorand].height);
    local width = 385.0;
    local height = 225.0;
    window = guiCreateElement( ELEMENT_TYPE_WINDOW, windowLabel,  screen[0]/2 - 192.5, screen[1]/2 - 65.2, width, height );
    label[0] = guiCreateElement( ELEMENT_TYPE_LABEL, labelText, 38.0, 30.0, 300.0, 20.0, false, window);
    input[0] = guiCreateElement( ELEMENT_TYPE_EDIT, inputText, 92.0, 60.0, 200.0, 20.0, false, window);
    button[0] = guiCreateElement( ELEMENT_TYPE_BUTTON, buttonText, 92.0, 85.0, 200.0, 30.0, false, window);
        //langs[0] = guiCreateElement(13, "lang_ru.png", screen[0]/2 - 16.0 + 20.0, screen[1]/2 + (138.0 / 2) + 28.0, 32.0, 18.0, false);
        //langs[1] = guiCreateElement(13, "lang_en.png", screen[0]/2 - 16.0 - 20.0, screen[1]/2 + (138.0 / 2) + 28.0, 32.0, 18.0, false);
    button[1] = guiCreateElement( ELEMENT_TYPE_BUTTON, forgotText, 92.0, 120.0, 200.0, 30.0, false, window);
    label[1] = guiCreateElement( ELEMENT_TYPE_LABEL, helpText, 20.0, 188.0, 355.0, 20.0, false, window);
        //guiSetAlwaysOnTop(langs[0], true);
        //guiSetAlwaysOnTop(langs[1], true);
    guiSetMovable(window,false);
    guiSetSizable(window,false);
    showCursor(true);    // guiSetAlpha(window, 0.1);
    isAuth = true;
}
addEventHandler("showAuthGUI", showAuthGUI);


function showBadPlayerNicknameGUI(){
    blackRoundFrame = guiCreateElement(13,"other_mask.png", 0, 0, screen[0], screen[1]);
    local width = 385.0;
    local height = 260.0;
    window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Информация / Information", screen[0]/2 - width/2, screen[1]/2 - height/2, width, height );
    //window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Информация", screen[0]/2 - 192.5, screen[1]/2 - 72.0, 385.0, 144.0 );
    label[0] = guiCreateElement( ELEMENT_TYPE_LABEL, "[RU] Измените никнейм на свой\r\n\r\nДля этого:\r\n1. Нажмите на клавиатуре кнопку Escape (Esc)\r\n2. Выберите в меню пункт SETTINGS\r\n3. Введите в поле Nickname ваш никнейм (вместо Player)\r\n4. Переподключитесь к серверу\r\n", 38.0, 30.0, 300.0, 110.0, false, window);
    label[1] = guiCreateElement( ELEMENT_TYPE_LABEL, "[EN] Change nickname\r\n\r\nHow to do it:\r\n1. Press Escape (Esc) button on your keyboard\r\n2. Choose SETTINGS item in top menu\r\n3. Enter your nickname into Nickname field (instead of Player)\r\n4. Disconnect and connect to server again\r\n", 38.0, 140.0, 300.0, 110.0, false, window);
    guiSetMovable(window,false);
    guiSetSizable(window,false);
    showCursor(true);
    isAuth = false;
}
addEventHandler("showBadPlayerNicknameGUI", showBadPlayerNicknameGUI);

function showRegGUI(windowText,labelText, inputpText, inputrpText, inputEmailText, buttonText, helpText, forgotText){
    blackRoundFrame = guiCreateElement(13,"other_mask.png", 0, 0, screen[0], screen[1]);
    //image = guiCreateElement(13, "logo.png", screen[0]/2 - 203.0, screen[1]/2 - 145.0, 406.0, 266.0);
    local width = 385.0;
    local height = 280.0;
    image = guiCreateElement(13, logos[logorand].imgsrc, screen[0]/2 - logos[logorand].offsetX, screen[1]/2 - logos[logorand].offsetY, logos[logorand].width, logos[logorand].height);
    window = guiCreateElement( ELEMENT_TYPE_WINDOW, windowText, screen[0]/2 - 192.5, screen[1]/2 - 65.0, width, height );
    label[0] = guiCreateElement( ELEMENT_TYPE_LABEL, labelText, 80.0, 30.0, 300.0, 20.0, false, window);
    label[1] = guiCreateElement( ELEMENT_TYPE_LABEL, inputpText, 70.0, 60.0, 300.0, 20.0, false, window);
    label[2] = guiCreateElement( ELEMENT_TYPE_LABEL, inputrpText, 70.0, 90.0, 300.0, 20.0, false, window);
    label[3] = guiCreateElement( ELEMENT_TYPE_LABEL, inputEmailText, 70.0, 120.0, 300.0, 20.0, false, window);
    input[0] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 180.0, 60.0, 150.0, 20.0, false, window);
    input[1] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 180.0, 90.0, 150.0, 20.0, false, window);
    input[2] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 130.0, 120.0, 200.0, 20.0, false, window);
    button[0] = guiCreateElement( 2, buttonText, width/2 - 75.0, 150.0, 150.0, 30.0, false, window);
    button[1] = guiCreateElement( 2, forgotText, width/2 - 75.0, 185.0, 150.0, 30.0, false, window);

    //langs[0] = guiCreateElement(13, "lang_ru.png", width/2 - 35.0, 225.0, 32.0, 18.0, false, window);
    //langs[1] = guiCreateElement(13, "lang_en.png", width/2 + 3.0, 225.0, 32.0, 18.0, false, window);
    //guiSetAlwaysOnTop(langs[0], true);
    //guiSetAlwaysOnTop(langs[1], true);


    label[4] = guiCreateElement( ELEMENT_TYPE_LABEL, helpText, 20.0, 250.0, 355.0, 20.0, false, window);

    question = guiCreateElement(13, "question.png", 100.0, 122.0, 16.0, 16.0, false, window);
    guiSetAlwaysOnTop(question, true);

    guiSetInputMasked( input[0], true );
    guiSetInputMasked( input[1], true );
    guiSetMovable(window,false);
    guiSetSizable(window,false);
    input.map(guiBringToFront);
    showCursor(true);
    delayedFunction(500, function() {
        showCursor(true);
    })
    // guiSetAlpha(window, 0.1);
    isAuth = false;
}
addEventHandler("showRegGUI", showRegGUI);

function destroyAuthGUI(){
    if(window) {

        guiDestroyElement(window);
        guiDestroyElement(image);
        guiDestroyElement(blackRoundFrame);
        //guiDestroyElement(langs[0]);
        //guiDestroyElement(langs[1]);

        blackRoundFrame = null;
        image = null;
        question = null;
        window = null;
    }
}
addEventHandler("destroyAuthGUI", destroyAuthGUI);

addEventHandler("changeAuthLanguage", function(lwindow, llabel, linput, lbutton, rwindow, rlabel, rinputp, rinputrp, riptemail, rbutton, helpText, forgotText) {
    if (isAuth) {
        guiSetText(window, lwindow);
        guiSetText(label[0], llabel);
        guiSetText(input[0], linput);
        guiSetText(button[0], lbutton);
        guiSetText(button[1], forgotText);
        guiSetText(label[1], helpText);

    } else {
        guiSetText(window, rwindow);
        guiSetText(label[0], rlabel);
        guiSetText(label[1], rinputp);
        guiSetText(label[2], rinputrp);
        guiSetText(label[3], riptemail);
        guiSetText(button[0], rbutton);
        guiSetText(button[1], forgotText);
        guiSetText(label[4], helpText);
    }
});

addEventHandler( "onGuiElementClick",function(element){ //this shit need some refactor
    if(element == button[0]){
        if(isAuth) {
            buttonLoginClick();
        } else {
            buttonRegisterClick();
        }
    }

    if(element == button[1]){
        log("showForgotGUIServerEvent click");
        triggerServerEvent("onPlayerShowForgotGUI");
    }

    if(element == question) {
        callEvent("onAlert", "Email", (locale == "ru" ? "Мы просим Вас указать действительный email\r\n на случай, если вы забудете логин или пароль.\r\nЕсли вы укажите недействительный email -\r\nвы не сможете восстановить доступ к аккаунту." : "Please enter your correct email to have opportunity\r\nto restore access to your game account\r\nin the event of loss."), 2);
    }

    if(element == input[0]){
        if(isAuth) {
            guiSetText(input[0], "");
            guiSetInputMasked(input[0], true );
        }
    }

    // if (element == langs[0]) {
    //     locale = "ru";
    //     triggerServerEvent("onPlayerLanguageChange", "ru");
    // }
    // if (element == langs[1]) {
    //     locale = "en";
    //     triggerServerEvent("onPlayerLanguageChange", "en");
    // }
    if (element == blackRoundFrame) {
        guiSendToBack(blackRoundFrame);
    }
    if (element == image) {
        guiSendToBack(image);
        guiSendToBack(blackRoundFrame);
    }
    if (element == blackRoundFrame || element == image) {
        //guiBringToFront( image );
        guiBringToFront( window );
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
        callEvent("onAlert", "", (locale == "ru" ? "Введите пароль" : "Enter password"));
    }
}

/**
 * Trigger button register click
 */
function buttonRegisterClick() {
    local password = guiGetText(input[0]);
    local passwordRepeat = guiGetText(input[1]);

    if (password.len() == 0 && passwordRepeat.len() == 0) {
        callEvent("onAlert", "", (locale == "ru" ? "Введите пароль" : "Enter password"));
        return;
    }

    if (password != passwordRepeat) {
        callEvent("onAlert", "", (locale == "ru" ? "Пароли не совпадают" : "Passwords are not equal"));
        return;
    }

    local email = guiGetText(input[2]);

    if (email.len() == 0) {
        callEvent("onAlert", "Email", (locale == "ru" ? "Введите ваш email адрес" : "Enter your email"));
        return;
    }

    if (!isValidEmail(email)) {
        callEvent("onAlert", "Email", (locale == "ru" ? "Некорректный email" : "Invalid email"));
        return;
    }

    triggerServerEvent("registerGUIFunction", password, email.tolower());
}

function isValidEmail(email)
{
    local check = regexp(@"([a-zA-Z0-9\_\.\+\-]{4,})+@[a-zA-Z0-9\-]+\.[a-zA-Z0-9\-]+$"); //Email Validation Regex
    return check.match(email);
}


addEventHandler("setPlayerIntroScreen", function(x, y, z, weather) {
    executeLua("p = game.game:GetActivePlayer() cam = game.cameramanager:GetPlayerMainCamera(0) cam:SetCameraRotation(p:GetPos() + p:GetDir() + Math:newVector("+x+", "+y+", "+z+"))");
    //setPlayerRotation(getLocalPlayer(), 0.0, 0.0, 180.0);
    delayedFunction(2500, function() {
        setWeather(weather)
    });
});

addEventHandler("resetPlayerIntroScreen", function() {
    //executeLua("cam = game.cameramanager:GetPlayerMainCamera(0) cam:LockControl(false, false)");
    isAuth = null;
    showChat(true);
    delayedFunction(500, function() {
        showChat(true);
    });
});

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
