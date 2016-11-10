/**
 * This modul collect all data in special database for futher analysys.
 */

class StatisticPoint extends ORM.Entity {
    static classname = "StatisticPoint";
    static table = "stat_points";
    static fields = [
        ORM.Field.String({ name = "type", }),
        ORM.Field.Timestamp({ name = "createdAt" })
    ];
    static traits = [
        ORM.Trait.Positionable()
    ];
}

function statisticsPushPlayers() {
    foreach (playerid in playerList) {
        // create object
        local point = StatisticPoint();
        local pos = getPlayerPosition(playerid);

        // set values
        point.x = pos.x;
        point.y = pos.y;
        point.z = pos.z;
        point.type = "player";
        
        // save it to db
        point.save();
    }
}