# A3XX IAE FADEC by Joshua Davidson (it0uchpods)

setlistener("/sim/signals/fdm-initialized", func {
	setprop("/controls/fadec/n1mode1", 0);
	setprop("/controls/fadec/n1mode2", 0);
	setprop("/systems/fadec/n1mode1", 0); # 0 == EPR, 1 == N1 Rated, 2 == N1 Unrated #
	setprop("/systems/fadec/n1mode2", 0); # 0 == EPR, 1 == N1 Rated, 2 == N1 Unrated #
	setprop("/systems/fadec/eng1/epr", 1);
	setprop("/systems/fadec/eng1/egt", 1);
	setprop("/systems/fadec/eng1/n1", 1);
	setprop("/systems/fadec/eng1/n2", 1);
	setprop("/systems/fadec/eng1/ff", 1);
	setprop("/systems/fadec/eng2/epr", 1);
	setprop("/systems/fadec/eng2/egt", 1);
	setprop("/systems/fadec/eng2/n1", 1);
	setprop("/systems/fadec/eng2/n2", 1);
	setprop("/systems/fadec/eng2/ff", 1);
	setprop("/systems/fadec/power-avail", 0);
	setprop("/systems/fadec/powered1", 0);
	setprop("/systems/fadec/powered2", 0);
	fadecLoop.start();
});

var fadecLoop = maketimer(0.7, func {
	var ac1 = getprop("/systems/electrical/bus/ac1");
	var ac2 = getprop("/systems/electrical/bus/ac1");
	var acess = getprop("/systems/electrical/bus/ac-ess");
	var state1 = getprop("/engines/engine[0]/state");
	var state2 = getprop("/engines/engine[1]/state");
	var master1 = getprop("/controls/engines/engine[0]/cutoff-switch");
	var master2 = getprop("/controls/engines/engine[1]/cutoff-switch");
	var modeSel = getprop("/controls/engines/engine-start-switch");
	var N1Mode1_sw = getprop("/controls/fadec/n1mode1");
	var N1Mode2_sw = getprop("/controls/fadec/n1mode2");
	
	if (ac1 >= 110 or ac2 >= 110 or acess >= 110) {
		setprop("/systems/fadec/power-avail", 1);
	} else {
		setprop("/systems/fadec/power-avail", 0);
	}
	
	var powerAvail = getprop("/systems/fadec/power-avail");
	
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
	var N1Mode1 = getprop("/systems/fadec/n1mode1");
	var N1Mode2 = getprop("/systems/fadec/n1mode2");
	var N11 = getprop("/engines/engine[0]/n1");
	var N12 = getprop("/engines/engine[1]/n1");
	var N21 = getprop("/engines/engine[0]/n2");
	var N22 = getprop("/engines/engine[1]/n2");
	
	if (powered1 and N1Mode1 == 0) {
		setprop("/systems/fadec/eng1/epr", 1);
	} else {
		setprop("/systems/fadec/eng1/epr", 0);
	}
	
	if (powered2 and N1Mode2 == 0) {
		setprop("/systems/fadec/eng2/epr", 1);
	} else {
		setprop("/systems/fadec/eng2/epr", 0);
	}
	
	if (powered1) {
		setprop("/systems/fadec/eng1/egt", 1);
		setprop("/systems/fadec/eng1/ff", 1);
	} else {
		setprop("/systems/fadec/eng1/egt", 0);
		setprop("/systems/fadec/eng1/ff", 0);
	}
	
	if (powered2) {
		setprop("/systems/fadec/eng2/egt", 1);
		setprop("/systems/fadec/eng2/ff", 1);
	} else {
		setprop("/systems/fadec/eng2/egt", 0);
		setprop("/systems/fadec/eng2/ff", 0);
	}
	
	if (powered1 and N11 >= 3.5) {
		setprop("/systems/fadec/eng1/n1", 1);
	} else {
		setprop("/systems/fadec/eng1/n1", 0);
	}
	
	if (powered2 and N12 >= 3.5) {
		setprop("/systems/fadec/eng2/n1", 1);
	} else {
		setprop("/systems/fadec/eng2/n1", 0);
	}
	
	if (powered1 and N21 >= 3.5) {
		setprop("/systems/fadec/eng1/n2", 1);
	} else {
		setprop("/systems/fadec/eng1/n2", 0);
	}
	
	if (powered2 and N22 >= 3.5) {
		setprop("/systems/fadec/eng2/n2", 1);
	} else {
		setprop("/systems/fadec/eng2/n2", 0);
	}
	
	if (N1Mode1_sw == 1) {
		setprop("/systems/fadec/n1mode1", 1);
	} else {
		setprop("/systems/fadec/n1mode1", 0);
	}
	
	if (N1Mode2_sw == 1) {
		setprop("/systems/fadec/n1mode2", 1);
	} else {
		setprop("/systems/fadec/n1mode2", 0);
	}
});
