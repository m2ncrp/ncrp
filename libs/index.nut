dofile("./ncrp/libs/squirrel-orm/lib/index.nut", true);
dofile("./ncrp/libs/network.nut", true);

ORM.Driver.setProxy(function(queryString, callback) {
    local request = Request({ destination = "database", query = query });

    request.onResponse(function(response) {
        return callback ? callback( null, response.data.result ) : null;
    });

    return request.send();
});
