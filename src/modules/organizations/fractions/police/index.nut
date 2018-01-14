POLICE_EBPD_ENTERES <- [
    [-360.342, 785.954, -19.9269],  // parade
    [-379.444, 654.207, -11.6451]   // stuff only
];

const EBPD_ENTER_RADIUS = 2.0;
const EBPD_TITLE_DRAW_DISTANCE = 35.0;

event("onServerStarted", function() {
    log("[FRACTION | POLICE] starting...");
    createVehicle(42, -387.247, 644.23, -11.1051, -0.540928, 0.0203334, 4.30543 );      // policecar1
    createVehicle(42, -327.361, 677.508, -17.4467, 88.647, -2.7285, 0.00588255 );       // policecarParking3
    createVehicle(42, -327.382, 682.532, -17.433, 90.5207, -3.07545, 0.378189 );        // policecarParking4
    createVehicle(21, -324.296, 693.308, -17.4131, -179.874, -0.796982, -0.196363 );    // policeBusParking1
    createVehicle(51, -326.669, 658.13, -17.5624, 90.304, -3.56444, -0.040828 );        // policeOldCarParking1
    createVehicle(51, -326.781, 663.293, -17.5188, 93.214, -2.95046, -0.0939897 );      // policeOldCarParking2
    createVehicle(42, 160.689, -351.494, -20.087, 0.292563, 0.457066, -0.15319 );       // policeCarKosoyPereulok

    create3DText( POLICE_EBPD_ENTERES[1][0], POLICE_EBPD_ENTERES[1][1], POLICE_EBPD_ENTERES[1][2]+0.35, "=== EMPIRE BAY POLICE DEPARTMENT ===", CL_ROYALBLUE, EBPD_TITLE_DRAW_DISTANCE );
    create3DText( POLICE_EBPD_ENTERES[1][0], POLICE_EBPD_ENTERES[1][1], POLICE_EBPD_ENTERES[1][2]+0.20, "Press E", CL_WHITE.applyAlpha(150), EBPD_ENTER_RADIUS );

    createPlace("KosoyPereulok", 171.597, -302.503, 161.916, -326.178);
    // Create Police Officers Manager here
    // POLICE_MANAGER = OfficerManager();
});

include("modules/organizations/fractions/police/functional/tickets.nut");

/*

Ранги:

"chief"
"assistant"
"detective"
"сaptain"
"lieutenant"
"sergeant"
"patrol"
"cadet"

 */
