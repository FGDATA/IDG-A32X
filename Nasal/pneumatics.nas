# A320 Pneumatics System
# Joshua Davidson (it0uchpods) and Jonathan Redpath (legoboyvdlp)

#############
# Init Vars #
#############

var pneu_init = func {
	setprop("/controls/pneumatic/switches/bleed1", 0);
	setprop("/controls/pneumatic/switches/bleed2", 0);
	setprop("/controls/pneumatic/switches/bleedapu", 0);
	setprop("/controls/pneumatic/switches/groundair", 0);
	setprop("/controls/pneumatic/switches/pack1", 0);
	setprop("/controls/pneumatic/switches/pack2", 0);
	setprop("/controls/pneumatic/switches/hot-air", 0);
	setprop("/controls/pneumatic/switches/ram-air", 0);
	setprop("/controls/pneumatic/switches/pack-flo", 9); # LO: 7, NORM: 9, HI: 11.
	setprop("/controls/pneumatic/switches/xbleed", 1); # SHUT: 0, AUTO: 1, OPEN: 2. # I will simulate later, once I get the knob animated. -JD
	setprop("/systems/pneumatic/bleed1", 0);
	setprop("/systems/pneumatic/bleed2", 0);
	setprop("/systems/pneumatic/bleedapu", 0);
	setprop("/systems/pneumatic/groundair", 0);
	setprop("/systems/pneumatic/total-psi", 0);
	setprop("/systems/pneumatic/start-psi", 0);
	setprop("/systems/pneumatic/pack-psi", 0);	
	setprop("/systems/pneumatic/pack1", 0);
	setprop("/systems/pneumatic/pack2", 0);
	setprop("/systems/pneumatic/startpsir", 0);
	setprop("/systems/pneumatic/eng1-starter", 0);
	setprop("/systems/pneumatic/eng2-starter", 0);
	pneu_timer.start();
}

#######################
# Main Pneumatic Loop #
#######################

var master_pneu = func {
	var bleed1_sw = getprop("/controls/pneumatic/switches/bleed1");
	var bleed2_sw = getprop("/controls/pneumatic/switches/bleed2");
	var bleedapu_sw = getprop("/controls/pneumatic/switches/bleedapu");
	var pack1_sw = getprop("/controls/pneumatic/switches/pack1");
	var pack2_sw = getprop("/controls/pneumatic/switches/pack2");
	var hot_air_sw = getprop("/controls/pneumatic/switches/hot-air");
	var ram_air_sw	= getprop("/controls/pneumatic/switches/ram-air");
	var pack_flo_sw = getprop("/controls/pneumatic/switches/pack-flo");
	var xbleed_sw = getprop("/controls/pneumatic/switches/xbleed");
	var eng1_starter = getprop("/systems/pneumatic/eng1-starter");
	var eng2_starter = getprop("/systems/pneumatic/eng2-starter");
	var groundair = getprop("/systems/pneumatic/groundair");
	var groundair_supp = getprop("/controls/pneumatic/switches/groundair");
	var rpmapu = getprop("/systems/apu/rpm");
	var stateL = getprop("/engines/engine[0]/state");
	var stateR = getprop("/engines/engine[1]/state");
	
	# Air Sources/PSI
	if (rpmapu >= 94.9 and bleedapu_sw) {
		setprop("/systems/pneumatic/bleedapu", 34);
	} else {
		setprop("/systems/pneumatic/bleedapu", 0);
	}
	
	if (stateL == 3 and bleed1_sw) {
		setprop("/systems/pneumatic/bleed1", 31);
	} else {
		setprop("/systems/pneumatic/bleed1", 0);
	}
	
	if (stateR == 3 and bleed2_sw) {
		setprop("/systems/pneumatic/bleed2", 32);
	} else {
		setprop("/systems/pneumatic/bleed2", 0);
	}
	
	var bleed1 = getprop("/systems/pneumatic/bleed1");
	var bleed2 = getprop("/systems/pneumatic/bleed2");
	var bleedapu = getprop("/systems/pneumatic/bleedapu");
	var ground = getprop("/systems/pneumatic/groundair");
	
	if (stateL == 1 or stateR == 1) {
		setprop("/systems/pneumatic/start-psi", 18);
	} else {
		setprop("/systems/pneumatic/start-psi", 0);
	}
	
	if (pack1_sw == 1 and (bleed1 >= 20 or bleedapu >= 20 or ground >= 20) and eng1_starter == 0 and eng2_starter == 0) {
		setprop("/systems/pneumatic/pack1", pack_flo_sw);
	} else {
		setprop("/systems/pneumatic/pack1", 0);
	}
	
	if (pack2_sw == 1 and (bleed2 >= 20 or bleedapu >= 20 or ground >= 20) and eng1_starter == 0 and eng2_starter == 0) {
		setprop("/systems/pneumatic/pack2", pack_flo_sw);
	} else {
		setprop("/systems/pneumatic/pack2", 0);
	}
	
	var pack1 = getprop("/systems/pneumatic/pack1");
	var pack2 = getprop("/systems/pneumatic/pack2");
	
	if (pack1_sw == 1 and pack2_sw == 1) {
		setprop("/systems/pneumatic/pack-psi", pack1 + pack2);
	} else if (pack1_sw == 0 and pack2_sw == 0) {
		setprop("/systems/pneumatic/pack-psi", 0);
	} else {
		setprop("/systems/pneumatic/pack-psi", pack1 + pack2 + 5);
	}
	
	var pack_psi = getprop("/systems/pneumatic/pack-psi");
	var start_psi = getprop("/systems/pneumatic/start-psi");
	
	if ((bleed1 + bleed2 + bleedapu) > 42) {
		setprop("/systems/pneumatic/total-psi", 42);
	} else {
		var total_psi_calc = ((bleed1 + bleed2 + bleedapu + ground) - start_psi - pack_psi);
		setprop("/systems/pneumatic/total-psi", total_psi_calc);
	}
	
	if (groundair_supp) { 
		setprop("/systems/pneumatic/groundair", 39);
	} else {
		setprop("/systems/pneumatic/groundair", 0);
	}
	
	var total_psi = getprop("/systems/pneumatic/total-psi");
}

###################
# Update Function #
###################

var update_pneumatic = func {
	master_pneu();
}

var pneu_timer = maketimer(0.2, update_pneumatic);
