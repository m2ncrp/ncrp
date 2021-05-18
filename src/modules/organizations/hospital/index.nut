const HOSPITAL_X         = -393.429;
const HOSPITAL_Y         = 912.044;
const HOSPITAL_Z         = -20.0026;
const HOSPITAL_RADIUS    = 2.0;
const HOSPITAL_HEAL_FIX  = 4.0;

event("onServerStarted", function() {
    logStr("starting hospital...");
});

alternativeTranslate({
    "en|hospital.money.deducted" : "You've successfully payed $%.2f for your treatment!"
    "ru|hospital.money.deducted" : "Вас выписали из госпиталя. Лечение обошлось вам в $%.2f."

    "en|hospital.money.donthave" : "You don't have enough money to pay for full treatment!"
    "ru|hospital.money.donthave" : "У вас недостаточно денег для оплаты полного лечения."

    "en|hospital.money.donthave" : "You don't have enough money to pay for full treatment!"
    "ru|hospital.money.donthave" : "У вас недостаточно денег для оплаты полного лечения."

    "en|hospital.money.notenough" : "You don't have enough money to pay for treatment!"
    "ru|hospital.money.notenough" : "У вас недостаточно денег для оплаты лечения."

    "en|hospital.heal.complete" : "You've payed $%.2f for your treatment!"
    "ru|hospital.heal.complete" : "Ваше здоровье снова в норме. Лечение обошлось в $%.2f."
});

event("onServerPlayerStarted", function( playerid ) {
    createPrivate3DText ( playerid, HOSPITAL_X, HOSPITAL_Y, HOSPITAL_Z+0.35, plocalize(playerid, "3dtext.organizations.hospital"), CL_ROYALBLUE );
    createPrivate3DText ( playerid, HOSPITAL_X, HOSPITAL_Y, HOSPITAL_Z+0.20, [[ "Heal", (getGovernmentValue("hospitalTreatmentPrice") + HOSPITAL_HEAL_FIX).tostring()], "%s ($%s): /heal"], CL_WHITE.applyAlpha(150), HOSPITAL_RADIUS );
});

cmd("heal", function(playerid) {
    if (!isPlayerInValidPoint(playerid, HOSPITAL_X, HOSPITAL_Y, HOSPITAL_RADIUS )) {
        return;
    }

    local amount = getGovernmentValue("hospitalTreatmentPrice") + HOSPITAL_HEAL_FIX;

    if (!canMoneyBeSubstracted(playerid, amount)) {
        return msg(playerid, "hospital.money.notenough", CL_ERROR);
    }

    subMoneyToPlayer(playerid, amount);
    addTreasuryMoney(amount);
    setPlayerHealth(playerid, 720.0);
    msg(playerid, "hospital.heal.complete", [amount], CL_SUCCESS);
});