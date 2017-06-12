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
		setprop("/FMGC/internal/minspeed", 146);
	} else if (flap == 5) {
		setprop("/FMGC/internal/overspeed", 163);
		setprop("/FMGC/internal/minspeed", 136);
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

#################################
# IT-AUTOFLIGHT Based Autopilot #
#################################

var APinit = func {
	setprop("/it-autoflight/custom/trk-fpa", 0);
	setprop("/it-autoflight/input/kts-mach", 0);
	setprop("/it-autoflight/input/ap1", 0);
	setprop("/it-autoflight/input/ap2", 0);
	setprop("/it-autoflight/input/athr", 0);
	setprop("/it-autoflight/input/fd1", 0);
	setprop("/it-autoflight/input/fd2", 0);
	setprop("/it-autoflight/input/hdg", 360);
	setprop("/it-autoflight/input/alt", 10000);
	setprop("/it-autoflight/input/vs", 0);
	setprop("/it-autoflight/input/fpa", 0);
	setprop("/it-autoflight/input/lat", 5);
	setprop("/it-autoflight/input/lat-arm", 0);
	setprop("/it-autoflight/input/vert", 7);
	setprop("/it-autoflight/input/bank-limit", 25);
	setprop("/it-autoflight/input/trk", 0);
	setprop("/it-autoflight/input/toga", 0);
	setprop("/it-autoflight/input/spd-managed", 0);
	setprop("/it-autoflight/output/ap1", 0);
	setprop("/it-autoflight/output/ap2", 0);
	setprop("/it-autoflight/output/athr", 0);
	setprop("/it-autoflight/output/fd1", 0);
	setprop("/it-autoflight/output/fd2", 0);
	setprop("/it-autoflight/output/loc-armed", 0);
	setprop("/it-autoflight/output/appr-armed", 0);
	setprop("/it-autoflight/output/thr-mode", 2);
	setprop("/it-autoflight/output/lat", 5);
	setprop("/it-autoflight/output/vert", 7);
	setprop("/it-autoflight/output/fma-pwr", 0);
	setprop("/it-autoflight/settings/use-backcourse", 0);
	setprop("/it-autoflight/internal/min-vs", -500);
	setprop("/it-autoflight/internal/max-vs", 500);
	setprop("/it-autoflight/internal/alt", 10000);
	setprop("/it-autoflight/internal/alt", 10000);
	setprop("/it-autoflight/internal/fpa", 0);
	setprop("/it-autoflight/internal/top-of-des-nm", 0);
	setprop("/it-autoflight/mode/thr", "PITCH");
	setprop("/it-autoflight/mode/arm", "HDG");
	setprop("/it-autoflight/mode/lat", "T/O");
	setprop("/it-autoflight/mode/vert", "T/O CLB");
	setprop("/it-autoflight/input/spd-kts", 100);
	setprop("/it-autoflight/input/spd-mach", 0.50);
	update_armst.start();
	thrustmode();
}

# AP 1 Master System
setlistener("/it-autoflight/input/ap1", func {
	var apmas = getprop("/it-autoflight/input/ap1");
	var ac_ess = getprop("/systems/electrical/bus/ac-ess");
	if (apmas == 0) {
		fmabox();
		setprop("/it-autoflight/output/ap1", 0);
		if (getprop("/it-autoflight/sound/enableapoffsound") == 1) {
			setprop("/it-autoflight/sound/apoffsound", 1);
			setprop("/it-autoflight/sound/enableapoffsound", 0);	  
		}
	} else if (apmas == 1 and ac_ess >= 110) {
		if ((getprop("/gear/gear[1]/wow") == 0) and (getprop("/gear/gear[2]/wow") == 0)) {
			fmabox();
			setprop("/it-autoflight/output/ap1", 1);
			setprop("/it-autoflight/sound/enableapoffsound", 1);
			setprop("/it-autoflight/sound/apoffsound", 0);
		}
	}
});

# AP 2 Master System
setlistener("/it-autoflight/input/ap2", func {
	var apmas = getprop("/it-autoflight/input/ap2");
	var ac_ess = getprop("/systems/electrical/bus/ac-ess");
	if (apmas == 0) {
		fmabox();
		setprop("/it-autoflight/output/ap2", 0);
		if (getprop("/it-autoflight/sound/enableapoffsound2") == 1) {
			setprop("/it-autoflight/sound/apoffsound2", 1);	
			setprop("/it-autoflight/sound/enableapoffsound2", 0);	  
		}
	} else if (apmas == 1 and ac_ess >= 110) {
		if ((getprop("/gear/gear[1]/wow") == 0) and (getprop("/gear/gear[2]/wow") == 0)) {
			fmabox();
			setprop("/it-autoflight/output/ap2", 1);
			setprop("/it-autoflight/sound/enableapoffsound2", 1);
			setprop("/it-autoflight/sound/apoffsound2", 0);
		}
	}
});

# AT Master System
setlistener("/it-autoflight/input/athr", func {
	var atmas = getprop("/it-autoflight/input/athr");
	if (atmas == 0) {
		setprop("/it-autoflight/output/athr", 0);
	} else if (atmas == 1) {
		thrustmode();
		setprop("/it-autoflight/output/athr", 1);
	}
});

# Flight Director 1 Master System
setlistener("/it-autoflight/input/fd1", func {
	var fdmas = getprop("/it-autoflight/input/fd1");
	if (fdmas == 0) {
		fmabox();
		setprop("/it-autoflight/output/fd1", 0);
	} else if (fdmas == 1) {
		fmabox();
		setprop("/it-autoflight/output/fd1", 1);
	}
});

# Flight Director 2 Master System
setlistener("/it-autoflight/input/fd2", func {
	var fdmas = getprop("/it-autoflight/input/fd2");
	if (fdmas == 0) {
		fmabox();
		setprop("/it-autoflight/output/fd2", 0);
	} else if (fdmas == 1) {
		fmabox();
		setprop("/it-autoflight/output/fd2", 1);
	}
});

# FMA Boxes and Mode
var fmabox = func {
	var ap1 = getprop("/it-autoflight/output/ap1");
	var ap2 = getprop("/it-autoflight/output/ap2");
	var fd1 = getprop("/it-autoflight/output/fd1");
	var fd2 = getprop("/it-autoflight/output/fd2");
	if (!ap1 and !ap2 and !fd1 and !fd2) {
		setprop("/it-autoflight/input/trk", 0);
		setprop("/it-autoflight/input/lat", 3);
		setprop("/it-autoflight/input/vert", 1);
		setprop("/it-autoflight/input/vs", 0);
		setprop("/it-autoflight/output/fma-pwr", 0);
	} else {
		setprop("/it-autoflight/input/trk", 0);
		setprop("/it-autoflight/input/vs", 0);
		setprop("/it-autoflight/output/fma-pwr", 1);
	}
}

# Master Lateral
setlistener("/it-autoflight/input/lat", func {
	if ((getprop("/gear/gear[1]/wow") == 0) and (getprop("/gear/gear[2]/wow") == 0)) {
		lateral();
	} else {
		lat_arm();
	}
});

var lateral = func {
	var latset = getprop("/it-autoflight/input/lat");
	if (latset == 0) {
		alandt.stop();
		alandt1.stop();
		lnavwptt.stop();
		setprop("/it-autoflight/output/loc-armed", 0);
		setprop("/it-autoflight/output/appr-armed", 0);
		setprop("/it-autoflight/output/lat", 0);
		setprop("/it-autoflight/mode/lat", "HDG");
		setprop("/it-autoflight/mode/arm", " ");
	} else if (latset == 1) {
		if (getprop("/autopilot/route-manager/route/num") > 0 and getprop("/autopilot/route-manager/active") == 1) {
			alandt.stop();
			alandt1.stop();
			lnavwptt.start();
			setprop("/it-autoflight/output/loc-armed", 0);
			setprop("/it-autoflight/output/appr-armed", 0);
			setprop("/it-autoflight/output/lat", 1);
			setprop("/it-autoflight/mode/lat", "LNAV");
			setprop("/it-autoflight/mode/arm", " ");
		} else {
			gui.popupTip("Please make sure you have a route set, and that it is Activated!");
		}
	} else if (latset == 2) {
		if (getprop("/it-autoflight/output/lat") == 2) {
			# Do nothing because VOR/LOC is active
		} else {
			setprop("/instrumentation/nav[0]/signal-quality-norm", 0);
			setprop("/instrumentation/nav[1]/signal-quality-norm", 0);
			setprop("/it-autoflight/output/loc-armed", 1);
			setprop("/it-autoflight/mode/arm", "LOC");
		}
	} else if (latset == 3) {
		alandt.stop();
		alandt1.stop();
		lnavwptt.stop();
		setprop("/it-autoflight/output/loc-armed", 0);
		setprop("/it-autoflight/output/appr-armed", 0);
		var hdg5sec = int(getprop("/it-autoflight/internal/heading-5-sec-ahead")+0.5);
		setprop("/it-autoflight/input/hdg", hdg5sec);
		setprop("/it-autoflight/output/lat", 0);
		setprop("/it-autoflight/mode/lat", "HDG");
		setprop("/it-autoflight/mode/arm", " ");
	} else if (latset == 4) {
		lnavwptt.stop();
		setprop("/it-autoflight/output/lat", 4);
		setprop("/it-autoflight/mode/lat", "ALGN");
	} else if (latset == 5) {
		lnavwptt.stop();
		setprop("/it-autoflight/output/lat", 5);
	}
}

var lat_arm = func {
	var latset = getprop("/it-autoflight/input/lat");
	if (latset == 0) {
		setprop("/it-autoflight/input/lat-arm", 0);
		setprop("/it-autoflight/mode/arm", "HDG");
	} else if (latset == 1) {
		if (getprop("/autopilot/route-manager/route/num") > 0 and getprop("/autopilot/route-manager/active") == 1) {
			setprop("/it-autoflight/input/lat-arm", 1);
			setprop("/it-autoflight/mode/arm", "LNV");
		} else {
			gui.popupTip("Please make sure you have a route set, and that it is Activated!");
		}
	} else if (latset == 3) {
		var hdgnow = int(getprop("/orientation/heading-magnetic-deg")+0.5);
		setprop("/it-autoflight/input/hdg", hdgnow);
		setprop("/it-autoflight/input/lat-arm", 0);
		setprop("/it-autoflight/mode/arm", "HDG");
	}
}

# Master Vertical
setlistener("/it-autoflight/input/vert", func {
	if ((getprop("/gear/gear[1]/wow") == 0) and (getprop("/gear/gear[2]/wow") == 0)) {
		vertical();
	} else {
		vert_arm();
	}
});

var vertical = func {
	var vertset = getprop("/it-autoflight/input/vert");
	if (vertset == 0) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/output/appr-armed", 0);
		setprop("/it-autoflight/output/vert", 0);
		setprop("/it-autoflight/mode/vert", "ALT HLD");
		if (getprop("/it-autoflight/output/loc-armed")) {
			setprop("/it-autoflight/mode/arm", "LOC");
		} else {
			setprop("/it-autoflight/mode/arm", " ");
		}
		var altnow = int((getprop("/instrumentation/altimeter/indicated-altitude-ft")+50)/100)*100;
		setprop("/it-autoflight/input/alt", altnow);
		setprop("/it-autoflight/internal/alt", altnow);
		thrustmode();
	} else if (vertset == 1) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/output/appr-armed", 0);
		var altinput = getprop("/it-autoflight/input/alt");
		setprop("/it-autoflight/internal/alt", altinput);
		var vsnow = int(getprop("/velocities/vertical-speed-fps")*0.6)*100;
		setprop("/it-autoflight/input/vs", vsnow);
		setprop("/it-autoflight/output/vert", 1);
		setprop("/it-autoflight/mode/vert", "V/S");
		if (getprop("/it-autoflight/output/loc-armed")) {
			setprop("/it-autoflight/mode/arm", "LOC");
		} else {
			setprop("/it-autoflight/mode/arm", " ");
		}
		thrustmode();
	} else if (vertset == 2) {
		if (getprop("/it-autoflight/output/lat") == 2) {
			# Do nothing because VOR/LOC is active
		} else {
			setprop("/instrumentation/nav[0]/signal-quality-norm", 0);
			setprop("/instrumentation/nav[1]/signal-quality-norm", 0);
			setprop("/it-autoflight/output/loc-armed", 1);
		}
		if ((getprop("/it-autoflight/output/vert") == 2) or (getprop("/it-autoflight/output/vert") == 6)) {
			# Do nothing because G/S or LAND or FLARE is active
		} else {
			setprop("/instrumentation/nav[0]/gs-rate-of-climb", 0);
			setprop("/it-autoflight/output/appr-armed", 1);
			setprop("/it-autoflight/mode/arm", "ILS");
		}
	} else if (vertset == 3) {
		alandt.stop();
		alandt1.stop();
		var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
		var alt = getprop("/it-autoflight/internal/alt");
		var dif = calt - alt;
		var vsnow = getprop("/it-autoflight/internal/vert-speed-fpm");
		if (calt < alt) {
			setprop("/it-autoflight/internal/max-vs", vsnow);
		} else if (calt > alt) {
			setprop("/it-autoflight/internal/min-vs", vsnow);
		}
		minmaxtimer.start();
		thrustmode();
		setprop("/it-autoflight/output/vert", 0);
		setprop("/it-autoflight/mode/vert", "ALT CAP");
	} else if (vertset == 4) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/output/appr-armed", 0);
		var altinput = getprop("/it-autoflight/input/alt");
		setprop("/it-autoflight/internal/alt", altinput);
		var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
		var alt = getprop("/it-autoflight/internal/alt");
		var dif = calt - alt;
		if (dif < 250 and dif > -250) {
			alt_on();
		} else {
			flch_on();
		}
		if (getprop("/it-autoflight/output/loc-armed")) {
			setprop("/it-autoflight/mode/arm", "LOC");
		} else {
			setprop("/it-autoflight/mode/arm", " ");
		}
	} else if (vertset == 5) {
		fpa_calc();
		alandt.stop();
		alandt1.stop();
		fpa_calct.start();
		setprop("/it-autoflight/output/appr-armed", 0);
		var altinput = getprop("/it-autoflight/input/alt");
		setprop("/it-autoflight/internal/alt", altinput);
		var fpanow = (int(10*getprop("/it-autoflight/internal/fpa")))*0.1;
		print(fpanow);
		setprop("/it-autoflight/input/fpa", fpanow);
		setprop("/it-autoflight/output/vert", 5);
		setprop("/it-autoflight/mode/vert", "FPA");
		if (getprop("/it-autoflight/output/loc-armed") == 1) {
			setprop("/it-autoflight/mode/arm", "LOC");
		} else {
			setprop("/it-autoflight/mode/arm", " ");
		}
		thrustmode();
	} else if (vertset == 6) {
		setprop("/it-autoflight/output/vert", 6);
		setprop("/it-autoflight/mode/vert", "LAND");
		setprop("/it-autoflight/mode/arm", " ");
		thrustmode();
		alandt.stop();
		alandt1.start();
	} else if (vertset == 7) {
		alandt.stop();
		alandt1.stop();
		setprop("/it-autoflight/output/vert", 7);
		setprop("/it-autoflight/mode/arm", " ");
		var altinput = getprop("/it-autoflight/input/alt");
		setprop("/it-autoflight/internal/alt", altinput);
		thrustmodet.start();
	}
}

