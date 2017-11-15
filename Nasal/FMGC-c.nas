# A3XX FMGC/Autoflight
# Joshua Davidson (it0uchpods) and Jonathan Redpath (legoboyvdlp)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

setprop("/FMGC/internal/cruise-ft", 10000);
setprop("/it-autoflight/internal/alt", 10000);
setprop("/modes/pfd/fma/throttle-mode", " ");
setprop("/modes/pfd/fma/pitch-mode", " ");
setprop("/modes/pfd/fma/pitch-mode-armed", " ");
setprop("/modes/pfd/fma/pitch-mode2-armed", " ");
setprop("/modes/pfd/fma/roll-mode", " ");
setprop("/modes/pfd/fma/roll-mode-armed", " ");
setprop("/modes/pfd/fma/ap-mode", " ");
setprop("/modes/pfd/fma/fd-mode", " ");
setprop("/modes/pfd/fma/at-mode", " ");
setprop("/modes/pfd/fma/athr-armed", 0);
setprop("/modes/pfd/fma/throttle-mode-box", 0);
setprop("/modes/pfd/fma/pitch-mode-box", 0);
setprop("/modes/pfd/fma/pitch-mode-armed-box", 0);
setprop("/modes/pfd/fma/pitch-mode2-armed-box", 0);
setprop("/modes/pfd/fma/roll-mode-box", 0);
setprop("/modes/pfd/fma/roll-mode-armed-box", 0);
setprop("/modes/pfd/fma/ap-mode-box", 0);
setprop("/modes/pfd/fma/fd-mode-box", 0);
setprop("/modes/pfd/fma/athr-mode-box", 0);
setprop("/modes/pfd/fma/throttle-mode-time", 0);
setprop("/modes/pfd/fma/pitch-mode-time", 0);
setprop("/modes/pfd/fma/pitch-mode-armed-time", 0);
setprop("/modes/pfd/fma/pitch-mode2-armed-time", 0);
setprop("/modes/pfd/fma/roll-mode-time", 0);
setprop("/modes/pfd/fma/roll-mode-armed-time", 0);
setprop("/modes/pfd/fma/ap-mode-time", 0);
setprop("/modes/pfd/fma/fd-mode-time", 0);
setprop("/modes/pfd/fma/athr-mode-time", 0);

setlistener("sim/signals/fdm-initialized", func {
	loopFMA.start();
});

