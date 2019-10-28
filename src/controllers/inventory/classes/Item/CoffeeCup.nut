class Item.CoffeeCup extends Item.Drink  {

    static classname = "Item.CoffeeCup";
    handsOnly = true;
    destroyOnDrop = true;

    static function getType() {
        return "Item.CoffeeCup";
    }

    constructor () {
        base.constructor();
        this.volume = 0.5475;
        this.amount = 25.0
    }

    function drop(playerid, inventory) {
        msgr(playerid, "inventory.coffee.crashed", [], 10, CL_WHITE);
    }
}

alternativeTranslate({
    "en|inventory.coffee.crashed" : "Сup of coffee slipped out of hands and crashed"
    "ru|inventory.coffee.crashed" : "Чашка кофе выскользнула из рук и разбилась"
});
