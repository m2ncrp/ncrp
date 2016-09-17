_gui_objects <- {};

class guiObject 
{
	uid = "";
	type = "object";
	name = "";
	caption = "";
	position = null;
	size = null;
	components = null;
	pages = null;
	handler = null;
	datahandler = null;
	encoded = null;
	pageid = 0;
	pagecount = 0;

	constructor(caption, position = null, size = null) 
	{
		if (!position) position = p3();
		if (!size) size = p3(100, 20); // standart component size
		this.uid = md5(time().tostring() + random(1111,9999).tostring());
		this.caption = caption;
		this.position = position;
		this.size = size;
		this.components = [];
		this.pages = [];
	}

	function prehook() {}

	function encode(force = false)
	{
		if (!this.encoded || force) {
			
			this.encoded = {
				uid = this.uid, 
				type = this.type, 
				name = this.name, 
				caption = this.caption, 
				position = this.position.encode(),
				size = this.size.encode(),
				components = [],
				pages = [],
				pageid = this.pageid
			};

			local _pageid = -1;
			foreach(obj in this.components) {
				if (typeof obj == "string" && obj == "-page-") {
					_pageid++;
					this.encoded.pages.insert(_pageid, []);
					continue;
				}
				if (_pageid >= 0) {
					this.encoded.pages[_pageid].push(obj.encode());
				} else 
					this.encoded.components.push(obj.encode());
			}
			this.pagecount = _pageid;
		}
		return this.encoded;
	}

	function setSize(size) 
	{
		this.size = size;
	}

	function setPosition() 
	{
		this.position = position;
	}

	function component(object)
	{
		this.components.push(object);
		return this;
	}

	function setHandler(func)
	{
		this.handler = func;
		local self = this;

		addEventHandler(this.uid + "_handler", function(id) {
			local result = self.handler(world.getPlayer(id));
			if (result == 0) {
				local form = self.getForm();
				if (form) form.hide(world.getPlayer(id));
			}
		});
	}

	function create(playerid)
	{
		_gui_objects[this.uid] <- this;
		local data = json.encode(this.encode());
		triggerClientEvent(playerid, "onServerGuiShow", data);
	}

	function destroy(playerid)
	{
		delete _gui_objects[this.uid];
		local data = json.encode(this.encode());
		triggerClientEvent(playerid, "onServerGuiHide", data);
	}

	function show(playerid)
	{
		this.create(playerid);
		return this;
	}

	// function showAll()
	// {
	// 	foreach(player in world.getPlayers()) {
	// 		this.show(player);
	// 	}
	// 	return this;
	// }

	function hide(playerid)
	{
		this.destroy(playerid);
		return this;
	}

	// function hideAll()
	// {
	// 	foreach(player in world.getPlayers()) {
	// 		this.hide(player);
	// 	}
	// 	return this;
	// }

	function getForm()
	{
		if (this.type == "form") return this;
		foreach(item in _gui_objects) {
			if (item.type == "form") {
				foreach(comp in item.components) {
					if (comp == this)
						return item;
 				}
			}
		}
		return false;
	}
}

class guiForm extends guiObject 
{
	type = "form";

	function getData(playerid, handler)
	{
		this.datahandler = handler;
		local self = this;

		addEventHandler(this.uid + "_data", function(playerid, data) {
			self.datahandler(playerid, json.decode(data));
		});

		triggerClientEvent(playerid, "onServerGuiDataRequest", this.uid);
	}

	function closeForm(player) {
		return 0;
	}
}

class guiImage extends guiObject 
{
	type = "image";
}

class guiEdit extends guiObject 
{
	type = "edit";

	constructor(caption, name, position, size = null)
	{
		base.constructor(caption, position, size);
		this.name = name;
	}
}

class guiLabel extends guiObject 
{
	type = "label";
}

class guiButton extends guiObject 
{
	type = "button";

	constructor(caption, position, handler, size = null)
	{
		base.constructor(caption, position, size);
		this.setHandler(handler);
	}
}

class guiSubmit extends guiButton 
{
	type = "submit";
}

class guiCancel extends guiButton 
{
	type = "cancel";
}

