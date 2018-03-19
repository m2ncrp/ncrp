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
