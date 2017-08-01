# A3XX FMGC/Autoflight
# Joshua Davidson (it0uchpods) and Jonathan Redpath (legoboyvdlp)

#######################################
# Copyright (c) A3XX Development Team #
#######################################

##################
# Init Functions #
##################

setprop("/FMGC/internal/overspeed", 338);
setprop("/FMGC/internal/minspeed", 204);
setprop("/position/gear-agl-ft", 0);
setprop("/FMGC/internal/mng-spd", 157);
setprop("/FMGC/internal/mng-spd-cmd", 157);
setprop("/FMGC/internal/mng-kts-mach", 0);
setprop("/FMGC/internal/mach-switchover", 0);
setprop("/it-autoflight/settings/reduc-agl-ft", 3000);
setprop("/it-autoflight/internal/vert-speed-fpm", 0);
setprop("/it-autoflight/output/fma-pwr", 0);
setprop("/instrumentation/nav[0]/nav-id", "XXX");
setprop("/instrumentation/nav[1]/nav-id", "XXX");
setprop("/FMGC/internal/ils1-mcdu", "XXX/999.99");
setprop("/FMGC/internal/ils2-mcdu", "XXX/999.99");
setprop("/FMGC/internal/vor1-mcdu", "XXX/999.99");
setprop("/FMGC/internal/vor2-mcdu", "999.99/XXX");

