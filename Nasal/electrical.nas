# A3XX Electrical System
# Joshua Davidson (it0uchpods) and Jonathan Redpath (legoboyvdlp)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

var ac_volt_std = 115;
var ac_volt_min = 110;
var dc_volt_std = 28;
var dc_volt_min = 25;
var dc_amps_std = 150;
var ac_hz_std = 400;
var ac1_src = "XX";
var ac2_src = "XX";
var power_consumption = nil;
var screen_power_consumption = nil;
var screens = nil;
var lpower_consumption = nil;
var light_power_consumption = nil;
var lights = nil;

setlistener("/sim/signals/fdm-initialized", func {
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
	var ac_ess_shed = getprop("/systems/electrical/bus/ac-ess-shed");
	var dc1 = getprop("/systems/electrical/bus/dc1");
	var dc2 = getprop("/systems/electrical/bus/dc2");
	var dcbat = getprop("/systems/electrical/bus/dcbat");
	var dc_ess = getprop("/systems/electrical/bus/dc-ess");
	var gen_1_volts = getprop("/systems/electrical/extra/gen1-volts");
	var gen_2_volts = getprop("/systems/electrical/extra/gen2-volts");
	var galley_shed = getprop("/systems/electrical/extra/galleyshed");
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
	var bat1_volts = getprop("/systems/electrical/battery1-volts");
	var bat2_volts = getprop("/systems/electrical/battery2-volts");
	var replay = getprop("/sim/replay/replay-state");
	var wow = getprop("/gear/gear[1]/wow");
});

# Power Consumption, cockpit screens
# According to pprune, each LCD uses 60W. Will assume that it reduces linearly to ~50 watts when dimmed, and to 0 watts when off

var screen = {
	name: "",
	type: "", # LCD or CRT, will be used later when we have CRTs
	max_watts: 0,
	dim_watts: 0,
	dim_prop: "",
	elec_prop: "",
	power_consumption: func() {
		var dim_prop = me.dim_prop;
		if (getprop(me.dim_prop) != 0) {
			screen_power_consumption = (50 + (10 * getprop(dim_prop)));
		} else {
			screen_power_consumption = 0;
		} 
		return screen_power_consumption;
	},
	new: func(name,type,max_watts,dim_watts,dim_prop,elec_prop) {
		var s = {parents:[screen]};
		
		s.name = name;
		s.type = type;
		s.max_watts = max_watts;
		s.dim_watts = dim_watts;
		s.dim_prop = dim_prop;
		s.elec_prop = elec_prop;
		
		return s;
	}
};

# Power Consumption, lights
# from docs found on google

var light = {
	name: "",
	max_watts: 0,
	control_prop: "",
	elec_prop: "",
	power_consumption: func() {
		
		if (getprop(me.control_prop) != 0 and getprop(me.elec_prop) != 0) {
			light_power_consumption = me.max_watts;
		} else {
			light_power_consumption = 0;
		} 
		return light_power_consumption;
	},
	new: func(name,max_watts,control_prop,elec_prop) {
		var l = {parents:[light]};
		
		l.name = name;
		l.max_watts = max_watts;
		l.control_prop = control_prop;
		l.elec_prop = elec_prop;
		
		return l;
	}
};

# Main Elec System

