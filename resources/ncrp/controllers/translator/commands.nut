simplecmd("en", function(playerid) {
    setPlayerLocale(playerid, "en");
    msg(playerid, "language.change.success", CL_SUCCESS);
    dbg("player", "locale", getAuthor(playerid), "en");
});

simplecmd("ru", function(playerid) {
    setPlayerLocale(playerid, "ru");
    msg(playerid, "language.change.success", CL_SUCCESS);
    dbg("player", "locale", getAuthor(playerid), "ru");
});
