class ContainerFractionMembers extends Container
{
    static classname = "ContainerFractionMembers";

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor() {
        base.constructor(::FractionMember);
    }

    function sort() {
        local self = this;

        this.__keys.sort(function(a, b) {
            if (!self[a].role || !self[b].role) {
                return 0;
            }

            if (self[a].role.level > self[b].role.level) return 1;
            if (self[a].role.level < self[b].role.level) return -1;
            if (self[a].role.id > self[b].role.id) return 1;
            if (self[a].role.id < self[b].role.id) return -1;
            return 0;
        });

        return this;
    }

    /**
     * Check if member exists
     * @param  {Character|Integer} character
     * @return {Boolean}
     */
    function exists(character) {
        if (character instanceof ::Character) {
            character = character.id;
        }

        if (typeof character != "integer") {
            throw "ContainerFractionMembers: Unexpected provided type, use Character or Integer!"
        }

        return base.exists(character);
    }

    /**
     * Try to get character or return empty relation
     * @param  {Character|Integer} character
     * @return {FractionMember}
     */
    function _get(character) {
        if (character instanceof ::Character) {
            character = character.id;
        }

        if (typeof character != "integer") {
            throw "ContainerFractionMembers: Unexpected provided type, use Character or Integer!"
        }

        if (character in this.__data) {
            return this.__data[character];
        }
        else {
            return ::FractionMember();
        }
    }

    /**
     * Add a new member
     * @param {Character|Integer} character
     * @param {FractionRole} role
     * @return {FractionMember} created/setted member
     */
    function add(character, role) {
        if (this.exists(character)) {
            throw "ContainerFractionMembers: Cannot insert character in members, it's already a part of this member structure!"
        }

        return this.set(character, role);
    }

    /**
     * Change role for particular member
     * @param {Character|Integer} character
     * @param {FractionRole} role
     * @return {FractionMember} created/setted member
     */
    function set(character, role) {
        if (character instanceof ::Character) {
            character = character.id;
        }

        if (typeof character != "integer") {
            throw "ContainerFractionMembers: Unexpected provided type, use Character or Integer!"
        }

        if (!(role instanceof ::FractionRole)) {
            throw "ContainerFractionMembers: You should provide a valid role object as an argument!"
        }

        local member = this[character];

        member.role         = role;
        member.roleid       = role.id;
        member.fractionid   = role.fractionid;
        member.characterid  = character;

        member.save();

        base.set(character, member);
        this.sort();

        return member;
    }

    /**
     * Remove particular player from fraction
     * @param  {Character|Integer} character
     * @return {FractionMember}
     */
    function remove(character) {
        if (character instanceof ::Character) {
            character = character.id;
        }

        if (typeof character != "integer") {
            throw "ContainerFractionMembers: Unexpected provided type, use Character or Integer!"
        }

        return base.remove(character);
    }

    /**
     * Return array of character objects
     * of online fraction members
     * @return {Array}
     */
    function getOnline() {
        local members = [];

        foreach (characterid, member in this) {
            if (!::xPlayers.has(characterid)) {
                continue;
            }

            local character = ::xPlayers[characterid];

            if (::isPlayerLoaded(character.playerid)) {
                members.push(character);
            }
        }

        return members;
    }
}
