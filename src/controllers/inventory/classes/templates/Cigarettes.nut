class Item.Cigarettes extends Item.Abstract
{
    static classname = "Item.Cigarettes";
    volume = 0.09504;
    effect = 0;
    timeout = 0;
    steps = 4;
    addiction = 0;
    counter = 0;
    animation = "DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{ function(l_1_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.LOCKED)end, function(l_2_0)return game.game:GetActivePlayer():AnimPlay(\"sc_man_smoke_in\", false)end, function(l_3_0)return game.game:GetActivePlayer():AnimPlay(\"sc_man_smoke_stat_a\", false)end, function(l_4_0)return game.game:GetActivePlayer():AnimPlay(\"sc_man_smoke_stat_b\", false)end, function(l_5_0)return game.game:GetActivePlayer():AnimPlay(\"sc_man_smoke_stat_c\", false)end, function(l_6_0)return game.game:GetActivePlayer():AnimPlay(\"sc_man_smoke_stat_d\", false)end, function(l_7_0)return game.game:GetActivePlayer():AnimPlay(\"sc_man_smoke_out\", false)end, function(l_8_0)return game.game:GetActivePlayer():SetControlStyle(enums.ControlStyle.FREE)end}) end,{l_1_0},500,1,false)";
    // большой скрипт с анимацией
    animation_sync = "DelayBuffer:Insert(function(l_1_0) CommandBuffer:Insert(l_6_0,{function(l_3_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"sc_man_smoke_in\", false)end, function(l_3_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"sc_man_smoke_stat_a\", false)end, function(l_3_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"sc_man_smoke_stat_b\", false)end, function(l_3_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"sc_man_smoke_stat_c\", false)end, function(l_3_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"sc_man_smoke_stat_d\", false)end, function(l_3_0)return game.entitywrapper:GetEntityByName(\"m2online_ped_%d\"):AnimPlay(\"sc_man_smoke_out\", false)end}) end,{l_1_0},500,1,false)";
    // версия для отражения другим клиентам

    function use(playerid, inventory) {
        msg(playerid, format("Вы выкурили: %s", plocalize(playerid, this.classname)));
        if (isPlayerInVehicle(playerid) == false) { // если игрок в машине - не проигрываем анимацию
            triggerClientEvent(playerid, "animate", animation); // Клиентский ивент с отображением анимации на себе
            foreach (id, player in players) { // бежим по всем игрокам на сервере
                triggerClientEvent(id, "sync_animation", format(animation_sync, playerid, playerid, playerid, playerid, playerid, playerid)); // Клиентский ивент с отображением анимации на остальных клиентах
            }
        }
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
