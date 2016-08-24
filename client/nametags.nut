// nametags.nut By AaronLad

local vectors = {};
local text;
local dimensions;
local boxWidth = 68.0;
local boxHeight = 10.0;

function framePreRender( )
{
	for( local i = 0; i < MAX_PLAYERS; i++ )
	{
		if( i != getLocalPlayer() && isPlayerConnected(i) )
		{
			// Get the player position
			local pos = getPlayerPosition( i );
			
			// Get the screen position from the world
			vectors[i] <- getScreenFromWorld( pos[0], pos[1], (pos[2] + 2.0) );
		}
	}
}
addEventHandler( "onClientFramePreRender", framePreRender );

function frameRender( post_gui )
{
	if( !post_gui )
	{
		for( local i = 0; i < MAX_PLAYERS; i++ )
		{
			if( i != getLocalPlayer() && isPlayerConnected(i) && isPlayerOnScreen(i) )
			{
				local pos = getPlayerPosition( i );
				local lclPos = getPlayerPosition( getLocalPlayer() );
				local fDistance = getDistanceBetweenPoints3D( pos[0], pos[1], pos[2], lclPos[0], lclPos[1], lclPos[2] );
				
				if( fDistance <= 35.0 )
				{
					local fScale = 1.0;
					
					text = getPlayerName(i) + " (" + i.tostring() + ")";
					dimensions = dxGetTextDimensions( text, fScale, "tahoma-bold" );
					
					dxDrawText( text, (vectors[i][0] - (dimensions[0] / 2)) + 1, vectors[i][1] + 1, 0xFF000000, false, "tahoma-bold", fScale );
					dxDrawText( text, (vectors[i][0] - (dimensions[0] / 2)), vectors[i][1], getPlayerColour(i), false, "tahoma-bold", fScale );
				
					local healthWidth = (((clamp( 0.0, getPlayerHealth( i ), 720.0 ) * 100.0) / 720.0) / 100 * (boxWidth - 4.0));
				
					dxDrawRectangle( (vectors[i][0] - (boxWidth / 2)), (vectors[i][1] + 16.0), boxWidth, boxHeight, fromRGB( 0, 0, 0, 160 ) );
					dxDrawRectangle( ((vectors[i][0] - (boxWidth / 2)) + 2.0), (vectors[i][1] + 18.0), (boxWidth - 4.0), (boxHeight - 4.0), fromRGB( 0, 110, 0, 160 ) );
					dxDrawRectangle( ((vectors[i][0] - (boxWidth / 2)) + 2.0), (vectors[i][1] + 18.0), healthWidth, (boxHeight - 4.0), fromRGB( 0, 255, 0, 160 ) );
				}
			}
		}
	}
}
addEventHandler( "onClientFrameRender", frameRender );