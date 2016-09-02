addCommandHandler( "vehicle",
	function( playerid, id )
	{
		local pos = getPlayerPosition( playerid );
		local vehicle = createVehicle( id.tointeger(), pos[0] + 2.0, pos[1], pos[2] + 1.0, 0.0, 0.0, 0.0 );
		
		local colour = getVehicleColour ( vehicle );
	
		log ( "Primary Colour: "+colour[0]+", "+colour[1]+", "+colour[2] );
		log ( "Secondary Colour: "+colour[3]+", "+colour[4]+", "+colour[5] );
		
		setVehicleColour ( vehicle, 255, 0, 255, 0, 255, 255 );
	}
);

addCommandHandler( "tune",
	function( playerid )
	{
		if( isPlayerInVehicle( playerid ) )
		{
			local vehicleid = getPlayerVehicle( playerid );
			setVehicleTuningTable( vehicleid, 3 );
			
			setVehicleWheelTexture( vehicleid, 0, 11 );
			setVehicleWheelTexture( vehicleid, 1, 11 );
		}
	}
);

addCommandHandler( "fix",
	function( playerid )
	{
		if( isPlayerInVehicle( playerid ) )
		{
			local vehicleid = getPlayerVehicle( playerid );
			repairVehicle( vehicleid );
		}
	}
);

addCommandHandler( "heal",
	function( playerid )
	{
		setPlayerHealth( playerid, 720.0 );
	}
);

addCommandHandler( "skin",
	function( playerid, id )
	{
		setPlayerModel( playerid, id.tointeger() );
	}
);

addCommandHandler( "die",
    function( playerid )
    {
        setPlayerHealth( playerid, 0.0 );
    }
);


addCommandHandler( "restart",
    function( playerid, name )
    {
        restart name;
        log("LoL!");
    }
);