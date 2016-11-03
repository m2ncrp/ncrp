include("controllers/jobs/commands.nut");
include("controllers/jobs/busdriver");
include("controllers/jobs/fuel");
include("controllers/jobs/taxi");
include("controllers/jobs/cargodriver");

addEventHandlerEx("onServerStarted", function() {
    // nothing there anymore :C
    log("[jobs] starting...");
});

/*
turn left
[05:07:42] Player 0 is at position -1628.69, -192.213, -20.4596
[05:07:54] Player 0 is at position -1647.99, -200.939, -20.1184

stop at the last
[05:08:53] Player 0 is at position -1616.34, -307.903, -20.4052
[05:09:00] Player 0 is at position -1597.63, -299.765, -20.3364

turn left
[05:09:51] Player 0 is at position -1557.59, -308.449, -20.3377
[05:09:58] Player 0 is at position -1531.28, -300.096, -20.3312

parking pozadi
[05:10:50] Player 0 is at position -1535.85, -256.054, -20.3354
[05:10:59] Player 0 is at position -1552.1, -235.126, -20.3354

            // stop at last stone -1562.91, -306.811, -19.9248, 90.1007, -0.126429, 0.126207
            // parking bus pozadi car -1537.93, -178.492, -19.5892, -0.239189, -1.16005, -2.24415

*/
