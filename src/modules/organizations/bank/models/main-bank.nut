local bankLoadedData = [];

event("onServerStarted", function() {
    log("[shops] loading bank...");

    bankLoadedDataRead();
});

function bankLoadedDataRead() {
    Bank.findAll(function(err, results) {
        bankLoadedData = (results.len()) ? results : [];
    });
}


function test0() {
	local field = Bank();

    // put data
    field.ownerid  = 1;
    field.type     = "deposit";
    field.amount = 999.95;
    field.rate = 0.05;
    field.interest = 10.45;

    field.save();
    bankLoadedDataRead();
}