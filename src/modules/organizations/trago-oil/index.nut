const FUEL_JOB_X = 551.762;
const FUEL_JOB_Y = -266.866;
const FUEL_JOB_Z = -20.1644;

event("onServerStarted", function() {
    create3DText(FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z+0.35, "TRAGO OIL", CL_ROYALBLUE);
    create3DText(FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z+0.20, "/job fuel | /fuel list", CL_WHITE.applyAlpha(150), 2.0);

    registerPersonalJobBlip("fueldriver", FUEL_JOB_X, FUEL_JOB_Y);
});

cmd("fuel", "orders", function(playerid) {
    if(!isPlayerInValidPoint(playerid, FUEL_JOB_X, FUEL_JOB_Y, 2.0)) {
        return msg(playerid, "Чтобы посомтреть список заказов на топливо, отправляйтесь к штаб-квартире Trago Oil в Ойстер-Бэй.", CL_ERROR)
    }

    local stations = getFuelStations();
    local list = [];

    foreach (name, station in stations) {
      if (station.state != "opened" || station.data.fuel.amountIn == 0.0) continue;
      local price = station.data.fuel.priceIn;
      local needGallons = Math.min(FUEL_STATION_LIMIT - station.data.fuel.amount, station.data.fuel.amountIn);
      local readyToBuyGallons = Math.min(needGallons, station.data.money / price);
      local total = readyToBuyGallons * price;
      list.push(format("%s покупает %.2f ед. по $%.2f за галлон. Итого: $%.2f", name, readyToBuyGallons, price, total));
    }

    msgh(playerid, "Заказы на поставку топлива", list);
});
