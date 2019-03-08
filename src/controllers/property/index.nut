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
        foreach (idx, object in results) {
            log(object)
            create3DText(object.data.coords.x, object.data.coords.y, object.data.coords.z, format("Property: %s", object.title), CL_RIPELEMON, 5.0);
            create3DText(object.data.coords.x, object.data.coords.y, object.data.coords.z - 0.10, "Press E", CL_WHITE.applyAlpha(125), 0.5);
            create3DText(object.data.coords.private_x, object.data.coords.private_y, object.data.coords.private_z, format("Private: %s", object.title), CL_CASCADE, 1.0);
            create3DText(object.data.coords.private_x, object.data.coords.private_y, object.data.coords.private_z - 0.10, "Press E", CL_WHITE.applyAlpha(125), 0.5);
            //property.set(object.id, object);
        }
        
    });
});

//{"coords":{"x":-684.614,"y":367.108,"z":1.47988}}

/*

двери и замки для каждой двери отдельно (от 1 до 3)
дверь в приватное место
приватное место
публичное место
*/
