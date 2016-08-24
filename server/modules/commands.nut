/* Player commands */
cmd(["register", "reg"], function(id, password = 0) { 													
	local player = world.getPlayer(id); 									
	if (!password) return Chat.warn(l("err_nopassword"), player); 		
	
	if (player.tryRegister(password)) {											
		if (player.tryLogin(password)) {										
			Chat.green(l("reglogin_success"), player); 

			/*
				There's a tutorial for newbies learned them how to play at this server. 
			*/
			gui_tutorial(player);

		} else {
			Chat.green(l("register_success"), player);
		}
	} else {
		Chat.warn(l("err_registered"), player);
	}
});

cmd(["login", "log", "l"], function(id, password = 0)	{
	local player = world.getPlayer(id);
	if (!password) { Chat.warn(l("err_nopassword"), player); return; }
	
	if (player.tryLogin(password)) {
		Chat.green(l("login_success"), player);

		/*
			There's a tutorial for newbies learned them how to play at this server. 
		*/ 
		//gui_tutorial(player);	

	} else {
		Chat.warn(l("err_loginfail"), player);
	}
});

cmd("test", function(id) {
	local player = world.getPlayer(id);
	/*
	local msg = ["Do you really want to do that?", "and many many many many many many", "many many many many many", "many many many many many", "many many many many words"];
	local box = guiDialogBox("ORLY?", msg, function(player) {
		player.message("Clicked OK");
		return 1;
	}, function(player) {
		player.message("Clicked Cancel");
		return 0;
	}).show(player);
	*/
	local edt = guiDialogInput("Enter name", function(player, input) {
		player.message("You entered: " + input);
		return 0;
	}).show(player);
	/*local slct = guiDialogSelect("What ?!?", null, function(player) {
			player.message("I choosed: " + this.pageid);
		})
		.component(guiImage("logo.png", p3(100,100), p3(249, 80)))
		.component(guiLabel("Hello", p3(20,20)))
			.br()
		.component(guiEdit("Name...", "usr_name", p3(20,20)))
		.show(player);
	*/
});

cmd("stats", function(id, p2="") { // show to the player his var's
	local player = world.getPlayer(id);
	// Add function call GUI and show some var's like a scoreboard (close by press Enter)
	
	local window = guiForm("$stats " + player.name, p3(), p3(120, 130))
		.component(guiLabel("Exp: ", p3(10, 10), p3(55, 34)))
		.component(guiLabel(player.minutes, p3(90, 10), p3(55, 34)))
			
		/*.component(guiLabel("Level: ", p3(10, 10), p3(23, 34)))
		.component(guiLabel(player.minutes, p3(50, 10), p3(23, 34)))
			
		.component(guiLabel("Slots: ", p3(10, 10), p3(23, 34)))
		.component(guiLabel(player.minutes, p3(50, 10), p3(23, 34)))*/
			
		.component(guiLabel("Adminlevel: ", p3(10, 25), p3(55, 34)))
		.component(guiLabel(player.adminlevel, p3(90, 25), p3(55, 34)))
			
		.component(guiLabel("Money: ", p3(10, 40), p3(55, 34)))
		.component(guiLabel(player.money, p3(90, 40), p3(55, 34)))
			
		.component(guiLabel("Skin: ", p3(10, 55), p3(55, 34)))
		.component(guiLabel(player.skin, p3(90, 55), p3(55, 34)))
		
		/*.component(guiSubmit("OK", p3(20, 100), function(player) {
			player.message("Clicked ok");
		}))*/
		.component(guiCancel("Close", p3(10,90), function(player) {
			return 0;
		}))
	.show(player); // Create gui window for player
});

cmd("drop", function(id, ...) {  	// drop some item from player slot
});

cmd("take", function(id) {		// take some item to player slot
});

