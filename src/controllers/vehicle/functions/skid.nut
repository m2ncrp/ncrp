// Вырубить управление
function spoilVehicleControls(vehicleid) {
  local driverid = getVehicleDriver(vehicleid);
  if(driverid == null) return;

  freezePlayer(driverid, true);

  delayedFunction(2000, function() {
    freezePlayer(driverid, false);
  })
}

// Дёрнуть руль в какую-то сторону
function skidVehicle(vehicleid) {
  local driverid = getVehicleDriver(vehicleid);
  if(driverid == null) return;
  local toRight = random(0, 1);
  triggerClientEvent(driverid, "setVehicleSteer", (random(5, 15) * 1.0) * (toRight ? -1 : 1))

  delayedFunction(1500, function() {
    triggerClientEvent(driverid, "setVehicleSteer", 0.0)
  })
}

// затормозить, будто в снег въехал
function slowDownVehicle(vehicleid) {
  for (local i = 1; i <= 20; i++) {
    local j = i;
    local sp = getVehicleSpeed(vehicleid);
    delayedFunction(j*50, function() {
        local k = 1 - 0.025 * j;
        setVehicleSpeed(vehicleid, sp[0] * k, sp[1] * k, sp[2] * k);
    })
  }
}

