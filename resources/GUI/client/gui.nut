function dbg(data) { log("[debug] " + json.encode(data));}
function ti(a) { return a.tofloat(); }

class json {

	function decode(string) {
		local _compile = compilestring("return " + stripLines(string));
		
		return _compile();
		//return recursivedecode(_compile());
	}

	function recursivedecode(data) {
		foreach(i, val in data) {
			if (typeof(val) == "array" || typeof(val) == "table") {
				data[i] = recursivedecode(val);
			} else if (typeof(val) == "string") {
				data[i] = htmldecode(val);
			}
		}
		return data;
	}
	
	function stripLines(string) {
		local _split = split(string, "\r\n");
		string = "";
		
		foreach(_string in _split) string += _string;
		
		return string;
	}

	function htmlencode(str) {
		//str = strrep(str, "\"", "$30-");
		//str = strrep(str, "'", "$31-");
		str = str_replace(str, "[", "$32-");
		str = str_replace(str, "]", "$33-");
		str = str_replace(str, "{", "$34-");
		str = str_replace(str, "}", "$35-");
		return str;
	}

	function htmldecode(str) {
		//str = strrep(str, "$30-", "'");
		//str = strrep(str, "$31-", "\"");
		str = str_replace(str, "$32-", "[");
		str = str_replace(str, "$33-", "]");
		str = str_replace(str, "$34-", "{");
		str = str_replace(str, "$35-", "}");
		return str;
	}

	function encode(var) {
		local _string;
		
		switch(typeof(var)) {
			case "bool":
			case "integer":
				return "\"" + var.tointeger() + "\"" ;
			
			case "string":
			case "float":
				return "\"" + var.tostring() + "\"";
				
			case "array":
				_string = "[";
				foreach(key, element in var) {
					local _string_2 = encode(element);
					if(_string_2 == null)
						return null;
					_string += _string_2 +(key+1 < var.len() ? "," : "");
				
				}
				
				_string += "]";
				return _string;
				
			case "table":
				_string = "{";
				local _i = 0;
				foreach(key, value in var) {
					_i++;
					local _key = encode(key);
					if(_key == null)
						return null;
					local _value = encode(value);
					if(_value == null)
						return null;

					_string += _key + ":" + _value +(_i < var.len() ? "," : "");
				}
				
				_string += "}";
				return _string;

			default:
				return null;
		}
	}
}

local _gui_objects = {};
local _gui_queue = [];

function str_replace(search, replace, subject)
{
	local first = subject.find(search[0].tochar()), last = (typeof first == "null" ? null:subject.find(search[(search.len()-1)].tochar(), first)), string = "";

  	if (typeof first == "null" || typeof last == "null") return false;
 
  	for (local i = 0; i < subject.len(); i++)
    	if (i >= first && i <= last) {
      		if (i == first)
        		string = format("%s%s", string, replace.tostring());
		}
   		else string = format("%s%s", string, subject[i].tochar());
 
  	return string;
}

function gui_add(data, prnt = null, vis = true) {
	local i = null;
	if (!prnt) {
		local _size = getScreenSize();
		if (ti(data.position.x) == 0) {
			data.position.x = _size[0] / 2 - ti(data.size.x) / 2;
		}
		if (ti(data.position.y) == 0) {
			data.position.y = _size[1] / 2 - ti(data.size.y) / 2;
		}
		i = guiCreateElement(gui_type(data.type), data.caption, ti(data.position.x), ti(data.position.y), ti(data.size.x), ti(data.size.y));
	} else {
		i = guiCreateElement(gui_type(data.type), data.caption, ti(data.position.x), ti(data.position.y), ti(data.size.x), ti(data.size.y), false, prnt);
	}

	guiSetVisible(i, vis);

	_gui_objects[data.uid] <- {
		entity = data,
		visible = vis,
		intance = i
	};

	foreach(component in data.components) {
		gui_add(component, i);
	}

	local pageid = -1;
	foreach(page in data.pages) {
		pageid++;
		foreach(component in page) {
			gui_add(component, i, (pageid == data.pageid.tointeger()) ? true : false);
		}
	}
}

function gui_type(name) { 
	switch(name) { 
		case "form": return 0; 
		case "submit": case "cancel": 
		case "leftbtn": case "rightbtn":
		case "button": return 2; 
		case "image": return 13; 
		case "label": return 6; 
		case "edit": return 1; 
	} 
	return 0; 
}

function gui_translate(string) {
	return str_replace("$stats", "Статистика", string);
}

function gui_getValue(uid) {
	return guiGetText(_gui_objects[uid].intance);
}

function gui_isVisible(data) {
	if (data.uid in _gui_objects)
		return _gui_objects[data.uid].visible;
	return false;
}

function gui_exists(data) {
	if (data.uid in _gui_objects)
		return true;
	return false;
}

