# A3XX JSB Engine System
# Joshua Davidson (it0uchpods)

#####################
# Initializing Vars #
#####################

var engines = props.globals.getNode("/engines").getChildren("engine");
var n1_min = 22.4;
var n2_min = 60.7;
var egt_min = 434;
var n1_spin = 5.1;
var n2_spin = 22.8;
var n1_start = 22.3;
var n2_start = 60.6;
var egt_start = 587;
var n1_max = 105.8;
var n2_max = 102.1;
var egt_max = 712;
var n1_wm = 0;
var n2_wm = 0;
var apu_max = 99.2;
var apu_egt_min = 496;
var apu_egt_max = 643;
var spinup_time = 49;
var start_time = 10;
var egt_lightup_time = 2;
var egt_lightdn_time = 8;
var shutdown_time = 20;
var egt_shutdown_time = 20;
setprop("/systems/apu/rpm", 0);
setprop("/systems/apu/egt", 42);
setprop("/controls/engines/engine[0]/reverser", 0);
setprop("/controls/engines/engine[1]/reverser", 0);
setprop("/controls/engines/engine[0]/igniter-a", 0);
setprop("/controls/engines/engine[1]/igniter-a", 0);
setprop("/controls/engines/engine[0]/igniter-b", 0);
setprop("/controls/engines/engine[1]/igniter-b", 0);
setprop("/controls/engines/engine[0]/last-igniter", "B");
setprop("/controls/engines/engine[1]/last-igniter", "B");

var eng_init = func {
	setprop("/controls/engines/engine[0]/man-start", 0);
	setprop("/controls/engines/engine[1]/man-start", 0);
}

##############################
# Trigger Startups and Stops #
##############################

setlistener("/controls/engines/engine[0]/cutoff-switch", func {
	if (getprop("/controls/engines/engine[0]/cutoff-switch") == 0) {
		if (getprop("/controls/engines/engine[0]/man-start") == 0) {
			start_one_check();
		} else if (getprop("/controls/engines/engine[0]/man-start") == 1) {
			eng_one_man_startt.start();
		}
	} else if (getprop("/controls/engines/engine[0]/cutoff-switch") == 1) {
		eng_one_auto_startt.stop();
		eng_one_man_startt.stop();
		eng_one_n2_checkt.stop();
		setprop("/controls/engines/engine[0]/igniter-a", 0);
		setprop("/controls/engines/engine[0]/igniter-b", 0);
		setprop("/controls/engines/engine[0]/man-start", 0);
		setprop("/systems/pneumatic/eng1-starter", 0);
		setprop("/controls/engines/engine[0]/starter", 0);
		setprop("/controls/engines/engine[0]/cutoff", 1);
		setprop("/engines/engine[0]/state", 0);
		interpolate(engines[0].getNode("egt-actual"), 0, egt_shutdown_time);
		eng_one_n2_checkt.stop();
	}
});

setlistener("/controls/engines/engine[0]/man-start", func {
	start_one_mancheck();
});

var start_one_mancheck = func {
	if (getprop("/controls/engines/engine[0]/man-start") == 1) {
		if (getprop("/controls/engines/engine-start-switch") == 2 and (getprop("/controls/engines/engine[0]/cutoff-switch") == 1)) {
			setprop("/systems/pneumatic/eng1-starter", 1);
			settimer(start_one_mancheck_b, 0.5);
		}
	} else {
		if (getprop("/engines/engine[0]/state") == 1 or getprop("/engines/engine[0]/state") == 2) {
			setprop("/systems/pneumatic/eng1-starter", 0);
			setprop("/engines/engine[0]/state", 0);
			setprop("/controls/engines/engine[0]/starter", 0);
		}
	}
}

var start_one_mancheck_b = func {
	if (getprop("/systems/pneumatic/total-psi") >= 28) {
		setprop("/engines/engine[0]/state", 1);
		setprop("/controls/engines/engine[0]/starter", 1);
	}
}

var start_one_check = func {
	if (getprop("/controls/engines/engine-start-switch") == 2 and getprop("/controls/engines/engine[0]/cutoff-switch") == 0) {
		setprop("/systems/pneumatic/eng1-starter", 1);
		settimer(start_one_check_b, 0.5);
	}
}

var start_one_check_b = func {
	if ((getprop("/controls/engines/engine-start-switch") == 2) and (getprop("/systems/pneumatic/total-psi") >= 28) and (getprop("/controls/engines/engine[0]/cutoff-switch") == 0)) {
		auto_start_one();
	}
}

