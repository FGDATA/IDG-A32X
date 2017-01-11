# AIRBUS A320 SYSTEMS FILE
##########################

# NOTE: This file contains a loop for running all update functions, so it should be loaded last

## SYSTEMS LOOP
###############

var systems =
 {
 stopUpdate: 0,
 init: func
  {
  print("A320 Systems ... Done!");
  systems.stop();
  settimer(func
   {
   systems.stopUpdate = 0;
   systems.update();
   }, 0.5);
  },
 stop: func
  {
  systems.stopUpdate = 1;
  },
 update: func
  {
  apu1.update();
  engine1.update();
  engine2.update();
  update_electrical();

  # stop calling our systems code if the stop() function was called or the aircraft crashes
  if (!systems.stopUpdate and !props.globals.getNode("sim/crashed").getBoolValue())
   {
   settimer(systems.update, 0);
   }
  }
 };

# call init() 2 seconds after the FDM is ready
setlistener("sim/signals/fdm-initialized", func
 {
 settimer(systems.init, 2);
 }, 0, 0);
# call init() if the simulator resets
setlistener("sim/signals/reinit", func(reinit)
 {
 if (reinit.getBoolValue())
  {
  systems.init();
  }
 }, 0, 0);

## LIGHTS
#########

# create all lights
var beacon_switch = props.globals.getNode("controls/switches/beacon", 2);
var beacon = aircraft.light.new("sim/model/lights/beacon", [0.015, 3], "controls/lighting/beacon");

var strobe_switch = props.globals.getNode("controls/switches/strobe", 2);
var strobe = aircraft.light.new("sim/model/lights/strobe", [0.025, 1.5], "controls/lighting/strobe");

# logo lights listener
setlistener("controls/lighting/nav-lights-switch", func
 {
 var nav_lights = props.globals.getNode("sim/model/lights/nav-lights");
 var logo_lights = props.globals.getNode("sim/model/lights/logo-lights");
 var setting = getprop("controls/lighting/nav-lights-switch");
 if (setting == 1)
  {
  nav_lights.setBoolValue(1);
  logo_lights.setBoolValue(0);
  }
 elsif (setting == 2)
  {
  nav_lights.setBoolValue(1);
  logo_lights.setBoolValue(1);
  }
 else
  {
  nav_lights.setBoolValue(0);
  logo_lights.setBoolValue(0);
  }
 });

## TIRE SMOKE/RAIN
##################

var tiresmoke_system = aircraft.tyresmoke_system.new(0, 1, 2);
aircraft.rain.init();

## SOUNDS
#########

# seatbelt/no smoking sign triggers
setlistener("controls/switches/seatbelt-sign", func
 {
 setprop("/sim/sound/seatbelt-sign",1);

 settimer(func
  {
  props.globals.getNode("sim/sound/seatbelt-sign").setBoolValue(0);
  }, 2);
 });
setlistener("controls/switches/no-smoking-sign", func
 {
 props.globals.getNode("sim/sound/no-smoking-sign").setBoolValue(1);

 settimer(func
  {
  props.globals.getNode("sim/sound/no-smoking-sign").setBoolValue(0);
  }, 2);
 });


## GEAR
#######

# prevent retraction of the landing gear when any of the wheels are compressed
setlistener("controls/gear/gear-down", func
 {
 var down = props.globals.getNode("controls/gear/gear-down").getBoolValue();
 if (!down and (getprop("gear/gear[0]/wow") or getprop("gear/gear[1]/wow") or getprop("gear/gear[2]/wow")))
  {
  props.globals.getNode("controls/gear/gear-down").setBoolValue(1);
  }
 });

## DOORS
########

# create all doors
# front doors
var doorl1 = aircraft.door.new("sim/model/door-positions/doorl1", 2);
var doorr1 = aircraft.door.new("sim/model/door-positions/doorr1", 2);

# middle doors (A321 only)
var doorl2 = aircraft.door.new("sim/model/door-positions/doorl2", 2);
var doorr2 = aircraft.door.new("sim/model/door-positions/doorr2", 2);
var doorl3 = aircraft.door.new("sim/model/door-positions/doorl3", 2);
var doorr3 = aircraft.door.new("sim/model/door-positions/doorr3", 2);

# rear doors
var doorl4 = aircraft.door.new("sim/model/door-positions/doorl4", 2);
var doorr4 = aircraft.door.new("sim/model/door-positions/doorr4", 2);

# cargo holds
var cargobulk = aircraft.door.new("sim/model/door-positions/cargobulk", 2.5);
var cargoaft = aircraft.door.new("sim/model/door-positions/cargoaft", 2.5);
var cargofwd = aircraft.door.new("sim/model/door-positions/cargofwd", 2.5);

# seat armrests in the flight deck
var armrests = aircraft.door.new("sim/model/door-positions/armrests", 2);

# door opener/closer
var triggerDoor = func(door, doorName, doorDesc)
 {
 if (getprop("sim/model/door-positions/" ~ doorName ~ "/position-norm") > 0)
  {
  gui.popupTip("Closing " ~ doorDesc ~ " door");
  door.toggle();
  }
 else
  {
  if (getprop("velocities/groundspeed-kt") > 5)
   {
   gui.popupTip("You cannot open the doors while the aircraft is moving");
   }
  else
   {
   gui.popupTip("Opening " ~ doorDesc ~ " door");
   door.toggle();
   }
  }
 };
 
setlistener("/sim/signals/fdm-initialized", func {	
  	itaf.ap_init();			
	var autopilot = gui.Dialog.new("sim/gui/dialogs/autopilot/dialog", "Aircraft/A320Family/Systems/autopilot-dlg.xml");
	setprop("/controls/engines/thrust-limit", "TOGA");
	setprop("/controls/engines/epr-limit", 1.301);
	setprop("/controls/engines/n1-limit", 97.8);
	setprop("/it-autoflight/input/fd1", 1);
	setprop("/it-autoflight/input/fd2", 1);
});

var aglgears = func {
    var agl = getprop("/position/altitude-agl-ft") or 0;
    var aglft = agl - 8.004;  # is the position from the Airbus A320 above ground
    var aglm = aglft * 0.3048;
    setprop("/position/gear-agl-ft", aglft);
    setprop("/position/gear-agl-m", aglm);

    settimer(aglgears, 0.01);
}

aglgears();

setlistener("/instrumentation/altimeter/indicated-altitude-ft", func {
	setprop("/instrumentation/altimeter/indicated-altitude-ft-pfd", getprop("/instrumentation/altimeter/indicated-altitude-ft") / 100);
});

setlistener("/instrumentation/vertical-speed-indicator/indicated-speed-fpm", func {
	setprop("/instrumentation/vertical-speed-indicator/indicated-speed-fpm-pfd", getprop("/instrumentation/vertical-speed-indicator/indicated-speed-fpm") / 100);
});

setlistener("/controls/parking-brake", func {
	if (getprop("/controls/parking-brake") == 1) {
		setprop("/electrical/switches/ext-pwr", 1);
	} else {
		setprop("/electrical/switches/ext-pwr", 0);
	}
});