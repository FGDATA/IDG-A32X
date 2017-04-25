# A320 Pneumatics System
# Jonathan Redpath (legoboyvdlp) and Joshua Davidson (it0uchpods)

#############
# Init Vars #
#############

# 7th stage of HP compressor is where the bleed is normally extracted at 44 PSI +- 4 but at low N2 10th stage is selected to provide 36 +- 4 psi
var pneumatics_init = func {
	setprop("/systems/pneumatic/tempspsi/eng1/bleedvalvepsi", 0);
	setprop("/systems/pneumatic/tempspsi/eng1/bleedvalvetemp", 0);
	setprop("/systems/pneumatic/tempspsi/eng2/bleedvalvepsi", 0);
	setprop("/systems/pneumatic/tempspsi/eng2/bleedvalvetemp", 0);
	setprop("/systems/pneumatic/tempspsi/eng1/downstreamfavtemp", 0);
	setprop("/systems/pneumatic/tempspsi/eng2/downstreamfavtemp", 0);
	setprop("/systems/pneumatic/valves/xbleed", 0);
	setprop("/systems/pneumatic/valves/eng1/bleedvalvepos", 0);
	setprop("/systems/pneumatic/valves/eng1/OPRESSvalve", 0);
	setprop("/systems/pneumatic/valves/eng1/bleedengsrc", "7");
	setprop("/systems/pneumatic/valves/eng1/fav", 0);
	setprop("/systems/pneumatic/valves/eng2/fav", 0);
	setprop("/systems/pneumatic/valves/eng2/bleedvalvepos", 0);
	setprop("/systems/pneumatic/valves/eng2/OPRESSvalve", 0);
	setprop("/systems/pneumatic/valves/eng2/bleedengsrc", "7");
	setprop("/systems/pneumatic/valves/eng2/fav", 0);
	setprop("/systems/pneumatic/valves/apubleed", 0);
	setprop("/systems/pneumatic/valves/eng1/startvalve", 0);
	setprop("/systems/pneumatic/valves/eng2/startvalve", 0);
	setprop("/controls/bleed/ground", 0);
	setprop("/controls/bleed/OHP/pack1", 0);
	setprop("/controls/bleed/OHP/pack2", 0);
	setprop("/controls/bleed/OHP/bleed1", 0);
	setprop("/controls/bleed/OHP/bleed2", 0);
	setprop("/controls/bleed/OHP/xbleed", 0);
	setprop("/controls/bleed/OHP/bleedapu", 0);
	setprop("/controls/bleed/OHP/ramair", 0);
	pneu_timer.start();
}

#######################
# Main Pneumatic Loop #
#######################

var master_pneu = func {
	var bleed1 = getprop("/controls/bleed/OHP/bleed1");
	var bleed2 = getprop("/controls/bleed/OHP/bleed2");
	var apubleedsw = getprop("/controls/bleed/OHP/bleedapu");
	var apubleed = getprop("/systems/pneumatic/valves/apubleed");
	var opress1 = getprop("/systems/pneumatic/valves/eng1/OPRESSvalve");
	var bleedohp1 = getprop("/controls/bleed/OHP/bleed1");
	var eng1valveopen = getprop("/systems/pneumatic/valves/eng1/startvalve");
	var opress2 = getprop("/systems/pneumatic/valves/eng2/OPRESSvalve");
	var bleedohp2 = getprop("/controls/bleed/OHP/bleed2");
	var eng2valveopen = getprop("/systems/pneumatic/valves/eng2/startvalve");
	
	if (bleed1) {
		setprop("/systems/pneumatic/valves/eng1/bleedvalvepos", 1);
	} else {
		setprop("/systems/pneumatic/valves/eng1/bleedvalvepos", 0);
	}

	if (bleed2) {
		setprop("/systems/pneumatic/valves/eng2/bleedvalvepos", 1);
	} else {
		setprop("/systems/pneumatic/valves/eng2/bleedvalvepos", 0);
	}

	if (opress1 or apubleed or !bleedohp1 or eng1valveopen) {
		setprop("/systems/pneumatic/valves/eng1/bleedvalvepos", 0);
	}
	
	if (opress2 or apubleed or !bleedohp2 or eng2valveopen) {
		setprop("/systems/pneumatic/valves/eng2/bleedvalvepos", 0);
	}

	if (apubleedsw) {
		apubleedtimer.start();
	} else {
		apubleedtimer.stop();
		setprop("/systems/pneumatic/valves/xbleed", 0);
		setprop("/systems/pneumatic/valves/apubleed", 0);
	}
}

var apubleedtimer = maketimer(0.5, func {
	var APU = getprop("/systems/apu/rpm");
	if (APU > 94.9) {
		apubleedtimer.stop();
		setprop("/systems/pneumatic/valves/xbleed", 1);
		setprop("/systems/pneumatic/valves/eng1/bleedvalvepos", 0);
		setprop("/systems/pneumatic/valves/eng2/bleedvalvepos", 0);
		setprop("/controls/bleed/OHP/bleed1", 0);
		setprop("/controls/bleed/OHP/bleed2", 0);
		setprop("/systems/pneumatic/valves/apubleed", 1);
	}
});

###################
# Update Function #
###################

var update_pneumatic = func {
	master_pneu();
}

var pneu_timer = maketimer(0.5, update_pneumatic);
