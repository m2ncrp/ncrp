dofile("resources/ncrp/helpers/assert.nut");

function test_isRobertoLukini(playerid) {
    expect( "test_isRobertoLukini", "Roberto_Lukini", getPlayerName(playerid) );
}

function test_isThirdSpawn(playerid) {
    expect( "test_isThirdSpawn", 3, players[playerid]["spawn"]);
}

q <- TestQueue();

cases <- [
    test_isRobertoLukini,
    test_isThirdSpawn
];


// q.pushall(cases); // call unit on first connect only
