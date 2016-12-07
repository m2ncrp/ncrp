
cmd("sts", function(playerid) {
    local window  = GUI.Window("Seelct stuff");
    local entries = bkGetTeamsForDay();

    foreach (idx, value in entries) {
        window.add([
            GUI.Button("The Bats", function(playerid) {
                msg(playerid, "you've clicked button 1")
            }),
            GUI.Label("5/1 asds -- asd 5/1"),
            GUI.Button("The asdasd", function(playerid) {
                msg(playerid, "you've clicked button 2")
            })
        ]);
    }

    window.show(playerid);
});


cmd("alert", function(playerid) {
    GUI.Alert("WTF ??").show(playerid);
});
