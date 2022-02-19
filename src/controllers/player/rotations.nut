getPlayerRotationNative <- getPlayerRotation;

function getPlayerRotation(playerid) {
    local rot = getPlayerRotationNative(playerid);
    return [rot[2], rot[1], rot[0]];
}