# Master Thrust
var loopFMA = maketimer(0.05, func {
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	var newthr = getprop("/modes/pfd/fma/throttle-mode");
	if (state1 == "TOGA" or state2 == "TOGA") {
		if (newthr != " ") {
			setprop("/modes/pfd/fma/throttle-mode", " ");
		}
	} else if (state1 == "MCT" or state2 == "MCT") {
		if (newthr != "  ") {
			setprop("/modes/pfd/fma/throttle-mode", "  ");
		}
	} else if (state1 == "MAN THR" or state2 == "MAN THR") {
		if (newthr != "   ") {
			setprop("/modes/pfd/fma/throttle-mode", "   ");
		}
	} else {
		if ((getprop("/it-autoflight/output/vert") == 4) or (getprop("/it-autoflight/output/vert") == 6) or (getprop("/it-autoflight/output/vert") == 7) or (getprop("/it-autoflight/output/vert") == 8)) {
			if (getprop("/it-autoflight/output/fd1") == 0 and getprop("/it-autoflight/output/fd2") == 0 and getprop("/it-autoflight/output/ap1") == 0 and getprop("/it-autoflight/output/ap2") == 0) {
				loopFMA_b();
			} else {
				var thr = getprop("/it-autoflight/output/thr-mode");
				if (thr == 0) {
					loopFMA_b();
				} else if (thr == 1) {
					if (newthr != "THR IDLE") {
						setprop("/modes/pfd/fma/throttle-mode", "THR IDLE");
					}
				} else if (thr == 2) {
					if (state1 == "CL" or state2 == "CL") {
						if (newthr != "THR CLB") {
							setprop("/modes/pfd/fma/throttle-mode", "THR CLB");
						}
					} else {
						if (newthr != "THR LVR") {
							setprop("/modes/pfd/fma/throttle-mode", "THR LVR");
						}
					}
				}
			}
		} else {
			loopFMA_b();
		}
	}
	
	# A/THR Armed/Active
	if (getprop("/it-autoflight/output/athr") == 1 and (state1 == "MAN THR" or state2 == "MAN THR" or state1 == "MCT" or state2 == "MCT" or state1 == "TOGA" or state2 == "TOGA")) {
		if (getprop("/modes/pfd/fma/athr-armed") != 1) {
			setprop("/modes/pfd/fma/athr-armed", 1);
		}
	} else {
		if (getprop("/modes/pfd/fma/athr-armed") != 0) {
			setprop("/modes/pfd/fma/athr-armed", 0);
		}
	}
	
	# SRS RWY Engagement
	var flx = getprop("/systems/thrust/lim-flex");
	var lat = getprop("/it-autoflight/mode/lat");
	var newlat = getprop("/modes/pfd/fma/roll-mode");
	var vert = getprop("/it-autoflight/mode/vert");
	var newvert = getprop("/modes/pfd/fma/pitch-mode");
	var newvertarm = getprop("/modes/pfd/fma/pitch-mode2-armed");
	var thr1 = getprop("/controls/engines/engine[0]/throttle-pos");
	var thr2 = getprop("/controls/engines/engine[1]/throttle-pos");
	var wow = getprop("/gear/gear[0]/wow");
	var engstate1 = getprop("/engines/engine[0]/state");
	var engstate2 = getprop("/engines/engine[1]/state");
	if (((state1 == "TOGA" or state2 == "TOGA") or (flx == 1 and (state1 == "MCT" or state2 == "MCT")) or (flx == 1 and ((state1 == "MAN THR" and thr1 >= 0.83) or (state2 == "MAN THR" and thr2 >= 0.83)))) and (engstate1 == 3 or engstate2 == 3)) {
		# RWY Engagement would go here, but automatic ILS selection is not simulated yet.
		if (wow and getprop("/FMGC/internal/v2-set") == 1 and getprop("/it-autoflight/output/vert") != 7) {
			setprop("/it-autoflight/input/vert", 7);
			setprop("/it-autoflight/mode/vert", "T/O CLB");
			fmgc.vertical();
		}
	} else {
		var gear1 = getprop("/gear/gear[1]/wow");
		var gear2 = getprop("/gear/gear[2]/wow");
		if (getprop("/it-autoflight/input/lat") == 5 and (gear1 or gear2)) {
			setprop("/it-autoflight/input/lat", 9);
			fmgc.lateral();
		}
		if (getprop("/it-autoflight/output/vert") == 7 and (gear1 or gear2)) {
			setprop("/it-autoflight/input/vert", 9);
			fmgc.vertical();
		}
	}
	
	var trk = getprop("/it-autoflight/custom/trk-fpa");
	if (lat == "HDG" and trk == 0) {
		if (newlat != "HDG") {
			setprop("/modes/pfd/fma/roll-mode", "HDG");
		}
	} else if (lat == "HDG" and trk == 1) {
		if (newlat != "TRACK") {
			setprop("/modes/pfd/fma/roll-mode", "TRACK");
		}
	}
	
	# Boxes
	var boxtime = getprop("/sim/time/elapsed-sec");
	if (getprop("/modes/pfd/fma/ap-mode-time") + 10 >= boxtime) {
		setprop("/modes/pfd/fma/ap-mode-box", 1);
	} else {
		setprop("/modes/pfd/fma/ap-mode-box", 0);
	}
	if (getprop("/modes/pfd/fma/fd-mode-time") + 10 >= boxtime) {
		setprop("/modes/pfd/fma/fd-mode-box", 1);
	} else {
		setprop("/modes/pfd/fma/fd-mode-box", 0);
	}
	if (getprop("/modes/pfd/fma/athr-mode-time") + 10 >= boxtime) {
		setprop("/modes/pfd/fma/athr-mode-box", 1);
	} else {
		setprop("/modes/pfd/fma/athr-mode-box", 0);
	}
	if (getprop("/modes/pfd/fma/throttle-mode-time") + 10 >= boxtime) {
		setprop("/modes/pfd/fma/throttle-mode-box", 1);
	} else {
		setprop("/modes/pfd/fma/throttle-mode-box", 0);
	}
	if (getprop("/modes/pfd/fma/roll-mode-time") + 10 >= boxtime) {
		setprop("/modes/pfd/fma/roll-mode-box", 1);
	} else {
		setprop("/modes/pfd/fma/roll-mode-box", 0);
	}
	if (getprop("/modes/pfd/fma/pitch-mode-time") + 10 >= boxtime) {
		setprop("/modes/pfd/fma/pitch-mode-box", 1);
	} else {
		setprop("/modes/pfd/fma/pitch-mode-box", 0);
	}
	if (getprop("/modes/pfd/fma/roll-mode-armed-time") + 10 >= boxtime) {
		setprop("/modes/pfd/fma/roll-mode-armed-box", 1);
	} else {
		setprop("/modes/pfd/fma/roll-mode-armed-box", 0);
	}
	if (getprop("/modes/pfd/fma/pitch-mode-armed-time") + 10 >= boxtime) {
		setprop("/modes/pfd/fma/pitch-mode-armed-box", 1);
	} else {
		setprop("/modes/pfd/fma/pitch-mode-armed-box", 0);
	}
	if (getprop("/modes/pfd/fma/pitch-mode2-armed-time") + 10 >= boxtime) {
		setprop("/modes/pfd/fma/pitch-mode2-armed-box", 1);
	} else {
		setprop("/modes/pfd/fma/pitch-mode2-armed-box", 0);
	}
});