function gui_hide(data) {
	_gui_objects[data.uid].visible = false;
	guiSetVisible(_gui_objects[data.uid].intance, false);

	foreach(component in data.components) {
		if (component.uid in _gui_objects)
		guiSetVisible(_gui_objects[component.uid].intance, false);
	}

	foreach(page in data.pages) {
		foreach(comp in page) {
			if (comp.uid in _gui_objects)
			guiSetVisible(_gui_objects[comp.uid].intance, false);
		}
	}
}

function gui_show(data) {
	_gui_objects[data.uid].visible = true;
	guiSetVisible(_gui_objects[data.uid].intance, true);

	foreach(component in data.components) {
		if (comp.uid in _gui_objects)
		guiSetVisible(_gui_objects[component.uid].intance, true);
	}

	foreach(page in data.pages) {
		foreach(comp in page) {
			if (comp.uid in _gui_objects)
			guiSetVisible(_gui_objects[comp.uid].intance, _gui_objects[comp.uid].visible);
		}
	}
}
function gui_bindbutton(name, value) {
	bindKey(name, "down", function() {
		if (_gui_queue.len() < 1) return 0;
		local element = _gui_objects[_gui_queue.top()];
		foreach(item in element.entity.components) {
			if (item.type == value) {
				triggerServerEvent(item.uid + "_handler");
			}
		}
	});
}

gui_bindbutton("enter", "submit");
gui_bindbutton("backspace", "cancel");
gui_bindbutton("delete", "cancel");
gui_bindbutton("arrow_l", "leftbtn");
gui_bindbutton("arrow_r", "rightbtn");
gui_bindbutton("a", "leftbtn");
gui_bindbutton("d", "rightbtn");

bindKey("f2", "down", function() {
	showCursor(!isCursorShowing());
});

addEventHandler("setCursorShowing", function() {
	showCursor(!isCursorShowing());
});

addEventHandler("onClientFrameRender", function(post) {
if (!post) {
foreach(obj in _gui_objects) {
	if (obj.entity.type == "form" && gui_isVisible(obj.entity)) {
		foreach(comp in obj.entity.components) {
			if (comp.uid in _gui_objects)
			guiSetVisible(_gui_objects[comp.uid].intance, _gui_objects[comp.uid].visible);
		}
		foreach(page in obj.entity.pages) {
			foreach(comp in page) {
				if (comp.uid in _gui_objects)
				guiSetVisible(_gui_objects[comp.uid].intance, _gui_objects[comp.uid].visible);
			}
		}
	}
}
}});

addEventHandler("onGuiElementMove", function(element) {
foreach(item in _gui_objects) {
	if (item.intance == element) {
		local id = _gui_queue.find(item.entity.uid);
		if (id) {
			_gui_queue.remove(id);
			_gui_queue.push(item.entity.uid);
		}
	}
}});

addEventHandler("onGuiElementClick", function(element) {
foreach(item in _gui_objects) {
	if (item.intance == element) {
		if (item.entity.type == "form") {
			local id = _gui_queue.find(item.entity.uid);
			if (id) {
				_gui_queue.remove(id);
				_gui_queue.push(item.entity.uid);
			}
		}
		triggerServerEvent(item.entity.uid + "_handler");
	}
}});

addEventHandler("onServerGuiShow", function(request) {
	local data = json.decode(request);

	_gui_queue.push(data.uid);

	if (gui_exists(data)) {
		gui_show(data);
	} else {
		gui_add(data);
	}

	showCursor(true);
	triggerServerEvent("onPlayerGuiOpen");
});

addEventHandler("onServerGuiHide", function(request) {
	local data = json.decode(request);

	local id = _gui_queue.find(data.uid);
	if (id || id == 0) _gui_queue.remove(id);

	if (gui_isVisible(data)) {
		gui_hide(data);
	}
	local visible = false;
	foreach(obj in _gui_objects) {
		if (obj.entity.type == "form" && obj.visible)
			visible = true;
	}
	if (!visible) {
		triggerServerEvent("onPlayerLastGuiClose");
		showCursor(false);
	}
});

addEventHandler("onServerGuiDataRequest", function(uid) {
	local form = _gui_objects[uid];
	local data = null; data = {};
	foreach(object in form.entity.components) {
		if (object.name) {
			data[object.name] <- gui_getValue(object.uid);
		}
	}
	triggerServerEvent(uid + "_data", json.encode(data));
});

addEventHandler("onServerGuiPage", function(uid, pageid) {
	local form = _gui_objects[uid].entity;
	form.pageid = pageid;
	foreach(page in form.pages) {
		foreach(comp in page) {
			if (comp.uid in _gui_objects) {
				_gui_objects[comp.uid].visible = false;
				guiSetVisible(_gui_objects[comp.uid].intance, false);
			}
		}
	}
	foreach(comp in form.pages[pageid]) {
		if (comp.uid in _gui_objects) {
			_gui_objects[comp.uid].visible = true;
			guiSetVisible(_gui_objects[comp.uid].intance, true);
		}
	}
});