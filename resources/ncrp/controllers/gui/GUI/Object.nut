class GUI.Object
{
    /**
     * Storage for the position of the element
     * @type {GUI.Position}
     */
    __position = null;

    /**
     * Storage for the size
     * @type {GUI.Position}
     */
    __size = null;

    /**
     * Storage for the element name
     * @type {String}
     */
    __title = null;

    /**
     * Storage for parent element
     * @type {ORM.Object}
     */
    __parent = null;

    /**
     * Current element type
     * @type {Integer}
     */
    static __type = -1;

    constructor ()
    {
        this.__position = ORM.Position.Centered();
        this.__size     = null;
    }

    function setPosition(position)
    {
        this.__position = position
        this.refresh();
        return this;
    }

    /**
     * Set parent object for current element
     * @param {ORM.Object} object
     */
    function setParent(object)
    {
        if (!(object instanceof ORM.Object)) {
            throw "ORM.Object: setParent object should extend ORM.Object";
        }

        this.__parent = object;
        this.refresh();
        return this;
    }

    function refresh()
    {

    }
}
