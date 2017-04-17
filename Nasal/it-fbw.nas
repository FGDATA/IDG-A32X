# Airbus A3XX FBW System by Joshua Davidson (it0uchpods/411)
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
	} else {
		setprop("/it-fbw/roll-lim-max", "160");
		setprop("/it-fbw/roll-lim-min", "-160");
	}
	
	if (getprop("/gear/gear[0]/wow") == 1) {
		setprop("/it-fbw/roll-deg", "0");
	}
}

#########################
# Pitch Update Function #
#########################

var pitch_input = func {

	var elev = getprop("/controls/flight/elevator");
	
	if (getprop("/it-fbw/law") == 0) {
		setprop("/it-fbw/pitch-lim-max", "30");
		setprop("/it-fbw/pitch-lim-min", "-15");
	} else {
		setprop("/it-fbw/pitch-lim-max", "160");
		setprop("/it-fbw/pitch-lim-min", "-160");
	}
	
	if (getprop("/gear/gear[0]/wow") == 1) {
		if (elev > -0.05 and elev < 0.05) {
			setprop("/it-fbw/pitch-deg", getprop("/orientation/pitch-deg"));
		}
	}
}

###########################
# Various Other Functions #
###########################

setlistener("/it-autoflight/output/ap1", func {
	if (getprop("/it-autoflight/output/ap1") == 0) {
		setprop("/it-fbw/roll-deg", getprop("/orientation/roll-deg"));
		setprop("/it-fbw/pitch-deg", getprop("/orientation/pitch-deg"));
	}
});

setlistener("/it-autoflight/output/ap2", func {
	if (getprop("/it-autoflight/output/ap2") == 0) {
		setprop("/it-fbw/roll-deg", getprop("/orientation/roll-deg"));
		setprop("/it-fbw/pitch-deg", getprop("/orientation/pitch-deg"));
	}
});

setlistener("/it-fbw/law", func {
	if (getprop("/it-fbw/law") == 0) {
		setprop("/it-fbw/roll-deg", getprop("/orientation/roll-deg"));
		setprop("/it-fbw/pitch-deg", getprop("/orientation/pitch-deg"));
	} else if (getprop("/it-fbw/law") == 1) {
		setprop("/it-fbw/roll-deg", getprop("/orientation/roll-deg"));
		setprop("/it-fbw/pitch-deg", getprop("/orientation/pitch-deg"));
	}
});

setlistener("/sim/signals/fdm-initialized", func {
	setprop("/it-fbw/law", 2);
	update_roll.start();
	update_pitch.start();
	print("AIRBUS FBW ... OK!");
});

setlistener("/systems/electrical/bus/ac-ess", func {
	if (getprop("/systems/electrical/bus/ac-ess") >= 110) {
		if (getprop("/it-fbw/law") != 0) {
			setprop("/it-fbw/law", 0);
		}
	} else {
		if (getprop("/it-fbw/law") != 2) {
			setprop("/it-fbw/law", 2);
		}
	}
});

##########
# Timers #
##########
var update_roll = maketimer(0.01, roll_input);
var update_pitch = maketimer(0.01, pitch_input);
