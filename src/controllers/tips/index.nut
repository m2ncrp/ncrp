include("controllers/tips/tutorial.nut")

local tipsToggles = {};

local infoTipsCache = [];
local infoTips = [
    "tips.money.earn"   ,
 // "tips.money.bank"   ,
    "tips.car"          ,
    "tips.car.repair"   ,
    "tips.eat"          ,
    "tips.police"       ,
    "tips.hobos"        ,
    "tips.engine.howto" ,
 // "tips.taxi"         ,
    "tips.metro"        ,
 // "tips.house"        ,
    "tips.report"       ,
 // "tips.idea"         ,
    "tips.discord"      ,
    "tips.vk"           ,
 // "tips.layout"       ,
 // "tips.business"     ,
 // "tips.sellcar"      ,
 // "tips.bugreport"    ,
    "tips.openmap"      ,
    "tips.switchchats"  ,
    "tips.turnlights"   ,
    "tips.hat"
];

alternativeTranslate({

        "en|tips.money.earn"   :   "You can get money by working. For more info: /job"
        "ru|tips.money.earn"   :   "Вы можете зарабатывать деньги, устроившись на работу. Подробнее: /job"

        "en|tips.money.bank"   :   "You can earn money by starting bank deposit. Go to the bank (icon with dollar on the map)."
        "ru|tips.money.bank"   :   "Вы можете получать доход от депозита в банке (иконка доллара на карте)."

        "en|tips.car"          :   "You can buy own car at the Diamond Motors (colored icon with car on the map)."
        "ru|tips.car"          :   "Вы можете купить собственный автомобиль в Diamond Motors (цветная иконка с автомобилем на карте)."

        "en|tips.car.repair"   :   "You can repair your car at the repair shops."
        "ru|tips.car.repair"   :   "Вы можете починить свой автомобиль в автомастерских."

        "en|tips.eat"          :   "You can restore health by eating in the restaurants."
        "ru|tips.eat"          :   "Вы можете восстанавливать уровень здоровья, покупая еду в ресторанах, барах и закусочных."

        "en|tips.police"       :   "If you see a crime, don't hesitate calling a police from phone booth. Use: /police"
        "ru|tips.police"       :   "Если вы стали свидетелем преступления - бегите к телефонной будке и вызывайте полицию. Команда: /police"

        "en|tips.hobos"        :   "You can search trash containers and find something in it"
        "ru|tips.hobos"        :   "Вы можете найти деньги в мусорных контейнерах"

        "en|tips.engine.howto" :   "Do not waste fuel, don't forget to off the engine by press Q button"
        "ru|tips.engine.howto" :   "Не забывайте экономить топливо, используйте кнопку Q для выключения двигателя."

        "en|tips.taxi"         :   "If you need a ride, you can take a taxi from phone booth. Use: /taxi"
        "ru|tips.taxi"         :   "Если вам нужно куда-то добраться, вы можете вызвать такси из телефонной будки: /taxi"

        "en|tips.metro"        :   "Subway is a good way of transportation. Go to the nearest subway station and use: /find subway"
        "ru|tips.metro"        :   "Метро - это удобный и дешевый способ передвижения. Найдите ближайшую станцию с помощью /find subway"

        "en|tips.house"        :   "You can buy a house, just find an estate agent, and settle a deal."
        "ru|tips.house"        :   "Вы можете купить дом. Найдите риелтора, чтобы заключить сделку."

        "en|tips.report"       :   "Saw a cheater? Or player which is braking the rules? Report via: /report id reason"
        "ru|tips.report"       :   "Увидели читера? Или игрока нарушающего правила? Сообщите администрации: /report id нарушение"

        "en|tips.idea"         :   "You have an idea, suggestion, or question? Let us know via: /idea TEXT"
        "ru|tips.idea"         :   "У вас есть идея или предложение, сообщите об этом нам, используя команду: /idea ТЕКСТ"

        "en|tips.discord"      :   "You can follow our development updates on the official discord server: bit.ly/m2ncrp"
        "ru|tips.discord"      :   "Вы можете следить за новостями разработки на официальном сервере Discord: bit.ly/m2ncrp"

        "en|tips.vk"           :   "Join our group in VK: vk.com/m2ncrp"
        "ru|tips.vk"           :   "Вступайте в нашу группу ВКонтакте: vk.com/m2ncrp"

        "en|tips.layout"       :   "You can change keyboard layout (all binds will remain on same positions as for qwerty). Use /layout"
        "ru|tips.layout"       :   "Вы можете сменить раскладку клавиатуры (бинды останутся на прежних местах как для qwerty). См. /layout"

        "en|tips.business"     :   "You can purchase any business (while staning near it), via: /business buy"
        "ru|tips.business"     :   "Вы можете приобрести бизнес. Находясь у бизнеса, напишите команду /business buy"

        "en|tips.sellcar"      :   "You can sell car to other player. Use command /sell"
        "ru|tips.sellcar"      :   "Вы можете продать свой автомобиль другому игроку. Находясь в авто, используйте команду /sell"

        "en|tips.bugreport"    :   "You can report bugs or errors via /bug TEXT"
        "ru|tips.bugreport"    :   "Обнаружили ошибку или баг? Напишите нам: /bug ТЕКСТ"

        "en|tips.openmap"      :   "You can open map - press key M."
        "ru|tips.openmap"      :   "Вы можете открыть карту города, нажав на клавишу M (английскую)."

        "en|tips.switchchats"  :   "Use F1-F3 keys to switch between different types of the chat."
        "ru|tips.switchchats"  :   "Для переключения между слотами чата используйте клавиши F1-F3."

        "en|tips.turnlights"   :   "X - left turn lights; C - right turn lights; H - hazard lights."
        "ru|tips.turnlights"   :   "X - левый поворотник; C - правый поворотник; H - аварийка."

        "en|tips.hat"          :   "Use /hat COUNT for pull a ball from hat, where COUNT balls in hat."
        "ru|tips.hat"          :   "/hat 5 - вытащить из шляпы один шар из 5 шаров."

        "en|tips.enabled"      :   "Tips has been enabled."
        "ru|tips.enabled"      :   "Подсказки были включены."

        "en|tips.disabled"     :   "Tips has been disabled."
        "ru|tips.disabled"     :   "Подсказки были выключены."

        "en|tips.disabledAlready"   :   "You have disabled receiving tips. To enable: /tips"
        "ru|tips.disabledAlready"   :   "У вас отключены подсказки. Включить: /tips"

});


