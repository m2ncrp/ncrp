local convertedNationalityDict = {
    "1"  : "british"
    "2"  : "italian"
    "3"  : "american"
    "4"  : "irish"
    "5"  : "italian"
    "6"  : "french"
    "7"  : "afro"
    "8"  : "chinese"
    "9"  : "mexican"
    "10" : "german"
    "11" : "jewish"
}

class Item.Passport extends Item.Abstract
{
    static classname = "Item.Passport";
    volume      = 0.0452;

    function use(playerid, inventory) {

        if(isNumeric(this.data.nationality)) {
            this.data.nationality = convertedNationalityDict[this.data.nationality.tostring()];
            this.save();
        }

        msg(playerid, "===========================================", CL_HELP_LINE);
        msg(playerid, "passport.info.title"         , CL_HELP_TITLE);
        msg(playerid, "passport.info.fio"           , [ this.data["fio"] ], CL_WHITE);
        msg(playerid, "passport.info.nationality"   , [ plocalize(playerid, "nationality."+this.data["nationality"]) ], CL_WHITE);
        msg(playerid, "passport.info.birthdate"     , [ getBirthdate(this.data["birthdate"]) ], CL_WHITE);
        msg(playerid, "passport.info.sex"           , [ plocalize(playerid, "passport.sex."+this.data["sex"]) ], CL_WHITE);

        msg(playerid, "passport.info.hair"          , [ plocalize(playerid, "passport.hair."+this.data["hair"]) ], CL_WHITE);
        msg(playerid, "passport.info.eyes"          , [ plocalize(playerid, "passport.eyes."+this.data["eyes"]) ], CL_WHITE);
        // msg(playerid, "passport.info.issued"        , [ this.data["issued"] ], CL_WHITE);
        // msg(playerid, "passport.info.expires"       , [ this.data["expires"] ], CL_WHITE);
    }

    static function getType() {
        return "Item.Passport";
    }
}
