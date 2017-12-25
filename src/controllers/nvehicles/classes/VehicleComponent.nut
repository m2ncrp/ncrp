class VehicleComponent
{
    static classname = "VehicleComponent";

    id          = null;
    limit       = 4;
    // vehicleid   = null;
    // state       = null;
    data        = null;
    parent      = null;

    constructor(data) {
        this.id     = "id" in data ? data.id : null;
        this.data   = data;
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
        return merge(this.data, { id = this.id, type = this.classname });
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
}
