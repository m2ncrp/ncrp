class Item.Passport extends Item.Abstract
{
    static classname = "Item.Passport";
    volume      = 0.05;

    function use(playerid, inventory) {
        msg(playerid, "===========================================", CL_HELP_LINE);
        msg(playerid, "passport.info.title"         , CL_HELP_TITLE);
        msg(playerid, "passport.info.fio"           , [ this.data["fio"] ], CL_WHITE);
        msg(playerid, "passport.info.nationality"   , [ plocalize(playerid, "passport.nationality."+this.data["sex"]+"-"+this.data["nationality"]) ], CL_WHITE);
        msg(playerid, "passport.info.birthdate"     , [ this.data["birthdate"] ], CL_WHITE);
        msg(playerid, "passport.info.sex"           , [ plocalize(playerid, "passport.sex."+this.data["sex"]) ], CL_WHITE);

        msg(playerid, "passport.info.hair"          , [ plocalize(playerid, "passport.hair."+this.data["hair"]) ], CL_WHITE);
        msg(playerid, "passport.info.eyes"          , [ plocalize(playerid, "passport.eyes."+this.data["eyes"]) ], CL_WHITE);
        msg(playerid, "passport.info.issued"        , [ this.data["issued"] ], CL_WHITE);
        msg(playerid, "passport.info.expires"       , [ this.data["expires"] ], CL_WHITE);
    }

    static function getType() {
        return "Item.Passport";
    }
}
