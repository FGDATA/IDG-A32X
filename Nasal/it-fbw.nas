# Airbus A3XX FBW/Flight Control Computer System
# Joshua Davidson (it0uchpods)

# 2 ELevator and Aileron Computers (ELAC)
# Aileron Control
# Normal Elevator / Stab Trim Control
# 3 Spoiler Elevator Computers (SEC)
# Spoiler Control
# Standby Elevator / Stab Trim Control
# 2 Flight Agumentation Computers (FAC)
# Electric Rudder Control
# 2 Flight Control Data Concentrators (FCDC)
# Aquire data from ELAC and SEC and send it to the EIS and Centralized Fault Display System

# If All ELACs Fail, Alternate Law

var fctlInit = func {
	setprop("/controls/fctl/elac1", 1);
	setprop("/controls/fctl/elac2", 1);
	setprop("/controls/fctl/sec1", 1);
	setprop("/controls/fctl/sec2", 1);
	setprop("/controls/fctl/sec3", 1);
	setprop("/controls/fctl/fac1", 1);
	setprop("/controls/fctl/fac2", 1);
	setprop("/systems/fctl/elac1", 0);
	setprop("/systems/fctl/elac2", 0);
	setprop("/systems/fctl/sec1", 0);
	setprop("/systems/fctl/sec2", 0);
	setprop("/systems/fctl/fac1", 0);
	setprop("/systems/fctl/fac2", 0);
}

###################
# Update Function #
###################

var update_loop = func {

	var elac1_sw = getprop("/controls/fctl/elac1");
	var elac2_sw = getprop("/controls/fctl/elac2");
	var sec1_sw = getprop("/controls/fctl/sec1");
	var sec2_sw = getprop("/controls/fctl/sec2");
	var sec3_sw = getprop("/controls/fctl/sec3");
	var fac1_sw = getprop("/controls/fctl/fac1");
	var fac2_sw = getprop("/controls/fctl/fac2");
	
	var elac1_fail = getprop("/systems/failures/elac1");
	var elac2_fail = getprop("/systems/failures/elac2");
	var sec1_fail = getprop("/systems/failures/sec1");
	var sec2_fail = getprop("/systems/failures/sec2");
	var sec3_fail = getprop("/systems/failures/sec3");
	var fac1_fail = getprop("/systems/failures/fac1");
	var fac2_fail = getprop("/systems/failures/fac2");
	
	if (elac1_sw and !elac1_fail) {
		setprop("/systems/fctl/elac1", 1);
	} else {
		setprop("/systems/fctl/elac1", 0);
	}
	
	if (elac2_sw and !elac2_fail) {
		setprop("/systems/fctl/elac2", 1);
	} else {
		setprop("/systems/fctl/elac2", 0);
	}
	
	if (sec1_sw and !sec1_fail) {
		setprop("/systems/fctl/sec1", 1);
	} else {
		setprop("/systems/fctl/sec1", 0);
	}
	
	if (sec2_sw and !sec2_fail) {
		setprop("/systems/fctl/sec2", 1);
	} else {
		setprop("/systems/fctl/sec2", 0);
	}
	
	if (sec3_sw and !sec3_fail) {
		setprop("/systems/fctl/sec3", 1);
	} else {
		setprop("/systems/fctl/sec3", 0);
	}
	
	if (fac1_sw and !fac1_fail) {
		setprop("/systems/fctl/fac1", 1);
	} else {
		setprop("/systems/fctl/fac1", 0);
	}
	
	if (fac2_sw and !fac2_fail) {
		setprop("/systems/fctl/fac2", 1);
	} else {
		setprop("/systems/fctl/fac2", 0);
	}

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
		} else if (getprop("/controls/flight/flap-lever") == 4) {
			setprop("/it-fbw/pitch-lim-max", "25");
			setprop("/it-fbw/pitch-lim-min", "-15");
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
var updatet = maketimer(0.05, update_loop);