setlistener("/controls/engines/engine[1]/cutoff-switch", func {
	if (getprop("/controls/engines/engine[1]/cutoff-switch") == 0) {
		if (getprop("/controls/engines/engine[1]/man-start") == 0) {
			start_two_check();
		} else if (getprop("/controls/engines/engine[1]/man-start") == 1) {
			eng_two_man_startt.start();
		}
	} else if (getprop("/controls/engines/engine[1]/cutoff-switch") == 1) {
		eng_two_auto_startt.stop();
		eng_two_man_startt.stop();
		eng_two_n2_checkt.stop();
		setprop("/controls/engines/engine[1]/igniter-a", 0);
		setprop("/controls/engines/engine[1]/igniter-b", 0);
		setprop("/controls/engines/engine[1]/man-start", 0);
		setprop("/systems/pneumatic/eng2-starter", 0);
		setprop("/controls/engines/engine[1]/starter", 0);
		setprop("/controls/engines/engine[1]/cutoff", 1);
		setprop("/engines/engine[1]/state", 0);
		interpolate(engines[1].getNode("egt-actual"), 0, egt_shutdown_time);
	}
});

setlistener("/controls/engines/engine[1]/man-start", func {
	start_two_mancheck();
});

var start_two_mancheck = func {
	if (getprop("/controls/engines/engine[1]/man-start") == 1) {
		if (getprop("/controls/engines/engine-start-switch") == 2 and (getprop("/controls/engines/engine[1]/cutoff-switch") == 1)) {
			setprop("/systems/pneumatic/eng2-starter", 1);
			settimer(start_two_mancheck_b, 0.5);
		}
	} else {
		if (getprop("/engines/engine[1]/state") == 1 or getprop("/engines/engine[1]/state") == 2) {
			setprop("/systems/pneumatic/eng2-starter", 0);
			setprop("/engines/engine[1]/state", 0);
			setprop("/controls/engines/engine[1]/starter", 0);
		}
	}
}

var start_two_mancheck_b = func {
	if (getprop("/systems/pneumatic/total-psi") >= 28) {
		setprop("/engines/engine[1]/state", 1);
		setprop("/controls/engines/engine[1]/starter", 1);
	}
}

var start_two_check = func {
	if (getprop("/controls/engines/engine-start-switch") == 2 and getprop("/controls/engines/engine[1]/cutoff-switch") == 0) {
		setprop("/systems/pneumatic/eng2-starter", 1);
		settimer(start_two_check_b, 0.5);
	}
}

var start_two_check_b = func {
	if ((getprop("/controls/engines/engine-start-switch") == 2) and (getprop("/systems/pneumatic/total-psi") >= 28) and (getprop("/controls/engines/engine[1]/cutoff-switch") == 0)) {
		auto_start_two();
	}
}

####################
# Start Engine One #
####################

var auto_start_one = func {
	setprop("/engines/engine[0]/state", 1);
	setprop("/controls/engines/engine[0]/starter", 1);
	eng_one_auto_startt.start();
}

var eng_one_auto_start = func {
	if (getprop("/engines/engine[0]/n2") >= 24.1) {
		eng_one_auto_startt.stop();
		setprop("/engines/engine[0]/state", 2);
		setprop("/controls/engines/engine[0]/cutoff", 0);
		if (getprop("/controls/engines/engine[0]/last-igniter") == "B") {
			setprop("/controls/engines/engine[0]/igniter-a", 1);
			setprop("/controls/engines/engine[0]/igniter-b", 0);
			setprop("/controls/engines/engine[0]/last-igniter", "A");
		} else if (getprop("/controls/engines/engine[0]/last-igniter") == "A") {
			setprop("/controls/engines/engine[0]/igniter-a", 0);
			setprop("/controls/engines/engine[0]/igniter-b", 1);
			setprop("/controls/engines/engine[0]/last-igniter", "B");
		}
		interpolate(engines[0].getNode("egt-actual"), egt_start, egt_lightup_time);
		eng_one_n2_checkt.start();
	}
}

var eng_one_man_start = func {
	if (getprop("/engines/engine[0]/n2") >= 16.7) {
		eng_one_man_startt.stop();
		setprop("/engines/engine[0]/state", 2);
		setprop("/controls/engines/engine[0]/cutoff", 0);
		setprop("/controls/engines/engine[0]/igniter-a", 1);
		setprop("/controls/engines/engine[0]/igniter-b", 1);
		interpolate(engines[0].getNode("egt-actual"), egt_start, egt_lightup_time);
		eng_one_n2_checkt.start();
	}
}

