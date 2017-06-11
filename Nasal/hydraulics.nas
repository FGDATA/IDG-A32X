# A320 Hydraulic System
# Joshua Davidson (it0uchpods)

#############
# Init Vars #
#############

var hyd_init = func {
	setprop("/controls/hydraulic/eng1-pump", 1);
	setprop("/controls/hydraulic/eng2-pump", 1);
	setprop("/controls/hydraulic/elec-pump-blue", 1);
	setprop("/controls/hydraulic/elec-pump-yellow", 0);
	setprop("/controls/hydraulic/ptu", 1);
	setprop("/controls/hydraulic/rat-man", 0);
	setprop("/controls/hydraulic/rat", 0);
	setprop("/controls/hydraulic/rat-deployed", 0);
	setprop("/systems/hydraulic/ptu-active", 0);
	setprop("/systems/hydraulic/blue-psi", 0);
	setprop("/systems/hydraulic/green-psi", 0);
	setprop("/systems/hydraulic/yellow-psi", 0);
	setprop("/systems/hydraulic/spoiler3and4-inhibit", 0);
	setprop("/systems/hydraulic/spoiler-inhibit", 0);
	setprop("/controls/gear/brake-parking", 0);
	hyd_timer.start();
}

#######################
# Main Hydraulic Loop #
#######################

