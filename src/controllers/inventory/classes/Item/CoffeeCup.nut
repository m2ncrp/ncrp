class Item.CoffeeCup extends Item.Drink  {

    static classname = "Item.CoffeeCup";
    handsOnly = true;
    destroyOnDrop = true;
    model = 131; // id модельки в руке из внутриигровых таблиц
    animation = "DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.LOCKED)end, function(l_2_0)return game.game:GetActivePlayer():AnimPlay(\"sc_drink_coffee_out\", false)end, function(l_8_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.FREE)end}) end,{l_1_0},0,1,false)";
    // для кофе используем спец. скрипт на анимации
    animation_sync = "DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"sc_drink_coffee_out\", false)end}) end,{l_1_0},0,1,false)";

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
