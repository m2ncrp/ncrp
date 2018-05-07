class Item.VehicleKey extends Item.Abstract
{
    static classname = "Item.VehicleKey";
    default_decay = 259200;
    weight        = 0.10;

    constructor (data = null) {
        base.constructor();
        if (data == null) {
            this.data = { code = generateHash(3) };
        }
    }

    function getCode() {
        return this.data.code;
    }

    function getId() {
        return this.data.id;
    }

    function use(playerid, inventory) {

        local vehicle = vehicles.byKeyCode(this.getCode());

        if (!vehicle) {
            return msg(playerid, "inventory.vehiclekey.removedcar", CL_HELP_TITLE);
        }

        local plateComponent = vehicle.components.findOne(NVC.Plate);

        if(!plateComponent) {
            return msg(playerid, "inventory.vehiclekey.withoutplate", CL_HELP_TITLE);
        }

        msg(playerid, "==================================", CL_HELP_LINE);
        msg(playerid, "Item.VehicleKey", CL_HELP_TITLE);
        msg(playerid, plateComponent.get()+" - "+getVehicleNameByModelId( vehicle.components.findOne(NVC.Hull).getModel() ), CL_WHITE);
    }

    static function getType() {
        return "Item.VehicleKey";
    }
}