var vert_arm = func {
	var vertset = getprop("/it-autoflight/input/vert");
	if (vertset == 8) {
		# Do nothing right now
	} else {
		# Do nothing right now
	}
}

# Helpers
var toggle_trkfpa = func {
	var trkfpa = getprop("/it-autoflight/custom/trk-fpa");
	if (trkfpa == 0) {
		setprop("/it-autoflight/custom/trk-fpa", 1);
		if (getprop("/it-autoflight/output/vert") == 1) {
			setprop("/it-autoflight/input/vert", 5);
		}
		setprop("/it-autoflight/input/trk", 1);
		var hed = getprop("/it-autoflight/internal/heading-error-deg");
		if (hed >= -10 and hed <= 10 and getprop("/it-autoflight/output/lat") == 0) {
			setprop("/it-autoflight/input/lat", 3);
		}
	} else if (trkfpa == 1) {
		setprop("/it-autoflight/custom/trk-fpa", 0);
		if (getprop("/it-autoflight/output/vert") == 5) {
			setprop("/it-autoflight/input/vert", 1);
		}
		setprop("/it-autoflight/input/trk", 0);
		var hed = getprop("/it-autoflight/internal/heading-error-deg");
		if (hed >= -10 and hed <= 10 and getprop("/it-autoflight/output/lat") == 0) {
			setprop("/it-autoflight/input/lat", 3);
		}
	}
}

