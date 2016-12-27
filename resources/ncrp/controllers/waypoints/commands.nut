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



ps <- PointSequence();

cmd(["cccc7"], function(playerid) {
    local p1 = Point3d(X, Y, Z, 180.0);
    p1.attachLocalBlip(playerid, X, Y, ICON_TARGET, 4000.0);
    local p2 = Point3d(41.9951, -21.5509, -15.4029, 180.0);
    p2.attachLocalBlip(playerid, 41.9951, -21.5509, ICON_TARGET, 4000.0);
    local p3 = Point3d(41.4975, -98.6097, -18.3269, 180.0);
    p3.attachLocalBlip(playerid, 41.4975, -98.6097, ICON_TARGET, 4000.0);
    
    ps.add(p1);
    ps.add(p2);
    ps.add(p3);
});


cmd(["cccc8"], function(playerid) {
    local pos = getPlayerPosition(playerid);
    local angle = getPlayerRotation(playerid);
    ps.check(pos[0], pos[1], pos[2], angle[0], radius);
});
