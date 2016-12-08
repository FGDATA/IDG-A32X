####    A320 Landing Gear System    ####
####    Jonathan Redpath    ####

var lgciu_one_init = func {
	print("LGCIU No 1: Initializing");
	setprop("controls/lgciu[0]/mlgleft",1); #0 = retracted, 1 = extended
	setprop("controls/lgciu[0]/mlgright",1); #0 = retracted, 1 = extended
	setprop("controls/lgciu[0]/nlg",1); #0 = retracted, 1 = extended
	setprop("/controls/lgciu[0]/doors/mlgleft",0); #0 = closed, 1 = open
	setprop("controls/lgciu[0]/doors/mlgright",0); #0 = closed, 1 = open
	setprop("controls/lgciu[0]/doors/nlg",0); #0 = closed, 1 = open
	setprop("/controls/lgciu[0]/gearlever",1); #0 = retracted, 1 = extended
	print("L/G SYS: Gears and Doors Set");
	setprop("/controls/lgciu[0]/mlgleft/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/mlgright/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/nlg/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/mlgleft/isuplock",0); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/mlgright/isuplock",0); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/nlg/isuplock",0); #0 = no, 1 = yes
	print("L/G SYS: Uplock / Downlock System Enabled");
	setprop("/controls/lgciu[0]/hyd/greensupply",0); #0 = no, 1 = yes presently no supply as green pump is off
	print("L/G SYS: Hydraulics Initialized");
	setprop("/controls/lgciu[0]/isonground",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/nws/nwsenabled",0); #0 = disabled 1 = enabled, must be disabled for push
	setprop("/controls/lgciu[0]/inuse",1); #the LGCIUs switch between eachother on each gear cycle. eg if one LGCIU fails put the gear down and bring them up again to reset
	setprop("/controls/lgciu[0]/hasbeenret",0); #has the gear been retracted with LGCIU1?
	print("L/G SYS: System Settings Initialized");
	print("LGCIU No 1 Loaded!");
}

var lgciu_two_init = func {
	print("LGCIU No 2: Initializing");
	setprop("/controls/lgciu[1]/mlgleft",1); #0 = retracted, 1 = extended
	setprop("/controls/lgciu[1]/mlgright",1); #0 = retracted, 1 = extended
	setprop("/controls/lgciu[1]/nlg",1); #0 = retracted, 1 = extended
	setprop("/controls/lgciu[1]/doors/mlgleft",0); #0 = closed, 1 = open
	setprop("/controls/lgciu[1]/doors/mlgright",0); #0 = closed, 1 = open
	setprop("/controls/lgciu[1]/doors/nlg",0); #0 = closed, 1 = open
	setprop("/controls/lgciu[1]/gearlever",1); #0 = retracted, 1 = extended
	print("L/G SYS: Gears and Doors Set");
	setprop("/controls/lgciu[1]/mlgleft/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/mlgright/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/nlg/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/mlgleft/isuplock",0); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/mlgright/isuplock",0); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/nlg/isuplock",0); #0 = no, 1 = yes
	print("L/G SYS: Uplock / Downlock System Enabled");
	setprop("/controls/lgciu[1]/hyd/greensupply",0); #0 = no, 1 = yes presently no supply as green pump is off
	print("L/G SYS: Hydraulics Initialized");
	setprop("/controls/lgciu[1]/isonground",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/nws/nwsenabled",0); #0 = disabled 1 = enabled, must be disabled for push
	setprop("/controls/lgciu[1]/inuse",0); #the LGCIUs switch between eachother on each gear cycle. eg if one LGCIU fails put the gear down and bring them up again to reset
	setprop("/controls/lgciu[1]/hasbeenret",0); #has the gear been retracted with LGCIU2?
	print("L/G SYS: System Settings Initialized");
	print("LGCIU No 2: Loaded!");
}



# Initialize Landing Gear Control and Indication Unit
setlistener("/sim/signals/fdm-initialized", func {	
	print("Landing Gear System: Initializing");
  	lgciu_one_init();
	lgciu_two_init();
});

