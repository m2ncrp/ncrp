include("modules/organizations/treasury/models/Treasury.nut");
include("modules/organizations/treasury/commands.nut");

local TREASURY = null;

event("onServerStarted", function() {
    log("[treasury] loading treasury...");

    Treasury.findAll(function(err, results) {
        if (results.len()) {
            TREASURY = results[0];
        } else {
            TREASURY = Treasury();
            TREASURY.amount = 1000.0;
            TREASURY.tax_roads = 10.0;
            TREASURY.tax_salary = 10.0;
            TREASURY.save();
        }
    })
});


function addMoneyToTreasury(amount) {
    local amount = round(fabs(amount.tofloat()), 2);
    TREASURY.amount += amount;
    TREASURY.save();
    dbg("chat", "idea", "Городская казна", "Пополнение на сумму: "+amount.tostring());
}


function subMoneyToTreasury(amount) {
    local amount = round(fabs(amount.tofloat()), 2);
    TREASURY.amount -= amount;
    TREASURY.save();
    dbg("chat", "idea", "Городская казна", "Списание на сумму: "+amount.tostring());
}


function canTreasuryMoneyBeSubstracted(amount) {
    local amount = round(fabs(amount.tofloat()), 2);
    return (TREASURY.amount >= amount);
}


function getMoneyTreasury() {
    return TREASURY.amount;
}
