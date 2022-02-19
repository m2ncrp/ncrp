let astar = {
    // init: function (grid) {
    //     for (let x = 0, xl = grid.length; x < xl; x++) {
    //         for (let y = 0, yl = grid[x].length; y < yl; y++) {
    //             let node = grid[x][y];
    //             node.f = 0;
    //             node.g = 0;
    //             node.h = 0;
    //             node.cost = 1;
    //             node.visited = false;
    //             node.closed = false;
    //             node.parent = null;
    //         }
    //     }
    // },
    array: function () {
        return [];
    },
    search: function (grid, start, end, heuristic) {
        heuristic = heuristic || astar.manhattan;

        let openArray = astar.array();

        openArray.push(start);

        while (openArray.size() > 0) {
            let currentNode = openArray.pop();

            if (currentNode === end) {
                let curr = currentNode;
                let ret = [];
                while (curr.parent) {
                    ret.push(curr);
                    curr = curr.parent;
                }
                return ret.reverse();
            }

            currentNode.closed = true;

            let neighbors = astar.neighbors(grid, currentNode);

            for (let i = 0, il = neighbors.length; i < il; i++) {
                let neighbor = neighbors[i];

                if (neighbor.closed || neighbor.isWall()) {
                    continue;
                }

                let gScore = currentNode.g + neighbor.cost;
                let beenVisited = neighbor.visited;

                if (!beenVisited || gScore < neighbor.g) {
                    neighbor.visited = true;
                    neighbor.parent = currentNode;
                    neighbor.h = neighbor.h || heuristic(neighbor.pos, end.pos);
                    neighbor.g = gScore;
                    neighbor.f = neighbor.g + neighbor.h;

                    if (!beenVisited) {
                        openArray.push(neighbor);
                    } else {
                        openArray.rescoreElement(neighbor);
                    }
                }
            }
        }

        return [];
    },
    manhattan: function (pos0, pos1) {
        let d1 = Math.abs(pos1.x - pos0.x);
        let d2 = Math.abs(pos1.y - pos0.y);
        return d1 + d2;
    },
    // neighbors: function (grid, node) {
    //     let ret = [];
    //     let x = node.x;
    //     let y = node.y;

    //     if (grid[x - 1] && grid[x - 1][y]) {
    //         ret.push(grid[x - 1][y]);
    //     }

    //     if (grid[x + 1] && grid[x + 1][y]) {
    //         ret.push(grid[x + 1][y]);
    //     }

    //     if (grid[x] && grid[x][y - 1]) {
    //         ret.push(grid[x][y - 1]);
    //     }

    //     if (grid[x] && grid[x][y + 1]) {
    //         ret.push(grid[x][y + 1]);
    //     }

    //     return ret;
    // },
};

let graph = new Graph([
    [1, 1, 1, 1],
    [0, 1, 1, 0],
    [0, 0, 1, 1],
]);
let start = graph.grid[0][0];
let end = graph.grid[1][2];
let result = astar.search(graph, start, end);

console.log(result);

let edges = {
    0: [],
    1: [],
    813: [814],
    814: [815, 540, 102],
    815: [1, 0],
    540: [],
    102: [],
};
