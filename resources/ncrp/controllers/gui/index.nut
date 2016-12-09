GUI <- { __version = "001" };

// include("controllers/gui/Object.nut");
// include("controllers/gui/Object.nut");

// ELEMENT_TYPE_WINDOW
// ELEMENT_TYPE_EDIT
// ELEMENT_TYPE_BUTTON
// ELEMENT_TYPE_CHECKBOX
// ELEMENT_TYPE_COMBOBOX
// ELEMENT_TYPE_GRIDLIST
// ELEMENT_TYPE_LABEL
// ELEMENT_TYPE_PROGRESSBAR
// ELEMENT_TYPE_RADIOBUTTON
// ELEMENT_TYPE_SCROLLBAR
// ELEMENT_TYPE_SCROLLPANE
// ELEMENT_TYPE_TABPANEL
// ELEMENT_TYPE_TAB
// ELEMENT_TYPE_IMAGE

// cmd("sts", function(playerid) {
//     local window  = GUI.Window("Seelct stuff");
//     local entries = bkGetTeamsForDay();

//     foreach (idx, value in entries) {
//         window.add([
//             GUI.Button("The Bats", function(playerid) {
//                 msg(playerid, "you've clicked button 1")
//             }),
//             GUI.Label("5/1 asds -- asd 5/1"),
//             GUI.Button("The asdasd", function(playerid) {
//                 msg(playerid, "you've clicked button 2")
//             })
//         ]);
//     }

//     window.show(playerid);
// });


// cmd("alert", function(playerid) {
//     GUI.Alert("WTF ??").show(playerid);
// });

// cmd("wtf", function(pid) {
//     local a = GUI.Window("Hello world");

//     local handler = function(pid) {
//         print(pid + " clicked");
//     };

//     a.setPosition(ORM.Position.center(-5, -10));
//     a.add([ ORM.Label("how hard you try"), ORM.Button("Try", handler) ]);

//     a.show(pid);
// });
