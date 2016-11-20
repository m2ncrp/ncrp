class World {
    time = null;

    constructor () {
        this.time = {second = 0, minute = 58, hour = 23, day = 13, month = 6, year = 1952};
    }

    function sendToClient(playerid)
    {
        local t = this.time;
        triggerClientEvent(playerid, "onServerTimeSync", t.minute, t.hour, t.day, t.month, t.year.tostring());
    }

    function sendToAllClients()
    {
        local self = this;

        playerList.each(function(playerid) {
            self.sendToClient(playerid);
        });
    }

    function onSecondChange()
    {
        triggerServerEventEx("onServerSecondChange");
        this.time.second++;
        if (this.time.second >= WORLD_SECONDS_PER_MINUTE) {
            this.time.second = 0;
            this.onMinuteChange();
        }
    }

    function onMinuteChange()
    {
        triggerServerEventEx("onServerMinuteChange");

        this.time.minute++;
        if (this.time.minute >= WORLD_MINUTES_PER_HOUR) {
            this.time.minute = 0;
            this.onHourChange();
        }

        this.sendToAllClients();

        if (!(this.time.minute % AUTOSAVE_TIME)) {
            triggerServerEventEx("onServerAutosave");
        }
    }

    function onHourChange()
    {
        triggerServerEventEx("onServerHourChange");

        this.time.hour++;
        if (this.time.hour >= WORLD_HOURS_PER_DAY) {
            this.time.hour = 0;
            this.onDayChange();
        }

        triggerServerEventEx("weather:onPhaseChange", this.time.hour);
    }

    function onDayChange()
    {
        triggerServerEventEx("onServerDayChange");

        this.time.day++;
        if (this.time.day >= WORLD_DAYS_PER_MONTH) {
            this.time.day = 1;
            this.onMonthChange();
        }
    }

    function onMonthChange()
    {
        triggerServerEventEx("onServerMonthChange");

        this.time.month++;
        if (this.time.month >= WORLD_MONTH_PER_YEAR) {
            this.time.month = 1;
            this.onYearChange();
        }
    }

    function onYearChange()
    {
        triggerServerEventEx("onServerYearChange");

        this.time.year++;
    }
}
