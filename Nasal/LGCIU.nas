####    A320 Landing Gear System    ####
####    Jonathan Redpath   			####
#### 	v.0.4						####


var lgciu_one_init = func {
	setprop("controls/lgciu[0]/mlgleftpos",1); #0 = retracted, 1 = extended
	setprop("controls/lgciu[0]/mlgrightpos",1); #0 = retracted, 1 = extended
	setprop("controls/lgciu[0]/nlgpos",1); #0 = retracted, 1 = extended
	setprop("/controls/lgciu[0]/doors/mlgleft",0); #0 = closed, 1 = open
	setprop("controls/lgciu[0]/doors/mlgright",0); #0 = closed, 1 = open
	setprop("controls/lgciu[0]/doors/nlg",0); #0 = closed, 1 = open
	setprop("/controls/lgciu[0]/gearlever",1); #0 = retracted, 1 = extended
	setprop("/controls/lgciu[0]/mlgleft/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/mlgright/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/nlg/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/mlgleft/isuplock",0); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/mlgright/isuplock",0); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/nlg/isuplock",0); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/hyd/greensupply",0); #0 = no, 1 = yes presently no supply as green pump is off
	setprop("/controls/lgciu[0]/wow/isongroundl",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/wow/isongroundn",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/wow/isongroundr",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[0]/nws/nwsenabled",0); #0 = disabled 1 = enabled, must be disabled for push
	setprop("/controls/lgciu[0]/inuse",1); #the LGCIUs switch between eachother on each gear cycle. eg if one LGCIU fails put the gear down and bring them up again to reset
	setprop("/controls/lgciu[0]/hasbeenret",0); #has the gear been retracted with LGCIU1?
	setprop("/controls/lgciu[0]/fail",0); #0 = no 1 = 
	setprop("/controls/lgciu[0]/emermanext","0"); #0 = no 3 = extended can only be retracted if green hyd is available. crank must be turned 3 times clockwise so this has quotes
	setprop("/controls/lgciu[0]/cargo/fwd/lock",1);
	setprop("/controls/lgciu[0]/cargo/aft/lock",1);
	setprop("/controls/lgciu[0]/cargo/bulk/lock",1);
	setprop("/controls/lgciu[0]/cargo/fwd/open",0);
	setprop("/controls/lgciu[0]/cargo/aft/open",0);
	setprop("/controls/lgciu[0]/cargo/bulk/open",0);
}

var lgciu_two_init = func {
	setprop("controls/lgciu[1]/mlgleftpos",1); #0 = retracted, 1 = extended
	setprop("controls/lgciu[1]/mlgrightpos",1); #0 = retracted, 1 = extended
	setprop("controls/lgciu[1]/nlgpos",1); #0 = retracted, 1 = extended
	setprop("/controls/lgciu[1]/doors/mlgleft",0); #0 = closed, 1 = open
	setprop("controls/lgciu[1]/doors/mlgright",0); #0 = closed, 1 = open
	setprop("controls/lgciu[1]/doors/nlg",0); #0 = closed, 1 = open
	setprop("/controls/lgciu[1]/gearlever",1); #0 = retracted, 1 = extended
	setprop("/controls/lgciu[1]/mlgleft/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/mlgright/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/nlg/isdownlock",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/mlgleft/isuplock",0); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/mlgright/isuplock",0); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/nlg/isuplock",0); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/hyd/greensupply",0); #0 = no, 1 = yes presently no supply as green pump is off
	setprop("/controls/lgciu[1]/wow/isongroundl",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/wow/isongroundn",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/wow/isongroundr",1); #0 = no, 1 = yes
	setprop("/controls/lgciu[1]/nws/nwsenabled",0); #0 = disabled 1 = enabled, must be disabled for push
	setprop("/controls/lgciu[1]/inuse",0); #the LGCIUs switch between eachother on each gear cycle. eg if one LGCIU fails put the gear down and bring them up again to reset
	setprop("/controls/lgciu[1]/hasbeenret",0); #has the gear been retracted with LGCIU2?
	setprop("/controls/lgciu[1]/fail",0); #0 = no 1 = yes
	setprop("/controls/lgciu[1]/emermanext","0"); #0 = no 3 = extended can only be retracted if green hyd is available. crank must be turned 3 times clockwise so this has quotes
	setprop("/controls/lgciu[0]/init",1); #these two properties say that 'everything is ready now'
	setprop("/controls/lgciu[1]/init",1); 
	setprop("/controls/lgciu[1]/cargo/fwd/lock",1);
	setprop("/controls/lgciu[1]/cargo/aft/lock",1);
	setprop("/controls/lgciu[1]/cargo/bulk/lock",1);
	setprop("/controls/lgciu[1]/cargo/fwd/open",0);
	setprop("/controls/lgciu[1]/cargo/aft/open",0);
	setprop("/controls/lgciu[1]/cargo/bulk/open",0);
}

