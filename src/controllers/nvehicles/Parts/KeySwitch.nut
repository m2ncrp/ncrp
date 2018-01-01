class VehicleComponent.KeySwitch extends VehicleComponent
{
    static classname = "VehicleComponent.KeySwitch";

    limit = 1;

    constructor (data = null) {
        base.constructor(data);

        if (this.data == null) {
            this.data = {
                status = false,
                code = getRandomHash();
            }
        }
    }

    function beforeAction() {
        dbg("Key switch action method was called @line 22 KeySwitch.nut");
    }

    function action() {
        local eng = getPlayerNVehicle(playerid).getComponent(VehicleComponent.Engine);

        players[playerid].inventory.each( function(item) {
            if (item.data.id == this.data.code) {
                this.setStatusTo( !this.data.status );
                eng.data.status = !this.data.status;
                eng.correct();
                return;
            }
        });
    }

    function correct() { }

    function setStatusTo(newStatus) {
        this.data.status = newStatus;
    }

    function getState() {
        return this.data.status;
    }
}


key("q", function(playerid) {
    if (!original__isPlayerInVehicle(playerid)) {
        return;
    }

    if (!(original__getPlayerVehicle(playerid) in vehicles_native)) return;

    this.action();
});
