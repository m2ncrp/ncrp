local __migrations = [];

// helper functios
function migrate(callback) {
    __migrations.push(callback);
}

function applyMigrations(connection) {
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
            __migrations[migration.current++](connection);
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
migrate(function(connection) {
    connection.query("ALTER TABLE tbl_characters ADD COLUMN `deposit` FLOAT NOT NULL DEFAULT 0.0;");
});

// 24.11.16
// added vehicle wheel saving
migrate(function(connection) {
    connection.query("ALTER TABLE tbl_vehicles ADD COLUMN `fwheel` INT(255) NOT NULL DEFAULT 0;");
    connection.query("ALTER TABLE tbl_vehicles ADD COLUMN `rwheel` INT(255) NOT NULL DEFAULT 0;");
});

// 26.11.16
// added character language saving
migrate(function(connection) {
    connection.query("ALTER TABLE tbl_characters ADD COLUMN `locale` VARCHAR(255) NOT NULL DEFAULT 'en';");
});

// 04.11.16
// added accounts serial and ip saving
migrate(function(connection) {
    connection.query("ALTER TABLE tbl_accounts ADD COLUMN `ip` VARCHAR(255) NOT NULL DEFAULT '';");
    connection.query("ALTER TABLE tbl_accounts ADD COLUMN `serial` VARCHAR(255) NOT NULL DEFAULT '';");
});

// 05.11.16
// added character health saving
migrate(function(connection) {
    connection.query("ALTER TABLE tbl_characters ADD COLUMN `health` FLOAT(255) NOT NULL DEFAULT 720.0;");
});

// 05.11.16
// added account locale saving
migrate(function(connection) {
    connection.query("ALTER TABLE tbl_accounts ADD COLUMN `locale` VARCHAR(255) NOT NULL DEFAULT 'en';");
});

// 05.11.16
// added account layout saving
migrate(function(connection) {
    connection.query("ALTER TABLE tbl_accounts ADD COLUMN `layout` VARCHAR(255) NOT NULL DEFAULT 'qwerty';");
});

// 20.12.16
// added account time of creation and last login
migrate(function(connection) {
    connection.query("ALTER TABLE tbl_accounts ADD COLUMN `created` INT(255) NOT NULL DEFAULT 0;");
    connection.query("ALTER TABLE tbl_accounts ADD COLUMN `logined` INT(255) NOT NULL DEFAULT 0;");
});

// 21.12.16
// added character state saving
migrate(function(connection) {
    connection.query("ALTER TABLE tbl_characters ADD COLUMN `state` VARCHAR(255) NOT NULL DEFAULT 'free';");
});
