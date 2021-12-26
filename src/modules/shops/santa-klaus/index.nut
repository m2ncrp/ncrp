include("modules/shops/santa-klaus/letter-points.nut");

local SANTA_X = -330.915;
local SANTA_Y = 210.595;
local SANTA_Z = -4.59302;
local SANTA_RADIUS = 2.0;
local timestampStart = 1640584800; // real
// local timestampStart = 1640549267; // fake


alternativeTranslate({
    "en|santa.gift.elveslost"        :  "A terrible thing happened - the elves lost several bags of letters."
    "ru|santa.gift.elveslost"        :  "Случилось страшное - эльфы потеряли несколько мешков с письмами для Санты."

    "en|santa.gift.needed"           :  "You need to help them find %d %s of Santa on the city's streets and bring them here."
    "ru|santa.gift.needed"           :  "Нужно помочь им отыскать их. Найди %d %s Санты на улицах города и принеси их сюда."

    "en|santa.gift.maxcount"         :  "You did a good job and helped the elves enough. See you next year!"
    "ru|santa.gift.maxcount"         :  "Вы хорошо постарались и достаточно помогли эльфам. До встречи в следующем году!"

    "en|santa.letter.use"            :  "This is one of Santa's lost letters!"
    "ru|santa.letter.use"            :  "Это одно из потерянных писем Санты!"

    "en|santa.gift.get"              :  "You gave 5 found letters and received a gift."
    "ru|santa.gift.get"              :  "Вы отдали 5 найденных писем и получили подарок."
});

event("onServerPlayerStarted", function(playerid) {
    if(isNewYear2022EventStarted()) {
        createPrivateBlip(playerid, SANTA_X, SANTA_Y, ICON_CUP,ICON_RANGE_FULL);
        createPrivate3DText(playerid, SANTA_X, SANTA_Y, SANTA_Z+0.35, plocalize(playerid, "3dtext.newyear.gifts"), CL_FLAMINGO, 3.0 );
        createPrivate3DText(playerid, SANTA_X, SANTA_Y, SANTA_Z+0.20, plocalize(playerid, "3dtext.job.press.action"), CL_WHITE.applyAlpha(150), SANTA_RADIUS );
    }
})

function isNewYear2022EventStarted() {
    local currentTimestamp = getTimestamp();
    return timestampStart <= currentTimestamp;
}

function setSantaFutureTimestamp() {
    timestampStart = getTimestamp() + 5;
}

local options = [
    {
        "item": "XmasBall",
        "weight": 0.067568,
    },
    {
        "item": "XmasBells",
        "weight": 0.067568,
    },
    {
        "item": "XmasCandle",
        "weight": 0.067568,
    },
    {
        "item": "XmasCane",
        "weight": 0.067568,
    },
    {
        "item": "XmasCookieMan",
        "weight": 0.067568,
    },
    {
        "item": "XmasCookiesAndMilk",
        "weight": 0.067568,
    },
    {
        "item": "XmasCookieStar",
        "weight": 0.067568,
    },
    {
        "item": "XmasDeer",
        "weight": 0.036036,
    },
    {
        "item": "XmasElf",
        "weight": 0.031532,
    },
    {
        "item": "XmasHat",
        "weight": 0.040541,
    },
    {
        "item": "XmasHolly",
        "weight": 0.067568,
    },
    {
        "item": "XmasMittens",
        "weight": 0.040541,
    },
    {
        "item": "XmasSanta",
        "weight": 0.027027,
    },
    {
        "item": "XmasSign",
        "weight": 0.004505,
    },
    {
        "item": "XmasSnowflake",
        "weight": 0.067568,
    },
    {
        "item": "XmasSnowGlobe",
        "weight": 0.013514,
    },
    {
        "item": "XmasSnowman",
        "weight": 0.036036,
    },
    {
        "item": "XmasSock",
        "weight": 0.040541,
    },
    {
        "item": "XmasStar",
        "weight": 0.090090,
    },
    {
        "item": "XmasTree",
        "weight": 0.031532,
    },
];

function generateNewYearGiftName() {
    return weightedRandom(options);
}

