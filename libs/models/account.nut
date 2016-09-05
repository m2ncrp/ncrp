class Account extends ORM.Entity {
    
    static classname = "Account";
    static table = "tbl_accounts";

    static fields = [
        ORM.Field.String({ name = "username" }),
        ORM.Field.String({ name = "password" })
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
}
