# A3XX FADEC/Throttle Control System by Joshua Davidson (it0uchpods)
# V2.0.0

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

setprop("/systems/thrust/alpha-floor", 0);
setprop("/systems/thrust/toga-lk", 0);

setprop("/systems/thrust/epr/toga-lim", 0.0);
setprop("/systems/thrust/epr/mct-lim", 0.0);
setprop("/systems/thrust/epr/flx-lim", 0.0);
setprop("/systems/thrust/epr/clb-lim", 0.0);
setprop("/systems/thrust/n1/toga-lim", 0.0);
setprop("/systems/thrust/n1/mct-lim", 0.0);
setprop("/systems/thrust/n1/flx-lim", 0.0);
setprop("/systems/thrust/n1/clb-lim", 0.0);
setprop("/engines/flx-thr", 0.0);
setprop("/controls/engines/thrust-limit", "TOGA");
setprop("/controls/engines/epr-limit", 0.0);
setprop("/controls/engines/n1-limit", 0.0);
setprop("/systems/thrust/state1", "IDLE");
setprop("/systems/thrust/state2", "IDLE");
setprop("/systems/thrust/lvrclb", "0");
setprop("/systems/thrust/clbreduc-ft", "1500");
setprop("/systems/thrust/toga-lim", 0.0);
setprop("/systems/thrust/mct-lim", 0.0);
setprop("/systems/thrust/clb-lim", 0.0);
setprop("/systems/thrust/lim-flex", 0);
setprop("/engines/flex-derate", 0);

setlistener("/sim/signals/fdm-initialized", func {
	var thr1 = getprop("/controls/engines/engine[0]/throttle-pos");
	var thr2 = getprop("/controls/engines/engine[1]/throttle-pos");
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	var engstate1 = getprop("/engines/engine[0]/state");
	var engstate2 = getprop("/engines/engine[1]/state");
	var eprtoga = getprop("/systems/thrust/epr/toga-lim");
	var eprmct = getprop("/systems/thrust/epr/mct-lim");
	var eprflx = getprop("/systems/thrust/epr/flx-lim");
	var eprclb = getprop("/systems/thrust/epr/clb-lim");
	var n1toga = getprop("/systems/thrust/n1/toga-lim");
	var n1mct = getprop("/systems/thrust/n1/mct-lim");
	var n1flx = getprop("/systems/thrust/n1/flx-lim");
	var n1clb = getprop("/systems/thrust/n1/clb-lim");
	var ias = getprop("/velocities/airspeed-kt");
	var flaps = getprop("/controls/flight/flap-pos");
	var alphaProtSpd = getprop("/FMGC/internal/alpha-prot-speed");
	thrustt.start();
});

