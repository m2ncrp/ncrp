class FractionContainer extends Container
{
    static classname = "FractionContainer";

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

    function getManaged(playerid) {
        local fractions = [];

        foreach (idx, fraction in this) {
            if (fraction.exists(playerid) && fraction[playerid].level < 1) {
                fractions.push(fraction);
            }
        }

        return fractions;
    }
}