cmd(["sub","subway"], function(id, station="") {
	local player = world.getPlayer(id);
	if(player.isLogined()) {
	// local str = world.getNearestStructure(player);	
	// if( str.type = subway) {				// if player's near any station then...
		// local currentStation = ...		// get the current player station and don't show it on the dialog
		gui_subway(player);
	// }else{
		// this.message( l("subway_too_far") );
	// }
	} else {
		Chat.warn( l("dont_logined"), player);
	}
});

/* Chat commands */
cmd("help", function(id) {  // helping guide
	local player = world.getPlayer(id);
	if(player.isLogined()) {
		gui_help(player);
	} else {
		Chat.warn( l("dont_logined"), player);
	}
});

cmd(["i","shout"], function(id, ...) {  // local chat 
	local player = world.getPlayer(id);
	if(player.isLogined()){
		Chat.ic(vargv, player);
	}
});

cmd(["s","shout"], function(id, ...) {  // shout 
	local player = world.getPlayer(id);
	if(player.isLogined()){
		Chat.shout(vargv, player);
	}
});

cmd(["w","whisper"], function(id, p1, ...) {  // wisper (pm to another player)
	local player = world.getPlayer( id );
	local target = world.getPlayer( p1.tointeger() );
	if( player.isLogined() ){
		Chat.whisper(vargv, player, target);
	}
});

cmd(["b"], function(id, ...) {  	// nonRP local chat
	local player = world.getPlayer(id);
	if(player.isLogined()){
		Chat.b(vargv, player);
	}
});

/*		Let's hide it for a while
cmd(["ad"], function(id, ...) { // add advert to the global nonRP chat
	local player = world.getPlayer(id);
	if(player.isLogined()){
		message.sendAll(vargv, player);
	}
});
*/

cmd(["o","ooc"], function(id, ...) {  	// global nonRP chat
	local player = world.getPlayer(id);
	if(player.isLogined()){
		//if(!world.togooc){			// Probably sometimes better turn it off couse it will always has spam & nonRP messages
			Chat.global(vargv, player);
		//}
	}
});

cmd("me", function(id, ...) {
	local player = world.getPlayer(id);
	if (player.isLogined()) {
		Chat.me(vargv, player);
	}
});

cmd("try", function(id, ...) {  // random for some actions
	local player = world.getPlayer(id);
	if (player.isLogined()) {
		Chat.trysmth(vargv, player);
	}
});

cmd("bank", function(id) {  	// actions with bank system
	local player = world.getPlayer(id);
	if (player.isLogined()) {
		switch(p2) {
			case "deposit":			// put some cash to the bank account
			break;
			case "withdraw":		// get some cash
			break;
			case "credit":			// borrow some money for a while
			break;
			case "transfer":
			break;
			case "pay":				// payment to ... 
				switch(p3) {
					case "tax":		// the Town treasury
					break;
					case "bill": 	// another player even if he's offline
					break;
				}
			break;
		}
	} else {
		Chat.warn( l("dont_logined"), player);
	}
});

/* commands for vehicles */
cmd(["vehicle","v","car"], function(id, p2 = 0, p3 = 0, p4 = 0, p5 = "") {
	local player = world.getPlayer(id);
	if( player.isLogined()) {
		switch(p2) {
			case "create":	// create vehicle
				local p = player.getPosition(); p.x += 2;
				if (p5.len() < 1) p5 = Vehicle.findEmptyNumber();
				local v = Vehicle(p3.tointeger(), p5, p4.tointeger(), p);
				world.addVehicle(v).create();
			break;
			case "setowner":
				local car = player.getVehicle();
				car.setRole(player, 3);
			break;
			case "buy":		// player -> buy vehicle
				
			break;
			case "sell": 	// player -> sell vehicle
			
			break;
			case "rent": 	// player -> rent vehicle
		
			break;	
			case "repair": 	// mechanic -> player vehicle
		
			case "tune": 	// mechanic -> player vehicle
			break;
			
			break;
		}
	} else {
		Chat.warn( l("dont_logined"), player);
	}
});