setlistener("/controls/engines/engine[0]/throttle-pos", func {
	engstate1 = getprop("/engines/engine[0]/state");
	engstate2 = getprop("/engines/engine[1]/state");
	thr1 = getprop("/controls/engines/engine[0]/throttle-pos");
	if (getprop("/systems/thrust/alpha-floor") == 0 and getprop("/systems/thrust/toga-lk") == 0) {
		if (thr1 < 0.01) {
			setprop("/systems/thrust/state1", "IDLE");
			unflex();
			atoff_request();
		} else if (thr1 >= 0.01 and thr1 < 0.60) {
			setprop("/systems/thrust/state1", "MAN");
			unflex();
		} else if (thr1 >= 0.60 and thr1 < 0.65) {
			setprop("/systems/thrust/state1", "CL");
			unflex();
		} else if (thr1 >= 0.65 and thr1 < 0.78) {
			setprop("/systems/thrust/state1", "MAN THR");
			unflex();
		} else if (thr1 >= 0.78 and thr1 < 0.83) {
			if (getprop("/controls/engines/thrust-limit") == "FLX") {
				if (getprop("/gear/gear[0]/wow") == 1 and (engstate1 == 3 or engstate2 == 3)) {
					setprop("/it-autoflight/input/athr", 1);
				}
				setprop("/controls/engines/engine[0]/throttle-fdm", 0.99);
			} else {
				setprop("/controls/engines/engine[0]/throttle-fdm", 0.95);
			}
			setprop("/systems/thrust/state1", "MCT");
		} else if (thr1 >= 0.83 and thr1 < 0.95) {
			setprop("/systems/thrust/state1", "MAN THR");
			unflex();
		} else if (thr1 >= 0.95) {
			if (getprop("/gear/gear[0]/wow") == 1 and (engstate1 == 3 or engstate2 == 3)) {
				setprop("/it-autoflight/input/athr", 1);
			}
			setprop("/controls/engines/engine[0]/throttle-fdm", 0.99);
			setprop("/systems/thrust/state1", "TOGA");
			unflex();
		}
	} else {
		if (thr1 < 0.01) {
			setprop("/systems/thrust/state1", "IDLE");
		} else if (thr1 >= 0.01 and thr1 < 0.60) {
			setprop("/systems/thrust/state1", "MAN");
		} else if (thr1 >= 0.60 and thr1 < 0.65) {
			setprop("/systems/thrust/state1", "CL");
		} else if (thr1 >= 0.65 and thr1 < 0.78) {
			setprop("/systems/thrust/state1", "MAN THR");
		} else if (thr1 >= 0.78 and thr1 < 0.83) {
			setprop("/systems/thrust/state1", "MCT");
		} else if (thr1 >= 0.83 and thr1 < 0.95) {
			setprop("/systems/thrust/state1", "MAN THR");
		} else if (thr1 >= 0.95) {
			setprop("/systems/thrust/state1", "TOGA");
		}
		setprop("/controls/engines/engine[0]/throttle-fdm", 0.99);
	}
});

setlistener("/controls/engines/engine[1]/throttle-pos", func {
	engstate1 = getprop("/engines/engine[0]/state");
	engstate2 = getprop("/engines/engine[1]/state");
	thr2 = getprop("/controls/engines/engine[1]/throttle-pos");
	if (getprop("/systems/thrust/alpha-floor") == 0 and getprop("/systems/thrust/toga-lk") == 0) {
		if (thr2 < 0.01) {
			setprop("/systems/thrust/state2", "IDLE");
			unflex();
			atoff_request();
		} else if (thr2 >= 0.01 and thr2 < 0.60) {
			setprop("/systems/thrust/state2", "MAN");
			unflex();
		} else if (thr2 >= 0.60 and thr2 < 0.65) {
			setprop("/systems/thrust/state2", "CL");
			unflex();
		} else if (thr2 >= 0.65 and thr2 < 0.78) {
			setprop("/systems/thrust/state2", "MAN THR");
			unflex();
		} else if (thr2 >= 0.78 and thr2 < 0.83) {
			if (getprop("/controls/engines/thrust-limit") == "FLX") {
				if (getprop("/gear/gear[0]/wow") == 1 and (engstate1 == 3 or engstate2 == 3)) {
					setprop("/it-autoflight/input/athr", 1);
				}
				setprop("/controls/engines/engine[1]/throttle-fdm", 0.99);
			} else {
				setprop("/controls/engines/engine[1]/throttle-fdm", 0.95);
			}
			setprop("/systems/thrust/state2", "MCT");
		} else if (thr2 >= 0.83 and thr2 < 0.95) {
			setprop("/systems/thrust/state2", "MAN THR");
			unflex();
		} else if (thr2 >= 0.95) {
			if (getprop("/gear/gear[0]/wow") == 1 and (engstate1 == 3 or engstate2 == 3)) {
				setprop("/it-autoflight/input/athr", 1);
			}
			setprop("/controls/engines/engine[1]/throttle-fdm", 0.99);
			setprop("/systems/thrust/state2", "TOGA");
			unflex();
		}
	} else {
		if (thr2 < 0.01) {
			setprop("/systems/thrust/state2", "IDLE");
		} else if (thr2 >= 0.01 and thr2 < 0.60) {
			setprop("/systems/thrust/state2", "MAN");
		} else if (thr2 >= 0.60 and thr2 < 0.65) {
			setprop("/systems/thrust/state2", "CL");
		} else if (thr2 >= 0.65 and thr2 < 0.78) {
			setprop("/systems/thrust/state2", "MAN THR");
		} else if (thr2 >= 0.78 and thr2 < 0.83) {
			setprop("/systems/thrust/state2", "MCT");
		} else if (thr2 >= 0.83 and thr2 < 0.95) {
			setprop("/systems/thrust/state2", "MAN THR");
		} else if (thr2 >= 0.95) {
			setprop("/systems/thrust/state2", "TOGA");
		}
		setprop("/controls/engines/engine[1]/throttle-fdm", 0.99);
	}
});

