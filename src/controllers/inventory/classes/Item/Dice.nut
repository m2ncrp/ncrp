class Item.Dice extends Item.Abstract
{
    static classname = "Item.Dice";

    static function getType() {
        return "Item.Dice";
    }

    function use(playerid, inventory) {
        local dice = random(1, 6);
        msgr(playerid, "utils.diсe", [ getAuthor2(playerid), dice ], CL_WHITE, 10);
    }
}

alternativeTranslate({
    "en|utils.diсe"            : "%s threw the dice: %d"
    "ru|utils.diсe"            : "%s бросил игральный кубик и тот выпал на цифру: %d"
});
