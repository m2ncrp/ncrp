class VehicleComponent.Plate extends VehicleComponent
{
    static classname = "VehicleComponent.Plate";

    constructor (data = null) {
        base.constructor(data);

        if (this.data == null) {
            this.data = { number = getRandomVehiclePlate() }
        }
    }

    function get() {
        return this.data.number;
    }

    function set(text) {
        if (text.len() > 6) return;
        this.data.number = text;
        return this.correct();
    }

    function correct() {
        setVehiclePlateText(this.parent.vehicleid, this.data.number);
    }
}
