try { return _IS_LOADED; } catch (e) { _IS_LOADED <- true; }

dofile("./resources/libs/squirrel-orm/lib/index.nut", true);
dofile("./resources/libs/network.nut", true);

dofile("./resources/libs/test.nut", true);

ORM.Driver.setProxy(function(queryString, callback) {
    local request = Request({ destination = "database", query = query });

    request.onResponse(function(response) {
        return callback ? callback( null, response.data.result ) : null;
    });

    return request.send();
});
