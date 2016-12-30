local businessesIncr = 0;
local businesses = {};
local businessDefaults = [
    { type = BUSINESS_DEFAULT, blip = null,         info = null,        price = 15000.0,  income = 10.0 },
    { type = BUSINESS_DINER,   blip = ICON_BURGER,  info = "/eat",      price = 25000.0,  income = 15.0 },
    { type = BUSINESS_BAR,     blip = ICON_BAR,     info = "/drink",    price = 45000.0,  income = 40.0 },
    { type = BUSINESS_WEAPON,  blip = ICON_WEAPON,  info = "/weapons",  price = 100000.0, income = 65.0 },
];

function getBusinessInfo(type) {
    foreach (idx, value in businessDefaults) {
        if (type == value.type) return value;
    }
    return null;
}

function loadBusinessResources(entity) {
    local pricetag;

    if (entity.owner == "") {
        pricetag = format("(Price: $%.2f, Income: $%.2f) /business buy", entity.price, entity.income, entity.servid);
    } else {
        pricetag = format("(Owner: %s, Income: $%.2f)", entity.owner, entity.income);
    }

    entity.text1 = create3DText( entity.x, entity.y, entity.z + 0.35, entity.name, CL_RIPELEMON , BUSINESS_VIEW_DISTANCE);
    entity.text2 = create3DText( entity.x, entity.y, entity.z + 0.05, pricetag, CL_EUCALYPTUS.applyAlpha(125), BUSINESS_BUY_DISTANCE );

    local info = getBusinessInfo(entity.type);
    if (entity.type != BUSINESS_DEFAULT && info && info.info) {
        entity.text3 = create3DText( entity.x, entity.y, entity.z + 0.20, info.info, CL_WHITE.applyAlpha(75), BUSINESS_INTERACT_DISTANCE );
        entity.blip  = createBlip(   entity.x, entity.y, info.blip );
    }
}

function freeBusinessResources(entity) {
    if (entity && entity instanceof Business) {
        if (entity.text1) remove3DText(entity.text1);
        if (entity.text2) remove3DText(entity.text2);
        if (entity.text3) remove3DText(entity.text3);
        return true;
    }

    return false;
}

/**
 * Create business using provided parameters
 * @param  {Float} x
 * @param  {Float} y
 * @param  {Float} z
 * @param  {String} name
 * @param  {Integer} type
 * @return {Integer} created biz id
 */
function createBusiness(x, y, z, name, type) {
    local biz = Business();

    biz.x = x.tofloat();
    biz.y = y.tofloat();
    biz.z = z.tofloat();
    biz.name = name;
    biz.type = type.tointeger();

    local info = getBusinessInfo(type.tointeger());
    biz.income = info.income;
    biz.price  = info.price;

    // store it
    return loadBusiness(biz);
}

function loadBusiness(entity) {
    businesses[++businessesIncr] <- entity;
    entity.servid = businessesIncr;
    loadBusinessResources(entity);
    return businessesIncr;
}

/**
 * Destroy business by id
 * @param  {Integer} bizid
 * @return {Boolean} result
 */
function destroyBusiness(bizid) {
    if (!(bizid in businesses)) {
        return false;
    }

    freeBusinessResources(businesses[bizid]);
    businesses[bizid].remove();
    delete businesses[bizid];
}

/**
 * Set business name
 * @param {Integer} bizid
 * @param {String} amount
 * @return {Boolean} result
 */
function setBusinessName(bizid, name) {
    if (!(bizid in businesses)) {
        return false;
    }

    businesses[bizid].name = name.tostring();
    businesses[bizid].save();
    freeBusinessResources(businesses[bizid]);
    loadBusinessResources(businesses[bizid]);
    return true;
}

/**
 * Get business name
 * @param  {Integer}
 * @return {String}
 */
function getBusinessName(bizid) {
    if (!(bizid in businesses)) {
        return false;
    }

    return businesses[bizid].name;
}

/**
 * Set business type
 * @param {Integer} bizid
 * @param {Integer} type
 * @return {Boolean} result
 */
