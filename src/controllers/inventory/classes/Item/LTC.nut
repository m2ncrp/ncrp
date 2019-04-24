class Item.LTC extends Item.Abstract
{
    static classname = "Item.LTC";
    volume      = 0.05;

    function use(playerid, inventory) {
        msg(playerid, "===========================================", CL_HELP_LINE);
        msg(playerid, "ltc.info.title"         , CL_HELP_TITLE);
        msg(playerid, "ltc.info.number"        , [ this.data["number"] ], CL_WHITE);
        msg(playerid, "ltc.info.fio"           , [ this.data["fio"] ], CL_WHITE);
        msg(playerid, "ltc.info.issued"        , [ this.data["issued"] ], CL_WHITE);
        msg(playerid, "ltc.info.expires"       , [ this.data["expires"] ], CL_WHITE);
    }

    static function getType() {
        return "Item.LTC";
    }
}
