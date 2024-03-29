class Character extends ORM.JsonEntity {

    static classname = "Character";
    static table = "tbl_characters";

    /**
     * Array of default character fields
     * @type {Array}
     */
    static fields = [
        ORM.Field.Integer   ({ name = "accountid"   }), // for relation to @Account

        ORM.Field.Float     ({ name = "money",      value = 0.0 }),
        ORM.Field.Integer   ({ name = "dskin"       }),
        ORM.Field.Integer   ({ name = "cskin"       }),
        ORM.Field.Integer   ({ name = "xp",         })
        ORM.Field.Float     ({ name = "health",     value = 720.0 }),
        ORM.Field.String    ({ name = "state",      value = "free" }),

        ORM.Field.String    ({ name = "firstname"   }),
        ORM.Field.String    ({ name = "lastname"    }),
        ORM.Field.String    ({ name = "nationality" }),
        ORM.Field.Integer   ({ name = "race"        }),
        ORM.Field.Integer   ({ name = "sex"         }),
        ORM.Field.String    ({ name = "birthdate", value = "01.01.1920" }),

        ORM.Field.String    ({ name = "name"        }), // @deprecated
        ORM.Field.String    ({ name = "job"         }), // @deprecated
        ORM.Field.Float     ({ name = "deposit",    }), // @deprecated
        ORM.Field.Integer   ({ name = "spawnid"     }), // @deprecated
        ORM.Field.Float     ({ name = "housex",     }), // @deprecated
        ORM.Field.Float     ({ name = "housey",     }), // @deprecated
        ORM.Field.Float     ({ name = "housez",     }), // @deprecated

        ORM.Field.Integer   ({ name = "mlvl",       value = 0 }),

        ORM.Field.Float     ({ name = "hunger",     value = 100.0 }),
        ORM.Field.Float     ({ name = "thirst",     value = 100.0 }),
    ];

    /**
     * Array of character traits
     * @type {Array}
     */
    static traits = [
        ORM.Trait.Positionable(),
        ORM.Trait.Rotationable(),
    ];

    taxi        = null; // @deprecated
    toggle      = null; // @deprecated
    request     = null; // @deprecated
    handshakes  = null;
    inventory   = null;
    hands       = null;
    spawned     = false;
    playerid    = -1;

    constructor () {
        base.constructor();
        this.request = {};
    }

    /**
     * Try to set virtual position (not calling native setPlayerPosition)
     * Can be passed either number sequence or Vector3 object
     *
     * @param {Float} x
     * @param {Float} y
     * @param {Float} z
     * or
     * @param {Vector3} position
     *
     * @return {Boolean}
     */
    function setPosition(...) {
        if (vargv.len() == 3) {
            this.x = vargv[0].tofloat();
            this.y = vargv[1].tofloat();
            this.z = vargv[2].tofloat();

            // return setPlayerPosition(this.playerid, this.x, this.y, this.z);
            return;
        }

        if (vargv[0] instanceof Vector3) {
            this.x = vargv[0].x;
            this.y = vargv[0].y;
            this.z = vargv[0].z;

            // return setPlayerPosition(this.playerid, this.x, this.y, this.z);
            return;
        }

        return dbg("player", "setPosition", "arguments are invalid", vargv) && false;
    }

    function save() {
        base.save();
        ::trigger("onCharacterSave", this.playerid, this);
    }

    /**
     * Return current player position
     * @return {Vector3}
     */
    function getPosition() {
        // local position = getPlayerPosition(this.playerid);

        // this.x = position[0];
        // this.y = position[1];
        // this.z = position[2];

        // todo: refactor
        return Vector3(this.x, this.y, this.z);
    }

    function getName() {
        return this.firstname + " " + this.lastname;
    }

    function trigger(event, ...) {
        local args = vargv;

        args.insert(0, getroottable());
        args.insert(1, this.playerid);
        args.insert(2, event);

        return ::trigger.acall(args);
    }
}
