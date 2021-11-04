addEventHandler("ringPhone", function(flag) {
	executeLua(format("game.datastore:SetBool(\"PhoneBoothRinging\", %s)", flag.tostring()));
});
