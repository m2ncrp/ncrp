include("modules/shops/restaurant/commands.nut");

const EAT_COST = 0.25;
const DRINK_COST = 0.1;
const MAX_HEALTH = 800.0;

translation("en", {
    "shops.restaurant.toofar"               : "[INFO] You're too far.",
    // "shops.restaurant.diner.eat.success"    : "You've spend $%.2f on diner.",
    // "shops.restaurant.bar.drink.success"    : "You've spend $%.2f for beer."
    "shops.restaurant.diner.eat.success"    : "You've eaten some food (free).",
    "shops.restaurant.bar.drink.success"    : "You've drunk some beer (free).",
});

translation("ru", {
    "shops.restaurant.toofar"               : "[INFO] Вы слишком далеко.",
    "shops.restaurant.diner.eat.success"    : "Вы потратили $%.2f на еду.",
    "shops.restaurant.bar.drink.success"    : "Вы потратили $%.2f на пиво."
});

/**
 * Some actions on call eat function call
 * @param  {[type]} playerid [description]
 * @return {[type]}          [description]
 */
function onEating(playerid) {
    msg(playerid, "shops.restaurant.diner.eat.success", [EAT_COST], CL_SUCCESS);
    return setPlayerHealth(playerid, MAX_HEALTH);
}

function eat(playerid) {
    local bid = getBusinessNearPlayer(playerid);
    if ( getBusinessType(bid) == 1 ) {
        return onEating(playerid);
    } else {
        return msg(playerid, "shops.restaurant.toofar");
    }
}


/**
 * Some actions on call drink function call
 * @param  {[type]} playerid [description]
 * @return {[type]}          [description]
 */
function onDrinking(playerid) {
    msg(playerid, "shops.restaurant.bar.drink.success", [DRINK_COST], CL_SUCCESS);
    return setPlayerHealth(playerid, MAX_HEALTH);
}

function drink(playerid) {
    local bid = getBusinessNearPlayer(playerid);
    if ( getBusinessType(bid) == 2 ) {
        return onDrinking(playerid);
    } else {
        return msg(playerid, "shops.restaurant.toofar");
    }
}
