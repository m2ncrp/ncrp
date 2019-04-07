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
    "tips.idea"         ,
    "tips.discord"      ,
    "tips.vk"           ,
 // "tips.layout"       ,
 // "tips.business"     ,
 // "tips.sellcar"      ,
    "tips.bugreport"    ,
    "tips.openmap"      ,
    "tips.switchchats"  ,
    "tips.chatvisible"  ,
    "tips.turnlights"   ,
    "tips.dice"         ,
    "tips.hat"
];

alternativeTranslate({



        "en|tips.money.earn"   :   "[TIPS] You can get money by working. For more info: /help job"
        "ru|tips.money.earn"   :   "[TIPS] Вы можете зарабатывать деньги, устроившись на работу. Подробнее: /help job"

        "en|tips.money.bank"   :   "[TIPS] You can earn money by starting bank deposit. Go to the bank (icon with dollar on the map)."
        "ru|tips.money.bank"   :   "[TIPS] Вы можете получать доход от депозита в банке (иконка доллара на карте)."

        "en|tips.car"          :   "[TIPS] You can buy own car at the Diamond Motors (colored icon with car on the map)."
        "ru|tips.car"          :   "[TIPS] Вы можете купить собственный автомобиль в Diamond Motors (цветная иконка с автомобилем на карте)."

        "en|tips.car.repair"   :   "[TIPS] You can repair your car at the repair shops."
        "ru|tips.car.repair"   :   "[TIPS] Вы можете починить свой автомобиль в автомастерских."

        "en|tips.eat"          :   "[TIPS] You can restore health by eating in the restaurants."
        "ru|tips.eat"          :   "[TIPS] Вы можете восстанавливать уровень здоровья, обедая в ресторанах."

        "en|tips.police"       :   "[TIPS] If you see a crime, don't hesitate calling a police from phone booth. Use: /police"
        "ru|tips.police"       :   "[TIPS] Если вы стали свидетелем преступления - бегите к телефонной будке и вызывайте полицию. Команда: /police"

        "en|tips.hobos"        :   "[TIPS] You can search trash containers and find something in it"
        "ru|tips.hobos"        :   "[TIPS] Вы можете найти деньги в мусорных контейнерах"

        "en|tips.engine.howto" :   "[TIPS] Do not waste fuel, don't forget to off the engine by press Q button"
        "ru|tips.engine.howto" :   "[TIPS] Не забывайте экономить топливо, используйте кнопку Q для выключения двигателя."

        "en|tips.taxi"         :   "[TIPS] If you need a ride, you can take a taxi from phone booth. Use: /taxi"
        "ru|tips.taxi"         :   "[TIPS] Если вам нужно куда-то добраться, вы можете вызвать такси из телефонной будки: /taxi"

        "en|tips.metro"        :   "[TIPS] Subway is a good way of transportation. Go to the nearest subway station and use: /subway"
        "ru|tips.metro"        :   "[TIPS] Метро - это удобный и дешевый способ передвижения. Найдите ближайшую станцию с помощью /subway"

        "en|tips.house"        :   "[TIPS] You can buy a house, just find an estate agent, and settle a deal."
        "ru|tips.house"        :   "[TIPS] Вы можете купить дом. Найдите риелтора, чтобы заключить сделку."

        "en|tips.report"       :   "[TIPS] Saw a cheater? Or player which is braking the rules? Report via: /report ID TEXT"
        "ru|tips.report"       :   "[TIPS] Увидели читера? Или игрока нарушающего правила? Сообщите администрации: /report ID ТЕКСТ"

        "en|tips.idea"         :   "[TIPS] You have an idea, suggestion, or question? Let us know via: /idea TEXT"
        "ru|tips.idea"         :   "[TIPS] У вас есть идея или предложение, сообщите об этом нам, используя команду: /idea ТЕКСТ"

        "en|tips.discord"      :   "[TIPS] You can follow our development updates on the official discord server: bit.ly/m2ncrp"
        "ru|tips.discord"      :   "[TIPS] Вы можете следить за новостями разработки на официальном сервере Discord: bit.ly/m2ncrp"

        "en|tips.vk"           :   "[TIPS] Join our group in VK: vk.com/m2ncrp"
        "ru|tips.vk"           :   "[TIPS] Вступайте в нашу группу ВКонтакте: vk.com/m2ncrp"

        "en|tips.layout"       :   "[TIPS] You can change keyboard layout (all binds will remain on same positions as for qwerty). Use /layout"
        "ru|tips.layout"       :   "[TIPS] Вы можете сменить раскладку клавиатуры (бинды останутся на прежних местах как для qwerty). См. /layout"

        "en|tips.business"     :   "[TIPS] You can purchase any business (while staning near it), via: /business buy"
        "ru|tips.business"     :   "[TIPS] Вы можете приобрести бизнес. Находясь у бизнеса, напишите команду /business buy"

        "en|tips.sellcar"      :   "[TIPS] You can sell car to other player. Use command /sell"
        "ru|tips.sellcar"      :   "[TIPS] Вы можете продать свой автомобиль другому игроку. Находясь в авто, используйте команду /sell"

        "en|tips.bugreport"    :   "[TIPS] You can report bugs or errors via /bug TEXT"
        "ru|tips.bugreport"    :   "[TIPS] Обнаружили ошибку или баг? Напишите нам: /bug ТЕКСТ"

        "en|tips.openmap"      :   "[TIPS] You can open map - press key M."
        "ru|tips.openmap"      :   "[TIPS] Вы можете открыть карту города, нажав на клавишу M (английскую)."

        "en|tips.switchchats"  :   "[TIPS] Use F1-F3 keys to switch between different types of the chat."
        "ru|tips.switchchats"  :   "[TIPS] Для переключения между слотами чата используйте клавиши F1-F3."

        "en|tips.chatvisible"  :   "[TIPS] Press F5 to show/hide window of chat."
        "ru|tips.chatvisible"  :   "[TIPS] Если вы хотите скрыть чат - нажмите клавишу F5. Повторное нажатие отобразит чат."

        "en|tips.turnlights"   :   "[TIPS] Z - left turn lights; X - hazard lights; C - right turn lights."
        "ru|tips.turnlights"   :   "[TIPS] Z - левый поворотник; X - аварийка; C - правый поворотник."

        "en|tips.dice"         :   "[TIPS] Use /dice for throwing dice."
        "ru|tips.dice"         :   "[TIPS] Чтобы бросить кубик, используйте: /dice"

        "en|tips.hat"          :   "[TIPS] Use /hat COUNT for pull a ball from hat, where COUNT balls in hat."
        "ru|tips.hat"          :   "[TIPS] /hat X - вытащить из шляпы один шар из X шаров."

        "en|tips.enabled"      :   "[TIPS] Tips has been enabled."
        "ru|tips.enabled"      :   "[TIPS] Подсказки были включены."

        "en|tips.disabled"     :   "[TIPS] Tips has been disabled."
        "ru|tips.disabled"     :   "[TIPS] Подсказки были выключены."

        "en|tips.disabledAlready"   :   "[TIPS] You have disabled receiving tips. To enable: /tips"
        "ru|tips.disabledAlready"   :   "[TIPS] У вас отключены подсказки. Включить: /tips"

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

        msg(playerid, tip, CL_JORDYBLUE);
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
