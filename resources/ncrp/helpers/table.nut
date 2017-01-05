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
