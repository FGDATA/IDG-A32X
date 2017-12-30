# A3XX Buttons
# Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

# Resets buttons to the default values
var variousReset = func {
	setprop("/modes/cpt-du-xfr", 0);
	setprop("/modes/fo-du-xfr", 0);
	setprop("/controls/fadec/n1mode1", 0);
	setprop("/controls/fadec/n1mode2", 0);
	setprop("/instrumentation/mk-viii/serviceable", 1);
	setprop("/instrumentation/mk-viii/inputs/discretes/terr-inhibit", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/gpws-inhibit", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/glideslope-cancel", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/momentary-flap-all-override", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/momentary-flap-3-override", 0);
	setprop("/controls/switches/cabinCall", 0);
	setprop("/controls/switches/mechCall", 0);
	setprop("/controls/switches/emer-lights", 0.5);
	# cockpit voice recorder stuff
	setprop("/controls/CVR/power", 0);
	setprop("/controls/CVR/test", 0);
	setprop("/controls/CVR/tone", 0);
	setprop("/controls/CVR/gndctl", 0);
	setprop("/controls/CVR/erase", 0);
	setprop("/controls/switches/cabinfan", 1);
	setprop("/controls/oxygen/crewOxyPB", 1); # 0 = OFF 1 = AUTO
	setprop("/controls/switches/emerCallLtO", 0); # ON light, flashes white for 10s
	setprop("/controls/switches/emerCallLtC", 0); # CALL light, flashes amber for 10s
	setprop("/controls/switches/emerCall", 0);
	setprop("/controls/switches/LrainRpt", 0);
	setprop("/controls/switches/RrainRpt", 0);
	setprop("/controls/switches/wiperLspd", 0); # -1 = INTM 0 = OFF 1 = LO 2 = HI
	setprop("/controls/switches/wiperRspd", 0); # -1 = INTM 0 = OFF 1 = LO 2 = HI
	setprop("/controls/lighting/strobe", 0);
	setprop("/controls/lighting/beacon", 0);
	setprop("/controls/lighting/wing-lights", 0);
	setprop("/controls/lighting/nav-lights-switch", 0);
	setprop("/controls/lighting/landing-lights[1]", 0);
	setprop("/controls/lighting/landing-lights[2]", 0);
	setprop("/controls/lighting/taxi-light-switch", 0);
	setprop("/controls/lighting/DU/du1", 1);
	setprop("/controls/lighting/DU/du2", 1);
	setprop("/controls/lighting/DU/du3", 1);
	setprop("/controls/lighting/DU/du4", 1);
	setprop("/controls/lighting/DU/du5", 1);
	setprop("/controls/lighting/DU/du6", 1);
	setprop("/modes/fcu/hdg-time", 0);
	setprop("/controls/switching/ATTHDG", 0);
	setprop("/controls/switching/AIRDATA", 0);
	setprop("/controls/switches/no-smoking-sign", 1);
	setprop("/controls/switches/seatbelt-sign", 1);
}

setlistener("/sim/signals/fdm-initialized", func {
	var stateL = getprop("/engines/engine[0]/state");
	var stateR = getprop("/engines/engine[1]/state");
	var Lrain = getprop("/controls/switches/LrainRpt");
	var Rrain = getprop("/controls/switches/RrainRpt");
	var OnLt = getprop("/controls/switches/emerCallLtO");
	var CallLt = getprop("/controls/switches/emerCallLtC");
	var wow = getprop("/gear/gear[1]/wow");
	rainTimer.start();
});

# inhibit rain rpt when engines off and on ground
var rainRepel = func {
	Lrain = getprop("/controls/switches/LrainRpt");
	Rrain = getprop("/controls/switches/RrainRpt");
	wow = getprop("/gear/gear[1]/wow");
	stateL = getprop("/engines/engine[0]/state");
	stateR = getprop("/engines/engine[1]/state");
	if (Lrain and (stateL != 3 and stateR != 3 and wow)) {	
		setprop("/controls/switches/LrainRpt", 0);
	}
	if (Rrain and (stateL != 3 and stateR != 3 and wow)) { 
		setprop("/controls/switches/RrainRpt", 0);
	}
}

var EmerCall = func {
	setprop("/controls/switches/emerCall", 1);
	EmerCallTimer1.start();
	EmerCallTimer2.start();
	settimer(func() {
		setprop("/controls/switches/emerCall", 0);
		EmerCallTimer1.stop();
		EmerCallTimer2.stop();
	}, 10);
}

var EmerCallOnLight = func {
	OnLt = getprop("/controls/switches/emerCallLtO");
	if (OnLt) { 
		setprop("/controls/switches/emerCallLtO", 0);
	} else if (!OnLt) { 
		setprop("/controls/switches/emerCallLtO", 1);
	}
}

var EmerCallLightCall = func {
	CallLt = getprop("/controls/switches/emerCallLtC");
	if (CallLt) { 
		setprop("/controls/switches/emerCallLtC", 0);
	} else if (!CallLt) { 
		setprop("/controls/switches/emerCallLtC", 1);
	}
}

var CabinCall = func {
	setprop("/controls/switches/emerCall", 0);
	settimer(func() {
		setprop("/controls/switches/emerCall", 0);
	}, 15);
}
		
var MechCall = func {
	setprop("/controls/switches/mechCall", 1);
	settimer(func() {
		setprop("/controls/switches/mechCall", 0);
	}, 15);
}

