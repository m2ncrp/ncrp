include("controllers/admin/commands.nut");
include("controllers/admin/sqdebug.nut");

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
    "tips.taxi"         ,
    "tips.metro"        ,
    "tips.house"        ,
];

translation("en", {
    "tips.money.earn"   :   "[TIP] You can get money by working. For more info: /help job"
    "tips.money.bank"   :   "[TIP] You can earn money by starting bank deposit. Go to the bank (Yellow icon on the map)"
    "tips.car"          :   "[TIP] You can buy own car at the Diamond Motors. (Gear icon on the map)."
    "tips.car.repair"   :   "[TIP] You can repair your car at the service shops. Use /repair"
    "tips.eat"          :   "[TIP] You can restore health by eating in the restaurants."
    "tips.police"       :   "[TIP] If you see a crime, dont hesitate calling a police. Use: /police LOCATION"
    "tips.taxi"         :   "[TIP] If you need a ride, you can take a taxi. Use: /taxi LOCATION"
    "tips.metro"        :   "[TIP] Subway is a good way of transportation. Go to the nearest subway station, and use: /subway"
    "tips.house"        :   "[TIP] You can buy a house, just find an estate agent, and settle a deal."
});

function isPlayerAdmin(playerid) {
    return (serverAdmins.find(getPlayerSerial(playerid)) != null);
}

event("onPlayerTeleportRequested", function(playerid, x, y, z) {
    // msg("Teleporting to: ", [x, y, z]);
    setPlayerPosition(playerid, x, y, z);
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
