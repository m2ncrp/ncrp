class Item.CoffeeCup extends Item.Drink  {

    static classname = "Item.CoffeeCup";
    handsOnly = true;

    static function getType() {
        return "Item.CoffeeCup";
    }

    constructor () {
        base.constructor();
        this.volume = 0.5475;
        this.amount = 25.0
    }

    function drop(playerid, inventory) {
        base.drop(playerid, inventory);
        msgr(playerid, "inventory.coffee.crashed", [], CL_WHITE, 10);
    }
}

alternativeTranslate({
    "en|inventory.coffee.crashed" : "Сup of coffee slipped out of hands and crashed"
    "ru|inventory.coffee.crashed" : "Чашка кофе выскользнула из рук и разбилась"
});
