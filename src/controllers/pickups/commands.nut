acmd("cp", function(playerid) {
    msg(playerid, "create pickup");
    createPickup("RTR_ARROW_00", -393.429 + randomf(-1.0, 1.0), 912.044, -19.0026);
})

acmd("mp", function(playerid) {
    msg(playerid, "move pickup");
    movePickup("RTR_ARROW_00", -393.429 + randomf(-1.0, 1.0), 912.044, -19.0026);
})

acmd("rp", function(playerid) {
    msg(playerid, "rotate pickup");
    rotatePickup("RTR_ARROW_00");
})

acmd("dp", function(playerid) {
    msg(playerid, "destroy pickup");
    destroyPickup("RTR_ARROW_00");
})

acmd("sp", function(playerid) {
    msg(playerid, "stop pickup");
    stopRotationPickup("RTR_ARROW_00");
})