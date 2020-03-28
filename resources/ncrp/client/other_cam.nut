addEventHandler("setCameraPosition", function(x, y, z) {
executeLua("p = game.game:GetActivePlayer() cam = game.cameramanager:GetPlayerMainCamera(0) cam:LockControl(true, false) cam:SetCameraRotation(p:GetPos() + p:GetDir() + Math:newVector("+x+", "+y+", "+z+"))");

// cam:LockLookAtEntity(game.entitywrapper:GetEntityByName("CamPos"), joesCar, -1)
	//game.entitywrapper:GetEntityByName("CamPos"):SetPos(joesCar:GetPos() + joesCar:GetDir() * -2 + Math:newVector(0, 0, 0.4))
	//executeLua("cam = game.cameramanager:GetPlayerMainCamera(0) game.entitywrapper:GetEntityByName('CamPos'):SetPos(Math:newVector(-1380.0, 1358.0, -13.31))");
    //cam:LockLookAtEntity(game.entitywrapper:GetEntityByName("CamPos"), joesCar, -1)
    //game.game:GetActivePlayer():InventoryAddItem(36)");

		// p:SetControlStyle(enums.ControlStyle.LOCKED) - фриз игрока
});

addEventHandler("setOpenSeason", function() {
	executeLua("game.traffic:OpenSeason(22)");
});

addEventHandler("ArmyTrucksActivate", function() {
	executeLua("sendMessage(missions.M02RideToFreddysBar.M02ArmyTrucks, 1, 0)")
});
