Item <- {};
Item.State <- {
    NONE             = 0,
    GROUND           = 1,
    PLAYER_HAND      = 2,
    PLAYER           = 3,
    STORAGE          = 4,
    VEHICLE_INV      = 5
    VEHICLE_INTERIOR = 6,
    PROPERTY_INV     = 7,
};

// include entities
include("controllers/inventory/classes/templates/Abstract.nut");
include("controllers/inventory/classes/templates/Cigarettes.nut");
include("controllers/inventory/classes/templates/None.nut");
include("controllers/inventory/classes/templates/Weapon.nut");
include("controllers/inventory/classes/templates/Ammo.nut");
include("controllers/inventory/classes/templates/Clothes.nut");
include("controllers/inventory/classes/templates/Food.nut");
include("controllers/inventory/classes/templates/Drink.nut");
include("controllers/inventory/classes/templates/Storage.nut");
include("controllers/inventory/classes/templates/Wheels.nut");
//include("controllers/inventory/classes/templates/Equipment.nut");

include("controllers/inventory/classes/Item/RepairKit.nut");
include("controllers/inventory/classes/Item/Jerrycan.nut");
include("controllers/inventory/classes/Item/VehicleTax.nut");
include("controllers/inventory/classes/Item/VehicleKey.nut");
include("controllers/inventory/classes/Item/VehicleTitle.nut");
include("controllers/inventory/classes/Item/Race.nut");
include("controllers/inventory/classes/Item/Passport.nut");
include("controllers/inventory/classes/Item/LTC.nut");
include("controllers/inventory/classes/Item/FirstAidKit.nut");
include("controllers/inventory/classes/Item/PoliceBadge.nut");
include("controllers/inventory/classes/Item/Money.nut");
include("controllers/inventory/classes/Item/Gift.nut");
include("controllers/inventory/classes/Item/Dice.nut");
include("controllers/inventory/classes/Item/CoffeeCup.nut");
include("controllers/inventory/classes/Item/WeaponsAndAmmo.nut");

include("controllers/inventory/classes/GroundItems.nut");
include("controllers/inventory/classes/ItemContainer.nut");
include("controllers/inventory/classes/PlayerItemContainer.nut");
include("controllers/inventory/classes/PlayerHandsContainer.nut");
include("controllers/inventory/classes/StorageItemContainer.nut");
include("controllers/inventory/classes/VehicleInventoryItemContainer.nut");
include("controllers/inventory/classes/VehicleInteriorItemContainer.nut");
include("controllers/inventory/classes/PropertyInventoryItemContainer.nut");


// add shortcuts overrides
Item.findBy <- function(condition, callback) {
    // call init (calls only one time per entity)
    Item.Abstract.initialize();

    local query = ORM.Query("SELECT * FROM `:table` :condition")

    query.setParameter("table", Item.Abstract.table, true);
    query.setParameter("condition", ORM.Utils.Formatter.calculateCondition(condition), true);

    return query.getResult(callback);
};

Item.findOneBy <- function(condition, callback) {
    // call init (calls only one time per entity)
    Item.Abstract.initialize();

    local query = ORM.Query("SELECT * FROM `:table` :condition LIMIT 1")

    query.setParameter("table", Item.Abstract.table, true);
    query.setParameter("condition", ORM.Utils.Formatter.calculateCondition(condition), true);

    return query.getSingleResult(callback);
};

Item.findAll <- function(callback) {
    // call init (calls only one time per entity)
    Item.Abstract.initialize();

    return ORM.Query("SELECT * FROM `:table`")
        .setParameter("table", Item.Abstract.table, true)
        .getResult(callback);
};

/**
 * Food
 */
class Item.Burger           extends Item.Food   { static classname = "Item.Burger";         constructor () { base.constructor(); this.volume = 1.5680; this.amount = 60.0; this.model = 65   }}
class Item.Hotdog           extends Item.Food   { static classname = "Item.Hotdog";         constructor () { base.constructor(); this.volume = 0.6760; this.amount = 30.0; this.model = 48   }}
class Item.Sandwich         extends Item.Food   { static classname = "Item.Sandwich";       constructor () { base.constructor(); this.volume = 0.3776; this.amount = 20.0; this.model = 66   }}
class Item.Gyros            extends Item.Food   { static classname = "Item.Gyros";          constructor () { base.constructor(); this.volume = 1.0080; this.amount = 50.0; this.model = 127  }}
class Item.Donut            extends Item.Food   { static classname = "Item.Donut";          constructor () { base.constructor(); this.volume = 0.0850; this.amount = 35.0; this.model = 1    }}

