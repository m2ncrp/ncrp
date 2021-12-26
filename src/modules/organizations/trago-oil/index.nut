const FUEL_JOB_X = 551.762;
const FUEL_JOB_Y = -266.866;
const FUEL_JOB_Z = -20.1644;

event("onServerStarted", function() {
    create3DText(FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z+0.35, "TRAGO OIL", CL_ROYALBLUE);
    create3DText(FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z+0.20, "/job fuel | /fuel orders", CL_WHITE.applyAlpha(150), 2.0);

    registerPersonalJobBlip("fueldriver", FUEL_JOB_X, FUEL_JOB_Y);
});

cmd("fuel", "orders", function(playerid) {
    if(!isPlayerInValidPoint(playerid, FUEL_JOB_X, FUEL_JOB_Y, 2.0)) {
        return msg(playerid, "Чтобы посмотреть список заказов на топливо, отправляйтесь к штаб-квартире Trago Oil в Ойстер-Бэй.", CL_ERROR)
    }

    local stations = getFuelStations();
    local list = [];

    foreach (name, station in stations) {
      local needGallons = Math.max(0, Math.min(FUEL_STATION_LIMIT - station.data.fuel.amount, station.data.fuel.amountIn));
      if (station.state != "opened" || station.data.fuel.amountIn == 0.0 || needGallons == 0.0) continue;
      local price = station.data.fuel.priceIn;
      local readyToBuyGallons = Math.min(needGallons, station.data.money / price);
      local total = readyToBuyGallons * price;
      if (station.state != "opened" || station.data.fuel.amountIn == 0.0 || needGallons == 0.0 || readyToBuyGallons == 0.0) continue;
      list.push(format("%s покупает %.2f гал. по $%.2f/гал. Итого: $%.2f", name, readyToBuyGallons, price, total));
    }

    if(list.len()== 0) {
        return msg(playerid, "Заказов на поставку топлива в данный момент нет", CL_JORDYBLUE);
    }

    msgh(playerid, "Заказы на поставку топлива", list);
});