setlistener("/sim/signals/fdm-initialized", func {
	var database1 = getprop("/FMGC/internal/navdatabase");
	var database2 = getprop("/FMGC/internal/navdatabase2");
	var code1 = getprop("/FMGC/internal/navdatabasecode");
	var code2 = getprop("/FMGC/internal/navdatabasecode2");
	var gear1 = getprop("/gear/gear[1]/wow");
	var gear2 = getprop("/gear/gear[2]/wow");
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	var flaps = getprop("/controls/flight/flap-pos");
	var dep = getprop("/FMGC/internal/dep-arpt");
	var arr = getprop("/FMGC/internal/arr-arpt");
	var n1_left = getprop("/engines/engine[0]/n1");
	var n1_right = getprop("/engines/engine[1]/n1");
	var flaps = getprop("/controls/flight/flap-pos");
	var modelat = getprop("/modes/pfd/fma/roll-mode");
	var mode = getprop("/modes/pfd/fma/pitch-mode");
	var gs = getprop("/velocities/groundspeed-kt");
	var alt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
	var aglalt = getprop("/position/gear-agl-ft");
	var cruiseft = getprop("/FMGC/internal/cruise-ft");
	var cruiseft_b = getprop("/FMGC/internal/cruise-ft") - 200;
	var newcruise = getprop("/it-autoflight/internal/alt");
	var phase = getprop("/FMGC/status/phase");
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	var wowl = getprop("/gear/gear[1]/wow");
	var wowr = getprop("/gear/gear[2]/wow");
	var targetalt = getprop("/it-autoflight/internal/alt");
	var targetvs = getprop("/it-autoflight/input/vs");
	var targetfpa = getprop("/it-autoflight/input/fpa");
	var vertmode = getprop("/modes/pfd/fma/pitch-mode");
	var reduc_agl_ft = getprop("/it-autoflight/settings/reduc-agl-ft");
	var locarm = getprop("/it-autopilot/output/loc-armed");
	var apprarm = getprop("/it-autopilot/output/appr-armed");
	var gear0 = getprop("/gear/gear[0]/wow");
	var fd1 = getprop("/it-autoflight/input/fd1");
	var fd2 = getprop("/it-autoflight/input/fd2");
	var spd = getprop("/it-autoflight/input/spd-kts");
	var hdg = getprop("/it-autoflight/input/hdg");
	var alt = getprop("/it-autoflight/input/alt");
	var altitude = getprop("/instrumentation/altimeter/indicated-altitude-ft");
	var flap = getprop("/controls/flight/flap-pos");
	var freqnav0uf = getprop("/instrumentation/nav[0]/frequencies/selected-mhz");
	var freqnav0 = sprintf("%.2f", freqnav0uf);
	var namenav0 = getprop("/instrumentation/nav[0]/nav-id");
	var freqnav1uf = getprop("/instrumentation/nav[1]/frequencies/selected-mhz");
	var freqnav1 = sprintf("%.2f", freqnav1uf);
	var namenav1 = getprop("/instrumentation/nav[1]/nav-id");
	var freqnav2uf = getprop("/instrumentation/nav[2]/frequencies/selected-mhz");
	var freqnav2 = sprintf("%.2f", freqnav2uf);
	var namenav2 = getprop("/instrumentation/nav[2]/nav-id");
	var freqnav3uf = getprop("/instrumentation/nav[3]/frequencies/selected-mhz");
	var freqnav3 = sprintf("%.2f", freqnav3uf);
	var namenav3 = getprop("/instrumentation/nav[3]/nav-id");
	var freqadf0uf = getprop("/instrumentation/adf[0]/frequencies/selected-khz");
	var freqadf0 = sprintf("%.2f", freqadf0uf);
	var nameadf0 = getprop("/instrumentation/adf[0]/ident");
	var freqadf1uf = getprop("/instrumentation/adf[1]/frequencies/selected-khz");
	var freqadf1 = sprintf("%.2f", freqadf1uf);
	var nameadf1 = getprop("/instrumentation/adf[1]/ident");
	var ias = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
	var mach = getprop("/instrumentation/airspeed-indicator/indicated-mach");
	var ktsmach = getprop("/it-autoflight/input/kts-mach");
	var mngktsmach = getprop("/FMGC/internal/mng-kts-mach");
	var mng_spd = getprop("/FMGC/internal/mng-spd");
	var mng_spd_cmd = getprop("/FMGC/internal/mng-spd-cmd");
	var kts_sel = getprop("/it-autoflight/input/spd-kts");
	var mach_sel = getprop("/it-autoflight/input/spd-mach");
	var srsSPD = getprop("/it-autoflight/settings/togaspd");
	var overspeed = getprop("/FMGC/internal/overspeed");
	var minspeed = getprop("/FMGC/internal/minspeed");
	var mach_switchover = getprop("/FMGC/internal/mach-switchover");
	var decel = getprop("/FMGC/internal/decel");
	var mng_alt_spd_cmd = getprop("/FMGC/internal/mng-alt-spd");
	var mng_alt_spd = 0;
	var mng_alt_mach_cmd = getprop("/FMGC/internal/mng-alt-mach");
	var mng_alt_mach = 0;
	var mng_spd_cmd = getprop("/FMGC/internal/mng-spd-cmd");
	var mng_spd = getprop("/FMGC/internal/mng-spd");
});

var FMGCinit = func {
	setprop("/FMGC/status/to-state", 0);
	setprop("/FMGC/status/phase", "0"); # 0 is Preflight 1 is Takeoff 2 is Climb 3 is Cruise 4 is Descent 5 is Decel/Approach 6 is Go Around 7 is Done
	setprop("/FMGC/internal/overspeed", 338);
	setprop("/FMGC/internal/mng-spd", 157);
	setprop("/FMGC/internal/mng-spd-cmd", 157);
	setprop("/FMGC/internal/mng-kts-mach", 0);
	setprop("/FMGC/internal/mach-switchover", 0);
	setprop("/it-autoflight/settings/reduc-agl-ft", 3000);
	setprop("/FMGC/internal/decel", 0);
	setprop("/FMGC/internal/loc-source", "NAV0");
	setprop("/FMGC/internal/optalt", 0);
	phasecheck.start();
	various.start();
	various2.start();
}

#############
# TO Status #
#############

setlistener("/gear/gear[1]/wow", func {
	flarecheck();
});