var loopFMA_b = func {
	var newthr = getprop("/modes/pfd/fma/throttle-mode");
	if (getprop("/it-autoflight/input/kts-mach") == 0) {
		if (newthr != "SPEED") {
			setprop("/modes/pfd/fma/throttle-mode", "SPEED");
		}
	} else if (getprop("/it-autoflight/input/kts-mach") == 1) {
		if (newthr != "MACH") {
			setprop("/modes/pfd/fma/throttle-mode", "MACH");
		}
	}
}

# Master Lateral
setlistener("/it-autoflight/mode/lat", func {
	var lat = getprop("/it-autoflight/mode/lat");
	var newlat = getprop("/modes/pfd/fma/roll-mode");
	if (lat == "LNAV") {
		if (newlat != "NAV") {
			setprop("/modes/pfd/fma/roll-mode", "NAV");
		}
	} else if (lat == "LOC") {
		if (newlat != "LOC*" and newlat != "LOC") {
			setprop("/modes/pfd/fma/roll-mode", "LOC*");
			locupdate.start();
		}
	} else if (lat == "ALGN") {
		if (newlat != " ") {
			setprop("/modes/pfd/fma/roll-mode", " ");
		}
	} else if (lat == "RLOU") {
		if (newlat != " ") {
			setprop("/modes/pfd/fma/roll-mode", " ");
		}
	} else if (lat == "T/O") {
		if (newlat != "RWY") {
			setprop("/modes/pfd/fma/roll-mode", "RWY");
		}
	} else if (lat == " ") {
		if (newlat != " ") {
			setprop("/modes/pfd/fma/roll-mode", " ");
		}
	}
});

var locupdate = maketimer(0.5, func {
	var lat = getprop("/it-autoflight/mode/lat");
	var newlat = getprop("/modes/pfd/fma/roll-mode");
	var nav_defl = getprop("/instrumentation/nav[0]/heading-needle-deflection-norm");
	if (lat == "LOC") {
		if (nav_defl > -0.15 and nav_defl < 0.15) {
			locupdate.stop();
			if (newlat != "LOC") {
				setprop("/modes/pfd/fma/roll-mode", "LOC");
			}
		}
	}
});

