include("controllers/property/classes/Property.nut");

property <- null;

event("onServerStarted", function() {
    property <- Container(Property);

    Property.findAll(function(err, results) {
        foreach (idx, object in results) {
            property.set(object.id, object);
        }
    });
});
