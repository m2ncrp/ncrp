class FractionRoleContainer extends Container
{
    static classname = "FractionRoleContainer";

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor() {
        base.constructor();
        this.__ref = Fraction;
    }

    function push(element) {
        this.add(this.len(), element);
    }
}
