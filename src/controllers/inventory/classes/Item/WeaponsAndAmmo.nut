
/**
 * Weapons
 */
class Item.Revolver         extends Item.Weapon { static classname = "Item.Weapons.Revolver";       constructor () { base.constructor(); this.volume = 0.200; this.model =  2; this.ammo = "Item.Ammo38Special"; this.capacity =   6 }}
class Item.MauserC96        extends Item.Weapon { static classname = "Item.Weapons.MauserC96";      constructor () { base.constructor(); this.volume = 1.200; this.model =  3; this.ammo = "Item.Ammo45ACP";     this.capacity =  10 }}
class Item.Colt             extends Item.Weapon { static classname = "Item.Weapons.Colt";           constructor () { base.constructor(); this.volume = 1.100; this.model =  4; this.ammo = "Item.Ammo45ACP";     this.capacity =   7 }}
class Item.ColtSpec         extends Item.Weapon { static classname = "Item.Weapons.ColtSpec";       constructor () { base.constructor(); this.volume = 1.500; this.model =  5; this.ammo = "Item.Ammo45ACP";     this.capacity =  23 }}
class Item.Magnum           extends Item.Weapon { static classname = "Item.Weapons.Magnum";         constructor () { base.constructor(); this.volume = 0.900; this.model =  6; this.ammo = "Item.Ammo357Magnum"; this.capacity =   6 }}
class Item.Remington870     extends Item.Weapon { static classname = "Item.Weapons.Remington870";   constructor () { base.constructor(); this.volume = 3.600; this.model =  8; this.ammo = "Item.Ammo12gauge";   this.capacity =   8 }}
class Item.M3GreaseGun      extends Item.Weapon { static classname = "Item.Weapons.M3GreaseGun";    constructor () { base.constructor(); this.volume = 3.500; this.model =  9; this.ammo = "Item.Ammo45ACP";     this.capacity =  30 }}
class Item.MP40             extends Item.Weapon { static classname = "Item.Weapons.MP40";           constructor () { base.constructor(); this.volume = 4.700; this.model = 10; this.ammo = "Item.Ammo9x19mm";    this.capacity =  32 }}
class Item.Thompson1928     extends Item.Weapon { static classname = "Item.Weapons.Thompson1928";   constructor () { base.constructor(); this.volume = 4.900; this.model = 11; this.ammo = "Item.Ammo45ACP";     this.capacity =  50 }}
class Item.M1A1Thompson     extends Item.Weapon { static classname = "Item.Weapons.M1A1Thompson";   constructor () { base.constructor(); this.volume = 4.800; this.model = 12; this.ammo = "Item.Ammo45ACP";     this.capacity =  30 }}
class Item.Beretta38A       extends Item.Weapon { static classname = "Item.Weapons.Beretta38A";     constructor () { base.constructor(); this.volume = 3.300; this.model = 13; this.ammo = "Item.Ammo9x19mm";    this.capacity =  30 }}
class Item.MG42             extends Item.Weapon { static classname = "Item.Weapons.MG42";           constructor () { base.constructor(); this.volume = 11.50; this.model = 14; this.ammo = "Item.Ammo792x57mm";  this.capacity = 100 }}
class Item.M1Garand         extends Item.Weapon { static classname = "Item.Weapons.M1Garand";       constructor () { base.constructor(); this.volume = 4.300; this.model = 15; this.ammo = "Item.Ammo792x63mm";  this.capacity =   8 }}
class Item.Kar98k           extends Item.Weapon { static classname = "Item.Weapons.Kar98k";         constructor () { base.constructor(); this.volume = 3.900; this.model = 17; this.ammo = "Item.Ammo792x57mm";  this.capacity =   5 }}

//class Item.Molotov          extends Item.Weapon { static classname = "Item.Molotov";        constructor () { base.constructor(); this.volume = 1.000; this.model = 21; this.ammo = "none";               this.capacity =   1 }}
//class Item.MK2              extends Item.Weapon { static classname = "Item.MK2";            constructor () { base.constructor(); this.volume = 0.600; this.model =  7; this.ammo = "none";               this.capacity =   1 }}

/**
 * Ammo
 */
class Item.Ammo45ACP        extends Item.Ammo   { static classname = "Item.Ammo45ACP";      constructor () { base.constructor(); this.volume = 0.012 }}
class Item.Ammo357Magnum    extends Item.Ammo   { static classname = "Item.Ammo357Magnum";  constructor () { base.constructor(); this.volume = 0.010 }}
class Item.Ammo12gauge      extends Item.Ammo   { static classname = "Item.Ammo12gauge";    constructor () { base.constructor(); this.volume = 0.017 }}
class Item.Ammo9x19mm       extends Item.Ammo   { static classname = "Item.Ammo9x19mm";     constructor () { base.constructor(); this.volume = 0.010 }}
class Item.Ammo792x57mm     extends Item.Ammo   { static classname = "Item.Ammo792x57mm";   constructor () { base.constructor(); this.volume = 0.012 }}
class Item.Ammo762x63mm     extends Item.Ammo   { static classname = "Item.Ammo762x63mm";   constructor () { base.constructor(); this.volume = 0.010 }}
class Item.Ammo38Special    extends Item.Ammo   { static classname = "Item.Ammo38Special";  constructor () { base.constructor(); this.volume = 0.007 }}
