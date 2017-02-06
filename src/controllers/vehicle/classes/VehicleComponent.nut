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
        this.id     = data.id;
        this.data   = data;
    }

    function setParent(parent) {
        this.parent = parent;
        return this;
    }

    function beforeAction() {
        // overridable function
        // Some instructions before action starts
    }

    function action() {
        // overridable function
        // Run action instructions
    }

    function afterAction() {
        // overridable function
        // Some instructions after action's done
    }

    /**
     * Correct status from time to time
     * Also overridable function
     */
    function correct() {
        // Code
    }

    function serialize() {
        return merge(this.data, { id = this.id, type = this.classname });
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
