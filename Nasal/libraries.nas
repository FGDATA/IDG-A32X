# A320 Main Libraries
# Joshua Davidson (it0uchpods)

# :)
print("          ____ ___   ___  ______              _ _       ");
print("    /\   |___ \__ \ / _ \|  ____|            (_) |      ");
print("   /  \    __) | ) | | | | |__ __ _ _ __ ___  _| |_   _ ");
print("  / /\ \  |__ < / /| | | |  __/ _` | '_ ` _ \| | | | | |");
print(" / ____ \ ___) / /_| |_| | | | (_| | | | | | | | | |_| |");
print("/_/    \_\____/____|\___/|_|  \__,_|_| |_| |_|_|_|\__, |");
print("                                                   __/ |");
print("                                                  |___/ ");
print("-----------------------------------------------------------------------");
print("(c) 2016-2017 Joshua Davidson, and Jonathan Redpath");
print("Report all bugs on GitHub Issues tab, or the forums. :)");
print("If you are reading this, you are awesome!");
print("-----------------------------------------------------------------------");
print(" ");

# Dimmers
setprop("/controls/lighting/ndl-norm", 0);
setprop("/controls/lighting/ndr-norm", 0);
setprop("/controls/lighting/upper-norm", 0);

##########
# Lights #
##########
var beacon_switch = props.globals.getNode("/controls/switches/beacon", 2);
var beacon = aircraft.light.new("/sim/model/lights/beacon", [0.015, 3], "/controls/lighting/beacon");
var strobe_switch = props.globals.getNode("/controls/switches/strobe", 2);
var strobe = aircraft.light.new("/sim/model/lights/strobe", [0.025, 1.5], "/controls/lighting/strobe");

setlistener("controls/lighting/nav-lights-switch", func {
	var nav_lights = props.globals.getNode("/sim/model/lights/nav-lights");
	var logo_lights = props.globals.getNode("/sim/model/lights/logo-lights");
	var setting = getprop("/controls/lighting/nav-lights-switch");
	if (setting == 1) {
		nav_lights.setBoolValue(1);
		logo_lights.setBoolValue(0);
	} else if (setting == 2) {
		nav_lights.setBoolValue(1);
		logo_lights.setBoolValue(1);
	} else {
		nav_lights.setBoolValue(0);
		logo_lights.setBoolValue(0);
	}
});
 
setlistener("controls/lighting/landing-lights[1]", func {
	var landl = getprop("/controls/lighting/landing-lights[1]");
	if (landl == 1) {
		setprop("/sim/rendering/als-secondary-lights/alt-landing-light",1);
	} else {
		setprop("/sim/rendering/als-secondary-lights/alt-landing-light",0);
	}
});

setlistener("controls/lighting/landing-lights[2]", func {
	var landr = getprop("/controls/lighting/landing-lights[2]");
	if (landr == 1) {
		setprop("/sim/rendering/als-secondary-lights/use-alt-landing-light",1);
	} else {
		setprop("/sim/rendering/als-secondary-lights/use-alt-landing-light",0);
	}
});

###################
# Tire Smoke/Rain #
###################

var tiresmoke_system = aircraft.tyresmoke_system.new(0, 1, 2);
aircraft.rain.init();

##########
# Sounds #
##########

setlistener("/sim/sounde/btn1", func {
	if (!getprop("/sim/sounde/btn1")) {
		return;
	}
	settimer(func {
		props.globals.getNode("/sim/sounde/btn1").setBoolValue(0);
	}, 0.05);
});

setlistener("/sim/sounde/oh-btn", func {
	if (!getprop("/sim/sounde/oh-btn")) {
		return;
	}
	settimer(func {
		props.globals.getNode("/sim/sounde/oh-btn").setBoolValue(0);
	}, 0.05);
});

setlistener("/sim/sounde/btn3", func {
	if (!getprop("/sim/sounde/btn3")) {
		return;
	}
	settimer(func {
		props.globals.getNode("/sim/sounde/btn3").setBoolValue(0);
	}, 0.05);
});

setlistener("/sim/sounde/knb1", func {
	if (!getprop("/sim/sounde/knb1")) {
		return;
	}
	settimer(func {
		props.globals.getNode("/sim/sounde/knb1").setBoolValue(0);
	}, 0.05);
});

setlistener("/sim/sounde/switch1", func {
	if (!getprop("/sim/sounde/switch1")) {
		return;
	}
	settimer(func {
		props.globals.getNode("/sim/sounde/switch1").setBoolValue(0);
	}, 0.05);
});

setlistener("/controls/switches/seatbelt-sign", func {
	props.globals.getNode("/sim/sounde/seatbelt-sign").setBoolValue(1);
	settimer(func {
		props.globals.getNode("/sim/sounde/seatbelt-sign").setBoolValue(0);
	}, 2);
});

