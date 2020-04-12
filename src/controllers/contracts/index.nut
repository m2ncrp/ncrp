include("controllers/contracts/models/Contract.nut");
include("controllers/contracts/commands.nut");

local contracts_cache = {};

event("onServerStarted", function() {
    logStr("starting contracts...");

    Contract.findBy({}, function(err, contracts) {
        foreach (idx, contract in contracts) {
            contracts_cache[contract.id] <- contract;
        }
    })
});

function getContracts() {
	return contracts_cache;
}