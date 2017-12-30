# A3XX CFM FADEC by Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

setprop("/systems/fadec/n1mode1", 0); # Doesn't do anything, just here for other logic #
setprop("/systems/fadec/n1mode2", 0); # Doesn't do anything, just here for other logic #
setprop("/systems/fadec/eng1/egt", 1);
setprop("/systems/fadec/eng1/n1", 1);
setprop("/systems/fadec/eng1/n2", 1);
setprop("/systems/fadec/eng1/ff", 1);
setprop("/systems/fadec/eng2/egt", 1);
setprop("/systems/fadec/eng2/n1", 1);
setprop("/systems/fadec/eng2/n2", 1);
setprop("/systems/fadec/eng2/ff", 1);
setprop("/systems/fadec/power-avail", 0);
setprop("/systems/fadec/powered1", 0);
setprop("/systems/fadec/powered2", 0);
setprop("/systems/fadec/powered-time", 0);
setprop("/systems/fadec/powerup", 0);

var fadecLoop = func {
	var ac1 = getprop("/systems/electrical/bus/ac1");
	var ac2 = getprop("/systems/electrical/bus/ac2");
	var acess = getprop("/systems/electrical/bus/ac-ess");
	var state1 = getprop("/engines/engine[0]/state");
	var state2 = getprop("/engines/engine[1]/state");
	var master1 = getprop("/controls/engines/engine[0]/cutoff-switch");
	var master2 = getprop("/controls/engines/engine[1]/cutoff-switch");
	var modeSel = getprop("/controls/engines/engine-start-switch");
	
	if (ac1 >= 110 or ac2 >= 110 or acess >= 110) {
		if (getprop("/systems/fadec/power-avail") != 1) {
			setprop("/systems/fadec/powered-time", getprop("/sim/time/elapsed-sec"));
			setprop("/systems/fadec/power-avail", 1);
		}
	} else {
		if (getprop("/systems/fadec/power-avail") != 0) {
			setprop("/systems/fadec/power-avail", 0);
		}
	}
	
	var powerAvail = getprop("/systems/fadec/power-avail");
	
	if (getprop("/systems/fadec/powered-time") + 300 >= getprop("/sim/time/elapsed-sec")) {
		setprop("/systems/fadec/powerup", 1);
	} else {
		setprop("/systems/fadec/powerup", 0);	
	}
	
	if (state1 == 3) {
		setprop("/systems/fadec/powered1", 1);
	} else if (powerAvail and modeSel == 2) {
		setprop("/systems/fadec/powered1", 1);
	} else {
		setprop("/systems/fadec/powered1", 0);
	}
	
	if (state2 == 3) {
		setprop("/systems/fadec/powered2", 1);
	} else if (powerAvail and modeSel == 2) {
		setprop("/systems/fadec/powered2", 1);
	} else {
		setprop("/systems/fadec/powered2", 0);
	}
	
	var powered1 = getprop("/systems/fadec/powered1");
	var powered2 = getprop("/systems/fadec/powered2");
	
	if (powered1 or getprop("/systems/fadec/powerup")) {
		setprop("/systems/fadec/eng1/n1", 1);
		setprop("/systems/fadec/eng1/egt", 1);
		setprop("/systems/fadec/eng1/n2", 1);
		setprop("/systems/fadec/eng1/ff", 1);
	} else {
		setprop("/systems/fadec/eng1/n1", 0);
		setprop("/systems/fadec/eng1/egt", 0);
		setprop("/systems/fadec/eng1/n2", 0);
		setprop("/systems/fadec/eng1/ff", 0);
	}
	
	if (powered2 or getprop("/systems/fadec/powerup")) {
		setprop("/systems/fadec/eng2/n1", 1);
		setprop("/systems/fadec/eng2/egt", 1);
		setprop("/systems/fadec/eng2/n2", 1);
		setprop("/systems/fadec/eng2/ff", 1);
	} else {
		setprop("/systems/fadec/eng2/n1", 0);
		setprop("/systems/fadec/eng2/egt", 0);
		setprop("/systems/fadec/eng2/n2", 0);
		setprop("/systems/fadec/eng2/ff", 0);
	}
}