/* commands for houses */
cmd(["house", "h"], function(id, p2 = 0, p3 = 0, p4 = 0, p5 = "") {
	local player = world.getPlayer(id);
	if( player.isLogined()) {
		switch(p2) {
			case "buy":		// ïîêóïêà
				
			break;
			case "sell": 	// ïðîäàæà
			
			break;
			case "rent": 	// àðåíäà
			
			break;
			case "take": 	// take an item from house slots
			
			break;
			case "drop": 	// drop an item to house slots
			
			break;
		}
	} else {
		Chat.warn( l("dont_logined"), player);
	}
});

cmd(["struct", "str"], function(id, action, p1 = 0, p2 = 0, p3 = 0, p4 = 0, p5 = 0) {	// ~ triggers
	local player = world.getPlayer(id);
	switch(action) {
		case "menu":
			this.message("Nothing special, just GUI menu");
			//gui_structure_main(player);
		break;
		case "create":
			local obj = Struct(player.getPosition(), p3(p1.tofloat()), p1.tofloat());
			world.addStruct(obj.create());
		break;
		case "del":
			this.message( "The structure with " + world.nearestStructure(player).name + " is nearest to you" );
			//local obj = GetNearest //Get the nearest struct to the player
			//obj.destroy();
			//world.delStruct(obj);
		break;
		case "createsq":
			if (!player.getMemory("p1") || !player.getMemory("p2")) {
				player.message("You need to select positions by /s pos1 and /s pos2");
			} else {
				local obj = Struct(player.delMemory("p1"), player.delMemory("p2"));
				world.addStruct(obj.create());
			}
		break;
		case "pos1":
			player.setMemory("p1", player.getPosition());
		break;
		case "pos2":
			player.setMemory("p2", player.getPosition());
		break;
		
	}
});

cmd(["business","biz"],function(id, action, ...) {	// ~ Organization
	local player = world.getPlayer(id);
	if( player.isLogined()) {
		switch(action){
			case "buy":
			break;
			case "sell":
			break;
			case "post":
			break;
			case "set":
				switch(p3){
					case "pay":
					break;
				}
			break;
		}
	} else {
		Chat.warn( l("dont_logined"), player);
	}
});

cmd(["chat", "c"], function(id, p1, ...) {
	local player = world.getPlayer(id);
	if( player.isLogined()) {
		switch(p1) {
			case "set":
				player.setSlot(Message.tostring(vargv));
			break;
			case "1": case "2": case "3":
				player.changeSlot(p1.tointeger() - 1);
			break;
		}
	} else {
		Chat.warn( l("dont_logined"), player);
	}
});

cmd("c1", function(id) {
	world.getPlayer(id).changeSlot(0);
});

cmd("c2", function(id) {
	world.getPlayer(id).changeSlot(1);
});

cmd("c3", function(id) {
	world.getPlayer(id).changeSlot(2);
});


/* Fraction chat's such as PDEB and Gov */
cmd(["radio","r"], function(id, ...) {  // local fraction chat (radio -> cars)
});

cmd(["ra"], function(id, ...) {  // global fraction chat (radio -> cars)
});

/* Police commands ~ organization */
cmd("accept", function(id, p2="", p3="") { // accept some sessoin
	local player = world.getPlayer(id);
	switch(p2){
		case "chase":			// chase session
		break;
		case "reinforcement":	// reinforcement session
		break;
		case "call":			// call session
		break;
	}
});


cmd("duty", function(id) {  // fraction's work
});

cmd("tizer", function(id) {  // freeze target for a while
	togglePlayerControls( playerid, false );
});

cmd("rummage", function(id) {  // îáûñê èãðîêà
});

cmd("handcuffs", function(id) {  // take it on/off the target
});

cmd("jail", function(id) {  // send player to jail (only near jail)
});

cmd("wanted", function(id) {  // get a list of wanted players
});

cmd("onduty", function(id) {  // who's on duty now
});

cmd("ticket", function(id) {  // get to the target ticket ( player/vehicle )
});

cmd(["depatrment", "dep", "d"], function(id) {  // global chat ( to all players from Gov fraction )
});

