addEventHandler( "onClientFrameRender",  function(post) {
	if( post ) {
        local screen = getScreenSize();
        local string = "FPS: " + getFPS() + "  |  Ping: " + getPlayerPing(getLocalPlayer()) + "  |  Connected players: " + getPlayerCount();
        dxDrawRectangle(0.0, 0.0, screen[0].tofloat(), 24.0, 0x55000000);
        dxDrawText( string , 8.0, 4.0, 0xFFFFFFFF, false, "tahoma-bold" );
		dxDrawText( "NC-RP v0.154 (new)" , screen[0] - 120.0, 4.0, 0xFFFFFFFF, false, "tahoma-bold" );
    }
});
