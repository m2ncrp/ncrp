class Item.Race extends Item.Abstract
{
    static classname = "Item.Race";
    default_decay = 0;
    volume        = 0.05;

    function use(playerid, inventory) {

        local members   = this.data.members;
        //local cars      = this.data.cars;
        //local date      = this.data.date;
        //local time      = this.data.time;
        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "Item.Race", CL_HELP_TITLE);
        msg(playerid, "Название гонки: "+this.data.name, CL_CASCADE );
        foreach (carNumber, member in members) {
            local message = format("RACE0%s: %s (charId: %d)", carNumber, member[1], member[0]);
            msg(playerid, message, CL_CASCADE );
        }
    }

    static function getType() {
        return "Item.Race";
    }
}

