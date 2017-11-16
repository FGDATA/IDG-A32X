# A3XX mCDU by Joshua Davidson (it0uchpods) and Jonathan Redpath

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

var dataInput = func(key) {
	if (key == "L1") {
		setprop("/MCDU[0]/page", "POSMON");
	}
	if (key == "L2") {
		setprop("/MCDU[0]/page", "IRSMON");
	}
	if (key == "R5") {
		setprop("/MCDU[0]/page", "PRINTFUNC");
	}
}

var printInput = func(key) {
	if (key == "L1") { 
		setprop("/FMGC/print/mcdu/page1/L1auto", 1);
	}
	if (key == "L2") { 
		setprop("/FMGC/print/mcdu/page1/L2auto", 1);
	}
	if (key == "L3") { 
		setprop("/FMGC/print/mcdu/page1/L3auto", 1);
	}
	if (key == "L5") { 
		setprop("/MCDU[0]/page", "DATA");
	}
	if (key == "R1") { 
		setprop("/FMGC/print/mcdu/page1/R1req", 1);
	}
	if (key == "R2") { 
		setprop("/FMGC/print/mcdu/page1/R2req", 1);
	}
	if (key == "R3") { 
		setprop("/FMGC/print/mcdu/page1/R3req", 1);
	}
}

var printInput2 = func(key) {
	if (key == "L1") { 
		setprop("/FMGC/print/mcdu/page2/L1auto", 1);
	}
	if (key == "L2") { 
		setprop("/FMGC/print/mcdu/page2/L2auto", 1);
	}
	if (key == "L3") { 
		setprop("/FMGC/print/mcdu/page2/L3auto", 1);
	}
	if (key == "L4") { 
		setprop("/FMGC/print/mcdu/page2/L4auto", 1);
	}
	if (key == "L6") { 
		setprop("/MCDU[0]/page", "DATA");
	}
	if (key == "R1") { 
		setprop("/FMGC/print/mcdu/page2/R1req", 1);
	}
	if (key == "R2") { 
		setprop("/FMGC/print/mcdu/page2/R2req", 1);
	}
	if (key == "R3") { 
		setprop("/FMGC/print/mcdu/page2/R3req", 1);
	}
	if (key == "R4") { 
		setprop("/FMGC/print/mcdu/page2/R4req", 1);
	}
}