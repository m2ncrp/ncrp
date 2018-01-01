class VehicleComponent.KeySwitch extends VehicleComponent
{
    static classname = "VehicleComponent.KeySwitch";

    limit = 1;

    constructor (data = null) {
        base.constructor(data);

        if (this.data == null) {
            this.data = {
                status = false,
                code = null,
            }
        }
    }

    function _getHash(value) {
        return md5(value);
    }

    function _setHash(value) {
        this.data.code = md5(value);
    }

    function beforeAction() {
        dbg("Key switch action method was called @line 22 KeySwitch.nut");
    }

    function action() {
        this.setStatusTo( !this.getState() );
    }

    function correct() { }

    function setStatusTo(newStatus) {
        if (this.data.code == null) {
            this.data.code = _getHash(this.parent.id);
        }
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

    local v = getPlayerNVehicle(playerid);
    local eng = v.getComponent(VehicleComponent.Engine);
    local ks = v.getComponent(VehicleComponent.KeySwitch);

    foreach (idx, item in players[playerid].inventory) {
        if ((item._entity == "Item.VehicleKey") && (item.data.id == ks.data.code)) {
            eng.setStatusTo( !ks.data.status );
            eng.correct();
            ks.action();
            return;
        }
    }
});
