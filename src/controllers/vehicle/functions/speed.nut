units <- {
  kmh = 3.6,  // километры в час
  mps = 1,    // метры в секунду
  mph = 2.237 // мили в час
}

function getVehicleRealSpeed(vehicleid, unit = "kmh")
{
  local velo = getVehicleSpeed(vehicleid)
  return getDistanceBetweenPoints3D(0.0, 0.0, 0.0, velo[0], velo[1], velo[2]) * units[unit];
}
