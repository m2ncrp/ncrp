class World extends ORM.Entity
{
    static classname = "World";
    static table = "tbl_worlds";

    static fields = [
        ORM.Field.Integer({ name = "second" }),
        ORM.Field.Integer({ name = "minute" }),
        ORM.Field.Integer({ name = "hour" }),
        ORM.Field.Integer({ name = "day" }),
        ORM.Field.Integer({ name = "month" }),
        ORM.Field.Integer({ name = "year" })
    ];

    function sendToClient(playerid) {
        // triggerClientEvent(playerid, "onServerTimeSync", this.minute, this.hour, this.day, this.month, this.year.tostring());
        trigger(playerid, "onServerIntefaceTime",
            format("%02d:%02d", this.hour, this.minute),
            format("%02d.%02d.%04d", this.day, this.month, this.year)
        );
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
        trigger("onServerSecondChange");
        this.second++;
        if (this.second >= WORLD_SECONDS_PER_MINUTE) {
            this.second = 0;
            this.onMinuteChange();
        }
    }

    function onMinuteChange()
    {
        trigger("onServerMinuteChange");
        this.minute++;
        if (this.minute >= WORLD_MINUTES_PER_HOUR) {
            this.minute = 0;
            this.onHourChange();
        }

        this.sendToAllClients();

        if (!(this.minute % AUTOSAVE_TIME)) {
            trigger("onServerAutosave");
        }

        // save ourself
        this.save();
    }

    function onHourChange()
    {
        trigger("onServerHourChange");
        this.hour++;
        if (this.hour >= WORLD_HOURS_PER_DAY) {
            this.hour = 0;
            this.onDayChange();
        }

        trigger("weather:onPhaseChange", this.hour);
    }

    function onDayChange()
    {
        trigger("onServerDayChange");
        this.day++;
        if (this.day >= WORLD_DAYS_PER_MONTH) {
            this.day = 1;
            this.onMonthChange();
        }
    }

    function onMonthChange()
    {
        trigger("onServerMonthChange");
        this.month++;
        if (this.month >= WORLD_MONTH_PER_YEAR) {
            this.month = 1;
            this.onYearChange();
        }
    }

    function onYearChange()
    {
        trigger("onServerYearChange");
        this.year++;
    }
}
