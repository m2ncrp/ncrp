function gui_tutorial(player) {
	
	return guiDialogSelect("Tutorial", p3(750,520), function(player) {
		player.message("I choosed: " + this.pageid);
		//return 0;
	})
	.component(guiImage("Tutorial1.png", p3(10, 30), p3(730,328)))
		.br()
	.component(guiImage("Tutorial2.png", p3(10, 30), p3(730,328)))
		.br()
	.component(guiImage("Tutorial3.png", p3(10, 30), p3(730,328)))
		.br()
	.component(guiImage("Tutorial4.png", p3(10, 30), p3(730,328)))
		.br()
	.component(guiImage("Tutorial5.png", p3(10, 30), p3(730,328)))
		.br()
	.component(guiImage("Tutorial6.png", p3(10, 30), p3(730,328)))
		.br()
	.component(guiImage("Tutorial7.png", p3(10, 30), p3(730,328)))
	.show(player);	
}

function gui_login(player) {
	return guiDialogLogin("Enter password", function(player, password) {
		if (!password) { Chat.warn(l("err_nopassword"), player); return; }
	
		if (player.tryLogin(password)) {
			Chat.green(l("login_success"), player);

			/*
				There's a tutorial for newbies learned them how to play at this server. 
			*/
			gui_tutorial(player);	
		} else {
			Chat.warn(l("err_loginfail"), player);
		}
		return 0;
	})
	.show(player);
}

function gui_help( player ){
	return guiForm("Help", p3(), p3(120, 250))
		.component(guiButton("Chats", p3(10,30), function(player) {
			this.getForm().destroy(player);
			local helpDialog = guiDialogSelect("Chats", p3(750,520), function(player) {
				player.message("I choosed: " + this.pageid);
				//this.getForm().destroy(player);
			})
			.component(guiImage("Help_chats.png", p3(10, 30), p3(730,328)))
				.show(player);	
			}))
			.component(guiCancel("Money", p3(10,55), function(player) {
				local helpDialog = guiDialogSelect("Money", p3(750,520), function(player) {
					player.message("I choosed: " + this.pageid);
					//this.getForm().destroy(player);
				})
				.component(guiImage("Help_money.png", p3(10, 30), p3(730,328)))
				.show(player);	
			}))
			.component(guiCancel("Vehicle", p3(10,80), function(player) {
				local helpDialog = guiDialogSelect("Vehicle", p3(750,520), function(player) {
					player.message("I choosed: " + this.pageid);
					//this.getForm().destroy(player);
				})
				.component(guiImage("Help_vehicles.png", p3(10, 30), p3(730,328)))
				.show(player);	
			}))
			.component(guiCancel("House", p3(10,105), function(player) {
				local helpDialog = guiDialogSelect("House", p3(750,520), function(player) {
					player.message("I choosed: " + this.pageid);
					//this.getForm().destroy(player);
				})
				.component(guiImage("Help_house.png", p3(10, 30), p3(730,328)))
				.show(player);	
			}))
			.component(guiCancel("Weapon", p3(10,130), function(player) {
				local helpDialog = guiDialogSelect("Weapon", p3(750,520), function(player) {
					player.message("I choosed: " + this.pageid);
					//this.getForm().destroy(player);
				})
				.component(guiImage("Tutorial1.png", p3(10, 30), p3(730,328)))
				.show(player);	
			}))
			.component(guiCancel("Biz", p3(10,155), function(player) {
				local helpDialog = guiDialogSelect("Biz", p3(750,520), function(player) {
					player.message("I choosed: " + this.pageid);
					//this.getForm().destroy(player);
				})
				.component(guiImage("Tutorial1.png", p3(10, 30), p3(730,328)))
				.show(player);	
			}))
			.component(guiCancel("Job", p3(10,180), function(player) {
				local helpDialog = guiDialogSelect("Job", p3(750,520), function(player) {
					player.message("I choosed: " + this.pageid);
					//this.getForm().destroy(player);
				})
				.component(guiImage("Tutorial1.png", p3(10, 30), p3(730,328)))
				.show(player);	
			}))
			.component(guiCancel("Other commands", p3(10,180), function(player) {
				local helpDialog = guiDialogSelect("Other commands", p3(750,520), function(player) {
					player.message("I choosed: " + this.pageid);
					//this.getForm().destroy(player);
				})
				.component(guiImage("Help_cmds.png", p3(10, 30), p3(730,328)))
				.show(player);	
			}))

			.component(guiCancel("Close", p3(10,220), function(player) {
				return 0;
			}))
		.show(player); // Create gui window for player
}

