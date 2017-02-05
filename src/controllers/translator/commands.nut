simplecmd("en", function(playerid) {
    setPlayerLocale(playerid, "en");
    msg(playerid, "language.change.success", CL_SUCCESS);
    dbg("player", "locale", getIdentity(playerid), "en");
});

simplecmd("ru", function(playerid) {
    setPlayerLocale(playerid, "ru");
    msg(playerid, "language.change.success", CL_SUCCESS);
    dbg("player", "locale", getIdentity(playerid), "ru");
});

event("onPlayerLanguageChange", function(playerid, locale) {
    setPlayerLocale(playerid, locale);
    msg(playerid, "language.change.success", CL_SUCCESS);
    dbg("player", "locale", getIdentity(playerid), locale);
});
