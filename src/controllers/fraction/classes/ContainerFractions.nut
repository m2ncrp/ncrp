class ContainerFractions extends Container
{
    static classname = "FractionContainer";

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor() {
        base.constructor(Fraction);
    }

    function push(element) {
        this.add(this.len(), element);
    }

    /**
     * Get fractions containing current player
     * @param  {Character|Integer} character or character.id
     * @return {Array}
     */
    function getContaining(character) {
        local fractions = [];

        foreach (idx, fraction in this.getAll()) {
            if (fraction.members.exists(character)) {
                fractions.push(fraction);
            }
        }

        return fractions;
    }
}
