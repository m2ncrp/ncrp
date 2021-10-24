const ELEMENT_TYPE_BUTTON = 2;
const ELEMENT_TYPE_IMAGE = 13;
// check for 2x widht bug
local screen = getScreenSize();
local screenX = screen[0].tofloat();
local screenY = screen[1].tofloat();

if ((screenX / screenY) > 2.0) {
    screenX = 0.5 * screenX;
}

screen = [screenX, screenY];
centerX <- screenX * 0.5;
centerY <- screenY * 0.5;

local windowWidth = 153.0;
local windowWidthHalf = windowWidth * 0.5;

local window;

local images = array(6);

local xOffset = -5.0;
local yOffset = -67.0;

local state = {};

function setVehicleState(vehicleid, doorsCount, hasTrunk, frontLeftDoor, frontRightDoor, rearLeftDoor, rearRightDoor, trunkOpened, trunkLocked) {
    state.vehicleid <- vehicleid;
    state.doorsCount <- doorsCount;
    state.hasTrunk <- hasTrunk;
    state.frontLeftDoor <- frontLeftDoor;
    state.frontRightDoor <- frontRightDoor;
    state.rearLeftDoor <- rearLeftDoor;
    state.rearRightDoor <- rearRightDoor;
    state.trunkOpened <- trunkOpened;
    state.trunkLocked <- trunkLocked;
}

function getLockedText(value) {
  return value == true ? "Locked" : "Unlocked";
}

addEventHandler("showVehicleGUI", function(windowText, vehicleid, doorsCount, hasTrunk, frontLeftDoor, frontRightDoor, rearLeftDoor, rearRightDoor, trunkOpened, trunkLocked) {
    setVehicleState(vehicleid, doorsCount, hasTrunk, frontLeftDoor, frontRightDoor, rearLeftDoor, rearRightDoor, trunkOpened, trunkLocked);
    local dynamicY = 27.0;
    local windowHeight = 101.0;

    if(doorsCount > 2) {
      windowHeight += 69;
    }

    if(hasTrunk) {
      windowHeight += 69;
    }

    local windowHeightHalf = windowHeight * 0.5;

    window = guiCreateElement( ELEMENT_TYPE_WINDOW, windowText, centerX - windowWidthHalf, centerY - windowHeightHalf, windowWidth, windowHeight);

    guiSetSize(window, windowWidth, windowHeight);
    guiSetPosition(window, windowText, centerX - windowWidthHalf, centerY - windowHeightHalf);
    guiSetText(window, windowText);
    guiSetVisible(window, true);

    delayedFunction(0, function() {
      images[0] = guiCreateElement( ELEMENT_TYPE_IMAGE, "Vehicle.LeftDoor" + getLockedText(frontLeftDoor) +".png", 10, dynamicY, 64.0, 64.0, false, window);
      if(frontRightDoor != null) {
        images[1] = guiCreateElement( ELEMENT_TYPE_IMAGE, "Vehicle.RightDoor" + getLockedText(frontRightDoor) +".png", 79, dynamicY, 64.0, 64.0, false, window);
      }

      if(rearLeftDoor != null) {
        dynamicY += 69;
        images[2] = guiCreateElement( ELEMENT_TYPE_IMAGE, "Vehicle.LeftDoor" + getLockedText(rearLeftDoor) +".png", 10, dynamicY, 64.0, 64.0, false, window);
        images[3] = guiCreateElement( ELEMENT_TYPE_IMAGE, "Vehicle.RightDoor" + getLockedText(rearRightDoor) +".png", 79, dynamicY, 64.0, 64.0, false, window);
      }

      if(hasTrunk) {
        dynamicY += 69;
        images[4] = guiCreateElement( ELEMENT_TYPE_IMAGE, "Vehicle.Trunk"+getLockedText(trunkLocked)+".png", 44, dynamicY, 64.0, 64.0, false, window);
        // images[5] = guiCreateElement( ELEMENT_TYPE_IMAGE, "Item.Burger.png", 10, dynamicY, 64.0, 64.0, false, window);
      }
    })

    showCursor(true);
    if (typeof window == "userdata")            guiSetSizable(window, false);
    if (typeof guiSetAlwaysOnTop == "function") guiSetAlwaysOnTop(window, true);
    if (typeof guiSetMovable == "function")     guiSetMovable(window, false);
    delayedFunction(1, function() {
        guiSendToBack(window);
    })
});

addEventHandler("hideVehicleGUI", function() {
    hideVehicleGUI();
});

function hideCursor() {
    showCursor(false);
}

function hideVehicleGUI() {
    delayedFunction(1, function() {
        guiSetVisible(window, false);
        guiDestroyElement(window);
        window = null;
    })
    hideCursor();
    //delayedFunction(100, hideCursor);
}

function onClickDoor(elemIndex, frontOrRear, leftOrRight) {
        local direction = leftOrRight == "left" ? "Left" : "Right";
        local key = frontOrRear+direction+"Door";
        local pos = guiGetPosition(images[elemIndex])
        guiDestroyElement(images[elemIndex]);
        state[key] = !state[key];
        images[elemIndex] = guiCreateElement( ELEMENT_TYPE_IMAGE, "Vehicle."+direction+"Door" + getLockedText(state[key]) +".png", pos[0], pos[1], 64.0, 64.0, false, window);
        triggerServerEvent("setVehicleDoorLocked", state.vehicleid, frontOrRear, leftOrRight, state[key]);
}

addEventHandler("onGuiElementClick", function(element) {
    if(element == window) {
      return;
    }

    if(element == images[0]) {
        onClickDoor(0, "front", "left")
    }

    if(element == images[1]){
        onClickDoor(1, "front",  "right")
    }

    if(element == images[2]){
        onClickDoor(2, "rear", "left")
    }

    if(element == images[3]){
        onClickDoor(3, "rear", "right");
    }

    if(element == images[4]){
        local pos = guiGetPosition(images[4])
        guiDestroyElement(images[4]);
        state.trunkLocked = !state.trunkLocked;
        images[4] = guiCreateElement( ELEMENT_TYPE_IMAGE, "Vehicle.Trunk" + getLockedText(state.trunkLocked) +".png", pos[0], pos[1], 64.0, 64.0, false, window);
        triggerServerEvent("setVehicleTrunkLocked", state.vehicleid, state.trunkLocked);
    }

    // if(element == images[5]){
        //executeLua("game.game:GetActivePlayer():MakeCarOwnership(game.entitywrapper:GetEntityByName(\"m2online_vehicle_"+state.vehicleid+"\"))")
    // }

    delayedFunction(1, function() {
        guiSendToBack(window);
    });
});

function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}