# A3XX Hydraulic System
# Joshua Davidson (it0uchpods)

##############################################################
# Copyright (c) A3XX Development Team - All Rights Reserved. #
##############################################################

#############
# Init Vars #
#############

setlistener("/sim/signals/fdm-initialized", func {
	var eng1_pump_sw = getprop("/controls/hydraulic/eng1-pump");
	var eng2_pump_sw = getprop("/controls/hydraulic/eng2-pump");
	var elec_pump_blue_sw = getprop("/controls/hydraulic/elec-pump-blue");
	var elec_pump_yellow_sw = getprop("/controls/hydraulic/elec-pump-yellow");
	var yellow_hand_pump = getprop("/controls/hydraulic/hand-pump-yellow");
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
	var dc2 = getprop("/systems/electrical/bus/dc2");
	var ptu_active = getprop("/systems/hydraulic/ptu-active");
	var accum = getprop("/systems/hydraulic/brakes/accumulator-pressure-psi");
	var lpsi = getprop("/systems/hydraulic/brakes/pressure-left-psi");
	var rpsi = getprop("/systems/hydraulic/brakes/pressure-right-psi");
	var parking = getprop("/controls/gear/brake-parking");
	var askidnws_sw = getprop("/systems/hydraulic/brakes/askidnwssw");
	var brake_mode = getprop("/systems/hydraulic/brakes/mode");
	var brake_l = getprop("/systems/hydraulic/brakes/lbrake");
	var brake_r = getprop("/systems/hydraulic/brakes/rbrake");
	var brake_nose = getprop("/systems/hydraulic/brakes/nose-rubber");
	var counter = getprop("/systems/hydraulic/brakes/counter");
	var down = getprop("/controls/gear/gear-down");
});

var hyd_init = func {
	setprop("/controls/hydraulic/eng1-pump", 1);
	setprop("/controls/hydraulic/eng2-pump", 1);
	setprop("/controls/hydraulic/elec-pump-blue", 1);
	setprop("/controls/hydraulic/elec-pump-yellow", 0);
	setprop("/controls/hydraulic/hand-pump-yellow", 0);
	setprop("/controls/hydraulic/ptu", 1);
	setprop("/controls/hydraulic/rat-man", 0);
	setprop("/controls/hydraulic/rat", 0);
	setprop("/controls/hydraulic/rat-deployed", 0);
	setprop("/systems/hydraulic/ptu-active", 0);
	setprop("/systems/hydraulic/blue-psi", 0);
	setprop("/systems/hydraulic/green-psi", 0);
	setprop("/systems/hydraulic/yellow-psi", 0);
	setprop("/controls/gear/brake-parking", 0);
	setprop("/systems/hydraulic/brakes/accumulator-pressure-psi", 0);
	setprop("/systems/hydraulic/brakes/pressure-left-psi", 0);
	setprop("/systems/hydraulic/brakes/pressure-right-psi", 0);
	setprop("/systems/hydraulic/brakes/askidnwssw", 1);
	setprop("/systems/hydraulic/brakes/mode", 0);
	setprop("/systems/hydraulic/brakes/lbrake", 0);
	setprop("/systems/hydraulic/brakes/rbrake", 0);
	setprop("/systems/hydraulic/brakes/nose-rubber", 0); # this stops the nose from spinning when you raise the gear
	setprop("/systems/hydraulic/brakes/counter", 0);
	setprop("/systems/hydraulic/brakes/accumulator-pressure-psi-1", 0);
	hyd_timer.start();
}

#######################
# Main Hydraulic Loop #
#######################

