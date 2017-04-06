# A320 FBW System by Joshua Davidson (it0uchpods/411)
# V0.8

var roll_input = func {

	if (getprop("/it-autoflight/output/ap1") == 0 and getprop("/it-autoflight/output/ap2") == 0 and ((getprop("/it-fbw/law") == "NORMAL") or (getprop("/it-fbw/law") == "ALTERNATE"))) {
		var ail = getprop("/controls/flight/aileron");
		
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
			setprop("/it-fbw/roll-deg", rfbw - "0.1");
		} else if (ail <= -0.5 and ail > -0.7) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw - "0.2");
		} else if (ail <= -0.7 and ail >= -1) {
			var rfbw = getprop("/it-fbw/roll-deg");
			setprop("/it-fbw/roll-deg", rfbw - "0.3");
		}
	}
	
	if (getprop("/it-fbw/roll-deg") >= 30) {
		if (getprop("/it-fbw/law") == "NORMAL") {
			if (ail > 0.4) {
				if (getprop("/it-fbw/roll-deg") >= 65) {
			setprop("/it-fbw/roll-deg", "65");
				}
			} else {
				setprop("/it-fbw/roll-deg", "30");
			}
		}
	}
	
	if (getprop("/it-fbw/roll-deg") <= -30) {
		if (getprop("/it-fbw/law") == "NORMAL") {
			if (ail < -0.4) {
				if (getprop("/it-fbw/roll-deg") <= -65) {
			setprop("/it-fbw/roll-deg", "-65");
				}
			} else {
				setprop("/it-fbw/roll-deg", "-30");
			}
		}
	}
	
	if (getprop("/gear/gear[0]/wow") == 1) {
		setprop("/it-fbw/roll-deg", "0");
	}

    settimer(roll_input, 0.01);
}

var pitch_input = func {

	if (getprop("/it-autoflight/output/ap1") == 0 and getprop("/it-autoflight/output/ap2") == 0 and ((getprop("/it-fbw/law") == "NORMAL") or (getprop("/it-fbw/law") == "ALTERNATE"))) {
		var elev = getprop("/controls/flight/elevator");
		
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
			setprop("/it-fbw/pitch-deg", pfbw - "0.15");
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
			setprop("/it-fbw/pitch-deg", pfbw + "0.15");
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

    settimer(pitch_input, 0.01);
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
	setprop("/it-fbw/law", "DIRECT"); # Will be changed to NORMAL when electric system powers up, as soon as I get the FBW/FDM stable
	roll_input();
	pitch_input();
#	print("AIRBUS FBW ... OK!") # Don't advertise until it's working! ;)
});
