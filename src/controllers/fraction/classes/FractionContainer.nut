class FractionContainer extends Container
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
     * @param  {Integer} playerid
     * @return {Array}
     */
    function getContaining(playerid) {
        local fractions = [];

        foreach (idx, fraction in this.getAll()) {
            // skip aliases
            if (idx == fraction.shortcut) continue;

            if (fraction.exists(playerid)) {
                fractions.push(fraction);
            }
        }

        return fractions;
    }

    /**
     * Get fractions containing current player
     * where he is manager (role.level == 0)
     * @param  {Integer} playerid
     * @return {Array}
     */
    function getManaged(playerid, level = 1) {
        local fractions = [];

        foreach (idx, fraction in this.getAll()) {
            // skip aliases
            if (idx == fraction.shortcut) continue;

            if (fraction.exists(playerid) && fraction.get(playerid).level <= level) {
                fractions.push(fraction);
            }
        }

        return fractions;
    }
}