# Alpha Floor and Toga Lock
setlistener("/it-autoflight/input/athr", func {
	if (getprop("/systems/thrust/alpha-floor") == 1) {
		setprop("/it-autoflight/input/athr", 1);
	} else {
		setprop("/systems/thrust/toga-lk", 0);
	}
});

# Checks if all throttles are in the IDLE position, before tuning off the A/THR.
var atoff_request = func {
	state1 = getprop("/systems/thrust/state1");
	state2 = getprop("/systems/thrust/state2");
	if ((state1 == "IDLE") and (state2 == "IDLE") and (getprop("/systems/thrust/alpha-floor") == 0) and (getprop("/systems/thrust/toga-lk") == 0)) {
		setprop("/it-autoflight/input/athr", 0);
	}
}

setlistener("/systems/thrust/state1", func {
	thrust_lim();
});

setlistener("/systems/thrust/state2", func {
	thrust_lim();
});

var thrust_lim = func {
	state1 = getprop("/systems/thrust/state1");
	state2 = getprop("/systems/thrust/state2");
	thr1 = getprop("/controls/engines/engine[0]/throttle-pos");
	thr2 = getprop("/controls/engines/engine[1]/throttle-pos");
	eprtoga = getprop("/systems/thrust/epr/toga-lim");
	eprmct = getprop("/systems/thrust/epr/mct-lim");
	eprflx = getprop("/systems/thrust/epr/flx-lim");
	eprclb = getprop("/systems/thrust/epr/clb-lim");
	n1toga = getprop("/systems/thrust/n1/toga-lim");
	n1mct = getprop("/systems/thrust/n1/mct-lim");
	n1flx = getprop("/systems/thrust/n1/flx-lim");
	n1clb = getprop("/systems/thrust/n1/clb-lim");
	if (getprop("/gear/gear[1]/wow") == 0 or getprop("/gear/gear[2]/wow") == 0) {
		if ((state1 == "TOGA" or state2 == "TOGA" or (state1 == "MAN THR" and thr1 >= 0.83) or (state2 == "MAN THR" and thr2 >= 0.83)) or getprop("/systems/thrust/alpha-floor") == 1 or getprop("/systems/thrust/toga-lk") == 1) {
			setprop("/controls/engines/thrust-limit", "TOGA");
			setprop("/controls/engines/epr-limit", eprtoga);
			setprop("/controls/engines/n1-limit", n1toga);
		} else if ((state1 == "MCT" or state2 == "MCT" or (state1 == "MAN THR" and thr1 < 0.83) or (state2 == "MAN THR" and thr2 < 0.83)) and getprop("/systems/thrust/lim-flex") == 0) {
			setprop("/controls/engines/thrust-limit", "MCT");
			setprop("/controls/engines/epr-limit", eprmct);
			setprop("/controls/engines/n1-limit", n1mct);
		} else if ((state1 == "MCT" or state2 == "MCT" or (state1 == "MAN THR" and thr1 < 0.83) or (state2 == "MAN THR" and thr2 < 0.83)) and getprop("/systems/thrust/lim-flex") == 1) {
			setprop("/controls/engines/thrust-limit", "FLX");
			setprop("/controls/engines/epr-limit", eprflx);
			setprop("/controls/engines/n1-limit", n1flx);
		} else if (state1 == "CL" or state2 == "CL" or state1 == "MAN" or state2 == "MAN" or state1 == "IDLE" or state2 == "IDLE") {
			setprop("/controls/engines/thrust-limit", "CLB");
			setprop("/controls/engines/epr-limit", eprclb);
			setprop("/controls/engines/n1-limit", n1clb);
		}
	} else if (getprop("/FMGC/internal/flex-set") == 1 and getprop("/systems/fadec/n1mode1") == 0 and getprop("/systems/fadec/n1mode2") == 0) {
		setprop("/systems/thrust/lim-flex", 1);
		setprop("/controls/engines/thrust-limit", "FLX");
		setprop("/controls/engines/epr-limit", eprflx);
		setprop("/controls/engines/n1-limit", n1flx);
	} else {
		setprop("/controls/engines/thrust-limit", "TOGA");
		setprop("/controls/engines/epr-limit", eprtoga);
		setprop("/controls/engines/n1-limit", n1toga);
	}
}