setlistener("/controls/switches/no-smoking-sign", func {
	props.globals.getNode("/sim/sounde/no-smoking-sign").setBoolValue(1);
	settimer(func {
		props.globals.getNode("/sim/sounde/no-smoking-sign").setBoolValue(0);
	}, 1);
});

#########
# Doors #
#########

# Front doors
var doorl1 = aircraft.door.new("/sim/model/door-positions/doorl1", 2);
var doorr1 = aircraft.door.new("/sim/model/door-positions/doorr1", 2);

# Middle doors (A321 only)
var doorl2 = aircraft.door.new("/sim/model/door-positions/doorl2", 2);
var doorr2 = aircraft.door.new("/sim/model/door-positions/doorr2", 2);
var doorl3 = aircraft.door.new("/sim/model/door-positions/doorl3", 2);
var doorr3 = aircraft.door.new("/sim/model/door-positions/doorr3", 2);

# Rear doors
var doorl4 = aircraft.door.new("/sim/model/door-positions/doorl4", 2);
var doorr4 = aircraft.door.new("/sim/model/door-positions/doorr4", 2);

# Cargo holds
var cargobulk = aircraft.door.new("/sim/model/door-positions/cargobulk", 2.5);
var cargoaft = aircraft.door.new("/sim/model/door-positions/cargoaft", 2.5);
var cargofwd = aircraft.door.new("/sim/model/door-positions/cargofwd", 2.5);

# Seat armrests in the flight deck (unused)
var armrests = aircraft.door.new("/sim/model/door-positions/armrests", 2);

# door opener/closer
var triggerDoor = func(door, doorName, doorDesc) {
	if (getprop("/sim/model/door-positions/" ~ doorName ~ "/position-norm") > 0) {
		gui.popupTip("Closing " ~ doorDesc ~ " door");
		door.toggle();
	} else {
		if (getprop("/velocities/groundspeed-kt") > 5) {
			gui.popupTip("You cannot open the doors while the aircraft is moving!!!");
		} else {
			gui.popupTip("Opening " ~ doorDesc ~ " door");
			door.toggle();
		}
	}
};

#######################
# Various Other Stuff #
#######################
 
setlistener("/sim/signals/fdm-initialized", func {
	fbw.fctlInit();
	systems.elec_init();
	systems.adirs_init();
	systems.pneu_init();
	systems.hyd_init();
	systems.fuel_init();
	systems.eng_init();
  	fmgc.APinit();			
	librariesLoop.start();
	fmgc.FMGCinit();
	mcdu1.MCDU_init();
	mcdu2.MCDU_init();
	icing.PitotIcingReset();
	icing.icingInit();
	var autopilot = gui.Dialog.new("sim/gui/dialogs/autopilot/dialog", "Aircraft/A320Family/Systems/autopilot-dlg.xml");
	setprop("/it-autoflight/input/fd1", 1);
	setprop("/it-autoflight/input/fd2", 1);
	libraries.ECAMinit();
	libraries.variousReset();
});

var librariesLoop = maketimer(0.1, func {
	var groundpwr = getprop("/controls/switches/cart");
	var groundair = getprop("/controls/pneumatic/switches/groundair");
	var gs = getprop("/velocities/groundspeed-kt");
	var parkbrake = getprop("controls/gear/brake-parking");
	
	if ((groundair or groundpwr) and ((gs > 2) or !parkbrake)) {
		setprop("/controls/switches/cart", 0);
		setprop("/controls/pneumatic/switches/groundair", 0);
	}
	
	var V = getprop("/velocities/groundspeed-kt");

	if (V > 15) {
		setprop("/systems/shake/effect", 1);
	} else {
		setprop("/systems/shake/effect", 0);
	}
	
	var trueSpeedKts = getprop("/instrumentation/airspeed-indicator/true-speed-kt");
	if(trueSpeedKts > 420) {
		setprop("/it-autoflight/internal/bank-limit", 15);
	} else if(trueSpeedKts > 340) {
		setprop("/it-autoflight/internal/bank-limit", 20);
	} else {
		setprop("/it-autoflight/internal/bank-limit", 25);
	}
	
	if (getprop("/it-autoflight/custom/show-hdg") == 0 and getprop("/it-autoflight/output/lat") != 4) {
		setprop("/it-autoflight/input/hdg", math.round(getprop("/orientation/heading-magnetic-deg")));
	}
});

setlistener("/options/steep-ils", func {
	if (getprop("/options/steep-ils") == 1) {
		setprop("/instrumentation/mk-viii/inputs/discretes/steep-approach", 1);
	} else {
		setprop("/instrumentation/mk-viii/inputs/discretes/steep-approach", 0);
	}
});

var aglgears = func {
    var agl = getprop("/position/altitude-agl-ft") or 0;
    var aglft = agl - 11.101;  # is the position from the Airbus A320 above ground
    var aglm = aglft * 0.3048;
    setprop("/position/gear-agl-ft", aglft);
    setprop("/position/gear-agl-m", aglm);

    settimer(aglgears, 0.01);
}

