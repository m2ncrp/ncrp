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
// // added deposit for character
// migrate(function(connection) {
//     connection.query("alter table tbl_characters add field deposit float not null default 0.0;");
// });

