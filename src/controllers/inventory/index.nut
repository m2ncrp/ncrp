include("controllers/inventory/classes");
include("controllers/inventory/inventories.nut");
// include("controllers/inventory/functions.nut"); // refactor

local inventory_script;
local inventory_cache = {};

event("onServerStarted", function() {
    logger.log("starting inventory...");
});

/**
 * Try to load player inventory
 * on player connected
 */
event("onServerPlayerStarted", function(playerid) {
    local character = players[playerid];

    if (!(character.id in inventory_cache)) {
        local body = PlayerItemContainer(playerid);
        local hand = PlayerHandsContainer(playerid);

        ORM.Query("select * from tbl_items where parent = :id and state in (:states)")
            .setParameter("id", character.id)
            .setParameter("states", concat([Item.State.PLAYER, Item.State.PLAYER_HAND], ","), true)
            .getResult(function(err, items) {
                foreach (idx, item in items) {
                    if (item.state == Item.State.PLAYER_HAND) {
                        hand.set(item.slot, item);
                        continue;
                    }

                    body.set(item.slot, item);
                }
            });

        inventory_cache[character.id] <- {
            body = body, hand = hand
        };
    }
    else {
        inventory_cache[character.id].body.parent = character;
        inventory_cache[character.id].hand.parent = character;
    }

    character.inventory = inventory_cache[character.id].body;
    character.hands     = inventory_cache[character.id].hand;
});

event("native:inventory:loaded", function(playerid) {
    delayedFunction(1500, function() {
        players[playerid].hands.show(playerid);
        players[playerid].inventory.blocked = false;
    });
});

/**
 * Try to save player's items on character save
 */
event("onCharacterSave", function(playerid, character) {
    foreach (idx, item in character.inventory) item.save();
    foreach (idx, item in character.hands) item.save();
});

key("i", function(playerid) {
    if (isPlayerAdmin(playerid)) return;

    if (!players[playerid].inventory.blocked) {
        players[playerid].inventory.toggle(playerid);
    }
});

key("tab", function(playerid) {
    if (!players[playerid].inventory.blocked) {
        players[playerid].inventory.toggle(playerid);
    }
});

alternativeTranslate({
    "en|Item.None"             : ""
    "en|Item.Revolver12"       : "Revolver 12"
    "en|Item.MauserC96"        : "Mauser C96"
    "en|Item.ColtM1911A1"      : "Colt M1911 A1"
    "en|Item.ColtM1911Spec"    : "Colt M1911 Special"
    "en|Item.Revolver19"       : "Revolver 19"
    "en|Item.MK2"              : "MK2"
    "en|Item.Remington870"     : "Remington 870"
    "en|Item.M3GreaseGun"      : "MP Grease Gun"
    "en|Item.MP40"             : "MP-40"
    "en|Item.Thompson1928"     : "Thompson 1928"
    "en|Item.M1A1Thompson"     : "M1A1 Thompson"
    "en|Item.Beretta38A"       : "Beretta 38A"
    "en|Item.MG42"             : "MG-42"
    "en|Item.M1Garand"         : "M1 Garand"
    "en|Item.Kar98k"           : "Kar 98k"
    "en|Item.Molotov"          : "Molotov"
    "en|Item.Ammo45ACP"        : "Ammo .45 ACP"
    "en|Item.Ammo357magnum"    : "Ammo .357 Mangum"
    "en|Item.Ammo12mm"         : "Ammo 12 mm"
    "en|Item.Ammo9x19mm"       : "Ammo 9x19 mm"
    "en|Item.Ammo792x57mm"     : "Ammo 7.92x57 mm"
    "en|Item.Ammo762x63mm"     : "Ammo 7.62x63 mm"
    "en|Item.Ammo38Special"    : "Ammo .38 Special"
    "en|Item.Clothes"          : "Clothes"
    "en|Item.Burger"           : "Burger"
    "en|Item.Hotdog"           : "Hotdog"
    "en|Item.Sandwich"         : "Sandwich"
    "en|Item.Cola"             : "Cola"
    "en|Item.Jerrycan"         : "Jerrycan"

    "ru|Item.None"             : ""
    "ru|Item.Revolver12"       : "Revolver 12"
    "ru|Item.MauserC96"        : "Mauser C96"
    "ru|Item.ColtM1911A1"      : "Colt M1911 A1"
    "ru|Item.ColtM1911Spec"    : "Colt M1911 Special"
    "ru|Item.Revolver19"       : "Revolver 19"
    "ru|Item.MK2"              : "MK2"
    "ru|Item.Remington870"     : "Remington 870"
    "ru|Item.M3GreaseGun"      : "MP Grease Gun"
    "ru|Item.MP40"             : "MP-40"
    "ru|Item.Thompson1928"     : "Thompson 1928"
    "ru|Item.M1A1Thompson"     : "M1A1 Thompson"
    "ru|Item.Beretta38A"       : "Beretta 38A"
    "ru|Item.MG42"             : "MG-42"
    "ru|Item.M1Garand"         : "M1 Garand"
    "ru|Item.Kar98k"           : "Kar 98k"
    "ru|Item.Molotov"          : "Коктейль Молотова"
    "ru|Item.Ammo45ACP"        : "Патроны .45 ACP"
    "ru|Item.Ammo357magnum"    : "Патроны .357 Mangum"
    "ru|Item.Ammo12mm"         : "Патроны 12 mm"
    "ru|Item.Ammo9x19mm"       : "Патроны 9x19 mm"
    "ru|Item.Ammo792x57mm"     : "Патроны 7.92x57 mm"
    "ru|Item.Ammo762x63mm"     : "Патроны 7.62x63 mm"
    "ru|Item.Ammo38Special"    : "Патроны .38 Special"
    "ru|Item.Clothes"          : "Одежда"
    "ru|Item.Burger"           : "Бургер"
    "ru|Item.Hotdog"           : "Хот-дог"
    "ru|Item.Sandwich"         : "Сэндвич"
    "ru|Item.Cola"             : "Кола"
    "ru|Item.Jerrycan"         : "Канистра"
});