var unflex = func {
	state1 = getprop("/systems/thrust/state1");
	state2 = getprop("/systems/thrust/state2");
	if (state1 != "MCT" and state2 != "MCT" and getprop("/gear/gear[1]/wow") == 0 and getprop("/gear/gear[2]/wow") == 0) {
		setprop("/systems/thrust/lim-flex", 0);
	}
}

var thrust_loop = func {
	state1 = getprop("/systems/thrust/state1");
	state2 = getprop("/systems/thrust/state2");
	if ((state1 == "CL") and (state2 == "CL")) {
		setprop("/systems/thrust/lvrclb", "0");
	} else {
		var status = getprop("/systems/thrust/lvrclb");
		if (status == 0) {
			if (getprop("/gear/gear[0]/wow") == 0) {
				if (getprop("/systems/thrust/state1") == "MAN" or getprop("/systems/thrust/state2") == "MAN") {
					setprop("/systems/thrust/lvrclb", "1");
				} else {
					if (getprop("/instrumentation/altimeter/indicated-altitude-ft") >= getprop("/systems/thrust/clbreduc-ft") and getprop("/gear/gear[1]/wow") == 0 and getprop("/gear/gear[2]/wow") == 0) {
						setprop("/systems/thrust/lvrclb", "1");
					} else {
						setprop("/systems/thrust/lvrclb", "0");
					}
				}
			}
		} else if (status == 1) {
			setprop("/systems/thrust/lvrclb", "0");
		}
	}

#	ias = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
#	flaps = getprop("/controls/flight/flap-pos");
#	alphaProtSpd = getprop("/FMGC/internal/alpha-prot-speed");
#	togaLockSpd = alphaProtSpd + 3;
#	if (getprop("/gear/gear[1]/wow") == 0 and getprop("/gear/gear[2]/wow") == 0 and getprop("/it-fbw/law") == 0) {
#		if (ias < alphaProtSpd) {
#			setprop("/systems/thrust/alpha-floor", 1);
#			setprop("/systems/thrust/toga-lk", 0);
#			setprop("/it-autoflight/input/athr", 1);
#		} else if (getprop("/systems/thrust/alpha-floor") == 1 and ias > togaLockSpd) {
#			setprop("/systems/thrust/alpha-floor", 0);
#			setprop("/it-autoflight/input/athr", 1);
#			setprop("/systems/thrust/toga-lk", 1);
#		}
#	} else {
#		setprop("/systems/thrust/alpha-floor", 0);
#		setprop("/systems/thrust/toga-lk", 0);
#	}
}

# Timers
var thrustt = maketimer(0.5, thrust_loop);
