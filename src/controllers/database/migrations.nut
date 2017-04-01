local __migrations = [];

// helper functios
function migrate(callback) {
    __migrations.push(callback);
}

function applyMigrations(callback, type) {
    local migration;

    MigrationVersion.findAll(function(err, migrations) {
        if (err || !migrations || migrations.len() < 1) {
            migration = MigrationVersion();
            migration.current = __migrations.len();
            migration.save();
        } else {
            migration = migrations[0];
        }

        // if current version is old, migrate to new
        while (migration.current < __migrations.len()) {
            __migrations[migration.current++](callback, type);
            log("[database][migration] applying migration #" + migration.current);
        }

        migration.save();
    });
}

/**
 * Apply your migrations below
 */

// 21.11.16
// added deposit field for character
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `deposit` FLOAT NOT NULL DEFAULT 0.0;");
});

// 24.11.16
// added vehicle wheel saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_vehicles ADD COLUMN `fwheel` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_vehicles ADD COLUMN `rwheel` INT(255) NOT NULL DEFAULT 0;");
});

// 26.11.16
// added character language saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `locale` VARCHAR(255) NOT NULL DEFAULT 'en';");
});

// 04.11.16
// added accounts serial and ip saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `ip` VARCHAR(255) NOT NULL DEFAULT '';");
    query("ALTER TABLE tbl_accounts ADD COLUMN `serial` VARCHAR(255) NOT NULL DEFAULT '';");
});

// 05.11.16
// added character health saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `health` FLOAT NOT NULL DEFAULT 720.0;");
});

// 05.11.16
// added account locale saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `locale` VARCHAR(255) NOT NULL DEFAULT 'en';");
});

// 05.11.16
// added account layout saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `layout` VARCHAR(255) NOT NULL DEFAULT 'qwerty';");
});

// 20.12.16
// added account time of creation and last login
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `created` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_accounts ADD COLUMN `logined` INT(255) NOT NULL DEFAULT 0;");
});

// 21.12.16
// added character state saving
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `state` VARCHAR(255) NOT NULL DEFAULT 'free';");
});

// 29.12.16
// added account email
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `email` VARCHAR(255) NOT NULL DEFAULT '';");
});

// 29.12.16
// added account email
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `email` VARCHAR(255) NOT NULL DEFAULT '';");
});

// 02.01.17
// added character update fields
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `accountid` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `firstname` VARCHAR(255) NOT NULL DEFAULT '';");
    query("ALTER TABLE tbl_characters ADD COLUMN `lastname` VARCHAR(255) NOT NULL DEFAULT '';");
    query("ALTER TABLE tbl_characters ADD COLUMN `race` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `sex` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `birthdate` VARCHAR(255) NOT NULL DEFAULT '01.01.1920';");
    query("ALTER TABLE tbl_characters ADD COLUMN `x` FLOAT NOT NULL DEFAULT 0.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `y` FLOAT NOT NULL DEFAULT 0.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `z` FLOAT NOT NULL DEFAULT 0.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `rx` FLOAT NOT NULL DEFAULT 0.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `ry` FLOAT NOT NULL DEFAULT 0.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `rz` FLOAT NOT NULL DEFAULT 0.0;");
    query("UPDATE tbl_characters SET x = housex WHERE id > 0;");
    query("UPDATE tbl_characters SET y = housey WHERE id > 0;");
    query("UPDATE tbl_characters SET z = housez WHERE id > 0;");
});

//05.01.2017
//added moderator access level, number of player warnings/blocks
migrate(function(query, type) {
    query("ALTER TABLE tbl_accounts ADD COLUMN `moderator` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_accounts ADD COLUMN `warns` INT(255) NOT NULL DEFAULT 0;");
    query("ALTER TABLE tbl_accounts ADD COLUMN `blocks` INT(255) NOT NULL DEFAULT 0;");
});

// 09.01.2017
// added migration for attaching new owned vehicles to players
migrate(function(query, type) {
    query("ALTER TABLE tbl_vehicles ADD COLUMN `ownerid` INT(255) NOT NULL DEFAULT -1;");
});

// 10.01.2017
// added migration for businesses and adding ids for owners
// and attaching id references to all stuff
migrate(function(query, type) {
    query("ALTER TABLE tbl_businesses ADD COLUMN `ownerid` INT(255) NOT NULL DEFAULT -1;");

    local data = {};

    Account.findAll(function(err, accounts) {
        data.accounts <- accounts;
    });

    Character.findAll(function(err, characters) {
        data.characters <- characters;
    });

    Vehicle.findAll(function(err, vehicles) {
        data.vehicles <- vehicles;
    });

    Business.findAll(function(err, businesses) {
        data.businesses <- businesses;
    });

    foreach (idx1, character in data.characters) {

        // update references to accountid in character
        foreach (idx2, account in data.accounts) {
            if (character.name == account.username) {
                character.accountid = account.id;
                character.save();
            }
        }

        // update vehicle references
        foreach (idx2, vehicle in data.vehicles) {
            if (character.name == vehicle.owner) {
                vehicle.ownerid = character.id;
                // vehicle.owner   = character.getName();
                vehicle.save();
            }
        }

        // update business references
        foreach (idx2, business in data.businesses) {
            if (character.name == business.owner) {
                business.ownerid = character.id;
                // business.owner   = character.getName();
                business.save();
            }
        }
    }
});


// 09.01.2017
// added migration for police ticket
migrate(function(query, type) {
    query("ALTER TABLE tbl_policetickets ADD COLUMN `who` VARCHAR(255) NOT NULL DEFAULT '';");
});

//12.01.2017
//added owner in bans table
migrate(function(query, type) {
    query("ALTER TABLE adm_bans ADD COLUMN `owner` VARCHAR(255) NOT NULL DEFAULT '';");
});

//12.01.2017
//added moderator lvl in character table
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `mlvl` INT(255) NOT NULL DEFAULT 0;");
});

// 24.02.2017
// added character hunger and thirst
migrate(function(query, type) {
    query("ALTER TABLE tbl_characters ADD COLUMN `hunger` FLOAT NOT NULL DEFAULT 100.0;");
    query("ALTER TABLE tbl_characters ADD COLUMN `thirst` FLOAT NOT NULL DEFAULT 100.0;");
});

// 26.02.2017
// added fraction role salary
migrate(function(query, type) {
    // query("ALTER TABLE tbl_fraction_role ADD COLUMN `salary` FLOAT NOT NULL DEFAULT 0.0;");
});

// 26.02.2017
// added fraction role salary
migrate(function(query, type) {
    query("ALTER TABLE tbl_fraction_roles ADD COLUMN `salary` FLOAT NOT NULL DEFAULT 0.0;");
});

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

// 1. брать деньги из общего баланса фракции и видеть баланс фракции;
// 2. пользоваться автомобилями, находящимися в пользовании фракции;
// 3. приглашать участников во фракцию и исключать из неё;
// 4. назначать участника на должность;
// 5. пользоваться чатом фракции.


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
