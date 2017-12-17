class VehicleComponent.WheelPair extends VehicleComponent
{
    static classname = "VehicleComponent.WheelPair";

    static WheelPosition = {
        front  = 0,
        middle = 1,
        rear   = 2
    }

    constructor (data) {
        base.constructor(data);

        if (this.data == null) {
            this.data = {
                front  = getVehicleWheelTexture( this.parent.vehicleid, 0 ),
                middle = getVehicleWheelTexture( this.parent.vehicleid, 1 ),
                rear   = getVehicleWheelTexture( this.parent.vehicleid, 2 )
            }
        }
    }

    function get(pair_num) {
        return getVehicleWheelTexture( this.parent.vehicleid, pair_num );
    }

    function set(pair_num, to) {
        if (pair_num == this.WheelPosition.front) {
            this.data.front = to;
        }

        if (pair_num == this.WheelPosition.middle) {
            this.data.middle = to;
        }

        if (pair_num == this.WheelPosition.rear) {
            this.data.rear = to;
        }

        setVehicleWheelTexture( this.parent.vehicleid, pair_num, to );
    }

    function correct() {
        this.set(this.WheelPosition.front,
                this.data.front);
        this.set(this.WheelPosition.middle,
                this.data.middle);
        this.set(this.WheelPosition.rear,
                this.data.rear);
    }
}
