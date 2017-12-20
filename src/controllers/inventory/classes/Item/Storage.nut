class Item.Storage extends Item.Abstract
{
    static classname = "Item.Storage";

    container = null;
    loaded = false;
    // default_decay = 0; // бесконечное хранение на земле

    function calculateWeight () {
        if (this.isLoaded()) {
            local sum = 0;
            foreach (idx, item in this.container) {
                sum += item.calculateWeight();
            }
            this.amount = sum;
            return this.weight + sum;
        }
        return this.weight + this.amount;
    }

    constructor () {
        base.constructor();
        container = StorageItemContainer(this);
    }

    function use(playerid, inventory) {
        if (!this.isLoaded()) {
            this.load();
        }

        this.container.toggle(playerid);
    }

    function load() {
        local self = this;
        ORM.Query("select * from tbl_items where parent = :id and state = :states")
            .setParameter("id", this.id)
            .setParameter("states", Item.State.STORAGE, true)
            .getResult(function(err, items) {
                foreach (idx, item in items) {
                    self.container.set(item.slot, item);
                }
            });

        this.loaded = true;
    }

    function isLoaded() {
        return this.loaded;
    }

    function save() {
        base.save();
        foreach (idx, item in this.container) {
            item.parent = this.id;
            item.save();
        }
    }

    function drop(playerid, inventory) {
        this.container.hide(playerid)
    }

    static function getType() {
        return "Item.Storage";
    }
}
