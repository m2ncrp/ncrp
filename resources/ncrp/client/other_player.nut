addEventHandler("hidePlayerModel", function() {
    executeLua("game.game:GetActivePlayer():ShowModel(false)");
});

addEventHandler("showPlayerModel", function() {
    executeLua("game.game:GetActivePlayer():ShowModel(true)");
});
