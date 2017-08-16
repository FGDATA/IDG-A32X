# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

var perfCLBInput = func(key) {
	var scratchpad = getprop("/MCDU[1]/scratchpad");
	if (key == "L5") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/cost-index", 0);
			setprop("/FMGC/internal/cost-index-set", 0);
			setprop("/MCDU[1]/scratchpad-msg", "0");
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var ci = int(scratchpad);
			var cis = size(scratchpad);
			if (cis >= 1 and cis <= 3) {
				if (ci == nil) {
					if (getprop("/MCDU[1]/scratchpad") != "NOT ALLOWED") {
						setprop("/MCDU[1]/last-scratchpad", getprop("/MCDU[1]/scratchpad"));
					}
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				} else if (ci >= 0 and ci <= 999) {
					setprop("/FMGC/internal/cost-index", ci);
					setprop("/FMGC/internal/cost-index-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					if (getprop("/MCDU[1]/scratchpad") != "NOT ALLOWED") {
						setprop("/MCDU[1]/last-scratchpad", getprop("/MCDU[1]/scratchpad"));
					}
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				if (getprop("/MCDU[1]/scratchpad") != "NOT ALLOWED") {
					setprop("/MCDU[1]/last-scratchpad", getprop("/MCDU[1]/scratchpad"));
				}
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L6") {
		setprop("/MCDU[1]/page", "TO");
	} else if (key == "R6") {
		setprop("/MCDU[1]/page", "CRZ");
	}
}
