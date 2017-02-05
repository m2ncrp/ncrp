class vector3 {
    x = 0.0;
    y = 0.0;
    z = 0.0;

    constructor (x, y, z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    // function add(vec) {
        
    // }

    function isNull() {
        return (this.x == 0.0 && this.y == 0.0 && this.z == 0.0);
    }
}