# Master Vertical
setlistener("/it-autoflight/mode/vert", func {
	var vert = getprop("/it-autoflight/mode/vert");
	var newvert = getprop("/modes/pfd/fma/pitch-mode");
	var newvertarm = getprop("/modes/pfd/fma/pitch-mode2-armed");
	if (vert == "ALT HLD") {
		altvert();
		if (newvertarm != " ") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", " ");
		}
	} else if (vert == "ALT CAP") {
		altvert();
		if (newvertarm != " ") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", " ");
		}
	} else if (vert == "V/S") {
		if (newvert != "V/S") {
			setprop("/modes/pfd/fma/pitch-mode", "V/S");
		}
		if (newvertarm != "ALT") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", "ALT");
		}
	} else if (vert == "G/S") {
		if (newvert != "G/S*" and newvert != "G/S") {
			setprop("/modes/pfd/fma/pitch-mode", "G/S*");
			gsupdate.start();
		}
		if (newvertarm != " ") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", " ");
		}
	} else if (vert == "SPD CLB") {
		if (newvert != "OP CLB") {
			setprop("/modes/pfd/fma/pitch-mode", "OP CLB");
		}
		if (newvertarm != "ALT") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", "ALT");
		}
	} else if (vert == "SPD DES") {
		if (newvert != "OP DES") {
			setprop("/modes/pfd/fma/pitch-mode", "OP DES");
		}
		if (newvertarm != "ALT") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", "ALT");
		}
	} else if (vert == "FPA") {
		if (newvert != "FPA") {
			setprop("/modes/pfd/fma/pitch-mode", "FPA");
		}
		if (newvertarm != "ALT") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", "ALT");
		}
	} else if (vert == "LAND") {
		if (newvert != "LAND") {
			setprop("/modes/pfd/fma/pitch-mode", "LAND");
		}
	} else if (vert == "FLARE") {
		if (newvert != "FLARE") {
			setprop("/modes/pfd/fma/pitch-mode", "FLARE");
		}
	} else if (vert == "ROLLOUT") {
		if (newvert != "ROLL OUT") {
			setprop("/modes/pfd/fma/pitch-mode", "ROLL OUT");
		}
	} else if (vert == "T/O CLB") {
		if (newvert != "SRS") {
			setprop("/modes/pfd/fma/pitch-mode", "SRS");
		}
		updatePitchArm2();
	} else if (vert == "G/A CLB") {
		if (newvert != "SRS") {
			setprop("/modes/pfd/fma/pitch-mode", "SRS");
		}
		if (newvertarm != "ALT") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", "ALT");
		}
	} else if (vert == "MNG HLD") {
		if (newvert != "ALT") {
			setprop("/modes/pfd/fma/pitch-mode", "ALT");
		}
		if (newvertarm != " ") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", " ");
		}
	} else if (vert == "MNG CAP") {
		if (newvert != "ALT*") {
			setprop("/modes/pfd/fma/pitch-mode", "ALT*");
		}
		if (newvertarm != " ") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", " ");
		}
	} else if (vert == "MNG CLB") {
		if (newvert != "CLB") {
			setprop("/modes/pfd/fma/pitch-mode", "CLB");
		}
		if (newvertarm != "ALT") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", "ALT");
		}
	} else if (vert == "MNG DES") {
		if (newvert != "DES") {
			setprop("/modes/pfd/fma/pitch-mode", "DES");
		}
		if (newvertarm != "ALT") {
			setprop("/modes/pfd/fma/pitch-mode2-armed", "ALT");
		}
	} else if (vert == " ") {
		if (newvert != " ") {
			setprop("/modes/pfd/fma/pitch-mode", " ");
		}
		updatePitchArm2();
	}
	altvert();
});

setlistener("/FMGC/internal/v2-set", func {
	updatePitchArm2();
});

