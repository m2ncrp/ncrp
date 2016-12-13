class Trailer extends BaseVehicle {
    capacity = null;
    
    constructor (model, px, py, pz, rx, ry, rz) {
        base.constructor(model, px, py, pz, rx, ry, rz);
        capacity = 0;
    }
}
