include("controllers/admin/commands.nut");
include("controllers/admin/sqdebug.nut");
include("controllers/admin/teleport.nut");

local serverAdmins = [
    "CD19A5029AE81BB50B023291846C0DF3", // max
    "940A9BF3DC69DC56BCB6BDB5450961B4", // dima
    "E818234F219F14336D8FFD5C657B796C", // inlufz
];

local infoTipsCache = [];
local infoTips = [
    "tips.money.earn"   ,
    "tips.money.bank"   ,
    "tips.car"          ,
    "tips.car.repair"   ,
    "tips.eat"          ,
    "tips.police"       ,
    "tips.hobos"        ,
    "tips.engine.howto" ,
    "tips.taxi"         ,
    "tips.metro"        ,
    "tips.house"        ,
    "tips.carrental"    ,
    "tips.report"       ,
    "tips.idea"         ,
    "tips.discord"      ,
];

translation("en", {
    "tips.money.earn"   :   "[TIPS] You can get money by working. For more info: /help job"
    "tips.money.bank"   :   "[TIPS] You can earn money by starting bank deposit. Go to the bank (yellow icon on the map)."
    "tips.car"          :   "[TIPS] You can buy own car at the Diamond Motors (gear icon on the map)."
    "tips.car.repair"   :   "[TIPS] You can repair your car at the repair shops. Use /repair"
    "tips.eat"          :   "[TIPS] You can restore health by eating in the restaurants."
    "tips.police"       :   "[TIPS] If you see a crime, dont hesitate calling a police. Use: /police LOCATION"
    "tips.hobos"        :   "[TIPS] You can search trash containers and find something in it using /dig command"
    "tips.engine.howto" :   "[TIPS] Do not waste fuel, don't forget to off the engine using /engine off or press Q button"
    "tips.taxi"         :   "[TIPS] If you need a ride, you can take a taxi. Use: /taxi LOCATION"
    "tips.metro"        :   "[TIPS] Subway is a good way of transportation. Go to the nearest subway station and use: /subway"
    "tips.house"        :   "[TIPS] You can buy a house, just find an estate agent, and settle a deal."
    "tips.carrental"    :   "[TIPS] If you haven't enough money to buy a car, you can rent it at the Car Rental in North Millville."
    "tips.report"       :   "[TIPS] Saw a cheater? Or player which is braking the rules? Report via: /report ID TEXT"
    "tips.idea"         :   "[TIPS] You have an idea, suggestion, or question? Let us know via: /idea TEXT"
    "tips.discord"      :   "[TIPS] You can follow our development updates on the official discord server: bit.ly/nc-rp."
});

translation("ru", {
    "tips.money.earn"   :   "[TIPS] Вы можете зарабатывать деньги работая на работах. Подробнее: /help job"
    "tips.money.bank"   :   "[TIPS] Вы можете получать доход от депозита в банке. Отправляйтесь в банк (Желтая инконка на карте)."
    "tips.car"          :   "[TIPS] Вы можете купить собственный автомобиль в Diamond Motors (Серая иконка шестеренки на карте)."
    "tips.car.repair"   :   "[TIPS] Вы можете починить свой автомобиль в мастерских. Используйте /repair"
    "tips.eat"          :   "[TIPS] Вы можете восстанавливать уровень ХП обедая в ресторанах."
    "tips.police"       :   "[TIPS] Если вы стали свидетелем преступления, вызывайте полицию. Команда: /police МЕСТО"
    "tips.hobos"        :   "[TIPS] Вы можете найти деньги в мусорных баках. Используйте команду: /dig"
    "tips.engine.howto" :   "[TIPS] Не забывайте экономить топливо, используйте кнопку Q, или команду /engine off для выключения двигателя."
    "tips.taxi"         :   "[TIPS] Если вам нужно куда-то добраться, вы можете вызвать такси: /taxi МЕСТО"
    "tips.metro"        :   "[TIPS] Метро, это удобнный и дешевый способ передвижения. Найдите ближайшую станцию и используйте: /subway"
    "tips.house"        :   "[TIPS] Вы моежете купить дом, найдите риелтора что бы заключить сделку."
    "tips.carrental"    :   "[TIPS] Если у вас не хватает денег на авто, вы можете арендовать машину Car Rental в North Millville."
    "tips.report"       :   "[TIPS] Увидели читера? Или игрока нарушающего правила? Доложите на него испоьзуя: /report ID ТЕКСТ"
    "tips.idea"         :   "[TIPS] У вас есть идея или предложение, сообщите об этом нам используя команду: /idea ТЕКСТ"
    "tips.discord"      :   "[TIPS] Вы можете следить за новостями разрабоки на официальном дискорд сервере: bit.ly/nc-rp."
});

function isPlayerAdmin(playerid) {
    return (serverAdmins.find(getPlayerSerial(playerid)) != null);
}

event("onPlayerTeleportRequested", function(playerid, x, y, z) {
    if (isPlayerAdmin(playerid)) {
        setPlayerPosition(playerid, x, y, z);
    }
});

event("onClientDebugToggle", function(playerid) {
    return (isPlayerAdmin(playerid)) ? trigger(playerid, "onServerDebugToggle") : null;
})

event("native:onConsoleInput", function(name, data) {
    switch (name) {
        case "list": dbg(getPlayers()); break;
        case "adm": sendPlayerMessageToAll("[ADMIN] " + data, CL_MEDIUMPURPLE.r, CL_MEDIUMPURPLE.g, CL_MEDIUMPURPLE.b); log("[ADMIN] " + data); break;
        case "lang": dumpTranslations(data.slice(0, 2), data.slice(3, 5)); break;
    }
});

event("onServerAutosave", function() {
    if (!infoTipsCache || !infoTipsCache.len()) {
        infoTipsCache = clone infoTips;
    }

    // remove random value from cache
    local tipid = random(0, infoTipsCache.len() - 1);
    local tip   = infoTipsCache[tipid];
    infoTipsCache.remove(tipid);

    // send to all logined players
    msg_a(tip, CL_JORDYBLUE);
});
