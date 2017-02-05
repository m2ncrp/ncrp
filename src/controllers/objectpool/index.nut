include("controllers/objectpool/basepool.nut");

t <- null;

local pass = [
    [0, 1],
    [2, 3, 6],
    [4, 5]
];

local kek = [6, 7];

function testpool() {
    t = BasePool(3, pass);
    return t.obj_list;
}


function addpool() {
    t.add(kek);
    return t.obj_list;
}
