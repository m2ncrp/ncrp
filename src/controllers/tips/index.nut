include("controllers/tips/tutorial.nut")

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
    "tips.business"     ,
    "tips.sellcar"      ,
    "tips.bugreport"    ,
    "tips.openmap"      ,
    "tips.switchchats"  ,
    "tips.chatvisible"  ,
    "tips.turnlights"   ,
    "tips.dice"         ,
    "tips.hat"
];

translation("en", {
    "tips.money.earn"   :   "[TIPS] You can get money by working. For more info: /help job"
    "tips.money.bank"   :   "[TIPS] You can earn money by starting bank deposit. Go to the bank (yellow icon on the map)."
    "tips.car"          :   "[TIPS] You can buy own car at the Diamond Motors (gear icon on the map)."
    "tips.car.repair"   :   "[TIPS] You can repair your car at the repair shops. Use /repair"
    "tips.eat"          :   "[TIPS] You can restore health by eating in the restaurants."
    "tips.police"       :   "[TIPS] If you see a crime, don't hesitate calling a police from phone booth. Use: /police"
    "tips.hobos"        :   "[TIPS] You can search trash containers and find something in it using /dig command"
    "tips.engine.howto" :   "[TIPS] Do not waste fuel, don't forget to off the engine using /engine off or press Q button"
    "tips.taxi"         :   "[TIPS] If you need a ride, you can take a taxi from phone booth. Use: /taxi"
    "tips.metro"        :   "[TIPS] Subway is a good way of transportation. Go to the nearest subway station and use: /subway"
    "tips.house"        :   "[TIPS] You can buy a house, just find an estate agent, and settle a deal."
    "tips.report"       :   "[TIPS] Saw a cheater? Or player which is braking the rules? Report via: /report ID TEXT"
    "tips.idea"         :   "[TIPS] You have an idea, suggestion, or question? Let us know via: /idea TEXT"
    "tips.discord"      :   "[TIPS] You can follow our development updates on the official discord server: bit.ly/tsoeb."
    "tips.vk"           :   "[TIPS] Join our group in VK: vk.com/tsoeb"
    "tips.layout"       :   "[TIPS] You can change keyboard layout (all binds will remain on same positions as for qwerty). Use /layout"
    "tips.business"     :   "[TIPS] You can purchase any business (while staning near it), via: /business buy"
    "tips.sellcar"      :   "[TIPS] You can sell car to other player. Use command /sell"
    "tips.bugreport"    :   "[TIPS] You can report bugs or errors via /bug TEXT"
    "tips.openmap"      :   "[TIPS] You can open map - press key M."
    "tips.switchchats"  :   "[TIPS] Use F1-F4 keys to switch between different types of the chat."
    "tips.chatvisible"  :   "[TIPS] Press F5 to show/hide window of chat."
    "tips.turnlights"   :   "[TIPS] Z - left turn lights; X - hazard lights; C - right turn lights."
    "tips.dice"         :   "[TIPS] Use /dice for throwing dice."
    "tips.hat"          :   "[TIPS] Use /hat COUNT for pull a ball from hat, where COUNT balls in hat."
    "tips.enabled"      :   "[TIPS] Tips has been enabled."
    "tips.disabled"     :   "[TIPS] Tips has been disabled."
});

local tipsToggles = {};

event("onServerMinuteChange", function() {
    if ((getMinute() % 30) != 0) {
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
    if (!(getPlayerName(playerid) in tipsToggles)) {
        msg(playerid, "tips.disabled");
        return tipsToggles[getPlayerName(playerid)] <- true;
    }

    msg(playerid, "tips.enabled");
    delete tipsToggles[getPlayerName(playerid)];
});