setlistener("/gear/gear[2]/wow", func {
	flarecheck();
});

var flarecheck = func {
	gear1 = getprop("/gear/gear[1]/wow");
	gear2 = getprop("/gear/gear[2]/wow");
	state1 = getprop("/systems/thrust/state1");
	state2 = getprop("/systems/thrust/state2");
	flaps = getprop("/controls/flight/flap-pos");
	if (gear1 == 1 and gear2 == 1 and (state1 == "MCT" or state1 == "MAN THR" or state1 == "TOGA") and (state2 == "MCT" or state2 == "MAN THR" or state2 == "TOGA") and flaps < 4) {
		setprop("/FMGC/status/to-state", 1);
	}
	if (getprop("/position/gear-agl-ft") >= 55) {
		setprop("/FMGC/status/to-state", 0);
	}
	if (gear1 == 1 and gear2 == 1 and getprop("/FMGC/status/to-state") == 0 and flaps >= 4) {
		setprop("/controls/flight/elevator-trim", 0.0);
	}
}

###############
# MCDU Inputs #
###############

var updateARPT = func {
	dep = getprop("/FMGC/internal/dep-arpt");
	arr = getprop("/FMGC/internal/arr-arpt");
	setprop("/autopilot/route-manager/departure/airport", dep);
	setprop("/autopilot/route-manager/destination/airport", arr);
	if (getprop("/autopilot/route-manager/active") != 1) {
		fgcommand("activate-flightplan", props.Node.new({"activate": 1}));
	}
}

setlistener("/FMGC/internal/cruise-ft", func {
	setprop("/autopilot/route-manager/cruise/altitude-ft", getprop("/FMGC/internal/cruise-ft"));
});

############################
# Flight Phase and Various #
############################

