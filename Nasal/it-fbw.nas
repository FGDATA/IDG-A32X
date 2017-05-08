# Airbus A3XX FBW System by Joshua Davidson (it0uchpods)
# V0.9.7.1

###################
# Update Function #
###################

var update_loop = func {

	var ail = getprop("/controls/flight/aileron");
	
	if (getprop("/it-fbw/law") == 0) {
		if (ail > 0.4 or ail < -0.4) {
			setprop("/it-fbw/roll-lim-max", "67");
			setprop("/it-fbw/roll-lim-min", "-67");
		} else if (ail < 0.05 and ail > -0.05) {
			setprop("/it-fbw/roll-lim-max", "33");
			setprop("/it-fbw/roll-lim-min", "-33");
		} else {
			if (getprop("/it-fbw/roll-deg") > 33) {
				setprop("/it-fbw/roll-deg", "33");
			} else if (getprop("/it-fbw/roll-deg") < -33) {
				setprop("/it-fbw/roll-deg", "-33");
			}
		}
	} else if (getprop("/it-fbw/law") == 1) {
		setprop("/it-fbw/roll-lim-max", "160");
		setprop("/it-fbw/roll-lim-min", "-160");
	} else {
		setprop("/it-fbw/roll-lim-max", "33");
		setprop("/it-fbw/roll-lim-min", "-33");
	}

	var elev = getprop("/controls/flight/elevator");
	
	if (getprop("/it-fbw/law") == 0) {
		if (getprop("/position/gear-agl-ft") <= 2) {
			setprop("/it-fbw/pitch-lim-max", "15");
			setprop("/it-fbw/pitch-lim-min", "-5");
		} else {
			setprop("/it-fbw/pitch-lim-max", "30");
			setprop("/it-fbw/pitch-lim-min", "-15");
		}
	} else if (getprop("/it-fbw/law") == 1) {
		setprop("/it-fbw/pitch-lim-max", "160");
		setprop("/it-fbw/pitch-lim-min", "-160");
	} else {
		setprop("/it-fbw/pitch-lim-max", "15");
		setprop("/it-fbw/pitch-lim-min", "-15");
	}

	if (getprop("/it-fbw/override") == 0) {
		if ((getprop("/systems/electrical/bus/ac-ess") >= 110) and (getprop("/systems/hydraulic/green-psi") >= 1500) and (getprop("/systems/hydraulic/yellow-psi") >= 1500)) {
			if (getprop("/it-fbw/law") != 0) {
				setprop("/it-fbw/law", 0);
			}
		} else if ((getprop("/systems/electrical/bus/ac-ess") >= 110) and (getprop("/systems/hydraulic/blue-psi") >= 1500)) {
			if (getprop("/it-fbw/law") != 2) {
				setprop("/it-fbw/law", 2);
			}
		} else {
			if (getprop("/it-fbw/law") != 3) {
				setprop("/it-fbw/law", 3);
			}
		}
	}
	
	if (getprop("/it-fbw/law") == 1 and getprop("/controls/gear/gear-down") == 1 and getprop("/it-fbw/override") == 0) {
		setprop("/it-fbw/law", 2);
	}
}

###########################
# Various Other Functions #
###########################

setlistener("/sim/signals/fdm-initialized", func {
	setprop("/it-fbw/override", 0);
	setprop("/it-fbw/law", 3);
	updatet.start();
});

##########
# Timers #
##########
var updatet = maketimer(0.01, update_loop);
