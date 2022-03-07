include("modules/telephone/commands.nut");
include("modules/telephone/translations.nut");
include("modules/telephone/nodes.nut");
include("modules/telephone/phoneObjs.nut");

// TODO: может стоит переехать на классы
// include("modules/telephone/classes/Telephone.nut");

// type
const PHONE_TYPE_BOOTH = 0;
const PHONE_TYPE_BUSSINESS = 1;

TELEPHONE_TEXT_COLOR <- CL_WAXFLOWER;
local phone_nearest_blip = {};
local PHONE_CALL_PRICE = 0.50;

local numbers = {
    "0192": "car rental",
    "1111": "empire custom"
    // "0000", searhing car services
    // "1863", // Tires and Rims
    // "6214", // Richard Beck
};

local phoneObjs = getPhoneObjects();

function getPhoneObj(number) {
    return number in phoneObjs ? phoneObjs[number] : null;
}

function getPlayerPhoneObj(playerid) {
    foreach (key, value in phoneObjs) {
        if (isPlayerInValidPoint3D(playerid, value.coords[0], value.coords[1], value.coords[2], 0.4)) {
            return value;
            break;
        }
    }
}

function findNearestPhoneObj(playerid) {
    local pos = getPlayerPositionObj(playerid);
    local dis = 2000;
    local obj = null;
    foreach (key, value in telephones) {
        local distance = getDistanceBetweenPoints2D(pos.x, pos.y, value.coords[0], value.coords[1]);
        if (distance < dis && value.type == PHONE_TYPE_BOOTH) {
           dis = distance;
           obj = value;
        }
    }
    return obj;
}

function goToPhone(playerid, number) {
    local phObj = getPhoneObj(number);
    setPlayerPosition(playerid, phObj.coords[0], phObj.coords[1], phObj.coords[2]);
}

event("onServerStarted", function() {
    logStr("[jobs] loading telephone services job and telephone system...");
    foreach (key, phone in phoneObjs) {
        phone.number <- key;
        phone.isCalling <- false;
        phone.isRinging <- false;
    }
});

event("onPlayerConnect", function(playerid){
    phone_nearest_blip[playerid] <- {};
    phone_nearest_blip[playerid].blip3dtext <- null;
});

event("onServerPlayerStarted", function( playerid ){
    foreach (key, phObj in phoneObjs) {
        createPrivate3DText(playerid, phObj.coords[0], phObj.coords[1], phObj.coords[2]+0.35, plocalize(playerid, "TELEPHONE", [key]), CL_RIPELEMON, 2.0);
        createPrivate3DText(playerid, phObj.coords[0], phObj.coords[1], phObj.coords[2]+0.20, plocalize(playerid, "3dtext.job.press.Q"), CL_WHITE.applyAlpha(150), 0.4);
    }
});


function showBlipNearestPhoneForPlayer(playerid) {
    if (phone_nearest_blip[playerid].blip3dtext) {
        return msg(playerid, "telephone.findalready");
    }

    local phObj = findNearestPhoneObj(playerid);
    local phonehash = createPrivateBlip(playerid, phObj.coords[0], phObj.coords[1], ICON_RED, 1000.0);
    phone_nearest_blip[playerid].blip3dtext = true;
    msg(playerid, "telephone.findphone");
    delayedFunction(20000, function() {
        removeBlip(phonehash);
        phone_nearest_blip[playerid].blip3dtext = null;
    });
}

function showPhoneGUI(playerid){
    local windowText            =  plocalize(playerid, "phone.gui.window");
    local label0Callto          =  plocalize(playerid, "phone.gui.callto");
    local label1insertNumber    =  plocalize(playerid, "phone.gui.insertNumber");
    local button0Police         =  plocalize(playerid, "phone.gui.buttonPolice");
    local button1Taxi           =  plocalize(playerid, "phone.gui.buttonTaxi");
    local button2Call           =  plocalize(playerid, "phone.gui.buttonCall");
    local button3Refuse         =  plocalize(playerid, "phone.gui.buttonRefuse");
    local input0exampleNumber   =  plocalize(playerid, "phone.gui.exampleNumber");

    triggerClientEvent(playerid, "showPhoneGUI", windowText, label0Callto, label1insertNumber, button0Police, button1Taxi, button2Call, button3Refuse, input0exampleNumber);
}


