# Airbus A3XX FBW System by Joshua Davidson (it0uchpods/411)
# V0.9.2

########################
# Roll Update Function #
########################

var roll_input = func {

	var ail = getprop("/controls/flight/aileron");
			
	if (getprop("/it-autoflight/output/ap1") == 0 and getprop("/it-autoflight/output/ap2") == 0 and ((getprop("/it-fbw/law") == "NORMAL") or (getprop("/it-fbw/law") == "ALTERNATE"))) {
		
		if (ail >= 0.05 and ail < 0.15) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw + "0.01");
		} else if (ail >= 0.15 and ail < 0.3) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw + "0.05");
		} else if (ail >= 0.3 and ail < 0.5) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw + "0.1");
		} else if (ail >= 0.5 and ail < 0.7) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw + "0.2");
		} else if (ail >= 0.7 and ail <= 1) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw + "0.3");
		}
	
		if (ail <= -0.05 and ail > -0.15) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw - "0.01");
		} else if (ail <= -0.15 and ail > -0.3) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw - "0.05");
		} else if (ail <= -0.3 and ail > -0.5) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw - "0.01");
		} else if (ail <= -0.5 and ail > -0.7) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw - "0.2");
		} else if (ail <= -0.7 and ail >= -1) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw - "0.3");
		}
	}
	
	if (getprop("/it-fbw/roll-deg") >= 33) {
		if (getprop("/it-fbw/law") == "NORMAL") {
			if (ail > 0.4) {
				if (getprop("/it-fbw/roll-deg") >= 67) {
			setprop("/it-fbw/roll-deg", "67");
				}
			} else {
				setprop("/it-fbw/roll-deg", "33");
			}
		}
	}
	
	if (getprop("/it-fbw/roll-deg") <= -33) {
		if (getprop("/it-fbw/law") == "NORMAL") {
			if (ail < -0.4) {
				if (getprop("/it-fbw/roll-deg") <= -67) {
			setprop("/it-fbw/roll-deg", "-67");
				}
			} else {
				setprop("/it-fbw/roll-deg", "-33");
			}
		}
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

	if (getprop("/it-autoflight/output/ap1") == 0 and getprop("/it-autoflight/output/ap2") == 0 and ((getprop("/it-fbw/law") == "NORMAL") or (getprop("/it-fbw/law") == "ALTERNATE"))) {
		
		if (elev >= 0.05 and elev < 0.15) {
			var pfbw = getprop("/it-fbw/pitch-deg");
			setprop("/it-fbw/pitch-deg", pfbw - "0.005");
		} else if (elev >= 0.15 and elev < 0.3) {
			var pfbw = getprop("/it-fbw/pitch-deg");
			setprop("/it-fbw/pitch-deg", pfbw - "0.01");
		} else if (elev >= 0.3 and elev < 0.5) {
			var pfbw = getprop("/it-fbw/pitch-deg");
			setprop("/it-fbw/pitch-deg", pfbw - "0.05");
		} else if (elev >= 0.5 and elev < 0.7) {
			var pfbw = getprop("/it-fbw/pitch-deg");
			setprop("/it-fbw/pitch-deg", pfbw - "0.1");
		} else if (elev >= 0.7 and elev <= 1) {
			var pfbw = getprop("/it-fbw/pitch-deg");
			setprop("/it-fbw/pitch-deg", pfbw - "0.2");
		}
	
		if (elev <= -0.05 and elev > -0.15) {
			var pfbw = getprop("/it-fbw/pitch-deg");
			setprop("/it-fbw/pitch-deg", pfbw + "0.005");
		} else if (elev <= -0.15 and elev > -0.3) {
			var pfbw = getprop("/it-fbw/pitch-deg");
			setprop("/it-fbw/pitch-deg", pfbw + "0.01");
		} else if (elev <= -0.3 and elev > -0.5) {
			var pfbw = getprop("/it-fbw/pitch-deg");
			setprop("/it-fbw/pitch-deg", pfbw + "0.05");
		} else if (elev <= -0.5 and elev > -0.7) {
			var pfbw = getprop("/it-fbw/pitch-deg");
			setprop("/it-fbw/pitch-deg", pfbw + "0.1");
		} else if (elev <= -0.7 and elev >= -1) {
			var pfbw = getprop("/it-fbw/pitch-deg");
			setprop("/it-fbw/pitch-deg", pfbw + "0.2");
		}
		
		if ((getprop("/controls/flight/flap-lever") >= 3) and (getprop("/controls/engines/engine[0]/throttle") < 0.65) and (getprop("/controls/engines/engine[1]/throttle") < 0.65) and (getprop("/position/gear-agl-ft") <= 50)) {
			if (elev > -0.05 and elev < 0.05) {
				var pfbw = getprop("/it-fbw/pitch-deg");
				setprop("/it-fbw/pitch-deg", pfbw - "0.003");
			}
			var gear1 = setlistener("/gear/gear[1]/wow", func {
				if (getprop("/gear/gear[1]/wow") == 1 and getprop("/gear/gear[2]/wow") == 1) {
					removelistener(gear1);
					setprop("/controls/flight/elevator-trim", -0.1);
				}
			});
			var gear2 = setlistener("/gear/gear[2]/wow", func {
				if (getprop("/gear/gear[1]/wow") == 1 and getprop("/gear/gear[2]/wow") == 1) {
					removelistener(gear2);
					setprop("/controls/flight/elevator-trim", -0.1);
				}
			});
		}
	}
	
	if (getprop("/it-fbw/pitch-deg") >= 15) {
		if (getprop("/position/gear-agl-ft") <= 30) {
			setprop("/it-fbw/pitch-deg", "15");
		}
		if (getprop("/it-fbw/pitch-deg") >= 30) {
			if (getprop("/it-fbw/law") == "NORMAL") {
				setprop("/it-fbw/pitch-deg", "30");
			}
		}
	}
	
	if (getprop("/it-fbw/pitch-deg") <= -15) {
		if (getprop("/it-fbw/law") == "NORMAL") {
			setprop("/it-fbw/pitch-deg", "-15");
		}
	}
	
	if (getprop("/gear/gear[0]/wow") == 1) {
		if (elev > -0.1 and elev < 0.1) {
			setprop("/it-fbw/pitch-deg", getprop("/orientation/pitch-deg"));
		}
	}
}

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
	if (getprop("/it-fbw/law") == "NORMAL") {
		setprop("/it-fbw/roll-deg", getprop("/orientation/roll-deg"));
		setprop("/it-fbw/pitch-deg", getprop("/orientation/pitch-deg"));
	} else if (getprop("/it-fbw/law") == "ALTERNATE") {
		setprop("/it-fbw/roll-deg", getprop("/orientation/roll-deg"));
		setprop("/it-fbw/pitch-deg", getprop("/orientation/pitch-deg"));
	}
});

setlistener("/sim/signals/fdm-initialized", func {
	setprop("/it-fbw/law", "DIRECT");
	update_roll.start();
	update_pitch.start();
	print("AIRBUS FBW ... OK!");
});

setlistener("/systems/electrical/bus/ac-ess", func {
	if (getprop("/systems/electrical/bus/ac-ess") >= 110) {
		if (getprop("/it-fbw/law") != "NORMAL") {
			setprop("/it-fbw/law", "NORMAL");
		}
	} else {
		if (getprop("/it-fbw/law") != "DIRECT") {
			setprop("/it-fbw/law", "DIRECT");
		}
	}
});

##########
# Timers #
##########
var update_roll = maketimer(0.01, roll_input);
var update_pitch = maketimer(0.01, pitch_input);