var phasecheck = maketimer(0.2, func {
	n1_left = getprop("/engines/engine[0]/n1");
	n1_right = getprop("/engines/engine[1]/n1");
	flaps = getprop("/controls/flight/flap-pos");
	modelat = getprop("/modes/pfd/fma/roll-mode");
	mode = getprop("/modes/pfd/fma/pitch-mode");
	gs = getprop("/velocities/groundspeed-kt");
	alt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
	aglalt = getprop("/position/gear-agl-ft");
	cruiseft = getprop("/FMGC/internal/cruise-ft");
	cruiseft_b = getprop("/FMGC/internal/cruise-ft") - 200;
	newcruise = getprop("/it-autoflight/internal/alt");
	phase = getprop("/FMGC/status/phase");
	state1 = getprop("/systems/thrust/state1");
	state2 = getprop("/systems/thrust/state2");
	wowl = getprop("/gear/gear[1]/wow");
	wowr = getprop("/gear/gear[2]/wow");
	targetalt = getprop("/it-autoflight/internal/alt");
	targetvs = getprop("/it-autoflight/input/vs");
	targetfpa = getprop("/it-autoflight/input/fpa");
	vertmode = getprop("/modes/pfd/fma/pitch-mode");
	reduc_agl_ft = getprop("/it-autoflight/settings/reduc-agl-ft");
	locarm = getprop("/it-autopilot/output/loc-armed");
	apprarm = getprop("/it-autopilot/output/appr-armed");
	gear0 = getprop("/gear/gear[0]/wow");
	
	if ((((n1_left >= 85) and (n1_right >= 85)) or (gs > 90 )) and (mode == "SRS") and gear0 == 1 and phase == 0) {
		setprop("/FMGC/status/phase", "1");
		setprop("/systems/pressurization/mode", "TO");
	}
	
	if ((alt >= reduc_agl_ft) and (alt <= cruiseft) and (phase == "1") and (phase != "4") and (mode != "SRS")) {
		setprop("/FMGC/status/phase", "2");
	}
	
	if (alt >= cruiseft_b and phase == "2" and (mode == "ALT" or mode == mode == "ALT*" or mode == "ALT CRZ")) {
		setprop("/FMGC/status/phase", "3");
		setprop("/systems/pressurization/mode", "CR");
	}
	
	if (alt <= cruiseft and (mode == "DES" or mode == "OP DES") and phase == "3") {
		setprop("/FMGC/status/phase", "4");
		setprop("/systems/pressurization/mode", "DE");
	}
	
	if (getprop("/FMGC/status/to-state") == 0 and flaps >= 3 and ((phase == "3") or (phase == "4")) and alt < 7200) {
		setprop("/FMGC/status/phase", "5");
	}
	
	if (getprop("/autopilot/route-manager/route/num") > 0 and getprop("/autopilot/route-manager/active") == 1 and getprop("/autopilot/route-manager/distance-remaining-nm") <= 15) {
		setprop("/FMGC/internal/decel", 1);
	} else if (getprop("/FMGC/internal/decel") == 1 and phase != 5) {
		setprop("/FMGC/internal/decel", 0);
	}
	
	if ((phase == "5") and (state1 == "TOGA") and (state2 == "TOGA")) {
		setprop("/FMGC/status/phase", "6");
		setprop("/it-autoflight/input/toga", 1);
	}
	
	if ((phase == "6") and ((vertmode == "G/A CLB") or (vertmode == "SPD CLB") or (vertmode == "CLB") or ((vertmode == "V/S") and (targetvs > 0)) or ((vertmode == "FPA") and (targetfpa > 0))) and (alt <= targetalt)) {
		setprop("/FMGC/status/phase", "2");
	}
	
	if ((wowl and wowr) and (gs < 40) and (phase == "2" or phase == "3" or phase == "4" or phase == "5" or phase == "6")) {
		reset_FMGC();
	}
	
	flap = getprop("/controls/flight/flap-pos");
	if (flap == 0) {
		setprop("/FMGC/internal/overspeed", 338);
		setprop("/FMGC/internal/minspeed", 202);
	} else if (flap == 1) {
		setprop("/FMGC/internal/overspeed", 216);
		setprop("/FMGC/internal/minspeed", 184);
	} else if (flap == 2) {
		setprop("/FMGC/internal/overspeed", 207);
		setprop("/FMGC/internal/minspeed", 169);
	} else if (flap == 3) {
		setprop("/FMGC/internal/overspeed", 189);
		setprop("/FMGC/internal/minspeed", 156);
	} else if (flap == 4) {
		setprop("/FMGC/internal/overspeed", 174);
		setprop("/FMGC/internal/minspeed", 147);
	} else if (flap == 5) {
		setprop("/FMGC/internal/overspeed", 163);
		setprop("/FMGC/internal/minspeed", 134);
	}
});

var reset_FMGC = func {
	setprop("/FMGC/status/phase", "7");
	fd1 = getprop("/it-autoflight/input/fd1");
	fd2 = getprop("/it-autoflight/input/fd2");
	spd = getprop("/it-autoflight/input/spd-kts");
	hdg = getprop("/it-autoflight/input/hdg");
	alt = getprop("/it-autoflight/input/alt");
	APinit();
	FMGCinit();
	mcdu1.MCDU_reset();
	mcdu2.MCDU_reset();
	setprop("/it-autoflight/input/fd1", fd1);
	setprop("/it-autoflight/input/fd2", fd2);
	setprop("/it-autoflight/input/spd-kts", spd);
	setprop("/it-autoflight/input/hdg", hdg);
	setprop("/it-autoflight/input/alt", alt);
	setprop("/systems/pressurization/mode", "GN");
	setprop("/systems/pressurization/vs", "0");
	setprop("/systems/pressurization/targetvs", "0");
	setprop("/systems/pressurization/vs-norm", "0");
	setprop("/systems/pressurization/auto", 1);
	setprop("/systems/pressurization/deltap", "0");
	setprop("/systems/pressurization/outflowpos", "0");
	setprop("/systems/pressurization/deltap-norm", "0");
	setprop("/systems/pressurization/outflowpos-norm", "0");
	altitude = getprop("/instrumentation/altimeter/indicated-altitude-ft");
	setprop("/systems/pressurization/cabinalt", altitude);
	setprop("/systems/pressurization/targetalt", altitude); 
	setprop("/systems/pressurization/diff-to-target", "0");
	setprop("/systems/pressurization/ditchingpb", 0);
	setprop("/systems/pressurization/targetvs", "0");
	setprop("/systems/ventilation/cabin/fans", 0); # aircon fans
	setprop("/systems/ventilation/avionics/fan", 0);
	setprop("/systems/ventilation/avionics/extractvalve", "0");
	setprop("/systems/ventilation/avionics/inletvalve", "0");
	setprop("/systems/ventilation/lavatory/extractfan", 0);
	setprop("/systems/ventilation/lavatory/extractvalve", "0");
	setprop("/systems/pressurization/ambientpsi", "0");
	setprop("/systems/pressurization/cabinpsi", "0");
}

