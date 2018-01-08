class VehicleComponent
{
    static classname = "VehicleComponent";

    static AbilityToDecay = {
        immortal = 0,
        destroyable = 1,
    };

    id          = null;
    limit       = 4;
    // vehicleid   = null;
    // state       = null;
    data        = null;
    parent      = null;
    capacity    = 100.0;
    decay       = 0.0;
    created_ingame = 0;
    created_real   = null;

    default_decay = 10368000; // ~ 4 месяца (8 внутриигровых)

    decayFlag = 0;

    constructor(data) {
        this.id     = "id" in data ? data.id : null;
        this.data   = data;

        if (this.created_ingame == 0 && this.decayFlag == this.AbilityToDecay.destroyable) {
            this.created_ingame = getTimestamp();
            this.created_real = date();
        }
    }

    function setParent(parent) {
        this.parent = parent;
        return this;
    }

    /**
     * Overridable function that do whatever you want
     * with this particular vehicle component before action.
     */
    function beforeAction() {
        // code
    }

    /**
     * Overridable function that represent function
     * of this component.
     */
    function action() {
        this.beforeAction();
        // code
        this.afterAction();
    }

    /**
     * Overridable function that do whatever you want
     * with this particular vehicle component before action.
     */
    function afterAction() {
        // code
    }

    /**
     * Correct status from time to time
     * Also overridable function
     */
    function correct() {
        // Code
    }

    function save() {

    }

    function onMinute() {

    }

    function onEnter(character, seat) {

    }

    function onExit(character, seat) {

    }

    function serialize() {
        return merge(this.data, { id = this.id, type = this.classname, decay = this.decay });
    }

    function _serialize() {
        return this.serialize();
    }

    function insertable(container)
    {
        local occasions = 0;

        foreach (idx, component in container) {
            occasions += (component.getclass() == this.getclass()) ? 1 : 0;

            if (occasions > this.limit) {
                return false;
            }
        }

        return true;
    }

    /**
     * Get timestamp of time's left for 0 component capacity
     */
    function _getDecay() {
        return this.decay;
    }

    /**
     * Sets timestamp to a new one
     * @param {uint} to is new timestamp
     */
    function _setDecay(to) {
        this.decay = to;
        return this;
    }

    /**
     * Add given number to the current timestamp
     * @param  {with} with [description]
     * @return {[type]}      [description]
     */
    function _appendDecay(with) {
        this.decay += with;
        return this;
    }

    function getCapacity() {
        return this.capacity;
    }

    function setCapacity(to) {
        if (to > 100 || this.capacity >= 100) {
            return;
        }

        // get the difference
        // local diff = this.capacity - to;
        // 
        // is it more than before
        // if (diff)
        // local newTimestamp =
    }
}
