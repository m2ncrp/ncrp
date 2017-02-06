/**
 * Return array of keys of the table
 * @param  {Table} table
 * @return {Array}
 */
function tableKeys(table) {
    if (typeof table != "table") {
        return error("tableKeys: provided data is not a table.");
    }

    local keys = [];

    foreach (idx, value in table) {
        keys.push(idx);
    }

    return keys;
}

/**
 * Merges given tables into one table
 * Lastest table has bigger priority on resolving key collisions
 * @param  {Table} 1
 * @param  {Table} 2
 * ...
 * @param  {Table} n
 *
 * @return {Table}
 */
function merge(...) {
    return vargv.reduce(function(carry, item) {
        if (!item) {
            return {};
        }

        foreach (idx, value in item) {
            carry[idx] <- value;
        }

        return carry;
    });
}
