cmd(["donate", "donat"], function ( playerid ) {
  local lang = getPlayerLocale(playerid);
  if(lang == "en") {
    return msg(playerid, "Donate is not available for english-speaking players");
  }

  msg(playerid, "===========================================", CL_HELP_LINE);
  msg(playerid, "ДОНАТ", CL_HELP_TITLE);
  msg(playerid, "Вы можете приобрести игровую валюту.");
  msg(playerid, "Подробности и варианты оплаты по ссылке:");
  msg(playerid, "https://mafia2online.ru/donate.html", CL_HELP);

});
