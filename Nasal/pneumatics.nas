var pneumatics_init = func {
#Temps and Pressures. Controls ECAM indications
setprop("/controls/bleed/BMC1/tempspsi/eng1/bleedvalvepsi",0); #eng 1 bleed pressure
setprop("/controls/bleed/BMC1/tempspsi/eng1/bleedvalvetemp",0); #eng 2 bleed temp
setprop("/controls/bleed/BMC1/tempspsi/eng2/bleedvalvepsi",0); #eng 1 bleed pressure
setprop("/controls/bleed/BMC1/tempspsi/eng2/bleedvalvetemp",0); #eng 2 bleed temp
setprop("/controls/bleed/BMC1/tempspsi/eng1/downstreamfavtemp",0); #eng 1 bleed temp upstream of precooler
setprop("/controls/bleed/BMC1/tempspsi/eng2/downstreamfavtemp",0); #eng 2 bleed temp upstream of precooler
#valves
setprop("/controls/bleed/BMC1/valves/xbleed",0); #controls xbleed valve pos
setprop("/controls/bleed/BMC1/valves/eng1/bleedvalvepos",0); #eng 1 bleed off on startup
setprop("/controls/bleed/BMC1/valves/eng1/OPRESSvalve",0); #at 75 PSI the valve moves to 50 percent closed and at 85 psi moves to 100 percent
setprop("/controls/bleed/BMC1/valves/eng1/bleedengsrc","7"); 
setprop("/controls/bleed/BMC1/valves/eng1/fav",0); #limits temp upstream of bleed valve to 200C. closes as needed to maintain temp. closed on startup as engine n1 is 0
setprop("/controls/bleed/BMC1/valves/eng2/fav",0); #limits temp upstream of bleed valve to 200C. closes as needed to maintain temp. closed on startup as engine n1 is 0
setprop("/controls/bleed/BMC1/valves/eng2/bleedvalvepos",0); #eng 1 bleed off on startup
setprop("/controls/bleed/BMC1/valves/eng2/OPRESSvalve",0);
setprop("/controls/bleed/BMC1/valves/eng2/bleedengsrc","7"); 
setprop("/controls/bleed/BMC1/valves/eng2/fav",0); 
setprop("/controls/bleed/BMC1/valves/apubleed",0); #apu bleed off on startup
setprop("/controls/bleed/BMC1/valves/eng1/startvalve",0); #must be open for engine start. Opens automatically. Can get stuck (note for v.1.0)
setprop("/controls/bleed/BMC1/valves/eng2/startvalve",0);
setprop("/controls/bleed/ground",0); #ground air disco on startup. Remember that packs must be off for this, maybe make copilot screen message like 777 autopilot messages
#7th stage of HP compressor is where the bleed is normally extracted at 44 PSI +- 4 but at low N2 10th stage is selected to provide 36 +- 4 psi
#Overhead
setprop("/controls/bleed/OHP/pack1",0);
setprop("/controls/bleed/OHP/pack2",0);
setprop("/controls/bleed/OHP/bleed1",0);
setprop("/controls/bleed/OHP/bleed2",0);
setprop("/controls/bleed/OHP/xbleed",0); #controls xbleed valve MODE
setprop("/controls/bleed/OHP/bleedapu",0);
setprop("/controls/bleed/OHP/ramair",0);
}



#####################
# Bleed Valve Logic #
#####################
setlistener("/controls/bleed/OHP/bleed1", func {
var bleed1 = getprop("/controls/bleed/OHP/bleed1");
if (bleed1) {
	setprop("/controls/bleed/BMC1/valves/eng1/bleedvalvepos",1);
} else {
	setprop("/controls/bleed/BMC1/valves/eng1/bleedvalvepos",0);
}
});

setlistener("/controls/bleed/OHP/bleed2", func {
var bleed2 = getprop("/controls/bleed/OHP/bleed2");
if (bleed2) {
	setprop("/controls/bleed/BMC1/valves/eng2/bleedvalvepos",1);
} else {
	setprop("/controls/bleed/BMC1/valves/eng2/bleedvalvepos",0);
}
});

var bleed_valve_eng1 = func { #logic that closes the bleed valve
	var opress1 = getprop("/controls/bleed/BMC1/valves/eng1/OPRESSvalve");
	var apubleed = getprop("/controls/bleed/BMC1/valves/apubleed");
	var bleedohp1 = getprop("/controls/bleed/OHP/bleed1");
	var eng1valveopen = getprop("/controls/bleed/BMC1/valves/eng1/startvalve");
	#if (opress1 or firepb or leak or ovht or apubleed or eng1valveopen or !bleedohp1)
	if (opress1 or apubleed or !bleedoph1 or eng1valveopen) {
		var bleedvalve1 = getprop("/controls/bleed/BMC1/valves/eng1/bleedvalvepos");
		setprop(bleedvalve1,0);
	}
}

var bleed_valve_eng2 = func { #logic that closes the bleed valve
	var opress2 = getprop("/controls/bleed/BMC1/valves/eng2/OPRESSvalve");
	var apubleed = getprop("/controls/bleed/BMC1/valves/apubleed");
	var bleedohp2 = getprop("/controls/bleed/OHP/bleed2");
	var eng2valveopen = getprop("/controls/bleed/BMC1/valves/eng2/startvalve");
	#if (opress2 or firepb or leak or ovht or apubleed or eng1valveopen or !bleedohp2)
	if (opress2 or apubleed or !bleedoph2 or eng2valveopen) {
		var bleedvalve2 = getprop("/controls/bleed/BMC1/valves/eng2/bleedvalvepos");
		setprop(bleedvalve2,0);
	}
}

setlistener("/controls/bleed/OHP/bleedapu", func {
var bleedAPU = getprop("/controls/bleed/OHP/bleedapu");
if (bleedAPU) {
apubleedtimer.start();
} else {
apubleedtimer.stop();
setprop("/controls/bleed/BMC1/valves/xbleed",0); #close xbleed
setprop("/controls/bleed/BMC1/valves/apubleed",0); #close apu bleed
}
});

var apubleedtimer = maketimer(0.1, func {
var APU = getprop("/systems/apu/rpm");
if (APU > 94.9) {
setprop("/controls/bleed/BMC1/valves/xbleed",1); #open xbleed so apu can supply both packs
setprop("/controls/bleed/BMC1/valves/eng1/bleedvalvepos",0); #close eng bleeds
setprop("/controls/bleed/BMC1/valves/eng2/bleedvalvepos",0);
setprop("/controls/bleed/OHP/bleed1",0); #close eng bleeds on OHP
setprop("/controls/bleed/OHP/bleed2",0);
setprop("/controls/bleed/BMC1/valves/apubleed",1); #open apu bleed
apubleedtimer.stop();
}
});