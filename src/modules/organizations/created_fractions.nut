/**
 * в этом файле описаны миграции для фракций которые были применены когда то
 * но были перенесены сюда, по причине неправвильности местонахождения ранее
 *
 * этот код не выполняеться, и не должен
 */

function __dont_run() {

    // 1. брать деньги из общего баланса фракции и видеть баланс фракции;
    // 2. пользоваться автомобилями, находящимися в пользовании фракции;
    // 3. приглашать участников во фракцию и исключать из неё;
    // 4. назначать участника на должность;
    // 5. пользоваться чатом фракции.

    // 28.02.2017
    // added sanrea
    migrate(function(query, type) {
        local fraction = fraction__Create("Sanreas", "sanreas", "mafia");

        fraction__Role(fraction, "Capofamiglia",     "superadmin",   FRACTION_FULL_PERMISSION);
        fraction__Role(fraction, "Consigliere",      "admin",        FRACTION_MONEY_PERMISSION);
        fraction__Role(fraction, "Capo Bastone",     "moderator1"    FRACTION_ROLESET_PERMISSION);
        fraction__Role(fraction, "Capo",             "moderator2",   FRACTION_INVITE_PERMISSION);
        fraction__Role(fraction, "Soldato",          "user1",        FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Picciotto",        "guest1",       FRACTION_CHAT_PERMISSION);
        fraction__Role(fraction, "Giovane D\'Onore",  "guest2",      FRACTION_CHAT_PERMISSION);
    });

    // added hospital
    migrate(function(query, type) {
        local fraction = fraction__Create("Empire General Hospital", "hospital", "hospital");

        fraction__Role(fraction, "Hospital Chief",   "superadmin",   FRACTION_FULL_PERMISSION);
        fraction__Role(fraction, "Doctor",           "doctor",       FRACTION_VEHICLE_PERMISSION);
    });

    // added Freemans
    migrate(function(query, type) {
        local fraction = fraction__Create("Freemans", "freemans", "mafia");

        fraction__Role(fraction, "Don",         "don",          FRACTION_FULL_PERMISSION);
        fraction__Role(fraction, "Capo",        "capo",         FRACTION_MONEY_PERMISSION);
        fraction__Role(fraction, "Security",    "security",     FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Confidant",   "confidant",    FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Worker",      "worker",       FRACTION_NO_PERMISSION);
    });

    // added Bombers
    migrate(function(query, type) {
        local fraction = fraction__Create("Bombers", "bombers", "gang");

        fraction__Role(fraction, "Big boss",    "bigboss",      FRACTION_FULL_PERMISSION);
        fraction__Role(fraction, "Underboss",   "underboss",    FRACTION_FULL_PERMISSION);
        fraction__Role(fraction, "Gangsta",     "gangsta",      FRACTION_INVITE_PERMISSION);
        fraction__Role(fraction, "Brother",     "brother",      FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Bully",       "bully",        FRACTION_VEHICLE_PERMISSION);
    });

    // added Hell Boys
    migrate(function(query, type) {
        local fraction = fraction__Create("Hell Boys", "hellboys", "gang");

        fraction__Role(fraction, "Ringleader",  "superadmin",   FRACTION_FULL_PERMISSION);
        fraction__Role(fraction, "Proxy",       "admin",        FRACTION_ROLESET_PERMISSION);
        fraction__Role(fraction, "Mechanic",    "mechanic",     FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Getter",      "getter",       FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Scout",       "scout",        FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Assistant",   "assistant",    FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Bouncer",     "bouncer",      FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Quack",       "quack",        FRACTION_VEHICLE_PERMISSION);
    });

    // 29.03.2017
    // added Family Navarra
    migrate(function(query, type) {
        local fraction = fraction__Create("Family Navarra", "navarra", "mafia");

        fraction__Role(fraction, "Don",             "superadmin",   FRACTION_FULL_PERMISSION);
        fraction__Role(fraction, "Consigliere",     "admin",        FRACTION_MONEY_PERMISSION);
        fraction__Role(fraction, "Giovane Boss",    "moderator1"    FRACTION_ROLESET_PERMISSION);
        fraction__Role(fraction, "Capo",            "moderator2",   FRACTION_ROLESET_PERMISSION);
        fraction__Role(fraction, "Sotto-Capo",      "user1",        FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Soldato",         "user2",        FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Sombattente",     "guest1",       FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Associate",       "guest2",       FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Novizio",         "guest3",       FRACTION_VEHICLE_PERMISSION);
    });

    // 01.04.2017
    // added Government
    migrate(function(query, type) {
        local fraction = fraction__Create("Government", "gov", "government");

        fraction__Role(fraction, "Governor",        "gov",          FRACTION_FULL_PERMISSION);
        fraction__Role(fraction, "Vice Governor",   "vgov",         FRACTION_ROLESET_PERMISSION);
        fraction__Role(fraction, "Driver",          "driver"        FRACTION_VEHICLE_PERMISSION);
        fraction__Role(fraction, "Security",        "security",     FRACTION_VEHICLE_PERMISSION);
    });

}
