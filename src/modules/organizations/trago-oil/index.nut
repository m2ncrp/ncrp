const FUEL_JOB_X = 551.762;
const FUEL_JOB_Y = -266.866;
const FUEL_JOB_Z = -20.1644;

event("onServerStarted", function() {
    create3DText ( FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z+0.35, "TRAGO OIL", CL_ROYALBLUE );
    create3DText ( FUEL_JOB_X, FUEL_JOB_Y, FUEL_JOB_Z+0.20, "/job fuel | /fuel list", CL_WHITE.applyAlpha(150), 2.0);

    registerPersonalJobBlip("fueldriver", FUEL_JOB_X, FUEL_JOB_Y);
});

cmd("fuel", "list", function(playerid) {
  local stations = getFuelStations();
  local list = [];

  foreach (name, station in stations) {
    if(station.state != "opened" || station.data.fuel.amountIn == 0.0 ) continue;
    local price = station.data.fuel.priceIn;
    local needGallons = Math.min(FUEL_STATION_LIMIT - station.data.fuel.amount, station.data.fuel.amountIn);
    local readyBoughtGallons = Math.min(needGallons, station.data.money / price);
    local total = readyBoughtGallons * price;
    list.push(format("%s покупает %.2f ед. по $%.2f за галлон. Итого: $%.2f", name, readyBoughtGallons, price, total));
  }

  msgh(playerid, "Зазказы на поставку топлива", list);
});
