class NVC.KeySwitch extends NVC
{
    static classname = "NVC.KeySwitch";

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

    function _getHash() {
        return this.data.code;
    }

    function _setHash(value) {
        this.data.code = md5(value.tostring());
    }

    function beforeAction() {
        dbg("Key switch action method was called @line 22 KeySwitch.nut");
    }

    function action() {
        this.setStatusTo( !this.getState() );
    }

    function correct() { }

    function setStatusTo(newStatus) {
        this.data.status = newStatus;
    }

    function getState() {
        return this.data.status;
    }

    function onEnter(character, seat) {
        if (this.data.code == null) {
            this._setHash(this.parent.id);
        }
    }
}


key("q", function(playerid) {
    if (!isPlayerInNVehicle(playerid)) return;

    local vehicle = getPlayerNVehicle(playerid);

    if (isPlayerHaveNVehicleKey(playerid, vehicle)) {
        local engine = vehicle.getComponent(NVC.Engine);
        local keyswitch = vehicle.getComponent(NVC.KeySwitch);
        engine.setStatusTo( !keyswitch.data.status );
        engine.correct();
        keyswitch.action();
    }

});
