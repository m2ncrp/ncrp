local _server_time = {minute = 0, hour = 8, day = 1, month = 1, year = 1952};

// addEventHandler("onClientFrameRender", function(post) {
//     if(!post && ("hour" in _server_time)) {
//         local screen = getScreenSize();
//         local t = _server_time;

//         foreach(name, value in t) {
//             if (!value) value = 0;
//             t[name] = value.tostring();
//             if (t[name].len() < 2) t[name] = "0" + value;
//         }

//         local ttime = t.hour + ":" + t.minute;
//         local timesize = dxGetTextDimensions(ttime, 3.2, "tahoma-bold");
//         dxDrawText(ttime, screen[0] - timesize[0] - 16.0, 28.0, 0xCCFFFFFF, false, "tahoma-bold", 3.2);

//         local tdate = t.day + "." + t.month + "." + t.year;
//         local datesize = dxGetTextDimensions(tdate, 1.6, "tahoma-bold");
//         dxDrawText(tdate, screen[0] - datesize[0] - 16.0, 70.0, 0xCCFFFFCC, false, "tahoma-bold", 1.6);
//         // dxDrawText("_________", screen[0] - datesize[0] - 16.0, 75.0, 0xFFFFFFFF, true, "tahoma-bold", 1.5);

//         local tmoney = "$00000242.23";
//         local moneysize = dxGetTextDimensions(tmoney, 2.4, "tahoma-bold");
//         dxDrawText(tmoney, screen[0] - moneysize[0] - 16.0, 92.0, 0xCC22AA22, false, "verdana", 2.4);

//     }
// });

addEventHandler("onServerTimeSync", function(m, h, d, mo, y) {
    local time = {minute = m, hour = h, day = d, month = mo, year = y};
    _server_time = time;
});
