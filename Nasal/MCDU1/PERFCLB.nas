##############################################################
# Copyright (c) A3XX Development Team - All Rights Reserved. #
##############################################################

##################################################################
# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath #
##################################################################

var perfCLBInput = func(key) {
	var scratchpad = getprop("/MCDU[0]/scratchpad");
	if (key == "L5") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/cost-index", 0);
			setprop("/FMGC/internal/cost-index-set", 0);
			setprop("/MCDU[0]/scratchpad-msg", "0");
			setprop("/MCDU[0]/scratchpad", "");
		} else {
			var ci = int(scratchpad);
			var cis = size(scratchpad);
			if (cis >= 1 and cis <= 3) {
				if (ci == nil) {
					if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
						setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
					}
					setprop("/MCDU[0]/scratchpad-msg", "1");
					setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
				} else if (ci >= 0 and ci <= 120) {
					setprop("/FMGC/internal/cost-index", ci);
					setprop("/FMGC/internal/cost-index-set", 1);
					setprop("/MCDU[0]/scratchpad", "");
				} else {
					if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
						setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
					}
					setprop("/MCDU[0]/scratchpad-msg", "1");
					setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
				}
			} else {
				if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
					setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
				}
				setprop("/MCDU[0]/scratchpad-msg", "1");
				setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L6") {
		setprop("/MCDU[0]/page", "TO");
	} else if (key == "R6") {
		setprop("/MCDU[0]/page", "CRZ");
	}
}