var BSCU_init = func {
setprop("/controls/BSCU/hyd/greensupply",0);
setprop("/controls/BSCU/nws/ruddlim","6");
setprop("/controls/BSCU/nws/tilllim","70");
setprop("/controls/BSCU/nws/enabled",0);
setprop("/controls/BSCU/nws/pedalsdisc",0);
setprop("/controls/BSCU/fail/nws",0);
setprop("/controls/BSCU/fail/askid",0);
setprop("/controls/BSCU/fail/BSCU",0);
setprop("/controls/BSCU/brakes/hydsupp","0"); #0 is off, 1 is grn, 2 is altn yellow accum
setprop("/controls/BSCU/brakes/mlgltemp","0"); #in celsius
setprop("/controls/BSCU/brakes/mlgrtemp","0"); #in celsius
setprop("/controls/BSCU/brakes/coolfans",0); #0 off 1 on
setprop("/controls/BSCU/brakes/loverheatplug",0); #0 off 1 on
setprop("/controls/BSCU/brakes/roverheatplug",0); #0 off 1 on
setprop("/controls/BSCU/brakes/mode","4"); #0 is norm, 1 is altn, 3 is altn no askid 4 is parkbrake
}

# for now like this. later try to do a jsbsim table
var BSCU_timer = maketimer(0.1, func(){
var ias = getprop("/velocities/airspeed-kt");
if (ias > 130) {
setprop("/controls/BSCU/nws/ruddlim","0");
} else if (ias > 70) {
setprop("/controls/BSCU/nws/tilllim","0");
} else if (ias > 57.9 and ias < 61.99 ) {
setprop("/controls/BSCU/nws/ruddlim","3.5");
});
# BSCU logic is A/SKID and NWS sw on, one eng running, a/c on grnd, and towing ctrl lvr in norm pos

# Initialize Landing Gear Control and Indication Unit
setlistener("/sim/signals/fdm-initialized", func {	
  	lgciu_one_init();
	lgciu_two_init();
	BSCU_init();
	BSCU_timer.start();
	print("LGCIU System ... OK!");
	print("BSCU System ... OK!");
});




### Left MLG compressor sensor to check if we are on the ground ###
setlistener("/gear/gear[0]/wow", func {	
	var wowmlgl = getprop("/gear/gear[0]/wow");
	if (wowmlgl == 0) {
	setprop("/controls/lgciu[0]/wow/isongroundl",0);
	setprop("/controls/lgciu[1]/wow/isongroundl",0);
	} else if (wowmlgl == 1) {
	setprop("/controls/lgciu[0]/wow/isongroundl",1);
	setprop("/controls/lgciu[1]/wow/isongroundl",1);
}
});

### Nose MLG compressor sensor to check if we are on the ground ###
setlistener("/gear/gear[1]/wow", func {	
	var wowmlgn = getprop("/gear/gear[1]/wow");
	if (wowmlgn == 0) {
	setprop("/controls/lgciu[0]/wow/isongroundn",0);
	setprop("/controls/lgciu[1]/wow/isongroundn",0);
	} else if (wowmlgn == 1) {
	setprop("/controls/lgciu[0]/wow/isongroundn",1);
	setprop("/controls/lgciu[1]/wow/isongroundn",1);
}
});

### Right MLG compressor sensor to check if we are on the ground ###
setlistener("/gear/gear[2]/wow", func {	
	var wowmlgr = getprop("/gear/gear[2]/wow");
	if (wowmlgr == 0) {
	setprop("/controls/lgciu[0]/wow/isongroundr",0);
	setprop("/controls/lgciu[1]/wow/isongroundr",0);
	} else if (wowmlgr == 1) {
	setprop("/controls/lgciu[0]/wow/isongroundr",1);
	setprop("/controls/lgciu[1]/wow/isongroundr",1);
}
});

### Interpolate MLG and NLG so that they take 10 seconds to move positions ###
setlistener("/controls/gear/gear-down", func {
var gr = getprop("/controls/gear/gear-down");
var mlgl = getprop("/controls/lgciu[0]/mlgleftpos");
var mlgr = getprop("/controls/lgciu[0]/mlgrightpos");
var mlgl2 = getprop("/controls/lgciu[1]/mlgleftpos");
var mlgr2 = getprop("/controls/lgciu[1]/mlgrightpos");
var nlg = getprop("/controls/lgciu[0]/nlgpos");
var nlg2 = getprop("/controls/lgciu[1]/nlgpos");
var inuseno1 = getprop("/controls/lgciu[0]/inuse");
var inuseno2 = getprop("/controls/lgciu[1]/inuse");
if ((gr == 1) and (inuseno1 == 1)) {
    interpolate("/controls/lgciu[0]/mlgleftpos", 1, 10);
	interpolate("/controls/lgciu[0]/mlgrightpos", 1, 10);
	interpolate("/controls/lgciu[0]/nlgpos", 1, 10);
	interpolate("/controls/lgciu[1]/mlgleftpos", 1, 10); #we also interpolate the other LGCIU's properties just to keep the systems from clashing
	interpolate("/controls/lgciu[1]/mlgrightpos", 1, 10);
	interpolate("/controls/lgciu[1]/nlgpos", 1, 10);
} else if ((gr == 1) and (inuseno2 == 1)) {
    interpolate("/controls/lgciu[1]/mlgleftpos", 1, 10);
	interpolate("/controls/lgciu[1]/mlgrightpos", 1, 10);
	interpolate("/controls/lgciu[1]/nlgpos", 1, 10);
	interpolate("/controls/lgciu[0]/mlgleftpos", 1, 10);
	interpolate("/controls/lgciu[0]/mlgrightpos", 1, 10);
	interpolate("/controls/lgciu[0]/nlgpos", 1, 10);
} else if ((gr == 0) and (inuseno1 == 1)) {
	interpolate("/controls/lgciu[0]/mlgleftpos", 0, 10);
	interpolate("/controls/lgciu[0]/mlgrightpos", 0, 10);
	interpolate("/controls/lgciu[0]/nlgpos", 0, 10);
	interpolate("/controls/lgciu[1]/mlgleftpos", 0, 10);
	interpolate("/controls/lgciu[1]/mlgrightpos", 0, 10);
	interpolate("/controls/lgciu[1]/nlgpos", 0, 10);
} else if ((gr == 0) and (inuseno2 == 1)) {
	interpolate("/controls/lgciu[1]/mlgleftpos", 0, 10);
	interpolate("/controls/lgciu[1]/mlgrightpos", 0, 10);
	interpolate("/controls/lgciu[1]/nlgpos", 0, 10);
	interpolate("/controls/lgciu[0]/mlgleftpos", 0, 10);
	interpolate("/controls/lgciu[0]/mlgrightpos", 0, 10);
	interpolate("/controls/lgciu[0]/nlgpos", 0, 10);
}
});





### Checking the Hydraulics and Valves ###

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
#var hydsupp = getprop("/controls/lgciu[0]/hyd/greensupply");
#if ((inuse1 == 1) and (isgearupordown == 0) and (hydsupp == 1)) {
if ((inuse1 == 1) and (isgearupordown == 0)) {
setprop("/controls/lgciu[0]/hasbeenret",1); #we have put gear up on lgciu no 1
setprop("/controls/lgciu[0]/inuse",1); #we want to keep active LGCIU on no 1
setprop("/controls/lgciu[0]/gearlever",0); #0 = retracted, 1 = extended
setprop("/controls/lgciu[1]/gearlever",0); #0 = retracted, 1 = extended
} else {
#if ((inuse2 == 1) and (isgearupordown == 0) and (hydsupp == 1)) {
if ((inuse2 == 1) and (isgearupordown == 0)) {
setprop("/controls/lgciu[1]/hasbeenret",1); #we have put gear up on lgciu no 2
setprop("/controls/lgciu[1]/inuse",1); #we want to keep active LGCIU on no 2
setprop("/controls/lgciu[0]/gearlever",0); #0 = retracted, 1 = extended
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
var no1fail = getprop("/controls/lgciu[0]/fail");
var no2fail = getprop("/controls/lgciu[1]/fail");
if ((inuse1 == 1) and (isgearupordown == 1) and (hasbeen1 == 1) and (hydsupp == 1)) {
setprop("/controls/lgciu[0]/hasbeenret",0); #reset retraction sensor
setprop("/controls/lgciu[0]/inuse",0); #we want to switch to no 2 after putting the gear down
setprop("/controls/lgciu[1]/inuse",1);
setprop("/controls/lgciu[0]/gearlever",1); #0 = retracted, 1 = extended
setprop("/controls/lgciu[1]/gearlever",1); #0 = retracted, 1 = extended
} else if ((inuse2 == 1) and (isgearupordown == 1) and (hasbeen2 == 1) and (hydsupp == 1)) {
setprop("/controls/lgciu[1]/hasbeenret",0); #reset retraction sensor
setprop("/controls/lgciu[0]/inuse",1); #we want to switch to no 1 after putting the gear down
setprop("/controls/lgciu[1]/inuse",0);
setprop("/controls/lgciu[0]/gearlever",1); #0 = retracted, 1 = extended
setprop("/controls/lgciu[1]/gearlever",1); #0 = retracted, 1 = extended
} else if ((inuse1 == 1) and (isgearupordown == 1) and (hasbeen1 == 1) and (hydsupp ==1) and (no2fail == 1)) {
setprop("/controls/lgciu[0]/hasbeenret",0); #reset retraction sensor
setprop("/controls/lgciu[0]/inuse",1); #we want to switch to no 2 after putting the gear down but we cant because it is failed
setprop("/controls/lgciu[1]/inuse",0);
setprop("/controls/lgciu[0]/gearlever",1); #0 = retracted, 1 = extended
setprop("/controls/lgciu[1]/gearlever",1); #0 = retracted, 1 = extended
} else if ((inuse1 == 2) and (isgearupordown == 1) and (hasbeen2 == 1) and (hydsupp ==1) and (no1fail == 1)) {
setprop("/controls/lgciu[0]/hasbeenret",0); #reset retraction sensor
setprop("/controls/lgciu[1]/inuse",1); #we want to switch to no 1 after putting the gear down but we cant because it is failed
setprop("/controls/lgciu[0]/inuse",0);
setprop("/controls/lgciu[0]/gearlever",1); #0 = retracted, 1 = extended
setprop("/controls/lgciu[1]/gearlever",1); #0 = retracted, 1 = extended
}
} 
);
# Disconnect hyd to gear when we use emergency extension
setlistener("/controls/lgciu[0]/emermanext", func {
var no1manexthyd = getprop("/controls/lgciu[0]/emermanext");
if (no1manexthyd > 0.1) {
setprop("/controls/lgciu[0]/hyd/greensupply",0);
setprop("/controls/lgciu[1]/hyd/greensupply",0);
} else {
}
});
# Disconnect hyd to gear when we use emergency extension
setlistener("/controls/lgciu[0]/emermanext", func {
var no2manexthyd = getprop("/controls/lgciu[1]/emermanext");
if (no2manexthyd > 0.1) {
setprop("/controls/lgciu[0]/hyd/greensupply",0);
setprop("/controls/lgciu[1]/hyd/greensupply",0);
} else {
}
});

# No 1 failed
setlistener("/controls/lgciu[0]/fail", func {
var no1fail = getprop("/controls/lgciu[0]/fail");
if (no1fail == 1) {
setprop("/controls/lgciu[0]/inuse",0);
setprop("/controls/lgciu[1]/inuse",1);
print("LGCIU No 1... Failed!");
} else {
print("LGCIU No 1... Serviceable!");
}
});

# No 2 failed
setlistener("/controls/lgciu[1]/fail", func {
var no2fail = getprop("/controls/lgciu[1]/fail");
if (no2fail == 1) {
setprop("/controls/lgciu[1]/inuse",0);
setprop("/controls/lgciu[0]/inuse",1);
print("LGCIU No 2... Failed!");
} else {
print("LGCIU No 2... Serviceable!");
}
});

# BSCU failed
setlistener("/controls/BSCU/fail/BSCU", func {
var bscufail = getprop("/controls/BSCU/fail/BSCU");
if (bscufail == 1) {
print("BSCU... Failed!");
} else {
print("BSCU... Serviceable!");
}
});

