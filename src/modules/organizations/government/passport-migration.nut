event("onServerStarted", function( ){
    local query = ORM.Query("SELECT * FROM tbl_characters WHERE data LIKE \"%passport%\"")

    query.getResult(function(err, result) {
        foreach (idx, value in result) {
            delete value.data.passport;
            value.save();
        }
    });
});