event("onServerPlayerStarted", function( playerid ){

    local account = getAccount(playerid);

    if (account.hasData("showTIPS")) {
        local showTIPS = account.getData("showTIPS");
        if (showTIPS == false) {
            tipsToggles[getPlayerName(playerid)] <- true;
            msg(playerid, "tips.disabledAlready");
        }
    }

    delayedFunction(7000, function() {
        msg(playerid, "hello.news.title", CL_WARNING);
        msg(playerid, "hello.news.text", CL_SUCCESS);
    });


});

event("onServerMinuteChange", function() {
    if ((getMinute() % 15) != 0) {
        return;
    }

    if (!infoTipsCache || !infoTipsCache.len()) {
        infoTipsCache = clone infoTips;
    }

    // remove random value from cache
    local tipid = random(0, infoTipsCache.len() - 1);
    local tip   = infoTipsCache[tipid];
    infoTipsCache.remove(tipid);

    // send to all logined players
    foreach (playerid, value in players) {
        if (getPlayerName(playerid) in tipsToggles) continue;

        msg(playerid, tip, CL_MALIBU);
    }
});

cmd("tips", function(playerid) {

    local account = getAccount(playerid);

    if (!(getPlayerName(playerid) in tipsToggles)) {
        account.setData("showTIPS", false);
        msg(playerid, "tips.disabled");
        return tipsToggles[getPlayerName(playerid)] <- true;
    }

    msg(playerid, "tips.enabled");
    account.setData("showTIPS", true);
    delete tipsToggles[getPlayerName(playerid)];
});
