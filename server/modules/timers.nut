world.addTimer("world_second", function() {
	world.onSecondChange();
}, 1000); // 1 second

world.addTimer("car_respawn", function() {
	local vehicles = world.getVehicles();
	foreach(vehicle in vehicles) {
		if (vehicle.isDriven() && !vehicle.isOwner(vehicle.getDriver())) {
			vehicle.moveBack();
		}
	}
}, 10);//60000 * 20); // 20 minutes