var lnavwpt = func {
	if (getprop("/autopilot/route-manager/route/num") > 0) {
		if (getprop("/autopilot/route-manager/wp/dist") <= 1.0) {
			var wptnum = getprop("/autopilot/route-manager/current-wp");
			if ((wptnum + 1) < getprop("/autopilot/route-manager/route/num")) {
				setprop("/autopilot/route-manager/current-wp", wptnum + 1);
			}
		}
	}
}

var flch_on = func {
	setprop("/it-autoflight/output/appr-armed", 0);
	setprop("/it-autoflight/output/vert", 4);
	thrustmodet.start();
}
var alt_on = func {
	setprop("/it-autoflight/output/appr-armed", 0);
	setprop("/it-autoflight/output/vert", 0);
	setprop("/it-autoflight/mode/vert", "ALT CAP");
	setprop("/it-autoflight/internal/max-vs", 500);
	setprop("/it-autoflight/internal/min-vs", -500);
	minmaxtimer.start();
}

var fpa_calc = func {
	var VS = getprop("/velocities/vertical-speed-fps");
	var TAS = getprop("/velocities/uBody-fps");
	if (TAS < 10) TAS = 10;
	if (VS < -200) VS =-200;
	if (abs(VS/TAS) <= 1) {
		var FPangle = math.asin(VS/TAS);
		FPangle *=90;
		setprop("/it-autoflight/internal/fpa", FPangle);
	}
}

