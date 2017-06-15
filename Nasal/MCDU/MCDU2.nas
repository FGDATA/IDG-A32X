##################################################################
# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath #
##################################################################

var MCDU_init = func {
	setprop("/MCDU[1]/brightness", "1.0");
	MCDU_reset(); # Reset MCDU, clears data
}

var MCDU_reset = func {
	setprop("/it-autoflight/settings/togaspd", 157);
	setprop("/MCDU[1]/last-fmgc-page", "STATUS");
	setprop("/MCDU[1]/page", "MCDU");
	setprop("/MCDU[1]/scratchpad", "");
	setprop("/MCDUC/flight-num", "");
	setprop("/MCDUC/thracc-set", 0);
	setprop("/MCDUC/reducacc-set", 0);
	setprop("/MCDUC/flight-num-set", 0);
	setprop("/FMGC/internal/flex", 0);
	setprop("/FMGC/internal/dep-arpt", "");
	setprop("/FMGC/internal/arr-arpt", "");
	setprop("/FMGC/internal/cruise-ft", 10000);
	setprop("/FMGC/internal/cruise-fl", 100);
	setprop("/FMGC/internal/cost-index", "0");
	setprop("/FMGC/internal/trans-alt", 18000);
	setprop("/FMGC/internal/reduc-agl-ft", "3000");
	setprop("/FMGC/internal/eng-out-reduc", "3500");
	setprop("/FMGC/internal/v1", 0);
	setprop("/FMGC/internal/vr", 0);
	setprop("/FMGC/internal/v2", 0);
	setprop("/FMGC/internal/block", 0.0);
	setprop("/FMGC/internal/v1-set", 0);
	setprop("/FMGC/internal/vr-set", 0);
	setprop("/FMGC/internal/v2-set", 0);
	setprop("/FMGC/internal/block-set", 0);
	setprop("/FMGC/internal/to-flap", 0);
	setprop("/FMGC/internal/to-ths", "0.0");
	setprop("/FMGC/internal/tofrom-set", 0);
	setprop("/FMGC/internal/cost-index-set", 0);
	setprop("/FMGC/internal/cruise-lvl-set", 0);
	setprop("/FMGC/internal/flap-ths-set", 0);
	setprop("/FMGC/internal/flex-set", 0);
	setprop("/FMGC/internal/vor1freq-set", 0);
	setprop("/FMGC/internal/vor1crs-set", 0);
	setprop("/FMGC/internal/vor2freq-set", 0);
	setprop("/FMGC/internal/vor2crs-set", 0);
}

