translation("en", {

    "empirecustom.phone.hello"      : "[CALL] Advertising agency Empire Custom. We can help you to advertise! Cost: $%.2f."
    "empirecustom.phone.notenough"  : "[CALL] Sorry, there is not enough money on your account in bank."
    "empirecustom.phone.enter"      : "Enter text of your ad:"
    "empirecustom.phone.help"       : "Write text in chat and send it for %d seconds. To refuse - write 0 or 'cancel'."
    "empirecustom.phone.yourad"     : "Text: %s"
    "empirecustom.phone.placed"     : "[CALL] Your ad will be placed in 1 minute. Thanks for choosing Empire Custom. (hang up)"
    "empirecustom.phone.ad"         : "[AD] %s"
    "empirecustom.phone.canceled"   : "[CALL] If you want to advertise, call to us. Good luck! (hang up)"
});

local AD_COST = 1.0;
local AD_TIMEOUT = 120; // in seconds
local AD_COLOR = CL_CARIBBEANGREEN;

event("onPlayerPhoneCallNPC", function(playerid, number, place) {
    if(number == "1111") {
        if (isPlayerMuted(playerid)) {
            animatedPut(playerid);
            return msg(playerid, "admin.mute.youhave", CL_RED);
        }

        msg(playerid, "empirecustom.phone.hello", AD_COST, TELEPHONE_TEXT_COLOR);

        if(!canBankMoneyBeSubstracted(playerid, AD_COST)) {
            msg(playerid, "empirecustom.phone.notenough")
            animatedPut(playerid);
            return;
        }

        msg(playerid, "empirecustom.phone.enter");
        msg(playerid, "empirecustom.phone.help", AD_TIMEOUT, CL_GRAY);
        trigger(playerid, "hudCreateTimer", AD_TIMEOUT, true, true);
        local ad_sended = false;

        delayedFunction(AD_TIMEOUT*1000, function() {
            if (ad_sended == false) {
                msg(playerid, "empirecustom.phone.canceled", TELEPHONE_TEXT_COLOR);
            }
        });

        requestUserInput(playerid, function(playerid, text) {
            trigger(playerid, "hudDestroyTimer");
            if (text.tolower() == "отмена" || text.tolower() == "'отмена'" || text.tolower() == "нет" || text.tolower() == "'нет'" || text.tolower() == "cancel" || text.tolower() == "'cancel'" || text == "0") {
                ad_sended = "canceled";
                animatedPut(playerid);
                return msg(playerid, "empirecustom.phone.canceled", TELEPHONE_TEXT_COLOR);
            }
            ad_sended = true;

            dbg(format("[RADIO] %s: %s", getPlayerName(playerid), text))
            local replaced = preg_replace(@"[^\d]+", "", text)
            if(replaced.find("0192") != null) {
                subPlayerMoney(playerid, 100.0);
                dbg(format("[RADIO] auto-fine: %s", getPlayerName(playerid)))
                animatedPut(playerid);
                return;
            }

            msg(playerid, "empirecustom.phone.yourad", text, TELEPHONE_TEXT_COLOR);
            msg(playerid, "empirecustom.phone.placed", TELEPHONE_TEXT_COLOR);
            animatedPut(playerid);

            subPlayerDeposit(playerid, AD_COST);

            delayedFunction(60000, function() {
                trigger("onRadioMessageSend", text);
                //msg(playerid, "empirecustom.phone.ad", text, AD_COLOR);
            });
        }, AD_TIMEOUT);
    }

});
