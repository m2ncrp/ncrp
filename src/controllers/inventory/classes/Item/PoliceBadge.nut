class Item.PoliceBadge extends Item.Abstract
{
    static classname = "Item.PoliceBadge";
    volume      = 0.0212;

    function use(playerid, inventory) {
        local radius = 3.0;
        msgr(playerid, "===========================================", null, CL_HELP_LINE, radius);
        msgr(playerid, "policebadge.title", null, CL_HELP_LINE, radius);
        msgr(playerid, this.data["fio"], null, CL_WHITE, radius);
        msgr(playerid, "policebadge.info.number", [ this.data["number"] ], CL_WHITE, radius);
    }

    static function getType() {
        return "Item.PoliceBadge";
    }
}
