class Point2d extends Vector3d {
    angle = null;
    tolerance = null;

    blip_hash = null;
    
    constructor (X, Y, angle, tolerance = 5.0) {
        this.X = X;
        this.Y = Y;

        this.angle = angle;
        this.tolerance = tolerance;

        this.blip_hash = null;
    }

    function checkRotation(currentAngle) {
        return (angle - tolerance <= currentAngle <= angle + tolerance);
    }

    function attachLocalBlip(playerid, X, Y, icon, visibleDistance) {
        blip_hash = createPrivateBlip(playerid, X, Y, icon, visibleDistance);
    }

    function attachGlobalBlip(X, Y, icon, distance) {
        blip_hash = createBlip(X, Y, icon, distance);
    }

    function removeLocalBlip() {
        removeBlip( blip_hash );
    }

    function removeGlobalBlip() {
        removeBlip( blip_hash );
    }

    /**
     * Check if smth with given radius is in point with expected rotation 
     * @param  {[type]}  X      [description]
     * @param  {[type]}  Y      [description]
     * @param  {[type]}  angle  [description]
     * @param  {[type]}  radius [description]
     * @return {Boolean}        [description]
     */
    function isInPoint(X, Y, radius) {
        return checkDistanceXY(X1, Y1, X2, Y2, radius);
    }

    function isInPoint_Strict(X, Y, angle, radius) {
        local isDistGood = checkDistanceXY(X1, Y1, X2, Y2, radius);
        local isRotationGood = checkRotation(angle);
        return isDistGood && isRotationGood;
    }
}





class Point3d extends Point2d {
    
    constructor (X, Y, Z, angle, tolerance = 5.0) {
        base.constructor(X, Y, angle, tolerance);
        this.Z = Z;
    }

    function isInPoint(X, Y, Z, radius) {
        return checkDistanceXYZ(X1, Y1, Z1, X2, Y2, Z2, radius);
    }

    function isInPoint_Strict(X, Y, Z, angle, radius) {
        local isDistGood = checkDistanceXYZ(X1, Y1, Z1, X2, Y2, Z2, radius);
        local isRotationGood = checkRotation(angle);
        return isDistGood && isRotationGood;
    }
}


/*
local p = Point2d(pX, pY, 90.0);
p.attachLocalBlip(playerid, 4000.0);

local posP = getPlayerPosition(playerid);
local angle = getPlayerRotation(playerid);
if ( p.isInPoint(posP[0], posP[1], angle[0], 6.0) ) {
    p.removeLocalBlip();
}
*/
