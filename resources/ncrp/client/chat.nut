// REMOVE IN RC4
addEventHandler("onClientChat", function(text, isCommand) {
    if (isCommand) {
        return true;
    }
    return false;
});
