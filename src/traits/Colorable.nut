class Colorable extends ORM.Trait.Interface {
    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        ORM.Field.Integer({ name = "color_x", value = 0 }),
        ORM.Field.Integer({ name = "color_g", value = 0 }),
        ORM.Field.Integer({ name = "color_b", value = 0 })
    ];
}

class ColorableA extends ORM.Trait.Interface {
    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        ORM.Field.Integer({ name = "cra", value = 0 }),
        ORM.Field.Integer({ name = "cga", value = 0 }),
        ORM.Field.Integer({ name = "cba", value = 0 })
    ];
}

class ColorableB extends ORM.Trait.Interface {
    /**
     * Set up mapping for different values/columns inside table
     * @type {Array}
     */
    static fields = [
        ORM.Field.Integer({ name = "crb", value = 0 }),
        ORM.Field.Integer({ name = "cgb", value = 0 }),
        ORM.Field.Integer({ name = "cbb", value = 0 })
    ];
}
