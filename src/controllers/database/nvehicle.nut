function migrateNVehicles() {
    local keys = null;
    local temp = null;

    Item.VehicleKey.findAll(function(err, items) {
        dbg(items.len());
        keys = items;
        dbg(keys.len());
    })

    VehicleOld.findAll(function(err, results) {
        temp = results;
    })

    local len = temp.len();
    for(local i = 0; i < len; i++) {
        local oveh = temp[i];
        local nveh = Vehicle(oveh.model);

        nveh.ownerid = oveh.ownerid;
        nveh.state = oveh.reserved ? 0 : 1;
        nveh.setPosition(oveh.x, oveh.y, oveh.z);
        nveh.setRotation(oveh.rx, oveh.ry, oveh.rz);
        nveh.data = { parking = oveh.parking, history = JSONParser.parse(oveh.history) };

        nveh.getComponent(NVC.FuelTank).data.level = oveh.fuellevel;
        nveh.getComponent(NVC.Plate).data.number = oveh.plate;
        nveh.getComponent(NVC.Hull).data = {
            chassis = oveh.model,
            model   = oveh.model,
            color1  = format("%d|%d|%d", oveh.cra, oveh.cga, oveh.cba),
            color2  = format("%d|%d|%d", oveh.crb, oveh.cgb, oveh.cbb),
            dirt    = oveh.dirtlevel,
        };

        local matching = keys.filter(function(i, key) {
            return key.data.id == oveh.id
        });

        if (matching.len() < 1) {
            nveh.save();
            dbg("vehicle", oveh.id, "doesnt have a key/keylock");
            continue;
        }

        local key = matching[0]
        local hash = generateHash(3);

        nveh.components.push(NVC.KeyLock({ code = hash }));
        nveh.save(true);

        key.data = { code = hash, id = oveh.id, nid = nveh.id }
        key.save();

        dbg("vehicle", oveh.id, "converted ok to", nveh.id);
    }
     dbg("done");
}
