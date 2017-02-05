event("invetory:onServerItemAdd", function(id) {});
event("invetory:onServerItemMove", function(id) {});
event("invetory:onServerItemDrop", function(id) {});
event("invetory:onServerItemRemove", function(id) {});

local storage = {};

class Inventory
{
    id      = null;
    data    = null;
    handle  = null;
    items   = null;

    guiTopOffset    = 20.0;
    guiPadding      = 5.0;
    guiCellSize     = 64.0;

    guiLableItemOffsetX = 46.0;
    guiLableItemOffsetY = 50.0;

    constructor(id, data) {
        this.id     = id;
        this.data   = data;
        this.items  = {};

        return this.createGUI();
    }

    function formatLabelText(item) {
        switch (item.type) {
            case "Item.None":       return "";
            case "Item.Weapon":     return item.amount.tostring();
            case "Item.Ammo":       return item.amount.tostring();
            case "Item.Clothes":    return item.amount.tostring();
        }

        return "";
    }

    function updateGUI(data) {

    }

    function createGUI() {
        local sizex = ((this.data.sizeX * (this.guiCellSize + this.guiPadding * 2)) + this.guiPadding * 2).tofloat();
        local sizey = ((this.data.sizeY * (this.guiCellSize + this.guiPadding * 2)) + this.guiPadding * 2).tofloat();

        this.handle = guiCreateElement(ELEMENT_TYPE_WINDOW, this.data.title, centerX - sizex / 2, centerY - sizey / 2, sizex, sizey);

        foreach (idx, item in this.data.items) {
            local posx = this.guiPadding + (floor(item.slot % this.data.sizeX) * this.guiCellSize + this.guiPadding);
            local posy = this.guiPadding + (floor(item.slot / this.data.sizeX) * this.guiCellSize + this.guiPadding) + this.guiTopOffset;

            item.handle <- guiCreateElement( ELEMENT_TYPE_IMAGE, item.classname + ".jpg", posx, posy, this.guiCellSize, this.guiCellSize, false, this.handle);
            item.label  <- guiCreateElement( ELEMENT_TYPE_LABEL, this.formatLabelText(item), posx + this.guiLableItemOffsetX, posy + this.guiLableItemOffsetY, 16.0, 15.0, false, this.handle);

            this.items[item.slot] <- item;
        }

        // for (local i = 0; i < this.data.sizeX * this.data.sizeY; i++) {
        //     if (!(i in this.item))
        // }

        return true;
    }
}

event("invetory:onServerOpen", function(id, data) {
    local data = JSONParser.parse(data);

    dbgc("openning gui.");

    if (!(id in storage)) {
        storage[id] <- Inventory(id, data);
        dbgc("creating gui.");
    } else {
        dbgc("updating gui.");
        storage[id].updateGUI(data);
        guiSetVisible(storage[id].handle, true);
    }
});

event("inventory:onServerClose", function(id) {
    dbgc("closing gui.");
    if (id in storage) {
        guiSetVisible(storage[id].handle, false);
    }
});
