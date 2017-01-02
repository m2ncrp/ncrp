 addEventHandler("setGPS",function(fx,fy) {
 	removeGPSTarget();
	setGPSTarget(fx.tofloat(), fy.tofloat());
 });
