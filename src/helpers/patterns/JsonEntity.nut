class ORM.JsonEntity extends ORM.Entity {

    constructor() {
        base.constructor();
        this.data = {};
    }

    function initialize() {
        if (this.classname in this.__initialized) {
            return;
        }

        // validate user-defined fields
        foreach (idx, field in this.fields) {
            if (!(field instanceof ORM.Field.Basic)) {
                throw "ORM.Entity: you've tried to attach non-inherited field. Dont do dis.";
            }

            this.fields[idx] = clone(field);
        }

        // special check for extended entity class
        if (this.fields.len() > 1) {
            // id exists, which means we are inhariting some entity
            if (this.fields[0].getName() == "id") {
                this.fields.remove(2);
                this.fields.remove(1);
                this.fields.remove(0);
            }
        }

        // reverse current defined fields (to add at the beginning)
        this.fields.reverse();

        // add default fields
        this.fields.push(ORM.Field.Text({ name = "data", value = "{}", escaping = false }));
        this.fields.push(ORM.Field.String({ name = "_entity", value = this.classname }));
        this.fields.push(ORM.Field.Id({ name = "id" }));

        // reverse back to normal order
        this.fields.reverse();

        // inherit traits described in entity class
        foreach (idx, trait in this.traits) {
            if (!(trait instanceof ORM.Trait.Interface)) {
                throw "ORM.Entity: you've tried to insert non-inherited trait. Dont do dis.";
            }

            // attach trait fields
            foreach (idx, field in trait.fields) {
                local skipping = false;

                foreach (idx, ofield in this.fields) {
                    if (field.__name == ofield.__name) {
                        skipping = true;
                    }
                }

                if (skipping) {
                    continue;
                }

                this.fields.push(field);
            }
        }

        // set as initialized (preventing double run)
        this.__initialized[this.classname] <- 1;

        // create table if not exists
        this.createTable().execute();
    }

    function save(callback = null) {
        local temp = this.data;
        this.data  = JSONEncoder.encode(temp);
        local answ = base.save(callback);
        this.data  = temp;

        return answ;
    }

    function hydrate(data) {
        local entity = base.hydrate(data);
        entity.data = JSONParser.parse(entity.data);
        return entity;
    }

    function setData(name, value) {
        this.data[name] <- value;
        return this;
    }

    function getData(name) {
        return name in this.data ? this.data[name] : null;
    }
}
