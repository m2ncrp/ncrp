class Item.Cigarettes extends Item.Abstract
{
    static classname = "Item.Cigarettes";
    volume = 0.025;
    effect = 0;
    timeout = 0;
    steps = 4;
    addiction = 0;
    counter = 0;

    function use(playerid, inventory) {
        msg(playerid, format("Вы выкурили: %s", plocalize(playerid, this.classname)));
        inventory.remove(this.slot).remove();
        inventory.sync();
        hungerUp(playerid, inventory);
    }

    function hungerUp (playerid, inventory) {
        if(counter == this.steps) {
            return;
        }
        this.counter += 1;
        addPlayerHunger(playerid, this.effect);
        local self = this;
        delayedFunction(150000, function () {
            self.hungerUp(playerid, inventory);
        });
    }

    static function getType() {
        return "Item.Cigarettes";
    }
}
