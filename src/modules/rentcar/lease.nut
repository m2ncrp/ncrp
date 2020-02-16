local LEASE_DEPOSIT = 50.0;

function leaseCar(playerid) {

    if(checkPlayerSectionData(playerid, "lease")) {
        if(!players[playerid].data.lease.accessible) {
            return msg(playerid, "Вам недоступна возможность сдачи автомобиля в аренду.", CL_ERROR);
        }
    } else {
        msg(playerid, "rentcar.lease.dontknow", CL_HELP);
        msg(playerid, "rentcar.explorecity", CL_HELP);
        return;
    }

    local plaPos = getPlayerPosition(playerid);

    // if(!isInPlace("CarRent", plaPos[0], plaPos[1])) {
    //     return msg(playerid, "Сдать автомобиль в аренду можно на одной из площадок, которые обозначены на карте", CL_HELP);
    // }

    if(!isPlayerInVehicle(playerid)) {
        msg(playerid, "Сдать автомобиль в аренду можно только находясь в нём.", CL_ERROR);
    }

    local vehicleid     = getPlayerVehicle( playerid );
    local vehPos        = getVehiclePositionObj( vehicleid );
    local vehRot        = getVehicleRotationObj( vehicleid );


    // if(!isInPlace("CarRent", vehPos.x, vehPos.y)) {
    //     return msg(playerid, "Сдать автомобиль в аренду можно только в специальных местах.", CL_ERROR);
    // }

    if (!isPlayerHaveVehicleKey(playerid, vehicleid)) {
        return msg(playerid, "vehicle.owner.warning", CL_ERROR);
    }

    if (isGovVehicle(getVehiclePlateText(vehicleid))) {
        return msg(playerid, "Этот автомобиль нельзя сдать в аренду.", CL_ERROR);
    }


    if(isVehicleCarRent(vehicleid)) {
        return msg(playerid, "Этот автомобиль уже сдаётся.", CL_ERROR);
    }

    if(getVehicleDirtLevel(vehicleid) > 0.1) {
        return msg(playerid, "Автомобиль грязный.", CL_ERROR);
    }

    if(getVehicleFuelEx(vehicleid) / getDefaultVehicleFuel(vehicleid) < 0.7) {
        return msg(playerid, "В автомобиле мало топлива.", CL_ERROR);
    }

    if(!canMoneyBeSubstracted(playerid, LEASE_DEPOSIT)) {
        return msg(playerid, format("Недостаточно денег для внесение депозита ($%.2f).", [LEASE_DEPOSIT]), CL_ERROR);
    }

    trigger(playerid, "hudCreateTimer", 30, true, true);

    local complete = false;

    delayedFunction(30000, function() {
        if (complete == false) {
            return msg(playerid, "Аренда не подтверждена", CL_THUNDERBIRD);
        }
    });

    msg(playerid, "Введите стоимость аренды в долларах за час (игровой):", CL_HELP);
    delayedFunction( 1000, function() {
        requestUserInput(playerid, function(playerid, price) {

            trigger(playerid, "hudDestroyTimer");
            if (!price || !isFloat(price) || price.tofloat() <= 0) {
                return msg(playerid, "Указана некорректная стоимость", CL_THUNDERBIRD);
            }

            price = price.tofloat();

            blockDriving(playerid, vehicleid);

            local veh = getVehicleEntity(vehicleid);

            if(("rent" in veh.data) == false) {
                veh.data.rent <- {}
            }

            subMoneyToPlayer(playerid, LEASE_DEPOSIT);

            veh.data.rent = {
                price = price,
                money = LEASE_DEPOSIT,
                count = 0
            }

            veh.data.defaultPos <- vehPos;
            veh.data.defaultRot <- vehRot;

            setVehicleRespawnPositionObj(vehicleid, vehPos)
            setVehicleRespawnRotationObj(vehicleid, vehRot)
            setVehicleRespawnEx(vehicleid, true);

            complete = true;

            msg(playerid, format("Стоимость аренды за час: $%.2f", price), CL_JORDYBLUE);
            msg(playerid, "Автомобиль выставлен в аренду.", CL_SUCCESS);
            return;

        }, 30);
    });
}

function unleaseCar(playerid) {

    local plaPos = getPlayerPosition(playerid);

    // if(!isInPlace("CarRent", plaPos[0], plaPos[1])) {
    //     return msg(playerid, "Сдать автомобиль в аренду можно на одной из площадок, которые обозначены на карте", CL_HELP);
    // }

    if(!isPlayerInVehicle(playerid)) {
        msg(playerid, "Чтобы забрать автомобиль из аренды, вы должны находиться в нём");
    }

    local vehicleid     = getPlayerVehicle( playerid );
    local vehPos        = getVehiclePositionObj( vehicleid );

    // if(!isInPlace("CarRent", vehPos.x, vehPos.y)) {
    //     return msg(playerid, "Сдать автомобиль в аренду можно только в специальных местах.", CL_ERROR);
    // }
       // удаляет информацию о стоимости авто и позицию.
       // возвращает все деньги с баланса в наличку игроку (за вычетом комиссии)

    if(!isPlayerHaveVehicleKey(playerid, vehicleid)) {
        return msg(playerid, "vehicle.owner.warning", CL_ERROR);
    }

    if(!isVehicleCarRent(vehicleid)) {
        return msg(playerid, "Этот автомобиль не сдаётся", CL_ERROR);
    }

    local veh = getVehicleEntity(vehicleid);

    delete veh.data.defaultPos;
    delete veh.data.defaultRot;

    setVehicleRespawnEx(vehicleid, false);

    addMoneyToPlayer(playerid, veh.data.rent.money);
    unblockDriving(vehicleid);

    msg(playerid, "Автомобиль снят с аренды.", CL_SUCCESS);
    msg(playerid, format("Вместе с депозитом ($%.2f) вы получили: $%.2f", LEASE_DEPOSIT, veh.data.rent.money), CL_JORDYBLUE);
    delete veh.data.rent;
}

function leaseGetStats(playerid) {

    local vehicleid = getPlayerVehicle( playerid );

    if (!isPlayerHaveVehicleKey(playerid, vehicleid)) {
        return msg(playerid, "vehicle.owner.warning", CL_ERROR);
    }

    if(!isVehicleCarRent(vehicleid)) {
        return msg(playerid, "Этот автомобиль не сдаётся", CL_ERROR);
    }

    if(getPlayerWhoRentVehicle(vehicleid) != null) {
        return msg(playerid, "Этот автомобиль сейчас арендован", CL_ERROR);
    }

    local veh = getVehicleEntity(vehicleid);

    msg(playerid, ".:: Сведения об аренде ::.", CL_HELP);
    msg(playerid, format("Стоимость аренды за час: $%.2f", veh.data.rent.price), CL_JORDYBLUE);
    msg(playerid, format("Количество аренд: %d", veh.data.rent.count), CL_JORDYBLUE);
    msg(playerid, format("Топливо: %d из %d л.", getVehicleFuelEx(vehicleid), getDefaultVehicleFuel(vehicleid)), CL_JORDYBLUE);
    msg(playerid, format("Баланс: $%.2f", veh.data.rent.money), CL_JORDYBLUE);
}