var various = maketimer(1, func {
	if (getprop("/engines/engine[0]/state") == 3 and getprop("/engines/engine[1]/state") != 3) {
		setprop("/it-autoflight/settings/reduc-agl-ft", getprop("/FMGC/internal/eng-out-reduc"));
	} else if (getprop("/engines/engine[0]/state") != 3 and getprop("/engines/engine[1]/state") == 3) {
		setprop("/it-autoflight/settings/reduc-agl-ft", getprop("/FMGC/internal/eng-out-reduc"));
	} else {
		setprop("/it-autoflight/settings/reduc-agl-ft", getprop("/FMGC/internal/reduc-agl-ft"));
	}
	
	setprop("/FMGC/internal/gw", math.round(getprop("fdm/jsbsim/inertia/weight-lbs"), 100));
});

var various2 = maketimer(0.5, func {
	nav0();
	nav1();
	nav2();
	nav3();
	adf0();
	adf1();
	if (getprop("/it-autoflight/output/lat") == 0) {
		setprop("/it-autoflight/custom/show-hdg", 1);
	}
});

var nav0 = func {
	var freqnav0uf = getprop("/instrumentation/nav[0]/frequencies/selected-mhz");
	var freqnav0 = sprintf("%.2f", freqnav0uf);
	var namenav0 = getprop("/instrumentation/nav[0]/nav-id");
	if (freqnav0 >= 108.10 and freqnav0 <= 111.95) {
		if (namenav0 != "") {
			setprop("/FMGC/internal/ils1-mcdu", namenav0 ~ "/" ~ freqnav0);
		} else {
			setprop("/FMGC/internal/ils1-mcdu", freqnav0);
		}
	}
}

var nav1 = func {
	var freqnav1uf = getprop("/instrumentation/nav[1]/frequencies/selected-mhz");
	var freqnav1 = sprintf("%.2f", freqnav1uf);
	var namenav1 = getprop("/instrumentation/nav[1]/nav-id");
	if (freqnav1 >= 108.10 and freqnav1 <= 111.95) {
		if (namenav1 != "") {
			setprop("/FMGC/internal/ils2-mcdu", freqnav1 ~ "/" ~ namenav1);
		} else {
			setprop("/FMGC/internal/ils2-mcdu", freqnav1);
		}
	}
}

var nav2 = func {
	var freqnav2uf = getprop("/instrumentation/nav[2]/frequencies/selected-mhz");
	var freqnav2 = sprintf("%.2f", freqnav2uf);
	var namenav2 = getprop("/instrumentation/nav[2]/nav-id");
	if (freqnav2 >= 108.00 and freqnav2 <= 117.95) {
		if (namenav2 != "") {
			setprop("/FMGC/internal/vor1-mcdu", namenav2 ~ "/" ~ freqnav2);
		} else {
			setprop("/FMGC/internal/vor1-mcdu", freqnav2);
		}
	}
}

