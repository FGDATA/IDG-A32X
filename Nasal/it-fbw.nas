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
	setprop("/systems/fctl/sec3", 0);
	setprop("/systems/fctl/fac1", 0);
	setprop("/systems/fctl/fac2", 0);
	setprop("/it-fbw/degrade-law", 0);
}

setprop("/it-fbw/roll-back", 0);
setprop("/it-fbw/spd-hold", 0);

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
	
	var elac1 = getprop("/systems/fctl/elac1");
	var elac2 = getprop("/systems/fctl/elac2");
	var sec1 = getprop("/systems/fctl/sec1");
	var sec2 = getprop("/systems/fctl/sec2");
	var sec3 = getprop("/systems/fctl/sec3");
	var fac1 = getprop("/systems/fctl/fac1");
	var fac2 = getprop("/systems/fctl/fac2");
	var law = getprop("/it-fbw/law");
	
	# Degrade logic, all failures which degrade FBW need to go here. -JD
	if (getprop("/gear/gear[1]/wow") == 0 and getprop("/gear/gear[2]/wow") == 0) {
		if (!elac1 and !elac2) {
			if (law == 0) {
				setprop("/it-fbw/degrade-law", 1);
			}
		} else if (getprop("/systems/electrical/bus/ac-ess") >= 110 and getprop("/systems/hydraulic/blue-psi") >= 1500 and getprop("/systems/hydraulic/green-psi") < 1500 and getprop("/systems/hydraulic/yellow-psi") < 1500) {
			if (law == 0 or law == 1) {
				setprop("/it-fbw/degrade-law", 2);
			}
		} else if (getprop("/controls/gear/gear-down") == 1) {
			if (law == 1) {
				setprop("/it-fbw/degrade-law", 2);
			}
		} else if (getprop("/systems/electrical/bus/ac-ess") < 110 or (getprop("/systems/hydraulic/blue-psi") < 1500 and getprop("/systems/hydraulic/green-psi") < 1500 and getprop("/systems/hydraulic/yellow-psi") < 1500)) {
			setprop("/it-fbw/degrade-law", 3);
		}
	}
	
	var law = getprop("/it-fbw/law");
	
	# Mech Backup can always return to direct, if it can.
	if (law == 3 and getprop("/systems/electrical/bus/ac-ess") >= 110 and getprop("/systems/hydraulic/blue-psi") >= 1500) {
		setprop("/it-fbw/degrade-law", 2);
	}
	
}
	
var fbw_loop = func {
	
	var ail = getprop("/controls/flight/aileron");
	
	if (ail > 0.4 or ail < -0.4) {
		setprop("/it-fbw/roll-lim", "67");
		if (getprop("/it-fbw/roll-back") == 1 and getprop("/orientation/roll-deg") <= 33.5 and getprop("/orientation/roll-deg") >= -33.5) {
			setprop("/it-fbw/roll-back", 0);
		}
		if (getprop("/it-fbw/roll-back") == 0 and (getprop("/orientation/roll-deg") > 33.5 or getprop("/orientation/roll-deg") < -33.5)) {
			setprop("/it-fbw/roll-back", 1);
		}
	} else if (ail < 0.05 and ail > -0.05) {
		setprop("/it-fbw/roll-lim", "33");
		if (getprop("/it-fbw/roll-back") == 1 and getprop("/orientation/roll-deg") <= 33.5 and getprop("/orientation/roll-deg") >= -33.5) {
			setprop("/it-fbw/roll-back", 0);
		}
	}

	if (getprop("/it-fbw/override") == 0) {
		var degrade = getprop("/it-fbw/degrade-law");
		if (degrade == 0) {
			if (getprop("/it-fbw/law") != 0) {
				setprop("/it-fbw/law", 0);
			}
		} else if (degrade == 1) {
			if (getprop("/it-fbw/law") != 1) {
				setprop("/it-fbw/law", 1);
			}
		} else if (degrade == 2) {
			if (getprop("/it-fbw/law") != 2) {
				setprop("/it-fbw/law", 2);
			}
		} else if (degrade == 3) {
			if (getprop("/it-fbw/law") != 3) {
				setprop("/it-fbw/law", 3);
			}
		}
	}
}

###########################
# Various Other Functions #
###########################

setlistener("/sim/signals/fdm-initialized", func {
	setprop("/it-fbw/override", 0);
	setprop("/it-fbw/law", 0);
	updatet.start();
	fbwt.start();
});

##########
# Timers #
##########
var updatet = maketimer(0.1, update_loop);
var fbwt = maketimer(0.05, fbw_loop);
