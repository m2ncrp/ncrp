class Item.Cigarettes extends Item.Abstract
{
    static classname = "Item.Cigarettes";
    hasAnimation = true;
    volume = 0.09504;
    effect = 0;
    timeout = 0;
    steps = 4;
    addiction = 0;
    counter = 0;
    anim_len = 41000;

    function use(playerid, inventory) {
        msg(playerid, format("Вы выкурили: %s", plocalize(playerid, this.classname)));
        this.animate(playerid, "Use" + this.getType(), this.model);
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
