class BannedName extends ORM.Entity
{
    static classname = "BannedName";
    static table = "adm_bannednames";

    static fields = [
        ORM.Field.String ({ name = "firstname"  }),
        ORM.Field.String ({ name = "lastname"   }),
        ORM.Field.Integer({ name = "created"    }),
    ];
}
