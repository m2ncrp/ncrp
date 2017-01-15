translation("en", {

    "empirecustom.phone.hello"      : "[CALL] Advertising agency Empire Custom. We can help you to advertise! Cost: $%.2f."
    "empirecustom.phone.notenough"  : "[CALL] Sorry, there is not enough money on your account in bank."
    "empirecustom.phone.enter"      : "Enter text of your ad:"
    "empirecustom.phone.help"       : "Write text on chat and send it for %d seconds. To refuse - write 0 or 'cancel'."
    "empirecustom.phone.yourad"     : "Text: %s"
    "empirecustom.phone.placed"     : "[CALL] Your ad will be placed in 1 minute. Thanks for choosing Empire Custom. (hang up)"
    "empirecustom.phone.ad"         : "[AD] %s"
    "empirecustom.phone.canceled"   : "[CALL] If you want to advertise, call to us. Good luck! (hang up)"
});

local AD_COST = 7.52;
local AD_TIMEOUT = 90; // in seconds
local AD_COLOR = CL_CARIBBEANGREEN;

event("onPlayerPhoneCall", function(playerid, number, place) {
    if(number == "1111") {

        msg(playerid, "empirecustom.phone.hello", AD_COST, TELEPHONE_TEXT_COLOR);

        if(!canBankMoneyBeSubstracted(playerid, AD_COST)) {
            return msg(playerid, "empirecustom.phone.notenough");
        }

        msg(playerid, "empirecustom.phone.enter");
        msg(playerid, "empirecustom.phone.help", AD_TIMEOUT, CL_GRAY);

        local ad_sended = false;

        delayedFunction(AD_TIMEOUT*1000, function() {
            if (ad_sended == false) {
                msg(playerid, "empirecustom.phone.canceled", TELEPHONE_TEXT_COLOR);
            }
        });

        requestUserInput(playerid, function(playerid, text) {
            if (text.tolower() == "отмена" || text.tolower() == "'отмена'" || text.tolower() == "cancel" || text.tolower() == "'cancel'" || text == "0") {
                ad_sended = "canceled";
                return msg(playerid, "empirecustom.phone.canceled", TELEPHONE_TEXT_COLOR);
            }

            msg(playerid, "empirecustom.phone.yourad", text, TELEPHONE_TEXT_COLOR);
            msg(playerid, "empirecustom.phone.placed", TELEPHONE_TEXT_COLOR);
            ad_sended = true;
            subBankMoneyToPlayer(playerid, AD_COST);

            delayedFunction(60000, function() {
                msg(playerid, "empirecustom.phone.ad", text, AD_COLOR);
            });
        }, 90);
    }

});