var CVR_test = func {
	var parkBrake = getprop("/controls/gear/brake-parking");
	if (parkBrake) {
		setprop("controls/CVR/tone", 1);
		settimer(func() {
			setprop("controls/CVR/tone", 0);
		}, 15);
	}
}

var CVR_master = func {
	var stateL = getprop("/engines/engine[0]/state");
	var stateR = getprop("/engines/engine[1]/state");
	var wowl = getprop("/gear/gear[1]/wow");
	var wowr = getprop("/gear/gear[2]/wow");
	var gndCtl = getprop("/systems/CVR/gndctl");
	var acPwr = getprop("/systems/electrical/bus/ac-ess");
	if (acPwr > 0 and wowl and wowr and (gndCtl or (stateL == 3 or stateR == 3))) {
		setprop("/controls/CVR/power", 1);
	} else if (!wowl and !wowr and acPwr > 0) {
		setprop("/controls/CVR/power", 1);
	} else {
		setprop("/controls/CVR/power", 0);
	}
}

var mcpSPDKnbPull = func {
	setprop("/it-autoflight/input/spd-managed", 0);
	fmgc.ManagedSPD.stop();
	var ias = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
	var mach = getprop("/instrumentation/airspeed-indicator/indicated-mach");
	if (getprop("/it-autoflight/input/kts-mach") == 0) {
		if (ias >= 100 and ias <= 360) {
			setprop("/it-autoflight/input/spd-kts", math.round(ias, 1));
		} else if (ias < 100) {
			setprop("/it-autoflight/input/spd-kts", 100);
		} else if (ias > 360) {
			setprop("/it-autoflight/input/spd-kts", 360);
		}
	} else if (getprop("/it-autoflight/input/kts-mach") == 1) {
		if (mach >= 0.50 and mach <= 0.95) {
			setprop("/it-autoflight/input/spd-mach", math.round(mach, 0.001));
		} else if (mach < 0.50) {
			setprop("/it-autoflight/input/spd-mach", 0.50);
		} else if (mach > 0.95) {
			setprop("/it-autoflight/input/spd-mach", 0.95);
		}
	}
}

var mcpSPDKnbPush = func {
	if (getprop("/FMGC/internal/cruise-lvl-set") == 1 and getprop("/FMGC/internal/cost-index-set") == 1) {
		setprop("/it-autoflight/input/spd-managed", 1);
		fmgc.ManagedSPD.start();
	}
}

var mcpHDGKnbPull = func {
	if (getprop("/it-autoflight/output/fd1") == 1 or getprop("/it-autoflight/output/fd2") == 1 or getprop("/it-autoflight/output/ap1") == 1 or getprop("/it-autoflight/output/ap2") == 1) {
		var latmode = getprop("/it-autoflight/output/lat");
		var showhdg = getprop("/it-autoflight/custom/show-hdg");
		if (latmode == 0 or showhdg == 0) {
			setprop("/it-autoflight/input/lat", 3);
			setprop("/it-autoflight/custom/show-hdg", 1);
		} else {
			setprop("/it-autoflight/input/lat", 0);
			setprop("/it-autoflight/custom/show-hdg", 1);
		}
	}
}

var hdgInput = func {
	var latmode = getprop("/it-autoflight/output/lat");
	if (latmode != 0) {
		setprop("/it-autoflight/custom/show-hdg", 1);
		var hdgnow = getprop("/it-autoflight/input/hdg");
		setprop("/modes/fcu/hdg-time", getprop("/sim/time/elapsed-sec"));
	}
}

var mcpHDGKnbPush = func {
	if (getprop("/it-autoflight/output/fd1") == 1 or getprop("/it-autoflight/output/fd2") == 1 or getprop("/it-autoflight/output/ap1") == 1 or getprop("/it-autoflight/output/ap2") == 1) {
		setprop("/it-autoflight/input/lat", 1);
	}
}

var toggleSTD = func {
	var Std = getprop("/modes/altimeter/std");
	if (Std == 1) {
		var oldqnh = getprop("/modes/altimeter/oldqnh");
		setprop("/instrumentation/altimeter/setting-inhg", oldqnh);
		setprop("/modes/altimeter/std", 0);
	} else if (Std == 0) {
		var qnh = getprop("/instrumentation/altimeter/setting-inhg");
		setprop("/modes/altimeter/oldqnh", qnh);
		setprop("/instrumentation/altimeter/setting-inhg", 29.92);
		setprop("/modes/altimeter/std", 1);
	}
}

var increaseManVS = func {
	var manvs = getprop("/systems/pressurization/outflowpos-man");
	var auto = getprop("/systems/pressurization/auto");
	if (manvs <= 1 and manvs >= 0 and !auto) {
		setprop("/systems/pressurization/outflowpos-man", manvs + 0.001);
	}
}

var decreaseManVS = func {
	var manvs = getprop("/systems/pressurization/outflowpos-man");
	var auto = getprop("/systems/pressurization/auto");
	if (manvs <= 1 and manvs >= 0 and !auto) {
		setprop("/systems/pressurization/outflowpos-man", manvs - 0.001);
	}
}

var update_CVR = func {
	CVR_master();
}

var CVR = maketimer(0.1, update_CVR);
var EmerCallTimer1 = maketimer(0.5, EmerCallOnLight);
var EmerCallTimer2 = maketimer(0.5, EmerCallLightCall);
var rainTimer = maketimer(0.1, rainRepel);