cmd(["wantedlevel","wl"], function(id) {  // set player wanted level to ...
});

cmd(["org","organize"], function(id, action = "", p0 = "", p1 = "", p2 = "", p3 = "", p4 = "") {	// ~ Organization
	local player = world.getPlayer(id);
	switch(action) {
		case "menu":
			gui_organization_main(player);
		break;
		case "create":
			local obj = Organization(p0, 14);
			obj.create();
			world.addOrganization(obj);
		break; 
		case "add":
			switch(p0) {
				case "rank":
					world.nearestFraction(player).addRank(p1, p2.tointeger(), p3.tointeger());
				break;
				case "member":
					world.nearestFraction(player).addMember(player, p1.tointeger());
				break;
			}
		break;
		case "set":
			switch(p0) {
				case "rank":
					//world.nearestFraction(player).addRank(p1, p2.tointeger(), p3.tointeger());
				break;
				case "name":
					//world.nearestFraction(player).addMember(player, p1.tointeger());
				break;
				case "route":
					switch(p1) {
						case "point":
						break;
					}
				break;
			}
		break;
		case "del":
			switch(p0) {
				case "rank":
					//world.nearestFraction(player).addRank(p1, p2.tointeger(), p3.tointeger());
				break;
				case "player":
					//world.nearestFraction(player).addMember(player, p1.tointeger());
				break;
				case "route":
					//world.nearestFraction(player).addMember(player, p1.tointeger());
				break;
			}
		break;
		case "route":
			switch(p0) {
				case "create":
					player.setMemory("org_operation", world.nearestFraction(player));
				break;
				case "add":
					player.getMemory("org_operation").addRoute(player);
				break;
			}
		break;
	}
});

cmd(["engine", "en"], function(id) {
	local player = world.getPlayer(id);
	if (player.isLogined() && player.inVehicle()) {
		local car = player.getVehicle();
		car.engine();
	}
});


/* Job commands */
cmd(["job"], function(id, p2 = 0, p3 = 0, p4 = 0, p5 = "") {
	local player = world.getPlayer(id);
	switch(p2) {
		case "accept":	// ïðèíÿòèå ðàáîòû (ïîñëå "/job take" èëè "/job give")
			
		break;
		case "give":	// ïðåäëîæåíèå ðàáîòû
		
		break;
		case "leave":	// óâîëüíåíèå ñ ðàáîòû
		
		break;
		case "take":	// ïðèíÿòèå ðàáîòû (íà ìåñòå)
		
		break;
		case "onduty":	// íà÷àòü ðàáîòó
		
		break;
		case "offduty":	// çàâåðøåíèå ðàáîòû
		
		break;
	}
});

cmd(["tune"], function(id, p2 = "", p3 = "", p4 = 0, p5 = "") {  // for mechanics and players
local player = world.getPlayer(id);
	switch(p2) {
		case "up":	// tune vehicle engine
			
		break;
		case "del":	// reset tune
			
		break;
		case "accept":
			switch(p3){
				case "tune":	
			
				break;
				case "repair":
			
				break;
			}
		break;
	}
});

cmd("paint", function(id, p2 = "", p3 = "") {		// for mechanics and players
	local player = world.getPlayer(id);
	switch(p2) {
		case "set":
		break;
		case "accept":
		break;
	}
});

cmd("wheels", function(id, p2 = "", p3 = "") {		// for mechanics and players
	local player = world.getPlayer(id);
	switch(p2) {
		case "set":
		break;
		case "accept":
		break;
	}
});

