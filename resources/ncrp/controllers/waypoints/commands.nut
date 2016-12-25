points <- [];

const X = 39.4199;
const Y = 22.7286;
const Z = -13.6457;

const radius = 2.5;

cmd(["cccc1"], function(playerid) {
    local p = Point3d(X, Y, Z, 90.0);
    p.attachLocalBlip(playerid, X, Y, ICON_TARGET, 4000.0);

    points.push(p);
});


cmd(["cccc2"], function(playerid) {
    local pos = getPlayerPosition(playerid);
    if ( points.top().isInPoint(pos[0], pos[1], pos[2], radius) ) {
        points.top().removeLocalBlip();
    }
});

cmd(["cccc3"], function(playerid) {
    local pos = getPlayerPosition(playerid);
    local angle = getPlayerRotation(playerid);
    angle = angle[0];
    if ( points.top().isInPoint_Strict(pos[0], pos[1], pos[2], angle, radius) ) {
        points.top().removeLocalBlip();
    }
});





cmd(["cccc4"], function(playerid) {
    local p = Point2d(X, Y, 90.0);
    p.attachLocalBlip(playerid, X, Y, ICON_TARGET, 4000.0);

    points.push(p);
});

cmd(["cccc5"], function(playerid) {
    local pos = getPlayerPosition(playerid);
    if ( points.top().isInPoint(pos[0], pos[1], radius) ) {
        points.top().removeLocalBlip();
    }
});

cmd(["cccc6"], function(playerid) {
    local pos = getPlayerPosition(playerid);
    local angle = getPlayerRotation(playerid);
    angle = angle[0];
    if ( points.top().isInPoint_Strict(pos[0], pos[1], angle, radius) ) {
        points.top().removeLocalBlip();
        // points.remove(idx)
    }
});
