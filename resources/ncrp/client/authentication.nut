const ELEMENT_TYPE_BUTTON = 2;
local screen = getScreenSize();
local window;
local input = array(3);
local label = array(4);
local button = array(2);
local image;
local isAuth;

function showAuthGUI(){
	image = guiCreateElement(13,"logo.png", screen[0]/2 - 148.0, screen[1]/2 - 220.0, 296.0, 102.0);
	window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Авторизация", screen[0]/2 - 192.5, screen[1]/2 - 65.2, 385.0, 135.0 );
	label[0] = guiCreateElement( ELEMENT_TYPE_LABEL, "Аккаунт уже зарегистрирован. Введите ваш пароль:", 58.0, 30.0, 300.0, 20.0, false, window);
	input[0] = guiCreateElement( ELEMENT_TYPE_EDIT, "Пароль", 92.0, 60.0, 200.0, 20.0, false, window);
	button[0] = guiCreateElement( ELEMENT_TYPE_BUTTON, "Авторизоваться", 92.0, 90.0, 200.0, 20.0,false, window);
	guiSetMovable(window,false);
	guiSetSizable(window,false);
	showCursor(true);
	isAuth = true;
}
addEventHandler("showAuthGUI", showAuthGUI);

function showRegGUI(){
	image = guiCreateElement(13,"logo.png", screen[0]/2 - 148.0, screen[1]/2 - 220.0, 296.0, 102.0);
	window = guiCreateElement( ELEMENT_TYPE_WINDOW, "Регистрация", screen[0]/2 - 222.5, screen[1]/2 - 100.0, 455.0, 200.0 );
	label[0] = guiCreateElement( ELEMENT_TYPE_LABEL, "Регистрация нового аккаунта. Заполните поля ниже:", 85.0, 30.0, 300.0, 20.0, false, window);
	label[1] = guiCreateElement( ELEMENT_TYPE_LABEL, "Придумайте пароль: ", 90.0, 60.0, 300.0, 20.0, false, window);
	label[2] = guiCreateElement( ELEMENT_TYPE_LABEL, "Повторите пароль:", 90.0, 90.0, 300.0, 20.0, false, window);
	label[3] = guiCreateElement( ELEMENT_TYPE_LABEL, "Email:", 90.0, 120.0, 300.0, 20.0, false, window);
	input[0] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 200.0, 60.0, 150.0, 20.0, false, window);
	input[1] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 200.0, 90.0, 150.0, 20.0, false, window);
	input[2] = guiCreateElement( ELEMENT_TYPE_EDIT, "", 150.0, 120.0, 200.0, 20.0, false, window);
	button[1] = guiCreateElement( 2, "Зарегистрироваться" ,  150.0, 150.0, 150.0, 20.0, false, window);
	guiSetInputMasked( input[0], true );
	guiSetInputMasked( input[1], true );
	guiSetMovable(window,false);
	guiSetSizable(window,false);
	showCursor(true);
	isAuth = false;
}
addEventHandler("showRegGUI", showRegGUI);

function destroyAuthGUI(){
	if(window){
		guiSetVisible(window,false);
		guiSetVisible(image,false);
		showCursor(false);
		guiDestroyElement(window);
		guiDestroyElement(image);
	}
}
addEventHandler("destroyAuthGUI", destroyAuthGUI);

addEventHandler( "onGuiElementClick",function(element){ //this shit need some refactor
		if(element == button[0]){
			if(isAuth){
				local password = guiGetText(input[0]);
				if(password.len() > 0){
					triggerServerEvent("loginGUIFunction", password);
				}
				else{
					guiSetInputMasked( input[0], false);
					guiSetText(input[0], "Пароль");
				}
			}
		}
		if(element == button[1]){
			if(guiGetText(input[0]) == guiGetText(input[1])){
				if(isValidEmail(guiGetText(input[2]))){
					guiSetText(input[2], "Введён не корректный email");
				}
				else {
					local password = guiGetText(input[0]);
					local email = guiGetText(input[2]);
					triggerServerEvent("registerGUIFunction", password, email);
				}
			}
		}
		if(element == input[0]){
			if(isAuth){
				guiSetText(input[0], "");
				guiSetInputMasked(input[0], true );
			}
		}
		if(element == input[2]){
			guiSetText(input[2], "");
		}
	});

function isValidEmail(email)
{
    local check = regexp("^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$"); //Email Validation Regex
    return check.match(email);
}

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}
