class Item.PoliceBadge extends Item.Abstract
{
    static classname = "Item.PoliceBadge";
    volume      = 0.2;

    function use(playerid, inventory) {
        local radius = 5.0;
        sendMsgToAllInRadius(playerid, "===========================================", null, CL_HELP_LINE, radius);
        sendMsgToAllInRadius(playerid, "policebadge.title", null, CL_HELP_LINE, radius);
        sendMsgToAllInRadius(playerid, "policebadge.info.number", [ this.data["number"] ], CL_WHITE, radius);
    }

    static function getType() {
        return "Item.PoliceBadge";
    }
}
