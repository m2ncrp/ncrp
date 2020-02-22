addEventHandler("onPlayerInitMoney", function(money) {
    local currentAmount = money * 100;
    executeLua("game.game:SoundFadeOut(250) pla=game.game:GetActivePlayer() money=pla:InventoryGetMoney() pla:InventoryAddMoney("+currentAmount+" - money)");
    delayedFunction(600, function() {
        executeLua("game.game:SoundFadeIn(1500) ");
    });
});

addEventHandler("onPlayerAddMoney", function(amount) {
    executeLua("game.game:GetActivePlayer():InventoryAddMoney("+amount+")");
});

addEventHandler("onPlayerRemoveMoney", function(amount) {
    executeLua("game.game:GetActivePlayer():InventoryRemoveMoney("+amount+")");
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}