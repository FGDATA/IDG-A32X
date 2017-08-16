# A3XX ADIRS system
# Jonathan Redpath and Joshua Davidson

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

#####################
# Initializing Vars #
#####################

setprop("/systems/electrical/bus/dc1", 0);
setprop("/systems/electrical/bus/dc2", 0);
setprop("/systems/electrical/bus/dc-ess", 0);
setprop("/systems/electrical/bus/ac1", 0);
setprop("/systems/electrical/bus/ac2", 0);
setprop("/systems/electrical/bus/ac-ess", 0);
var ttn = 0;
var knob = 0;

setlistener("/sim/signals/fdm-initialized", func {
	var roll = getprop("/orientation/roll-deg");
	var pitch = getprop("/orientation/pitch-deg");
	var gs = getprop("/velocities/groundspeed-kt");
	var data_knob = getprop("/controls/adirs/display/dataknob");
	var selected_ir = getprop("/controls/adirs/display/selected");
});

var adirs_init = func {
	setprop("/controls/adirs/mcducbtn",0);
	adirs_timer.start();
}

var ADIRSreset = func {
	setprop("/controls/adirs/numm", 0);
	setprop("/instrumentation/adirs/ir[0]/aligned",0);
	setprop("/instrumentation/adirs/ir[1]/aligned",0);
	setprop("/instrumentation/adirs/ir[2]/aligned",0);
	setprop("/instrumentation/adirs/ir[0]/display/ttn",0);
	setprop("/instrumentation/adirs/ir[1]/display/ttn",0);
	setprop("/instrumentation/adirs/ir[2]/display/ttn",0);
	setprop("/instrumentation/adirs/ir[0]/display/status","- - - - - - - - ");
	setprop("/instrumentation/adirs/ir[1]/display/status","- - - - - - - - ");
	setprop("/instrumentation/adirs/ir[2]/display/status","- - - - - - - - ");
	setprop("/controls/adirs/adr[0]/fault",0);
	setprop("/controls/adirs/adr[1]/fault",0);
	setprop("/controls/adirs/adr[2]/fault",0);
	setprop("/controls/adirs/adr[0]/off",0);
	setprop("/controls/adirs/adr[1]/off",0);
	setprop("/controls/adirs/adr[2]/off",0);
	setprop("/controls/adirs/display/text","");
	setprop("/controls/adirs/display/dataknob","5");
	setprop("/controls/adirs/display/selected","1");
	setprop("/controls/adirs/ir[0]/align",0);
	setprop("/controls/adirs/ir[1]/align",0);
	setprop("/controls/adirs/ir[2]/align",0);
	setprop("/controls/adirs/ir[0]/knob", 0);
	setprop("/controls/adirs/ir[1]/knob", 0);
	setprop("/controls/adirs/ir[2]/knob", 0);
	setprop("/controls/adirs/ir[0]/fault",0);
	setprop("/controls/adirs/ir[1]/fault",0);
	setprop("/controls/adirs/ir[2]/fault",0);
	setprop("/controls/adirs/onbat",0);
	setprop("/controls/adirs/mcducbtn",0);
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
	adirs_init();
}

var ir_align_loop = func(i) {
	ttn = getprop("/instrumentation/adirs/ir[" ~ i ~ "]/display/ttn");
	if ((ttn >= 0) and (ttn < 0.99)) { # Make it less sensitive
		ir_align_finish(i);
	} else {
		setprop("/instrumentation/adirs/ir[" ~ i ~ "]/display/ttn", ttn - 1);
	}
	roll = getprop("/orientation/roll-deg");
	pitch = getprop("/orientation/pitch-deg");
	gs = getprop("/velocities/groundspeed-kt");
	if (gs > 2) {
		setprop("/instrumentation/adirs/ir[" ~ i ~ "]/display/status", "STS-XCESS MOTION");
		ir_align_abort(i);
	}

}

var ir0_align_loop_timer = maketimer(1, func{ir_align_loop(0)});
var ir1_align_loop_timer = maketimer(1, func{ir_align_loop(1)});
var ir2_align_loop_timer = maketimer(1, func{ir_align_loop(2)});

var ir_align_start = func(i) {
	if (((i == 0) and !ir0_align_loop_timer.isRunning) or
			((i == 1) and !ir1_align_loop_timer.isRunning) or
			((i == 2) and !ir2_align_loop_timer.isRunning)) {
		setprop("/instrumentation/adirs/ir[" ~ i ~ "]/display/ttn", (math.sin((getprop("/position/latitude-deg") / 90) * (math.pi / 2)) * 720) + 300);
		if (i == 0) {
			ir0_align_loop_timer.start();
		} else if (i == 1) {
			ir1_align_loop_timer.start();
		} else if (i == 2) {
			ir2_align_loop_timer.start();
		}
		setprop("/controls/adirs/ir[" ~ i ~ "]/align", 1);
	}
}

