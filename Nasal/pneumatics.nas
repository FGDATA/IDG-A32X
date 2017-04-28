# A320 Pneumatics System
# Joshua Davidson (it0uchpods)

#############
# Init Vars #
#############

var pneumatics_init = func {
	setprop("/controls/pneumatic/switches/bleed1", 0);
	setprop("/controls/pneumatic/switches/bleed2", 0);
	setprop("/controls/pneumatic/switches/bleedapu", 0);
	setprop("/controls/pneumatic/switches/pack1", 0);
	setprop("/controls/pneumatic/switches/pack2", 0);
	setprop("/controls/pneumatic/switches/hot-air", 0);
	setprop("/controls/pneumatic/switches/ram-air", 0);
	setprop("/controls/pneumatic/switches/pack-flo", 10); # LO: 5, NORM: 10, HI: 15
	setprop("/controls/pneumatic/switches/xbleed", 1);
	setprop("/systems/pneumatic/bleed1", 0);
	setprop("/systems/pneumatic/bleed2", 0);
	setprop("/systems/pneumatic/bleedapu", 0);
	setprop("/systems/pneumatic/total-psi", 0);
	setprop("/systems/pneumatic/start-psi", 0);
	setprop("/systems/pneumatic/pack1", 0);
	setprop("/systems/pneumatic/pack2", 0);
	setprop("/systems/pneumatic/startpsir", 0);
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
	var pack_flo_sw = getprop("/controls/pneumatic/switches/pack-flo", 1);
	var xbleed_sw = getprop("/controls/pneumatic/switches/xbleed");
	var pack1 = getprop("/systems/pneumatic/pack1");
	var pack2 = getprop("/systems/pneumatic/pack2");
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
	
	if ( stateL == 1 or stateR == 1) {
		setprop("/systems/pneumatic/start-psi", 18);
	} else {
		setprop("/systems/pneumatic/start-psi", 0);
	}
	
	var start_psi = getprop("/systems/pneumatic/start-psi");
	
	if ((bleed1 + bleed2 + bleedapu) > 42) {
		setprop("/systems/pneumatic/total-psi", 42);
	} else {
		var total_psi_calc = ((bleed1 + bleed2 + bleedapu) - start_psi); # - pack_psi;
		setprop("/systems/pneumatic/total-psi", total_psi_calc);
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