var lskbutton = func(btn) {
	if (btn == "1") {
		if (getprop("/MCDU[1]/page") == "MCDU") {
			setprop("/MCDU[1]/page", getprop("/MCDU[1]/last-fmgc-page"));
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "GPS PRIMARY");
		} else if (getprop("/MCDU[1]/page") == "TO") {
			perfTOInput("L1");
		} else if (getprop("/MCDU[1]/page") == "RADNAV") {
			radnavInput("L1");
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "2") {
		if (getprop("/MCDU[1]/page") == "INITA") {
			PerfInput("L2");
		} else if (getprop("/MCDU[1]/page") == "TO") {
			perfTOInput("L2");
		} else if (getprop("/MCDU[1]/page") == "RADNAV") {
			radnavInput("L2");
		} else if (getprop("/MCDU[1]/page") == "CLB") {
			initInputA("L5"); # Does the same thing as on the INIT page
		} else if (getprop("/MCDU[0]/page") == "CRZ") {
			initInputA("L5"); 
		} else if (getprop("/MCDU[0]/page") == "DES") {
			initInputA("L5"); 
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "3") {
		if (getprop("/MCDU[1]/page") == "INITA") {
			initInputA("L3");
		} else if (getprop("/MCDU[1]/page") == "TO") {
			perfTOInput("L3");
		} else if (getprop("/MCDU[1]/page") == "RADNAV") {
			radnavInput("L3");
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "4") {
		if (getprop("/MCDU[1]/page") == "DATA") {
			setprop("/MCDU[1]/page", "STATUS");
		} else if (getprop("/MCDU[1]/page") == "TO") {
			perfTOInput("L4");
		} else if (getprop("/MCDU[1]/page") == "RADNAV") {
			radnavInput("L4");
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "5") {
		if (getprop("/MCDU[1]/page") == "INITA") {
			initInputA("L5");
		} else if (getprop("/MCDU[1]/page") == "TO") {
			perfTOInput("L5");
		} else if (getprop("/MCDU[1]/page") == "CLB") {
			perfCLBInput("L5");
		} else if (getprop("/MCDU[1]/page") == "CRZ") {
			perfCRZInput("L5");
		} else if (getprop("/MCDU[1]/page") == "DES") {
			perfDESInput("L5");
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "6") {
		if (getprop("/MCDU[1]/page") == "INITA") {
			initInputA("L6");
		} else if (getprop("/MCDU[1]/page") == "CLB") {
			perfCLBInput("L6");
		} else if (getprop("/MCDU[1]/page") == "CRZ") {
			perfCRZInput("L6");
		} else if (getprop("/MCDU[0]/page") == "DES") {
			perfDESInput("L6");
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	}
}

var lskbutton_b = func(btn) {
	# Special Middle Click Functions
}

var rskbutton = func(btn) {
	if (btn == "1") {
		if (getprop("/MCDU[1]/page") == "INITA") {
			initInputA("R1");
		} else if (getprop("/MCDU[1]/page") == "RADNAV") {
			radnavInput("R1");
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "2") {
		if (getprop("/MCDU[1]/page") == "INITB") {
			initInputB("R2");
		} else if (getprop("/MCDU[1]/page") == "RADNAV") {
			radnavInput("R2");
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "3") {
		if (getprop("/MCDU[1]/page") == "INITA") {
			initInputA("R3");
		} else if (getprop("/MCDU[1]/page") == "TO") {
			perfTOInput("R3");
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "4") {
		if (getprop("/MCDU[1]/page") == "TO") {
			perfTOInput("R4");
		} else if (getprop("/MCDU[1]/page") == "RADNAV") {
			radnavInput("R4");
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "5") {
		if (getprop("/MCDU[1]/page") == "TO") {
			perfTOInput("R5");
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "6") {
		if (getprop("/MCDU[1]/page") == "TO") {
			perfTOInput("R6");
		} else if (getprop("/MCDU[1]/page") == "CLB") {
			perfCLBInput("R6");
		} else if (getprop("/MCDU[1]/page") == "CRZ") {
			perfCRZInput("R6");
		} else {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		}
	}
}

var rskbutton_b = func(btn) {
	# Special Middle Click Functions
}

var radnavInput = func(key) {
	var scratchpad = getprop("/MCDU[1]/scratchpad");
	if (key == "L1") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor1freq-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 3 or tfs == 5 or tfs == 6) {
				if (scratchpad >= 108.10 and scratchpad <= 111.95) {
					if (scratchpad == 108.10 or scratchpad == 108.15 or scratchpad == 108.30 or scratchpad == 108.35 or scratchpad == 108.50 or scratchpad == 108.55 or scratchpad == 108.70 or scratchpad == 108.75 or scratchpad == 108.90 or scratchpad == 108.95 
					or scratchpad == 109.10 or scratchpad == 109.15 or scratchpad == 109.30 or scratchpad == 109.35 or scratchpad == 109.50 or scratchpad == 109.55 or scratchpad == 109.70 or scratchpad == 109.75 or scratchpad == 109.90 or scratchpad == 109.95 
					or scratchpad == 110.10 or scratchpad == 110.15 or scratchpad == 110.30 or scratchpad == 110.35 or scratchpad == 110.50 or scratchpad == 110.55 or scratchpad == 110.70 or scratchpad == 110.75 or scratchpad == 110.90 or scratchpad == 110.95 
					or scratchpad == 111.10 or scratchpad == 111.15 or scratchpad == 111.30 or scratchpad == 111.35 or scratchpad == 111.50 or scratchpad == 111.55 or scratchpad == 111.70 or scratchpad == 111.75 or scratchpad == 111.90 or scratchpad == 111.95) {
						setprop("/MCDU[1]/scratchpad-msg", "1");
						setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
					} else {
						setprop("/instrumentation/nav[0]/frequencies/selected-mhz", scratchpad);
						setprop("/FMGC/internal/vor1freq-set", 1);
						setprop("/MCDU[1]/scratchpad", "");
					}
				} else if (scratchpad >= 112.00 and scratchpad <= 117.95) {
					setprop("/instrumentation/nav[0]/frequencies/selected-mhz", scratchpad);
					setprop("/FMGC/internal/vor1freq-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L2") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor1crs-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs >= 1 and tfs <= 3) {
				if (scratchpad >= 0 and scratchpad <= 360) {
					setprop("/instrumentation/nav[0]/radials/selected-deg", scratchpad);
					setprop("/FMGC/internal/vor1crs-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L3") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor1freq-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
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
						setprop("/MCDU[1]/scratchpad", "");
					} else {
						setprop("/MCDU[1]/scratchpad-msg", "1");
						setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
					}
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L4") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor1crs-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs >= 1 and tfs <= 3) {
				if (scratchpad >= 0 and scratchpad <= 360) {
					setprop("/instrumentation/nav[0]/radials/selected-deg", scratchpad);
					setprop("/FMGC/internal/vor1crs-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "R1") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor2freq-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 3 or tfs == 5 or tfs == 6) {
				if (scratchpad >= 108.10 and scratchpad <= 111.95) {
					if (scratchpad == 108.10 or scratchpad == 108.15 or scratchpad == 108.30 or scratchpad == 108.35 or scratchpad == 108.50 or scratchpad == 108.55 or scratchpad == 108.70 or scratchpad == 108.75 or scratchpad == 108.90 or scratchpad == 108.95 
					or scratchpad == 109.10 or scratchpad == 109.15 or scratchpad == 109.30 or scratchpad == 109.35 or scratchpad == 109.50 or scratchpad == 109.55 or scratchpad == 109.70 or scratchpad == 109.75 or scratchpad == 109.90 or scratchpad == 109.95 
					or scratchpad == 110.10 or scratchpad == 110.15 or scratchpad == 110.30 or scratchpad == 110.35 or scratchpad == 110.50 or scratchpad == 110.55 or scratchpad == 110.70 or scratchpad == 110.75 or scratchpad == 110.90 or scratchpad == 110.95 
					or scratchpad == 111.10 or scratchpad == 111.15 or scratchpad == 111.30 or scratchpad == 111.35 or scratchpad == 111.50 or scratchpad == 111.55 or scratchpad == 111.70 or scratchpad == 111.75 or scratchpad == 111.90 or scratchpad == 111.95) {
						setprop("/MCDU[1]/scratchpad-msg", "1");
						setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
					} else {
						setprop("/instrumentation/nav[1]/frequencies/selected-mhz", scratchpad);
						setprop("/FMGC/internal/vor2freq-set", 1);
						setprop("/MCDU[1]/scratchpad", "");
					}
				} else if (scratchpad >= 112.00 and scratchpad <= 117.95) {
					setprop("/instrumentation/nav[1]/frequencies/selected-mhz", scratchpad);
					setprop("/FMGC/internal/vor2freq-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "R2") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vor2crs-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs >= 1 and tfs <= 3) {
				if (scratchpad >= 0 and scratchpad <= 360) {
					setprop("/instrumentation/nav[1]/radials/selected-deg", scratchpad);
					setprop("/FMGC/internal/vor2crs-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	}
}

var initInputA = func(key) {
	var scratchpad = getprop("/MCDU[1]/scratchpad");
	if (key == "L3") {
		if (scratchpad == "CLR") {
			setprop("/MCDUC/flight-num", "");
			setprop("/MCDUC/flight-num-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var flts = size(scratchpad);
			if (flts >= 1 and flts <= 8) {
				setprop("/MCDUC/flight-num", scratchpad);
				setprop("/MCDUC/flight-num-set", 1);
				setprop("/MCDU[1]/scratchpad", "");
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L5") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/cost-index", 0);
			setprop("/FMGC/internal/cost-index-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var ci = int(scratchpad);
			var cis = size(scratchpad);
			if (cis >= 1 and cis <= 3) {
				if (ci == nil) {
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				} else if (ci >= 0 and ci <= 120) {
					setprop("/FMGC/internal/cost-index", ci);
					setprop("/FMGC/internal/cost-index-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L6") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/cruise-ft", 10000);
			setprop("/FMGC/internal/cruise-fl", 100);
			setprop("/FMGC/internal/cruise-lvl-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var crz = int(scratchpad);
			var crzs = size(scratchpad);
			if (crzs >= 1 and crzs <= 3) {
				if (crz == nil) {
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				} else if (crz > 0 and crz <= 430) {
					setprop("/FMGC/internal/cruise-ft", crz * 100);
					setprop("/FMGC/internal/cruise-fl", crz);
					setprop("/FMGC/internal/cruise-lvl-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "R1") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/dep-arpt", "");
			setprop("/FMGC/internal/arr-arpt", "");
			setprop("/FMGC/internal/tofrom-set", 0);
			fmgc.updateARPT();
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 9) {
				var fromto = split("/", scratchpad);
				var froms = size(fromto[0]);
				var tos = size(fromto[1]);
				if (froms == 4 and tos == 4) {
					setprop("/FMGC/internal/dep-arpt", fromto[0]);
					setprop("/FMGC/internal/arr-arpt", fromto[1]);
					setprop("/FMGC/internal/tofrom-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
					fmgc.updateARPT();
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "R3") {
		if (getprop("/controls/adirs/mcducbtn") == 0) {
			setprop("/controls/adirs/mcducbtn", 1);
		}
	}
}

var initInputB = func(key) {
	var scratchpad = getprop("/MCDU[1]/scratchpad");
	if (key == "R2") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/block", 0.0);
			setprop("/FMGC/internal/block-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			var maxblock = getprop("/options/maxblock");
			if (tfs == 2 or tfs == 4 or tfs == 5) {
				if (scratchpad >= 1.0 and scratchpad <= maxblock) {
					setprop("/FMGC/internal/block", scratchpad);
					setprop("/FMGC/internal/block-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	}
}

var perfTOInput = func(key) {
	var scratchpad = getprop("/MCDU[1]/scratchpad");
	if (key == "L1") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/v1", 0);
			setprop("/FMGC/internal/v1-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 3) {
				if (scratchpad >= 100 and scratchpad <= 200) {
					setprop("/FMGC/internal/v1", scratchpad);
					setprop("/FMGC/internal/v1-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L2") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/vr", 0);
			setprop("/FMGC/internal/vr-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 3) {
				if (scratchpad >= 100 and scratchpad <= 200) {
					setprop("/FMGC/internal/vr", scratchpad);
					setprop("/FMGC/internal/vr-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L3") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/v2", 0);
			setprop("/FMGC/internal/v2-set", 0);
			setprop("/it-autoflight/settings/togaspd", 157);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 3) {
				if (scratchpad >= 100 and scratchpad <= 200) {
					setprop("/FMGC/internal/v2", scratchpad);
					setprop("/FMGC/internal/v2-set", 1);
					setprop("/it-autoflight/settings/togaspd", scratchpad + 10);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L4") {
		if (scratchpad == "CLR") {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 4 or tfs == 5) {
				if (scratchpad >= 1000 and scratchpad <= 18000) {
					setprop("/FMGC/internal/trans-alt", scratchpad);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L5") {
		if (scratchpad == "CLR") {
			setprop("/systems/thrust/clbreduc-ft", "1500");
			setprop("/FMGC/internal/reduc-agl-ft", "3000");
			setprop("/MCDUC/thracc-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 9) {
				var thracc = split("/", scratchpad);
				var thrred = size(thracc[0]);
				var acc = size(thracc[1]);
				if ((thrred >= 3 and thrred <= 5) and (acc >= 3 and acc <= 5)) {
					setprop("/systems/thrust/clbreduc-ft", thracc[0]);
					setprop("/FMGC/internal/reduc-agl-ft", thracc[1]);
					setprop("/MCDUC/thracc-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "R6") {
		setprop("/MCDU[1]/page", "CLB");
	} else if (key == "R3") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/to-flap", 0);
			setprop("/FMGC/internal/to-ths", "0.0");
			setprop("/FMGC/internal/flap-ths-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 7) {
				var flapths = split("/UP", scratchpad);
				if ((flapths[0] >= 1 and flapths[0] <= 4) and (flapths[1] >= 0.0 and flapths[1] <= 2.5)) {
					setprop("/FMGC/internal/to-flap", flapths[0]);
					setprop("/FMGC/internal/to-ths", flapths[1]);
					setprop("/FMGC/internal/flap-ths-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "R4") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/flex", 0);
			setprop("/FMGC/internal/flex-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs == 1 or tfs == 2) {
				if (scratchpad >= 0 and scratchpad <= 70) {
					setprop("/FMGC/internal/flex", scratchpad);
					setprop("/FMGC/internal/flex-set", 1);
					var flex_calc = getprop("/FMGC/internal/flex") - getprop("/environment/temperature-degc");
					setprop("/FMGC/internal/flex-cmd", flex_calc);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "R5") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/eng-out-reduc", "3500");
			setprop("/MCDUC/reducacc-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var tfs = size(scratchpad);
			if (tfs >= 3 and tfs <= 5) {
				setprop("/FMGC/internal/eng-out-reduc", scratchpad);
				setprop("/MCDUC/reducacc-set", 1);
				setprop("/MCDU[1]/scratchpad", "");
			} else {
				setprop("/MCDU[1]/scratchpad-msg", "1");
				setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
			}
		}
	}
}

var perfCLBInput = func(key) {
	var scratchpad = getprop("/MCDU[1]/scratchpad");
	if (key == "L5") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/cost-index", 0);
			setprop("/FMGC/internal/cost-index-set", 0);
			setprop("/MCDU[1]/scratchpad", "");
		} else {
			var ci = int(scratchpad);
			var cis = size(scratchpad);
			if (cis >= 1 and cis <= 3) {
				if (ci == nil) {
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				} else if (ci >= 0 and ci <= 120) {
					setprop("/FMGC/internal/cost-index", ci);
					setprop("/FMGC/internal/cost-index-set", 1);
					setprop("/MCDU[1]/scratchpad", "");
				} else {
					setprop("/MCDU[1]/scratchpad-msg", "1");
					setprop("/MCDU[1]/scratchpad", "NOT ALLOWED");
				}
			} else {
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

var perfCRZInput = func(key) {
	if (key == "L6") {
		setprop("/MCDU[1]/page", "CLB");
	}
	if (key == "R6") {
		setprop("/MCDU[1]/page", "DES");
	}
}

var perfDESInput = func(key) {
	if (key == "L6") {
		setprop("/MCDU[1]/page", "CRZ");
	}
}

var arrowbutton = func(btn) {
	if (btn == "left") {
		if (getprop("/MCDU[1]/page") == "DATA") {
			setprop("/MCDU[1]/page", "DATA2");
		} else if (getprop("/MCDU[1]/page") == "DATA2") {
			setprop("/MCDU[1]/page", "DATA");
		}
		if (getprop("/MCDU[1]/page") == "INITA") {
			setprop("/MCDU[1]/page", "INITB");
		} else if (getprop("/MCDU[1]/page") == "INITB") {
			setprop("/MCDU[1]/page", "INITA");
		}
	} else if (btn == "right") {
		if (getprop("/MCDU[1]/page") == "DATA") {
			setprop("/MCDU[1]/page", "DATA2");
		} else if (getprop("/MCDU[1]/page") == "DATA2") {
			setprop("/MCDU[1]/page", "DATA");
		}
		if (getprop("/MCDU[1]/page") == "INITA") {
			setprop("/MCDU[1]/page", "INITB");
		} else if (getprop("/MCDU[1]/page") == "INITB") {
			setprop("/MCDU[1]/page", "INITA");
		}
	} else if (btn == "up") {
		# Nothing for now
	} else if (btn == "down") {
		# Nothing for now
	}
}

var pagebutton = func(btn) {
	if (btn == "radnav") {
		setprop("/MCDU[1]/page", "RADNAV");
	} else if (btn == "perf") {
		if (getprop("/FMGC/status/phase") == 0 or getprop("/FMGC/status/phase") == 1) {
			setprop("/MCDU[1]/page", "TO");
		} else if (getprop("/FMGC/status/phase") == 2) {
			setprop("/MCDU[1]/page", "CLB");
		} else if (getprop("/FMGC/status/phase") == 3) {
			setprop("/MCDU[1]/page", "CRZ");
		}
	} else if (btn == "init") {
		setprop("/MCDU[1]/page", "INITA");
	} else if (btn == "data") {
		setprop("/MCDU[1]/page", "DATA");
	} else if (btn == "mcdu") {
		setprop("/MCDU[1]/last-fmgc-page", getprop("/MCDU[1]/page"));
		setprop("/MCDU[1]/page", "MCDU");
	}
}

var button = func(btn) {
	var scratchpad = getprop("/MCDU[1]/scratchpad");
	if (btn == "A") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "A");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "B") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "B");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "C") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "C");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "D") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "D");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "E") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "E");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "F") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "F");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "G") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "G");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "H") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "H");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "I") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "I");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "J") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "J");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "K") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "K");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "L") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "L");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "M") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "M");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "N") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "N");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "O") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "O");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "P") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "P");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "Q") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "Q");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "R") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "R");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "S") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "S");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "T") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "T");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "U") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "U");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "V") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "V");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "W") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "W");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "X") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "X");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "Y") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "Y");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "Z") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "Z");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "SLASH") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "/");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "SP") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ " ");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "CLR") {
		var scratchpad = getprop("/MCDU[1]/scratchpad");
		if (size(scratchpad) == 0) {
			setprop("/MCDU[1]/scratchpad-msg", "1");
			setprop("/MCDU[1]/scratchpad", "CLR");
		} else if (getprop("/MCDU[1]/scratchpad-msg") == 1) {
			setprop("/MCDU[1]/scratchpad", "");
			setprop("/MCDU[1]/scratchpad-msg", "0");
		} else if (size(scratchpad) > 0) {
			setprop("/MCDU[1]/scratchpad", left(scratchpad, size(scratchpad)-1));
			setprop("/MCDU[1]/scratchpad-msg", "0");
		}
	} else if (btn == "0") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "0");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "1") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "1");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "2") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "2");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "3") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "3");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "4") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "4");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "5") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "5");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "6") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "6");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "7") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "7");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "8") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "8");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "9") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "9");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "DOT") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ ".");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	} else if (btn == "PLUSMINUS") {
		setprop("/MCDU[1]/scratchpad", scratchpad ~ "-");
		setprop("/MCDU[1]/scratchpad-msg", "0");
	}
}

var screenFlash = func(time) {
	var page = getprop("/MCDU[1]/page");
	setprop("/MCDU[1]/page", "NONE");
	settimer(func {
		setprop("/MCDU[1]/page", page);
	}, time);
}