setlistener("/it-autoflight/input/kts-mach", func {
	var ias = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
	var mach = getprop("/instrumentation/airspeed-indicator/indicated-mach");
	if (getprop("/it-autoflight/input/kts-mach") == 0) {
		if (ias >= 100 and ias <= 360) {
			setprop("/it-autoflight/input/spd-kts", math.round(ias, 1));
		} else if (ias < 100) {
			setprop("/it-autoflight/input/spd-kts", 100);
		} else if (ias > 360) {
			setprop("/it-autoflight/input/spd-kts", 360);
		}
	} else if (getprop("/it-autoflight/input/kts-mach") == 1) {
		if (mach >= 0.50 and mach <= 0.95) {
			setprop("/it-autoflight/input/spd-kts", math.round(mach, 0.001));
		} else if (mach < 0.50) {
			setprop("/it-autoflight/input/spd-kts", 0.50);
		} else if (mach > 0.95) {
			setprop("/it-autoflight/input/spd-kts", 0.95);
		}
	}
});

# Takeoff Modes
# Lat Active
var latarms = func {
	if (getprop("/position/gear-agl-ft") >= 20) {
		if (getprop("/it-autoflight/input/lat-arm") == 1) {
			setprop("/it-autoflight/input/lat", getprop("/it-autoflight/input/lat-arm"));
		}
	}
}

