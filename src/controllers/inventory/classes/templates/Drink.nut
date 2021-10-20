class Item.Drink extends Item.Abstract
{
    static classname = "Item.Drink";
    animation = "DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.LOCKED)end, function(l_2_0)return game.game:GetActivePlayer():AnimPlay(\"sc_drink_bottle_out\", false)end, function(l_8_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.FREE)end}) end,{l_1_0},0,1,false)";
    // анимация питья
    animation_sync = "DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"sc_drink_bottle_out\", false)end}) end,{l_1_0},0,1,false)";
    // id модельки в руке из внутриигровых таблиц
    model = 0;
    // версия для отражения другим клиентам

    static function getType() {
        return "Item.Drink";
    }

    function use(playerid, inventory) {
        if (isPlayerInVehicle(playerid) == false) { // если игрок в машине, то не запускаем анимацию
            triggerClientEvent(playerid, "drinkable", animation, model); // клиентское событие для отображения анимации питья
            foreach (id, player in players) { // бежим по всем игрокам на сервере
                triggerClientEvent(id, "drinkable_sync", format(animation_sync, playerid), model, playerid); // клиентское событие для отображения анимации питья на чужих клиентах
            }
        }
        msg(playerid, format("Вы выпили: %s", plocalize(playerid, this.classname)));

        addPlayerThirst(playerid, randomf(this.amount - 5.0, this.amount + 5.0));
        inventory.remove(this.slot).remove();
        inventory.sync();
    }
}
