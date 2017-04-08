class GroundItems
{
    data = null;

    constructor() {
        this.data = [];
    }

    function extend(data) {
        this.data.extend(data);
        return this;
    }

    function get(id) {
        return this.data[id];
    }

    function push(item, position = Vector3()) {
        this.data.push(item);

        item.state = Item.State.GROUND;
        item.parent = 0;
        item.x = position.x;
        item.y = position.y;
        item.z = position.z;

        foreach (playerid, value in players) {
            trigger(playerid, "inventory:onServerGroundPush", JSONEncoder.encode(item.serialize()));
        }

        return this;
    }

    function filter(callback) {
        return this.data.filter(callback);
    }

    function map(callback) {
        return this.data.map(callback);
    }

    function remove(item) {
        for (local i = this.len() - 1; i >= 0; i--) {
            if (item.id != this.data[i].id) {
                continue;
            }

            foreach (playerid, value in players) {
                trigger(playerid, "inventory:onServerGroundRemove", JSONEncoder.encode(item.serialize()));
            }

            this.data.remove(i);
            return true;
        }

        return false;
    }

    function len() {
        return data.len();
    }

    /**
     * Serializes containing items into json string
     * @return {String}
     */
    function serialize() {
        local data = {
            type  = "Ground"
            items = [],
        };

        foreach (idx, item in this.data) {
            data.items.push(item.serialize());
        }

        return JSONEncoder.encode(data);
    }

    function sync(playerid) {
        return trigger(playerid, "inventory:onServerGroundSync", this.serialize());
    }
}