/**
 * Drinks
 */
class Item.Cola                 extends Item.Drink  { static classname = "Item.Cola";             constructor () { base.constructor(); this.volume = 0.6429; this.amount = 20.0; this.model = 111 }}
class Item.Whiskey              extends Item.Drink  { static classname = "Item.Whiskey";          constructor () { base.constructor(); this.volume = 1.3766; this.amount = 50.0; this.model = 129 }}
class Item.Brandy               extends Item.Drink  { static classname = "Item.Brandy";           constructor () { base.constructor(); this.volume = 1.8025; this.amount = 60.0; this.model = 29  }}
class Item.Wine                 extends Item.Drink  { static classname = "Item.Wine";             constructor () { base.constructor(); this.volume = 1.7388; this.amount = 55.0; this.model = 130 }}
class Item.MasterBeer           extends Item.Drink  { static classname = "Item.MasterBeer";       constructor () { base.constructor(); this.volume = 0.8263; this.amount = 30.0; this.model = 112 }}
class Item.StoltzBeer           extends Item.Drink  { static classname = "Item.StoltzBeer";       constructor () { base.constructor(); this.volume = 1.1741; this.amount = 35.0; this.model = 128 }}
class Item.OldEmpiricalBeer     extends Item.Drink  { static classname = "Item.OldEmpiricalBeer"; constructor () { base.constructor(); this.volume = 1.1605; this.amount = 40.0; this.model = 112 }}

/**
 * Cigarrets
 */
class Item.BigBreakRed      extends Item.Cigarettes { static classname = "Item.BigBreakRed";    constructor () { base.constructor(); this.volume = 0.11; this.effect = 9.0; this.timeout = 5; this.addiction = 15.0 }}
class Item.BigBreakBlue     extends Item.Cigarettes { static classname = "Item.BigBreakBlue";   constructor () { base.constructor(); this.volume = 0.11; this.effect = 6.0; this.timeout = 6; this.addiction = 10.0 }}
class Item.BigBreakWhite    extends Item.Cigarettes { static classname = "Item.BigBreakWhite";  constructor () { base.constructor(); this.volume = 0.11; this.effect = 3.0; this.timeout = 7; this.addiction =  5.0 }}


class Item.Box              extends Item.Storage    { static classname = "Item.Box";            constructor () { base.constructor(); this.volume = 180.0; this.container.limit = 128.0; this.container.sizeX = 3; this.container.sizeY = 4; }}

/**
 * Wheels
 */
class Item.Wheels00     extends Item.Wheels  { static classname = "Item.Wheels00"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Dunniel Spinner";       }}
class Item.Wheels01     extends Item.Wheels  { static classname = "Item.Wheels01"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Dunniel Black Rook";    }}
class Item.Wheels02     extends Item.Wheels  { static classname = "Item.Wheels02"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Speedstone Alpha";      }}
class Item.Wheels03     extends Item.Wheels  { static classname = "Item.Wheels03"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Speedstone Beta";       }}
class Item.Wheels04     extends Item.Wheels  { static classname = "Item.Wheels04"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Speedstone Top Speed";  }}
class Item.Wheels05     extends Item.Wheels  { static classname = "Item.Wheels05"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Galahad Tiara";         }}
class Item.Wheels06     extends Item.Wheels  { static classname = "Item.Wheels06"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Galahad Silver Band";   }}
class Item.Wheels07     extends Item.Wheels  { static classname = "Item.Wheels07"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Speedstone Diabolic";   }}
class Item.Wheels08     extends Item.Wheels  { static classname = "Item.Wheels08"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Galahad Coronet";       }}
class Item.Wheels09     extends Item.Wheels  { static classname = "Item.Wheels09"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Galahad Gold Crown";    }}
class Item.Wheels10     extends Item.Wheels  { static classname = "Item.Wheels10"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Speedstone Pacific";    }}
class Item.Wheels11     extends Item.Wheels  { static classname = "Item.Wheels11"; constructor () { base.constructor(); this.volume = 67.0; this.name = "Paytone Mistyhawk";     }}
