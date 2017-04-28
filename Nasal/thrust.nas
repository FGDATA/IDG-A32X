# A3XX Throttle Control System by Joshua Davidson (it0uchpods)
# Set A/THR modes to Custom IT-AUTOTHRUST, and other thrust modes like MCT, TOGA and eventually TO FLEX.
# Also handles FADEC
# V1.9.1

setlistener("/sim/signals/fdm-initialized", func {
	setprop("/controls/engines/thrust-limit", "TOGA");
	setprop("/controls/engines/epr-limit", 1.308);
	setprop("/controls/engines/n1-limit", 101.9);
	setprop("/systems/thrust/state1", "IDLE");
	setprop("/systems/thrust/state2", "IDLE");
	setprop("/systems/thrust/lvrclb", "0");
	setprop("/systems/thrust/clbreduc-ft", "1550");
	thrustt.start();
});

setlistener("/controls/engines/engine[0]/throttle-pos", func {
	var thrr = getprop("/controls/engines/engine[0]/throttle-pos");
	if (thrr < 0.02) {
		setprop("/systems/thrust/state1", "IDLE");
		atoff_request();
	} else if (thrr >= 0.01 and thrr < 0.60) {
		setprop("/systems/thrust/state1", "MAN");
	} else if (thrr >= 0.60 and thrr < 0.65) {
		setprop("/systems/thrust/state1", "CL");
	} else if (thrr >= 0.65 and thrr < 0.78) {
		setprop("/systems/thrust/state1", "MAN THR");
	} else if (thrr >= 0.78 and thrr < 0.83) {
		setprop("/it-autoflight/input/athr", 1);
		setprop("/controls/engines/engine[0]/throttle-fdm", 0.90);
		setprop("/systems/thrust/state1", "MCT");
	} else if (thrr >= 0.83 and thrr < 0.95) {
		setprop("/it-autoflight/input/athr", 1);
		setprop("/systems/thrust/state1", "MAN THR");
	} else if (thrr >= 0.95) {
		setprop("/it-autoflight/input/athr", 1);
		setprop("/controls/engines/engine[0]/throttle-fdm", 0.95);
		setprop("/systems/thrust/state1", "TOGA");
	}
});

setlistener("/controls/engines/engine[1]/throttle-pos", func {
	var thrr = getprop("/controls/engines/engine[1]/throttle-pos");
	if (thrr < 0.02) {
		setprop("/systems/thrust/state2", "IDLE");
		atoff_request();
	} else if (thrr >= 0.01 and thrr < 0.60) {
		setprop("/systems/thrust/state2", "MAN");
	} else if (thrr >= 0.60 and thrr < 0.65) {
		setprop("/systems/thrust/state2", "CL");
	} else if (thrr >= 0.65 and thrr < 0.78) {
		setprop("/systems/thrust/state2", "MAN THR");
	} else if (thrr >= 0.78 and thrr < 0.83) {
		setprop("/it-autoflight/input/athr", 1);
		setprop("/controls/engines/engine[1]/throttle-fdm", 0.90);
		setprop("/systems/thrust/state2", "MCT");
	} else if (thrr >= 0.83 and thrr < 0.95) {
		setprop("/it-autoflight/input/athr", 1);
		setprop("/systems/thrust/state2", "MAN THR");
	} else if (thrr >= 0.95) {
		setprop("/it-autoflight/input/athr", 1);
		setprop("/controls/engines/engine[1]/throttle-fdm", 0.95);
		setprop("/systems/thrust/state2", "TOGA");
	}
});

# Checks if all throttles are in the IDLE position, before tuning off the A/THR.
var atoff_request = func {
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	if ((state1 == "IDLE") and (state2 == "IDLE")) {
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
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	var thr1 = getprop("/controls/engines/engine[0]/throttle-pos");
	var thr2 = getprop("/controls/engines/engine[0]/throttle-pos");
	if (getprop("/gear/gear[1]/wow") == 0 and getprop("/gear/gear[2]/wow") == 0) {
		if (state1 == "TOGA" or state2 == "TOGA" or (state1 == "MAN THR" and thr1 >= 0.83) or (state2 == "MAN THR" and thr2 >= 0.83)) {
			setprop("/controls/engines/thrust-limit", "TOGA");
			setprop("/controls/engines/epr-limit", 1.308);
			setprop("/controls/engines/n1-limit", 101.8);
		} else if (state1 == "MCT" or state2 == "MCT" or (state1 == "MAN THR" and thr1 < 0.83) or (state2 == "MAN THR" and thr2 < 0.83)) {
			setprop("/controls/engines/thrust-limit", "MCT");
			setprop("/controls/engines/epr-limit", 1.293);
			setprop("/controls/engines/n1-limit", 97.7);
		} else if (state1 == "CL" or state2 == "CL" or state1 == "MAN" or state2 == "MAN" or state1 == "IDLE" or state2 == "IDLE") {
			setprop("/controls/engines/thrust-limit", "CLB");
			setprop("/controls/engines/epr-limit", 1.271);
			setprop("/controls/engines/n1-limit", 91.9);
		}
	} else {
		setprop("/controls/engines/thrust-limit", "TOGA");
		setprop("/controls/engines/epr-limit", 1.308);
		setprop("/controls/engines/n1-limit", 101.9);
	}
}

var thrust_loop = func {
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	if ((state1 == "CL") and (state2 == "CL")) {
		setprop("/systems/thrust/lvrclb", "0");
	} else {
		var status = getprop("/systems/thrust/lvrclb");
		if (status == 0) {
			if (getprop("/systems/thrust/state1") == "MAN" or getprop("/systems/thrust/state2") == "MAN") {
				setprop("/systems/thrust/lvrclb", "1");
			} else {
				if (getprop("/position/gear-agl-ft") >= getprop("/systems/thrust/clbreduc-ft")) {
					setprop("/systems/thrust/lvrclb", "1");
				} else {
					setprop("/systems/thrust/lvrclb", "0");
				}
			}
		} else if (status == 1) {
			setprop("/systems/thrust/lvrclb", "0");
		}
	}
}

# Timers
var thrustt = maketimer(0.5, thrust_loop);
