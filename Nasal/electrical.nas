# A3XX Electrical System
# Joshua Davidson (it0uchpods) and Jonathan Redpath (legoboyvdlp)

#############
# Init Vars #
#############

var ac_volt_std = 115;
var ac_volt_min = 110;
var dc_volt_std = 28;
var dc_volt_min = 25;
var dc_amps_std = 150;
var ac_hz_std = 400;

var elec_init = func {
	setprop("/controls/switches/annun-test", 0);
	setprop("/controls/electrical/switches/galley", 1);
	setprop("/controls/electrical/switches/idg1", 0);
	setprop("/controls/electrical/switches/idg2", 0);
	setprop("/controls/electrical/switches/gen1", 1);
	setprop("/controls/electrical/switches/gen2", 1);
	setprop("/controls/electrical/switches/emer-gen", 0);
	setprop("/controls/electrical/switches/gen-apu", 1);
	setprop("/controls/electrical/switches/gen-ext", 0);
	setprop("/controls/electrical/switches/apu-ext-crosstie", 1);
	setprop("/controls/electrical/switches/ac-ess-feed", 1);
	setprop("/controls/electrical/switches/battery1", 0);
	setprop("/controls/electrical/switches/battery2", 0);
	setprop("/systems/electrical/battery1-volts", 25.9);
	setprop("/systems/electrical/battery2-volts", 25.9);
	setprop("/systems/electrical/battery1-amps", 0);
	setprop("/systems/electrical/battery2-amps", 0);
	setprop("/systems/electrical/bus/dc1", 0);
	setprop("/systems/electrical/bus/dc2", 0);
	setprop("/systems/electrical/bus/dcbat", 0);
	setprop("/systems/electrical/bus/dc1-amps", 0);
	setprop("/systems/electrical/bus/dc2-amps", 0);
	setprop("/systems/electrical/bus/dc-ess", 0);
	setprop("/systems/electrical/bus/ac1", 0);
	setprop("/systems/electrical/bus/ac2", 0);
	setprop("/systems/electrical/bus/gen1-hz", 0);
	setprop("/systems/electrical/bus/gen2-hz", 0);
	setprop("/systems/electrical/bus/ac-ess", 0);
	setprop("/systems/electrical/extra/ext-volts", 0);
	setprop("/systems/electrical/extra/apu-volts", 0);
	setprop("/systems/electrical/extra/gen1-volts", 0);
	setprop("/systems/electrical/extra/gen2-volts", 0);
	setprop("/systems/electrical/extra/ext-hz", 0);
	setprop("/systems/electrical/extra/apu-hz", 0);
	setprop("/systems/electrical/extra/galleyshed", 0);
	setprop("/systems/electrical/extra/battery/bat1-contact", 0);
	setprop("/systems/electrical/extra/battery/bat2-contact", 0);
	setprop("/systems/electrical/gen-apu", 0);
	setprop("/systems/electrical/gen-ext", 0);
	setprop("/systems/electrical/on", 0);
	setprop("/controls/electrical/xtie/xtieL", 0);
	setprop("/controls/electrical/xtie/xtieR", 0);
	# Below are standard FG Electrical stuff to keep things working when the plane is powered
    setprop("/systems/electrical/outputs/adf", 0);
    setprop("/systems/electrical/outputs/audio-panel", 0);
    setprop("/systems/electrical/outputs/audio-panel[1]", 0);
    setprop("/systems/electrical/outputs/autopilot", 0);
    setprop("/systems/electrical/outputs/avionics-fan", 0);
    setprop("/systems/electrical/outputs/beacon", 0);
    setprop("/systems/electrical/outputs/bus", 0);
    setprop("/systems/electrical/outputs/cabin-lights", 0);
    setprop("/systems/electrical/outputs/dme", 0);
    setprop("/systems/electrical/outputs/efis", 0);
    setprop("/systems/electrical/outputs/flaps", 0);
    setprop("/systems/electrical/outputs/fuel-pump", 0);
    setprop("/systems/electrical/outputs/fuel-pump[1]", 0);
    setprop("/systems/electrical/outputs/gps", 0);
    setprop("/systems/electrical/outputs/gps-mfd", 0);
    setprop("/systems/electrical/outputs/hsi", 0);
    setprop("/systems/electrical/outputs/instr-ignition-switch", 0);
    setprop("/systems/electrical/outputs/instrument-lights", 0);
    setprop("/systems/electrical/outputs/landing-lights", 0);
    setprop("/systems/electrical/outputs/map-lights", 0);
    setprop("/systems/electrical/outputs/mk-viii", 0);
    setprop("/systems/electrical/outputs/nav", 0);
    setprop("/systems/electrical/outputs/nav[1]", 0);
    setprop("/systems/electrical/outputs/nav[2]", 0);
    setprop("/systems/electrical/outputs/nav[3]", 0);
    setprop("/systems/electrical/outputs/pitot-head", 0);
    setprop("/systems/electrical/outputs/stobe-lights", 0);
    setprop("/systems/electrical/outputs/tacan", 0);
    setprop("/systems/electrical/outputs/taxi-lights", 0);
    setprop("/systems/electrical/outputs/transponder", 0);
    setprop("/systems/electrical/outputs/turn-coordinator", 0);
	elec_timer.start();
}

