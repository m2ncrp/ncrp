Math <- {
    sqrt  = sqrt,
    acos  = acos,
    atan2 = atan2,
    acos  = acos,
    asin  = asin,
    cos   = cos,
    sin   = sin,
    min   = function(a, b) { return (a < b) ? a : b; },
    max   = function(a, b) { return (a > b) ? a : b; },
};

class Vector3 {
    x = 0.0;
    y = 0.0;
    z = 0.0;

    constructor(x = 0.0, y = 0.0, z = 0.0) {
        this.x = x.tofloat();
        this.y = y.tofloat();
        this.z = z.tofloat();
    }

    function negative() {
        return Vector3(-this.x, -this.y, -this.z);
    }

    function add(v) {
        if (v instanceof Vector3) return Vector3(this.x + v.x, this.y + v.y, this.z + v.z);
        else return Vector3(this.x + v, this.y + v, this.z + v);
    }

    function subtract(v) {
        if (v instanceof Vector3) return Vector3(this.x - v.x, this.y - v.y, this.z - v.z);
        else return Vector3(this.x - v, this.y - v, this.z - v);
    }

    function multiply(v) {
        if (v instanceof Vector3) return Vector3(this.x * v.x, this.y * v.y, this.z * v.z);
        else return Vector3(this.x * v, this.y * v, this.z * v);
    }

    function divide(v) {
        if (v instanceof Vector3) return Vector3(this.x / v.x, this.y / v.y, this.z / v.z);
        else return Vector3(this.x / v, this.y / v, this.z / v);
    }

    function equals(v) {
        if (v instanceof Vector3) return this.x == v.x && this.y == v.y && this.z == v.z;
        else return this.x == v && this.y == v && this.z == v;
    }

    function dot(v) {
        return this.x * v.x + this.y * v.y + this.z * v.z;
    }

    function cross(v) {
        return Vector3(
            this.y * v.z - this.z * v.y,
            this.z * v.x - this.x * v.z,
            this.x * v.y - this.y * v.x
        );
    }

    function length() {
        return Math.sqrt(this.dot(this));
    }

    function len() {
        return this.length();
    }

    function dist(v) {
        return this.subtract(v).length();
    }

    function unit() {
        return this.divide(this.length());
    }

    function min() {
        return Math.min(Math.min(this.x, this.y), this.z);
    }

    function max() {
        return Math.max(Math.max(this.x, this.y), this.z);
    }

    function empty() {
        return this.equals(0.0);
    }

    function isNull() {
        return this.empty();
    }

    function toAngles() {
        return {
            theta = Math.atan2(this.z, this.x),
            phi   = Math.asin(this.y / this.length())
        };
    }

    function angleTo(a) {
        return Math.acos(this.dot(a) / (this.length() * a.length()));
    }

    function toArray(n) {
        return [this.x, this.y, this.z];
    }

    function copy() {
        return Vector3(this.x, this.y, this.z);
    }

    function init(x, y, z) {
        this.x = x.tofloat(); this.y = y.tofloat(); this.z = z.tofloat();
        return this;
    }

    function _unm() {
        return this.negative();
    }

    function _add(v) {
        return this.add(v);
    }

    function _sub(v) {
        return this.subtract(v);
    }

    function _mul(v) {
        return this.multiply(v);
    }

    function _div(v) {
        return this.divide(v);
    }

    static function fromAngles(theta, phi) {
        return Vector3(Math.cos(theta) * Math.cos(phi), Math.sin(phi), Math.sin(theta) * Math.cos(phi));
    }

    static function randomDirection() {
        return Vector3.fromAngles(Math Vector3.random() * Math.PI * 2, Math.asin(Math.random() * 2 - 1));
    }

    static function lerp(a, b, fraction) {
        return b.subtract(a).multiply(fraction).add(a);
    }

    static function fromArray(a) {
        return Vector3(a[0], a[1], a[2]);
    }

    function rotate(angle_x, angle_y, angle_z) {
        // if (angle_x<0) {
        //     angle_x = angle_x+180.0
        // } else {
        //     angle_x = angle_x;
        // }

        // if (angle_y<0) {
        //     angle_y = angle_y+180.0
        // } else {
        //     angle_y = angle_y;
        // }

        // if (angle_z<0) {
        //     angle_z = angle_z+180.0
        // } else {
        //     angle_z = angle_z;
        // }
        local angleX = torad(angle_x);
        local angleY = torad(angle_y);
        local angleZ = torad(angle_z);

        local x = [1,0,0];
        local y = [0,cos(angleX),-sin(angleX)];
        local z = [0,sin(angleX),cos(angleX)];

        local mX = Matrix( x, y, z );

        x = [cos(angleY),0,sin(angleY)];
        y = [0,1,0];
        z = [-sin(angleY),0,cos(angleY)];

        local mY = Matrix( x, y, z );

        local res = mX.multiply(mY);
        res.tostring();

        x = [cos(angleZ),-sin(angleZ),0];
        y = [sin(angleZ),cos(angleZ),0];
        z = [0,0,1];

        local mZ = Matrix( x, y, z );

        res = res.multiply(mZ);
        res.tostring();

        return res.multiply(this);
    }

    function tostring() {
        // print(this.x + "," + this.y + "," + this.z + "\n");
        dbg(this);
        dbg();
    }
}
