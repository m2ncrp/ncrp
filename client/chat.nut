_chat_slot <- 0;
_chat_functions <- ["/ic", "/me", "/ooc"];

function dbg(data)
{
	log("[debug] " + data);
}

addEventHandler("onClientFrameRender", function(post) {
	if(!post) {
		dxDrawText("Слот чата:   1   2   3   " , 30.0, 8.0, 0xFFFFFFFF, true, "tahoma-bold");
		dxDrawText("[   ]", 95.0 + (15 * _chat_slot).tofloat(), 8.0, fromRGB(200,20,20), true, "tahoma-bold");
		dxDrawText(" - " + _chat_functions[_chat_slot], 146.0, 8.0, fromRGB(250,50,50), true, "tahoma-bold");
	}
});

bindKey("8", "down", function() {
	_chat_slot = 0;
	triggerServerEvent("onPlayerChangeChatSlot", 0);
});

bindKey("9", "down", function() {
	_chat_slot = 1;
	triggerServerEvent("onPlayerChangeChatSlot", 1);
});

bindKey("0", "down", function() {
	_chat_slot = 2;
	triggerServerEvent("onPlayerChangeChatSlot", 2);
});

bindKey("home", "down", function() {
	_chat_slot = (_chat_slot == 2) ? 0 : _chat_slot + 1;
	triggerServerEvent("onPlayerChangeChatSlot", _chat_slot);
});

bindKey("end", "down", function() {
	_chat_slot = (_chat_slot == 0) ? 2 : _chat_slot - 1;
	triggerServerEvent("onPlayerChangeChatSlot", _chat_slot);
});

addEventHandler("onAddClienChatCommand", function(command) {
	_chat_functions[_chat_slot] = command;
});

addEventHandler("onServerChangePlayerSlot", function(slot) {
	_chat_slot = slot.tointeger();
	local window = guiCreateElement(ELEMENT_TYPE_WINDOW, "test", 100, 100, 600, 300);
});


//addEventHandler("onClientChat", function(text) {
//	dbg(text);
	/*local rx = regexp("(/)");
	dbg(rx.match(text));
	/*f (text.find("/")) {
		triggerServerEvent("onPlayerChat", text); 
		return 0;
	}*/
//	triggerServerEvent("onPlayerChat", text);
//});