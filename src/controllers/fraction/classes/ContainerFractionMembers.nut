class ContainerFractionMembers extends Container
{
    static classname = "ContainerFractionMembers";

    /**
     * Create new instance
     * @return {PlayerContainer}
     */
    constructor() {
        base.constructor(FractionMember);
    }

    /**
     * Check if member exists
     * @param  {Character|Integer} character
     * @return {Boolean}
     */
    function exists(character) {
        if (character instanceof Character) {
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
        if (character instanceof Character) {
            character = character.id;
        }

        if (typeof character != "integer") {
            throw "ContainerFractionMembers: Unexpected provided type, use Character or Integer!"
        }

        if (base.exists(character)) {
            return base.get(character);
        }
        else {
            return FractionMember();
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
        if (character instanceof Character) {
            character = character.id;
        }

        if (typeof character != "integer") {
            throw "ContainerFractionMembers: Unexpected provided type, use Character or Integer!"
        }

        if (!(role instanceof FractionRole)) {
            throw "ContainerFractionMembers: You should provide a valid role object as an argument!"
        }

        local member = this.get(character);

        member.role         = role;
        member.roleid       = role.id;
        member.fractionid   = role.fractionid;
        member.characterid  = character;

        member.save();

        base.set(character, member);

        return member;
    }

    /**
     * Remove particular player from fraction
     * @param  {Character|Integer} character
     * @return {FractionMember}
     */
    function remove(character) {
        if (character instanceof Character) {
            character = character.id;
        }

        if (typeof character != "integer") {
            throw "ContainerFractionMembers: Unexpected provided type, use Character or Integer!"
        }

        return base.remove(character);
    }
}