function setBusinessType(bizid, type) {
    if (!(bizid in businesses)) {
        return false;
    }

    businesses[bizid].type = type.tointeger();
    businesses[bizid].save();
    freeBusinessResources(businesses[bizid]);
    loadBusinessResources(businesses[bizid]);
    return true;
}

/**
 * Get business type
 * @param  {Integer}
 * @return {Integer}
 */
function getBusinessType(bizid) {
    if (!(bizid in businesses)) {
        return false;
    }

    return businesses[bizid].type;
}

/**
 * Set business price
 * @param {Integer} bizid
 * @param {Float} amount
 * @return {Boolean} result
 */
function setBusinessPrice(bizid, amount) {
    if (!(bizid in businesses)) {
        return false;
    }

    businesses[bizid].price = amount.tofloat();
    businesses[bizid].save();
    freeBusinessResources(businesses[bizid]);
    loadBusinessResources(businesses[bizid]);
    return true;
}

/**
 * Get business price
 * @param  {Integer}
 * @return {Float}
 */
function getBusinessPrice(bizid) {
    if (!(bizid in businesses)) {
        return false;
    }

    return businesses[bizid].price;
}

/**
 * Set business income
 * @param {Integer} bizid
 * @param {Float} amount
 * @return {Boolean} result
 */
function setBusinessIncome(bizid, amount) {
    if (!(bizid in businesses)) {
        return false;
    }

    businesses[bizid].income = amount.tofloat();
    businesses[bizid].save();
    freeBusinessResources(businesses[bizid]);
    loadBusinessResources(businesses[bizid]);
    return true;
}

/**
 * Get business income
 * @param  {Integer}
 * @return {Float}
 */
function getBusinessIncome(bizid) {
    if (!(bizid in businesses)) {
        return false;
    }

    return businesses[bizid].income;
}

/**
 * Set business owner
 * @param {Integer} bizid
 * @param {String/Integer} playeridOrName
 * @return {Boolean} result
 */
function setBusinessOwner(bizid, playeridOrName) {
    if (!(bizid in businesses)) {
        return false;
    }

    if (isInteger(playeridOrName)) {
        playeridOrName = getPlayerName(playeridOrName);
    }

    businesses[bizid].owner = playeridOrName.tostring();
    businesses[bizid].save();

    freeBusinessResources(businesses[bizid]);
    loadBusinessResources(businesses[bizid]);

    return true;
}

/**
 * Get business owner
 * @param  {Integer} bizid
 * @return {String} owner name
 */
function getBusinessOwner(bizid) {
    if (!(bizid in businesses)) {
        return false;
    }

    return businesses[bizid].owner;
}

/**
 * Save all businesses
 */
function saveBusinesses() {
    foreach (idx, biz in businesses) {
        biz.save();
    }
}

/**
 * Get businnes by id
 * @param  {Integer} id
 * @return {Business}
 */
function getBusiness(id) {
    return (id in businesses) ? businesses[id] : null;
}

/**
 * Calcualte and aplly incomes for playing players
 */
function calculateBusinessIncome() {
    foreach (idx, biz in businesses) {
        local playerid = getPlayerIdFromName(biz.owner);

        if (playerid != -1) {
            local amount = max(0.0, randomf(biz.income - 2.5, biz.income + 2.5));

            // give only 5% of current amount
            if (isPlayerAfk(playerid)) {
                amount = amount * 0.05;
            }

            addMoneyToPlayer(playerid, amount);
            msg(playerid, "business.money.income", [amount, biz.name], CL_SUCCESS);
        }
    }
}

// function getAllBusinessesByType(type = -1) {

//     foreach (idx, value in businesses) {
//         // Code
//     }
// }

/**
 * Search for the first business near player
 *
 * @param  {Integer} playerid
 * @return {Integer} business id
 */
function getBusinessNearPlayer(playerid) {
    foreach (bizid, biz in businesses) {
        if (getDistanceToPoint(playerid, biz.x, biz.y, biz.z) <= BUSINESS_INTERACT_DISTANCE) {
            return bizid;
        }
    }

    return null;
}
