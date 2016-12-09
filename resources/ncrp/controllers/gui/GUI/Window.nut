class GUI.Window extends GUI.Object
{
    /**
     * Storage for window components
     * @type {Array}
     */
    __components = null;

    /**
     * Static shared table
     * for storing similar elements
     * @type {Object}
     */
    static __windows = {};

    /**
     * Current element type
     * ELEMENT_TYPE_WINDOW
     * @type {Integer}
     */
    static __type = 0;


    constructor()
    {
        base.constructor();
        this.__components = [];
    }

    /**
     * Addes new component
     * @param {GUI.Object} component
     * @return {GUI.Window} this
     */
    function add(component)
    {
        if (typeof component == "array"){
            return this.addLine(component);
        }

        if (!(component instanceof GUI.Object)) {
            throw "GUI.Window.add: only component of GUI.Object can be passed";
        }

        component.setParent(this);

        this.__components.push(component);
        this.rehash();

        // chaining
        return this;
    }

    /**
     * Add line of components
     * @param {Array} components
     * @return {GUI.Window} this
     */
    function addLine(components)
    {
        if (typeof components != "array") {
            throw "GUI.Window.addLine: You should pass array of GUI.Objects.";
        }

        // create new line
        local line = GUI.Line();

        // add params there
        foreach (idx, value in components) {
            line.add(value);
        }

        // push it
        this.add(line);

        return this;
    }

    function show(playerid)
    {

    }
}