function animatePhonePickUp(playerid) {
    local phoneObj = getPlayerPhoneObj(playerid);
    local type = phoneObj.type == PHONE_TYPE_BUSSINESS;
    local animation1 = type ? "Phone.PickUp": "PhoneBooth.PickUp";
    local animation2 = type ? "Phone.Static" : "PhoneBooth.Static";
    local model = type ? 118 : 1;
    animateGlobal(playerid, {"animation": animation1, "unblock": false, "model": model}, 2000);
    local coords = phoneObj.coords;
    setPlayerPosition(playerid, coords[0], coords[1], coords[2]);
    setPlayerRotation(playerid, coords[3], coords[4], coords[5]);
    delayedFunction(2000, function() {
        animateGlobal(playerid, {"animation": animation2, "endless": true, "block": false, "model": model});
    });
}

function animatePhonePut(playerid) {
    clearAnimPlace(playerid);
    local phoneObj = getPlayerPhoneObj(playerid);
    local type = phoneObj.type == PHONE_TYPE_BUSSINESS;
    local animation = type ? "Phone.Put": "PhoneBooth.Put";
    local model = type ? 118 : 1;
    animateGlobal(playerid, {"animation": animation, "model": model}, 1)
    delayedFunction(50, function() {
        if(!isPlayerConnected(playerid)) return;
        animateGlobal(playerid, {"animation": animation, "model": model}, 1000)
    });
}


function callByPhone(playerid, number = null) {
    local number = str_replace("555-", "", number);
    local phoneObj = getPlayerPhoneObj(playerid);

    if (phoneObj == false) {
        return;
    }

    if (phoneObj.type == PHONE_TYPE_BOOTH) {
        if(!canMoneyBeSubstracted(playerid, PHONE_CALL_PRICE)) {
            trigger("onPlayerPhonePut", playerid);
            return msg(playerid, "telephone.notenoughmoney");
        }
        subPlayerMoney(playerid, PHONE_CALL_PRICE);
        addWorldMoney(PHONE_CALL_PRICE);
    }

    if (phoneObj.number == number) {
        msg(playerid, "telephone.callyourself", CL_WARNING);
        trigger("onPlayerPhonePut", playerid);
        return;
    }

    // TODO
    if(number == "taxi" || number == "police" || number == "dispatch" || number == "towtruck" ) {
        return trigger("onPlayerPhoneCallNPC", playerid, number, plocalize(playerid, phoneObj.name));
    }

    if(!isNumeric(number) || number.len() != 4) {
        msg(playerid, "telephone.incorrect");
        return trigger("onPlayerPhonePut", playerid);
    }

    msg(playerid, "telephone.youcalling", ["555-"+number]);

    local isNumberExist = getPhoneObj(number);
    local eventName = number in numbers ? "onPlayerPhoneCallNPC" : isNumberExist ? "onPlayerPhoneCall" : null;

    if (!eventName) {
        msg(playerid, "telephone.notregister");
        trigger("onPlayerPhonePut", playerid);
        return;
    }

    trigger(eventName, playerid, number, phoneObj);
}

event("PhoneCallGUI", callByPhone);

event("onPlayerPhoneCall", function(playerid, number, phoneObj) {
    local targetPhoneObj = getPhoneObj(number);
    local charId = getCharacterIdFromPlayerId(playerid);

    if (targetPhoneObj.isRinging || targetPhoneObj.isCalling) {
        trigger("onPlayerPhonePut", playerid);
        return msg(playerid, "telephone.lineinuse", CL_WARNING);
    }

    targetPhoneObj.isRinging = true;

    addPhoneNode(charId, phoneObj.number, number);

    local coords = targetPhoneObj.coords;
    createPlace(format("phone_%s", number), coords[0] + 10, coords[1] + 10, coords[0] - 10, coords[1] - 10);

    delayedFunction(15000, function() {
        if (targetPhoneObj.isRinging) {
            stopRinging(targetPhoneObj);
            trigger("onPlayerPhonePut", playerid);
            msg(playerid, "telephone.noanswer", CL_WARNING);
        }
    });
});

event("onPlayerPhonePickUp", function(playerid, phoneObj) {
    animatePhonePickUp(playerid);
    phoneObj.isCalling = true;

    local node = findPhoneNodeBy({"to": phoneObj.number});

    // Есть входящий звонок, отвечаем
    if(node) {
        local charId = getCharacterIdFromPlayerId(playerid);
        msg(playerid, "telephone.callstart", CL_SUCCESS);
        msg(getPlayerIdFromCharacterId(node.subscribers[0]), "telephone.callstart", CL_SUCCESS);
        phoneNodeAddSubscriber(node.hash, charId);
        stopRinging(phoneObj);
        return;
    }

    // Показать окно
    delayedFunction(2500, function() {
        showPhoneGUI(playerid);
    });
});

