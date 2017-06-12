# A3XX Fuel System
# Joshua Davidson (it0uchpods)

#############
# Init Vars #
#############

var fuel_init = func {
	setprop("/systems/fuel/gravityfeedL", 0);
	setprop("/systems/fuel/gravityfeedR", 0);
	setprop("/systems/fuel/gravityfeedL-output", 0);
	setprop("/systems/fuel/gravityfeedR-output", 0);
	setprop("/controls/fuel/x-feed", 0);
	setprop("/controls/fuel/tank2pump1", 0);
	setprop("/controls/fuel/tank2pump2", 0);
	setprop("/controls/fuel/tank3pump1", 0);
	setprop("/controls/fuel/tank3pump2", 0);
	setprop("/controls/fuel/tank4pump1", 0);
	setprop("/controls/fuel/tank4pump2", 0);
	setprop("/controls/fuel/mode", 1);
	setprop("/systems/fuel/x-feed", 0);
	setprop("/systems/fuel/tank[2]/feed0", 0);
	setprop("/systems/fuel/tank[2]/feed1", 0);
	setprop("/systems/fuel/tank[3]/feed0", 0);
	setprop("/systems/fuel/tank[3]/feed1", 0);
	setprop("/systems/fuel/tank[4]/feed0", 0);
	setprop("/systems/fuel/tank[4]/feed1", 0);
	setprop("/systems/fuel/only-use-ctr-tank", 0);
	fuel_timer.start();
}

##############
# Main Loops #
##############
var master_fuel = func {
	var xfeed_sw = getprop("/controls/fuel/x-feed");
	var tank2pump1_sw = getprop("/controls/fuel/tank2pump1");
	var tank2pump2_sw = getprop("/controls/fuel/tank2pump2");
	var tank3pump1_sw = getprop("/controls/fuel/tank3pump1");
	var tank3pump2_sw = getprop("/controls/fuel/tank3pump2");
	var tank4pump1_sw = getprop("/controls/fuel/tank4pump1");
	var tank4pump2_sw = getprop("/controls/fuel/tank4pump2");
	var mode_sw = getprop("/controls/fuel/mode");
	var xfeed = getprop("/systems/fuel/x-feed");
	var ac1 = getprop("/systems/electrical/bus/ac1");
	var ac2 = getprop("/systems/electrical/bus/ac2");
	var gravityfeedL = getprop("/systems/fuel/gravityfeedL");
	var gravityfeedR = getprop("/systems/fuel/gravityfeedR");
	var gload = getprop("/accelerations/pilot-gdamped");
	
	if (gload >= 0.7 and gravityfeedL) {
		setprop("/systems/fuel/gravityfeedL-output", 1);
	} else {
		setprop("/systems/fuel/gravityfeedL-output", 0);
	}
	
	if (gload >= 0.7 and gravityfeedR) {
		setprop("/systems/fuel/gravityfeedR-output", 1);
	} else {
		setprop("/systems/fuel/gravityfeedR-output", 0);
	}
	
	var gravityfeedL_output = getprop("/systems/fuel/gravityfeedL-output");
	var gravityfeedR_output = getprop("/systems/fuel/gravityfeedR-output");
	
	if ((ac1 >= 110 or ac2 >= 110) and tank2pump1_sw) {
		setprop("/systems/fuel/tank[2]/feed0", 1);
	} else if (gravityfeedL_output) {
		setprop("/systems/fuel/tank[2]/feed0", 1);
	} else {
		setprop("/systems/fuel/tank[2]/feed0", 0);
	}
	
	if ((ac1 >= 110 or ac2 >= 110) and tank2pump2_sw) {
		setprop("/systems/fuel/tank[2]/feed1", 1);
	} else if (gravityfeedL_output) {
		setprop("/systems/fuel/tank[2]/feed1", 1);
	} else {
		setprop("/systems/fuel/tank[2]/feed1", 0);
	}
	
	if ((ac1 >= 110 or ac2 >= 110) and tank3pump1_sw) {
		setprop("/systems/fuel/tank[3]/feed0", 1);
	} else {
		setprop("/systems/fuel/tank[3]/feed0", 0);
	}
	
	if ((ac1 >= 110 or ac2 >= 110) and tank3pump2_sw) {
		setprop("/systems/fuel/tank[3]/feed1", 1);
	} else {
		setprop("/systems/fuel/tank[3]/feed1", 0);
	}
	
	if ((ac1 >= 110 or ac2 >= 110) and tank4pump1_sw) {
		setprop("/systems/fuel/tank[4]/feed0", 1);
	} else if (gravityfeedR_output) {
		setprop("/systems/fuel/tank[2]/feed0", 1);
	} else {
		setprop("/systems/fuel/tank[4]/feed0", 0);
	}
	
	if ((ac1 >= 110 or ac2 >= 110) and tank4pump2_sw) {
		setprop("/systems/fuel/tank[4]/feed1", 1);
	} else if (gravityfeedR_output) {
		setprop("/systems/fuel/tank[2]/feed1", 1);
	} else {
		setprop("/systems/fuel/tank[4]/feed1", 0);
	}
	
	if ((ac1 >= 110 or ac2 >= 110) and xfeed_sw) {
		setprop("/systems/fuel/x-feed", 1);
	} else {
		setprop("/systems/fuel/x-feed", 0);
	}
	
	var tank2feed0 = getprop("/systems/fuel/tank[2]/feed0");
	var tank2feed1 = getprop("/systems/fuel/tank[2]/feed1");
	var tank3feed0 = getprop("/systems/fuel/tank[3]/feed0");
	var tank3feed1 = getprop("/systems/fuel/tank[3]/feed1");
	var tank4feed0 = getprop("/systems/fuel/tank[4]/feed0");
	var tank4feed1 = getprop("/systems/fuel/tank[4]/feed1");
	
	if (((ac1 >= 110 or ac2 >= 110) and tank2pump1_sw and tank2pump1_sw)) {
		setprop("/systems/fuel/gravityfeedL", 0);
	} else {
		setprop("/systems/fuel/gravityfeedL", 1);
	}
	
	if (((ac1 >= 110 or ac2 >= 110) and tank4pump1_sw and tank4pump1_sw)) {
		setprop("/systems/fuel/gravityfeedR", 0);
	} else {
		setprop("/systems/fuel/gravityfeedR", 1);
	}
	
	var gravityfeedL = getprop("/systems/fuel/gravityfeedL");
	var gravityfeedR = getprop("/systems/fuel/gravityfeedR");
	
	if ((getprop("/fdm/jsbsim/propulsion/tank[3]/contents-lbs") >= 50) and tank3feed0 and tank3feed1 and !gravityfeedL and !gravityfeedR) {
		setprop("/systems/fuel/only-use-ctr-tank", 1);
	} else {
		setprop("/systems/fuel/only-use-ctr-tank", 0);
	}
}

###################
# Update Function #
###################

var update_fuel = func {
	master_fuel();
}

var fuel_timer = maketimer(0.2, update_fuel);

