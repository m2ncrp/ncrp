GUI <- { __version = "001" };

// include("controllers/gui/Object.nut");
// include("controllers/gui/Object.nut");
enum GUI_ELEMENT_TYPE {
    WINDOW,
    EDIT,
    BUTTON,
    CHECKBOX,
    COMBOBOX,
    GRIDLIST,
    LABEL,
    PROGRESSBAR,
    RADIOBUTTON,
    SCROLLBAR,
    SCROLLPANE,
    TABPANEL,
    TAB,
    IMAGE,
};

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


key("mouse_left", function(playerid) {
    dbg("clicked mouse1");
});
