cmd("rent", function(playerid, sub = 0, targetid = null) {
    if (sub == 0) {
        if(checkPlayerSectionData(playerid, "rent")) {
            msg(playerid, "");
            msg(playerid, ".:: Аренда автомобиля ::.", CL_HELP);
            msg(playerid, "Телефон: 555-0192", CL_SILVERSAND);
            msg(playerid, "/unrent - отказаться от аренды", CL_JORDYBLUE);
            return;
        }
        msg(playerid, "rentcar.rent.dontknow", CL_HELP);
        msg(playerid, "rentcar.explorecity", CL_HELP);
        return;
    }

    if (sub == "allow" && isPlayerAdmin(playerid)) {
        if(!targetid) {
            return msg(playerid, "Необходимо указать id: /rent allow id", CL_ERROR)
        }
        targetid = targetid.tointeger();
        if(!isPlayerConnected(targetid)) {
            return msg(playerid, format("Игрока с id %d нет на сервере", targetid), CL_ERROR)
        }
        setPlayerSectionData(targetid, "rent", { accessible = true })
        return msg(playerid, format("Игроку с id %d разрешено арендовать автомобиль", targetid), CL_SUCCESS);
    }

    if (sub == "ban" && isPlayerAdmin(playerid)) {
        if(!targetid) {
            return msg(playerid, "Необходимо указать id: /rent ban id", CL_ERROR)
        }
        targetid = targetid.tointeger();
        if(!isPlayerConnected(targetid)) {
            return msg(playerid, format("Игрока с id %d нет на сервере", targetid), CL_ERROR)
        }
        setPlayerSectionData(targetid, "rent", { accessible = false })
        return msg(playerid, format("Игроку с id %d запрещено арендовать автомобиль", targetid), CL_ERROR);
    }
});


cmd("lease", function(playerid, sub = 0, targetid = null) {
    if (sub == 0) {
        if(checkPlayerSectionData(playerid, "lease")) {
            msg(playerid, "");
            msg(playerid, ".:: Сдача автомобиля в аренду ::.", CL_HELP);
            msg(playerid, "/lease rules - правила сдачи в аренду", CL_JORDYBLUE);
            msg(playerid, "/lease terms - условия сдачи в аренду", CL_SILVERSAND);
            msg(playerid, "/lease start - сдать автомобиль в аренду", CL_JORDYBLUE);
            msg(playerid, "/lease stop - снять автомобиль с аренды", CL_SILVERSAND);
            msg(playerid, "/lease stats - посмотреть сведения об аренде", CL_JORDYBLUE);
            return;
        }
        msg(playerid, "rentcar.lease.dontknow", CL_HELP);
        msg(playerid, "rentcar.explorecity", CL_HELP);
    }

    if (sub == "start") {
        return leaseCar(playerid);
    }

    if (sub == "stop") {
        return unleaseCar(playerid);
    }

    if (sub == "stats") {
        return leaseGetStats(playerid);
    }

    if (sub == "rules") {
        msg(playerid, "");
        msg(playerid, ".:: Правила сдачи автомобиля в аренду:", CL_HELP);
        msg(playerid, "1. Вы не сможете пользоваться своим автомобилем.", CL_SILVERSAND);
        msg(playerid, "2. Депозит и доход от аренды формируют баланс автомобиля.", CL_JORDYBLUE);
        msg(playerid, "3. Заправка оплачивается с баланса автомобиля.", CL_SILVERSAND);
        msg(playerid, "4. Ремонт и мойку оплачивает арендатор за свой счёт.", CL_JORDYBLUE);
        msg(playerid, "5. Штрафы оплачивает арендатор за свой счёт.", CL_SILVERSAND);
        msg(playerid, "6. Транспортный налог начисляется в обычном режиме.", CL_JORDYBLUE);
        msg(playerid, "7. Забрать авто можно на месте парковки, если он не сдан.", CL_SILVERSAND);
        msg(playerid, "8. Обналичивание баланса происходит при снятии с аренды.", CL_JORDYBLUE);
        msg(playerid, "9. Правила могут меняться без дополнительного уведомления.", CL_SILVERSAND);
        // msg(playerid, "9. Комиссия 5 процентов, если баланс больше депозита.", CL_SILVERSAND);
        return;
    }

    if (sub == "terms") {
        msg(playerid, "");
        msg(playerid, ".:: Условия сдачи автомобиля в аренду:", CL_HELP);
        msg(playerid, "- Автомобиль ваш личный;", CL_SILVERSAND);
        msg(playerid, "- Автомобиль не грязный;", CL_JORDYBLUE);
        msg(playerid, "- Начисленная сумма налога не превышает лимит;", CL_SILVERSAND);
        msg(playerid, "- Автомобиль не находится в розыске;", CL_JORDYBLUE);
        msg(playerid, "- Топливный бак заполнен не менее, чем на 80 процентов;", CL_SILVERSAND);
        msg(playerid, "- У вас в наличии есть $50 для депозита;", CL_JORDYBLUE);
        return;
    }

    if (sub == "allow" && isPlayerAdmin(playerid)) {
        if(!targetid) {
            return msg(playerid, "Необходимо указать id: /lease allow id", CL_ERROR)
        }
        targetid = targetid.tointeger();
        if(!isPlayerConnected(targetid)) {
            return msg(playerid, format("Игрока с id %d нет на сервере", targetid), CL_ERROR)
        }
        setPlayerSectionData(targetid, "lease", { accessible = true })
        return msg(playerid, format("Игроку с id %d разрешено сдавать авто в аренду", targetid), CL_SUCCESS);
    }

    if (sub == "ban" && isPlayerAdmin(playerid)) {
        if(!targetid) {
            return msg(playerid, "Необходимо указать id: /lease ban id", CL_ERROR)
        }
        targetid = targetid.tointeger();
        if(!isPlayerConnected(targetid)) {
            return msg(playerid, format("Игрока с id %d нет на сервере", targetid), CL_ERROR)
        }
        setPlayerSectionData(targetid, "lease", { accessible = false })
        return msg(playerid, format("Игроку с id %d запрещено сдавать авто в аренду", targetid), CL_ERROR);
    }
});