var eng_one_n2_check = func {
	if (getprop("/engines/engine[0]/egt-actual") >= egt_start) {
		interpolate(engines[0].getNode("egt-actual"), egt_min, egt_lightdn_time);
	}
	if (getprop("/engines/engine[0]/n2") >= 43.0) {
		eng_one_n2_checkt.stop();
		setprop("/controls/engines/engine[0]/igniter-a", 0);
		setprop("/controls/engines/engine[0]/igniter-b", 0);
		setprop("/systems/pneumatic/eng1-starter", 0);
		setprop("/engines/engine[0]/state", 3);
	}
}

####################
# Start Engine Two #
####################

var auto_start_two = func {
	setprop("/engines/engine[1]/state", 1);
	setprop("/controls/engines/engine[1]/starter", 1);
	eng_two_auto_startt.start();
}

var eng_two_auto_start = func {
	if (getprop("/engines/engine[1]/n2") >= 24.1) {
		eng_two_auto_startt.stop();
		setprop("/engines/engine[1]/state", 2);
		setprop("/controls/engines/engine[1]/cutoff", 0);
		if (getprop("/controls/engines/engine[1]/last-igniter") == "B") {
			setprop("/controls/engines/engine[1]/igniter-a", 1);
			setprop("/controls/engines/engine[1]/igniter-b", 0);
			setprop("/controls/engines/engine[1]/last-igniter", "A");
		} else if (getprop("/controls/engines/engine[1]/last-igniter") == "A") {
			setprop("/controls/engines/engine[1]/igniter-a", 0);
			setprop("/controls/engines/engine[1]/igniter-b", 1);
			setprop("/controls/engines/engine[1]/last-igniter", "B");
		}
		interpolate(engines[1].getNode("egt-actual"), egt_start, egt_lightup_time);
		eng_two_n2_checkt.start();
	}
}

var eng_two_man_start = func {
	if (getprop("/engines/engine[1]/n2") >= 16.7) {
		eng_two_man_startt.stop();
		setprop("/engines/engine[1]/state", 2);
		setprop("/controls/engines/engine[1]/cutoff", 0);
		setprop("/controls/engines/engine[1]/igniter-a", 1);
		setprop("/controls/engines/engine[1]/igniter-b", 1);
		interpolate(engines[1].getNode("egt-actual"), egt_start, egt_lightup_time);
		eng_two_n2_checkt.start();
	}
}

var eng_two_n2_check = func {
	if (getprop("/engines/engine[1]/egt-actual") >= egt_start) {
		interpolate(engines[1].getNode("egt-actual"), egt_min, egt_lightdn_time);
	}
	if (getprop("/engines/engine[1]/n2") >= 43.0) {
		eng_two_n2_checkt.stop();
		setprop("/controls/engines/engine[1]/igniter-a", 0);
		setprop("/controls/engines/engine[1]/igniter-b", 0);
		setprop("/systems/pneumatic/eng2-starter", 0);
		setprop("/engines/engine[1]/state", 3);
	}
}

#############
# Start APU #
#############

setlistener("/controls/APU/start", func {
	if ((getprop("/controls/APU/master") == 1) and (getprop("/controls/APU/start") == 1)) {
		if (getprop("/systems/acconfig/autoconfig-running") == 0) {
			interpolate("/systems/apu/rpm", apu_max, spinup_time);
			apu_egt_checkt.start();
		} else if (getprop("/systems/acconfig/autoconfig-running") == 1) {
			interpolate("/systems/apu/rpm", apu_max, 5);
			interpolate("/systems/apu/egt", apu_egt_max, 5);
		}
	} else if (getprop("/controls/APU/master") == 0) {
		apu_egt_checkt.stop();
		apu_stop();
	}
});

var apu_egt_check = func {
	if (getprop("/systems/apu/rpm") >= 28) {
		apu_egt_checkt.stop();
		interpolate("/systems/apu/egt", apu_egt_max, 5);
		apu_egt2_checkt.start();
	}
}

var apu_egt2_check = func {
	if (getprop("/systems/apu/egt") >= 643) {
		apu_egt2_checkt.stop();
		interpolate("/systems/apu/egt", apu_egt_min, 20);
	}
}

