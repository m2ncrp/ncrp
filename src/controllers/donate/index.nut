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

  msgh(playerid, "Донат", [
      "Донат - это пожертвования.",
      "В благодарность мы начислим вам игровую валюту на счёт в банке.",
      "Подробности на нашем сайте:",
      "mafia2online.ru/donate"
  ]);

});
