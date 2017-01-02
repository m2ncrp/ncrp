class Character extends ORM.Entity {

    static classname = "Character";
    static table = "tbl_characters";

    static fields = [
        ORM.Field.String    ({ name = "name"        }),
        ORM.Field.Float     ({ name = "money"       }),
        ORM.Field.Integer   ({ name = "dskin"       }),
        ORM.Field.Integer   ({ name = "cskin"       }),
        ORM.Field.Integer   ({ name = "xp",         value = 0       })
        ORM.Field.Float     ({ name = "health",     value = 720.0   }),
        ORM.Field.String    ({ name = "state"       }),

        ORM.Field.String    ({ name = "firstname"   }),
        ORM.Field.String    ({ name = "lastname"    }),

        ORM.Field.String    ({ name = "job"         }), // @deprecated
        ORM.Field.Float     ({ name = "deposit",    value = 0.0     }), // @deprecated
        ORM.Field.Integer   ({ name = "spawnid"     value = 0       }), // @deprecated
        ORM.Field.Float     ({ name = "housex",     value = 0.0     }), // @deprecated
        ORM.Field.Float     ({ name = "housey",     value = 0.0     }), // @deprecated
        ORM.Field.Float     ({ name = "housez",     value = 0.0     }), // @deprecated
    ];

    static traits = [
        ORM.Trait.Positionable(),
        ORM.Trait.Rotationable(),
    ];

    taxi        = null; // @deprecated
    toggle      = null; // @deprecated
    request     = null; // @deprecated
    playerid    = -1;

    /**
     * Try to set virtual position (not calling native setPlayerPosition)
     * Can be passed either number sequence or vector3 object
     *
     * @param {Float} x
     * @param {Float} y
     * @param {Float} z
     * or
     * @param {vector3} position
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

        if (vargv[0] instanceof vector3) {
            this.x = vargv[0].x;
            this.y = vargv[0].y;
            this.z = vargv[0].z;

            // return setPlayerPosition(this.playerid, this.x, this.y, this.z);
            return;
        }

        return dbg("player", "setPosition", "arguments are invalid", vargv) && false;
    }

    /**
     * Return current player position
     * @return {vector3}
     */
    function getPosition() {
        local position = getPlayerPosition(this.playerid);

        this.x = position[0];
        this.y = position[1];
        this.z = position[2];

        // todo: refactor
        return vector3(x, y, z);
    }
}
