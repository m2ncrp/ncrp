class Item.Food extends Item.Abstract
{
    static classname = "Item.Food";
    animation = "DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.LOCKED)end, function(l_2_0)return game.game:GetActivePlayer():AnimPlay(\"sc_eat_ham_out\", false)end, function(l_2_0)return game.game:GetActivePlayer():ModelToHands(true,1,1) end, function(l_8_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.FREE)end}) end,{l_1_0},0,1,false)";
    // анимация поедания
    model = 1;
    // id модельки в руке из внутриигровых таблиц
    animation_sync = "DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_2_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"sc_eat_ham_out\", false)end}) end,{l_1_0},0,1,false)";
    // версия для отражения другим клиентам

    static function getType() {
        return "Item.Food";
    }

    function use(playerid, inventory) {
         if (isPlayerInVehicle(playerid) == false) { // если игрок в машине, то не запускаем анимацию
            triggerClientEvent(playerid, "edible", animation, model); // клиентское событие для отображения анимации поедания
            foreach (id, player in players) { // бежим по всем игрокам на сервере
                triggerClientEvent(id, "edible_sync", format(animation_sync, playerid), model, playerid); // клиентское событие для отображения анимации поедания на чужих клиентах
            }
        }
        msg(playerid, format("Вы съели: %s", plocalize(playerid, this.classname)));

        addPlayerHunger(playerid, randomf(this.amount - 5.0, this.amount + 5.0));
        inventory.remove(this.slot).remove();
        inventory.sync();
    }
    function useGround(playerid) {
      msg(playerid, "You are loser");
    }
}
