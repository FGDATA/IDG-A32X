# Electrical system for A320 by Joshua Davidson (it0uchpods/411).

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
	setprop("/controls/electrical/switches/galley", 0);
	setprop("/controls/electrical/switches/idg1", 0);
	setprop("/controls/electrical/switches/idg2", 0);
	setprop("/controls/electrical/switches/gen1", 0);
	setprop("/controls/electrical/switches/gen2", 0);
	setprop("/controls/electrical/switches/gen-apu", 0);
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
	setprop("/systems/electrical/gen-apu", 0);
	setprop("systems/electrical/on", 0);
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
	var gen_apu = getprop("/systems/electrical/gen-apu");
	var apu_ext_crosstie_sw = getprop("/controls/electrical/switches/apu-ext-crosstie");
	var ac_ess_feed_sw = getprop("/controls/electrical/switches/ac-ess-feed");
	var battery1_sw = getprop("/controls/electrical/switches/battery1");
	var battery2_sw = getprop("/controls/electrical/switches/battery2");
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
	var dc_ess = getprop("/systems/electrical/bus/dc-ess");
	var gen_1_volts = getprop("/systems/electrical/extra/gen1-volts");
	var gen_2_volts = getprop("/systems/electrical/extra/gen1-volts");
	var galley_shed = getprop("/systems/electrical/extra/galleyshed");
	
	
	
	# Left cross tie yes?
	if (extpwr_on and gen_ext_sw) {
		setprop("/controls/electrical/xtie/xtieR", 1);
	} else if (rpmapu >= 94.9 and gen_apu_sw) {
		setprop("/controls/electrical/xtie/xtieR", 1);
	} else if (stateL == 3 and gen1_sw) {
		setprop("/controls/electrical/xtie/xtieR", 1);
	} else {
		setprop("/controls/electrical/xtie/xtieR", 0);
	}
	
	# Right cross tie yes?
	if (extpwr_on and gen_ext_sw) {
		setprop("/controls/electrical/xtie/xtieL", 1);
	} else if (rpmapu >= 94.9 and gen_apu_sw) {
		setprop("/controls/electrical/xtie/xtieL", 1);
	} else if (stateR == 3 and gen2_sw) {
		setprop("/controls/electrical/xtie/xtieL", 1);
	} else {
		setprop("/controls/electrical/xtie/xtieL", 0);
	}
	
	# Left AC/DC bus yes?
	if (extpwr_on and gen_ext_sw) {
		setprop("/systems/electrical/bus/ac1", ac_volt_std);
		setprop("/systems/electrical/bus/ac-ess", ac_volt_std); 
		setprop("/systems/electrical/extra/ext-volts", ac_volt_std);
		setprop("/systems/electrical/extra/ext-hz", ac_volt_std);
		setprop("/systems/electrical/bus/dc1", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
	} else if (gen_apu) {
		setprop("/systems/electrical/bus/ac1", ac_volt_std);
		setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
		setprop("/systems/electrical/extra/apu-volts", ac_volt_std);
		setprop("/systems/electrical/extra/apu-hz", ac_volt_std);
		setprop("/systems/electrical/bus/dc1", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
	} else if (stateL == 3 and gen1_sw) {
		setprop("/systems/electrical/bus/ac1", ac_volt_std);
		setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
		setprop("/systems/electrical/extra/gen1-volts", ac_volt_std);
		setprop("/systems/electrical/bus/gen1-hz", ac_hz_std);
		setprop("/systems/electrical/bus/dc1", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
	} else if (apu_ext_crosstie_sw == 1 and xtieL) {
		setprop("/systems/electrical/bus/ac1", ac_volt_std);
		setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
		setprop("/systems/electrical/bus/dc1", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
	} else {
		setprop("/systems/electrical/bus/ac1", 0);
		setprop("/systems/electrical/extra/ext-volts", 0);
		setprop("/systems/electrical/extra/apu-volts", 0);
		setprop("/systems/electrical/extra/ext-hz", 0);
		setprop("/systems/electrical/extra/apu-hz", 0);
		setprop("/systems/electrical/extra/gen1-volts", 0);
		setprop("/systems/electrical/bus/gen1-hz", 0);
		if (getprop("/systems/electrical/bus/ac2") == 0) {
			setprop("/systems/electrical/bus/ac-ess", 0);
		}
		setprop("/systems/electrical/bus/dc1", 0);
		setprop("/systems/electrical/bus/dc1-amps", 0); 
		if (getprop("/systems/electrical/bus/dc2") == 0) {
			setprop("/systems/electrical/bus/dc-ess", 0);
		}
	}
	
	# Right AC/DC bus yes?
	if (extpwr_on and gen_ext_sw) {
		setprop("/systems/electrical/bus/ac2", ac_volt_std);
		setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
		setprop("/systems/electrical/extra/ext-volts", ac_volt_std);
		setprop("/systems/electrical/extra/ext-hz", ac_hz_std);
		setprop("/systems/electrical/bus/dc2", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
	} else if (gen_apu) {
		setprop("/systems/electrical/bus/ac2", ac_volt_std);
		setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
		setprop("/systems/electrical/extra/apu-volts", ac_volt_std);
		setprop("/systems/electrical/extra/apu-hz", ac_hz_std);
		setprop("/systems/electrical/bus/dc2", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
	} else if (stateR == 3 and gen2_sw) {
		setprop("/systems/electrical/bus/ac2", ac_volt_std);
		setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
		setprop("/systems/electrical/extra/gen2-volts", ac_volt_std);
		setprop("/systems/electrical/bus/gen2-hz", ac_hz_std);
		setprop("/systems/electrical/bus/dc2", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
	} else if (apu_ext_crosstie_sw == 1  and xtieR) {
		setprop("/systems/electrical/bus/ac2", ac_volt_std);
		setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
		setprop("/systems/electrical/bus/dc2", dc_volt_std);
		setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
		setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
	} else {
		setprop("/systems/electrical/bus/ac2", 0);
		setprop("/systems/electrical/extra/ext-volts", 0);
		setprop("/systems/electrical/extra/apu-volts", 0);
		setprop("/systems/electrical/extra/ext-hz", 0);
		setprop("/systems/electrical/extra/apu-hz", 0);
		setprop("/systems/electrical/extra/gen2-volts", 0);
		setprop("/systems/electrical/bus/gen2-hz", 0);
		if (getprop("/systems/electrical/bus/ac1") == 0) {
			setprop("/systems/electrical/bus/ac-ess", 0);
		}
		setprop("/systems/electrical/bus/dc2", 0);
		setprop("/systems/electrical/bus/dc2-amps", 0); 
		if (getprop("/systems/electrical/bus/dc1") == 0) {
			setprop("/systems/electrical/bus/dc-ess", 0);
		}
	}
	
	if (ac_ess >= 100) {
		if (galley_sw == 1 and !galley_shed) { 
			setprop("/systems/electrical/bus/galley", ac_volt_std);
		} else if (galley_sw or galley_shed) {
			setprop("/systems/electrical/bus/galley", 0);
		}
	} else {
		setprop("/systems/electrical/bus/galley", 0);
	}
	
	# Galley Shedding Logic
	if (!gen_apu and !gen_ext_sw and (!gen1_sw or !gen2_sw)) { # this is when one of the generators is not working or turned off as it reads 0 V
		setprop("/systems/electrical/extra/galleyshed", 1); 
	} else {
		setprop("/systems/electrical/extra/galleyshed", 0); 
	}
	
	# APU Generator: Make it only come online when the apu is running. This is needed to make galley shed work properly.
	if (rpmapu >= 94.9 and gen_apu_sw) {
		setprop("/systems/electrical/gen-apu", 1);
	} else {
		setprop("/systems/electrical/gen-apu", 0);
	}
	
	# Battery Amps
		if (battery1_sw) {
			setprop("/systems/electrical/battery1-amps", dc_amps_std);
		} else {
			setprop("/systems/electrical/battery1-amps", 0);
		}
		
		if (battery2_sw) {
			setprop("/systems/electrical/battery2-amps", dc_amps_std);
		} else {
			setprop("/systems/electrical/battery2-amps", 0);
		}
	
	if (getprop("/systems/electrical/bus/ac-ess") == 0) {
		setprop("systems/electrical/on", 0);
#		ai_spin.setValue(0.2);
#		aispin.stop();
		setprop("systems/electrical/outputs/adf", 0);
		setprop("systems/electrical/outputs/audio-panel", 0);
		setprop("systems/electrical/outputs/audio-panel[1]", 0);
		setprop("systems/electrical/outputs/autopilot", 0);
		setprop("systems/electrical/outputs/avionics-fan", 0);
		setprop("systems/electrical/outputs/beacon", 0);
		setprop("systems/electrical/outputs/bus", 0);
		setprop("systems/electrical/outputs/cabin-lights", 0);
		setprop("systems/electrical/outputs/dme", 0);
		setprop("systems/electrical/outputs/efis", 0);
		setprop("systems/electrical/outputs/flaps", 0);
		setprop("systems/electrical/outputs/fuel-pump", 0);
		setprop("systems/electrical/outputs/fuel-pump[1]", 0);
		setprop("systems/electrical/outputs/gps", 0);
		setprop("systems/electrical/outputs/gps-mfd", 0);
		setprop("systems/electrical/outputs/hsi", 0);
		setprop("systems/electrical/outputs/instr-ignition-switch", 0);
		setprop("systems/electrical/outputs/instrument-lights", 0);
		setprop("systems/electrical/outputs/landing-lights", 0);
		setprop("systems/electrical/outputs/map-lights", 0);
		setprop("systems/electrical/outputs/mk-viii", 0);
		setprop("systems/electrical/outputs/nav", 0);
		setprop("systems/electrical/outputs/nav[1]", 0);
		setprop("systems/electrical/outputs/pitot-head", 0);
		setprop("systems/electrical/outputs/stobe-lights", 0);
		setprop("systems/electrical/outputs/tacan", 0);
		setprop("systems/electrical/outputs/taxi-lights", 0);
		setprop("systems/electrical/outputs/transponder", 0);
		setprop("systems/electrical/outputs/turn-coordinator", 0);
	} else {
		setprop("systems/electrical/on", 1);
#		aispin.start();
		setprop("systems/electrical/outputs/adf", dc_volt_std);
		setprop("systems/electrical/outputs/audio-panel", dc_volt_std);
		setprop("systems/electrical/outputs/audio-panel[1]", dc_volt_std);
		setprop("systems/electrical/outputs/autopilot", dc_volt_std);
		setprop("systems/electrical/outputs/avionics-fan", dc_volt_std);
		setprop("systems/electrical/outputs/beacon", dc_volt_std);
		setprop("systems/electrical/outputs/bus", dc_volt_std);
		setprop("systems/electrical/outputs/cabin-lights", dc_volt_std);
		setprop("systems/electrical/outputs/dme", dc_volt_std);
		setprop("systems/electrical/outputs/efis", dc_volt_std);
		setprop("systems/electrical/outputs/flaps", dc_volt_std);
		setprop("systems/electrical/outputs/fuel-pump", dc_volt_std);
		setprop("systems/electrical/outputs/fuel-pump[1]", dc_volt_std);
		setprop("systems/electrical/outputs/gps", dc_volt_std);
		setprop("systems/electrical/outputs/gps-mfd", dc_volt_std);
		setprop("systems/electrical/outputs/hsi", dc_volt_std);
		setprop("systems/electrical/outputs/instr-ignition-switch", dc_volt_std);
		setprop("systems/electrical/outputs/instrument-lights", dc_volt_std);
		setprop("systems/electrical/outputs/landing-lights", dc_volt_std);
		setprop("systems/electrical/outputs/map-lights", dc_volt_std);
		setprop("systems/electrical/outputs/mk-viii", dc_volt_std);
		setprop("systems/electrical/outputs/nav", dc_volt_std);
		setprop("systems/electrical/outputs/nav[1]", dc_volt_std);
		setprop("systems/electrical/outputs/pitot-head", dc_volt_std);
		setprop("systems/electrical/outputs/stobe-lights", dc_volt_std);
		setprop("systems/electrical/outputs/tacan", dc_volt_std);
		setprop("systems/electrical/outputs/taxi-lights", dc_volt_std);
		setprop("systems/electrical/outputs/transponder", dc_volt_std);
		setprop("systems/electrical/outputs/turn-coordinator", dc_volt_std);
	}
}

###################
# Update Function #
###################

var update_electrical = func {
	master_elec();
}

var elec_timer = maketimer(0.2, update_electrical);