class guiLeftButton extends guiButton 
{
	type = "leftbtn";
}

class guiRightButton extends guiButton 
{
	type = "rightbtn";
}

class guiDialogBox extends guiForm {

	constructor(caption, messages = "", yes = null, no = null) {
		if (!size) size = p3(220, 60); // standart dialog-box size
		base.constructor(caption, null, size);

		if (typeof messages != "array") messages = [messages];
		local count = 0;
		foreach(message in messages) {
			count++;
			this.component(guiLabel(message, p3(20,20 * count), p3(180, 20)));
		}

		this.size = p3(220, 60 + 20 * count); // dynamic dialog-box size

		this.component(guiSubmit("OK", p3(10, this.size.y - 30), yes));
		this.component(guiCancel("Cancel", p3(110, this.size.y - 30), no));
	}
}

class guiDialogAlert extends guiForm {

	constructor(caption, messages = "", yes = null) {
		if (!size) size = p3(220, 60); // standart dialog-box size
		base.constructor(caption, null, size);

		if (typeof messages != "array") messages = [messages];
		local count = 0;
		foreach(message in messages) {
			count++;
			this.component(guiLabel(message, p3(20,20 * count), p3(180, 20)));
		}

		this.size = p3(220, 60 + 20 * count); // dynamic dialog-box size

		this.component(guiSubmit("OK", p3(this.size.x / 2 - 50, this.size.y - 30), yes));
	}
}


class guiDialogSelect extends guiForm {

	constructor(caption, size, handler) {
		if (!size) size = p3(400, 300);
		base.constructor(caption, null, size);

		this.component(guiCancel("X", p3(this.size.x - 20, 15), this.closeForm, p3(15, 15)));

		local self = this;
		this.handler = handler;

		this.component(guiSubmit("Select", p3(this.size.x / 2 - 50, this.size.y - 30), function(player) {
			self.handler(player);
		}));
		this.component(guiLeftButton("< Prev (A)", p3(10, this.size.y - 30), function(player) {
			self.prevAction(player);
		}));
		this.component(guiRightButton("(D) Next >", p3(this.size.x - 120, this.size.y - 30), function(player) {
			self.nextAction(player);
		}));

		this.br();
	}

	function prevAction(playerid) {
		this.pageid = (this.pageid > 0) ? this.pageid - 1 : 0;
		triggerClientEvent(playerid, "onServerGuiPage", this.uid, this.pageid);
	}

	function nextAction(playerid) {
		this.pageid = (this.pageid < this.pagecount) ? this.pageid + 1 : this.pagecount;
		triggerClientEvent(playerid, "onServerGuiPage", this.uid, this.pageid);
	}

	function br() {
		this.component("-page-");
		return this;
	}
}

class guiDialogInput extends guiForm {

	constructor(caption, handler) {
		base.constructor(caption, null, p3(220, 90));
		this.component(guiCancel("X", p3(this.size.x - 20, 15), this.closeForm, p3(15, 15)));
		this.component(guiEdit("", "usr_data", p3(20, 30), p3(180, 20)));

		local self = this;
		self.handler = handler;
		this.component(guiSubmit("Submit", p3(this.size.x / 2 - 50, this.size.y - 30), function(playerid) {
			self.getData(playerid, function(playerid, data) {
				local result = self.handler(playerid, data.usr_data);
				if (result == 0) self.hide(playerid);
			});
		}));
	}
}

class guiDialogLogin extends guiForm {

	constructor(caption, handler) {
		base.constructor(caption, null, p3(300, 200));
		this.component(guiCancel("X", p3(this.size.x - 20, 15), this.closeForm, p3(15, 15)));
		this.component(guiImage("logo.png", p3(25,30), p3(250, 80)));
		this.component(guiEdit("", "usr_data", p3(60, 150), p3(180, 20)));

		local self = this;
		self.handler = handler;
		this.component(guiSubmit("Submit", p3(this.size.x / 2 - 50, this.size.y - 30), function(playerid) {
			self.getData(player, function(playerid, data) {
				local result = self.handler(playerid, data.usr_data);
				if (result == 0) self.hide(playerid);
			});
		}));
	}
}