var ELEC = {
	init: func() {
		setprop("/controls/switches/annun-test", 0);
		setprop("/systems/electrical/nav-lights-power", 0);
		setprop("/controls/electrical/switches/galley", 1);
		setprop("/controls/electrical/switches/idg1", 0);
		setprop("/controls/electrical/switches/idg2", 0);
		setprop("/controls/electrical/switches/gen1", 1);
		setprop("/controls/electrical/switches/gen2", 1);
		setprop("/controls/electrical/switches/emer-gen", 0);
		setprop("/controls/electrical/switches/gen-apu", 1);
		setprop("/controls/electrical/switches/gen-ext", 0);
		setprop("/controls/electrical/switches/apu-ext-crosstie", 1);
		setprop("/controls/electrical/switches/ac-ess-feed", 0);
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
		setprop("/systems/electrical/bus/ac-ess-shed", 0);
		setprop("/systems/electrical/extra/ext-volts", 0);
		setprop("/systems/electrical/extra/apu-volts", 0);
		setprop("/systems/electrical/extra/gen1-volts", 0);
		setprop("/systems/electrical/extra/gen2-volts", 0);
		setprop("/systems/electrical/extra/ext-hz", 0);
		setprop("/systems/electrical/extra/apu-hz", 0);
		setprop("/systems/electrical/extra/galleyshed", 0);
		setprop("/systems/electrical/gen-apu", 0);
		setprop("/systems/electrical/gen-ext", 0);
		setprop("/systems/electrical/on", 0);
		setprop("/systems/electrical/ac1-src", "XX");
		setprop("/systems/electrical/ac2-src", "XX");
		setprop("/systems/electrical/galley-fault", 0);
		setprop("/systems/electrical/idg1-fault", 0);
		setprop("/systems/electrical/gen1-fault", 0);
		setprop("/systems/electrical/apugen-fault", 0);
		setprop("/systems/electrical/batt1-fault", 0);
		setprop("/systems/electrical/batt2-fault", 0);
		setprop("/systems/electrical/ac-ess-feed-fault", 0);
		setprop("/systems/electrical/gen2-fault", 0);
		setprop("/systems/electrical/idg2-fault", 0);
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
		
		screens = [screen.new(name: "DU1", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du1", elec_prop:"/systems/electrical/bus/ac-ess"),
			screen.new(name: "DU2", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du2", elec_prop:"/systems/electrical/bus/ac-ess-shed"),
			screen.new(name: "DU3", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du3", elec_prop:"/systems/electrical/bus/ac-ess"),
			screen.new(name: "DU4", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du4", elec_prop:"/systems/electrical/bus/ac2"),
			screen.new(name: "DU5", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du5", elec_prop:"/systems/electrical/bus/ac2"),
			screen.new(name: "DU6", type:"LCD", max_watts:60, dim_watts:50, dim_prop:"/controls/lighting/DU/du6", elec_prop:"/systems/electrical/bus/ac2")];
		
		lights = [light.new(name: "logo-left", max_watts:31.5, control_prop:"/sim/model/lights/logo-lights", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "logo-right", max_watts:31.5, control_prop:"/sim/model/lights/logo-lights", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "upper-beacon", max_watts:40, control_prop:"/sim/model/lights/beacon/state", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "lower-beacon", max_watts:40, control_prop:"/sim/model/lights/beacon/state", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "strobe-left", max_watts:38, control_prop:"/sim/model/lights/strobe/state", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "strobe-right", max_watts:38, control_prop:"/sim/model/lights/strobe/state", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "tail-strobe", max_watts:12, control_prop:"/sim/model/lights/tailstrobe/state", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "tail-strobe-ctl", max_watts:30, control_prop:"/sim/model/lights/tailstrobe/state", elec_prop:"/systems/electrical/bus/ac2"), 
			light.new(name: "tail-nav", max_watts:12, control_prop:"/sim/model/lights/nav-lights", elec_prop:"/systems/electrical/nav-lights-power"),
			light.new(name: "left-nav", max_watts:12, control_prop:"/sim/model/lights/nav-lights", elec_prop:"/systems/electrical/nav-lights-power"),
			light.new(name: "right-nav", max_watts:12, control_prop:"/sim/model/lights/nav-lights", elec_prop:"/systems/electrical/nav-lights-power"),
			light.new(name: "left-land", max_watts:39, control_prop:"/controls/lighting/landing-lights[1]", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "right-land", max_watts:39, control_prop:"/controls/lighting/landing-lights[2]", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "left-taxi", max_watts:31, control_prop:"/sim/model/lights/nose-lights", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "right-taxi", max_watts:31, control_prop:"/sim/model/lights/nose-lights", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "left-turnoff", max_watts:21, control_prop:"/controls/lighting/leftturnoff", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "right-turnoff", max_watts:21, control_prop:"/controls/lighting/rightturnoff", elec_prop:"/systems/electrical/bus/ac2"),
			light.new(name: "left-wing", max_watts:24, control_prop:"/controls/lighting/wing-lights", elec_prop:"/systems/electrical/bus/ac1"),
			light.new(name: "right-wing", max_watts:24, control_prop:"/controls/lighting/wing-lights", elec_prop:"/systems/electrical/bus/ac2")];
	},
	loop: func() {
		galley_sw = getprop("/controls/electrical/switches/galley");
		idg1_sw = getprop("/controls/electrical/switches/idg1");
		idg2_sw = getprop("/controls/electrical/switches/idg2");
		gen1_sw = getprop("/controls/electrical/switches/gen1");
		gen2_sw = getprop("/controls/electrical/switches/gen2");
		gen_apu_sw = getprop("/controls/electrical/switches/gen-apu");
		gen_ext_sw = getprop("/controls/electrical/switches/gen-ext");
		apu_ext_crosstie_sw = getprop("/controls/electrical/switches/apu-ext-crosstie");
		ac_ess_feed_sw = getprop("/controls/electrical/switches/ac-ess-feed");
		battery1_sw = getprop("/controls/electrical/switches/battery1");
		battery2_sw = getprop("/controls/electrical/switches/battery2");
		battery1_volts = getprop("/systems/electrical/battery1-volts");
		battery2_volts = getprop("/systems/electrical/battery2-volts");
		rpmapu = getprop("/systems/apu/rpm");
		extpwr_on = getprop("/controls/switches/cart");
		stateL = getprop("/engines/engine[0]/state");
		stateR = getprop("/engines/engine[1]/state");
		ac1 = getprop("/systems/electrical/bus/ac1");
		ac2 = getprop("/systems/electrical/bus/ac2");
		ac_ess = getprop("/systems/electrical/bus/ac-ess");
		ac_ess_shed = getprop("/systems/electrical/bus/ac-ess-shed");
		dc1 = getprop("/systems/electrical/bus/dc1");
		dc2 = getprop("/systems/electrical/bus/dc2");
		dcbat = getprop("/systems/electrical/bus/dcbat");
		dc_ess = getprop("/systems/electrical/bus/dc-ess");
		gen_1_volts = getprop("/systems/electrical/extra/gen1-volts");
		gen_2_volts = getprop("/systems/electrical/extra/gen2-volts");
		galley_shed = getprop("/systems/electrical/extra/galleyshed");
		emergen = getprop("/controls/electrical/switches/emer-gen");
		ias = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
		rat = getprop("/controls/hydraulic/rat");
		manrat = getprop("/controls/hydraulic/rat-man");
		ac_ess_fail = getprop("/systems/failures/elec-ac-ess");
		batt1_fail = getprop("/systems/failures/elec-batt1");
		batt2_fail = getprop("/systems/failures/elec-batt2");
		gallery_fail = getprop("/systems/failures/elec-galley");
		genapu_fail = getprop("/systems/failures/elec-genapu");
		gen1_fail = getprop("/systems/failures/elec-gen1");
		gen2_fail = getprop("/systems/failures/elec-gen2");
		replay = getprop("/sim/replay/replay-state");
		wow = getprop("/gear/gear[1]/wow");
		
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
		
		if (getprop("/systems/electrical/battery1-amps") > 120 or getprop("/systems/electrical/battery2-amps") > 120) {
			setprop("/systems/electrical/bus/dcbat", dc_volt_std);
		} else {
			setprop("/systems/electrical/bus/dcbat", 0);
		}
		
		dcbat = getprop("/systems/electrical/bus/dcbat");
		
		if (extpwr_on and gen_ext_sw) {
			setprop("/systems/electrical/gen-ext", 1);
		} else {
			setprop("/systems/electrical/gen-ext", 0);
		} 
		
		if (rpmapu >= 94.9 and gen_apu_sw and !gen_ext_sw) {
			setprop("/systems/electrical/gen-apu", 1);
		} else {
			setprop("/systems/electrical/gen-apu", 0);
		}
		
		gen_apu = getprop("/systems/electrical/gen-apu");
		gen_ext = getprop("/systems/electrical/gen-ext");
		
		# Left cross tie yes?
		if (stateL == 3 and gen1_sw and !gen1_fail) {
			setprop("/controls/electrical/xtie/xtieR", 1);
		} else if (extpwr_on and gen_ext_sw) {
			setprop("/controls/electrical/xtie/xtieR", 1);
		} else if (rpmapu >= 94.9 and gen_apu_sw and !genapu_fail) {
			setprop("/controls/electrical/xtie/xtieR", 1);
		} else {
			setprop("/controls/electrical/xtie/xtieR", 0);
		}
		
		# Right cross tie yes?
		if (stateR == 3 and gen2_sw and !gen2_fail) {
			setprop("/controls/electrical/xtie/xtieL", 1);
		} else if (extpwr_on and gen_ext_sw) {
			setprop("/controls/electrical/xtie/xtieL", 1);
		} else if (rpmapu >= 94.9 and gen_apu_sw and !genapu_fail) {
			setprop("/controls/electrical/xtie/xtieL", 1);
		} else {
			setprop("/controls/electrical/xtie/xtieL", 0);
		}
		
		xtieL = getprop("/controls/electrical/xtie/xtieL");
		xtieR = getprop("/controls/electrical/xtie/xtieR");
		
		# Left DC bus yes?
		if (stateL == 3 and gen1_sw and !gen1_fail) {
			setprop("/systems/electrical/bus/dc1", dc_volt_std);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
		} else if (extpwr_on and gen_ext_sw and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/dc1", dc_volt_std);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
		} else if (gen_apu and !genapu_fail and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/dc1", dc_volt_std);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
		} else if (apu_ext_crosstie_sw == 1 and xtieL) {
			setprop("/systems/electrical/bus/dc1", dc_volt_std);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/bus/dc1-amps", dc_amps_std); 
		} else if (emergen) {
			setprop("/systems/electrical/bus/dc1", 0);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/bus/dc1-amps", 0); 
		} else if (dcbat and ias >= 50) {
			setprop("/systems/electrical/bus/dc1", 0);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/bus/dc1-amps", 0); 
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
		} else if (extpwr_on and gen_ext_sw and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/dc2", dc_volt_std);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
		} else if (gen_apu and !genapu_fail and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/dc2", dc_volt_std);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
		} else if (apu_ext_crosstie_sw == 1  and xtieR) {
			setprop("/systems/electrical/bus/dc2", dc_volt_std);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/bus/dc2-amps", dc_amps_std); 
		} else if (emergen) {
			setprop("/systems/electrical/bus/dc2", 0);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/bus/dc2-amps", 0); 
		} else if (dcbat and ias >= 50) {
			setprop("/systems/electrical/bus/dc2", 0);
			setprop("/systems/electrical/bus/dc-ess", dc_volt_std);
			setprop("/systems/electrical/bus/dc2-amps", 0); 
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
			ac1_src = "GEN";
		} else if (extpwr_on and gen_ext_sw and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/ac1", ac_volt_std);
			ac1_src = "EXT";
		} else if (gen_apu and !genapu_fail and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/ac1", ac_volt_std);
			ac1_src = "APU";
		} else if (apu_ext_crosstie_sw == 1 and xtieL) {
			setprop("/systems/electrical/bus/ac1", ac_volt_std);
			ac1_src = "XTIE";
		} else if (emergen) {
			setprop("/systems/electrical/bus/ac1", 0);
			ac1_src = "ESSRAT";
		} else if (dcbat and ias >= 50) {
			setprop("/systems/electrical/bus/ac1", 0);
			ac1_src = "ESSBAT";
		} else {
			setprop("/systems/electrical/bus/ac1", 0);
			ac1_src = "XX";
		}
		
		# Right AC bus yes?
		if (stateR == 3 and gen2_sw and !gen2_fail) {
			setprop("/systems/electrical/bus/ac2", ac_volt_std);
			ac2_src = "GEN";
		} else if (extpwr_on and gen_ext_sw and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/ac2", ac_volt_std);
			ac2_src = "EXT";
		} else if (gen_apu and !genapu_fail and apu_ext_crosstie_sw) {
			setprop("/systems/electrical/bus/ac2", ac_volt_std);
			ac2_src = "APU";
		} else if (apu_ext_crosstie_sw == 1  and xtieR) {
			setprop("/systems/electrical/bus/ac2", ac_volt_std);
			ac2_src = "XTIE";
		} else if (emergen) {
			setprop("/systems/electrical/bus/ac2", 0);
			ac2_src = "ESSRAT";
		} else if (dcbat and ias >= 50) {
			setprop("/systems/electrical/bus/ac2", 0);
			ac2_src = "ESSBAT";
		} else {
			setprop("/systems/electrical/bus/ac2", 0);
			ac2_src = "XX";
		}
		
		ac1 = getprop("/systems/electrical/bus/ac1");
		ac2 = getprop("/systems/electrical/bus/ac2");
		
		# AC ESS bus yes?
		if (!ac_ess_fail) {
			if (ac1 >= 110 and !ac_ess_feed_sw) {
				setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
			} else if (ac2 >= 110 and ac_ess_feed_sw) {
				setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
			} else if (emergen or (dcbat and ias >= 50)) {
				setprop("/systems/electrical/bus/ac-ess", ac_volt_std);
			} else {
				setprop("/systems/electrical/bus/ac-ess", 0);
			}
		} else {
			setprop("/systems/electrical/bus/ac-ess", 0);
		}
		
		ac_ess = getprop("/systems/electrical/bus/ac-ess");
		
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
		
		if (ac1 == 0 and ac2 == 0 and emergen == 0) {
			setprop("/systems/electrical/bus/ac-ess-shed", 0);
		} else {
			setprop("/systems/electrical/bus/ac-ess-shed", ac_volt_std);
		}
		
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
		
		if (((ac1 == 0 and ac2 == 0 and ias >= 100) or manrat) and replay == 0) {
			setprop("/controls/hydraulic/rat-deployed", 1);
			setprop("/controls/hydraulic/rat", 1);
			setprop("/controls/electrical/switches/emer-gen", 1);
		}
		
		if (ias < 100 or (ac1 == 1) or (ac2 == 1)) {
			setprop("/controls/electrical/switches/emer-gen", 0);
		}
		
		dc1 = getprop("/systems/electrical/bus/dc1");
		dc2 = getprop("/systems/electrical/bus/dc2");
		
		if (battery1_volts < 27.9 and (dc1 > 25 or dc2 > 25) and battery1_sw and !batt1_fail) {
			decharge1.stop();
			charge1.start();
		} else if (battery1_volts == 27.9 and (dc1 > 25 or dc2 > 25) and battery1_sw and !batt1_fail) {
			charge1.stop();
			decharge1.stop();
		} else if (battery1_sw and !batt1_fail) {
			charge1.stop();
			decharge1.start();
		} else {
			decharge1.stop();
			charge1.stop();
		}
		
		if (battery2_volts < 27.9 and (dc1 > 25 or dc2 > 25) and battery2_sw and !batt2_fail) {
			decharge2.stop();
			charge2.start();
		} else if (battery2_volts == 27.9 and (dc1 > 25 or dc2 > 25) and battery2_sw and !batt2_fail) {
			charge2.stop();
			decharge2.stop();
		} else if (battery2_sw and !batt2_fail) {
			charge2.stop();
			decharge2.start();
		} else {
			decharge2.stop();
			charge2.stop();
		}
			
		if (getprop("/systems/electrical/bus/ac-ess") < 110) {
			if (getprop("/it-autoflight/output/ap1") == 1) {
				setprop("/it-autoflight/input/ap1", 0);
			}
			if (getprop("/it-autoflight/output/ap2") == 1) {
				setprop("/it-autoflight/input/ap2", 0);
			}
			setprop("systems/electrical/on", 0);
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
			setprop("/controls/lighting/fcu-panel-norm", 0);
			setprop("/controls/lighting/main-panel-norm", 0);
			setprop("/controls/lighting/overhead-panel-norm", 0);
		} else {
			setprop("/systems/electrical/on", 1);
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
			setprop("/controls/lighting/fcu-panel-norm", getprop("/controls/lighting/fcu-panel-knb"));
			setprop("/controls/lighting/main-panel-norm", getprop("/controls/lighting/main-panel-knb"));
			setprop("/controls/lighting/overhead-panel-norm", getprop("/controls/lighting/overhead-panel-knb"));
		}
		
		setprop("/systems/electrical/ac1-src", ac1_src);
		setprop("/systems/electrical/ac2-src", ac2_src);
		
		# Fault lights
		if (gallery_fail and galley_sw) {
			setprop("/systems/electrical/galley-fault", 1);
		} else {
			setprop("/systems/electrical/galley-fault", 0);
		}
		
		if (batt1_fail and battery1_sw) {
			setprop("/systems/electrical/batt1-fault", 1);
		} else {
			setprop("/systems/electrical/batt1-fault", 0);
		}
		
		if (batt2_fail and battery2_sw) {
			setprop("/systems/electrical/batt2-fault", 1);
		} else {
			setprop("/systems/electrical/batt2-fault", 0);
		}
		
		if ((gen1_fail and gen1_sw) or (gen1_sw and stateL != 3)) {
			setprop("/systems/electrical/gen1-fault", 1);
		} else {
			setprop("/systems/electrical/gen1-fault", 0);
		}
		
		if (ac_ess_fail) {
			setprop("/systems/electrical/ac-ess-feed-fault", 1);
		} else {
			setprop("/systems/electrical/ac-ess-feed-fault", 0);
		}
		
		if (genapu_fail and gen_apu_sw) {
			setprop("/systems/electrical/apugen-fault", 1);
		} else {
			setprop("/systems/electrical/apugen-fault", 0);
		}
		
		if ((gen2_fail and gen2_sw) or (gen2_sw and stateR != 3)) {
			setprop("/systems/electrical/gen2-fault", 1);
		} else {
			setprop("/systems/electrical/gen2-fault", 0);
		}
		
		foreach(var screena; screens) { 
			power_consumption = screena.power_consumption();
			if (getprop(screena.elec_prop) != 0) {
				setprop("/systems/electrical/DU/" ~ screena.name ~ "/watts", power_consumption);
			} else {
				setprop("/systems/electrical/DU/" ~ screena.name ~ "/watts", 0);
			}
		}
		
		foreach(var lighta; lights) { 
			power_consumption = lighta.power_consumption();
			if (getprop(screena.elec_prop) != 0 and getprop(lighta.control_prop) != 0) {
				setprop("/systems/electrical/light/" ~ lighta.name ~ "/watts", power_consumption);
			} else {
				setprop("/systems/electrical/light/" ~ lighta.name ~ "/watts", 0);
			}
		}
	},
};

var charge1 = maketimer(6, func {
	bat1_volts = getprop("/systems/electrical/battery1-volts");
	setprop("/systems/electrical/battery1-volts", bat1_volts + 0.1);
});
var charge2 = maketimer(6, func {
	bat2_volts = getprop("/systems/electrical/battery2-volts");
	setprop("/systems/electrical/battery2-volts", bat2_volts + 0.1);
});
var decharge1 = maketimer(69, func { # interval is at 69 seconds, to allow about 30 min from 25.9
	bat1_volts = getprop("/systems/electrical/battery1-volts");
	setprop("/systems/electrical/battery1-volts", bat1_volts - 0.1);
});
var decharge2 = maketimer(69, func {
	bat2_volts = getprop("/systems/electrical/battery2-volts");
	setprop("/systems/electrical/battery2-volts", bat2_volts - 0.1);
});
