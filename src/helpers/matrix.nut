class Matrix
{
    _data = [];

    length = 0;
    function __checksForDimentions(arg) {
        if ( !this.length ) {
            this.length = arg.len();
        }

        if ( this.length != arg.len() ) {
            throw "Dimensions of matrices being concatenated are not consistent.";
        }
    }

    constructor (...) {
        this._data = array( vargv.len() );
        foreach (i, arg in vargv) {
            if (typeof arg != "array") {
                throw "[MATH] Couldn't figure out matrix creation... Check args!";
            }

            this.__checksForDimentions(arg);

            if (arg.len() > 0 && typeof arg[0] == "array") {
                this._data = clone(arg);
                return;
            }

            // print( "[ARG] " + arg +"\n");
            this._data[i] = arg;
        }
    }

    function zeros(r = null, c = null, defautValue = 0) {
        if (!r || !c) {
            r = this.getRowNumber();
            c = this.getColumnNumber();
        }
        // local data = [];
        // for (local i = 0; i <= r; i++) {
        //     data.push( array(c, defautValue) );
        // }
        local tmp_data = array(r);
        foreach (idx, row in tmp_data) {
            tmp_data[idx] = array(c, defautValue);
        }
        return Matrix(tmp_data);
    }

    // function eye(r,c) {
    //     // if size was not given
    //     // local r = this.getRowNumber();
    //     // local c = this.getColumnNumber();

    //     local tmp_data = zeros(r, c);
    //     for (local i = 0; i < c; i++) {
    //         tmp_data[i][i] = 1;
    //     }
    //     return Matrix(tmp_data);
    // }

    function getColumn(index = 1) {
        local index = index - 1;
        local column = [];
        foreach (row in this._data) {
            column.push( row[index] );
        }
        return Matrix(column);
    }

    function getRow(index = 1) {
        local index = index - 1;
        return Matrix( this._data[index] );
    }

    // function swapColumns() {
    //     // Code
    // }

    // function swapRows() {
    //     // Code
    // }

    function transp() {
        local data = [];
        for (local i = 0; i < this.length; i++) {
            data.push( this.getColumn(i+1)._data[0] );
        }
        return Matrix(data);
    }

    function  getColumnNumber() {
        return this._data[0].len();
    }

    function getRowNumber() {
        return this._data.len();
    }

    function __multiplyRowByColumn(row, column) {
        local value = 0;
        foreach (i, element in row) {
            value += element * column[0][i];
            // print(value + " = " + value + " + " + element + " * " + column[0][i] + "\n");
        }
        // print("\n");
        return value;
    }

    // A * B
    function __multiplyDot(mtrx) {
        if ( mtrx._data.len() < 1 ) {
            throw "[MATH] __multiplyDot impossible: mtrx hasn't been initialized yet"
        }

        if ( this.getColumnNumber() != mtrx.getRowNumber() ) {
            throw "[MATH] Breaking rules of matrices multiplication @__multiplyDot";
        }

        local r = this.getRowNumber();
        local c = mtrx.getColumnNumber();

        // print("size: (" + r + "x" + c + ")\n");

        local tmp_mtrx = array(r);
        foreach (idx, row in tmp_mtrx) {
            tmp_mtrx[idx] = array(c, 0);
        }

        for (local i = 0; i < r; i++) {
            for (local j = 0; j < c; j++) {
                tmp_mtrx[i][j] = __multiplyRowByColumn( this._data[i], mtrx.getColumn(j+1)._data );
                // print(tmp_mtrx[i][j] + " = " + tmp_mtrx[i][j] + " + " + this._data[i][j] + " * " + mtrx._data[j][i] + "\n");
            }
        }
        return Matrix(tmp_mtrx);
    }


    function _mul(m) {
        return this.__multiplyDot(m);
    }

    function tostring() {
        // foreach (row in this._data) {
        //     print("[ ");
        //     foreach (element in row) {
        //         print( element + " " );
        //     }
        //     print("]\n");
        // }
        // print("\n");
        local str = "";
        foreach (row in this._data) {
            str += "[ ";
            foreach (element in row) {
                str+= " " + element.tostring();
            }
            str += " ]";
            dbg(str);
            str="";
        };
    }
}


function EulerAngles(rotationVector) {
    local angleX = torad( rotationVector[2] );
    local angleY = torad( rotationVector[1] );
    local angleZ = torad( rotationVector[0] );

    local mX = Matrix(
                [ 1, 0,          0               ],
                [ 0, cos(angleX), -sin(angleX)   ],
                [ 0, sin(angleX),  cos(angleX)   ]
            );
    // mX.tostring();

    // A = A * mX;
    // A.tostring();

    local mY = Matrix(
                [ cos(angleY),  0,  sin(angleY) ],
                [ 0,            1,  0           ],
                [-sin(angleY),  0,  cos(angleY) ]
            );
    // mY.tostring();

    // A = A * mY;
    // A.tostring();

    local mZ = Matrix(
                [ cos(angleZ), -sin(angleZ), 0 ],
                [ sin(angleZ),  cos(angleZ), 0 ],
                [ 0,            0,           1 ]
            );
    // mZ.tostring();

    // C = A * mZ;
    // C.tostring();

    local res = (mY * mX * mZ);
    // log("= = = = = = = = = = = = = =");
    // res.tostring();
    // log("= = = = = = = = = = = = = =");
    return res;
}