var updatePitchArm2 = func {
	var newvertarm = getprop("/modes/pfd/fma/pitch-mode2-armed");
	if (newvertarm != "CLB" and getprop("/FMGC/internal/v2-set") == 1) {
		setprop("/modes/pfd/fma/pitch-mode2-armed", "CLB");
	} else if (newvertarm != " " and getprop("/FMGC/internal/v2-set") != 1) {
		setprop("/modes/pfd/fma/pitch-mode2-armed", " ");
	}
}

var gsupdate = maketimer(0.5, func {
	var vert = getprop("/it-autoflight/mode/vert");
	var newvert = getprop("/modes/pfd/fma/pitch-mode");
	var gs_defl = getprop("/instrumentation/nav[0]/gs-needle-deflection-norm");
	if (vert == "G/S") {
		if (gs_defl > -0.06 and gs_defl < 0.06) {
			gsupdate.stop();
			if (newvert != "G/S") {
				setprop("/modes/pfd/fma/pitch-mode", "G/S");
			}
		}
	}
});

var altvert = func {
	var FMGCalt = getprop("/FMGC/internal/cruise-ft");
	var MCPalt = getprop("/it-autoflight/internal/alt");
	var ALTdif = abs(FMGCalt - MCPalt);
	var vert = getprop("/it-autoflight/mode/vert");
	var newvert = getprop("/modes/pfd/fma/pitch-mode");
	if (ALTdif <= 20) {
		if (vert == "ALT HLD") {
			if (newvert != "ALT CRZ") {
				setprop("/modes/pfd/fma/pitch-mode", "ALT CRZ");
			}
		} else if (vert == "ALT CAP") {
			if (newvert != "ALT CRZ*") {
				setprop("/modes/pfd/fma/pitch-mode", "ALT CRZ*");
			}
		}
	} else {
		if (vert == "ALT HLD") {
			if (newvert != "ALT") {
				setprop("/modes/pfd/fma/pitch-mode", "ALT");
			}
		} else if (vert == "ALT CAP") {
			if (newvert != "ALT*") {
				setprop("/modes/pfd/fma/pitch-mode", "ALT*");
			}
		}
	}
}

setlistener("/FMGC/internal/cruise-ft", altvert);

# Arm HDG or NAV
setlistener("/it-autoflight/mode/arm", func {
	var arm = getprop("/it-autoflight/mode/arm");
	var newarm = getprop("/modes/pfd/fma/roll-mode-armed");
	if (arm == "HDG") {
		if (newarm != "HDG") {
			setprop("/modes/pfd/fma/roll-mode-armed", " ");
		}
	} else if (arm == "LNV") {
		if (newarm != "NAV") {
			setprop("/modes/pfd/fma/roll-mode-armed", "NAV");
		}
	} else if (arm == " ") {
		if (newarm != " ") {
			setprop("/modes/pfd/fma/roll-mode-armed", " ");
		}
	}
});

# Arm LOC
setlistener("/it-autoflight/output/loc-armed", func {
	var loca = getprop("/it-autoflight/output/loc-armed");
	var newarm = getprop("/modes/pfd/fma/roll-mode-armed");
	if (loca) {
		if (newarm != "LOC") {
			setprop("/modes/pfd/fma/roll-mode-armed", "LOC");
		}
	} else {
		if (newarm != " ") {
			setprop("/modes/pfd/fma/roll-mode-armed", " ");
		}
	}
});

# Arm G/S
setlistener("/it-autoflight/output/appr-armed", func {
	var appa = getprop("/it-autoflight/output/appr-armed");
	var newvert2arm = getprop("/modes/pfd/fma/pitch-mode-armed");
	if (appa) {
		if (newvert2arm != "G/S") {
			setprop("/modes/pfd/fma/pitch-mode-armed", "G/S");
		}
	} else {
		if (newvert2arm != " ") {
			setprop("/modes/pfd/fma/pitch-mode-armed", " ");
		}
	}
});