/* Administration commands */
cmd(["a","admin"], function(id, p2="", p3="", p4="", p5="", p6="") {
	local player = world.getPlayer(id);
	switch(p2) {
		case "create":	// create smth (only for >5 lvl Amd)
			switch(p3) {
				case "car":		// "/a create car [id] [color1] [color2]" create a car without adding to DB
				break;
				case "house":	// "/a create house [price] [sellprice] [slots]" create a house at players coords	
				break;
				case "fraction":	
				break;
				case "job":		// "/a create job [name] [payment] [linktobusiness]"		
				break;
				case "business":	// "/a create business [type] [price] [sellprice]"
				break;
			}
		break;
		case "del":		// delete smth (only for >5 lvl Amd)
			switch(p3) {
				case "car":		 // delete car u're in
				break;
				case "house":		
				break;
				case "fraction":	
				break;
				case "job":			
				break;
				case "business":	
				break;
			}
		break;
		case "set":		// set smth (only for >5 lvl Amd)
			switch(p3) {
				case "player":
					switch(p4) {
						case "exp":
							local target = world.getPlayer(p5.tointeger());
							if(player.adminlevel == 6){
								target.minutes = p6.tointeger();
								this.message("{*} You set "+ target.name +" exp to "+ target.minutes);
								target.save();
							}else{
								this.message( l("wrong_admin_level") );
							}
						break;
						case "level":
							/*local target = world.getPlayer(p5.tointeger());
							if(player.adminlevel == 6){
								target.level = p6.tointeger();
								this.message("{*} You set "+ target.name +" level to "+ target.level);
								target.save();
							}else{
								this.message( "wrong_admin_level" );
							}*/
						break;
						case "money":
							local target = world.getPlayer(p5.tointeger());
							if(player.adminlevel == 6){
								target.money = p6.tointeger();
								this.message("{*} You set "+ target.name +" cash to "+ target.money);
								target.save();
							}else{
								this.message( l("wrong_admin_level") );
							}
						break;
						case "spawn":
							/*local target = world.getPlayer(p5.tointeger());
							if(player.adminlevel >= 5){
								if(p6.tointeger() != ""){   //If there is no coords ("/a set player spawn") save player coords as target spawn coords
									target.skin = p6.tointeger();
									this.message("{*} "+ target.skin);
									target.save();
								}
								else{
									this.message("Already has "+ target.skin + " skin!");
								}
							}else{
								this.message("You're not an Admin !");
							}*/
						break;
						case "skin":
							local target = world.getPlayer(p5.tointeger());
							if(player.adminlevel >= 5){
								if(target.skin != p6.tointeger()){
									target.skin = p6.tointeger();
									this.message("{*} "+ target.skin);
									target.save();
								}
								else{
									this.message("Already has "+ target.skin + " skin!");
								}
							}else{
								this.message( l("wrong_admin_level") );
							}
						break;
						case "adminlevel":
							local target = world.getPlayer(p5.tointeger());
							//if(player.adminlevel == 6){
								if(target.adminlevel != p6.tointeger()){
									target.adminlevel = p6.tointeger();
									this.message("{*} "+ target.adminlevel);
									target.save();
								}
								else{
									this.message("Already "+ target.adminlevel + " level adm!");
								}
							//}else{
							//	this.message( l("wrong_admin_level") );
							//}
						break;
						case "vehicle":	// if he has it
						break;
						case "house":	// if he has it
						break;
						case "business":// if he has it
						break;
						case "warns":
						break;
						case "nick":	// could be used by >3 lvl Adm
						break;
						case "pass":
						break;
						case "wantedlevel":
						break;
						case "health":
							local target = world.getPlayer( p5.tointeger() );
							player.setHealth( p6.tofloat() );
						break;
						case "leader":
						break;
					}
				break;
				case "car":	
					switch(p4) {
						case "price":	// at the Car Shop
						break;
						case "sellprice":	// for "/sell car" cmd, not "/sell car [playerid]"
						break;
						case "fuel":	// could be used by >2 lvl Adm
						break;
						case "plate":
							local vehicle = getPlayerVehicle( player.id );
							vehicle.setPlate( p5 );
						break;
						case "spawn":	// set XYZ and XrYrZr for current id on the server
						break;
						case "slots":	// set number of slots
						break;
						case "tune":
						if(player.inVehicle){
							local vehicle = player.getVehicle();
							//this.message("Vehicle " + vehicle + " has " + getVehicleTuningTable( vehicle ).tointeger() + " tune level");
							
							vehicle.setTuning( p5.tointeger() );
						}else{
							this.message( l("wrong_admin_level") );
						}
					}
				break;
				case "house":
					switch(p4) {
						case "price":
						break;
						case "sellprice":	// for "/sell house" cmd, not "/sell house [playerid]"
						break;
						case "slots":
						break;
						case "spawn":	// set XYZ for current id on the server
						break;
					}
				break;
				case "fraction":
					switch(p4) {
						case "name":	
						break;
						case "spawn":	// set XYZ for current id on the server
						break;
					}
				break;
				case "job":		
					switch(p4) {
						case "name":	
						break;
						case "payment":	// for "/sell house" cmd, not "/sell house [playerid]"
						break;
					}
				break;
				case "business":
					switch(p4) {
						case "name":	
						break;
						case "price":	
						break;
						case "sellprice":	
						break;
						case "coords":	// set XYZ for current id on the server
						break;
					}
				break;
				case "weather":
					world.setHour();
				break;
			}
		break;
		case "kick":	// kick player (for >1 lvl Adm)		"/a kick"
			local target = world.getPlayer(p3.tointeger());
			target.kick(p4);
		break;
		case "warn":	// warn player (for >1 lvl Adm)
		break;
		case "ban":		// ban player (for >3 lvl Adm)
		break;
		case "repair":	// fix vehicle is Admin in (for >3 lvl Adm)
			if(player.adminlevel >3){
				if(player.inVehicle()){
					local vehicle = player.getVehicle();
					vehicle.repair();
					this.message("You're fix "+ vehicle +" vehicle!");
				}
			}else{
				this.message( "wrong_admin_level" );
			}
		break;
		case "tp":		// teleport player (for >1 lvl Adm)
			switch(p3) {
				case "r":	// relatively
					if (!isPlayerInVehicle(id)) {
						local pos = getPlayerPosition( player.id );
						setPlayerPosition( player.id, pos[0] + p4.tofloat(), pos[1] + p5.tofloat(), pos[2] + p6.tofloat());
					} else {
						local vid = getPlayerVehicle(id);
						local pos = getVehiclePosition(vid);
						setVehiclePosition(vid, pos[0] + p4.tofloat(), pos[1] + p5.tofloat(), pos[2] + p6.tofloat());
					}
				break;
				case "o":	// ordinary
					if (!isPlayerInVehicle(id)) {
						setPlayerPosition(id, p4.tofloat(), p5.tofloat(), p6.tofloat());
					} else {
						local vid = getPlayerVehicle(id);
						setVehiclePosition(vid, p4.tofloat(), p5.tofloat(), p6.tofloat());
					}
				break;
				/*case "a":	// absolute
					//player.getRotation;	// get Player rotation angle
					// calc absolute angle
					 switch(p4) {
					case "f": 	// move forward
					break;
					case "b":	// move back
					break;
					case "l":	// move left
					break;
					case "r":	// move right
					break;
				}*/
			}
		break;
		case "goto":	// warn player (for >1 lvl Adm)
			local target = getPlayerPosition(p3.tointeger());
			setPlayerPosition(id, target[0], target[1], target[2]);
		break;
		case "give":	// give smth (for >4 lvl Adm)
		switch(p3) {
			case "gun":	
				local target = world.getPlayer(p4.tointeger());
				if(player.adminlevel > 4){
					if( p5.tointeger() > 1 && p5.tointeger() < 7 ){
						target.giveGun( p5.tointeger(), p6.tointeger());
						local gunName = getWeaponNameFromId( p5.tointeger() );
						target.message( l("admin_begin") + l("admin_give") + gunName + l("and_ammo"));
						this.message( l("you_give") + target.name + "[" + target.id + "]" + " " + gunName + l("and_ammo"));
					} else {
						this.message( "Oops... That's wrong id gun. Sorry" );
					}
				} else {
					this.message( l("wrong_admin_level") );
				}
			break;
			case "key":	
			break;
		}
		break;
		case "get":		// get smth (for 3>lvl Adm)
		switch(p3) {
			case "player":
				switch(p4) {
					case "stats":
						local target = world.getPlayer(p5.tointeger());
						if(player.adminlevel > 3){
							local window = guiForm("Stats ", point(), point(120, 130))
								.component(guiLabel("Exp: ", point(10, 10), point(55, 34)))
								.component(guiLabel(player.minutes, point(90, 10), point(55, 34)))
			
								.component(guiLabel("Adminlevel: ", point(10, 25), point(55, 34)))
								.component(guiLabel(player.adminlevel, point(90, 25), point(55, 34)))
			
								.component(guiLabel("Money: ", point(10, 40), point(55, 34)))
								.component(guiLabel(player.money, point(90, 40), point(55, 34)))
			
								.component(guiLabel("Skin: ", point(10, 55), point(55, 34)))
								.component(guiLabel(player.skin, point(90, 55), point(55, 34)))
			
								.component(guiCancel("Close", point(10,90), function(player) {
									this.getForm().destroy(player);
									player.message("Closed");
								}));
							window.create(player); // Create gui window for player
						}else{
							this.message( l("wrong_admin_level") );
						}
					break;
					case "adminlevel":
						local target = world.getPlayer(p5.tointeger());
						if(player.adminlevel > 3){
							this.message( target.name + l("have") + target.adminlevel + l("player_adminlevel"));
						}else{
							this.message( l("wrong_admin_level") );
						}
					break;
					case "rotation":
						local target = world.getPlayer( p5.tointeger() );
						if(player.adminlevel == 6){
							local targetPos = getPlayerRotation( target.id ); 
							this.message( target.name + l("player_facing") + targetPos[0] + ", " + targetPos[1]);
						}else{
							this.message( l("wrong_admin_level") );
						}
					break;
					case "position":
						local target = world.getPlayer( p5.tointeger() );
						if(player.adminlevel == 6){
							local targetPos = getPlayerPosition( target.id ); 
							this.message( target.name + l("player_facing") + targetPos[0] + ", " + targetPos[1]);
						}else{
							this.message( l("wrong_admin_level") );
						}
					break;
					case "health":
						local target = world.getPlayer( p5.tointeger() );
						local tH = target.getHealth();
						target.setHealth( p6.tointeger() );
						this.message( target.name + " health = " + tH );
					break;
					case "exp":
						local target = world.getPlayer(p5.tointeger());
						if(player.adminlevel == 6){
							this.message( target.name + l("have") + target.minutes + " exp");
						}else{
							this.message( l("wrong_admin_level") );
						}
					break;
					case "money":
						local target = world.getPlayer(p5.tointeger());
						if(player.adminlevel >= 6){
							this.message( target.name + l("have") + target.money + l("player_cash"));
						}else{
							this.message( l("wrong_admin_level") );
						}
					break;
					case "serial":
						local target = world.getPlayer(p5.tointeger());
						if(player.adminlevel >= 6){
							local msg = [ target.name + " serial: " + target.serial ];
							local box = guiDialogBox("Player Serial", msg, function(player) {
								player.message("Clicked OK");
								return 1;
							}, function(player) {
								player.message("Clicked Cancel");
								return 0;
							}).show(player);
						}else{
							this.message( l("wrong_admin_level") );
						}
					break;
				}
			break;
			case "house":	
			break;
			case "business":
			break;
			case "car":	
				switch(p4){
				     case "tune":
						if(player.inVehicle){
							local vehicle = player.getVehicle();
							this.message( l("vehicle") + vehicle.id + l("have") + vehicle.getTuning() + l("vehicle_tune_level"));
						}else{
							this.message( l("not_in_vehicle") );
						}
				     break;
				}
			break;
			case "blip":
				switch(p4){
				     case "whoadd":	
				     break;
				}
			break;
		}
		break;
	}
});