event("onServerSecondChange", function() {

    local currentTimestamp = getTimestamp(); // GTM 0

    if(!isNewYear2022EventStarted()) return;

    if(currentTimestamp == timestampStart) {
        for (local idx = 0; idx < 30; idx++) {
            local giftPos = getLetterPosition(idx)

            trigger("onSpawnNewYearLetter", giftPos[0], giftPos[1], giftPos[2])
        }
        dbg("spawn gifts");
    }

    local dayAfterStart = ceil((currentTimestamp - timestampStart).tofloat() / 86400);
    local h = floor(currentTimestamp % 86400 / 3600 );
    local m = floor(currentTimestamp % 3600 / 60);
    local s = floor(currentTimestamp % 3600 % 60);

    if(h >= 6 && h <= 20 && m == 30 && s == 0) {
        local hIndex = h - 6;

        local id1 = 30 * dayAfterStart + 2 * hIndex;
        local id2 = id1 + 1;

        local giftPos1 = getLetterPosition(id1);
        local giftPos2 = getLetterPosition(id2);
        if(!giftPos1 || !giftPos2) {
            dbg("chat", "report", "Santa Event", "@Fernando#8366 Letters are over");
            return;
        }
        trigger("onSpawnNewYearLetter", giftPos1[0], giftPos1[1], giftPos1[2])
        trigger("onSpawnNewYearLetter", giftPos2[0], giftPos2[1], giftPos2[2])
        dbg("chat", "report", "Santa Event", format("@Fernando#8366 spawn letter: %d", id1));
        dbg("chat", "report", "Santa Event", format("@Fernando#8366 spawn letter: %d", id2));
    }

    //dbg(format("%d:%d:%d", h, m, s))
});

key("e", function(playerid) {
    if(!isPlayerInValidPoint(playerid, SANTA_X, SANTA_Y, SANTA_RADIUS)) {
        return;
    }

    if(!isNewYear2022EventStarted()) return;

    if (players[playerid].getData("gift-ny22") == 3) {
        return msg(playerid, "santa.gift.maxcount", CL_WARNING)
    }

    local letterSlots = [];
    foreach(idx, item in players[playerid].inventory) {
        if (item instanceof Item.SantaLetter) {
            letterSlots.push(item.slot)
        }
    }

    local lettersCount = letterSlots.len();

    if(lettersCount < 5) {
        local lettersNeeded = 5 - lettersCount;
        local lang = getPlayerLocale(playerid);
        local titles = lang == "ru" ? ["письмо", "письма", "писем"] : ["letter", "letters", "letters"];
               msg(playerid, "santa.gift.elveslost", CL_INFO);
        return msg(playerid, "santa.gift.needed", [lettersNeeded, declOfNum(lettersNeeded, titles)], CL_WARNING);
    }

    local gift = Item.XmasGift();

    if (!players[playerid].inventory.isFreeVolume(gift)) {
        return msg(playerid, "inventory.volume.notenough", CL_ERROR);
    }

    try {

        for (local idx = 0; idx < 5; idx++) {
            players[playerid].inventory.remove(letterSlots[idx]).remove();
        }

        players[playerid].inventory.push(gift);
        players[playerid].inventory.sync();
        gift.save();

        local giftsReceived = 1;
        if(players[playerid].hasData("gift-ny22")) {
            giftsReceived = players[playerid].getData("gift-ny22") + 1;
        }
        players[playerid].setData("gift-ny22", giftsReceived);

        dbg("chat", "report", getPlayerName(playerid), format("received gift %d/3", giftsReceived));

        return msg(playerid, "santa.gift.get", CL_SUCCESS);

    } catch (e) {
        dbg("chat", "report", getPlayerName(playerid), format("@Fernando#8366 Error: %s", e));
        msg(playerid, format("Ошибка: %s", e), CL_ERROR);
        msg(playerid, "Напиши в Discord в канал #проблемы", CL_ERROR);
        return false;
    }

});

acmd("ny", function(playerid, id) {
    id = id.tointeger();
    local letterPos = getLetterPosition(id);
    if (letterPos) {
        setPlayerPosition(playerid, letterPos[0], letterPos[1], letterPos[2]);
    }
})


    // local res = {};
    // for (local index = 0; index < 6000; index++) {
    //     local veh = weightedRandom(options);

    //     if (veh in res) {
    //         res[veh]++;
    //     } else {
    //         res[veh] <- 1;
    //     }
    // }

    // dbg(res)