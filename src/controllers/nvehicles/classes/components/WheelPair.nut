class NVC.WheelPair extends NVC
{
    static classname = "NVC.WheelPair";

    static WheelPosition = {
        front  = 0,
        middle = 1,
        rear   = 2
    }

    constructor (data = null) {
        base.constructor(data);

        // TODO: setup wheel's textute properly with meta info
        if (this.data == null) {
            this.data = {
                front  = 0,//getVehicleWheelTexture( this.parent.vehicleid, 0 ),
                middle = 0,//getVehicleWheelTexture( this.parent.vehicleid, 1 ),
                rear   = 0,//getVehicleWheelTexture( this.parent.vehicleid, 2 )
            }
        }
    }

    function get(pair_num) {
        return getVehicleWheelTexture( this.parent.vehicleid, pair_num );
    }

    function getAll() {
        return [ this.get(0),
                 this.get(1),
                 this.get(2)
               ];
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

    /**
     * Check if capacity of component isn't more than 0, disable brakes at all
     */
    function isBroken() {
        return false;
    }

    function correct() {
        local model = this.parent.getComponent(NVC.Hull).getModel();
        local type = getModelType(model);

        // // TODO: cut off IF statement
        // if ( type == Vehicle.Type.sedan  ||
        //      type == Vehicle.Type.hetch ) {
        //     this.set(this.WheelPosition.front,
        //         this.data.front);
        //     this.set(this.WheelPosition.middle,
        //         this.data.middle);
        //     this.set(this.WheelPosition.rear,
        //         this.data.rear);
        // }
    }
}
