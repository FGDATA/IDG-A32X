##################################################################
# A3XX MCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath #
##################################################################

var MCDU_init = func {
	setprop("/MCDU[0]/brightness", "1.0");
	MCDU_reset(); # Reset MCDU, clears data
}

var MCDU_reset = func {
	setprop("/MCDU[0]/page", "STATUS");
	setprop("/MCDU[0]/cost-index", 0);
	setprop("/MCDU[0]/flight-num", 0);
	setprop("/MCDU[0]/scratchpad", "");
	setprop("/FMGC/internal/cost-index-set", 0);
	setprop("/FMGC/internal/cruise-lvl-set", 0);
}

var lskbutton = func(btn) {
	if (btn == "2") {
		if (getprop("/MCDU[0]/page") == "INITA") {
			PerfInput("L2");
		}
	} else if (btn == "4") {
		if (getprop("/MCDU[0]/page") == "DATA") {
			setprop("/MCDU[0]/page", "STATUS");
		}
	} else if (btn == "5") {
		if (getprop("/MCDU[0]/page") == "INITA") {
			initInputA("L5");
		} else if (getprop("/MCDU[0]/page") == "CLB") {
			PerfCLBInput("L5");
		}
	} else if (btn == "6") {
		if (getprop("/MCDU[0]/page") == "INITA") {
			initInputA("L6");
		} else if (getprop("/MCDU[0]/page") == "CLB") {
			PerfCLBInput("L6");
		}
	}
}
	

var initInputA = func(key) {
	var scratchpad = getprop("/MCDU[0]/scratchpad");
	if (key == "L5") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/cost-index", 0);
			setprop("/FMGC/internal/cost-index-set", 0);
			setprop("/MCDU[0]/scratchpad", "");
		} else {
			var ci = int(scratchpad);
			var cis = size(scratchpad);
			if (cis >= 1 and cis <= 3) {
				if (cis >= 0 and cis <= 120) {
					setprop("/FMGC/internal/cost-index", ci);
					setprop("/FMGC/internal/cost-index-set", 1);
					setprop("/MCDU[0]/scratchpad", "");
				} else {
					setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L6") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/cruise-ft", 10000);
			setprop("/FMGC/internal/cruise-fl", 100);
			setprop("/FMGC/internal/cruise-lvl-set", 0);
			setprop("/MCDU[0]/scratchpad", "");
		} else {
			var crz = int(scratchpad);
			var crzs = size(scratchpad);
			if (crzs >= 1 and crzs <= 3) {
				if (crz > 0 and crz <= 430) {
					setprop("/FMGC/internal/cruise-ft", crz * 100);
					setprop("/FMGC/internal/cruise-fl", crz);
					setprop("/FMGC/internal/cruise-lvl-set", 1);
					setprop("/MCDU[0]/scratchpad", "");
				} else {
					setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
			}
		}
	}
}

var PerfCLBInput = func(key) {
	var scratchpad = getprop("/MCDU[0]/scratchpad");
	if (key == "L5") {
		if (scratchpad == "CLR") {
			setprop("/FMGC/internal/cost-index", 0);
			setprop("/FMGC/internal/cost-index-set", 0);
			setprop("/MCDU[0]/scratchpad", "");
		} else {
			var ci = int(scratchpad);
			var cis = size(scratchpad);
			if (cis >= 1 and cis <= 3) {
				if (cis >= 0 and cis <= 120) {
					setprop("/FMGC/internal/cost-index", ci);
					setprop("/FMGC/internal/cost-index-set", 1);
					setprop("/MCDU[0]/scratchpad", "");
				} else {
					setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
				}
			} else {
				setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
			}
		}
	} else if (key == "L6") {
		setprop("/MCDU[0]/page", "TO");
	}
}

var PerfTOInput = func(key) {
	if (key == "R6") {
		setprop("/MCDU[0]/page", "CLB");
	}
}

var rskbutton = func(btn) {
	if (btn == "6") {
		if (getprop("/MCDU[0]/page") == "TO") {
			PerfTOInput("R6");
		}
	}
}

