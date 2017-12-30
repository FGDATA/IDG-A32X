# A3XX ECAM Messages
# Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

setprop("/ECAM/left-msg", "NONE");
setprop("/position/gear-agl-ft", 0);
setprop("/ECAM/Lower/page", "fctl");
# w = White, b = Blue, g = Green, a = Amber, r = Red

var ECAM = {
	init: func() {
		setprop("/ECAM/phase-1-inhibit", 0);
		setprop("/ECAM/phase-2-inhibit", 0);
		setprop("/ECAM/phase-3-inhibit", 0);
		setprop("/ECAM/phase-4-inhibit", 0);
		setprop("/ECAM/phase-5-inhibit", 0);
		setprop("/ECAM/phase-6-inhibit", 0);
		setprop("/ECAM/phase-7-inhibit", 0);
		setprop("/ECAM/phase-8-inhibit", 0);
		setprop("/ECAM/phase-9-inhibit", 0);
		setprop("/ECAM/phase-10-inhibit", 0);
		var stateL = getprop("/engines/engine[0]/state");
		var stateR = getprop("/engines/engine[1]/state");
		var thrustL = getprop("/systems/thrust/state1");
		var thrustR = getprop("/systems/thrust/state2");
		var elec = getprop("/systems/electrical/on");
		var speed = getprop("/velocities/airspeed-kt");
		var wowL = getprop("/gear/gear[1]/wow");
		var altitude = getprop("/position/gear-agl-ft");
		var phase1inhibit = getprop("/ECAM/phase-1-inhibit");
		var phase2inhibit = getprop("/ECAM/phase-2-inhibit");
		var phase3inhibit = getprop("/ECAM/phase-3-inhibit");
		var phase4inhibit = getprop("/ECAM/phase-4-inhibit");
		var phase5inhibit = getprop("/ECAM/phase-5-inhibit");
		var phase6inhibit = getprop("/ECAM/phase-6-inhibit");
		var phase7inhibit = getprop("/ECAM/phase-7-inhibit");
		var phase8inhibit = getprop("/ECAM/phase-8-inhibit");
		var phase9inhibit = getprop("/ECAM/phase-9-inhibit");
		var phase10inhibit = getprop("/ECAM/phase-10-inhibit");
	},
	MSGclr: func() {
		setprop("/ECAM/ecam-checklist-active", 0);
		setprop("/ECAM/left-msg", "NONE");
		setprop("/ECAM/msg/line1", "");
		setprop("/ECAM/msg/line2", "");
		setprop("/ECAM/msg/line3", "");
		setprop("/ECAM/msg/line4", "");
		setprop("/ECAM/msg/line5", "");
		setprop("/ECAM/msg/line6", "");
		setprop("/ECAM/msg/line7", "");
		setprop("/ECAM/msg/line8", "");
		setprop("/ECAM/msg/line1c", "w");
		setprop("/ECAM/msg/line2c", "w");
		setprop("/ECAM/msg/line3c", "w");
		setprop("/ECAM/msg/line4c", "w");
		setprop("/ECAM/msg/line5c", "w");
		setprop("/ECAM/msg/line6c", "w");
		setprop("/ECAM/msg/line7c", "w");
		setprop("/ECAM/msg/line8c", "w");
	},
		loop: func() {
		stateL = getprop("/engines/engine[0]/state");
		stateR = getprop("/engines/engine[1]/state");
		thrustL = getprop("/systems/thrust/state1");
		thrustR = getprop("/systems/thrust/state2");
		elec = getprop("/systems/electrical/on");
		speed = getprop("/velocities/airspeed-kt");
		wowL = getprop("/gear/gear[1]/wow");
		altitude = getprop("/position/gear-agl-ft");
		phase1inhibit = getprop("/ECAM/phase-1-inhibit");
		phase2inhibit = getprop("/ECAM/phase-2-inhibit");
		phase3inhibit = getprop("/ECAM/phase-3-inhibit");
		phase4inhibit = getprop("/ECAM/phase-4-inhibit");
		phase5inhibit = getprop("/ECAM/phase-5-inhibit");
		phase6inhibit = getprop("/ECAM/phase-6-inhibit");
		phase7inhibit = getprop("/ECAM/phase-7-inhibit");
		phase8inhibit = getprop("/ECAM/phase-8-inhibit");
		phase9inhibit = getprop("/ECAM/phase-9-inhibit");
		phase10inhibit = getprop("/ECAM/phase-10-inhibit");
		
		if (getprop("/FMGC/status/phase") == 0 and getprop("/engines/engine[0]/state") == 3 and getprop("/engines/engine[1]/state") == 3) {
			setprop("/ECAM/left-msg", "TO-MEMO");
		} else {
			setprop("/ECAM/left-msg", "NONE");
		}
		
		if (elec == 1 and !phase1inhibit and !phase2inhibit and !phase3inhibit and !phase4inhibit and !phase5inhibit and !phase6inhibit and !phase7inhibit and !phase8inhibit and !phase9inhibit and !phase10inhibit) {
			setprop("/ECAM/phase-1-inhibit", 1);
		} else if (stateL == 3 or stateR == 3 and !phase2inhibit and !phase3inhibit and !phase4inhibit and !phase5inhibit and !phase6inhibit and !phase7inhibit and !phase8inhibit and !phase9inhibit and !phase10inhibit) { 
			setprop("/ECAM/phase-1-inhibit", 0);
			setprop("/ECAM/phase-2-inhibit", 1);
		} else if (thrustL == "FLX" or thrustL == "TOGA" or thrustR == "FLX" or thrustR == "TOGA" and speed < 80 and !phase1inhibit and !phase3inhibit and !phase4inhibit and !phase5inhibit and !phase6inhibit and !phase7inhibit and !phase8inhibit and !phase9inhibit and !phase10inhibit) { 
			setprop("/ECAM/phase-2-inhibit", 0);
			setprop("/ECAM/phase-3-inhibit", 1);
		} else if (thrustL == "FLX" or thrustL == "TOGA" or thrustR == "FLX" or thrustR == "TOGA" and speed > 80 and wowL and !phase1inhibit and !phase2inhibit and !phase4inhibit and !phase5inhibit and !phase6inhibit and !phase7inhibit and !phase8inhibit and !phase9inhibit and !phase10inhibit) { 
			setprop("/ECAM/phase-3-inhibit", 0);
			setprop("/ECAM/phase-4-inhibit", 1);
		} else if (speed > 80 and !wowL and altitude < 1501 and !phase1inhibit and !phase2inhibit and !phase3inhibit and !phase5inhibit and !phase6inhibit and !phase7inhibit and !phase8inhibit and !phase9inhibit and !phase10inhibit) { 
			setprop("/ECAM/phase-4-inhibit", 0);
			setprop("/ECAM/phase-5-inhibit", 1);
		} else if (speed > 80 and !wowL and altitude > 1501 and !phase1inhibit and !phase2inhibit and !phase3inhibit and !phase4inhibit and !phase6inhibit and !phase7inhibit and !phase8inhibit and !phase9inhibit and !phase10inhibit) { 
			setprop("/ECAM/phase-5-inhibit", 0);
			setprop("/ECAM/phase-6-inhibit", 1);
		} else if (speed > 80 and !wowL and altitude < 801 and !phase1inhibit and !phase2inhibit and !phase3inhibit and !phase4inhibit and !phase5inhibit and !phase7inhibit and !phase8inhibit and !phase9inhibit and !phase10inhibit) { 
			setprop("/ECAM/phase-6-inhibit", 0);
			setprop("/ECAM/phase-7-inhibit", 1);
		} else if (speed > 80 and wowL and !phase1inhibit and !phase2inhibit and !phase3inhibit and !phase4inhibit and !phase5inhibit and !phase6inhibit and !phase8inhibit and !phase9inhibit and !phase10inhibit) { 
			setprop("/ECAM/phase-7-inhibit", 0);
			setprop("/ECAM/phase-8-inhibit", 1);
		} else if (speed < 80 and wowL and !phase1inhibit and !phase2inhibit and !phase3inhibit and !phase4inhibit and !phase5inhibit and !phase6inhibit and !phase7inhibit and !phase9inhibit and !phase10inhibit) { 
			setprop("/ECAM/phase-8-inhibit", 0);
			setprop("/ECAM/phase-9-inhibit", 1);
		} else if (stateL == 0 and stateR == 0 and !phase1inhibit and !phase2inhibit and !phase3inhibit and !phase4inhibit and !phase5inhibit and !phase6inhibit and !phase7inhibit and !phase8inhibit and !phase10inhibit) { 
			setprop("/ECAM/phase-9-inhibit", 0);
			setprop("/ECAM/phase-10-inhibit", 1);
		}
	},
};

ECAM.MSGclr();
