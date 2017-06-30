##################################################################
# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath #
##################################################################

var radnavInput = func(key) {
	var scratchpad = getprop("/MCDU[0]/scratchpad");
	if (key == "L1") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor1freq-set", 0);
			setprop("/MCDU[0]/scratchpad-msg", "0");
			setprop("/MCDU[0]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 3 or tfs == 5 or tfs == 6) {
				if (scratchpad >= 108.10 and scratchpad <= 111.95) {
					if (scratchpad == 108.10 or scratchpad == 108.15 or scratchpad == 108.30 or scratchpad == 108.35 or scratchpad == 108.50 or scratchpad == 108.55 or scratchpad == 108.70 or scratchpad == 108.75 or scratchpad == 108.90 or scratchpad == 108.95 
					or scratchpad == 109.10 or scratchpad == 109.15 or scratchpad == 109.30 or scratchpad == 109.35 or scratchpad == 109.50 or scratchpad == 109.55 or scratchpad == 109.70 or scratchpad == 109.75 or scratchpad == 109.90 or scratchpad == 109.95 
					or scratchpad == 110.10 or scratchpad == 110.15 or scratchpad == 110.30 or scratchpad == 110.35 or scratchpad == 110.50 or scratchpad == 110.55 or scratchpad == 110.70 or scratchpad == 110.75 or scratchpad == 110.90 or scratchpad == 110.95 
					or scratchpad == 111.10 or scratchpad == 111.15 or scratchpad == 111.30 or scratchpad == 111.35 or scratchpad == 111.50 or scratchpad == 111.55 or scratchpad == 111.70 or scratchpad == 111.75 or scratchpad == 111.90 or scratchpad == 111.95) {
						if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
							setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
						}
						setprop("/MCDU[0]/scratchpad-msg", "1");
						setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
					} else {
						setprop("/instrumentation/nav[0]/frequencies/selected-mhz", scratchpad);
						setprop("/FMGC/internal/vor1freq-set", 1);
						setprop("/MCDU[0]/scratchpad", "");
					}
				} else if (scratchpad >= 112.00 and scratchpad <= 117.95) {
					setprop("/instrumentation/nav[0]/frequencies/selected-mhz", scratchpad);
					setprop("/FMGC/internal/vor1freq-set", 1);
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
	} else if (key == "L2") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor1crs-set", 0);
			setprop("/MCDU[0]/scratchpad-msg", "0");
			setprop("/MCDU[0]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs >= 1 and tfs <= 3) {
				if (scratchpad >= 0 and scratchpad <= 360) {
					setprop("/instrumentation/nav[0]/radials/selected-deg", scratchpad);
					setprop("/FMGC/internal/vor1crs-set", 1);
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
	} else if (key == "L3") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor1freq-set", 0);
			setprop("/MCDU[0]/scratchpad-msg", "0");
			setprop("/MCDU[0]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 3 or tfs == 5 or tfs == 6) {
				if (scratchpad >= 108.10 and scratchpad <= 111.95) {
					if (scratchpad == 108.10 or scratchpad == 108.15 or scratchpad == 108.30 or scratchpad == 108.35 or scratchpad == 108.50 or scratchpad == 108.55 or scratchpad == 108.70 or scratchpad == 108.75 or scratchpad == 108.90 or scratchpad == 108.95 
					or scratchpad == 109.10 or scratchpad == 109.15 or scratchpad == 109.30 or scratchpad == 109.35 or scratchpad == 109.50 or scratchpad == 109.55 or scratchpad == 109.70 or scratchpad == 109.75 or scratchpad == 109.90 or scratchpad == 109.95 
					or scratchpad == 110.10 or scratchpad == 110.15 or scratchpad == 110.30 or scratchpad == 110.35 or scratchpad == 110.50 or scratchpad == 110.55 or scratchpad == 110.70 or scratchpad == 110.75 or scratchpad == 110.90 or scratchpad == 110.95 
					or scratchpad == 111.10 or scratchpad == 111.15 or scratchpad == 111.30 or scratchpad == 111.35 or scratchpad == 111.50 or scratchpad == 111.55 or scratchpad == 111.70 or scratchpad == 111.75 or scratchpad == 111.90 or scratchpad == 111.95) {
						setprop("/instrumentation/nav[0]/frequencies/selected-mhz", scratchpad);
						setprop("/FMGC/internal/vor1freq-set", 1);
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
			} else {
				if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
					setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
				}
				setprop("/MCDU[0]/scratchpad-msg", "1");
				setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L4") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor1crs-set", 0);
			setprop("/MCDU[0]/scratchpad-msg", "0");
			setprop("/MCDU[0]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs >= 1 and tfs <= 3) {
				if (scratchpad >= 0 and scratchpad <= 360) {
					setprop("/instrumentation/nav[0]/radials/selected-deg", scratchpad);
					setprop("/FMGC/internal/vor1crs-set", 1);
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
	} else if (key == "R1") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor2freq-set", 0);
			setprop("/MCDU[0]/scratchpad-msg", "0");
			setprop("/MCDU[0]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 3 or tfs == 5 or tfs == 6) {
				if (scratchpad >= 108.10 and scratchpad <= 111.95) {
					if (scratchpad == 108.10 or scratchpad == 108.15 or scratchpad == 108.30 or scratchpad == 108.35 or scratchpad == 108.50 or scratchpad == 108.55 or scratchpad == 108.70 or scratchpad == 108.75 or scratchpad == 108.90 or scratchpad == 108.95 
					or scratchpad == 109.10 or scratchpad == 109.15 or scratchpad == 109.30 or scratchpad == 109.35 or scratchpad == 109.50 or scratchpad == 109.55 or scratchpad == 109.70 or scratchpad == 109.75 or scratchpad == 109.90 or scratchpad == 109.95 
					or scratchpad == 110.10 or scratchpad == 110.15 or scratchpad == 110.30 or scratchpad == 110.35 or scratchpad == 110.50 or scratchpad == 110.55 or scratchpad == 110.70 or scratchpad == 110.75 or scratchpad == 110.90 or scratchpad == 110.95 
					or scratchpad == 111.10 or scratchpad == 111.15 or scratchpad == 111.30 or scratchpad == 111.35 or scratchpad == 111.50 or scratchpad == 111.55 or scratchpad == 111.70 or scratchpad == 111.75 or scratchpad == 111.90 or scratchpad == 111.95) {
						if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
							setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
						}
						setprop("/MCDU[0]/scratchpad-msg", "1");
						setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
					} else {
						setprop("/instrumentation/nav[1]/frequencies/selected-mhz", scratchpad);
						setprop("/FMGC/internal/vor2freq-set", 1);
						setprop("/MCDU[0]/scratchpad", "");
					}
				} else if (scratchpad >= 112.00 and scratchpad <= 117.95) {
					setprop("/instrumentation/nav[1]/frequencies/selected-mhz", scratchpad);
					setprop("/FMGC/internal/vor2freq-set", 1);
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
	} else if (key == "R2") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor2crs-set", 0);
			setprop("/MCDU[0]/scratchpad-msg", "0");
			setprop("/MCDU[0]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs >= 1 and tfs <= 3) {
				if (scratchpad >= 0 and scratchpad <= 360) {
					setprop("/instrumentation/nav[1]/radials/selected-deg", scratchpad);
					setprop("/FMGC/internal/vor2crs-set", 1);
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
	}
}
