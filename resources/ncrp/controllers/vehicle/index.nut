include("controllers/vehicle/commands.nut");
include("controllers/vehicle/hiddencars.nut");

addEventHandlerEx("onServerStarted", function() {
    log("[vehicles] starting...");
    createVehicle(8, -1546.6, -156.406, -19.2969, -0.241408, 2.89541, -2.29698);    // Sand Island
    createVehicle(9, -1537.77, -168.93, -19.4142, 0.0217354, 0.396637, -2.80105);   // Sand Island
    createVehicle(20, -1525.16, -193.591, -19.9696, 90.841, -0.248158, 3.35295);    // Sand Island
});
