cmd("en", function(playerid) {
    setPlayerLocale(playerid, "en");
    msg(playerid, "language.change.success", CL_SUCCESS);
});

cmd("ru", function(playerid) {
    setPlayerLocale(playerid, "ru");
    msg(playerid, "language.change.success", CL_SUCCESS);
});
