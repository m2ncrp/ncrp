class SportEvent extends ORM.Entity {

    static classname = "SportEvent";
    static table = "sport_events";

    static fields = [
        ORM.Field.String({ name = "type" }),
        ORM.Field.String({ name = "participants", value = "0" }),
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
        if (!(team instanceof SportEntries)) {
            throw "Participant should be a SportEntries type"
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
        local q = ORM.Query("select * from @SportEntries where id in (:ids)");
        q.setParameter("ids", this.participants);
        q.execute(callback);
    }
}
