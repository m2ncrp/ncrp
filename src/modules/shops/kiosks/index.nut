include("modules/shops/kiosks/commands.nut");

local kiosks = [
    [ -1564.51, -187.831, -20.3354 ],
    [ -126.189, -526.682, -16.9012 ],
    [ 31.5544, -477.632, -19.3843 ],
    [ 306.122, -305.191, -20.1579 ],
    [ 367.882, -301.842, -20.1629 ],
    [ 502.804, -295.863, -20.17 ],
    [ 282.516, 4.41143, -23.0924 ],
    [ 398.516, 205.133, -20.832 ],
    [ -66.0678, -309.424, -14.4035 ],
    [ 29.6693, 199.586, -15.9337 ],
    [ -379.034, -193.7, -10.2806 ],
    [ -238.939, -35.3087, -11.5725 ],
    [ -503.928, 8.98983, -0.500379 ],
    [ -720.969, 18.0526, 0.84581 ],
    [ -684.871, 303.744, 0.199466 ],
    [ -489.742, 465.764, 1.00419 ],
    [ -373.04, 443.894, -1.3083 ],
    [ -336.401, 568.842, 1.03808 ],
    [ -376.576, 636.722, -10.6979 ],
    [ -502.821, 802.439, -19.6091 ],
    [ -727.913, 864.669, -18.9142 ],
    [ -615.083, 929.499, -18.9179 ],
    [ 1.70807, 716.806, -21.929 ],
    [ -50.8092, 704.825, -21.9756 ],
    [ -122.132, 621.833, -20.0845 ],
    [ 32.9483, 599.391, -20.107 ],
    [ -186.541, 423.516, -6.32223 ],
    [ 162.509, 657.364, -22.1436 ],
    [ 229.701, 704.13, -23.6116 ],
    [ 437.153, 458.734, -23.6267 ],
    [ -377.249, 1585.65, -23.5892 ],
    [ -783.443, 1517.29, -6.1259 ],
    [ -1181.73, 1589.47, 5.75713 ],
    [ -1047.48, 1446.5, -4.43498 ],
    [ -1276.67, 1337.41, -13.5724 ],
    [ -1195.08, 1184.23, -13.5724 ],
    [ -1116.32, 1363.58, -13.5302 ],
    [ -1576.37, 1612.96, -6.07418 ],
    [ -1426.02, 975.747, -13.6296 ],
    [ -1601.44, 971.703, -5.16564 ],
    [ -1342.97, 410.674, -23.7304 ],
    [ 564.845, -555.742, -22.7021 ]
];

event("onServerStarted", function() {
    log("[shops] loading kiosks...");

    //creating public 3dtext
    foreach (kiosk in kiosks) {
        create3DText ( kiosk[0], kiosk[1], kiosk[2]+0.35, "NEWS STAND", CL_RIPELEMON, 6.0);
        create3DText ( kiosk[0], kiosk[1], kiosk[2]+0.20, "Press E", CL_WHITE.applyAlpha(150), 0.4 );
    }
});


function isPlayerNearKiosk(playerid) {
    local check = false;
    foreach (key, value in kiosks) {
        if (isPlayerInValidPoint3D(playerid, value[0], value[1], value[2], 0.4)) {
        check = true;
        break;
        }
    }

    return check;
}