event("onPlayerPhonePut", function(playerid) {
    local phoneObj = getPlayerPhoneObj(playerid);

    phoneObj.isCalling = false;

    animatePhonePut(playerid);

    local node = findPhoneNodeBy({"from": phoneObj.number});
    if(!node) return;

    local targetPhoneObj = getPhoneObj(node.to);
    if(targetPhoneObj && targetPhoneObj.isRinging) stopRinging(targetPhoneObj);

    deletePhoneNode(node.hash)
});


function stopRinging(phoneObj) {
    phoneObj.isRinging = false;
    local coords = phoneObj.coords;
    foreach (idx, value in players) {
        if (isInArea(format("phone_%s", phoneObj.number), value.x, value.y, value.z)){
            if (phoneObj.type == PHONE_TYPE_BUSSINESS){
                triggerClientEvent(idx, "ringPhoneStatic", false, coords[0], coords[1], coords[2]);
            } else {
                triggerClientEvent(idx, "ringPhone", false);
            }
        }
    }
    removeArea(format("phone_%s", phoneObj.number));
}

event("onPlayerAreaEnter", function(playerid, name) {
    local data = split(name, "_");
    if (data[0] == "phone") {
        local phoneObj = getPhoneObj(data[1]);
        if(phoneObj.isRinging) {
            if (phoneObj.type == PHONE_TYPE_BUSSINESS){
                local coords = phoneObj.coords;
                triggerClientEvent(playerid, "ringPhoneStatic", true, coords[0], coords[1], coords[2]);
            } else {
                triggerClientEvent(playerid, "ringPhone", true);
            }
        }
    }
});

event("onPlayerAreaLeave", function(playerid, name) {
    local data = split(name, "_");
    if (data[0] == "phone") {
        local phoneObj = getPhoneObj(data[1]);
        if(phoneObj.isRinging) {
            if (phoneObj.type == PHONE_TYPE_BUSSINESS){
                local coords = phoneObj.coords;
                triggerClientEvent(playerid, "ringPhoneStatic", false, coords[0], coords[1], coords[2]);
            } else {
                triggerClientEvent(playerid, "ringPhone", false);
            }
        }
    }
});

event("onPlayerDisconnect", function(playerid, reason) {
    local phoneObj = getPlayerPhoneObj(playerid);
    if (!phoneObj) return;
    if(phoneObj.isCalling) {
        stopCall(playerid);
    };
});

event("onPlayerDeath", function(playerid) {
    local phoneObj = getPlayerPhoneObj(playerid);
    if (!phoneObj) return;
    if(phoneObj.isCalling) {
        stopCall(playerid);
    };
});



function stopCall(playerid) {
    local charId = getCharacterIdFromPlayerId(playerid);
    local node = findPhoneNodeBy({"subscribers": charId});
    trigger("onPlayerPhonePut", playerid);

    if(!node) return;
    msg(playerid, "telephone.callend", CL_WARNING);

    local companionCharId = getPhoneNodeCompanion(node, charId);
    if(companionCharId) {
        local companionPlayerId = getPlayerIdFromCharacterId(companionCharId);
        if(companionPlayerId == -1 || !isPlayerConnected(companionPlayerId)) return;
        msg(companionPlayerId, "telephone.callend", CL_WARNING);
        trigger("onPlayerPhonePut", companionPlayerId);
    }
}

/* don't remove

addEventHandlerEx("onServerStarted", function() {
    logStr("[jobs] loading telephone services job...");
    local teleservicescars = [
        createVehicle(31, -1066.02, 1483.81, -3.79657, -90.8055, -1.36482, -0.105954),   // telephoneCAR1
        createVehicle(31, -1076.38, 1483.81, -3.51025, -89.5915, -1.332, -0.0857111),   // telephoneCAR2
    ];

    foreach(key, value in teleservicescars ) {
        setVehicleColour( value, 125, 60, 20, 125, 60, 20 );
    }
});

    local ets1 = createVehicle(31, -1066.02, 1483.81, -3.79657, -90.8055, -1.36482, -0.105954);   // telephoneCAR1
    local ets2 = createVehicle(31, -1076.38, 1483.81, -3.51025, -89.5915, -1.332, -0.0857111);   // telephoneCAR2
    setVehicleColor(ets1, 102, 70, 18, 63, 36, 7);
    setVehicleColor(ets2, 102, 70, 18, 63, 36, 7);
    setVehiclePlateText(ets1, "ETS-01");
    setVehiclePlateText(ets2, "ETS-02");
*/
