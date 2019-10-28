class Item.PoliceBadge extends Item.Abstract
{
    static classname = "Item.PoliceBadge";
    volume      = 0.0212;

    function use(playerid, inventory) {
        local radius = 3.0;
        msgr(playerid, "===========================================", null, radius, CL_HELP_LINE);
        msgr(playerid, "policebadge.title", null, radius, CL_HELP_LINE);
        msgr(playerid, this.data["fio"], null, radius, CL_WHITE);
        msgr(playerid, "policebadge.info.number", [ this.data["number"] ], radius, CL_WHITE);
    }

    static function getType() {
        return "Item.PoliceBadge";
    }
}