var ir_align_finish = func(i) {
	setprop("/instrumentation/adirs/ir[" ~ i ~ "]/aligned", 1);
	if (i == 0) {
		ir0_align_loop_timer.stop();
	} else if (i == 1) {
		ir1_align_loop_timer.stop();
	} else if (i == 2) {
		ir2_align_loop_timer.stop();
	}
	setprop("/controls/adirs/ir[" ~ i ~ "]/align", 0);
}

var ir_align_abort = func(i) {
	setprop("/controls/adirs/ir[" ~ i ~ "]/fault", 1);
	if (i == 0) {
		ir0_align_loop_timer.stop();
	} else if (i == 1) {
		ir1_align_loop_timer.stop();
	} else if (i == 2) {
		ir2_align_loop_timer.stop();
	}
	setprop("/controls/adirs/ir[" ~ i ~ "]/align", 0);
}

var ir_knob_move = func(i) {
	knob = getprop("/controls/adirs/ir[" ~ i ~ "]/knob");
	if (knob == 1) {
		setprop("/controls/adirs/ir[" ~ i ~ "]/align", 0);
		setprop("/controls/adirs/ir[" ~ i ~ "]/fault", 0);
		setprop("/instrumentation/adirs/ir[" ~ i ~ "]/aligned", 0);
		setprop("/instrumentation/adirs/ir[" ~ i ~ "]/display/status", "- - - - - - - - ");
		if (i == 0) {
			ir0_align_loop_timer.stop();
		} else if (i == 1) {
			ir1_align_loop_timer.stop();
		} else if (i == 2) {
			ir2_align_loop_timer.stop();
		}
	} else if (knob == 2) {
		if ( !getprop("/instrumentation/adirs/ir[" ~ i ~ "]/aligned") and
				(getprop("/systems/electrical/bus/ac-ess") > 9) ) {
			ir_align_start(i);
		}
	}
}

setlistener("/controls/adirs/ir[0]/knob", func {
	ir_knob_move(0);
	knobmcducheck();
});
setlistener("/controls/adirs/ir[1]/knob", func {
	ir_knob_move(1);
	knobmcducheck();
});
setlistener("/controls/adirs/ir[2]/knob", func {
	ir_knob_move(2);
	knobmcducheck();
});

var knobmcducheck = func {
	if (getprop("/controls/adirs/ir[0]/knob") == 1 and getprop("/controls/adirs/ir[1]/knob") == 1 and getprop("/controls/adirs/ir[2]/knob") == 1) {
		setprop("/controls/adirs/mcducbtn", 0);
	}
}

var onbat_light = func {
	if (((getprop("/systems/electrical/bus/dc1") > 25) or (getprop("/systems/electrical/bus/dc2") > 25)) and 
			((getprop("/systems/electrical/bus/ac1") < 110) and getprop("/systems/electrical/bus/ac2") < 110) and
			((getprop("/controls/adirs/ir[0]/knob") > 1) or
			(getprop("/controls/adirs/ir[1]/knob") > 1) or
			(getprop("/controls/adirs/ir[2]/knob") > 1))) {
		setprop("/controls/adirs/onbat", 1);
	} else {
		setprop("/controls/adirs/onbat", 0);
	}
}

var onbat_light_b = func {
	setprop("/controls/adirs/onbat", 1);
	settimer(func {
		onbat_light();
	}, 4);
	if (getprop("/controls/adirs/skip") == 1) {
		skip_ADIRS();
	}
}

setlistener("/controls/electrical/switches/gen-apu", onbat_light);
setlistener("/controls/electrical/switches/gen1", onbat_light);
setlistener("/controls/electrical/switches/gen2", onbat_light);
setlistener("/controls/electrical/switches/gen-ext", onbat_light);
setlistener("/systems/electrical/bus/ac-ess", onbat_light);
setlistener("/controls/adirs/ir[0]/knob", onbat_light_b);
setlistener("/controls/adirs/ir[1]/knob", onbat_light_b);
setlistener("/controls/adirs/ir[2]/knob", onbat_light_b);


