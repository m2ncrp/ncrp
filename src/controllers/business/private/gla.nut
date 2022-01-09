event("onServerStarted", function() {
    createBlip( -850.381,-386.834, [ 25, 0 ], ICON_RANGE_VISIBLE );
    createPlace("GreenLightAuto", -829.841,-400.898, -873.108,-350.735);
});

event("onPlayerAreaEnter", function(playerid, name) {
    if (name == "GreenLightAuto") {
        msg(playerid, "Добро пожаловать в Green Light Auto - дилерский центр, специализирующийся на покупке и продаже подержанных автомобилей.", CL_JADE);
        msg(playerid, "Мы работаем индивидуально с каждым клиентом, но пока не можем обеспечить круглосуточную работу нашего центра. Если наших менеджеров нет на месте, загляните позднее.", CL_CASCADE);
    }
});