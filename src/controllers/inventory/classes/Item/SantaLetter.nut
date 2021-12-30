class Item.SantaLetter extends Item.Abstract
{
    static classname = "Item.SantaLetter";

    default_decay = 0;
    volume = 0.01;

    function use(playerid, inventory) {
        msg(playerid, "santa.letter.use", CL_INFO);
    }

    static function getType() {
        return "Item.SantaLetter";
    }
}
