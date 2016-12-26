local screen = getScreenSize()
local img;
local audio;

function showScreemer()
{
	//img = guiCreteElement(13, "screamer.jpg"); //todo fix
	audio = Audio(true, true, "http://mafia2-online.ru/scream.mp3");
	audio.setVolume(100);
	audio.play();
}