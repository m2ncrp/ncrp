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

    if(getVehicleFuelEx(vehicleid) / getDefaultVehicleFuel(vehicleid) < 0.5) {
        return msg(playerid, "В автомобиле мало топлива.", CL_ERROR);
    }

    if(!canMoneyBeSubstracted(playerid, LEASE_DEPOSIT)) {
        return msg(playerid, "Недостаточно денег для внесения депозита ($%.2f).", LEASE_DEPOSIT, CL_ERROR);
    }

    trigger(playerid, "hudCreateTimer", 30, true, true);

    local timer = delayedFunction(30000, function() {
        return msg(playerid, "Аренда не подтверждена", CL_THUNDERBIRD);
    });

    msg(playerid, "1. Введите стоимость аренды в долларах за час (игровой):", CL_HELP);
    delayedFunction(0, function() {
        requestUserInput(playerid, function(playerid, price) {

            trigger(playerid, "hudDestroyTimer");
            timer.Kill();

            if (!price || !isFloat(price) || price.tofloat() <= 0) {
                return msg(playerid, "Указана некорректная стоимость аренды", CL_THUNDERBIRD);
            }

            price = price.tofloat();
            msg(playerid, format("$ %.2f", price), CL_JORDYBLUE);

            local timer2 = delayedFunction(30000, function() {
                return msg(playerid, "Аренда не подтверждена", CL_THUNDERBIRD);
            });

            trigger(playerid, "hudCreateTimer", 30, true, true);

            local baseFuelPrice = getSettingsValue("baseFuelPrice");

            msg(playerid, "2. Введите максимальную цену галлона топлива, по которой арендаторы смогут заправлять этот автомобиль:", CL_HELP);
            msg(playerid, format("Цена не может быть ниже $ %.2f. Указывайте разумный предел", baseFuelPrice), CL_GRAY);
            delayedFunction(0, function() {
                requestUserInput(playerid, function(playerid, fuelPrice) {
                    trigger(playerid, "hudDestroyTimer");
                    timer2.Kill();

                    if (!fuelPrice || !isFloat(fuelPrice) || fuelPrice.tofloat() < baseFuelPrice) {
                        return msg(playerid, "Указана некорректная максимальная цена топлива", CL_THUNDERBIRD);
                    }

                    fuelPrice = fuelPrice.tofloat();
                    msg(playerid, format("$ %.2f", fuelPrice), CL_JORDYBLUE);

                    blockDriving(playerid, vehicleid);

                    local veh = getVehicleEntity(vehicleid);

                    if(("rent" in veh.data) == false) {
                        veh.data.rent <- {}
                        veh.data.rent = {
                            enabled = true,
                            count = 0,
                            countall = 0,
                            money = 0,
                            price = 0,
                            fuelPrice = 0
                        }
                    }

                    subMoneyToPlayer(playerid, LEASE_DEPOSIT);

                    veh.data.rent.enabled = true;
                    veh.data.rent.money += LEASE_DEPOSIT;
                    veh.data.rent.price = price;
                    veh.data.rent.fuelPrice = fuelPrice;

                    veh.data.defaultPos <- vehPos;
                    veh.data.defaultRot <- vehRot;
                    veh.save();

                    setVehicleRespawnPositionObj(vehicleid, vehPos)
                    setVehicleRespawnRotationObj(vehicleid, vehRot)
                    setVehicleRespawnEx(vehicleid, true);

                    msg(playerid, "Стоимость аренды за час: $ %.2f", price, CL_JORDYBLUE);
                    msg(playerid, "Максимальная цена покупки галлона топлива: $ %.2f", fuelPrice, CL_JORDYBLUE);
                    msg(playerid, "Автомобиль выставлен в аренду.", CL_SUCCESS);
                    return;
                }, 30);
            });
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
        return msg(playerid, "Этот автомобиль не сдан в аренду.", CL_ERROR);
    }

    local veh = getVehicleEntity(vehicleid);

    delete veh.data.defaultPos;
    delete veh.data.defaultRot;

    setVehicleRespawnEx(vehicleid, false);

    addMoneyToPlayer(playerid, veh.data.rent.money);
    unblockDriving(vehicleid);

    msg(playerid, "Автомобиль снят с аренды.", CL_SUCCESS);
    msg(playerid, "Возвращён депозит ($%.2f). Чистый доход: $%.2f", [LEASE_DEPOSIT, veh.data.rent.money - LEASE_DEPOSIT], CL_JORDYBLUE);
    veh.data.rent.enabled = false;
    veh.data.rent.money = 0;
    veh.data.rent.count = 0;
    veh.save();
}

function leaseGetStats(playerid) {

    if (!isPlayerInVehicle(playerid)) return msg(playerid, "Вы должны быть в личном автомобиле!", CL_ERROR);

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
    msg(playerid, "Стоимость аренды за час: $ %.2f", veh.data.rent.price, CL_JORDYBLUE);
    msg(playerid, "Максимальная цена покупки галлона топлива: $ %.2f", veh.data.rent.fuelPrice, CL_JORDYBLUE);
    msg(playerid, "Количество аренд: %d (всего: %d)", [veh.data.rent.count, veh.data.rent.countall], CL_JORDYBLUE);
    msg(playerid, "Топливо: %d из %s", [getVehicleFuelEx(vehicleid), formatGallonsInteger(getDefaultVehicleFuel(vehicleid))], CL_JORDYBLUE);
    msg(playerid, "Баланс: $ %.2f", veh.data.rent.money, CL_JORDYBLUE);
}