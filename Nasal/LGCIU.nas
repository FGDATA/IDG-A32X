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
	setprop("/controls/lgciu[0]/hyd/greensupply",0); #0 = no, 1 = yes no supply as green pump is off
	print("L/G SYS: Hydraulics Initialized");
	setprop("/controls/lgciu[0]/isonground",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/nws/nwsenabled",0); #0 = disabled 1 = enabled, must be disabled for push
	setprop("/controls/lgciu[0]/inuse",1); #the LGCIUs switch between eachother on each gear cycle. eg if one LGCIU fails put the gear down and bring them up again to reset
	print("LGCIU No 1 Loaded!!");
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
	setprop("/controls/lgciu[1]/hyd/greensupply",0); #0 = no, 1 = yes no supply as green pump is off
	print("L/G SYS: Hydraulics Initialized");
	setprop("/controls/lgciu[1]/isonground",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/nws/nwsenabled",0); #0 = disabled 1 = enabled, must be disabled for push
	setprop("/controls/lgciu[1]/inuse",0); #the LGCIUs switch between eachother on each gear cycle. eg if one LGCIU fails put the gear down and bring them up again to reset
	print("LGCIU No 2: Loaded!");
}



# Initialize Landing Gear Control and Indication Unit
setlistener("/sim/signals/fdm-initialized", func {	
	print("Landing Gear System: Initializing");
  	lgciu_one_init();
	lgciu_two_init();
});

# Putting the Gear Up
setlistener("/controls/gear/gear-down", func {
var inuse1 = getprop("/controls/lgciu[0]/inuse");
var inuse2 = getprop("/controls/lgciu[1]/inuse");
var isgearupordown = getprop("/controls/gear/gear-down");
if ((inuse1 == 1) and (isgearupordown = 0)) {
setprop("/controls/lgciu[0]/hasbeenret",1);
} else {
if ((inuse2 == 1) and (isgearupordown = 0)) {
setprop("/controls/lgciu[1]/hasbeenret",1);
} else {
}
}
});

# Putting the Gear Down Again
setlistener("/controls/gear/gear-down", func {
var inuse1 = getprop("/controls/lgciu[0]/inuse");
var inuse2 = getprop("/controls/lgciu[1]/inuse");
var hasbeen1 = getprop("/controls/lgciu[0]/hasbeenret");
var hasbeen2 = getprop("/controls/lgciu[0]/hasbeenret");
var isgearupordown = getprop("/controls/gear/gear-down");
if ((inuse1 == 1) and (isgearupordown = 1)) {
setprop("/controls/lgciu[0]/hasbeenret",0);
setprop("/controls/lgciu[1]/inuse",1);
} else {
if ((inuse2 == 1) and (isgearupordown = 1)) {
setprop("/controls/lgciu[1]/hasbeenret",0);
setprop("/controls/lgciu[1]/inuse",0);
} else {
}
}
});
