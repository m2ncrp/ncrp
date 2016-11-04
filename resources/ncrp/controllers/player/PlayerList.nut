class PlayerList
{
    players = null;

    constructor () {
        this.players = {};
    }

    function getPlayers()
    {
        return this.players;
    }

    function addPlayer(id, name, ip, serial)
    {
        this.players[id] <- id;
    }

    function delPlayer(id)
    {
        local t = this.players[id];
        delete this.players[id];
        return t;
    }

    function getPlayer(id)
    {
        return this.players[id];
    }

    function each(callback)
    {
        foreach (idx, playerid in this.players) {
            callback(playerid);
        }
    }

    function nearestPlayer( playerid )
    {
        local min = null;
        local str = null;
        foreach(target in this.getPlayers()) {
            local dist = getDistance(playerid, target);
            if((dist < min || !min) && target!=playerid) {
                min = dist;
                str = target;
            }
        }
        return str;
    }
}
