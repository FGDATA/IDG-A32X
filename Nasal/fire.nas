# A3XX Fire System
# Jonathan Redpath

#############
# Init Vars #
#############

var fire_init = func {
	setprop("/systems/fire/cargo/fwddet", 0);
	setprop("/systems/fire/cargo/aftdet", 0);
	setprop("/systems/fire/cargo/fwdsquib", 0);
	setprop("/systems/fire/cargo/aftsquib", 0);
	setprop("/systems/fire/cargo/bottlelevel", 100);
	setprop("/systems/fire/cargo/test", 0);
	setprop("/controls/fire/cargo/test", 0);
	setprop("/controls/fire/cargo/fwdguard", 1);
	setprop("/controls/fire/cargo/aftguard", 1);
	setprop("/controls/fire/cargo/fwddisch", 0); # pushbutton
	setprop("/controls/fire/cargo/aftdisch", 0);
	setprop("/controls/fire/cargo/fwddischLight", 0);
	setprop("/controls/fire/cargo/aftdischLight", 0);
	setprop("/controls/fire/cargo/fwdsmokeLight", 0);
	setprop("/controls/fire/cargo/aftsmokeLight", 0);
	setprop("/controls/fire/cargo/bottleempty", 0);
	# status: 1 is ready, 0 is already disch
	setprop("/controls/fire/cargo/status", 1);
	setprop("/controls/fire/cargo/warnfwd", 0);
	setprop("/controls/fire/cargo/warnaft", 0);
	setprop("/controls/fire/cargo/squib1fault", 0);
	setprop("/controls/fire/cargo/squib2fault", 0);
	setprop("/controls/fire/cargo/detfault", 0);
	setprop("/controls/fire/cargo/test/state", 0);
	fire_timer.start();
}

##############
# Main Loops #
##############
var master_fire = func {
	var level = getprop("/systems/fire/cargo/bottlelevel");
	var fwdsquib = getprop("/systems/fire/cargo/fwdsquib");
	var aftsquib = getprop("/systems/fire/cargo/aftsquib");
	var fwddet = getprop("/systems/fire/cargo/fwddet");
	var aftdet = getprop("/systems/fire/cargo/aftdet");
	var test = getprop("/controls/fire/cargo/test");
	var guard1 = getprop("/controls/fire/cargo/fwdguard");
	var guard2 = getprop("/controls/fire/cargo/aftguard");
	var dischpb1 = getprop("/controls/fire/cargo/fwddisch"); 
	var dischpb2 = getprop("/controls/fire/cargo/aftdisch");
	var smokedet1 = getprop("/controls/fire/cargo/fwdsmokeLight");
	var smokedet2 = getprop("/controls/fire/cargo/aftsmokeLight");
	var bottleIsEmpty = getprop("/controls/fire/cargo/bottleempty");
	var WeCanExt = getprop("/controls/fire/cargo/status");
	var test2 = getprop("/systems/fire/cargo/test");
	var state = getprop("/controls/fire/cargo/test/state");
	var dc1 = getprop("/systems/electrical/bus/dc1");
	var dc2 = getprop("/systems/electrical/bus/dc2");
	var dcbat = getprop("/systems/electrical/bus/dcbat");
	var pause = getprop("/sim/freeze/master");
	
	###################
	# Detection Logic #
	###################
	
	if (fwddet) {
		setprop("/controls/fire/cargo/fwdsmokeLight", 1);
		setprop("/controls/fire/cargo/warnfwd", 1);
	} else {
		setprop("/controls/fire/cargo/fwdsmokeLight", 0);
	}
	
	if (aftdet) {
		setprop("/controls/fire/cargo/aftsmokeLight", 1);
		setprop("/controls/fire/cargo/warnaft", 1);
	} else {
		setprop("/controls/fire/cargo/aftsmokeLight", 0);
	}
	
	###############
	# Discharging #
	###############
	
	if (dischpb1) {
		if (WeCanExt == 1 and !fwdsquib and !bottleIsEmpty and (dc1 > 0 or dc2 > 0 or dcbat > 0)) {
			setprop("/systems/fire/cargo/fwdsquib", 1);
		}
	}
	
	if (dischpb1 and fwdsqib and !bottleIsEmpty and !puase) {
		var bottle = getprop("/systems/fire/cargo/bottlelevel");
		setprop("/systems/fire/cargo/bottlelevel", bottle - 0.166);
	}
	
	if (dischpb2) {
		if (WeCanExt == 1 and !aftsquib and !bottleIsEmpty and (dc1 > 0 or dc2 > 0 or dcbat > 0)) {
			setprop("/systems/fire/cargo/aftsquib", 1);
		}
	}
	
	if (dischpb1 and fwdsqib and !bottleIsEmpty and !puase) {
		var bottle = getprop("/systems/fire/cargo/bottlelevel");
		setprop("/systems/fire/cargo/bottlelevel", bottle - 0.166);
	}
	
	#################
	# Test Sequence #
	#################
	
	setlistener("/controls/fire/cargo/test", func {
		var test = getprop("/controls/fire/cargo/test");
		if (test) {
			setprop("/systems/fire/cargo/test", 1);
		}
	});
	
	if (test2 and state == 0) {
			setprop("/controls/fire/cargo/fwdsmokeLight", 1);
			setprop("/controls/fire/cargo/warnfwd", 1);
			settimer(func(){
				setprop("/controls/fire/cargo/fwdsmokeLight", 0);
				setprop("/controls/fire/cargo/warnfwd", 0);
				setprop("/controls/fire/cargo/test/state", 1);
			}, 0.5);
	} else if (test2 and state == 1) {
		setprop("/controls/fire/cargo/aftsmokeLight", 1);
		setprop("/controls/fire/cargo/warnaft", 1);
		settimer(func(){
			setprop("/controls/fire/cargo/aftsmokeLight", 0);
			setprop("/controls/fire/cargo/warnaft", 0);
			setprop("/controls/fire/cargo/test/state", 2);
		}, 0.5);
	} else if (test2 and state == 2) {
		setprop("/controls/fire/cargo/fwddischLight", 1);
		setprop("/controls/fire/cargo/aftdischLight", 1);
		settimer(func(){
			setprop("/controls/fire/cargo/fwddischLight", 0);
			setprop("/controls/fire/cargo/aftdischLight", 0);
			setprop("/systems/fire/cargo/test", 0);
			setprop("/controls/fire/cargo/test", 0);
			setprop("/controls/fire/cargo/test/state", 0);
		}, 0.5);
	}
	
	
	##########
	# Status #
	##########
	
	if (level < 0.1) {
		setprop("/controls/fire/cargo/bottleempty", 1);
		setprop("/controls/fire/cargo/status", 0);
		setprop("/controls/fire/cargo/fwddischLight", 1);
		setprop("/controls/fire/cargo/aftdischLight", 1);
	} else {
		setprop("/controls/fire/cargo/bottleempty", 0);
		setprop("/controls/fire/cargo/status", 1);
		setprop("/controls/fire/cargo/fwddischLight", 0);
		setprop("/controls/fire/cargo/aftdischLight", 0);
	}
	
}

###################
# Update Function #
###################

var update_fire = func {
	master_fire();
}

var fire_timer = maketimer(0.1, update_fire);