######################
# Main Electric Loop #
######################

var master_elec = func {
	var galley_sw = getprop("/controls/electrical/switches/galley");
	var idg1_sw = getprop("/controls/electrical/switches/idg1");
	var idg2_sw = getprop("/controls/electrical/switches/idg2");
	var gen1_sw = getprop("/controls/electrical/switches/gen1");
	var gen2_sw = getprop("/controls/electrical/switches/gen2");
	var gen_apu_sw = getprop("/controls/electrical/switches/gen-apu");
	var gen_ext_sw = getprop("/controls/electrical/switches/gen-ext");
	var apu_ext_crosstie_sw = getprop("/controls/electrical/switches/apu-ext-crosstie");
	var ac_ess_feed_sw = getprop("/controls/electrical/switches/ac-ess-feed");
	var battery1_sw = getprop("/controls/electrical/switches/battery1");
	var battery2_sw = getprop("/controls/electrical/switches/battery2");
	var battery1_volts = getprop("/systems/electrical/battery1-volts");
	var battery2_volts = getprop("/systems/electrical/battery2-volts");
	var rpmapu = getprop("/systems/apu/rpm");
	var extpwr_on = getprop("/controls/switches/cart");
	var stateL = getprop("/engines/engine[0]/state");
	var stateR = getprop("/engines/engine[1]/state");
	var xtieL = getprop("/controls/electrical/xtie/xtieL");
	var xtieR = getprop("/controls/electrical/xtie/xtieR");
	var ac1 = getprop("/systems/electrical/bus/ac1");
	var ac2 = getprop("/systems/electrical/bus/ac2");
	var ac_ess = getprop("/systems/electrical/bus/ac-ess");
	var dc1 = getprop("/systems/electrical/bus/dc1");
	var dc2 = getprop("/systems/electrical/bus/dc2");
	var dcbat = getprop("/systems/electrical/bus/dcbat");
	var dc_ess = getprop("/systems/electrical/bus/dc-ess");
	var gen_1_volts = getprop("/systems/electrical/extra/gen1-volts");
	var gen_2_volts = getprop("/systems/electrical/extra/gen1-volts");
	var galley_shed = getprop("/systems/electrical/extra/galleyshed");
	var bat1_con = getprop("/systems/electrical/extra/battery/bat1-contact");
	var bat2_con = getprop("/systems/electrical/extra/battery/bat2-contact");
	var emergen = getprop("/controls/electrical/switches/emer-gen");
	var ias = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
	var rat = getprop("/controls/hydraulic/rat");
	var manrat = getprop("/controls/hydraulic/rat-man");
	var ac_ess_fail = getprop("/systems/failures/elec-ac-ess");
	var batt1_fail = getprop("/systems/failures/elec-batt1");
	var batt2_fail = getprop("/systems/failures/elec-batt2");
	var gallery_fail = getprop("/systems/failures/elec-galley");
	var genapu_fail = getprop("/systems/failures/elec-genapu");
	var gen1_fail = getprop("/systems/failures/elec-gen1");
	var gen2_fail = getprop("/systems/failures/elec-gen2");
	
	if (rpmapu >= 94.9 and gen_apu_sw) {
		setprop("/systems/electrical/gen-apu", 1);
	} else {
		setprop("/systems/electrical/gen-apu", 0);
	}
	
	if (extpwr_on and gen_ext_sw) {
		setprop("/systems/electrical/gen-ext", 1);
	} else {
		setprop("/systems/electrical/gen-ext", 0);
	}
	
	var gen_apu = getprop("/systems/electrical/gen-apu");
	var gen_ext = getprop("/systems/electrical/gen-ext");
	
	# Left cross tie yes?
	if (extpwr_on and gen_ext_sw) {
		setprop("/controls/electrical/xtie/xtieR", 1);
	} else if (rpmapu >= 94.9 and gen_apu_sw and !genapu_fail) {
		setprop("/controls/electrical/xtie/xtieR", 1);
	} else if (stateL == 3 and gen1_sw and !gen1_fail) {
		setprop("/controls/electrical/xtie/xtieR", 1);
	} else {
		setprop("/controls/electrical/xtie/xtieR", 0);
	}
	
	# Right cross tie yes?
	if (extpwr_on and gen_ext_sw) {
		setprop("/controls/electrical/xtie/xtieL", 1);
	} else if (rpmapu >= 94.9 and gen_apu_sw and !genapu_fail) {
		setprop("/controls/electrical/xtie/xtieL", 1);
	} else if (stateR == 3 and gen2_sw and !gen2_fail) {
		setprop("/controls/electrical/xtie/xtieL", 1);
	} else {
		setprop("/controls/electrical/xtie/xtieL", 0);
	}
	
	# Left DC bus yes?
	if (stateL == 3 and gen1_sw and !gen1_fail) {
		setprop("/systems/electrical/bus/dc1", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
	} else if (gen_apu and !genapu_fail) {
		setprop("/systems/electrical/bus/dc1", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
	} else if (extpwr_on and gen_ext_sw) {
		setprop("/systems/electrical/bus/dc1", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
	} else if (apu_ext_crosstie_sw == 1 and xtieL) {
		setprop("/systems/electrical/bus/dc1", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
	} else if (emergen) {
		setprop("/systems/electrical/bus/dc1", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
	} else {
		setprop("/systems/electrical/bus/dc1", 0);
		setprop("/systems/electrical/bus/dc1-amps", 0); 
		if (getprop("/systems/electrical/bus/dc2") == 0) {
			setprop("/systems/electrical/bus/dc-ess", 0);
		}
	}
	
	# Right DC bus yes?
	if (stateR == 3 and gen2_sw and !gen2_fail) {
		setprop("/systems/electrical/bus/dc2", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
	} else if (gen_apu and !genapu_fail) {
		setprop("/systems/electrical/bus/dc2", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
	} else if (extpwr_on and gen_ext_sw) {
		setprop("/systems/electrical/bus/dc2", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
	} else if (apu_ext_crosstie_sw == 1  and xtieR) {
		setprop("/systems/electrical/bus/dc2", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
	} else if (emergen) {
		setprop("/systems/electrical/bus/dc2", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
	} else {
		setprop("/systems/electrical/bus/dc2", 0);
		setprop("/systems/electrical/bus/dc2-amps", 0); 
		if (getprop("/systems/electrical/bus/dc1") == 0) {
			setprop("/systems/electrical/bus/dc-ess", 0);
		}
	}
	
	# Left AC bus yes?
	if (stateL == 3 and gen1_sw and !gen1_fail) {
		setprop("/systems/electrical/bus/ac1", ac_volt_std);
	} else if (gen_apu and !genapu_fail) {
		setprop("/systems/electrical/bus/ac1", ac_volt_std);
	} else if (extpwr_on and gen_ext_sw) {
		setprop("/systems/electrical/bus/ac1", ac_volt_std);
	} else if (apu_ext_crosstie_sw == 1 and xtieL) {
		setprop("/systems/electrical/bus/ac1", ac_volt_std);
	} else if (emergen) {
		setprop("/systems/electrical/bus/ac1", ac_volt_std);
	} else {
		setprop("/systems/electrical/bus/ac1", 0);
	}
	
	# Right AC bus yes?
	if (stateR == 3 and gen2_sw and !gen2_fail) {
		setprop("/systems/electrical/bus/ac2", ac_volt_std);
	} else if (gen_apu and !genapu_fail) {
		setprop("/systems/electrical/bus/ac2", ac_volt_std);
	} else if (extpwr_on and gen_ext_sw) {
		setprop("/systems/electrical/bus/ac2", ac_volt_std);
	} else if (apu_ext_crosstie_sw == 1  and xtieR) {
		setprop("/systems/electrical/bus/ac2", ac_volt_std);
	} else if (emergen) {
		setprop("/systems/electrical/bus/ac2", ac_volt_std);
	} else {
		setprop("/systems/electrical/bus/ac2", 0);
	}
	
	# HZ/Volts yes?
	if (stateL == 3 and gen1_sw and !gen1_fail) {
		setprop("/systems/electrical/extra/gen1-volts", ac_volt_std);
		setprop("/systems/electrical/bus/gen1-hz", ac_hz_std);
	} else {
		setprop("/systems/electrical/extra/gen1-volts", 0);
		setprop("/systems/electrical/bus/gen1-hz", 0);
	}
	
	if (stateR == 3 and gen2_sw and !gen2_fail) {
		setprop("/systems/electrical/extra/gen2-volts", ac_volt_std);
		setprop("/systems/electrical/bus/gen2-hz", ac_hz_std);
	} else {
		setprop("/systems/electrical/extra/gen2-volts", 0);
		setprop("/systems/electrical/bus/gen2-hz", 0);
	}
	
	if (extpwr_on and gen_ext_sw) {
		setprop("/systems/electrical/extra/ext-volts", ac_volt_std);
		setprop("/systems/electrical/extra/ext-hz", ac_hz_std);
	} else {
		setprop("/systems/electrical/extra/ext-volts", 0);
		setprop("/systems/electrical/extra/ext-hz", 0);
	}
	
	if (gen_apu and !genapu_fail) {
		setprop("/systems/electrical/extra/apu-volts", ac_volt_std);
		setprop("/systems/electrical/extra/apu-hz", ac_hz_std);
	} else {
		setprop("/systems/electrical/extra/apu-volts", 0);
		setprop("/systems/electrical/extra/apu-hz", 0);
	}
	
	var ac1 = getprop("/systems/electrical/bus/ac1");
	var ac2 = getprop("/systems/electrical/bus/ac2");
	
	if (!ac_ess_fail and (ac1 >= 110 or ac2 >= 110)) {
		setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
	} else {
		setprop("/systems/electrical/bus/ac-ess", 0);
	}
	
	var ac_ess = getprop("/systems/electrical/bus/ac-ess");
	
	if (ac_ess >= 110 and !gallery_fail) {
		if (galley_sw == 1 and !galley_shed) { 
			setprop("/systems/electrical/bus/galley", ac_volt_std);
		} else if (galley_sw or galley_shed) {
			setprop("/systems/electrical/bus/galley", 0);
		}
	} else {
		setprop("/systems/electrical/bus/galley", 0);
	}
	
	if (!gen_apu and !gen_ext_sw and (!gen1_sw or !gen2_sw)) {
		setprop("/systems/electrical/extra/galleyshed", 1); 
	} else {
		setprop("/systems/electrical/extra/galleyshed", 0); 
	}
	
	if ((ac1 == 0) and (ac2 == 0) and (ias > 100) or (manrat)) {
		setprop("/controls/hydraulic/rat-deployed", 1);
		setprop("/controls/hydraulic/rat", 1);
		setprop("/controls/electrical/switches/emer-gen", 1);
	}
	
	if (ias < 100) {
		setprop("/controls/electrical/switches/emer-gen", 0);
	}
	
	# Battery Amps
	if (battery1_sw and !batt1_fail) {
		setprop("/systems/electrical/battery1-amps", dc_amps_std);
	} else {
		setprop("/systems/electrical/battery1-amps", 0);
	}
	
	if (battery2_sw and !batt2_fail) {
		setprop("/systems/electrical/battery2-amps", dc_amps_std);
	} else {
		setprop("/systems/electrical/battery2-amps", 0);
	}
	
	if ((dc1 > 0) or (dc2 > 0)) {
		setprop("/systems/electrical/bus/dcbat", dc_volt_std);
	} else {
		setprop("/systems/electrical/bus/dcbat", 0);
	}
	
	if (battery1_volts > 27.9 or (dcbat == 0)) {
		setprop("/systems/electrical/extra/battery/bat1-contact", 0);
		charge1.stop();
	} else if (batt1_fail) {
		setprop("/systems/electrical/extra/battery/bat1-contact", 0);
		charge1.stop();
	}
	
	if (battery2_volts > 27.9 or (dcbat == 0)) {
		setprop("/systems/electrical/extra/battery/bat2-contact", 0);
		charge2.stop();
	} else if (batt2_fail) {
		setprop("/systems/electrical/extra/battery/bat2-contact", 0);
		charge2.stop();
	}
	
	if ((dcbat > 0) and battery1_sw and !batt1_fail) {
		setprop("/systems/electrical/extra/battery/bat1-contact", 1);
		decharge1.stop();
		charge1.start();
	}
	
	if ((dcbat > 0) and battery2_sw and !batt2_fail) {
		setprop("/systems/electrical/extra/battery/bat2-contact", 1);
		decharge1.stop();
		charge2.start();
	}

	
	if (!bat1_con and (dcbat == 0) and battery1_sw and !batt1_fail) {
		decharge1.start();
	}
	
	if (!bat2_con and (dcbat == 0) and battery2_sw and !batt2_fail) {
		decharge2.start();
	}
		
	if (getprop("/systems/electrical/bus/ac-ess") < 110) {
		setprop("/it-autoflight/input/ap1", 0);
		setprop("/it-autoflight/input/ap2", 0);
		setprop("systems/electrical/on", 0);
#		ai_spin.setValue(0.2);
#		aispin.stop();
		setprop("/systems/electrical/outputs/adf", 0);
		setprop("/systems/electrical/outputs/audio-panel", 0);
		setprop("/systems/electrical/outputs/audio-panel[1]", 0);
		setprop("/systems/electrical/outputs/autopilot", 0);
		setprop("/systems/electrical/outputs/avionics-fan", 0);
		setprop("/systems/electrical/outputs/beacon", 0);
		setprop("/systems/electrical/outputs/bus", 0);
		setprop("/systems/electrical/outputs/cabin-lights", 0);
		setprop("/systems/electrical/outputs/dme", 0);
		setprop("/systems/electrical/outputs/efis", 0);
		setprop("/systems/electrical/outputs/flaps", 0);
		setprop("/systems/electrical/outputs/fuel-pump", 0);
		setprop("/systems/electrical/outputs/fuel-pump[1]", 0);
		setprop("/systems/electrical/outputs/gps", 0);
		setprop("/systems/electrical/outputs/gps-mfd", 0);
		setprop("/systems/electrical/outputs/hsi", 0);
		setprop("/systems/electrical/outputs/instr-ignition-switch", 0);
		setprop("/systems/electrical/outputs/instrument-lights", 0);
		setprop("/systems/electrical/outputs/landing-lights", 0);
		setprop("/systems/electrical/outputs/map-lights", 0);
		setprop("/systems/electrical/outputs/mk-viii", 0);
		setprop("/systems/electrical/outputs/nav", 0);
		setprop("/systems/electrical/outputs/nav[1]", 0);
		setprop("/systems/electrical/outputs/nav[2]", 0);
		setprop("/systems/electrical/outputs/nav[3]", 0);
		setprop("/systems/electrical/outputs/pitot-head", 0);
		setprop("/systems/electrical/outputs/stobe-lights", 0);
		setprop("/systems/electrical/outputs/tacan", 0);
		setprop("/systems/electrical/outputs/taxi-lights", 0);
		setprop("/systems/electrical/outputs/transponder", 0);
		setprop("/systems/electrical/outputs/turn-coordinator", 0);
	} else {
		setprop("/systems/electrical/on", 1);
#		aispin.start();
		setprop("/systems/electrical/outputs/adf", dc_volt_std);
		setprop("/systems/electrical/outputs/audio-panel", dc_volt_std);
		setprop("/systems/electrical/outputs/audio-panel[1]", dc_volt_std);
		setprop("/systems/electrical/outputs/autopilot", dc_volt_std);
		setprop("/systems/electrical/outputs/avionics-fan", dc_volt_std);
		setprop("/systems/electrical/outputs/beacon", dc_volt_std);
		setprop("/systems/electrical/outputs/bus", dc_volt_std);
		setprop("/systems/electrical/outputs/cabin-lights", dc_volt_std);
		setprop("/systems/electrical/outputs/dme", dc_volt_std);
		setprop("/systems/electrical/outputs/efis", dc_volt_std);
		setprop("/systems/electrical/outputs/flaps", dc_volt_std);
		setprop("/systems/electrical/outputs/fuel-pump", dc_volt_std);
		setprop("/systems/electrical/outputs/fuel-pump[1]", dc_volt_std);
		setprop("/systems/electrical/outputs/gps", dc_volt_std);
		setprop("/systems/electrical/outputs/gps-mfd", dc_volt_std);
		setprop("/systems/electrical/outputs/hsi", dc_volt_std);
		setprop("/systems/electrical/outputs/instr-ignition-switch", dc_volt_std);
		setprop("/systems/electrical/outputs/instrument-lights", dc_volt_std);
		setprop("/systems/electrical/outputs/landing-lights", dc_volt_std);
		setprop("/systems/electrical/outputs/map-lights", dc_volt_std);
		setprop("/systems/electrical/outputs/mk-viii", dc_volt_std);
		setprop("/systems/electrical/outputs/nav", dc_volt_std);
		setprop("/systems/electrical/outputs/nav[1]", dc_volt_std);
		setprop("/systems/electrical/outputs/nav[2]", dc_volt_std);
		setprop("/systems/electrical/outputs/nav[3]", dc_volt_std);
		setprop("/systems/electrical/outputs/pitot-head", dc_volt_std);
		setprop("/systems/electrical/outputs/stobe-lights", dc_volt_std);
		setprop("/systems/electrical/outputs/tacan", dc_volt_std);
		setprop("/systems/electrical/outputs/taxi-lights", dc_volt_std);
		setprop("/systems/electrical/outputs/transponder", dc_volt_std);
		setprop("/systems/electrical/outputs/turn-coordinator", dc_volt_std);
	}
}

###################
# Update Function #
###################

var update_electrical = func {
	master_elec();
}

##########
# Timers #
##########

var elec_timer = maketimer(0.2, update_electrical);

var charge1 = maketimer(6, func {
	var bat1_volts = getprop("/systems/electrical/battery1-volts");
	setprop("/systems/electrical/battery1-volts", bat1_volts + 0.1);
});
var charge2 = maketimer(6, func {
	var bat2_volts = getprop("/systems/electrical/battery2-volts");
	setprop("/systems/electrical/battery2-volts", bat2_volts + 0.1);
});
var decharge1 = maketimer(69, func { # interval is at 69 seconds, to allow about 30 min from 25.9
	var bat1_volts = getprop("/systems/electrical/battery1-volts");
	setprop("/systems/electrical/battery1-volts", bat1_volts - 0.1);
});
var decharge2 = maketimer(69, func {
	var bat2_volts = getprop("/systems/electrical/battery2-volts");
	setprop("/systems/electrical/battery2-volts", bat2_volts - 0.1);
});