class NVC.KeySwitch extends NVC
{
    static classname = "NVC.KeySwitch";

    limit = 1;

    constructor(data = null) {
        base.constructor(data);

        if (this.data == null) {
            this.data = { status = false, id = -1, num = 0 }
        }
    }

    function action() {
        this.setStatusTo( !this.getState() );
    }

    function setStatusTo(newStatus) {
        this.data.status = newStatus;
    }

    function getState() {
        return this.data.status;
    }

    function onEnter(character, seat) {
        this.data.id = this.parent.id;
    }
}

key("q", function(playerid) {
    if (!isPlayerInNVehicle(playerid)) return;

    local vehicle = getPlayerNVehicle(playerid);

    if (isPlayerHaveNVehicleKey(players[playerid], vehicle)) {
        vehicle.getComponent(NVC.KeySwitch).action();
        vehicle.getComponent(NVC.Engine).setStatusTo(keyswitch.data.status);
        vehicle.getComponent(NVC.Engine).correct();
    }

});
