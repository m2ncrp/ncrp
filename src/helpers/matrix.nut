class Matrix
{
    r1 = Vector3(0, 0, 0);
    r2 = Vector3(0, 0, 0);
    r3 = Vector3(0, 0, 0);

    constructor (x, y, z) {
        if (typeof x == "array") {
            this.r1 = Vector3(x[0], x[1], x[2]);
            this.r2 = Vector3(y[0], y[1], y[2]);
            this.r3 = Vector3(z[0], z[1], z[2]);
        }

        if (x instanceof Vector3) {
            this.r1.init(x.x, x.y, x.z);
            this.r2.init(y.x, y.y, y.z);
            this.r3.init(z.x, z.y, z.z);
        }

        // this.tostring();
    }

    function add(m) {
        if (m instanceof Matrix) return Matrix(this.r1 + m.r1, this.r2 + m.r2, this.r3 + m.r3);
        else return Matrix(this.r1 + m, this.r2 + m, this.r3 + m);
    }

    function multiply(m) {
        if (m instanceof Matrix) {
            local x = Vector3(m.r1.x, m.r2.x, m.r3.x);
            local y = Vector3(m.r1.y, m.r2.y, m.r3.y);
            local z = Vector3(m.r1.z, m.r2.z, m.r3.z);

            local s1 = Vector3(this.r1.dot(x), this.r1.dot(y), this.r1.dot(z));
            local s2 = Vector3(this.r2.dot(x), this.r2.dot(y), this.r2.dot(z));
            local s3 = Vector3(this.r3.dot(x), this.r3.dot(y), this.r3.dot(z));

            return Matrix(s1, s2, s3);
        }
        if (m instanceof Vector3) {
            local x = this.r1.dot(m);
            local y = this.r2.dot(m);
            local z = this.r3.dot(m);
            return Vector3( x, y, z );
        }
        else return Matrix(this.r1 * m, this.r2 * m, this.r3 * m);
    }

    function tostring() {
        // dbg(this.r1.x + ",\t" + this.r1.y + ",\t" + this.r1.z + "\n");
        // dbg(this.r2.x + ",\t" + this.r2.y + ",\t" + this.r2.z + "\n");
        // dbg(this.r3.x + ",\t" + this.r3.y + ",\t" + this.r3.z + "\n\n");
        //
        // dbg(this.r1);
        // dbg(this.r2);
        // dbg(this.r3);
        // dbg();
    }
}
