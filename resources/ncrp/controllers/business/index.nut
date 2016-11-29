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
    Business.findAll(function(err, results) {
        foreach (idx, business in results) {
            loadBusiness(business);
        }
    });
});

translation("en", {
    "business.money.income"     : "You've earned %.2f from your business «%s» !",
    "business.error.cantbuy"    : "You can't buy a business right now!"
});

translation("ru", {
    "business.money.income"     : "Вы заработали %.2f от вашего бизнеса «%s» !",
    "business.error.cantbuy"    : "Сейчас у вас нет возможности купить бизнес !"
});


event("onServerStopping", saveBusinesses);
event("onServerAutosave", saveBusinesses);

event("onServerHourChanged", function() {
    return calculateBusinessIncome();
});
