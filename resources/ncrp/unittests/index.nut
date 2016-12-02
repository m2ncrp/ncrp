dofile("resources/ncrp/helpers/assert.nut");
dofile("resources/ncrp/unittests/commands.nut");

function test_isRobertoLukini(playerid) {
    expect( "test_isRobertoLukini", "Roberto_Lukini", getPlayerName(playerid) );
}

function test_isThirdSpawn(playerid) {
    expect( "test_isThirdSpawn", 3, players[playerid]["spawn"]);
}

// Check if vehicle fuel tank volume same as expected
function test_fueltanks(playerid) {
    local vehid = createVehicle( 6, -1674.18, -232.502, -20.1111, 0.0, 0.0, 0.0 );
    setPlayerPosition(playerid, -1674.18, -232.502, -20.1111);   
    // putPlayerInVehicle( playerid, vehid, 0 ); 

    setVehicleFuel(vehid, 0.0);
    fuelup(playerid);

    expect( "test_fueltanks", 64, getVehicleFuel(vehid) );
}

q <- TestQueue();

cases <- [
    test_isRobertoLukini,
    test_isThirdSpawn
];


// q.pushall(cases); // call unit on first connect only
