class Account extends ORM.Entity {

    static classname = "Account";
    static table = "tbl_accounts";

    static fields = [
        ORM.Field.String({ name = "username" }),
        ORM.Field.String({ name = "password" }),
        ORM.Field.String({ name = "ip" }),
        ORM.Field.String({ name = "serial" }),
        ORM.Field.Float ({ name = "money" }),
        ORM.Field.String({ name = "locale", value = "en" }),
        ORM.Field.String({ name = "layout", value = "qwerty" }),
        ORM.Field.Integer({ name = "created", value = 0 }),
        ORM.Field.Integer({ name = "logined", value = 0 }),
    ];

    /**
     * Checks if specified playerid is logined
     * is so, passes to the callback Account object, else null
     *
     * @param  {Integer}  playerid
     * @param  {Function} callback
     */
    function getSession(playerid, callback) {
        local request = Request({ destination = "auth", method = "getSession", id = playerid });

        request.onResponse(function(response) {
            return callback ? callback( null, response.data.result ) : null;
        });

        return request.send();
    }

    /**
     * Registers current object (this)
     * as logined using playerid
     *
     * @param  {Integer}  playerid
     */
    function addSession(playerid) {
        Request({ destination = "auth", method = "addSession", id = playerid, object = this }).send();
    }
}