var nav3 = func {
	var freqnav3uf = getprop("/instrumentation/nav[3]/frequencies/selected-mhz");
	var freqnav3 = sprintf("%.2f", freqnav3uf);
	var namenav3 = getprop("/instrumentation/nav[3]/nav-id");
	if (freqnav3 >= 108.00 and freqnav3 <= 117.95) {
		if (namenav3 != "") {
			setprop("/FMGC/internal/vor2-mcdu", freqnav3 ~ "/" ~ namenav3);
		} else {
			setprop("/FMGC/internal/vor2-mcdu", freqnav3);
		}
	}
}

var adf0 = func {
	var freqadf0uf = getprop("/instrumentation/adf[0]/frequencies/selected-khz");
	var freqadf0 = sprintf("%.2f", freqadf0uf);
	var nameadf0 = getprop("/instrumentation/adf[0]/ident");
	if (freqadf0 >= 190 and freqadf0 <= 1750) {
		if (nameadf0 != "") {
			setprop("/FMGC/internal/adf1-mcdu", nameadf0 ~ "/" ~ freqadf0);
		} else {
			setprop("/FMGC/internal/adf1-mcdu", freqadf0);
		}
	}
}

var adf1 = func {
	var freqadf1uf = getprop("/instrumentation/adf[1]/frequencies/selected-khz");
	var freqadf1 = sprintf("%.2f", freqadf1uf);
	var nameadf1 = getprop("/instrumentation/adf[1]/ident");
	if (freqadf1 >= 190 and freqadf1 <= 1750) {
		if (nameadf1 != "") {
			setprop("/FMGC/internal/adf2-mcdu", freqadf1 ~ "/" ~ nameadf1);
		} else {
			setprop("/FMGC/internal/adf2-mcdu", freqadf1);
		}
	}
}

#################
# Managed Speed #
#################

