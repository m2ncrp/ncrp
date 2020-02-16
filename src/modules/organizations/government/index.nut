include("modules/organizations/government/passport.nut");
include("modules/organizations/government/ltc.nut");
include("modules/organizations/government/tax.nut");
// include("modules/organizations/government/vehicleTitle.nut");
include("modules/organizations/government/voting.nut");
include("modules/organizations/government/treasury.nut");
include("modules/organizations/government/models/Government.nut");

local coords = [-122.331, -62.9116, -12.041];
local SIDEWALK = [-118.966, -73.4, -66.4244, -52.5];
local governmentLoadedData = null;

function getGovCoords(i) {
    return coords[i];
}

event("onServerStarted", function() {
    log("[organizations] government...");

    create3DText ( coords[0], coords[1], coords[2]+0.20, "/tax | /passport", CL_WHITE.applyAlpha(100), 2.0 );
    createBlip  ( coords[0], coords[1], [ 24, 0 ], ICON_RANGE_VISIBLE );
    createPlace("GovernmentSidewalk", SIDEWALK[0], SIDEWALK[1], SIDEWALK[2], SIDEWALK[3]);

    governmentLoadedDataRead();

});

function governmentLoadedDataRead() {
    Government.findAll(function(err, results) {
        if (results.len()) {
            governmentLoadedData = results;
        } else {
            local items = [
                "tax_rate",
                "ltc_price",
                "driver_license_price",
                "treasury",
                "interest_rate",
                "unemployed_income",
                "started_income_min",
                "started_income_max",
            ];

            foreach(i, item in items) {
                local field = Government();

                // put data
                field.name  = item;
                field.value = 10.0;
                field.save();
            }

            governmentLoadedDataRead();
        }
    })
}

function getGovernmentField(name = "") {
    foreach(i, item in governmentLoadedData) {
        if(item.name == name) {
            return item;
        }
    }
}

function setGovernmentField(name, value) {
    local field = getGovernmentField(name);
    field.value = value;
    field.save();
}

event("onServerPlayerStarted", function( playerid ) {
    createPrivate3DText ( playerid, coords[0], coords[1], coords[2]+0.35, plocalize(playerid, "3dtext.organizations.meria"), CL_ROYALBLUE);
});

event("onPlayerPlaceEnter", function(playerid, name) {
    if (isPlayerInVehicle(playerid) && name == "GovernmentSidewalk") {
        local vehicleid = getPlayerVehicle(playerid);
        local vehSpeed = getVehicleSpeed(vehicleid);
        local vehPos = getVehiclePosition(vehicleid);

        local vehSpeedNew = [];

        if (vehPos[0] > SIDEWALK[0] && vehPos[0] < SIDEWALK[2]) {
            // для нижней границы
            if (vehPos[1] > (SIDEWALK[1] - 4.0) && vehPos[1] < (SIDEWALK[1] + 4.0)) {
                if (vehSpeed[1] >= 0) vehSpeed[1] = (vehSpeed[1] + 1) * -1;
            }
            // для верхней границы
            if (vehPos[1] > (SIDEWALK[3] - 4.0) && vehPos[1] < (SIDEWALK[3] + 4.0)) {
                if (vehSpeed[1] <= 0) vehSpeed[1] = (vehSpeed[1] - 1) * -1;
            }
        }

        // для правой боковой границы
        if (vehPos[0] > (SIDEWALK[2] - 4.0) && vehPos[0] < (SIDEWALK[2] + 4.0)) {
            if (vehPos[1] > SIDEWALK[1] && vehPos[1] < SIDEWALK[3]) {
                if (vehSpeed[0] <= 0) vehSpeed[0] = (vehSpeed[0] - 1) * -1;
            }
        }

        setVehicleSpeed(vehicleid, vehSpeed[0], vehSpeed[1], vehSpeed[2]);
    }
});

/**
 * Check vehicleid/plate/vehInstance is government
 * @param  {any}  plate, vehicleid or instance
 * @return {boolean}
**/
function isGovVehicle(value) {

  function checkGovPlate(plate) {
    return plate.find("GOV-") == 0;
  }

  if(typeof value == "string") {
    return checkGovPlate(value);
  }
  if(typeof value == "integer") {
    local plate = getVehiclePlateText(value);
    return checkGovPlate(plate);
  }
  if(typeof value == "instance") {
    return checkGovPlate(value.entity.plate);
  }

}

//function tax(monthUp = 12, day = null, month = null, year = null, ) {
//    day   = day   ? day   : getDay();
//    month = month ? month : getMonth();
//    year  = year  ? year  : getYear();
//    dbg(day+"."+month+"."+year)
//
//    local intMonth = year * 12 + month + monthUp;
//    local intYear = floor(intMonth / 12);
//    local lostMonth = intMonth % 12;
//
//    if (lostMonth == 0) {
//        lostMonth = 12;
//        intYear -= 1;
//    }
//
//    dbg(day+"."+lostMonth+"."+intYear)
//}
