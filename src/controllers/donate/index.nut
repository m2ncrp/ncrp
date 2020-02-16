cmd(["donate", "donat"], function ( playerid, value = null ) {

  if(isPlayerAdmin(playerid) && value != null) {
    setSettingsValue("donate", value)
    return msg(playerid, "Донат %s", [value == "true" ? "возобновлён" : "приостановлен"])
  }

  local lang = getPlayerLocale(playerid);
  if(lang == "en") {
    return msg(playerid, "Donate is not available for english-speaking players");
  }

  if(!getSettingsValue("donate")) {
    return msg(playerid, "На данный момент возможность доната не предоставляется");
  }

  msg(playerid, "===========================================", CL_HELP_LINE);
  msg(playerid, "ДОНАТ", CL_HELP_TITLE);
  msg(playerid, "Вы можете приобрести игровую валюту.");
  msg(playerid, "Подробности и варианты оплаты по ссылке:");
  msg(playerid, "https://mafia2online.ru/donate.html", CL_HELP);
});
