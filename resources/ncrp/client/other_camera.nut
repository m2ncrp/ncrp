addEventHandler("cameralock", function () {
    executeLua("game.cameramanager:GetPlayerMainCamera(0):LockSetActor(game.game:GetActivePlayer(),1)");
    });

addEventHandler("cameraunlock", function () {
    executeLua("game.cameramanager:GetPlayerMainCamera(0):Unlock(0)");
    });
