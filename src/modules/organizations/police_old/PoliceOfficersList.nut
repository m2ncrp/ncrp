/**
 * Dat list allow leader to see all his officers in organization (don't show who's online!)
 */

officersIntotal <- 0;
police_officer_list <- {};

// IS_DATABASE_DEBUG <- true


function getPoliceOfficersList(entity) {
    if ( POLICE_RANK.find(entity.job) != null ) {
        police_officer_list[officersIntotal++] <- entity;
        return officersIntotal;
    }
}

function getPoliceEmployeesPageNumber(playerid, number = "0", language = "en") {
    local ranks = concat(POLICE_RANK, "','");
    // dbg(ranks);

    local q = ORM.Query("select * from tbl_characters where job in (':jobs') limit :page, 10");
    q.setParameter("jobs", ranks, true);
    q.setParameter("page", max(0, number.tointeger()) * 10);
    q.getResult(function(err, chars) {
        sendPlayerMessage(playerid, format("Page %s, format 'name - rank' (for next page /police employees <page>):", number.tostring()) );
        foreach (idx, char in chars) {
            msg(playerid, char.getName() + " - " + localize("job."+char.job, [], language));
            // dbg("police dude: " + char.getName() + " - " + char.job );
        }
    });
}

event("onServerStarted", function() {
    // Todo: remove query from CMD. Simply load all data needs to memory, then show it partially
});


cmd("police", ["employees"], function(playerid, page = "0") {
    if ( getPoliceRank(playerid) == POLICE_MAX_RANK ) {
        dbg( "[POLICE EMPLOYEES] " + getAuthor(playerid) + " checking out Police employees list" );
        getPoliceEmployeesPageNumber(playerid, page, getPlayerLocale(playerid));
    }
});
