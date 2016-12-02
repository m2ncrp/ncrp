addEventHandler("onClientChat", function(text, isCommand) {
    if (isCommand) {
        return true;
    }
    return false;
});
