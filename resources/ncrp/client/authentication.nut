local screen = getSceenSize();
local guiMainWindow;
local guiInput;
local guiLabel;
local guiButton;


function initialization ()
{
	guiMainWindow = guiCreateElement( ELEMENT_TYPE_WINDOW, "Авторизация", screen[0]/2 - 300, screen[1]/2 - 75, 600.0, 150.0 );
	guiLabel = guiCreateElement( ELEMENT_TYPE_LABEL, "Аккаунт уже зарегестрирован, введите ваш пароль!", 160.0, 30.0, 300.0, 20.0, false, guiMainWindow);
	guiInput = guiCreateElement( ELEMENT_TYPE_EDIT, "", 200.0, 60.0, 200.0, 20.0, false, guiMainWindow);
	guiButton = guiCreateElement( ELEMENT_TYPE_BUTTON, "Авторизоваться", 200.0, 90.0, 200.0, 20.0,false, guiMainWindow);
	guiSetInputMasked( guiInput, true );
	guiSetMovable(guiMainWindow,false);
	guiSetSizable(guiMainWindow,false);
	guiSetVisibe(guiMainWindow, false);
}

addEventHandler( "onGuiElementClick",
	function(element)
	{
		if(element == guiButton)
		{
				//todo
		}
	});