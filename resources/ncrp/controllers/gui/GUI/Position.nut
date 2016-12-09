enum {
    GUI_POSITION_ABSOLUTE,
    GUI_POSITION_CENTERED
};

class GUI.Position
{
    x = null;
    y = null;
    z = null;

    type = GUI_POSITION_CENTERED;

    constructor (x, y, z)
    {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    static function absolute(x = 0, y = 0, z = 0)
    {
        local object = GUI.Position(x, y, z);

        object.type = GUI_POSITION_ABSOLUTE;

        return object;
    }

    static function centered(x = 0, y = 0, z = 0)
    {
        return GUI.Position(x, y, z);
    }
}
