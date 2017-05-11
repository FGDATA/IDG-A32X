# A320Family FMGC
# Joshua Davidson (it0uchpods)

# Very Simple at the moment, but will evolve into a fully-fledged FMGC System. -JD

setlistener("/gear/gear[1]/wow", func {
	flarecheck();
});

setlistener("/gear/gear[2]/wow", func {
	flarecheck();
});

var flarecheck = func {
	var gear1 = getprop("/gear/gear[1]/wow");
	var gear2 = getprop("/gear/gear[2]/wow");
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	var flaps = getprop("/controls/flight/flap-pos");
	if (gear1 == 1 and gear2 == 1 and (state1 == "MCT" or state1 == "TOGA") and (state2 == "MCT" or state2 == "TOGA") and flaps < 4) {
		setprop("/FMGC/status/to-state", 1);
	}
	if (getprop("/position/gear-agl-ft") >= 55) {
		setprop("/FMGC/status/to-state", 0);
	}
	if (gear1 == 1 and gear2 == 1 and getprop("/FMGC/status/to-state") == 0 and flaps >= 4) {
		setprop("/controls/flight/elevator-trim", -0.15);
	}
}