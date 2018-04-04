# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

var initInputB = func(key) {
	var scratchpad = getprop("/MCDU[1]/scratchpad");
	if (key == "R1") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/zfw", 0);
			setprop("/FMGC/internal/zfwcg", 55.1); # 25KG default
			setprop("/FMGC/internal/zfw-set", 0);
			setprop("/FMGC/internal/zfwcg-set", 0);
			setprop("/MCDU[1]/scratchpad-msg", "0");
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 0) {
				var zfw = getprop("/fdm/jsbsim/inertia/weight-lbs") - getprop("/consumables/fuel/total-fuel-lbs");
				setprop("/MCDU[1]/scratchpad", "/" ~ sprintf("%3.1f", math.round(zfw / 1000, 0.1)));
			} else if (tfs >= 2 and tfs <= 11 and find("/", scratchpad) != -1) {
				var zfwi = split("/", scratchpad);
				var zfwcg = size(zfwi[0]);
				var zfw = size(zfwi[1]);
				if (zfwcg >= 1 and zfwcg <= 5 and zfwi[0] > 0 and zfwi[0] <= 99.9) {
					setprop("/FMGC/internal/zfwcg", zfwi[0]);
					setprop("/FMGC/internal/zfwcg-set", 1);
				}
				if (zfw >= 1 and zfw <= 5 and zfwi[1] > 0 and zfwi[1] <= 999.9) {
					setprop("/FMGC/internal/zfw", zfwi[1]);
					setprop("/FMGC/internal/zfw-set", 1);
				}
				if ((zfwcg >= 1 and zfwcg <= 5 and zfwi[0] > 0 and zfwi[0] <= 99.9) or (zfw >= 1 and zfw <= 5 and zfwi[1] > 0 and zfwi[1] <= 999.9)) {
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					if (getprop("/MCDU[1]/scratchpad") != "NOT ALLOWED") {
						setprop("/MCDU[1]/last-scratchpad", getprop("/MCDU[1]/scratchpad"));
					}
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else if (tfs >= 1 and tfs <= 5) {
				var zfwcg = size(scratchpad);
				if (zfwcg >= 1 and zfwcg <= 5 and scratchpad > 0 and scratchpad <= 99.9) {
					setprop("/FMGC/internal/zfwcg", scratchpad);
					setprop("/FMGC/internal/zfwcg-set", 1);
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
	} else if (key == "R2") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/block", 0.0);
			setprop("/FMGC/internal/block-set", 0);
			setprop("/MCDU[1]/scratchpad-msg", "0");
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			var maxblock = getprop("/options/maxblock");
			if (tfs == 0) {
				setprop("/MCDU[1]/scratchpad", sprintf("%3.1f", math.round(getprop("/consumables/fuel/total-fuel-lbs") / 1000, 0.1)));
			} else if (tfs >= 1 and tfs <= 5) {
				if (scratchpad >= 1.0 and scratchpad <= maxblock) {
					setprop("/FMGC/internal/block", scratchpad);
					setprop("/FMGC/internal/block-set", 1);
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
	}
}