var arrowbutton = func(btn) {
	if (btn == "left") {
		if (getprop("/MCDU[0]/page") == "DATA") {
			setprop("/MCDU[0]/page", "DATA2");
		} else if (getprop("/MCDU[0]/page") == "DATA2") {
			setprop("/MCDU[0]/page", "DATA");
		}
		if (getprop("/MCDU[0]/page") == "INITA") {
			setprop("/MCDU[0]/page", "INITB");
		} else if (getprop("/MCDU[0]/page") == "INITB") {
			setprop("/MCDU[0]/page", "INITA");
		}
	} else if (btn == "right") {
		if (getprop("/MCDU[0]/page") == "DATA") {
			setprop("/MCDU[0]/page", "DATA2");
		} else if (getprop("/MCDU[0]/page") == "DATA2") {
			setprop("/MCDU[0]/page", "DATA");
		}
		if (getprop("/MCDU[0]/page") == "INITA") {
			setprop("/MCDU[0]/page", "INITB");
		} else if (getprop("/MCDU[0]/page") == "INITB") {
			setprop("/MCDU[0]/page", "INITA");
		}
	} else if (btn == "up") {
		# Nothing for now
	} else if (btn == "down") {
		# Nothing for now
	}
}

var pagebutton = func(btn) {
	if (btn == "perf") {
		if (getprop("/FMGC/status/phase") == 0 or getprop("/FMGC/status/phase") == 1) {
			setprop("/MCDU[0]/page", "TO");
		}
	} else if (btn == "init") {
		setprop("/MCDU[0]/page", "INITA");
	} else if (btn == "data") {
		setprop("/MCDU[0]/page", "DATA");
	}
}

var button = func(btn) {
	var scratchpad = getprop("/MCDU[0]/scratchpad");
	if (btn == "A") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "A");
	} else if (btn == "B") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "B");
	} else if (btn == "C") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "C");
	} else if (btn == "D") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "D");
	} else if (btn == "E") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "E");
	} else if (btn == "F") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "F");
	} else if (btn == "G") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "G");
	} else if (btn == "H") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "H");
	} else if (btn == "I") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "I");
	} else if (btn == "J") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "J");
	} else if (btn == "K") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "K");
	} else if (btn == "L") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "L");
	} else if (btn == "M") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "M");
	} else if (btn == "N") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "N");
	} else if (btn == "O") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "O");
	} else if (btn == "P") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "P");
	} else if (btn == "Q") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "Q");
	} else if (btn == "R") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "R");
	} else if (btn == "S") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "S");
	} else if (btn == "T") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "T");
	} else if (btn == "U") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "U");
	} else if (btn == "V") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "V");
	} else if (btn == "W") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "W");
	} else if (btn == "X") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "X");
	} else if (btn == "Y") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "Y");
	} else if (btn == "Z") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "Z");
	} else if (btn == "SLASH") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "/");
	} else if (btn == "SP") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ " ");
	} else if (btn == "CLR") {
		var scratchpad = getprop("/MCDU[0]/scratchpad");
		if (size(scratchpad) == 0) {
			setprop("/MCDU[0]/scratchpad", "CLR");
		} else if (scratchpad == "CLR") {
			setprop("/MCDU[0]/scratchpad", "");
		} else if (scratchpad == "NOT ALLOWED") {
			setprop("/MCDU[0]/scratchpad", "");
		} else if (size(scratchpad) > 0) {
			setprop("/MCDU[0]/scratchpad", left(scratchpad, size(scratchpad)-1));
		}
	} else if (btn == "0") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "0");
	} else if (btn == "1") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "1");
	} else if (btn == "2") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "2");
	} else if (btn == "3") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "3");
	} else if (btn == "4") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "4");
	} else if (btn == "5") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "5");
	} else if (btn == "6") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "6");
	} else if (btn == "7") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "7");
	} else if (btn == "8") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "8");
	} else if (btn == "9") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ "9");
	} else if (btn == "DOT") {
		setprop("/MCDU[0]/scratchpad", scratchpad ~ ".");
	}
}

var screenFlash = func(time) {
	var page = getprop("/MCDU[0]/page");
	setprop("/MCDU[0]/page", "NONE");
	settimer(func {
		setprop("/MCDU[0]/page", page);
	}, time);
}