var master_hyd = func {
	eng1_pump_sw = getprop("/controls/hydraulic/eng1-pump");
	eng2_pump_sw = getprop("/controls/hydraulic/eng2-pump");
	elec_pump_blue_sw = getprop("/controls/hydraulic/elec-pump-blue");
	elec_pump_yellow_sw = getprop("/controls/hydraulic/elec-pump-yellow");
	yellow_hand_pump = getprop("/controls/hydraulic/hand-pump-yellow");
	ptu_sw = getprop("/controls/hydraulic/ptu");
	rat_man_sw = getprop("/controls/hydraulic/rat-man");
	blue_psi = getprop("/systems/hydraulic/blue-psi");
	green_psi = getprop("/systems/hydraulic/green-psi");
	yellow_psi = getprop("/systems/hydraulic/yellow-psi");
	rpmapu = getprop("/systems/apu/rpm");
	stateL = getprop("/engines/engine[0]/state");
	stateR = getprop("/engines/engine[1]/state");
	dc_ess = getprop("/systems/electrical/bus/dc-ess");
	psi_diff = green_psi - yellow_psi;
	rat = getprop("/controls/hydraulic/rat");
	ratout = getprop("/controls/hydraulic/rat-deployed");
	gs = getprop("/velocities/groundspeed-kt");
	blue_leak = getprop("/systems/failures/hyd-blue");
	green_leak = getprop("/systems/failures/hyd-green");
	yellow_leak = getprop("/systems/failures/hyd-yellow");
	blue_pump_fail = getprop("/systems/failures/pump-blue");
	green_pump_fail = getprop("/systems/failures/pump-green");
	yellow_pump_eng_fail = getprop("/systems/failures/pump-yellow-eng");
	yellow_pump_elec_fail = getprop("/systems/failures/pump-yellow-elec");
	ptu_fail = getprop("/systems/failures/ptu");
	dc2 = getprop("/systems/electrical/bus/dc2");
	
	if (psi_diff > 500 or psi_diff < -500 and ptu_sw and dc2 > 28) {
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
	
	ptu_active = getprop("/systems/hydraulic/ptu-active");
	
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
	} else if (yellow_hand_pump and !yellow_leak and (getprop("/gear/gear[0]/wow") or getprop("/gear/gear[1]/wow") or getprop("/gear/gear[2]/wow"))) {
		if (yellow_psi < 2900) {
			setprop("/systems/hydraulic/yellow-psi", yellow_psi + 50);
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
	
	accum = getprop("/systems/hydraulic/brakes/accumulator-pressure-psi");
	lpsi = getprop("/systems/hydraulic/brakes/pressure-left-psi");
	rpsi = getprop("/systems/hydraulic/brakes/pressure-right-psi");
	parking = getprop("/controls/gear/brake-parking");
	askidnws_sw = getprop("/systems/hydraulic/brakes/askidnwssw");
	brake_mode = getprop("/systems/hydraulic/brakes/mode");
	brake_l = getprop("/systems/hydraulic/brakes/lbrake");
	brake_r = getprop("/systems/hydraulic/brakes/rbrake");
	brake_nose = getprop("/systems/hydraulic/brakes/nose-rubber");
	counter = getprop("/systems/hydraulic/brakes/counter");
	
	if (!parking and askidnws_sw and green_psi > 2500) {
		# set mode to on
		setprop("/systems/hydraulic/brakes/mode", 1); 
	} else if ((!parking and askidnws_sw and yellow_psi > 2500) or (!parking and askidnws_sw and accum > 0)) {
		# set mode to altn
		setprop("/systems/hydraulic/brakes/mode", 2); 
	} else {
		# set mode to off
		setprop("/systems/hydraulic/brakes/mode", 0);
	}
	
	if (brake_mode == 2 and yellow_psi > 2500 and accum < 700) {
		setprop("/systems/hydraulic/brakes/accumulator-pressure-psi", accum + 50);
	}
}

#######################
# Various Other Stuff #
#######################

setlistener("/controls/gear/gear-down", func {
	down = getprop("/controls/gear/gear-down");
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


# FIXME:
# Josh, please disable braking when:
# /systems/hydraulic/brakes/accumulator-pressure-psi is equal to 0 and when /systems/hydraulic/brakes/mode is equal to 2
# Thanks!

# Will do -JD

