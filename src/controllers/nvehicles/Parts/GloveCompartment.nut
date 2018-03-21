class VehicleComponent.GloveCompartment extends VehicleComponent {
    static classname = "VehicleComponent.GloveCompartment";

    container = null;

    loaded = false;
    status = false;

    constructor (data = null) {
        base.constructor(data);
        this.container = GloveCompartmentItemContainer(this.parent);

        if (data == null) {
            this.data = {}
        }
    }

    function setParent(parent) {
        this.container.parent = parent;
        return base.setParent(parent);
    }

    function save() {
        foreach (idx, item in this.container) {
            item.parent = this.parent.id;
            item.save();
        }
    }

    function setState(state) {
        this.status = !this.status;
    }

    function action() {
        this.setState( !this.status );
    }

    function correct() {}

    function load() {
        local self = this;
        ORM.Query("select * from tbl_items where parent = :id and state = :states")
            .setParameter("id", this.parent.id)
            .setParameter("states", Item.State.GLOVE_COMPART, true)
            .getResult(function(err, items) {
                foreach (idx, item in items) {
                    self.container.set(item.slot, item);
                }
            });

        this.loaded = true;
    }

    function isLoaded() {
        return this.loaded;
    }
}

// open up key switch and bardachok at the same time with players invenory
key("tab", function(playerid) {
    if ( !isPlayerInNVehicle(playerid) ) return;

    local vehicle = getPlayerNVehicle(playerid);
    if (vehicle == null || vehicle.getType() == Vehicle.Type.semitrailertruck || vehicle.getType() == Vehicle.Type.bus) return null;
    local gc = vehicle.getComponent(VehicleComponent.GloveCompartment);

    if ( vehicle.isPlayerDriver(players[playerid]) ||
         vehicle.isPlayerOnSeat(players[playerid], 1) )
    {
        if (!gc.status) {
            gc.container.show(playerid);
            gc.setState(true);
        } else {
            gc.container.hide(playerid);
            gc.setState(false);
        }
    }
});

