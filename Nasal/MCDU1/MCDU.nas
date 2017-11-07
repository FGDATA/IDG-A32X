# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

var MCDU_init = func {
	setprop("/MCDU[0]/brightness", "1.0");
	MCDU_reset(); # Reset MCDU, clears data
}

var MCDU_reset = func {
	setprop("/MCDU[0]/active", 0);
	setprop("/it-autoflight/settings/togaspd", 157);
	setprop("/MCDU[0]/last-scratchpad", "");
	setprop("/MCDU[0]/last-fmgc-page", "STATUS");
	setprop("/MCDU[0]/page", "MCDU");
	setprop("/MCDU[0]/scratchpad", "SELECT DESIRED SYSTEM");
	setprop("/MCDU[0]/scratchpad-msg", 0);
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
	setprop("/FMGC/internal/ils1freq-set", 0);
	setprop("/FMGC/internal/ils1crs-set", 0);
	setprop("/FMGC/internal/vor1freq-set", 0);
	setprop("/FMGC/internal/vor1crs-set", 0);
	setprop("/FMGC/internal/vor2freq-set", 0);
	setprop("/FMGC/internal/vor2crs-set", 0);
	setprop("/FMGC/internal/adf1freq-set", 0);
	setprop("/FMGC/internal/adf2freq-set", 0);
	setprop("/FMGC/internal/navdatabase", "01JAN-28JAN");
	setprop("/FMGC/internal/navdatabase2", "29JAN-26FEB");
	setprop("/FMGC/internal/navdatabasecode", "AB20170101");
	setprop("/FMGC/internal/navdatabasecode2", "AB20170102");
	setprop("/FMGC/print/mcdu/page1/L1auto", 0);
	setprop("/FMGC/print/mcdu/page1/L2auto", 0);
	setprop("/FMGC/print/mcdu/page1/L3auto", 0);
	setprop("/FMGC/print/mcdu/page1/R1req", 0);
	setprop("/FMGC/print/mcdu/page1/R2req", 0);
	setprop("/FMGC/print/mcdu/page1/R3req", 0);
	setprop("/FMGC/print/mcdu/page2/L1auto", 0);
	setprop("/FMGC/print/mcdu/page2/L2auto", 0);
	setprop("/FMGC/print/mcdu/page2/L3auto", 0);
	setprop("/FMGC/print/mcdu/page2/L4auto", 0);
	setprop("/FMGC/print/mcdu/page2/R1req", 0);
	setprop("/FMGC/print/mcdu/page2/R2req", 0);
	setprop("/FMGC/print/mcdu/page2/R3req", 0);
	setprop("/FMGC/print/mcdu/page2/R4req", 0);
	setprop("/FMGC/internal/tropo", 36090);
	setprop("/FMGC/internal/tropo-set", 0);
}

