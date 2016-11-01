class Colorable extends ORM.Trait.Interface {
    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        ORM.Field.Integer({ name = "color_x" }),
        ORM.Field.Integer({ name = "color_g" }),
        ORM.Field.Integer({ name = "color_b" })
    ];
}
