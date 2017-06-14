# A3XX FMGC/Autoflight
# Joshua Davidson (it0uchpods) and Jonathan Redpath (legoboyvdlp)

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
setprop("/FMGC/internal/ils-mcdu", "XXX/999.99");
setprop("/FMGC/internal/vor1-mcdu", "XXX/999.99");
setprop("/FMGC/internal/vor2-mcdu", "999.99/XXX");

var FMGCinit = func {
	setprop("/FMGC/status/to-state", 0);
	setprop("/FMGC/status/phase", "0"); # 0 is Preflight 1 is Takeoff 2 is Climb 3 is Cruise 4 is Descent 5 is Decel/Approach 6 is Go Around 7 is Done
	setprop("/FMGC/internal/tropo", 36090);
	setprop("/FMGC/internal/overspeed", 338);
	setprop("/FMGC/internal/mng-spd", 157);
	setprop("/FMGC/internal/mng-spd-cmd", 157);
	setprop("/FMGC/internal/mng-kts-mach", 0);
	setprop("/FMGC/internal/mach-switchover", 0);
	setprop("/it-autoflight/settings/reduc-agl-ft", 3000);
	setprop("/FMGC/internal/decel", 0);
	setprop("/FMGC/internal/loc-source", "NAV0");
	phasecheck.start();
	various.start();
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
	var gear1 = getprop("/gear/gear[1]/wow");
	var gear2 = getprop("/gear/gear[2]/wow");
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	var flaps = getprop("/controls/flight/flap-pos");
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
	var dep = getprop("/FMGC/internal/dep-arpt");
	var arr = getprop("/FMGC/internal/arr-arpt");
	setprop("/autopilot/route-manager/departure/airport", dep);
	setprop("/autopilot/route-manager/destination/airport", arr);
	if (getprop("/autopilot/route-manager/active") != 1) {
		fgcommand("activate-flightplan", props.Node.new({"activate": 1}));
	}
}

setlistener("/FMGC/internal/cruise-ft", func {
	setprop("/autopilot/route-manager/cruise/altitude-ft", getprop("/FMGC/internal/cruise-ft"));
});

################
# Flight Phase #
################

var phasecheck = maketimer(0.2, func {
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
	
	if ((((n1_left >= 85) and (n1_right >= 85)) or (gs > 90 )) and flaps < 4 and (mode == "SRS")) {
		setprop("/FMGC/status/phase", "1");
		setprop("/systems/pressurization/mode", "TO");
	}
	
	if ((aglalt >= reduc_agl_ft) and (alt <= cruiseft) and (phase == "1") and (phase != "4") and (mode != "SRS")) {
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
	} else {
		setprop("/FMGC/internal/decel", 0);
	}
	
	if ((phase == "5") and (state1 == "TOGA") and (state2 == "TOGA")) {
		setprop("/FMGC/status/phase", "6");
		setprop("/it-autoflight/input/toga", 1);
	}
	
	if ((phase == "6") and ((vertmode == "G/A CLB") or (vertmode == "SPD CLB") or (vertmode == "CLB") or ((vertmode == "V/S") and (targetvs > 0)) or ((vertmode == "FPA") and (targetfpa > 0))) and (alt <= targetalt)) {
		setprop("/FMGC/status/phase", "2");
	}
	
	if ((wowl and wowr) and (gs < 20) and (phase == "5")) {
		setprop("/FMGC/status/phase", "7");
		var fd1 = getprop("/it-autoflight/input/fd1");
		var fd2 = getprop("/it-autoflight/input/fd2");
		APinit();
		FMGCinit();
		mcdu1.MCDU_reset();
		mcdu2.MCDU_reset();
		setprop("/it-autoflight/input/fd1", fd1);
		setprop("/it-autoflight/input/fd2", fd2);
		press_init();
	}
	
	var flap = getprop("/controls/flight/flap-pos");
	if (flap == 0) {
		setprop("/FMGC/internal/overspeed", 338);
		setprop("/FMGC/internal/minspeed", 204);
	} else if (flap == 1) {
		setprop("/FMGC/internal/overspeed", 216);
		setprop("/FMGC/internal/minspeed", 188);
	} else if (flap == 2) {
		setprop("/FMGC/internal/overspeed", 207);
		setprop("/FMGC/internal/minspeed", 171);
	} else if (flap == 3) {
		setprop("/FMGC/internal/overspeed", 189);
		setprop("/FMGC/internal/minspeed", 159);
	} else if (flap == 4) {
		setprop("/FMGC/internal/overspeed", 174);
		setprop("/FMGC/internal/minspeed", 149);
	} else if (flap == 5) {
		setprop("/FMGC/internal/overspeed", 163);
		setprop("/FMGC/internal/minspeed", 139);
	}
});

var various = maketimer(1, func {
	if (getprop("/engines/engine[0]/state") == 3 and getprop("/engines/engine[1]/state") != 3) {
		setprop("/it-autoflight/settings/reduc-agl-ft", getprop("/FMGC/internal/eng-out-reduc"));
	} else if (getprop("/engines/engine[0]/state") != 3 and getprop("/engines/engine[1]/state") == 3) {
		setprop("/it-autoflight/settings/reduc-agl-ft", getprop("/FMGC/internal/eng-out-reduc"));
	} else {
		setprop("/it-autoflight/settings/reduc-agl-ft", getprop("/FMGC/internal/reduc-agl-ft"));
	}
	nav0();
	nav1();
});