############
# Stop APU #
############

setlistener("/controls/APU/master", func {
	if (getprop("/controls/APU/master") == 0) {
		setprop("/controls/APU/start", 0);
		apu_egt_checkt.stop();
		apu_egt2_checkt.stop();
		apu_stop();
	}
});

var apu_stop = func {
	interpolate("/systems/apu/rpm", 0, 30);
	interpolate("/systems/apu/egt", 42, 30);
}

#######################
# Various other stuff #
#######################

setlistener("/controls/engines/engine-start-switch", func {
	if (getprop("/engines/engine[0]/state") == 0) {
		start_one_check();
		start_one_mancheck();
	}
	if (getprop("/engines/engine[1]/state") == 0) {
		start_two_check();
		start_two_mancheck();
	}
	if ((getprop("/controls/engines/engine-start-switch") == 0) or (getprop("/controls/engines/engine-start-switch") == 1)) {
		if (getprop("/engines/engine[0]/state") == 1 or getprop("/engines/engine[0]/state") == 2) {
			setprop("/controls/engines/engine[0]/starter", 0);
			setprop("/controls/engines/engine[0]/cutoff", 1);
			setprop("/systems/pneumatic/eng1-starter", 0);
			setprop("/engines/engine[0]/state", 0);
			interpolate(engines[0].getNode("egt-actual"), 0, egt_shutdown_time);
		}
		if (getprop("/engines/engine[1]/state") == 1 or getprop("/engines/engine[1]/state") == 2) {
			setprop("/controls/engines/engine[1]/starter", 0);
			setprop("/controls/engines/engine[1]/cutoff", 1);
			setprop("/systems/pneumatic/eng2-starter", 0);
			setprop("/engines/engine[1]/state", 0);
			interpolate(engines[1].getNode("egt-actual"), 0, egt_shutdown_time);
		}
	}
});

setlistener("/systems/pneumatic/start-psi", func {
	if (getprop("/systems/pneumatic/total-psi") < 12) {
		if (getprop("/engines/engine[0]/state") == 1 or getprop("/engines/engine[0]/state") == 2) {
			setprop("/controls/engines/engine[0]/starter", 0);
			setprop("/controls/engines/engine[0]/cutoff", 1);
			setprop("/systems/pneumatic/eng1-starter", 0);
			setprop("/engines/engine[0]/state", 0);
			interpolate(engines[0].getNode("egt-actual"), 0, egt_shutdown_time);
		}
		if (getprop("/engines/engine[1]/state") == 1 or getprop("/engines/engine[1]/state") == 2) {
			setprop("/controls/engines/engine[1]/starter", 0);
			setprop("/controls/engines/engine[1]/cutoff", 1);
			setprop("/systems/pneumatic/eng2-starter", 0);
			setprop("/engines/engine[1]/state", 0);
			interpolate(engines[1].getNode("egt-actual"), 0, egt_shutdown_time);
		}
	}
});

var doIdleThrust = func {
	setprop("/controls/engines/engine[0]/throttle", 0.0);
	setprop("/controls/engines/engine[1]/throttle", 0.0);
}

#########################
# Reverse Thrust System #
#########################

var toggleFastRevThrust = func {
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	if (state1 == "IDLE" and state2 == "IDLE" and getprop("/controls/engines/engine[0]/reverser") == "0" and getprop("/controls/engines/engine[1]/reverser") == "0" and getprop("/gear/gear[1]/wow") == 1 and getprop("/gear/gear[2]/wow") == 1) {
		interpolate("/engines/engine[0]/reverser-pos-norm", 1, 1.4);
		interpolate("/engines/engine[1]/reverser-pos-norm", 1, 1.4);
		setprop("/controls/engines/engine[0]/reverser", 1);
		setprop("/controls/engines/engine[1]/reverser", 1);
		setprop("/controls/engines/engine[0]/throttle-rev", 0.5);
		setprop("/controls/engines/engine[1]/throttle-rev", 0.5);
		setprop("/fdm/jsbsim/propulsion/engine[0]/reverser-angle-rad", 3.14);
		setprop("/fdm/jsbsim/propulsion/engine[1]/reverser-angle-rad", 3.14);
	} else if ((getprop("/controls/engines/engine[0]/reverser") == "1") or (getprop("/controls/engines/engine[1]/reverser") == "1") and (getprop("/gear/gear[1]/wow") == 1) and (getprop("/gear/gear[2]/wow") == 1)) {
		setprop("/controls/engines/engine[0]/throttle-rev", 0);
		setprop("/controls/engines/engine[1]/throttle-rev", 0);
		interpolate("/engines/engine[0]/reverser-pos-norm", 0, 1.0);
		interpolate("/engines/engine[1]/reverser-pos-norm", 0, 1.0);
		setprop("/fdm/jsbsim/propulsion/engine[0]/reverser-angle-rad", 0);
		setprop("/fdm/jsbsim/propulsion/engine[1]/reverser-angle-rad", 0);
		setprop("/controls/engines/engine[0]/reverser", 0);
		setprop("/controls/engines/engine[1]/reverser", 0);
	}
}