function carRentalCall(playerid) {
    local defaulttogooc = getPlayerOOC(playerid);
    setPlayerOOC(playerid, false);

    local timer = null;
    function choiseTimeout(phrase) {
        timer = delayedFunction(30000, function() {
            if (timer.IsActive()) {
                timer.Kill();
                if(defaulttogooc) setPlayerOOC(playerid, true);
                return msg(playerid, phrase, CL_HELP);
            }
        });
    }

    msg(playerid, ".:: Aвтомобили в прокат. Здравствуйте, чем могу помочь?", CL_HELP);
    msg(playerid, "1. Хочу арендовать автомобиль", CL_JORDYBLUE);
    msg(playerid, "2. Хочу сдать автомобиль в аренду", CL_JORDYBLUE);
    msg(playerid, "Укажите номер интересующей вас информации в чат", CL_GRAY);

    trigger(playerid, "hudCreateTimer", 30, true, true);

    //msg(playerid, "/lease   -   ")
    delayedFunction( 1000, function() {
        choiseTimeout(".:: Перезвоните нам, когда определитесь. Всего доброго!");

        requestUserInput(playerid, function(playerid, choise) {
            timer.Kill();
            trigger(playerid, "hudDestroyTimer");

            if (!choise || (choise != "1" && choise != "2")) {
                if(defaulttogooc) setPlayerOOC(playerid, true);
                return msg(playerid, ".:: Перезвоните нам, когда определитесь. Всего доброго!", CL_HELP);
            }

            if(choise == "1") {
                if(checkPlayerSectionData(playerid, "rent") && players[playerid].data.rent.accessible == false) {
                    msg(playerid, ".:: Вы нарушали наши правила много раз, поэтому мы не готовы впредь предоставлять вам автомобили в аренду. Нам жаль.", CL_HELP);
                    return msg(playerid, "[DO] Разговор завершён", CL_CHAT_DO);
                }
                msg(playerid, ".:: Вы можете арендовать фирменный жёлтый автомобиль нашей компании с номерами, начинающимися на CR.", CL_SILVERSAND);
                delayedFunction(6000, function() {
                    msg(playerid, ".:: Автомобили доступны на парковках у вокзала, госпиталя, порта, рыбной фабрики, молочного цеха, автобусного депо, топливной компании и стадиона.", CL_HELP);
                    delayedFunction(8000, function() {
                        msg(playerid, ".:: Также вы можете арендовать частные автомобили.", CL_SILVERSAND);
                        delayedFunction(6000, function() {
                            msg(playerid, ".:: Стоимость аренды зависит от модели автомобиля.", CL_HELP);
                            delayedFunction(5000, function() {
                                msg(playerid, "Чтобы не разбивать стекло, нажмите F два раза подряд.", CL_CHAT_TIPS);
                                msg(playerid, "[DO] Разговор завершён", CL_CHAT_DO);
                                if(!checkPlayerSectionData(playerid, "rent")) {
                                    setPlayerSectionData(playerid, "rent", { accessible = true })
                                    delayedFunction(2000, function() {
                                        msg(playerid, "Теперь вам доступна аренда автомобилей.", CL_SUCCESS);
                                    });
                                }
                            });
                        });
                    });
                });
            }

            if(choise == "2") {
                if(checkPlayerSectionData(playerid, "lease") && players[playerid].data.lease.accessible == false) {
                    msg(playerid, ".:: Вы нарушали наши правила много раз, поэтому мы не готовы с вами сотрудничать. Нам жаль.", CL_HELP);
                    return msg(playerid, "[DO] Разговор завершён", CL_CHAT_DO);
                }
                msg(playerid, ".:: Вы можете сдать в аренду свой автомобиль и получать с этого доход.", CL_JORDYBLUE);
                delayedFunction(4000, function() {
                    msg(playerid, ".:: Всё очень просто:", CL_SILVERSAND);
                    delayedFunction(3000, function() {
                        msg(playerid, "- Подбираете место для размещения автомобиля.", CL_JORDYBLUE);
                        delayedFunction(5000, function() {
                            msg(playerid, "- Находясь в автомобиле, вводите: /lease", CL_SILVERSAND);
                            delayedFunction(5000, function() {
                                msg(playerid, "- Указываете стоимость аренды вашего автомобиля", CL_JORDYBLUE);
                                delayedFunction(5000, function() {
                                    msg(playerid, "- Всё готово! Ваш автомобиль сдаётся в аренду.", CL_SILVERSAND);
                                    msg(playerid, "[DO] Разговор завершён", CL_CHAT_DO);
                                    if(!checkPlayerSectionData(playerid, "lease")) {
                                        setPlayerSectionData(playerid, "lease", { accessible = true })
                                        delayedFunction(2000, function() {
                                         msg(playerid, "Теперь вам доступна сдача автомобилей в аренду.", CL_SUCCESS);
                                        });
                                    }
                                });
                            });
                        });
                    });
                });
            }
        }, 30);
    });
}

