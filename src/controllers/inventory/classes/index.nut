Item <- {};
Item.State <- {
    NONE             = 0,
    GROUND           = 1,
    PLAYER_HAND      = 2,
    PLAYER           = 3,
    STORAGE          = 4,
    VEHICLE_INV      = 5
    VEHICLE_INTERIOR = 6,
    BUILDING_INV     = 7,
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

include("controllers/inventory/classes/GroundItems.nut");
include("controllers/inventory/classes/ItemContainer.nut");
include("controllers/inventory/classes/PlayerItemContainer.nut");
include("controllers/inventory/classes/PlayerHandsContainer.nut");
include("controllers/inventory/classes/StorageItemContainer.nut");
include("controllers/inventory/classes/VehicleInventoryItemContainer.nut");
include("controllers/inventory/classes/VehicleInteriorItemContainer.nut");


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
 * Weapons
 */
class Item.Revolver         extends Item.Weapon { static classname = "Item.Revolver";       constructor () { base.constructor(); this.volume = 0.200; this.model =  2; this.ammo = "Item.Ammo38Special"; this.capacity =   6 }}
class Item.MauserC96        extends Item.Weapon { static classname = "Item.MauserC96";      constructor () { base.constructor(); this.volume = 1.200; this.model =  3; this.ammo = "Item.Ammo45ACP";     this.capacity =  10 }}
class Item.Colt             extends Item.Weapon { static classname = "Item.Colt";           constructor () { base.constructor(); this.volume = 1.100; this.model =  4; this.ammo = "Item.Ammo45ACP";     this.capacity =   7 }}
class Item.ColtSpec         extends Item.Weapon { static classname = "Item.ColtSpec";       constructor () { base.constructor(); this.volume = 1.500; this.model =  5; this.ammo = "Item.Ammo45ACP";     this.capacity =  23 }}
class Item.Magnum           extends Item.Weapon { static classname = "Item.Magnum";         constructor () { base.constructor(); this.volume = 0.900; this.model =  6; this.ammo = "Item.Ammo357Magnum"; this.capacity =   6 }}
class Item.Remington870     extends Item.Weapon { static classname = "Item.Remington870";   constructor () { base.constructor(); this.volume = 3.600; this.model =  8; this.ammo = "Item.Ammo12";        this.capacity =   8 }}
class Item.M3GreaseGun      extends Item.Weapon { static classname = "Item.M3GreaseGun";    constructor () { base.constructor(); this.volume = 3.500; this.model =  9; this.ammo = "Item.Ammo45ACP";     this.capacity =  30 }}
class Item.MP40             extends Item.Weapon { static classname = "Item.MP40";           constructor () { base.constructor(); this.volume = 4.700; this.model = 10; this.ammo = "Item.Ammo9x19mm";    this.capacity =  32 }}
class Item.Thompson1928     extends Item.Weapon { static classname = "Item.Thompson1928";   constructor () { base.constructor(); this.volume = 4.900; this.model = 11; this.ammo = "Item.Ammo45ACP";     this.capacity =  50 }}
class Item.M1A1Thompson     extends Item.Weapon { static classname = "Item.M1A1Thompson";   constructor () { base.constructor(); this.volume = 4.800; this.model = 12; this.ammo = "Item.Ammo45ACP";     this.capacity =  30 }}
class Item.Beretta38A       extends Item.Weapon { static classname = "Item.Beretta38A";     constructor () { base.constructor(); this.volume = 3.300; this.model = 13; this.ammo = "Item.Ammo9x19mm";    this.capacity =  30 }}
class Item.MG42             extends Item.Weapon { static classname = "Item.MG42";           constructor () { base.constructor(); this.volume = 11.50; this.model = 14; this.ammo = "Item.Ammo792x57mm";  this.capacity = 100 }}
class Item.M1Garand         extends Item.Weapon { static classname = "Item.M1Garand";       constructor () { base.constructor(); this.volume = 4.300; this.model = 15; this.ammo = "Item.Ammo792x63mm";  this.capacity =   8 }}
class Item.Kar98k           extends Item.Weapon { static classname = "Item.Kar98k";         constructor () { base.constructor(); this.volume = 3.900; this.model = 17; this.ammo = "Item.Ammo792x57mm";  this.capacity =   5 }}

//class Item.Molotov          extends Item.Weapon { static classname = "Item.Molotov";        constructor () { base.constructor(); this.volume = 1.000; this.model = 21; this.ammo = "none";               this.capacity =   1 }}
//class Item.MK2              extends Item.Weapon { static classname = "Item.MK2";            constructor () { base.constructor(); this.volume = 0.600; this.model =  7; this.ammo = "none";               this.capacity =   1 }}

/**
 * Ammo
 */
class Item.Ammo45ACP        extends Item.Ammo   { static classname = "Item.Ammo45ACP";      constructor () { base.constructor(); this.volume = 0.012 }}
class Item.Ammo357Magnum    extends Item.Ammo   { static classname = "Item.Ammo357Magnum";  constructor () { base.constructor(); this.volume = 0.010 }}
class Item.Ammo12           extends Item.Ammo   { static classname = "Item.Ammo12";         constructor () { base.constructor(); this.volume = 0.017 }}
class Item.Ammo9x19mm       extends Item.Ammo   { static classname = "Item.Ammo9x19mm";     constructor () { base.constructor(); this.volume = 0.010 }}
class Item.Ammo792x57mm     extends Item.Ammo   { static classname = "Item.Ammo792x57mm";   constructor () { base.constructor(); this.volume = 0.012 }}
class Item.Ammo762x63mm     extends Item.Ammo   { static classname = "Item.Ammo762x63mm";   constructor () { base.constructor(); this.volume = 0.010 }}
class Item.Ammo38Special    extends Item.Ammo   { static classname = "Item.Ammo38Special";  constructor () { base.constructor(); this.volume = 0.007 }}

/**
 * Food
 */
class Item.Burger           extends Item.Food   { static classname = "Item.Burger";         constructor () { base.constructor(); this.volume = 1.5680; this.amount = 75.0 }}
class Item.Hotdog           extends Item.Food   { static classname = "Item.Hotdog";         constructor () { base.constructor(); this.volume = 0.6760; this.amount = 30.0 }}
class Item.Sandwich         extends Item.Food   { static classname = "Item.Sandwich";       constructor () { base.constructor(); this.volume = 0.3776; this.amount = 20.0 }}
class Item.Gyros            extends Item.Food   { static classname = "Item.Gyros";          constructor () { base.constructor(); this.volume = 1.0080; this.amount = 50.0 }}


/**
 * Drinks
 */
class Item.Cola                 extends Item.Drink  { static classname = "Item.Cola";             constructor () { base.constructor(); this.volume = 0.6429; this.amount = 20.0 }}
class Item.Whiskey              extends Item.Drink  { static classname = "Item.Whiskey";          constructor () { base.constructor(); this.volume = 1.3766; this.amount = 50.0 }}
class Item.Brandy               extends Item.Drink  { static classname = "Item.Brandy";           constructor () { base.constructor(); this.volume = 1.8025; this.amount = 60.0 }}
class Item.Wine                 extends Item.Drink  { static classname = "Item.Wine";             constructor () { base.constructor(); this.volume = 1.7388; this.amount = 55.0 }}
class Item.MasterBeer           extends Item.Drink  { static classname = "Item.MasterBeer";       constructor () { base.constructor(); this.volume = 0.8263; this.amount = 30.0 }}
class Item.StoltzBeer           extends Item.Drink  { static classname = "Item.StoltzBeer";       constructor () { base.constructor(); this.volume = 1.1741; this.amount = 35.0 }}
class Item.OldEmpiricalBeer     extends Item.Drink  { static classname = "Item.OldEmpiricalBeer"; constructor () { base.constructor(); this.volume = 1.1605; this.amount = 40.0 }}

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
