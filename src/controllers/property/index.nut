include("controllers/property/translations.nut");
include("controllers/property/translations-cyr.nut");
include("controllers/property/classes/Property.nut");
include("controllers/property/functions.nut");
include("controllers/property/commands.nut");

properties <- null;

event("onServerStarted", function() {

    logStr("[property] loading property module...");

    properties <- Container(Property);

    Property.findAll(function(err, results) {
      logStr(results.len().tostring())
        foreach (idx, object in results) {
            properties.set(object.id, object);

            if(object.type == "biz") {
                loadBusiness(object)
            }

           // createPropertyLabels(object)
        }

    });
});

/*
function createPropertyLabels(object) {

    if(object.onsale) {
        create3DText(object.data.coords.private.x, object.data.coords.private.y, object.data.coords.private.z, format("Private: %s", object.title), CL_CASCADE, 1.0);
    }

    if("private" in object.data.coords) {
        create3DText(object.data.coords.private.x, object.data.coords.private.y, object.data.coords.private.z, format("Private: %s", object.title), CL_CASCADE, 1.0);
        create3DText(object.data.coords.private.x, object.data.coords.private.y, object.data.coords.private.z - 0.10, "Press Z", CL_WHITE.applyAlpha(125), 0.5);
    }
    create3DText(object.data.coords.public.x, object.data.coords.public.y, object.data.coords.public.z, format("Property: %s", object.title), CL_RIPELEMON, 5.0);
    create3DText(object.data.coords.public.x, object.data.coords.public.y, object.data.coords.public.z - 0.10, "Press E", CL_WHITE.applyAlpha(125), 0.5);
}
*/




/*
id
_entity
title
alias
type
subtype
ownerid
basePrice: 12000,
purchaseprice: 15000,
salePrice: 25000,
state: "opened"/"closed"/"onsale",
data: {
    "size": {
        "x": 5,
        "y": 3
    },
    "blipType": "ICON_MAP",
    "coords": {
        "public": {  // точка клиента
            "x": -661.45,
            "y": 346.388,
            "z": 1.17575
        },
        "private": { // точка владельца
            "x": -660.487,
            "y": 343.874,
            "z": 1.10121
        },
        "sale": {   // точка покупки/продажи
            "x": -660.487,
            "y": 343.874,
            "z": 1.10121
        }
    }
}

*/

/*
include("controllers/property/classes/Property.nut");
//include("controllers/property/commands.nut");

property <- null;

event("onServerStarted", function() {

    logStr("[property] loading property module...");

    property <- Container(Property);

    Property.findAll(function(err, results) {
      logStr(results.len().tostring())
        foreach (idx, object in results) {
            logStr(object)
            property.set(object.id, object);
        }
    });
});
*/

cmd("blip", function(playerid) {

    local icons = [
        ICON_RED       ,
        ICON_YELLOW    ,
        ICON_STAR      ,
        ICON_CROSS     ,
        ICON_MIC       ,
        ICON_MASK      ,
        ICON_GRAY      ,
        ICON_CUP       ,
        ICON_KNUCKLES  ,
        ICON_MAFIA     ,
        ICON_MAP       ,
        ICON_BURGER    ,
        ICON_CLOTHES   ,
        ICON_BRUSKI    ,
        ICON_WEAPON    ,
        ICON_ARMY      ,
        ICON_HOME      ,
        ICON_GEAR      ,
        ICON_CAR       ,
        ICON_FUEL      ,
        ICON_DOLLAR    ,
        ICON_BAR       ,
        ICON_PHONE     ,
        ICON_LOCK      ,
        ICON_REPAIR    ,
        ICON_TARGET    ,
        ICON_ARROW     ,
        ICON_LOGO_CAR  ,
        ICON_LOGO_WEAPON,
        ICON_LOGO_MIGHT,
        ICON_LOGO_STAR ,
        ICON_LOGO_PINK ,
        ICON_LOGO_BLACK
    ];


    for(local i = 0; i < icons.len(); i++) {
        createPrivateBlip(playerid, 0.0, 50.0*i, icons[i], 75.0)
    }
})

//{"coords":{"x":-684.614,"y":367.108,"z":1.47988}}

/*

двери и замки для каждой двери отдельно (от 1 до 3)
дверь в приватное место
приватное место
публичное место
*/
