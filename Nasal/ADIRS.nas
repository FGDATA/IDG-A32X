# A3XX ADIRS system
# Joshua Davidson

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

setlistener("/sim/signals/fdm-initialized", func {
	var roll = getprop("/orientation/roll-deg");
	var pitch = getprop("/orientation/pitch-deg");
	var gs = getprop("/velocities/groundspeed-kt");
	var data_knob = getprop("/controls/adirs/display/dataknob");
	var selected_ir = getprop("/controls/adirs/display/selected");
});

var ADIRS = {
	init: func() {
		setprop("/controls/adirs/numm", 0);
		setprop("/instrumentation/adirs/ir[0]/aligned", 0);
		setprop("/instrumentation/adirs/ir[1]/aligned", 0);
		setprop("/instrumentation/adirs/ir[2]/aligned", 0);
		setprop("/instrumentation/adirs/ir[0]/display/ttn", 0);
		setprop("/instrumentation/adirs/ir[1]/display/ttn", 0);
		setprop("/instrumentation/adirs/ir[2]/display/ttn", 0);
		setprop("/controls/adirs/adr[0]/fault", 0);
		setprop("/controls/adirs/adr[1]/fault", 0);
		setprop("/controls/adirs/adr[2]/fault", 0);
		setprop("/controls/adirs/adr[0]/off", 0);
		setprop("/controls/adirs/adr[1]/off", 0);
		setprop("/controls/adirs/adr[2]/off", 0);
		setprop("/controls/adirs/ir[0]/align", 0);
		setprop("/controls/adirs/ir[1]/align", 0);
		setprop("/controls/adirs/ir[2]/align", 0);
		setprop("/controls/adirs/ir[0]/knob", 0);
		setprop("/controls/adirs/ir[1]/knob", 0);
		setprop("/controls/adirs/ir[2]/knob", 0);
		setprop("/controls/adirs/ir[0]/fault", 0);
		setprop("/controls/adirs/ir[1]/fault", 0);
		setprop("/controls/adirs/ir[2]/fault", 0);
		setprop("/controls/adirs/onbat", 0);
		setprop("/controls/adirs/mcducbtn", 0);
		setprop("/controls/adirs/mcdu/mode1", ""); # INVAL ALIGN NAV ATT or off (blank)
		setprop("/controls/adirs/mcdu/mode2", "");
		setprop("/controls/adirs/mcdu/mode3", "");
		setprop("/controls/adirs/mcdu/status1", ""); # see smith thales p487
		setprop("/controls/adirs/mcdu/status2", "");
		setprop("/controls/adirs/mcdu/status3", "");
		setprop("/controls/adirs/mcdu/hdg", ""); # only shown if in ATT mode
		setprop("/controls/adirs/mcdu/avgdrift1", "");
		setprop("/controls/adirs/mcdu/avgdrift2", "");
		setprop("/controls/adirs/mcdu/avgdrift3", "");
		setprop("/controls/adirs/mcducbtn",0);
	},
	loop: func() {
		# Temporary to make instruments work for now
		setprop("/instrumentation/adirs/ir[0]/aligned", 1);
		setprop("/instrumentation/adirs/ir[1]/aligned", 1);
		setprop("/instrumentation/adirs/ir[2]/aligned", 1);
	},
};
