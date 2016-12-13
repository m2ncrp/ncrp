class SportEvent extends ORM.Entity {

    static classname = "SportEvent";
    static table = "sport_events";

    static fields = [
        ORM.Field.String({ name = "type" }),
        ORM.Field.String({ name = "participants", value = "0" }),
        ORM.Field.String({ name = "chances", value = "0" }),
        ORM.Field.String({ name = "date" }),
        ORM.Field.Integer({ name = "winner", value = 0 }),
    ];

    /**
     * Add participant
     * @param {SportEntries} team
     * @return {SportEvents} this
     */
    function addParticipant(team)
    {
        if (!(team instanceof SportMember)) {
            throw "Participant should be a SportMember type"
        }

        this.participants += "," + team.id;
        return this;
    }

    /**
     * Return array of participants (in the callback)
     * @param  {Function} callback
     */
    function getParticipants(callback)
    {
        local q = ORM.Query("select * from @SportMember where id in (:ids)");
        q.setParameter("ids", this.participants);
        q.getResult(callback);
    }


    /**
     * Add chance
     * @param {SportEntries} cheance
     * @return {SportEvents} this
     */
    function addChance(chance)
    {
        this.chances += "," + chance;
        return this;
    }
}

class SportBet extends ORM.Entity {

    static classname = "SportBet";
    static table = "sport_bets";

    static fields = [
        ORM.Field.String({  name = "name" }),
        ORM.Field.Integer({ name = "participant" }),
        ORM.Field.Float  ({ name = "amount" }),
        ORM.Field.Float  ({ name = "fraction" }),
    ];

}