var adirs_display = func() {
	data_knob = getprop("/controls/adirs/display/dataknob");
	selected_ir = getprop("/controls/adirs/display/selected");
	if ( selected_ir == 1 ) {
		setprop("/controls/adirs/display/text", "");
	} else {
		if ( data_knob == 1 ) {
			setprop("/controls/adirs/display/text", "888888888888888");
		} else if ( data_knob == 2 ) {
			if ( ((selected_ir == 2) and getprop("/instrumentation/adirs/ir[0]/aligned")) or
				((selected_ir == 3) and getprop("/instrumentation/adirs/ir[2]/aligned")) or
				((selected_ir == 4) and getprop("/instrumentation/adirs/ir[1]/aligned")) ) {
					setprop("/controls/adirs/display/text", sprintf("     %03i", getprop("/orientation/track-magnetic-deg")) ~ sprintf("     %03i", getprop("/velocities/groundspeed-kt")));
			} else {
				setprop("/controls/adirs/display/text", "- - - - - - - - ");
			}
		} else if ( data_knob == 3 ) {
			lat = abs(getprop("/position/latitude-deg"));
			lon = abs(getprop("/position/longitude-deg"));
			setprop("/controls/adirs/display/text", substr(getprop("/position/latitude-string"), -1, 1) ~
								sprintf("%2i", lat) ~ "'" ~
								sprintf("%2.1f", (lat - math.floor(lat)) * 60) ~
								substr(getprop("/position/longitude-string"), -1, 1) ~
								sprintf("%3i", lon) ~ "'" ~
								sprintf("%2.1f", (lon - math.floor(lon)) * 60));
		} else if ( data_knob == 4 ) {
			if ( ((selected_ir == 2) and getprop("/instrumentation/adirs/ir[0]/aligned")) or
				((selected_ir == 3) and getprop("/instrumentation/adirs/ir[2]/aligned")) or
				((selected_ir == 4) and getprop("/instrumentation/adirs/ir[1]/aligned")) ) {
					setprop("/controls/adirs/display/text", sprintf("     %03i", getprop("/environment/wind-from-heading-deg")) ~ sprintf("     %03i", getprop("/environment/wind-speed-kt")));
			} else {
				setprop("/controls/adirs/display/text", "- - - - - - - - ");
			}
		} else if ( data_knob == 5 ) {
			if ( ((selected_ir == 2) and getprop("/instrumentation/adirs/ir[0]/aligned")) or
				((selected_ir == 3) and getprop("/instrumentation/adirs/ir[2]/aligned")) or
				((selected_ir == 4) and getprop("/instrumentation/adirs/ir[1]/aligned")) ) {
					lat = getprop("/position/latitude-deg");
					lon = getprop("/position/longitude-deg");
					if ((lat > 82) or (lat < -60) or (lon < -90 and lon > -120 and lat > 73)) { 
						setprop("/controls/adirs/display/text", sprintf("   %3.1f", getprop("/orientation/heading-deg")) ~ "- - - - "); # this is true heading
					} else {
						setprop("/controls/adirs/display/text", sprintf("   %3.1f", getprop("/orientation/heading-magnetic-deg")) ~ "- - - - ");
					}
			} else {
				if ( (selected_ir == 2) and getprop("/controls/adirs/ir[0]/align") ) {
					setprop("controls/adirs/display/text", "- - - - " ~ sprintf(" TTN %2i", (getprop("/instrumentation/adirs/ir[0]/display/ttn") / 60)));
				} else if ( (selected_ir == 3) and getprop("/controls/adirs/ir[2]/align") ) {
					setprop("controls/adirs/display/text", "- - - - " ~ sprintf(" TTN %2i", (getprop("/instrumentation/adirs/ir[2]/display/ttn") / 60)));
				} else if ( (selected_ir == 4) and getprop("/controls/adirs/ir[1]/align") ) {
					setprop("controls/adirs/display/text", "- - - - " ~ sprintf(" TTN %2i", (getprop("/instrumentation/adirs/ir[1]/display/ttn") / 60)));
				} else {
					setprop("/controls/adirs/display/text", "- - - - - - - - ");
				}
			}	
		} else if ( data_knob == 6 ) {
			if ( selected_ir == 2 ) {
				setprop("/controls/adirs/display/text","- - - - - - - - ");
			} else if ( selected_ir == 3 ) {
				setprop("/controls/adirs/display/text","- - - - - - - - ");
			} else if ( selected_ir == 4 ) {
				setprop("/controls/adirs/display/text","- - - - - - - - ");
			}
		}
	}
}
var skip_ADIRS = func {
	if (getprop("/controls/adirs/ir[0]/knob") == 2) {
		setprop("/instrumentation/adirs/ir[0]/display/ttn",1); # Set it to 1 so it counts down from 1 to 0
	}
	if (getprop("/controls/adirs/ir[1]/knob") == 2) {
		setprop("/instrumentation/adirs/ir[1]/display/ttn",1); # Set it to 1 so it counts down from 1 to 0
	}
	if (getprop("/controls/adirs/ir[2]/knob") == 2) {
		setprop("/instrumentation/adirs/ir[2]/display/ttn",1); # Set it to 1 so it counts down from 1 to 0
	}
}

var adirs_skip = setlistener("/controls/adirs/skip", func {
	if (getprop("/controls/adirs/skip") == 1) {
		skip_ADIRS();
	}
});

var adirs_timer = maketimer(1, adirs_display);
