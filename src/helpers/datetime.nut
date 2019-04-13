function getRealTime() {
    local t = time();
    local minute = (t / 60) % 60;
    local hour = ((t / 3600) % 24) + 3;
    if(hour >= 24) hour -= 24;
    return format("%s:%s", addFirstZero(hour), addFirstZero(minute));
}

function getRealDate() {
    local d = date();
    return format("%s.%s.%d", addFirstZero(d.day), addFirstZero(d.month), d.year);
}

function getRealDateTime () {
    return getRealDate()+" "+getRealTime();
}

function addFirstZero(n) {
    if(n < 10) {
        return "0"+n;
    }
    return n.tostring();
}



local LEAPOCH = (946684800 + 86400*(31+29))

local DAYS_PER_400Y = (365*400 + 97)
local DAYS_PER_100Y = (365*100 + 24)
local DAYS_PER_4Y   = (365*4   + 1)

/**
 * Convert timestamp to human readable date
 * @param  {integer} t seconds
 * @return {object}    date and time
 */
function epochToHuman(t) {

    // +3 hours by Moscow timezone
    t = t + 10800;

    local days_in_month = [31,30,31,30,31,31,30,31,30,31,31,29];

    local secs = t - LEAPOCH;
    local days = secs / 86400;
    local remsecs = secs % 86400;
    if (remsecs < 0) {
        remsecs += 86400;
        days--;
    }

    local wday = (3+days)%7;
    if (wday < 0) wday += 7;

    local qc_cycles = days / DAYS_PER_400Y;
    local remdays = days % DAYS_PER_400Y;
    if (remdays < 0) {
        remdays += DAYS_PER_400Y;
        qc_cycles--;
    }

    local c_cycles = remdays / DAYS_PER_100Y;
    if (c_cycles == 4) c_cycles--;
    remdays -= c_cycles * DAYS_PER_100Y;

    local q_cycles = remdays / DAYS_PER_4Y;
    if (q_cycles == 25) q_cycles--;
    remdays -= q_cycles * DAYS_PER_4Y;

    local remyears = remdays / 365;
    if (remyears == 4) remyears--;
    remdays -= remyears * 365;

    local leap = (!remyears && (!q_cycles || !c_cycles)).tointeger();
    local yday = remdays + 31 + 28 + leap;

    if (yday >= 365+leap) yday -= 365+leap;

    local years = remyears + 4*q_cycles + 100*c_cycles + 400*qc_cycles;
    local months = 0;

    for ( months = 0; days_in_month[months] <= remdays; ++months) {
        remdays -= days_in_month[months];
    }

    local res = {
        y = years + 2000,
        mh = months + 2,
    }

    if (res.mh >= 12) {
        res.mh -=12;
        res.y++;
    }

    res.leap <- leap;

    res.mh++; // for jan == 1, feb == 2
    res.mday <- remdays + 1;
    res.wday <- wday;
    res.yday <- yday + 1;

    res.h <- remsecs / 3600;
    res.m <- remsecs / 60 % 60;
    res.s <- remsecs % 60;

    res.format <- function(format) {
        local string = format;
        string = str_replace_ex("H", addFirstZero(res.h), string);
        string = str_replace_ex("G", res.h, string);
        string = str_replace_ex("i", addFirstZero(res.m), string);
        string = str_replace_ex("s", addFirstZero(res.s), string);

        string = str_replace_ex("Y", res.y, string);
        string = str_replace_ex("n", res.mh, string);
        string = str_replace_ex("j", res.mday, string);
        string = str_replace_ex("m", addFirstZero(res.mh), string);
        string = str_replace_ex("d", addFirstZero(res.mday), string);

        string = str_replace_ex("w", res.wday, string); // 1 - 7
        string = str_replace_ex("z", res.yday, string); // day of the year (1 - 366)
        string = str_replace_ex("L", res.leap, string); // leap year: 1 or 0

        return string;
    };

    return res;
}

function convertDateToTimestamp(date) {
    local dateArray = split(date,".");
    return dateArray[0].tointeger() + dateArray[1].tointeger()*30 + dateArray[2].tointeger()*360;
}