# TOGA
setlistener("/it-autoflight/input/toga", func {
	if (getprop("/it-autoflight/input/toga") == 1) {
		setprop("/it-autoflight/input/vert", 7);
		vertical();
		setprop("/it-autoflight/output/loc-armed", 0);
		setprop("/it-autoflight/output/appr-armed", 0);
		setprop("/it-autoflight/input/toga", 0);
		togasel();
	}
});

var togasel = func {
	if ((getprop("/gear/gear[1]/wow") == 0) and (getprop("/gear/gear[2]/wow") == 0)) {
		var iasnow = int(getprop("/instrumentation/airspeed-indicator/indicated-speed-kt")+0.5);
		setprop("/it-autoflight/input/spd-kts", iasnow);
		setprop("/it-autoflight/input/kts-mach", 0);
		setprop("/it-autoflight/mode/vert", "G/A CLB");
		setprop("/it-autoflight/input/lat", 3);
	} else {
		setprop("/it-autoflight/input/lat", 5);
		lateral();
		setprop("/it-autoflight/mode/lat", "T/O");
		setprop("/it-autoflight/mode/vert", "T/O CLB");
	}
}

setlistener("/it-autoflight/mode/vert", func {
	var vertm = getprop("/it-autoflight/mode/vert");
	if (vertm == "T/O CLB") {
		reduct.start();
	} else {
		reduct.stop();
	}
});