var ManagedSPD = maketimer(0.25, func {
	if (getprop("/FMGC/internal/cruise-lvl-set") == 1 and getprop("/FMGC/internal/cost-index-set") == 1) {
		if (getprop("/it-autoflight/input/spd-managed") == 1) {
			altitude = getprop("/instrumentation/altimeter/indicated-altitude-ft");
			mode = getprop("/modes/pfd/fma/pitch-mode");
			ias = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
			mach = getprop("/instrumentation/airspeed-indicator/indicated-mach");
			ktsmach = getprop("/it-autoflight/input/kts-mach");
			mngktsmach = getprop("/FMGC/internal/mng-kts-mach");
			mng_spd = getprop("/FMGC/internal/mng-spd");
			mng_spd_cmd = getprop("/FMGC/internal/mng-spd-cmd");
			kts_sel = getprop("/it-autoflight/input/spd-kts");
			mach_sel = getprop("/it-autoflight/input/spd-mach");
			srsSPD = getprop("/it-autoflight/settings/togaspd");
			phase = getprop("/FMGC/status/phase"); # 0 is Preflight 1 is Takeoff 2 is Climb 3 is Cruise 4 is Descent 5 is Decel/Approach 6 is Go Around 7 is Done
			flap = getprop("/controls/flight/flap-pos");
			overspeed = getprop("/FMGC/internal/overspeed");
			minspeed = getprop("/FMGC/internal/minspeed");
			mach_switchover = getprop("/FMGC/internal/mach-switchover");
			decel = getprop("/FMGC/internal/decel");
			
			mng_alt_spd_cmd = getprop("/FMGC/internal/mng-alt-spd");
			mng_alt_spd = math.round(mng_alt_spd_cmd, 1);
			
			mng_alt_mach_cmd = getprop("/FMGC/internal/mng-alt-mach");
			mng_alt_mach = math.round(mng_alt_mach_cmd, 0.001);
			
			if (mach > mng_alt_mach and phase == 2) {
				setprop("/FMGC/internal/mach-switchover", 1);
			}
			
			if (ias > mng_alt_spd and (phase == 4 or phase == 5)) {
				setprop("/FMGC/internal/mach-switchover", 0);
			}
			
			if (mode == "SRS" and phase == 0 or phase == 1) {
				if (mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 0);
				}
				if (mng_spd_cmd != srsSPD) {
					setprop("/FMGC/internal/mng-spd-cmd", srsSPD);
				}
			} else if (phase == 2 and altitude <= 10050) {
				if (mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 0);
				}
				if (mng_spd_cmd != 250) {
					setprop("/FMGC/internal/mng-spd-cmd", 250);
				}
			} else if ((phase == 2 or phase == 3) and altitude > 10100 and !mach_switchover) {
				if (mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 0);
				}
				if (mng_spd_cmd != mng_alt_spd) {
					setprop("/FMGC/internal/mng-spd-cmd", mng_alt_spd);
				}
			} else if ((phase == 2 or phase == 3) and altitude > 10100 and mach_switchover) {
				if (!mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 1);
				}
				if (mng_spd_cmd != mng_alt_mach) {
					setprop("/FMGC/internal/mng-spd-cmd", mng_alt_mach);
				}
			} else if (phase == 4 and altitude > 11100 and !mach_switchover) {
				if (mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 0);
				}
				if (mng_spd_cmd != mng_alt_spd) {
					setprop("/FMGC/internal/mng-spd-cmd", mng_alt_spd);
				}
			} else if (phase == 4 and altitude > 11100 and mach_switchover) {
				if (!mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 1);
				}
				if (mng_spd_cmd != mng_alt_mach) {
					setprop("/FMGC/internal/mng-spd-cmd", mng_alt_mach);
				}
			} else if ((phase == 4 or phase == 5 or phase == 6) and altitude <= 11050) {
				if (mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 0);
				}
				if (mng_spd_cmd != 250 and !decel) {
					setprop("/FMGC/internal/mng-spd-cmd", 250);
				} else if (mng_spd_cmd != minspeed and decel) {
					setprop("/FMGC/internal/mng-spd-cmd", minspeed);
				}
			}
			
			mng_spd_cmd = getprop("/FMGC/internal/mng-spd-cmd");
			
			if (mng_spd_cmd > overspeed) {
				setprop("/FMGC/internal/mng-spd", overspeed);
			} else {
				setprop("/FMGC/internal/mng-spd", mng_spd_cmd);
			}
			
			if (ktsmach and !mngktsmach) {
				setprop("/it-autoflight/input/kts-mach", 0);
			} else if (!ktsmach and mngktsmach) {
				setprop("/it-autoflight/input/kts-mach", 1);
			}
			
			mng_spd = getprop("/FMGC/internal/mng-spd");
			
			if (kts_sel != mng_spd and !ktsmach) {
				setprop("/it-autoflight/input/spd-kts", mng_spd);
			} else if (mach_sel != mng_spd and ktsmach) {
				setprop("/it-autoflight/input/spd-mach", mng_spd);
			}
		} else {
			ManagedSPD.stop();
		}
	} else {
		ManagedSPD.stop();
		libraries.mcpSPDKnbPull();
	}
});

var switchDatabase = func {
	database1 = getprop("/FMGC/internal/navdatabase");
	database2 = getprop("/FMGC/internal/navdatabase2");
	code1 = getprop("/FMGC/internal/navdatabasecode");
	code2 = getprop("/FMGC/internal/navdatabasecode2");
	setprop("/FMGC/internal/navdatabase", database2);
	setprop("/FMGC/internal/navdatabase2", database1);
	setprop("/FMGC/internal/navdatabasecode", code2);
	setprop("/FMGC/internal/navdatabasecode2", code1);
}