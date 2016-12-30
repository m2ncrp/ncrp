class PoliceTicket extends ORM.Entity {
    static classname = "PoliceTicket";
    static table = "tbl_policetickets";

    static fields = [
        ORM.Field.String({ name = "player"  }),
        ORM.Field.String({ name = "type"    }),
        ORM.Field.String({ name = "price"   }),
        ORM.Field.String({ name = "status"  }),
        ORM.Field.Integer({ name = "stamp" }),
        ORM.Field.String({ name = "created" }),
    ];

    static traits = [
        ORM.Trait.Positionable()
    ];

    constructor (...) {
        base.constructor();

        if (!vargv.len()) return;

        // put data
        this.player = vargv[0];
        this.type   = vargv[1];
        this.price  = vargv[2];
        this.status = vargv[3];
        this.x      = vargv[4];
        this.y      = vargv[5];
        this.z      = vargv[6];
        this.stamp  = getTimestamp();
        this.created= getDateTime(); 
    }
}