# AP
var ap = func {
	var ap1 = getprop("/it-autoflight/output/ap1");
	var ap2 = getprop("/it-autoflight/output/ap2");
	var newap = getprop("/modes/pfd/fma/ap-mode");
	if (ap1 and ap2 and newap != "AP1+2") {
		setprop("/modes/pfd/fma/ap-mode", "AP 1+2");
	} else if (ap1 and !ap2 and newap != "AP 1") {
		setprop("/modes/pfd/fma/ap-mode", "AP 1");
	} else if (ap2 and !ap1 and newap != "AP 2") {
		setprop("/modes/pfd/fma/ap-mode", "AP 2");
	} else if (!ap1 and !ap2) {
		setprop("/modes/pfd/fma/ap-mode", " ");
	}
}

# FD
var fd = func {
	var fd1 = getprop("/it-autoflight/output/fd1");
	var fd2 = getprop("/it-autoflight/output/fd2");
	var newfd = getprop("/modes/pfd/fma/fd-mode");
	if (fd1 and fd2 and newfd != "1FD2") {
		setprop("/modes/pfd/fma/fd-mode", "1 FD 2");
	} else if (fd1 and !fd2 and newfd != "1 FD -") {
		setprop("/modes/pfd/fma/fd-mode", "1 FD -");
	} else if (fd2 and !fd1 and newfd != "- FD 2") {
		setprop("/modes/pfd/fma/fd-mode", "- FD 2");
	} else if (!fd1 and !fd2) {
		setprop("/modes/pfd/fma/fd-mode", " ");
	}
}

# AT
var at = func {
	var at = getprop("/it-autoflight/output/athr");
	var newat = getprop("/modes/pfd/fma/at-mode");
	if (at and newat != "A/THR") {
		setprop("/modes/pfd/fma/at-mode", "A/THR");
	} else if (!at) {
		setprop("/modes/pfd/fma/at-mode", " ");
	}
}

var boxchk = func {
	var ap1 = getprop("/it-autoflight/output/ap1");
	var ap2 = getprop("/it-autoflight/output/ap2");
	var fd1 = getprop("/it-autoflight/output/fd1");
	var fd2 = getprop("/it-autoflight/output/fd2");
	var fma_pwr = getprop("/it-autoflight/output/fma-pwr");
	if (ap1 and !ap2 and !fd1 and !fd2 and !fma_pwr) {
		setprop("/it-autoflight/input/lat", 3);
		boxchk_b();
	} else if (!ap1 and ap2 and !fd1 and !fd2 and !fma_pwr) {
		setprop("/it-autoflight/input/lat", 3);
		boxchk_b();
	} else if (!ap1 and !ap2 and fd1 and !fd2 and !fma_pwr) {
		setprop("/it-autoflight/input/lat", 3);
		boxchk_b();
	} else if (!ap1 and !ap2 and !fd1 and fd2 and !fma_pwr) {
		setprop("/it-autoflight/input/lat", 3);
		boxchk_b();
	}
}

var boxchk_b = func {
	var newlat = getprop("/modes/pfd/fma/roll-mode");
	if (newlat != " ") {
		setprop("/modes/pfd/fma/roll-mode-time", getprop("/sim/time/elapsed-sec"));
	}
	var newvert = getprop("/modes/pfd/fma/pitch-mode");
	if (newvert != " ") {
		setprop("/modes/pfd/fma/pitch-mode-time", getprop("/sim/time/elapsed-sec"));
	}
	var newarmr = getprop("/modes/pfd/fma/roll-mode-armed");
	if (newarmr != " ") {
		setprop("/modes/pfd/fma/roll-mode-armed-time", getprop("/sim/time/elapsed-sec"));
	}
	var newarmp = getprop("/modes/pfd/fma/pitch-mode-armed");
	if (newarmp != " ") {
		setprop("/modes/pfd/fma/pitch-mode-armed-time", getprop("/sim/time/elapsed-sec"));
	}
	var newarmp2 = getprop("/modes/pfd/fma/pitch-mode2-armed");
	if (newarmp2 != " ") {
		setprop("/modes/pfd/fma/pitch-mode2-armed-time", getprop("/sim/time/elapsed-sec"));
	}
}