setlistener("/it-autoflight/mode/lat", func {
	var vertm = getprop("/it-autoflight/mode/lat");
	if (vertm == "T/O") {
		latarmt.start();
	} else {
		latarmt.stop();
	}
});

var toga_reduc = func {
	if (getprop("/position/gear-agl-ft") >= getprop("/it-autoflight/settings/reduc-agl-ft")) {
		setprop("/it-autoflight/input/vert", 4);
	}
}

# Altitude Capture and FPA Timer Logic
setlistener("/it-autoflight/output/vert", func {
	var vertm = getprop("/it-autoflight/output/vert");
	if (vertm == 1) {
		altcaptt.start();
		fpa_calct.stop();
	} else if (vertm == 4) {
		altcaptt.start();
		fpa_calct.stop();
	} else if (vertm == 5) {
		altcaptt.start();
	} else if (vertm == 7) {
		altcaptt.start();
		fpa_calct.stop();
	} else if (vertm == 8) {
		altcaptt.stop();
		fpa_calct.stop();
	} else {
		altcaptt.stop();
		fpa_calct.stop();
	}
});

# Altitude Capture
var altcapt = func {
	var vsnow = getprop("/it-autoflight/internal/vert-speed-fpm");
	if ((vsnow >= 0 and vsnow < 500) or (vsnow < 0 and vsnow > -500)) {
		setprop("/it-autoflight/internal/captvs", 100);
		setprop("/it-autoflight/internal/captvsneg", -100);
	} else  if ((vsnow >= 500 and vsnow < 1000) or (vsnow < -500 and vsnow > -1000)) {
		setprop("/it-autoflight/internal/captvs", 200);
		setprop("/it-autoflight/internal/captvsneg", -200);
	} else  if ((vsnow >= 1000 and vsnow < 1500) or (vsnow < -1000 and vsnow > -1500)) {
		setprop("/it-autoflight/internal/captvs", 300);
		setprop("/it-autoflight/internal/captvsneg", -300);
	} else  if ((vsnow >= 1500 and vsnow < 2000) or (vsnow < -1500 and vsnow > -2000)) {
		setprop("/it-autoflight/internal/captvs", 400);
		setprop("/it-autoflight/internal/captvsneg", -400);
	} else  if ((vsnow >= 2000 and vsnow < 3000) or (vsnow < -2000 and vsnow > -3000)) {
		setprop("/it-autoflight/internal/captvs", 600);
		setprop("/it-autoflight/internal/captvsneg", -600);
	} else  if ((vsnow >= 3000 and vsnow < 4000) or (vsnow < -3000 and vsnow > -4000)) {
		setprop("/it-autoflight/internal/captvs", 900);
		setprop("/it-autoflight/internal/captvsneg", -900);
	} else  if ((vsnow >= 4000 and vsnow < 5000) or (vsnow < -4000 and vsnow > -5000)) {
		setprop("/it-autoflight/internal/captvs", 1200);
		setprop("/it-autoflight/internal/captvsneg", -1200);
	} else  if ((vsnow >= 5000) or (vsnow < -5000)) {
		setprop("/it-autoflight/internal/captvs", 1500);
		setprop("/it-autoflight/internal/captvsneg", -1500);
	}
	var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
	var alt = getprop("/it-autoflight/internal/alt");
	var dif = calt - alt;
	if (dif < getprop("/it-autoflight/internal/captvs") and dif > getprop("/it-autoflight/internal/captvsneg")) {
		if (vsnow > 0 and dif < 0) {
			setprop("/it-autoflight/input/vert", 3);
			setprop("/it-autoflight/output/thr-mode", 0);
		} else if (vsnow < 0 and dif > 0) {
			setprop("/it-autoflight/input/vert", 3);
			setprop("/it-autoflight/output/thr-mode", 0);
		}
	}
	var altinput = getprop("/it-autoflight/input/alt");
	setprop("/it-autoflight/internal/alt", altinput);
}

