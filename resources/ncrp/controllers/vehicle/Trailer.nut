class Trailer extends Vehicle {
    MAX_SEATS = 0;
    capacity = null;
    
    constructor (model, px, py, pz, rx, ry, rz) {
        base.constructor(model, px, py, pz, rx, ry, rz);
        capacity = 0;
    }
}
