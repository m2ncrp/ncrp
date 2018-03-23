function migrateNVehicles() {
    local keys = null;

    Item.VehicleKey.findAll(function(err, items) {
        dbg(items.len());
        keys = items.filter(@(item) (item instanceof Item.VehicleKey))
        dbg(keys.len());
    })

    VehicleOld.findAll(function(err, vehicles) {
        vehicles.map(function(oveh) {
            local nveh = Vehicle(oveh.model);

            nveh.ownerid = oveh.ownerid;
            nveh.state = oveh.reserved ? 0 : 1;
            nveh.setPosition(oveh.x, oveh.y, oveh.z);
            nveh.setRotation(oveh.rx, oveh.ry, oveh.rz);
            nveh.data = { parking = oveh.parking, history = oveh.history };

            nveh.getComponent(NVC.FuelTank).data.level = oveh.fuellevel;
            nveh.getComponent(NVC.Plate).data.plate = oveh.plate;
            nveh.getComponent(NVC.Hull).data = {
                chassis = oveh.model,
                model   = oveh.model,
                color1  = format("%d|%d|%d", oveh.cra, oveh.cga, oveh.cba),
                color2  = format("%d|%d|%d", oveh.crb, oveh.cgb, oveh.cbb),
                dirt    = oveh.dirtlevel,
            };

            local matching = keys.filter(@(key) key.data.id == oveh.id)

            if (matching.len() < 1) {
                nveh.save();
                return dbg("vehicle", nveh.id, "doesnt have a key/keylock");
            }

            local key = matching[0]

            key.data = { code = generateHash(3) }
            key.save();

            nveh.components.push(NVC.KeyLock({ code = key.getCode() }));
            nveh.save();
        })
    })
}
