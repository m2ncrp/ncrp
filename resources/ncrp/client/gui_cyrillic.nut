addEventHandler("onTranslate", function (key) {
  local phrases = {
    rotateCamera = "Чтобы осмотреть персонажа, зажмите Shift и двигайте мышь.",
    newName = "Придумайте новое имя. Ваше имущество будет сохранено."
  }
  callEvent("onTranslateReturn", key, phrases[key]);
});

