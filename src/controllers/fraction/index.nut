include("controllers/fraction/classes/Fraction.nut");
include("controllers/fraction/classes/FractionRole.nut");
include("controllers/fraction/classes/FractionMember.nut");
include("controllers/fraction/classes/FractionProperty.nut");
include("controllers/fraction/classes/ContainerFractions.nut");
include("controllers/fraction/classes/ContainerFractionRoles.nut");
include("controllers/fraction/classes/ContainerFractionMembers.nut");

// deperecated
FRACTION_FULL_PERMISSION      <- 0;
FRACTION_MONEY_PERMISSION     <- 1;
FRACTION_ROLESET_PERMISSION   <- 2;
FRACTION_INVITE_PERMISSION    <- 3;
FRACTION_VEHICLE_PERMISSION   <- 4;
FRACTION_CHAT_PERMISSION      <- 5;
FRACTION_NO_PERMISSION        <- 6;

include("controllers/fraction/functions.nut");
include("controllers/fraction/translations.nut");

include("controllers/fraction/commands/general.nut");
include("controllers/fraction/commands/invite.nut");
include("controllers/fraction/commands/roles.nut");
include("controllers/fraction/commands/members.nut");
// include("controllers/fraction/commands/vehicle.nut");
// include("controllers/fraction/commands/money.nut");
// include("controllers/fraction/commands/chat.nut");

fractions <- ContainerFractions();

event("onServerStarted", function() {
    local temp = {
        fractions = {},
        property  = {},
        members   = {},
        roles     = {},
    };

    local function add_results_to(place, mode, callback) {
        return function(err, results) {
            return results.map(function(result) {
                place[result.id] <- result;

                if (mode >= 1 && !(result.fractionid in temp.fractions)) {
                    return dbg("fractions", "error", "cannot find fractionid:", result.fractionid, "for", result.classname);
                }

                callback.call(this, result);
            });
        }
    }

    Fraction.findAll(add_results_to(temp.fractions, 0, function(result) {
        fractions.add(result.shortcut, result);
    }));

    FractionRole.findAll(add_results_to(temp.roles, 1, function(result) {
        temp.fractions[result.fractionid].roles.add(result.shortcut, result);
    }));

    FractionMember.findAll(add_results_to(temp.members, 1, function(result) {
        if (!(result.roleid in temp.roles)) {
            return dbg("fractions", "error", "cannot find roleid:", result.roleid, "for", result.classname);
        }

        temp.fractions[result.fractionid].members.baseSet(result.characterid, result, temp.roles[result.roleid]);
    }));

    FractionProperty.findAll(add_results_to(temp.property, 1, function(result) {
        temp.fractions[result.fractionid].property.add(result.entityid, result);
    }));

    register_fmds();
});