aglgears();

# In air, flaps 1 is slats only. On ground, it is slats and flaps.

setprop("/controls/flight/flap-lever", 0);
setprop("/controls/flight/flap-pos", 0);
setprop("/controls/flight/flap-txt", " ");

controls.flapsDown = func(step) {
	if (step == 1) {
		if (getprop("/controls/flight/flap-lever") == 0) {
			if (getprop("/velocities/airspeed-kt") <= 100) {
				setprop("/controls/flight/flaps", 0.290);
				setprop("/controls/flight/slats", 0.666);
				setprop("/controls/flight/flap-lever", 1);
				setprop("/controls/flight/flap-pos", 2);
				setprop("/controls/flight/flap-txt", "1+F");
				flaptimer.start();
				return;
			} else {
				setprop("/controls/flight/flaps", 0.000);
				setprop("/controls/flight/slats", 0.666);
				setprop("/controls/flight/flap-lever", 1);
				setprop("/controls/flight/flap-pos", 1);
				setprop("/controls/flight/flap-txt", "1");
				flaptimer.stop();
				return;
			}
		} else if (getprop("/controls/flight/flap-lever") == 1) {
			setprop("/controls/flight/flaps", 0.596);
			setprop("/controls/flight/slats", 0.814);
			setprop("/controls/flight/flap-lever", 2);
			setprop("/controls/flight/flap-pos", 3);
			setprop("/controls/flight/flap-txt", "2");
			flaptimer.stop();
			return;
		} else if (getprop("/controls/flight/flap-lever") == 2) {
			setprop("/controls/flight/flaps", 0.645);
			setprop("/controls/flight/slats", 0.814);
			setprop("/controls/flight/flap-lever", 3);
			setprop("/controls/flight/flap-pos", 4);
			setprop("/controls/flight/flap-txt", "3");
			flaptimer.stop();
			return;
		} else if (getprop("/controls/flight/flap-lever") == 3) {
			setprop("/controls/flight/flaps", 1.000);
			setprop("/controls/flight/slats", 1.000);
			setprop("/controls/flight/flap-lever", 4);
			setprop("/controls/flight/flap-pos", 5);
			setprop("/controls/flight/flap-txt", "FULL");
			flaptimer.stop();
			return;
		}
	} else if (step == -1) {
		if (getprop("/controls/flight/flap-lever") == 4) {
			setprop("/controls/flight/flaps", 0.645);
			setprop("/controls/flight/slats", 0.814);
			setprop("/controls/flight/flap-lever", 3);
			setprop("/controls/flight/flap-pos", 4);
			setprop("/controls/flight/flap-txt", "3");
			flaptimer.stop();
			return;
		} else if (getprop("/controls/flight/flap-lever") == 3) {
			setprop("/controls/flight/flaps", 0.596);
			setprop("/controls/flight/slats", 0.814);
			setprop("/controls/flight/flap-lever", 2);
			setprop("/controls/flight/flap-pos", 3);
			setprop("/controls/flight/flap-txt", "2");
			flaptimer.stop();
			return;
		} else if (getprop("/controls/flight/flap-lever") == 2) {
			if (getprop("/velocities/airspeed-kt") <= 100) {
				setprop("/controls/flight/flaps", 0.290);
				setprop("/controls/flight/slats", 0.666);
				setprop("/controls/flight/flap-lever", 1);
				setprop("/controls/flight/flap-pos", 2);
				setprop("/controls/flight/flap-txt", "1+F");
				flaptimer.start();
				return;
			} else {
				setprop("/controls/flight/flaps", 0.000);
				setprop("/controls/flight/slats", 0.666);
				setprop("/controls/flight/flap-lever", 1);
				setprop("/controls/flight/flap-pos", 1);
				setprop("/controls/flight/flap-txt", "1");
				flaptimer.stop();
				return;
			}
		} else if (getprop("/controls/flight/flap-lever") == 1) {
			setprop("/controls/flight/flaps", 0.000);
			setprop("/controls/flight/slats", 0.000);
			setprop("/controls/flight/flap-lever", 0);
			setprop("/controls/flight/flap-pos", 0);
			setprop("/controls/flight/flap-txt", " ");
			flaptimer.stop();
			return;
		}
	} else {
		return 0;
	}
}

var flaptimer = maketimer(0.5, func {
	if (getprop("/controls/flight/flap-pos") == 2 and getprop("/velocities/airspeed-kt") >= 208) {
		setprop("/controls/flight/flaps", 0.000);
		setprop("/controls/flight/slats", 0.666);
		setprop("/controls/flight/flap-lever", 1);
		setprop("/controls/flight/flap-pos", 1);
		setprop("/controls/flight/flap-txt", "1");
		flaptimer.stop();
	}
});