# Min and Max Pitch Reset
var minmax = func {
	var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
	var alt = getprop("/it-autoflight/internal/alt");
	var dif = calt - alt;
	if (dif < 50 and dif > -50) {
		setprop("/it-autoflight/internal/max-vs", 500);
		setprop("/it-autoflight/internal/min-vs", -500);
		var vertmode = getprop("/it-autoflight/output/vert");
		if (vertmode == 1 or vertmode == 2 or vertmode == 4 or vertmode == 5 or vertmode == 6 or vertmode == 7) {
			# Do not change the vertical mode because we are not trying to capture altitude.
		} else {
			setprop("/it-autoflight/mode/vert", "ALT HLD");
		}
		minmaxtimer.stop();
	}
}

# Thrust Mode Selector
var thrustmode = func {
	var calt = getprop("/instrumentation/altimeter/indicated-altitude-ft");
	var alt = getprop("/it-autoflight/internal/alt");
	var vertm = getprop("/it-autoflight/output/vert");
	if (vertm == 4) {
		if (calt < alt) {
			setprop("/it-autoflight/output/thr-mode", 2);
			setprop("/it-autoflight/mode/thr", " PITCH");
			setprop("/it-autoflight/mode/vert", "SPD CLB");
		} else if (calt > alt) {
			setprop("/it-autoflight/output/thr-mode", 1);
			setprop("/it-autoflight/mode/thr", " PITCH");
			setprop("/it-autoflight/mode/vert", "SPD DES");
		} else {
			setprop("/it-autoflight/output/thr-mode", 0);
			setprop("/it-autoflight/mode/thr", "THRUST");
			setprop("/it-autoflight/input/vert", 3);
		}
	} else if (vertm == 7) {
		setprop("/it-autoflight/output/thr-mode", 2);
		setprop("/it-autoflight/mode/thr", " PITCH");
	} else {
		setprop("/it-autoflight/output/thr-mode", 0);
		setprop("/it-autoflight/mode/thr", "THRUST");
		thrustmodet.stop();
	}
}

# ILS and Autoland
# LOC and G/S arming
var update_arms = func {
	update_locarmelec();
	update_apparmelec();
}

var update_locarmelec = func {
	var loca = getprop("/it-autoflight/output/loc-armed");
	if (loca) {
		locarmcheck();
	} else {
		return 0;
	}
}

