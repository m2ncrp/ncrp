include("controllers/business/functions.nut");
include("controllers/business/commands.nut");

const BUSINESS_DEFAULT = 0;
const BUSINESS_DINER   = 1;
const BUSINESS_BAR     = 2;
const BUSINESS_WEAPON  = 3;

const BUSINESS_INTERACT_DISTANCE = 2.5;
const BUSINESS_BUY_DISTANCE      = 1.0;
const BUSINESS_VIEW_DISTANCE     = 10.0;

event("onServerStarted", function() {
    log("[business] loading all businesses...");
    Business.findAll(function(err, results) {
        foreach (idx, business in results) {
            loadBusiness(business);
        }
    });
});

translation("en", {
    "business.money.income"     : "You've received $%.2f from your business '%s'!"
    "business.error.cantbuy"    : "You can't buy that business right now!"
    "business.error.faraway"    : "You are far away from any business!"
    "business.error.owned"      : "You cant buy a business which is already owned!"
    "business.purchase.success" : "You've successfuly purchased '%s'!"
});

event("onServerStopping", saveBusinesses);
event("onServerAutosave", saveBusinesses);

event("onServerHourChanged", function() {
    return calculateBusinessIncome();
});
