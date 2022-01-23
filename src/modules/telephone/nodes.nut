local nodes = {
    // Example:
    // "123456789": {
    //     "hash": 123456789,
    //     "subscribers": [425, 6782],
    //     "from":   "0111",
    //     "to":     "0111",
    // },
}

function getPhoneNodesList() {
    return nodes;
}

function addPhoneNode(caller, from, to) {
    local hash = getTimestamp();

    nodes[hash] <- {};
    nodes[hash].hash <- hash;
    nodes[hash].subscribers <- [];
    nodes[hash].subscribers.push(caller);
    nodes[hash].from <- from;
    nodes[hash].to <- to;

    return hash;
}

function phoneNodeAddSubscriber(hash, callee) {
    nodes[hash].subscribers.push(callee);
}

function getPhoneNode(hash) {
    return (hash in nodes) ? nodes[hash] : null;
}

function findPhoneNodeBy(obj) {
    foreach (idx, node in nodes) {
        foreach (key, value in obj) {
            if(key == "subscribers") {
                if(node[key].find(value) != null) {
                    return node;
                    break;
                }
            }
            if(node[key] == value) {
                return node;
                break;
            }
        }
    }
}

function getPhoneNodeCompanion(node, charId) {
    if(node.subscribers.len() < 2) return null;
    local filteredSubscribers = node.subscribers.filter(function(i, item) {
        return (item != charId);
    });
    return filteredSubscribers[0];
}

function deletePhoneNode(hash) {
    if (hash in nodes) {
        return delete nodes[hash];
    }

    return false;
}