var lskbutton = func(btn) {
	if (btn == "1") {
		if (getprop("/MCDU[0]/page") == "MCDU") {
			if (getprop("/MCDU[0]/active") != 2) {
				setprop("/MCDU[0]/scratchpad-msg", "1");
				setprop("/MCDU[0]/scratchpad", "WAIT FOR SYSTEM RESPONSE");
				setprop("/MCDU[0]/active", 1);
				settimer(func(){
					setprop("/MCDU[0]/page", getprop("/MCDU[0]/last-fmgc-page"));
					setprop("/MCDU[0]/scratchpad", "");
					setprop("/MCDU[0]/scratchpad-msg", "0");
					setprop("/MCDU[0]/active", 2);
				}, 2);
			} else {
				setprop("/MCDU[0]/page", getprop("/MCDU[0]/last-fmgc-page"));
				setprop("/MCDU[0]/scratchpad", "");
				setprop("/MCDU[0]/scratchpad-msg", "0");
			}
		} else if (getprop("/MCDU[0]/page") == "TO") {
			perfTOInput("L1");
		} else if (getprop("/MCDU[0]/page") == "RADNAV") {
			radnavInput("L1");
		} else if (getprop("/MCDU[0]/page") == "DATA") {
			dataInput("L1");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC") {
			printInput("L1");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			printInput2("L1");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "2") {
		if (getprop("/MCDU[0]/page") == "INITA") {
			PerfInput("L2");
		} else if (getprop("/MCDU[0]/page") == "TO") {
			perfTOInput("L2");
		} else if (getprop("/MCDU[0]/page") == "RADNAV") {
			radnavInput("L2");
		} else if (getprop("/MCDU[0]/page") == "CLB") {
			initInputA("L5"); # Does the same thing as on the INIT page
		} else if (getprop("/MCDU[0]/page") == "CRZ") {
			initInputA("L5"); 
		} else if (getprop("/MCDU[0]/page") == "DES") {
			initInputA("L5"); 
		} else if (getprop("/MCDU[0]/page") == "DATA") {
			dataInput("L2");
 		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC") {
			printInput("L2");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			printInput2("L2");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "3") {
		if (getprop("/MCDU[0]/page") == "INITA") {
			initInputA("L3");
		} else if (getprop("/MCDU[0]/page") == "TO") {
			perfTOInput("L3");
		} else if (getprop("/MCDU[0]/page") == "STATUS") {
			statusInput("L3");
		} else if (getprop("/MCDU[0]/page") == "RADNAV") {
			radnavInput("L3");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC") {
			printInput("L3");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			printInput2("L3");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "4") {
		if (getprop("/MCDU[0]/page") == "DATA") {
			setprop("/MCDU[0]/page", "STATUS");
		} else if (getprop("/MCDU[0]/page") == "TO") {
			perfTOInput("L4");
		} else if (getprop("/MCDU[0]/page") == "RADNAV") {
			radnavInput("L4");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			printInput2("L4");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "5") {
		if (getprop("/MCDU[0]/page") == "INITA") {
			initInputA("L5");
		} else if (getprop("/MCDU[0]/page") == "TO") {
			perfTOInput("L5");
		} else if (getprop("/MCDU[0]/page") == "CLB") {
			perfCLBInput("L5");
		} else if (getprop("/MCDU[0]/page") == "CRZ") {
			perfCRZInput("L5");
		} else if (getprop("/MCDU[0]/page") == "DES") {
			perfDESInput("L5");
		} else if (getprop("/MCDU[0]/page") == "RADNAV") {
			radnavInput("L5");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC") {
			printInput("L5");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			printInput2("L5");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "6") {
		if (getprop("/MCDU[0]/page") == "INITA") {
			initInputA("L6");
		} else if (getprop("/MCDU[0]/page") == "CLB") {
			perfCLBInput("L6");
		} else if (getprop("/MCDU[0]/page") == "CRZ") {
			perfCRZInput("L6");
		} else if (getprop("/MCDU[0]/page") == "DES") {
			perfDESInput("L6");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			printInput2("L6");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	}
}

var lskbutton_b = func(btn) {
	# Special Middle Click Functions
}

var rskbutton = func(btn) {
	if (btn == "1") {
		if (getprop("/MCDU[0]/page") == "INITA") {
			initInputA("R1");
		} else if (getprop("/MCDU[0]/page") == "RADNAV") {
			radnavInput("R1");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC") {
			printInput("R1");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			printInput2("R1");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "2") {
		if (getprop("/MCDU[0]/page") == "INITB") {
			initInputB("R2");
		} else if (getprop("/MCDU[0]/page") == "RADNAV") {
			radnavInput("R2");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC") {
			printInput("R2");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			printInput2("R2");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "3") {
		if (getprop("/MCDU[0]/page") == "INITA") {
			initInputA("R3");
		} else if (getprop("/MCDU[0]/page") == "TO") {
			perfTOInput("R3");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC") {
			printInput("R3");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			printInput2("R3");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "4") {
		if (getprop("/MCDU[0]/page") == "TO") {
			perfTOInput("R4");
		} else if (getprop("/MCDU[0]/page") == "RADNAV") {
			radnavInput("R4");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			printInput2("R4");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "5") {
		if (getprop("/MCDU[0]/page") == "TO") {
			perfTOInput("R5");
		} else if (getprop("/MCDU[0]/page") == "RADNAV") {
			radnavInput("R5");
		} else if (getprop("/MCDU[0]/page") == "DATA") {
			dataInput("R5");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	} else if (btn == "6") {
		if (getprop("/MCDU[0]/page") == "TO") {
			perfTOInput("R6");
		} else if (getprop("/MCDU[0]/page") == "CLB") {
			perfCLBInput("R6");
		} else if (getprop("/MCDU[0]/page") == "CRZ") {
			perfCRZInput("R6");
		} else if ((getprop("/MCDU[0]/page") == "DATA") or (getprop("/MCDU[0]/page") == "PRINTFUNC") or (getprop("/MCDU[0]/page") == "PRINTFUNC2")) {
			if (getprop("/MCDU[0]/scratchpad") != "AOC DISABLED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "AOC DISABLED");
		} else if (getprop("/MCDU[0]/page") == "INITA") {
			initInputA("R6");
		} else {
			if (getprop("/MCDU[0]/scratchpad") != "NOT ALLOWED") {
				setprop("/MCDU[0]/last-scratchpad", getprop("/MCDU[0]/scratchpad"));
			}
			setprop("/MCDU[0]/scratchpad-msg", "1");
			setprop("/MCDU[0]/scratchpad", "NOT ALLOWED");
		}
	}
}

var rskbutton_b = func(btn) {
	# Special Middle Click Functions
}

var arrowbutton = func(btn) {
	if (btn == "left") {
		if (getprop("/MCDU[0]/page") == "DATA") {
			setprop("/MCDU[0]/page", "DATA2");
		} else if (getprop("/MCDU[0]/page") == "DATA2") {
			setprop("/MCDU[0]/page", "DATA");
		}
		if (getprop("/MCDU[0]/page") == "INITA") {
			if (getprop("/engines/engine[0]/state") != 3 and getprop("/engines/engine[1]/state") != 3) {
				setprop("/MCDU[0]/page", "INITB");
			}
		} else if (getprop("/MCDU[0]/page") == "INITB") {
			setprop("/MCDU[0]/page", "INITA");
		}
		if (getprop("/MCDU[0]/page") == "PRINTFUNC") {
			setprop("/MCDU[0]/page", "PRINTFUNC2");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			setprop("/MCDU[0]/page", "PRINTFUNC");
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
		if (getprop("/MCDU[0]/page") == "PRINTFUNC") {
			setprop("/MCDU[0]/page", "PRINTFUNC2");
		} else if (getprop("/MCDU[0]/page") == "PRINTFUNC2") {
			setprop("/MCDU[0]/page", "PRINTFUNC");
		}
	} else if (btn == "up") {
		# Nothing for now
	} else if (btn == "down") {
		# Nothing for now
	}
}

var pagebutton = func(btn) {
	if (getprop("/MCDU[0]/page") != "MCDU") {
		if (btn == "radnav") {
			setprop("/MCDU[0]/page", "RADNAV");
		} else if (btn == "perf") {
			if (getprop("/FMGC/status/phase") == 0 or getprop("/FMGC/status/phase") == 1) {
				setprop("/MCDU[0]/page", "TO");
			} else if (getprop("/FMGC/status/phase") == 2) {
				setprop("/MCDU[0]/page", "CLB");
			} else if (getprop("/FMGC/status/phase") == 3) {
				setprop("/MCDU[0]/page", "CRZ");
			} else if (getprop("/FMGC/status/phase") == 4) {
				setprop("/MCDU[0]/page", "DES");
			}
		} else if (btn == "init") {
			setprop("/MCDU[0]/page", "INITA");
		} else if (btn == "data") {
			setprop("/MCDU[0]/page", "DATA");
		} else if (btn == "mcdu") {
			setprop("/MCDU[0]/last-fmgc-page", getprop("/MCDU[0]/page"));
			setprop("/MCDU[0]/scratchpad", "SELECT DESIRED SYSTEM");
			setprop("/MCDU[0]/page", "MCDU");
		} else if (btn == "f-pln") {
			setprop("/MCDU[0]/page", "F-PLNA");
		}
	}
}

var button = func(btn) {
	if (getprop("/MCDU[0]/scratchpad-msg") == 0 and getprop("/MCDU[0]/page") != "MCDU") {
		var scratchpad = getprop("/MCDU[0]/scratchpad");
		if (btn == "A") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "A");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "B") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "B");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "C") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "C");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "D") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "D");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "E") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "E");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "F") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "F");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "G") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "G");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "H") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "H");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "I") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "I");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "J") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "J");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "K") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "K");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "L") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "L");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "M") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "M");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "N") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "N");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "O") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "O");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "P") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "P");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "Q") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "Q");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "R") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "R");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "S") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "S");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "T") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "T");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "U") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "U");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "V") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "V");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "W") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "W");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "X") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "X");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "Y") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "Y");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "Z") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "Z");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "SLASH") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "/");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "SP") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ " ");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "CLR") {
			var scratchpad = getprop("/MCDU[0]/scratchpad");
			if (size(scratchpad) == 0) {
				setprop("/MCDU[0]/scratchpad-msg", "1");
				setprop("/MCDU[0]/scratchpad", "CLR");
			} else if (getprop("/MCDU[0]/scratchpad-msg") == 1) {
				setprop("/MCDU[0]/scratchpad", "");
				setprop("/MCDU[0]/scratchpad-msg", "0");
			} else if (size(scratchpad) > 0) {
				setprop("/MCDU[0]/last-scratchpad", "");
				setprop("/MCDU[0]/scratchpad", left(scratchpad, size(scratchpad)-1));
				setprop("/MCDU[0]/scratchpad-msg", "0");
			}
		} else if (btn == "0") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "0");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "1") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "1");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "2") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "2");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "3") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "3");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "4") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "4");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "5") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "5");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "6") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "6");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "7") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "7");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "8") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "8");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "9") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "9");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "DOT") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ ".");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		} else if (btn == "PLUSMINUS") {
			setprop("/MCDU[0]/scratchpad", scratchpad ~ "-");
			setprop("/MCDU[0]/scratchpad-msg", "0");
		}
	} else {
		if (btn == "CLR") {
			var scratchpad = getprop("/MCDU[0]/scratchpad");
			if (size(scratchpad) == 0) {
				setprop("/MCDU[0]/scratchpad-msg", "1");
				setprop("/MCDU[0]/scratchpad", "CLR");
			} else if (getprop("/MCDU[0]/scratchpad-msg") == 1) {
				setprop("/MCDU[0]/scratchpad", getprop("/MCDU[0]/last-scratchpad"));
				setprop("/MCDU[0]/last-scratchpad", "");
				setprop("/MCDU[0]/scratchpad-msg", "0");
			}
		}
	}
}

var screenFlash = func(time) {
	var page = getprop("/MCDU[0]/page");
	setprop("/MCDU[0]/page", "NONE");
	settimer(func {
		setprop("/MCDU[0]/page", page);
	}, time);
}
