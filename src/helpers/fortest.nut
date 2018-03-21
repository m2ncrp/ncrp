// private message
cmd("test", function(playerid) {
    msg(playerid, "OOC - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_OOC     );
    msg(playerid, "B - John Doe says: Произведение есть вещественный эле...",       CL_CHAT_B       );
    msg(playerid, "PM - John Doe says: Произведение есть вещественный эле...",      CL_CHAT_PM      );
    msg(playerid, "SHOUT - John Doe says: Произведение есть вещественный эле...",   CL_CHAT_SHOUT   );
    msg(playerid, "IC- John Doe says: Произведение есть вещественный эле...",       CL_CHAT_IC      );
    msg(playerid, "WHISPER - John Doe says: Произведение есть вещественный эле...", CL_CHAT_WHISPER );
    msg(playerid, "ME- John Doe says: Произведение есть вещественный эле...",       CL_CHAT_ME      );
    msg(playerid, "DO - John Doe says: Произведение есть вещественный эле...",      CL_CHAT_DO      );
    msg(playerid, "TODO - John Doe says: Произведение есть вещественный эле...",    CL_CHAT_TODO    );
    msg(playerid, "ADM - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_ADM     );
    msg(playerid, "DEV - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_DEV     );
    msg(playerid, "ERROR - John Doe says: Произведение есть вещественный эле...",   CL_ERROR        );
});

cmd("test2", function(playerid) {
    msg(playerid, "OOC - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_OOC     );
    msg(playerid, "B - John Doe says: Произведение есть вещественный эле...",       CL_CHAT_B       );
    msg(playerid, "PM - John Doe says: Произведение есть вещественный эле...",      CL_CHAT_PM      );
    msg(playerid, "SHOUT - John Doe says: Произведение есть вещественный эле...",   CL_CHAT_SHOUT   );
    msg(playerid, "IC- John Doe says: Произведение есть вещественный эле...",       CL_CHAT_IC      );
    msg(playerid, "WHISPER - John Doe says: Произведение есть вещественный эле...", CL_CHAT_WHISPER );
    msg(playerid, "ME- John Doe says: Произведение есть вещественный эле...",       CL_CHAT_ME      );
    msg(playerid, "DO - John Doe says: Произведение есть вещественный эле...",      CL_CHAT_DO      );
    msg(playerid, "TODO - John Doe says: Произведение есть вещественный эле...",    CL_CHAT_TODO    );
    msg(playerid, "ADM - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_ADM     );
    msg(playerid, "DEV - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_DEV     );
    msg(playerid, "ERROR - John Doe says: Произведение есть вещественный эле...",   CL_ERROR        );
});

// private message
cmd("md", function(playerid) {
    msg(playerid, "B - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_B     );
    msg(playerid, "ME - John Doe says: Произведение есть вещественный эле...",       CL_CHAT_ME       );
    msg(playerid, "B - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_B     );
    msg(playerid, "B - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_B     );
    msg(playerid, "ME - John Doe says: Произведение есть вещественный эле...",       CL_CHAT_ME       );
    msg(playerid, "B - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_B     );
    msg(playerid, "B - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_B     );
    msg(playerid, "ME - John Doe says: Произведение есть вещественный эле...",       CL_CHAT_ME       );
    msg(playerid, "ME - John Doe says: Произведение есть вещественный эле...",       CL_CHAT_ME       );
    msg(playerid, "ME - John Doe says: Произведение есть вещественный эле...",       CL_CHAT_ME       );
    msg(playerid, "B - John Doe says: Произведение есть вещественный эле...",     CL_CHAT_B     );
    msg(playerid, "ME - John Doe says: Произведение есть вещественный эле...",       CL_CHAT_ME       );
});


// private message
cmd("fly", function(playerid, plate) {

        msga("Start in 5 sec.", [], CL_ERROR);
        local pos = getPlayerPosition(playerid);
        delayedFunction(1000, function () {
            msga("Start in 4 sec.", [], CL_ERROR);
            delayedFunction(1000, function () {
                msga("Start in 3 sec.", [], CL_ERROR);
                delayedFunction(1000, function () {
                    msga("Start in 2 sec.", [], CL_ERROR);
                    delayedFunction(1000, function () {
                        msga("Start in 1 sec.", [], CL_ERROR);
                        delayedFunction(1000, function () {
                            msga("I believe I can fly", [], CL_SUCCESS);
                            local vehicleid = getVehicleByPlateText(plate.toupper());
                            setVehicleSpeed(vehicleid, 0.0, 0.0, 3.0);
                            local rot = getVehicleRotation(vehicleid);
                            delayedFunction(700, function () {
                                setVehicleSpeed(vehicleid, 0.0, 0.0, 5.0);
                                delayedFunction(400, function () {
                                    setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
                                    setVehiclePosition(vehicleid, pos[0], pos[1], 200.0);
                                    delayedFunction(500, function () {
                                        setVehiclePosition(vehicleid, pos[0], pos[1], pos[2]);
                                        setVehicleRotation(vehicleid, rot[0], rot[1], rot[2]);
                                        setVehicleSpeed(vehicleid, 0.0, 0.0, 0.0);
                                    })
                                })
                            });
                        });
                    });
                });
            });
        });
});
