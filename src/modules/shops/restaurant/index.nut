const EAT_COST = 0.35;
const DRINK_COST = 0.15;
const MAX_HEALTH = 800.0;

translation("en", {
    "shops.restaurant.toofar"               : "[INFO] You're too far."
    "shops.restaurant.money.notenough"      : "Not enough money to buy that."
    "shops.restaurant.diner.eat.success"    : "You've spend $%.2f on diner."
    "shops.restaurant.bar.drink.success"    : "You've spend $%.2f for beer."
    // "shops.restaurant.diner.eat.success"    : "You've eaten some food (free)."
    // "shops.restaurant.bar.drink.success"    : "You've drunk some beer (free)."
});

/**
 * Some actions on call eat function call
 * @param  {[type]} playerid [description]
 * @return {[type]}          [description]
 */
function onEating(playerid) {
    subMoneyToPlayer(playerid, EAT_COST);
    addMoneyToTreasury(EAT_COST);
    msg(playerid, "shops.restaurant.diner.eat.success", [EAT_COST], CL_SUCCESS);
    // return setPlayerHealth(playerid, MAX_HEALTH);
    addPlayerHunger(playerid, randomf(30.0, 40.0));
}

/**
 * Some actions on call drink function call
 * @param  {[type]} playerid [description]
 * @return {[type]}          [description]
 */
function onDrinking(playerid) {
    subMoneyToPlayer(playerid, DRINK_COST);
    addMoneyToTreasury(DRINK_COST);
    msg(playerid, "shops.restaurant.bar.drink.success", [DRINK_COST], CL_SUCCESS);
    // setPlayerHealth(playerid, MAX_HEALTH);
    addPlayerThirst(playerid, randomf(30.0, 40.0));
}

cmd("eat", function(playerid) {
    local bid = getBusinessNearPlayer(playerid);

    if ( getBusinessType(bid) == 1 ) {
        if (canMoneyBeSubstracted(playerid, EAT_COST)) {
            return onEating(playerid);
        }
        return msg(playerid, "shops.restaurant.money.notenough"); // !
    } else {
        return msg(playerid, "shops.restaurant.toofar");
    }
});

cmd("drink", function(playerid) {
    local bid = getBusinessNearPlayer(playerid);

    if ( getBusinessType(bid) == 2 ) {
        if (canMoneyBeSubstracted(playerid, DRINK_COST)) {
            return onDrinking(playerid);
        }
        return msg(playerid, "shops.restaurant.money.notenough"); // !
    } else {
        return msg(playerid, "shops.restaurant.toofar");
    }
});
