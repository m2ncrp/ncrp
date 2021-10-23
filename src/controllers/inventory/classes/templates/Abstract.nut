class Item.Abstract extends ORM.JsonEntity
{
    static classname = "Item.Abstract";
    static table = "tbl_items";

    fields = [
        ORM.Field.Integer({ name = "type", value = 0 }),
        ORM.Field.Integer({ name = "state", value = Item.State.NONE }),
        ORM.Field.Integer({ name = "slot", value = 0 }),
        ORM.Field.Integer({ name = "decay", value = 0 }),
        ORM.Field.Integer({ name = "parent", value = 0}),
        ORM.Field.Float  ({ name = "amount", value = 0.0}),
        ORM.Field.Integer({ name = "created", value = 0 }),
    ];

    traits = [
        ORM.Trait.Positionable(),
    ];

    handsOnly = false;
    destroyOnDrop = false;
    isPickable = true;
    stackable   = false;
    maxstack    = 0;
    volume      = 0.0;
    unitvolume  = 0.0;
    capacity    = 0.0;
    default_decay = 600;
    hasAnimation = false;
    model = 1;
    anim_len = 3300;

    static name = "Default Item"; // ?

    constructor () {
        base.constructor();

        if (this.created == 0) {
            this.created = getTimestamp();
        }
    }

    function pick(playerid, inventory) {
        if (inventory instanceof PlayerHandsContainer) {
            msg(playerid, "inventory.pickupinhands", [ plocalize(playerid, this.classname )], CL_SUCCESS);
        }
        else if (inventory instanceof PlayerItemContainer) {
            msg(playerid, "inventory.pickedup", [ plocalize(playerid, this.classname )], CL_SUCCESS);
        }
    }

    function use(playerid, inventory) {
        dbg("classes/Item.nut: trying to use item. Make sure you've overriden this method for your item", this.classname, getIdentity(playerid));
    }

    function transfer(playerid, inventory, targetid) {
        sendLocalizedMsgToAll(playerid, "inventory.transfered", [ getKnownCharacterNameWithId, plocalize(playerid, this.classname ) ], NORMAL_RADIUS, CL_CHAT_ME);

        sendLocalizedMsgToAll(targetid, "inventory.transferedfrom", [ getKnownCharacterNameWithId, plocalize(playerid, this.classname ) ], NORMAL_RADIUS, CL_CHAT_ME);
    }

    function destroy(playerid, inventory) {
        msg(playerid, "inventory.destroyed", [ plocalize(playerid, this.classname )], CL_FLAMINGO);
    }

    function move(playerid, inventory) {
        // nothing here
    }

    function drop(playerid, inventory) {
        msg(playerid, "inventory.dropped", [ plocalize(playerid, this.classname )], CL_SUCCESS);
    }

    function calculateVolume() {
        return this.volume;
    }

    function serialize() {
        local data = {
            classname   = this.classname,
            type        = this.getType(),
            slot        = this.slot,
            amount      = this.amount,
            volume      = this.calculateVolume(),
            id          = this.id,
            isPickable  = this.isPickable,
            data        = this.data
            temp        = {}
        };

        if (this.x != 0.0 || this.y != 0.0 || this.z != 0.0) {
            data.x <- this.x;
            data.y <- this.y;
            data.z <- this.z;
        }

        return data;
        // return JSONEncoder.encode(data);
    }

    function canBeDestroyed() {
        return true;
    }

    static function getType() {
        return "Item.Abstract";
    }

    function animate(playerid, anim, model, id=-1) {
        if(isPlayerInVehicle(playerid) || getPlayerState(playerid) == "cuffed" || isDockerHaveBox(playerid) || !this.hasAnimation) return;
        local position = getPlayerPosition(playerid);
        local charid = getCharacterIdFromPlayerId(playerid);
        if (charid in getCharsAnims()) return;
        addPlayerAnim(playerid, anim, model)
        createPlace(format("animation_%d", charid), position[0] - 10, position[1] - 10, position[0] + 10, position[1] + 10);
        triggerClientEvent(playerid, "animate", id, anim, model);
        foreach (idx, player in players) {
            local plaPos = getPlayerPosition(idx);
            if (isInPlace(format("animation_%d", charid), plaPos[0], plaPos[1])) {
                triggerClientEvent(idx, "animate", playerid, anim, model);
                }
        }
        delayedFunction(this.anim_len, function() {
            removePlace(format("animation_%d", charid));
            removePlayerAnim(playerid);
        });
    }
}

event("onPlayerPlaceEnter", function(playerid, name) {
    local data = split(name, "_");
    if (data[0] == "animation") {
        local playerAnim = getCharAnim(data[1].tointeger());
        triggerClientEvent(playerid, "animate", getPlayerIdFromCharacterId(data[1].tointeger()), playerAnim[0], playerAnim[1]);
    }
})