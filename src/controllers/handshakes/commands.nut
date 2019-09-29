// сказать имя другому игроку
cmd(["shake", "handshake"], function(playerid, targetId, ...) {

  targetid = toInteger(targetid);
  local nickname = concat(vargv);

  if (!targetid || !isNumeric(targetId) || !nickname.len()) {
           msg(playerid, "handshake.rule",  CL_THUNDERBIRD);
           msg(playerid, "handshake.example", CL_LYNCH );
    return msg(playerid, "handshake.real-name", CL_LYNCH );
  }

  if (playerid == targetid) {
    return msg(playerid, "handshake.yourself");
  }

  if ( !isPlayerConnected(targetid) ) {
  	return msg(playerid, "handshake.noplayer");
  }

  if (!checkDistanceBtwTwoPlayersLess(playerid, targetid, 3.0)) {
    return msg(playerid, "handshake.largedistance");
  }


  // Если не знаком: Меня зовут name

  // если разница между знакомствами меньше 3 минут
  // Ой, нет-нет, меня зовут

  // можно представиться своим настоящим именем /shake id me

});


alternativeTranslate({

    "en|handshake.rule"  : ""
    "ru|handshake.rule"  : "Чтобы представить: /shake id name"

    "en|handshake.example"  : ""
    "ru|handshake.example"  : "Например: /shake 7 Joe"

    "en|handshake.real-name"  : ""
    "ru|handshake.real-name"  : "Представиться настоящим именем: /shake id me"

    "en|handshake.yourself" : "You can't shake hands with yourself."
    "ru|handshake.yourself" : "Ты не знаком сам с собой? Срочно обратись к доктору!"

    "en|handshake.noplayer" : "There's no such person on server!"
    "ru|handshake.noplayer" : "Указанный игрок оффлайн."

    "en|handshake.largedistance" : "Distance between both players is too large!"
    "ru|handshake.largedistance" : "Между вами слишком большая дистанция!"

});