var master_hyd = func {
	var eng1_pump_sw = getprop("/controls/hydraulic/eng1-pump");
	var eng2_pump_sw = getprop("/controls/hydraulic/eng2-pump");
	var elec_pump_blue_sw = getprop("/controls/hydraulic/elec-pump-blue");
	var elec_pump_yellow_sw = getprop("/controls/hydraulic/elec-pump-yellow");
	var ptu_sw = getprop("/controls/hydraulic/ptu");
	var rat_man_sw = getprop("/controls/hydraulic/rat-man");
	var blue_psi = getprop("/systems/hydraulic/blue-psi");
	var green_psi = getprop("/systems/hydraulic/green-psi");
	var yellow_psi = getprop("/systems/hydraulic/yellow-psi");
	var rpmapu = getprop("/systems/apu/rpm");
	var stateL = getprop("/engines/engine[0]/state");
	var stateR = getprop("/engines/engine[1]/state");
	var dc_ess = getprop("/systems/electrical/bus/dc-ess");
	var psi_diff = green_psi - yellow_psi;
	var rat = getprop("/controls/hydraulic/rat");
	var ratout = getprop("/controls/hydraulic/rat-deployed");
	var gs = getprop("/velocities/groundspeed-kt");
	var blue_leak = getprop("/systems/failures/hyd-blue");
	var green_leak = getprop("/systems/failures/hyd-green");
	var yellow_leak = getprop("/systems/failures/hyd-yellow");
	var blue_pump_fail = getprop("/systems/failures/pump-blue");
	var green_pump_fail = getprop("/systems/failures/pump-green");
	var yellow_pump_eng_fail = getprop("/systems/failures/pump-yellow-eng");
	var yellow_pump_elec_fail = getprop("/systems/failures/pump-yellow-elec");
	var ptu_fail = getprop("/systems/failures/ptu");
	
	if (psi_diff > 500 or psi_diff < -500 and ptu_sw) {
		setprop("/systems/hydraulic/ptu-active", 1);
	} else if (psi_diff < 20 and psi_diff > -20) {
		setprop("/systems/hydraulic/ptu-active", 0);
	}

	if ((rat_man_sw == 1 or getprop("/controls/electrical/switches/emer-gen") == 1) and (gs > 100)) {
		setprop("/controls/hydraulic/rat", 1);
		setprop("/controls/hydraulic/rat-deployed", 1);
	} else if (gs < 100) {
		setprop("/controls/hydraulic/rat", 0);
	}
	
	var ptu_active = getprop("/systems/hydraulic/ptu-active");
	
	if ((elec_pump_blue_sw and dc_ess >= 25 and !blue_pump_fail) and (stateL == 3 or stateR == 3) and !blue_leak) {
		if (blue_psi < 2900) {
			setprop("/systems/hydraulic/blue-psi", blue_psi + 100);
		} else {
			setprop("/systems/hydraulic/blue-psi", 3000);
		}
	} else if (gs >= 100 and rat and !blue_leak) {
		if (blue_psi < 2400) {
			setprop("/systems/hydraulic/blue-psi", blue_psi + 100);
		} else {
			setprop("/systems/hydraulic/blue-psi", 2500);
		}
	} else {
		if (blue_psi > 1) {
			setprop("/systems/hydraulic/blue-psi", blue_psi - 50);
		} else {
			setprop("/systems/hydraulic/blue-psi", 0);
		}
	}
	
	if ((eng1_pump_sw and stateL == 3 and !green_pump_fail) and !green_leak) {
		if (green_psi < 2900) {
			setprop("/systems/hydraulic/green-psi", green_psi + 100);
		} else {
			setprop("/systems/hydraulic/green-psi", 3000);
		}
	} else if ((ptu_active and stateL != 3 and !ptu_fail) and !green_leak) {
		if (green_psi < 2900) {
			setprop("/systems/hydraulic/green-psi", green_psi + 100);
		} else {
			setprop("/systems/hydraulic/green-psi", 3000);
		}
	} else {
		if (green_psi > 1) {
			setprop("/systems/hydraulic/green-psi", green_psi - 50);
		} else {
			setprop("/systems/hydraulic/green-psi", 0);
		}
	}
	
	if ((eng2_pump_sw and stateR == 3 and !yellow_pump_eng_fail) and !yellow_leak) {
		if (yellow_psi < 2900) {
			setprop("/systems/hydraulic/yellow-psi", yellow_psi + 100);
		} else {
			setprop("/systems/hydraulic/yellow-psi", 3000);
		}
	} else if ((elec_pump_yellow_sw and dc_ess >= 25 and !yellow_pump_elec_fail) and !yellow_leak) {
		if (yellow_psi < 2900) {
			setprop("/systems/hydraulic/yellow-psi", yellow_psi + 100);
		} else {
			setprop("/systems/hydraulic/yellow-psi", 3000);
		}
	} else if ((ptu_active and stateR != 3 and !ptu_fail) and !yellow_leak) {
		if (yellow_psi < 2900) {
			setprop("/systems/hydraulic/yellow-psi", yellow_psi + 100);
		} else {
			setprop("/systems/hydraulic/yellow-psi", 3000);
		}
	} else {
		if (yellow_psi > 1) {
			setprop("/systems/hydraulic/yellow-psi", yellow_psi - 50);
		} else {
			setprop("/systems/hydraulic/yellow-psi", 0);
		}
	}
	
	var lelev = getprop("/systems/failures/elevator-left");
	var relev = getprop("/systems/failures/elevator-right");
	var flap = getprop("/controls/flight/flap-txt");
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	var alpha = getprop("/systems/thrust/alpha-floor");
	var sec1 = getprop("/systems/failures/sec1");
	var sec3 = getprop("/systems/failures/sec3");
	#var aoa_prot = getprop("aoaprotection);
	if (lelev or relev) {
		setprop("/systems/hydraulic/spoiler3and4-inhibit", 1);
	} else {
			setprop("/systems/hydraulic/spoiler3and4-inhibit", 0);
	}
	if ((flap == "FULL") or alpha or (sec1 and sec3) or (((state1 == "MCT") or (state1 == "TOGA")) and ((state2 == "MCT") or (state2 == "TOGA")))) {
		setprop("/systems/hydraulic/spoiler-inhibit", 1);
	} else {
			setprop("/systems/hydraulic/spoiler-inhibit", 0);
	}
}

#######################
# Various Other Stuff #
#######################

setlistener("/controls/gear/gear-down", func {
	var down = getprop("/controls/gear/gear-down");
	if (!down and (getprop("/gear/gear[0]/wow") or getprop("/gear/gear[1]/wow") or getprop("/gear/gear[2]/wow"))) {
		setprop("/controls/gear/gear-down", 1);
	}
});

###################
# Update Function #
###################

var update_hydraulic = func {
	master_hyd();
}

var hyd_timer = maketimer(0.2, update_hydraulic);