var doRevThrust = func {
	if (getprop("/controls/engines/engine[0]/reverser") == "1" and getprop("/controls/engines/engine[1]/reverser") == "1" and getprop("/gear/gear[1]/wow") == 1 and getprop("/gear/gear[2]/wow") == 1) {
		var pos1 = getprop("/controls/engines/engine[0]/throttle-rev");
		var pos2 = getprop("/controls/engines/engine[1]/throttle-rev");
		if (pos1 < 0.5) {
			setprop("/controls/engines/engine[0]/throttle-rev", pos1 + 0.167);
		}
		if (pos2 < 0.5) {
			setprop("/controls/engines/engine[1]/throttle-rev", pos2 + 0.167);
		}
	}
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	if (state1 == "IDLE" and state2 == "IDLE" and getprop("/controls/engines/engine[0]/reverser") == "0" and getprop("/controls/engines/engine[1]/reverser") == "0" and getprop("/gear/gear[1]/wow") == 1 and getprop("/gear/gear[2]/wow") == 1) {
		setprop("/controls/engines/engine[0]/throttle-rev", 0);
		setprop("/controls/engines/engine[1]/throttle-rev", 0);
		interpolate("/engines/engine[0]/reverser-pos-norm", 1, 1.4);
		interpolate("/engines/engine[1]/reverser-pos-norm", 1, 1.4);
		setprop("/controls/engines/engine[0]/reverser", 1);
		setprop("/controls/engines/engine[1]/reverser", 1);
		setprop("/fdm/jsbsim/propulsion/engine[0]/reverser-angle-rad", 3.14);
		setprop("/fdm/jsbsim/propulsion/engine[1]/reverser-angle-rad", 3.14);
	}
}

var unRevThrust = func {
	if (getprop("/controls/engines/engine[0]/reverser") == "1" or getprop("/controls/engines/engine[1]/reverser") == "1") {
		var pos1 = getprop("/controls/engines/engine[0]/throttle-rev");
		var pos2 = getprop("/controls/engines/engine[1]/throttle-rev");
		if (pos1 > 0.0) {
			setprop("/controls/engines/engine[0]/throttle-rev", pos1 - 0.167);
		} else {
			unRevThrust_b();
		}
		if (pos2 > 0.0) {
			setprop("/controls/engines/engine[1]/throttle-rev", pos2 - 0.167);
		} else {
			unRevThrust_b();
		}
	}
}

var unRevThrust_b = func {
	setprop("/controls/engines/engine[0]/throttle-rev", 0);
	setprop("/controls/engines/engine[1]/throttle-rev", 0);
	interpolate("/engines/engine[0]/reverser-pos-norm", 0, 1.0);
	interpolate("/engines/engine[1]/reverser-pos-norm", 0, 1.0);
	setprop("/fdm/jsbsim/propulsion/engine[0]/reverser-angle-rad", 0);
	setprop("/fdm/jsbsim/propulsion/engine[1]/reverser-angle-rad", 0);
	setprop("/controls/engines/engine[0]/reverser", 0);
	setprop("/controls/engines/engine[1]/reverser", 0);
}

# Timers
var eng_one_auto_startt = maketimer(0.5, eng_one_auto_start);
var eng_one_man_startt = maketimer(0.5, eng_one_man_start);
var eng_one_n2_checkt = maketimer(0.5, eng_one_n2_check);
var eng_two_auto_startt = maketimer(0.5, eng_two_auto_start);
var eng_two_man_startt = maketimer(0.5, eng_two_man_start);
var eng_two_n2_checkt = maketimer(0.5, eng_two_n2_check);
var apu_egt_checkt = maketimer(0.5, apu_egt_check);
var apu_egt2_checkt = maketimer(0.5, apu_egt2_check);