function gui_subway(player){
	return guiDialogSelect( l("subway_stations"), p3(750,520), function(player) {
			player.message("I choosed: " + this.pageid);
			// if( this.money >= str.payment ){																// if player's enough money then ...
					player.fadein(10000, function() {															// fade in player screen for 1000 miliseconds on the client-side
    					player.message("faded");
    					// if( this.fadeScreen()) this.setPosition( str.pos[0], str.pos[1], str.pos[2]); 		//set player's position from 1000 miliseconds
    					player.fadeout(20000, function () {
    						// this.money = this.money - str.payment;											// take some money from player
        					player.message("unfaded");
    					});
					}); 														
				// }else{																					// else ...
				// this.message( l("player_not_enough_money")); 												// show him that he've not enough money for that
			// }
		})
		.component(guiImage("Dipton.jpg", p3(10, 30), p3(730,328)))
		.component(guiImage("Dipton_description.png", p3(10, 360), p3(730,140)))
			.br()
		.component(guiImage("Kingston.jpg", p3(10, 30), p3(730,328)))
		/*.component(guiImage("Kingston_description.png", p3(10, 360), p3(730,140)))
			.br()*/
		.show(player);
}

function gui_organization_creation( player ){
}

function gui_organization_change( player ){
}

function gui_organization_creation_step1( player ){
	return guiDialogSelect("Tutorial", p3(750,520), function(player) {
		player.message("I choosed: " + this.pageid);
		gui_structure_main(player);
		player.message("Back");
		return 0;
	})
	.show(player);
}

function gui_organization_del( player, org ){
	local msg = ["Are you really wonna delete this organization?"];
	return guiDialogBox("Delete", msg, function(player, org) {
		player.message("Clicked OK");
		return 1;
		org.destroy();
	}, function(player) {
		player.message("Clicked Cancel");
		return 0;
		gui_organization_main(player);
	}).show(player);
}

function gui_organization_main( player ){
	local org = world.nearestOrganization( player );
	if( org.isMember(player) ){
		if( org.getRole(player) >= 5 ){
			return guiForm("Organization's operations", p3(), p3(200, 220))
			.component(guiLabel("Organization: " + org.name, p3(10, 10), p3(200, 34)))
			.component(guiSubmit("Change", p3(50, 80), function(player) {
				player.message("Clicked Change");
			}))
			.component(guiSubmit("Delete", p3(50, 110), function(player) {
				player.message("Clicked Delete");
				return 0;
				gui_organization_del(player, org);
			}))
			.component(guiCancel("Close", p3(50,160), function(player) {
				return 0;
				player.message("Closed");
			}))
			.show(player);
		}else{
			player.message( "Недостаточно прав, короч" );
		}
	}else{
		return guiForm("Organization's operations", p3(), p3(200, 220))
		.component(guiLabel("Nearest org.: " + org.name, p3(10, 10), p3(200, 34)))
		.component(guiSubmit("Create new", p3(50, 50), function(player) {
			player.message("Clicked Create");
			gui_organization_creation_step1(player);
			return 0;
		}))
		.component(guiSubmit("Enter", p3(50, 80), function(player) {
			player.message("Clicked Enter");
		}))
		.component(guiCancel("Close", p3(50,160), function(player) {
			return 0;
			player.message("Closed");
		}))
		.show(player);
	}
}