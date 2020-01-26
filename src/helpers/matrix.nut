/**
 * Multiply Matrix
 * @param  {array of array} A
 * @param  {array of array} B
 * @return {array of array}
 */
function multiplyMatrix(A, B)
{
    local rowsA = A.len();
    local colsA = A[0].len();
    local rowsB = B.len();
    local colsB = B[0].len();

    local C = [];
    if (colsA != rowsB) return false;
    for (local i = 0; i < rowsA; i++) C.push([]);
    for (local k = 0; k < colsB; k++)
     { for (local i = 0; i < rowsA; i++)
        { local t = 0;
          for (local j = 0; j < rowsB; j++) t += A[i][j]*B[j][k];
          C[i].push(t);
        }
     }
    return C;
}

/**
 * Transp Matrix
 * @param  {array of array} A
 * @return {array of array}
 */
function transpMatrix(A)
{
    local m = A.len();
    local n = A[0].len();
    local AT = [];
    for (local i = 0; i < n; i++)
    {
        AT.push([]);
        for (local j = 0; j < m; j++) AT[i].push(A[j][i]);
    }
    return AT;
}

/**
 * Custom Euler Angles
 * @param  {object} rotationVector
 * @return {array of array}
 */
function customEulerAngles(rotationVector) {

    // преобразования под игру
    local angleX = torad( rotationVector.z );
    local angleY = torad( rotationVector.y );
    local angleZ = torad( rotationVector.x );

    // в скобках везду берём обратные величины (со знаком минус)
    local mX = [
                [ 1,            0,             0 ],
                [ 0, cos(-angleX), -sin(-angleX) ],
                [ 0, sin(-angleX),  cos(-angleX) ]
            ];

    local mY = [
                [  cos(-angleY), 0, sin(-angleY) ],
                [             0, 1,            0 ],
                [ -sin(-angleY), 0, cos(-angleY) ]
            ];

    local mZ = [
                [ cos(-angleZ), -sin(-angleZ), 0 ],
                [ sin(-angleZ),  cos(-angleZ), 0 ],
                [            0,             0, 1 ]
            ];

    local res = multiplyMatrix(multiplyMatrix(mX, mY), mZ);

    return res;
}