# Update AP FD ATHR
setlistener("/it-autoflight/output/ap1", func {
	ap();
	boxchk();
});
setlistener("/it-autoflight/output/ap2", func {
	ap();
	boxchk();
});
setlistener("/it-autoflight/output/fd1", func {
	fd();
	boxchk();
});
setlistener("/it-autoflight/output/fd2", func {
	fd();
	boxchk();
});
setlistener("/it-autoflight/output/athr", func {
	at();
});

# Boxes
setlistener("/modes/pfd/fma/ap-mode", func {
	if (getprop("/modes/pfd/fma/ap-mode") != " ") {
		setprop("/modes/pfd/fma/ap-mode-time", getprop("/sim/time/elapsed-sec"));
	}
});

setlistener("/modes/pfd/fma/fd-mode", func {
	if (getprop("/modes/pfd/fma/fd-mode") != " ") {
		setprop("/modes/pfd/fma/fd-mode-time", getprop("/sim/time/elapsed-sec"));
	}
});

setlistener("/modes/pfd/fma/at-mode", func {
	if (getprop("/modes/pfd/fma/at-mode") != " ") {
		setprop("/modes/pfd/fma/throttle-mode-time", getprop("/sim/time/elapsed-sec"));
		setprop("/modes/pfd/fma/athr-mode-time", getprop("/sim/time/elapsed-sec"));
	}
});

setlistener("/modes/pfd/fma/athr-armed", func {
	if (getprop("/modes/pfd/fma/at-mode") != " ") {
		setprop("/modes/pfd/fma/athr-mode-time", getprop("/sim/time/elapsed-sec"));
	}
});

setlistener("/modes/pfd/fma/throttle-mode", func {
	var state1 = getprop("/systems/thrust/state1");
	var state2 = getprop("/systems/thrust/state2");
	if (getprop("/it-autoflight/output/athr") == 1 and state1 != "MCT" and state2 != "MCT" and state1 != "MAN THR" and state2 != "MAN THR" and state1 != "TOGA" and state2 != "TOGA" and state1 != "IDLE" and state2 != "IDLE") {
		setprop("/modes/pfd/fma/throttle-mode-time", getprop("/sim/time/elapsed-sec"));
	}
});

setlistener("/modes/pfd/fma/roll-mode", func {
	var newlat = getprop("/modes/pfd/fma/roll-mode");
	if (newlat != " ") {
		setprop("/modes/pfd/fma/roll-mode-time", getprop("/sim/time/elapsed-sec"));
	}
});

setlistener("/modes/pfd/fma/pitch-mode", func {
	var newvert = getprop("/modes/pfd/fma/pitch-mode");
	if (newvert != " ") {
		setprop("/modes/pfd/fma/pitch-mode-time", getprop("/sim/time/elapsed-sec"));
	}
});

setlistener("/modes/pfd/fma/roll-mode-armed", func {
	var newarm = getprop("/modes/pfd/fma/roll-mode-armed");
	if (newarm != " ") {
		setprop("/modes/pfd/fma/roll-mode-armed-time", getprop("/sim/time/elapsed-sec"));
	}
});

setlistener("/modes/pfd/fma/pitch-mode-armed", func {
	var newarm = getprop("/modes/pfd/fma/pitch-mode-armed");
	if (newarm != " ") {
		setprop("/modes/pfd/fma/pitch-mode-armed-time", getprop("/sim/time/elapsed-sec"));
	}
});

setlistener("/modes/pfd/fma/pitch-mode2-armed", func {
	var newarm = getprop("/modes/pfd/fma/pitch-mode2-armed");
	if (newarm != " ") {
		setprop("/modes/pfd/fma/pitch-mode2-armed-time", getprop("/sim/time/elapsed-sec"));
	}
});
