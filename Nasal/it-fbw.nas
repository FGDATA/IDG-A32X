# Airbus A3XX FBW System by Joshua Davidson (it0uchpods)
# V0.9.6

########################
# Roll Update Function #
########################

var roll_input = func {

	var ail = getprop("/controls/flight/aileron");
	
	if (getprop("/it-fbw/law") == 0) {
		if (ail > 0.4 or ail < -0.4) {
			setprop("/it-fbw/roll-lim-max", "67");
			setprop("/it-fbw/roll-lim-min", "-67");
		} else {
			setprop("/it-fbw/roll-lim-max", "33");
			setprop("/it-fbw/roll-lim-min", "-33");
			if (getprop("/it-fbw/law") > 33) {
				setprop("/it-fbw/roll-deg", "33");
			} else if (getprop("/it-fbw/law") < -33) {
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
}

#########################
# Pitch Update Function #
#########################

var pitch_input = func {

	var elev = getprop("/controls/flight/elevator");
	
	if (getprop("/it-fbw/law") == 0) {
		if (getprop("/position/gear-agl-ft") <= 15) {
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
}

###########################
# Various Other Functions #
###########################

setlistener("/sim/signals/fdm-initialized", func {
	setprop("/it-fbw/override", 0);
	setprop("/it-fbw/law", 3);
	update_roll.start();
	update_pitch.start();
});

setlistener("/systems/electrical/bus/ac-ess", func {
	fbw_law();
});

var fbw_law = func {
	if (getprop("/it-fbw/override") == 0) {
		if (getprop("/systems/electrical/bus/ac-ess") >= 110) {
			if (getprop("/it-fbw/law") != 0) {
				setprop("/it-fbw/law", 0);
			}
		} else {
			if (getprop("/it-fbw/law") != 3) {
				setprop("/it-fbw/law", 3);
			}
		}
	}
}

##########
# Timers #
##########
var update_roll = maketimer(0.01, roll_input);
var update_pitch = maketimer(0.01, pitch_input);