var update_apparmelec = func {
	var appra = getprop("/it-autoflight/output/appr-armed");
	if (appra) {
		apparmcheck();
	} else {
		return 0;
	}
}

var locarmcheck = func {
	var locdefl = getprop("instrumentation/nav[0]/heading-needle-deflection-norm");
	var locdefl_b = getprop("instrumentation/nav[1]/heading-needle-deflection-norm");
	if ((locdefl < 0.9233) and (getprop("instrumentation/nav[0]/signal-quality-norm") > 0.99) and (getprop("/FMGC/internal/loc-source") == "NAV0")) {
		make_loc_active();
	} else if ((locdefl_b < 0.9233) and (getprop("instrumentation/nav[1]/signal-quality-norm") > 0.99) and (getprop("/FMGC/internal/loc-source") == "NAV1")) {
		make_loc_active();
	} else {
		return 0;
	}
}

var make_loc_active = func {
	setprop("/it-autoflight/output/loc-armed", 0);
	setprop("/it-autoflight/output/lat", 2);
	setprop("/it-autoflight/mode/lat", "LOC");
	if (getprop("/it-autoflight/output/appr-armed") == 1) {
		# Do nothing because G/S is armed
	} else {
		setprop("/it-autoflight/mode/arm", " ");
	}
}

var apparmcheck = func {
	var signal = getprop("/instrumentation/nav[0]/gs-needle-deflection-norm");
	if ((signal <= -0.000000001) and (getprop("/FMGC/internal/loc-source") == "NAV0") and (getprop("/it-autoflight/output/lat") == 2)) {
		make_appr_active();
	} else {
		return 0;
	}
}

var make_appr_active = func {
	setprop("/it-autoflight/output/appr-armed", 0);
	setprop("/it-autoflight/output/vert", 2);
	setprop("/it-autoflight/mode/vert", "G/S");
	setprop("/it-autoflight/mode/arm", " ");
	alandt.start();
	thrustmode();
}

# Autoland Stage 1 Logic (Land)
var aland = func {
	var ap1 = getprop("/it-autoflight/output/ap1");
	var ap2 = getprop("/it-autoflight/output/ap2");
	if (getprop("/position/gear-agl-ft") <= 100) {
		setprop("/it-autoflight/input/lat", 4);
		setprop("/it-autoflight/input/vert", 6);
	}
}

var aland1 = func {
	var aglal = getprop("/position/gear-agl-ft");
	if (aglal <= 50 and aglal > 5) {
		setprop("/it-autoflight/mode/vert", "FLARE");
	}
	var gear1 = getprop("/gear/gear[1]/wow");
	var gear2 = getprop("/gear/gear[2]/wow");
	if (gear1 == 1 or gear2 == 1) {
		setprop("/it-autoflight/input/ap1", 0);
		setprop("/it-autoflight/input/ap2", 0);
		alandt1.stop();
	}
}

# Autoland Stage 2 Logic (Rollout)
# Not yet working, planned.

# VNAV

# For Canvas Nav Display.
setlistener("/it-autoflight/input/hdg", func {
	setprop("/autopilot/settings/heading-bug-deg", getprop("/it-autoflight/input/hdg"));
});

setlistener("/it-autoflight/internal/alt", func {
	setprop("/autopilot/settings/target-altitude-ft", getprop("/it-autoflight/internal/alt"));
});

# Timers
var update_armst = maketimer(0.5, update_arms);
var altcaptt = maketimer(0.5, altcapt);
var thrustmodet = maketimer(0.5, thrustmode);
var minmaxtimer = maketimer(0.5, minmax);
var alandt = maketimer(0.5, aland);
var alandt1 = maketimer(0.5, aland1);
var reduct = maketimer(0.5, toga_reduc);
var latarmt = maketimer(0.5, latarms);
var fpa_calct = maketimer(0.1, fpa_calc);
var lnavwptt = maketimer(1, lnavwpt);
	