var nav0 = func {
	var freqnav0uf = getprop("/instrumentation/nav[0]/frequencies/selected-mhz");
	var freqnav0 = sprintf("%.2f", freqnav0uf);
	var namenav0 = getprop("/instrumentation/nav[0]/nav-id");
	if (freqnav0 >= 108.10 and freqnav0 <= 117.95) {
		if (namenav0 != "") {
			setprop("/FMGC/internal/ils-mcdu", namenav0 ~ "/" ~ freqnav0);
			setprop("/FMGC/internal/vor1-mcdu", namenav0 ~ "/" ~ freqnav0);
		} else {
			setprop("/FMGC/internal/ils-mcdu", freqnav0);
			setprop("/FMGC/internal/vor1-mcdu", freqnav0);
		}
	}
}

var nav1 = func {
	var freqnav1uf = getprop("/instrumentation/nav[1]/frequencies/selected-mhz");
	var freqnav1 = sprintf("%.2f", freqnav1uf);
	var namenav1 = getprop("/instrumentation/nav[1]/nav-id");
	if (freqnav1 >= 108.10 and freqnav1 <= 117.95) {
		if (namenav1 != "") {
			setprop("/FMGC/internal/vor2-mcdu", namenav1 ~ "/" ~ freqnav1);
		} else {
			setprop("/FMGC/internal/vor2-mcdu", freqnav1);
		}
	}
}

#################
# Managed Speed #
#################

var ManagedSPD = maketimer(0.25, func {
	if (getprop("/FMGC/internal/cruise-lvl-set") == 1 and getprop("/FMGC/internal/cost-index-set") == 1) {
		if (getprop("/it-autoflight/input/spd-managed") == 1) {
			var alt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
			var mode = getprop("/modes/pfd/fma/pitch-mode");
			var ias = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
			var mach = getprop("/instrumentation/airspeed-indicator/indicated-mach");
			var ktsmach = getprop("/it-autoflight/input/kts-mach");
			var mngktsmach = getprop("/FMGC/internal/mng-kts-mach");
			var mng_spd = getprop("/FMGC/internal/mng-spd");
			var mng_spd_cmd = getprop("/FMGC/internal/mng-spd-cmd");
			var kts_sel = getprop("/it-autoflight/input/spd-kts");
			var mach_sel = getprop("/it-autoflight/input/spd-mach");
			var srsSPD = getprop("/it-autoflight/settings/togaspd");
			var phase = getprop("/FMGC/status/phase"); # 0 is Preflight 1 is Takeoff 2 is Climb 3 is Cruise 4 is Descent 5 is Decel/Approach 6 is Go Around 7 is Done
			var flap = getprop("/controls/flight/flap-pos");
			var overspeed = getprop("/FMGC/internal/overspeed");
			var minspeed = getprop("/FMGC/internal/minspeed");
			var mach_switchover = getprop("/FMGC/internal/mach-switchover");
			var decel = getprop("/FMGC/internal/decel");
			
			var mng_alt_spd_cmd = getprop("/FMGC/internal/mng-alt-spd");
			var mng_alt_spd = math.round(mng_alt_spd_cmd, 1);
			
			var mng_alt_mach_cmd = getprop("/FMGC/internal/mng-alt-mach");
			var mng_alt_mach = math.round(mng_alt_mach_cmd, 0.001);
			
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
			} else if (phase == 2 and alt <= 10050) {
				if (mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 0);
				}
				if (mng_spd_cmd != 250) {
					setprop("/FMGC/internal/mng-spd-cmd", 250);
				}
			} else if ((phase == 2 or phase == 3) and alt > 10100 and !mach_switchover) {
				if (mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 0);
				}
				if (mng_spd_cmd != mng_alt_spd) {
					setprop("/FMGC/internal/mng-spd-cmd", mng_alt_spd);
				}
			} else if ((phase == 2 or phase == 3) and alt > 10100 and mach_switchover) {
				if (!mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 1);
				}
				if (mng_spd_cmd != mng_alt_mach) {
					setprop("/FMGC/internal/mng-spd-cmd", mng_alt_mach);
				}
			} else if (phase == 4 and alt > 11100 and !mach_switchover) {
				if (mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 0);
				}
				if (mng_spd_cmd != mng_alt_spd) {
					setprop("/FMGC/internal/mng-spd-cmd", mng_alt_spd);
				}
			} else if (phase == 4 and alt > 11100 and mach_switchover) {
				if (!mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 1);
				}
				if (mng_spd_cmd != mng_alt_mach) {
					setprop("/FMGC/internal/mng-spd-cmd", mng_alt_mach);
				}
			} else if ((phase == 4 or phase == 5 or phase == 6) and alt <= 11050) {
				if (mngktsmach) {
					setprop("/FMGC/internal/mng-kts-mach", 0);
				}
				if (mng_spd_cmd != 250 and !decel) {
					setprop("/FMGC/internal/mng-spd-cmd", 250);
				} else if (mng_spd_cmd != minspeed and decel) {
					setprop("/FMGC/internal/mng-spd-cmd", minspeed);
				}
			}
			
			var mng_spd_cmd = getprop("/FMGC/internal/mng-spd-cmd");
			
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
			
			var mng_spd = getprop("/FMGC/internal/mng-spd");
			
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
