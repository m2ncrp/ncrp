/*
 addEventHandler("setGPS",function(fx,fy) {
 	removeGPSTarget();
	setGPSTarget(fx.tofloat(), fy.tofloat());
 });
*/
 addEventHandler("setGPS",function(fx,fy) {
    setGPSTarget(fx.tofloat(), fy.tofloat());
 });

 addEventHandler("removeGPS",function() {
    removeGPSTarget();
 });

 addEventHandler("hudCreateTimer", function(seconds, showed, started) {
    if( isHudTimerRunning() )
        {
            destroyHudTimer();
        }
    createHudTimer( seconds.tofloat(), showed, started );
 });

 addEventHandler("hudDestroyTimer", function() {
    if( isHudTimerRunning() )
        {
            destroyHudTimer();
        }
 });
