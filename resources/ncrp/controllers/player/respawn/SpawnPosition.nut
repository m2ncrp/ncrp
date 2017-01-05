class SpawnPosition extends ORM.Entity
{
    static classname = "SpawnPosition";
    static table = "tbl_spawns";

    static traits = [
        ORM.Trait.Positionable()
    ];
}