function showCarRentalParkingBlips(playerid) {
    local parkings = [
        [-1021.87, 1643.44, 10.6318 ],
        [-562.58, 1521.96, -16.1836 ],
        [-310.62, 1694.98, -22.3772 ],
        [-747.386, 1762.67, -15.0237],
        [-724.814, 1647.21, -14.9223],
    ]

    foreach (idx, parking in parkings) {
        local blip = createPrivateBlip(playerid, parking[0], parking[1], ICON_YELLOW, 4000.0);
        delayedFunction(30000, function(sblip) {
            removeBlip(sblip);
        }, blip);
    }
}

cmd("pped", function(playerid) {

    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -68.187, 370.748, -13.956, 0.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -66.187, 370.748, -13.956, 45.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -64.187, 370.748, -13.956, 90.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -62.187, 370.748, -13.956, 135.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -60.187, 370.748, -13.956, 180.0, 0.0, 0.0);

    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -68.187, 364.748, -13.956, 0.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -66.187, 364.748, -13.956, -45.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -64.187, 364.748, -13.956, -90.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -62.187, 364.748, -13.956, -135.0, 0.0, 0.0);
    trigger(playerid, "createPedTaxiPassenger", getPlayerName(playerid), 145, -60.187, 364.748, -13.956, -180.0, 0.0, 0.0);

});

cmd("unped", function(playerid) {
    trigger(playerid, "destroyPedTaxiPassenger", getPlayerName(playerid));
});