### Left MLG compressor sensor to check if we are on the ground ###
setlistener("/gear/gear[0]/wow", func {	
	var wowmlgl = getprop("/gear/gear[0]/wow");
	if (wowmlgl == 0) {
	setprop("/controls/lgciu[0]/isonground",0);
	setprop("/controls/lgciu[1]/isonground",0);
	} else if (wowmlgl == 1) {
	setprop("/controls/lgciu[0]/isonground",1);
	setprop("/controls/lgciu[1]/isonground",1);
}
});

### Checking the Green Hydraulic System ###
#var checkgreen = func {
setlistener("/controls/gear/gear-down", func {
#var psigrn = getprop("/hydraulics/green/psi"); it0uchpods, please enable whenever hydraulic system is available
var spd = getprop("/velocities/airspeed-kt");
	#if ((psigrn < 2000) or (spd > 261)) {  see above line where psigrn is defined
	if (spd > 261) {
	setprop("/controls/gear/gear-down",0);
	screen.log.write("Hydraulic Safety Valve was disconnected at 260 kts; cannot move gear!", 1, 1, 1);
}
});

### Switching between LGCIUS ###

# Putting the Gear Up
setlistener("/controls/gear/gear-down", func {
var inuse1 = getprop("/controls/lgciu[0]/inuse");
var inuse2 = getprop("/controls/lgciu[1]/inuse");
var isgearupordown = getprop("/controls/gear/gear-down");
var hydsupp = getprop("/controls/lgciu[0]/hyd/greensupply");
if ((inuse1 == 1) and (isgearupordown == 0) and (hydsupp == 1)) {
setprop("/controls/lgciu[0]/hasbeenret",1); #we have put gear up on lgciu no 1
setprop("/controls/lgciu[0]/inuse",1); #we want to keep active LGCIU on no 1
setprop("/controls/lgciu[0]/gearlever",0); #0 = retracted, 1 = extended

} else {
if ((inuse2 == 1) and (isgearupordown == 0) and (hydsupp == 1)) {
setprop("/controls/lgciu[1]/hasbeenret",1); #we have put gear up on lgciu no 2
setprop("/controls/lgciu[1]/inuse",1); #we want to keep active LGCIU on no 2
setprop("/controls/lgciu[1]/gearlever",0); #0 = retracted, 1 = extended
} else {
}
}
});

# Putting the Gear Down Again
setlistener("/controls/gear/gear-down", func {
var inuse1 = getprop("/controls/lgciu[0]/inuse");
var inuse2 = getprop("/controls/lgciu[1]/inuse");
var hasbeen1 = getprop("/controls/lgciu[0]/hasbeenret");
var hasbeen2 = getprop("/controls/lgciu[1]/hasbeenret");
var isgearupordown = getprop("/controls/gear/gear-down");
var hydsupp = getprop("/controls/lgciu[0]/hyd/greensupply");
if ((inuse1 == 1) and (isgearupordown == 1) and (hasbeen1 == 1) and (hydsupp == 1)) {
setprop("/controls/lgciu[0]/hasbeenret",0); #reset retraction sensor
setprop("/controls/lgciu[0]/inuse",0); #we want to switch to no 2 after putting the gear down
setprop("/controls/lgciu[1]/inuse",1);
setprop("/controls/lgciu[0]/gearlever",1); #0 = retracted, 1 = extended
} else {
if ((inuse2 == 1) and (isgearupordown == 1) and (hasbeen2 == 1) and (hydsupp == 1)) {
setprop("/controls/lgciu[1]/hasbeenret",0); #reset retraction sensor
setprop("/controls/lgciu[0]/inuse",1); #we want to switch to no 1 after putting the gear down
setprop("/controls/lgciu[1]/inuse",0);
setprop("/controls/lgciu[1]/gearlever",1); #0 = retracted, 1 = extended
} else {
}
}
});

