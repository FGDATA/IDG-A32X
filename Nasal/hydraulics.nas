# A320 Hydraulics - Disabled until complete

# LGCIU
# Jonathan Redpath
# Note: Will be compressed

#####################
# Initializing Vars #
#####################
var lgciu_init = func {
#Hydraulics
setprop("controls/LGCIU/hyd/safetyvalvepos",0); #1 is closed, 0 is open. 
setprop("controls/LGCIU/hyd/cutoffvalvepos",0); #1 is closed, 0 is open.
setprop("controls/LGCIU/hyd/doorselvalvepos",1); #1 is closed, 0 is open.
setprop("controls/LGCIU/hyd/gearselvalvepos",1); #1 is closed, 0 is open.
#Sensors
setprop("controls/LGCIU/sensor/ten",1); #1 is yes condition, ie on ground. Used to prohibit retraction on ground
setprop("controls/LGCIU/sensor/adr1and3flt",0);
setprop("controls/LGCIU/inhibit",1);
#Timers
safety_valve_ADR_timer.start();
sensorten.start();
}

var safety_valve_ADR = setlistener("controls/LGCIU/sensor/adr1and3flt", func {
var ADRfault = getprop("controls/LGCIU/sensor/adr1and3flt");
if (ADRfault) {
setprop("controls/LGCIU/hyd/safetyvalvepos",1); #close valve if we have ADR 1 + 3 FAULT
}
});

var gear_retract_inhibit = setlistener("controls/LGCIU/sensor/ten", func {
var sens10 = getprop("controls/LGCIU/sensor/ten");
var gearcmd = getprop("gear/gear-cmd-norm");
if (sens10) {
setprop("controls/LGCIU/inhibit",1); #use this property in gear retraction logic, eg if not gearinhib
} else {
setprop("controls/LGCIU/inhibit",0);
}
});


# Logic: 
#On the 320 series, the LGCIU, controls the safety valve when either ADR 1 or 3 has an indicated airspeed greater than 260KIAS, the valve will close preventing extension in flight. There is also a function where when the aircraft senses it's on the ground, the valve also closes to prevent inadvertent gear retraction.
#ADR 1/3 less than 260 kts with L/G lever down ----> safety valve is open(lets hydraulic fluid pass through it) {take off condition}
#ADR 1/3 less than 260 kts with L/G lever up ----> safety valve is still open as there is a 'Self Maintained' logic. {initial climb condition} As soon as ADR 1/3 more than 260 kts the safety valve will close (stop the hydraulic supply) {cruise}
#ADR 1/3 more than 260 kts with L/G lever up ----> safety valve will remain close and when ADR 1/3 drops below 260 kts with L/G lever up it will still remain close. It will open only when L/G lever is selected down.{descent condition}

var ADRlock = setlistener("controls/LGCIU/hyd/safetyvalvepos", func { #lock the valve if there is an ADR 1 + 3 fault
var ADRfault = getprop("controls/LGCIU/sensor/adr1and3flt");
var valve = getprop("controls/LGCIU/hyd/safetyvalvepos");
if (!valve and ADRfault) {
setprop("controls/LGCIU/hyd/safetyvalvepos",1);
}
});

var safety_valve_ADR_timer = maketimer(1, func {
var ADR1 = getprop("controls/adirs/ir[0]/fault");
var ADR3 = getprop("controls/adirs/ir[2]/fault");
if (ADR1 and ADR3) {
setprop("controls/LGCIU/sensor/adr1and3flt", 1);
} else {
setprop("controls/LGCIU/sensor/adr1and3flt", 0);
}
});

var sensorten = maketimer(0.1, func {
var gearpos = getprop("/gear/gear[0]/position-norm");
var gearpo1 = getprop("/gear/gear[1]/position-norm");
var gearpo2 = getprop("/gear/gear[2]/position-norm");
var gear1comp = getprop("gear/gear[0]/compression-norm");
var gear2comp = getprop("gear/gear[1]/compression-norm");
var gear3comp = getprop("gear/gear[2]/compression-norm");
if (gearpos and gearpo1 and gearpo2 and ((gear1comp > 0) and (gear2comp > 0) and (gear3comp > 0))) {
setprop("controls/LGCIU/sensor/ten",1); #1 is yes condition, ie on ground. Used to prohibit retraction on ground
} else {
setprop("controls/LGCIU/sensor/ten",0); #1 is yes condition, ie on ground. Used to prohibit retraction on ground
}
});