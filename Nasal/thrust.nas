# A340 Throttle Control System by Joshua Davidson (it0uchpods/411)
# Set A/THR modes to Custom IT-AUTOTHRUST, and other thrust modes like MCT, TOGA and eventually TO FLEX.
# V1.8

setlistener("/sim/signals/fdm-initialized", func {
	setprop("/systems/thrust/state1", "IDLE");
	setprop("/systems/thrust/state2", "IDLE");
	setprop("/systems/thrust/state3", "IDLE");
	setprop("/systems/thrust/state4", "IDLE");
	setprop("/systems/thrust/lvrclb", "0");
	setprop("/systems/thrust/clbreduc-ft", "2000");
	lvrclb();
	print("Thrust System ... Done!")
});

setlistener("/controls/engines/engine[0]/throttle", func {
	var thrr = getprop("/controls/engines/engine[0]/throttle");
	if (thrr < 0.05) {
		setprop("/systems/thrust/state1", "IDLE");
		atoff_request();
	} else if (thrr >= 0.05 and thrr < 0.60) {
		setprop("/systems/thrust/state1", "MAN");
	} else if (thrr >= 0.60 and thrr < 0.80) {
		setprop("/systems/thrust/state1", "CL");
	} else if (thrr >= 0.80 and thrr < 0.95) {
		setprop("/it-autoflight/at_mastersw", 1);
		setprop("/controls/engines/engine[0]/throttle-fdm", 0.94);
		setprop("/systems/thrust/state1", "MCT");
	} else if (thrr >= 0.95) {
		setprop("/it-autoflight/at_mastersw", 1);
		setprop("/controls/engines/engine[0]/throttle-fdm", 0.98);
		setprop("/systems/thrust/state1", "TOGA");
	}
});

setlistener("/controls/engines/engine[1]/throttle", func {
	var thrr = getprop("/controls/engines/engine[1]/throttle");
	if (thrr < 0.05) {
		setprop("/systems/thrust/state2", "IDLE");
		atoff_request();
	} else if (thrr >= 0.05 and thrr < 0.60) {
		setprop("/systems/thrust/state2", "MAN");
	} else if (thrr >= 0.60 and thrr < 0.80) {
		setprop("/systems/thrust/state2", "CL");
	} else if (thrr >= 0.80 and thrr < 0.95) {
		setprop("/it-autoflight/at_mastersw", 1);
		setprop("/controls/engines/engine[1]/throttle-fdm", 0.94);
		setprop("/systems/thrust/state2", "MCT");
	} else if (thrr >= 0.95) {
		setprop("/it-autoflight/at_mastersw", 1);
		setprop("/controls/engines/engine[1]/throttle-fdm", 0.98);
		setprop("/systems/thrust/state2", "TOGA");
	}
});

setlistener("/controls/engines/engine[2]/throttle", func {
	var thrr = getprop("/controls/engines/engine[2]/throttle");
	if (thrr < 0.05) {
		setprop("/systems/thrust/state3", "IDLE");
		atoff_request();
	} else if (thrr >= 0.05 and thrr < 0.60) {
		setprop("/systems/thrust/state3", "MAN");
	} else if (thrr >= 0.60 and thrr < 0.80) {
		setprop("/systems/thrust/state3", "CL");
	} else if (thrr >= 0.80 and thrr < 0.95) {
		setprop("/it-autoflight/at_mastersw", 1);
		setprop("/controls/engines/engine[2]/throttle-fdm", 0.94);
		setprop("/systems/thrust/state3", "MCT");
	} else if (thrr >= 0.95) {
		setprop("/it-autoflight/at_mastersw", 1);
		setprop("/controls/engines/engine[2]/throttle-fdm", 0.98);
		setprop("/systems/thrust/state3", "TOGA");
	}
});

setlistener("/controls/engines/engine[3]/throttle", func {
	var thrr = getprop("/controls/engines/engine[3]/throttle");
	if (thrr < 0.05) {
		setprop("/systems/thrust/state4", "IDLE");
		atoff_request();
	} else if (thrr >= 0.05 and thrr < 0.60) {
		setprop("/systems/thrust/state4", "MAN");
	} else if (thrr >= 0.60 and thrr < 0.80) {
		setprop("/systems/thrust/state4", "CL");
	} else if (thrr >= 0.80 and thrr < 0.95) {
		setprop("/it-autoflight/at_mastersw", 1);
		setprop("/controls/engines/engine[3]/throttle-fdm", 0.94);
		setprop("/systems/thrust/state4", "MCT");
	} else if (thrr >= 0.95) {
		setprop("/it-autoflight/at_mastersw", 1);
		setprop("/controls/engines/engine[3]/throttle-fdm", 0.98);
		setprop("/systems/thrust/state4", "TOGA");
	}
});

# Checks if all throttles are in the IDLE position, before tuning off the A/THR.
var atoff_request = func {
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	var state3 = getprop("/systems/thrust/state3");
	var state4 = getprop("/systems/thrust/state4");
	if ((state1 == "IDLE") and (state2 == "IDLE") and (state3 == "IDLE") and (state4 == "IDLE")) {
		setprop("/it-autoflight/at_mastersw", 0);
		setprop("/systems/thrust/at1", 0);
		setprop("/systems/thrust/at2", 0);
		setprop("/systems/thrust/at3", 0);
		setprop("/systems/thrust/at4", 0);
	}
}

var lvrclb = func {
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	var state3 = getprop("/systems/thrust/state3");
	var state4 = getprop("/systems/thrust/state4");
	if ((state1 == "CL") and (state2 == "CL") and (state3 == "CL") and (state4 == "CL")) {
		setprop("/systems/thrust/lvrclb", "0");
	} else {
		var status = getprop("/systems/thrust/lvrclb");
		if (status == 0) {
			if (getprop("/instrumentation/altimeter/indicated-altitude-ft") >= getprop("/systems/thrust/clbreduc-ft")) {
				setprop("/systems/thrust/lvrclb", "1");
			} else {
				setprop("/systems/thrust/lvrclb", "0");
			}
		} else if (status == 1) {
			setprop("/systems/thrust/lvrclb", "0");
		}
	}
    settimer(lvrclb, 0.5);
}