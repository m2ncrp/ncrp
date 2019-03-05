/*
include("controllers/property/classes/Property.nut");
//include("controllers/property/commands.nut");

property <- null;

event("onServerStarted", function() {

    log("[property] loading property module...");

    property <- Container(Property);

    Property.findAll(function(err, results) {
      log(results.len().tostring())
        foreach (idx, object in results) {
            log(object)
            property.set(object.id, object);
        }
    });
});
*/

include("controllers/property/classes/Property.nut");

event("onServerStarted", function() {

    log("[property] loading property module...");

    Property.findAll(function(err, results) {
      log(results.len().tostring())
    });
});

//{"coords":{"x":-684.614,"y":367.108,"z":1.47988}}
