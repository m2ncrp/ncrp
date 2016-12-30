function migrateSQLiteToMySQL() {
    if (IS_MYSQL_ENABLED) {
        return dbg("you should run with disabled and empty mysql database");
    }

    local settings = readMysqlSettings("migrate.mysql");

    if (!settings) {
        dbg("could not read settings from migrate.mysql file");
    }

    dbg("database", "mysql", "connecting with settings", settings);
    local connection2 = mysql_connect(settings.hostname, settings.username, settings.password, settings.database);

    if (!mysql_ping(connection2)) {
        return dbg("could not connect to mysql");
    }

    mysql_query(connection2, "SET NAMES UTF8;");

    // create big ass array
    // to store all our data
    local data = [];

    dbg("loading table Ban");
    Ban.findAll(function(err, records) {
        foreach (idx, value in records) {
            value.__persisted = false;
            data.push(value);
        }
    })

    dbg("loading table SpawnPosition");
    SpawnPosition.findAll(function(err, records) {
        foreach (idx, value in records) {
            value.__persisted = false;
            data.push(value);
        }
    })

    dbg("loading table Account");
    Account.findAll(function(err, records) {
        foreach (idx, value in records) {
            value.__persisted = false;
            data.push(value);
        }
    })

    dbg("loading table Business");
    Business.findAll(function(err, records) {
        foreach (idx, value in records) {
            value.__persisted = false;
            data.push(value);
        }
    })

    dbg("loading table Character");
    Character.findAll(function(err, records) {
        foreach (idx, value in records) {
            value.__persisted = false;
            data.push(value);
        }
    })

    dbg("loading table MigrationVersion");
    MigrationVersion.findAll(function(err, records) {
        foreach (idx, value in records) {
            value.__persisted = false;
            data.push(value);
        }
    })

    dbg("loading table StatisticPoint");
    // StatisticPoint.findAll(function(err, records) {
    //     foreach (idx, value in records) {
    //         value.__persisted = false;
    //         data.push(value);
    //     }
    // })

    dbg("loading table StatisticText");
    StatisticText.findAll(function(err, records) {
        local i = 0;
        foreach (idx, value in records) {
            value.__persisted = false;
            data.push(value);
            if (i++ > 100) break;
        }
    })

    dbg("loading table TeleportPosition");
    TeleportPosition.findAll(function(err, records) {
        foreach (idx, value in records) {
            value.__persisted = false;
            data.push(value);
        }
    })

    dbg("loading table TimestampStorage");
    TimestampStorage.findAll(function(err, records) {
        foreach (idx, value in records) {
            value.__persisted = false;
            data.push(value);
        }
    })

    dbg("loading table Vehicle");
    Vehicle.findAll(function(err, records) {
        foreach (idx, value in records) {
            value.__persisted = false;
            data.push(value);
        }
    })

    dbg("loading table World");
    World.findAll(function(err, records) {
        foreach (idx, value in records) {
            value.__persisted = false;
            data.push(value);
        }
    })

    dbg("loading table SportBet");
    // SportBet.findAll(function(err, records) {
    //     foreach (idx, value in records) {
    //         value.__persisted = false;
    //         data.push(value);
    //     }
    // })

    // dbg("loading table SportEvent");
    // SportEvent.findAll(function(err, records) {
    //     foreach (idx, value in records) {
    //         value.__persisted = false;
    //         data.push(value);
    //     }
    // })

    // dbg("loading table SportMember");
    // SportMember.findAll(function(err, records) {
    //     foreach (idx, value in records) {
    //         value.__persisted = false;
    //         data.push(value);
    //     }
    // })

    dbg("setting up mysql driver...");

    // now goto to creation
    intializeMySQLDDrivers(connection2);

    dbg("creating tables...");

    // create new tables
    Ban.createTable().execute();
    SpawnPosition.createTable().execute();
    Account.createTable().execute();
    Business.createTable().execute();
    Character.createTable().execute();
    MigrationVersion.createTable().execute();
    StatisticPoint.createTable().execute();
    StatisticText.createTable().execute();
    TeleportPosition.createTable().execute();
    TimestampStorage.createTable().execute();
    Vehicle.createTable().execute();
    World.createTable().execute();
    // SportBet.createTable().execute();
    // SportEvent.createTable().execute();
    // SportMember.createTable().execute();

    // mysql_query(connection2, "ALTER TABLE `stat_texts` CHANGE COLUMN `content` `content` TEXT CHARACTER SET 'cp1251' NOT NULL ;");

    dbg("trying to insert data...");
    dbg("total", data.len(), "records")

    foreach (idx, value in data) {
        value.save();
    }

    dbg("done!");

    data.clear();
}
