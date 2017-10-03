# A3XX Tray Tables
# Jonathan Redpath (legoboyvdlp)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

#############
# Init Vars #
#############
setlistener("/sim/signals/fdm-initialized", func {
	var cmdL = getprop("/controls/tray/cmdL");
	var cmdR = getprop("/controls/tray/cmdR");
	var trayLext = getprop("/controls/tray/lefttrayext");
	var trayRext = getprop("/controls/tray/righttrayext");
});

var tray_init = func {
	setprop("/controls/tray/cmdL", 0); # 0 = in 0.5 = half 1 = full
	setprop("/controls/tray/cmdR", 0); # 0 = in 0.5 = half 1 = full
	setprop("/controls/tray/lefttrayext", 0); # controls the lateral extension
	setprop("/controls/tray/righttrayext", 0);
	tray_timer.start();
}

##############
# Main Loops #
##############
var master_tray = func {
	cmdL = getprop("/controls/tray/cmdL");
	cmdR = getprop("/controls/tray/cmdR");
	trayLext = getprop("/controls/tray/lefttrayext");
	trayRext = getprop("/controls/tray/righttrayext");

	if (cmdL == 0 and trayLext == 1) {
		interpolate("/controls/tray/lefttrayext", 0, 2);
	} elsif (cmdL == 0 and trayLext == 0.5) {
		interpolate("/controls/tray/lefttrayext", 0, 1);
	} elsif (cmdL == 0.5 and trayLext == 1) {
		interpolate("/controls/tray/lefttrayext", 0.5, 1);
	} elsif (cmdL == 0.5 and trayLext == 0) {
		interpolate("/controls/tray/lefttrayext", 0.5, 1);
	} elsif (cmdL == 1 and trayLext == 0) {
		interpolate("/controls/tray/lefttrayext", 1, 2);
	} elsif (cmdL == 1 and trayLext == 0.5) {
		interpolate("/controls/tray/lefttrayext", 1, 1);
	}
	
	if (cmdR == 0 and trayRext == 1) {
		interpolate("/controls/tray/righttrayext", 0, 2);
	} elsif (cmdR == 0 and trayRext == 0.5) {
		interpolate("/controls/tray/righttrayext", 0, 1);
	} elsif (cmdR == 0.5 and trayRext == 1) {
		interpolate("/controls/tray/righttrayext", 0.5, 1);
	} elsif (cmdR == 0.5 and trayRext == 0) {
		interpolate("/controls/tray/righttrayext", 0.5, 1);
	} elsif (cmdR == 1 and trayRext == 0) {
		interpolate("/controls/tray/righttrayext", 1, 2);
	} elsif (cmdR == 1 and trayRext == 0.5) {
		interpolate("/controls/tray/righttrayext", 1, 1);
	}
}

###################
# Update Function #
###################
var update_tray = func {
	master_tray();
}

var tray_timer = maketimer(0.1, update_tray);