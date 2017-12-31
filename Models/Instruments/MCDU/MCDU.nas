# A3XX MCDU
# Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

var MCDU_1 = nil;
var MCDU_2 = nil;
var MCDU1_display = nil;
var MCDU2_display = nil;
var default = "BoeingCDU-Large.ttf";
var bracket = "helvetica_medium.txf";
var normal = 70;
var small = 56;
var page = "";
var page1 = getprop("/MCDU[0]/page");
var page2 = getprop("/MCDU[1]/page");
var vor1 = "";
var vor2 = "";
var ils = "";
var adf1 = "";
var adf2 = "";
setprop("/MCDUC/colors/wht/r", 1);
setprop("/MCDUC/colors/wht/g", 1);
setprop("/MCDUC/colors/wht/b", 1);
setprop("/MCDUC/colors/grn/r", 0.0509);
setprop("/MCDUC/colors/grn/g", 0.7529);
setprop("/MCDUC/colors/grn/b", 0.2941);
setprop("/MCDUC/colors/blu/r", 0.0901);
setprop("/MCDUC/colors/blu/g", 0.6039);
setprop("/MCDUC/colors/blu/b", 0.7176);
setprop("/MCDUC/colors/amb/r", 0.7333);
setprop("/MCDUC/colors/amb/g", 0.3803);
setprop("/MCDUC/colors/amb/b", 0.0000);
setprop("/MCDUC/colors/yel/r", 0.9333);
setprop("/MCDUC/colors/yel/g", 0.9333);
setprop("/MCDUC/colors/yel/b", 0.0000);

var canvas_MCDU_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "BoeingCDU-Large.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});

		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
			var svg_keys = me.getKeys();

			foreach (var key; svg_keys) {
				me[key] = canvas_group.getElementById(key);

				var clip_el = canvas_group.getElementById(key ~ "_clip");
				if (clip_el != nil) {
					clip_el.setVisible(0);
					var tran_rect = clip_el.getTransformedBounds();

					var clip_rect = sprintf("rect(%d,%d, %d,%d)", 
					tran_rect[1], # 0 ys
					tran_rect[2], # 1 xe
					tran_rect[3], # 2 ye
					tran_rect[0]); #3 xs
					#   coordinates are top,right,bottom,left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
					me[key].set("clip", clip_rect);
					me[key].set("clip-frame", canvas.Element.PARENT);
				}
			}
		}
		
		me.page = canvas_group;
		
		return me;
	},
	getKeys: func() {
		return ["Simple","Simple_Center","Scratchpad","Simple_Title","Simple_PageNum","ArrowLeft","ArrowRight","Simple_L1","Simple_L2","Simple_L3","Simple_L4","Simple_L5","Simple_L6","Simple_L1S","Simple_L2S","Simple_L3S","Simple_L4S","Simple_L5S","Simple_L6S",
		"Simple_L1_Arrow","Simple_L2_Arrow","Simple_L3_Arrow","Simple_L4_Arrow","Simple_L5_Arrow","Simple_L6_Arrow","Simple_R1","Simple_R2","Simple_R3","Simple_R4","Simple_R5","Simple_R6","Simple_R1S","Simple_R2S","Simple_R3S","Simple_R4S","Simple_R5S",
		"Simple_R6S","Simple_R1_Arrow","Simple_R2_Arrow","Simple_R3_Arrow","Simple_R4_Arrow","Simple_R5_Arrow","Simple_R6_Arrow","Simple_C1","Simple_C2","Simple_C3","Simple_C4","Simple_C5","Simple_C6","Simple_C1S","Simple_C2S","Simple_C3S","Simple_C4S",
		"Simple_C5S","Simple_C6S","INITA","INITA_CoRoute","INITA_FltNbr","INITA_CostIndex","INITA_CruiseFLTemp","INITA_FromTo","INITA_InitRequest","INITA_AlignIRS"];
	},
	update: func() {
		if (getprop("/systems/electrical/bus/ac1") >= 110) {
			MCDU_1.page.show();
			MCDU_1.update();
		} else {
			MCDU_1.page.hide();
		}
		if (getprop("/systems/electrical/bus/ac2") >= 110) {
			MCDU_2.page.show();
			MCDU_2.update();
		} else {
			MCDU_2.page.hide();
		}
	},
	updateCommon: func(i) {
		page = getprop("/MCDU[" ~ i ~ "]/page");
		if (page == "MCDU") {
			me["Simple"].show();
			me["Simple_Center"].hide();
			me["INITA"].hide();
			me["Simple_Title"].setText("  MCDU MENU");
			me["Simple_PageNum"].setText("X/X");
			me["Simple_PageNum"].hide();
			me["ArrowLeft"].hide();
			me["ArrowRight"].hide();
			me["Simple_L1"].show();
			me["Simple_L2"].show();
			me["Simple_L3"].show();
			me["Simple_L4"].show();
			me["Simple_L5"].hide();
			me["Simple_L6"].hide();
			me["Simple_L1S"].hide();
			me["Simple_L2S"].hide();
			me["Simple_L3S"].hide();
			me["Simple_L4S"].hide();
			me["Simple_L5S"].hide();
			me["Simple_L6S"].hide();
			me["Simple_L1_Arrow"].show();
			me["Simple_L2_Arrow"].show();
			me["Simple_L3_Arrow"].show();
			me["Simple_L4_Arrow"].show();
			me["Simple_L5_Arrow"].hide();
			me["Simple_L6_Arrow"].hide();
			me["Simple_R1"].hide();
			me["Simple_R2"].hide();
			me["Simple_R3"].hide();
			me["Simple_R4"].hide();
			me["Simple_R5"].hide();
			me["Simple_R6"].show();
			me["Simple_R1S"].hide();
			me["Simple_R2S"].hide();
			me["Simple_R3S"].hide();
			me["Simple_R4S"].hide();
			me["Simple_R5S"].hide();
			me["Simple_R6S"].hide();
			me["Simple_R1_Arrow"].hide();
			me["Simple_R2_Arrow"].hide();
			me["Simple_R3_Arrow"].hide();
			me["Simple_R4_Arrow"].hide();
			me["Simple_R5_Arrow"].hide();
			me["Simple_R6_Arrow"].show();
			
			me.fontLeft(default, default, default, default, default, default);
			me.fontLeftS(default, default, default, default, default, default);
			me.fontRight(default, default, default, default, default, default);
			me.fontRightS(default, default, default, default, default, default);
			
			me.fontSizeLeft(normal, normal, normal, normal, normal, normal);
			me.fontSizeRight(normal, normal, normal, normal, normal, normal);
			
			me.colorLeft("ack", "wht", "wht", "wht", "wht", "wht");
			me.colorLeftS("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorLeftArrow("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRight("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRightS("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRightArrow("wht", "wht", "wht", "wht", "wht", "wht");
			
			if (getprop("/MCDU[" ~ i ~ "]/active") == 0) {
				me["Simple_L1"].setText(" FMGC");
				me["Simple_L1"].setColor(1,1,1);
			} else if (getprop("/MCDU[" ~ i ~ "]/active") == 1) {
				me["Simple_L1"].setText(" FMGC(SEL)");
				me["Simple_L1"].setColor(0.0901,0.6039,0.7176);
			} else if (getprop("/MCDU[" ~ i ~ "]/active") == 2) {
				me["Simple_L1"].setText(" FMGC");
				me["Simple_L1"].setColor(0.0509,0.7529,0.2941);
			}
			me["Simple_L2"].setText(" ACARS");
			me["Simple_L3"].setText(" AIDS");
			me["Simple_L4"].setText(" CFDS");
			me["Simple_R6"].setText("RETURN ");
		} else if (page == "STATUS") {
			me["Simple"].show();
			me["Simple_Center"].hide();
			me["INITA"].hide();
			me["Simple_Title"].setText(sprintf("%s", getprop("/MCDUC/type")));
			me["Simple_PageNum"].setText("X/X");
			me["Simple_PageNum"].hide();
			me["ArrowLeft"].hide();
			me["ArrowRight"].hide();
			
			me["Simple_L1"].show();
			me["Simple_L2"].show();
			me["Simple_L3"].show();
			me["Simple_L4"].hide();
			me["Simple_L5"].show();
			me["Simple_L6"].show();
			me["Simple_L1S"].show();
			me["Simple_L2S"].show();
			me["Simple_L3S"].show();
			me["Simple_L4S"].hide();
			me["Simple_L5S"].show();
			me["Simple_L6S"].show();
			me["Simple_L1_Arrow"].hide();
			me["Simple_L2_Arrow"].hide();
			me["Simple_L3_Arrow"].show();
			me["Simple_L4_Arrow"].hide();
			me["Simple_L5_Arrow"].hide();
			me["Simple_L6_Arrow"].hide();
			me["Simple_R1"].hide();
			me["Simple_R2"].show();
			me["Simple_R3"].hide();
			me["Simple_R4"].hide();
			me["Simple_R5"].hide();
			me["Simple_R6"].show(); 
			me["Simple_R1S"].hide();
			me["Simple_R2S"].hide();
			me["Simple_R3S"].hide();
			me["Simple_R4S"].hide();
			me["Simple_R5S"].hide();
			me["Simple_R6S"].show();
			me["Simple_R1_Arrow"].hide();
			me["Simple_R2_Arrow"].hide();
			me["Simple_R3_Arrow"].hide();
			me["Simple_R4_Arrow"].hide();
			me["Simple_R5_Arrow"].hide();
			me["Simple_R6_Arrow"].show();
			
			me.fontLeft(default, default, default, default, bracket, default);
			me.fontLeftS(default, default, default, default, default, default);
			me.fontRight(default, default, default, default, default, default);
			me.fontRightS(default, default, default, default, default, default);
			
			me.fontSizeLeft(normal, normal, normal, normal, small, normal);
			me.fontSizeRight(normal, normal, normal, normal, normal, normal);
			
			me.colorLeft("grn", "blu", "blu", "wht", "blu", "grn");
			me.colorLeftS("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorLeftArrow("wht", "blu", "blu", "wht", "wht", "wht");
			me.colorRight("wht", "grn", "wht", "wht", "wht", "wht");
			me.colorRightS("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRightArrow("wht", "wht", "wht", "wht", "wht", "wht");
			
			me["Simple_L1"].setText(sprintf("%s", getprop("/MCDUC/eng")));
			me["Simple_L2"].setText(sprintf("%s", " " ~ getprop("/FMGC/internal/navdatabase")));
			me["Simple_L3"].setText(sprintf("%s", " " ~ getprop("/FMGC/internal/navdatabase2")));
			me["Simple_L5"].setText("[   ]");
			me["Simple_L6"].setText("+4.0/+0.0");
			me["Simple_L1S"].setText(" ENG");
			me["Simple_L2S"].setText(" ACTIVE NAV DATA BASE");
			me["Simple_L3S"].setText(" SECOND NAV DATA BASE");
			me["Simple_L5S"].setText("CHG CODE");
			me["Simple_L6S"].setText("IDLE/PERF");
			me["Simple_R2"].setText(sprintf("%s", getprop("/FMGC/internal/navdatabasecode") ~ " "));
			me["Simple_R6"].setText("STATUS/XLOAD ");
			me["Simple_R6S"].setText("SOFTWARE ");
		} else if (page == "DATA") {
			me["Simple"].show();
			me["Simple_Center"].hide();
			me["INITA"].hide();
			me["Simple_Title"].setText("DATA INDEX");
			me["Simple_PageNum"].setText("1/2");
			me["Simple_PageNum"].show();
			me["ArrowLeft"].show();
			me["ArrowRight"].show();
			
			me["Simple_L1"].show();
			me["Simple_L2"].show();
			me["Simple_L3"].show();
			me["Simple_L4"].show();
			me["Simple_L5"].hide();
			me["Simple_L6"].hide();
			me["Simple_L1S"].show();
			me["Simple_L2S"].show();
			me["Simple_L3S"].show();
			me["Simple_L4S"].hide();
			me["Simple_L5S"].hide();
			me["Simple_L6S"].hide();
			me["Simple_L1_Arrow"].show();
			me["Simple_L2_Arrow"].show();
			me["Simple_L3_Arrow"].show();
			me["Simple_L4_Arrow"].show();
			me["Simple_L5_Arrow"].hide();
			me["Simple_L6_Arrow"].hide();
			me["Simple_R1"].hide();
			me["Simple_R2"].hide();
			me["Simple_R3"].hide();
			me["Simple_R4"].hide();
			me["Simple_R5"].show();
			me["Simple_R6"].show();
			me["Simple_R1S"].hide();
			me["Simple_R2S"].hide();
			me["Simple_R3S"].hide();
			me["Simple_R4S"].hide();
			me["Simple_R5S"].show();
			me["Simple_R6S"].show();
			me["Simple_R1_Arrow"].hide();
			me["Simple_R2_Arrow"].hide();
			me["Simple_R3_Arrow"].hide();
			me["Simple_R4_Arrow"].hide();
			me["Simple_R5_Arrow"].show();
			me["Simple_R6_Arrow"].show();
			
			me.fontLeft(default, default, default, default, default, default);
			me.fontLeftS(default, default, default, default, default, default);
			me.fontRight(default, default, default, default, default, default);
			me.fontRightS(default, default, default, default, default, default);
			
			me.fontSizeLeft(normal, normal, normal, normal, normal, normal);
			me.fontSizeRight(normal, normal, normal, normal, normal, normal);
			
			me.colorLeft("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorLeftS("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorLeftArrow("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRight("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRightS("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRightArrow("wht", "wht", "wht", "wht", "wht", "wht");
			
			me["Simple_L1"].setText(" MONITOR");
			me["Simple_L2"].setText(" MONITOR");
			me["Simple_L3"].setText(" MONITOR");
			me["Simple_L4"].setText(" A/C STATUS");
			me["Simple_L1S"].setText(" POSITION");
			me["Simple_L2S"].setText(" IRS");
			me["Simple_L3S"].setText(" GPS");
			me["Simple_R5"].setText("FUNCTION ");
			me["Simple_R6"].setText("FUNCTION ");
			me["Simple_R5S"].setText("PRINT ");
			me["Simple_R6S"].setText("AOC ");
		} else if (page == "DATA2") {
			me["Simple"].show();
			me["Simple_Center"].hide();
			me["INITA"].hide();
			me["Simple_Title"].setText("DATA INDEX");
			me["Simple_PageNum"].setText("2/2");
			me["Simple_PageNum"].show();
			me["ArrowLeft"].show();
			me["ArrowRight"].show();
			
			me["Simple_L1"].show();
			me["Simple_L2"].show();
			me["Simple_L3"].show();
			me["Simple_L4"].show();
			me["Simple_L5"].show();
			me["Simple_L6"].show();
			me["Simple_L1S"].hide();
			me["Simple_L2S"].hide();
			me["Simple_L3S"].hide();
			me["Simple_L4S"].hide();
			me["Simple_L5S"].show();
			me["Simple_L6S"].show();
			me["Simple_L1_Arrow"].show();
			me["Simple_L2_Arrow"].show();
			me["Simple_L3_Arrow"].show();
			me["Simple_L4_Arrow"].show();
			me["Simple_L5_Arrow"].show();
			me["Simple_L6_Arrow"].show();
			me["Simple_R1"].show();
			me["Simple_R2"].show();
			me["Simple_R3"].show();
			me["Simple_R4"].show();
			me["Simple_R5"].hide();
			me["Simple_R6"].hide();
			me["Simple_R1S"].show();
			me["Simple_R2S"].show();
			me["Simple_R3S"].show();
			me["Simple_R4S"].show();
			me["Simple_R5S"].hide();
			me["Simple_R6S"].hide();
			me["Simple_R1_Arrow"].show();
			me["Simple_R2_Arrow"].show();
			me["Simple_R3_Arrow"].show();
			me["Simple_R4_Arrow"].show();
			me["Simple_R5_Arrow"].hide();
			me["Simple_R6_Arrow"].hide();
			
			me.fontLeft(default, default, default, default, default, default);
			me.fontLeftS(default, default, default, default, default, default);
			me.fontRight(default, default, default, default, default, default);
			me.fontRightS(default, default, default, default, default, default);
			
			me.fontSizeLeft(normal, normal, normal, normal, normal, normal);
			me.fontSizeRight(normal, normal, normal, normal, normal, normal);
			
			me.colorLeft("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorLeftS("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorLeftArrow("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRight("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRightS("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRightArrow("wht", "wht", "wht", "wht", "wht", "wht");
			
			me["Simple_L1"].setText(" WAYPOINTS");
			me["Simple_L2"].setText(" NAVAIDS");
			me["Simple_L3"].setText(" RUNWAYS");
			me["Simple_L4"].setText(" ROUTES");
			me["Simple_L5"].setText(" WINDS");
			me["Simple_L6"].setText(" WINDS");
			me["Simple_L5S"].setText(" ACTIVE F-PLN");
			me["Simple_L6S"].setText(" SEC F-PLN");
			me["Simple_R1"].setText("WAYPOINTS ");
			me["Simple_R2"].setText("NAVAIDS ");
			me["Simple_R3"].setText("RUNWAYS ");
			me["Simple_R4"].setText("ROUTES ");
			me["Simple_R1S"].setText("PILOTS ");
			me["Simple_R2S"].setText("PILOTS ");
			me["Simple_R3S"].setText("PILOTS ");
			me["Simple_R4S"].setText("PILOTS ");
		} else if (page == "RADNAV") {
			me["Simple"].show();
			me["Simple_Center"].hide();
			me["INITA"].hide();
			me["Simple_Title"].setText("RADIO NAV");
			me["Simple_PageNum"].setText("X/X");
			me["Simple_PageNum"].hide();
			me["ArrowLeft"].hide();
			me["ArrowRight"].hide();
			
			me["Simple_L1"].show();
			me["Simple_L2"].show();
			me["Simple_L3"].show();
			me["Simple_L4"].show();
			me["Simple_L5"].show();
			me["Simple_L6"].hide();
			me["Simple_L1S"].show();
			me["Simple_L2S"].show();
			me["Simple_L3S"].show();
			me["Simple_L4S"].show();
			me["Simple_L5S"].show();
			me["Simple_L6S"].hide();
			me["Simple_L1_Arrow"].hide();
			me["Simple_L2_Arrow"].hide();
			me["Simple_L3_Arrow"].hide();
			me["Simple_L4_Arrow"].hide();
			me["Simple_L5_Arrow"].hide();
			me["Simple_L6_Arrow"].hide();
			me["Simple_R1"].show();
			me["Simple_R2"].show();
			me["Simple_R3"].show();
			me["Simple_R4"].show();
			me["Simple_R5"].show();
			me["Simple_R6"].hide(); 
			me["Simple_R1S"].show();
			me["Simple_R2S"].show();
			me["Simple_R3S"].show();
			me["Simple_R4S"].show();
			me["Simple_R5S"].show();
			me["Simple_R6S"].hide();
			me["Simple_R1_Arrow"].hide();
			me["Simple_R2_Arrow"].hide();
			me["Simple_R3_Arrow"].hide();
			me["Simple_R4_Arrow"].hide();
			me["Simple_R5_Arrow"].hide();
			me["Simple_R6_Arrow"].hide();
			
			me.fontLeft(default, default, default, default, 0, default);
			me.fontLeftS(default, default, default, default, default, default);
			me.fontRight(default, default, bracket, bracket, 0, default);
			me.fontRightS(default, default, default, default, default, default);
			
			me.fontSizeLeft(0, 0, 0, 0, 0, normal);
			me.fontSizeRight(0, 0, small, small, 0, normal);
			
			me.colorLeft("blu", "blu", "blu", "blu", "blu", "blu");
			me.colorLeftS("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorLeftArrow("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRight("blu", "blu", "blu", "blu", "blu", "blu");
			me.colorRightS("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRightArrow("wht", "wht", "wht", "wht", "wht", "wht");
			
			vor1 = getprop("FMGC/internal/vor1-mcdu");
			vor2 = getprop("FMGC/internal/vor2-mcdu");
			ils = getprop("FMGC/internal/ils1-mcdu");
			adf1 = getprop("FMGC/internal/adf1-mcdu");
			adf2 = getprop("FMGC/internal/adf2-mcdu");
			
			if (getprop("/FMGC/internal/vor1freq-set") == 1) {
				me["Simple_L1"].setFontSize(normal); 
			} else {
				me["Simple_L1"].setFontSize(small); 
			}
			if (getprop("/FMGC/internal/vor1crs-set") == 1) {
				me["Simple_L2"].setFontSize(normal); 
			} else {
				me["Simple_L2"].setFontSize(small); 
			}
			if (getprop("/FMGC/internal/ils1freq-set") == 1) {
				me["Simple_L3"].setFontSize(normal); 
			} else {
				me["Simple_L3"].setFontSize(small); 
			}
			if (getprop("/FMGC/internal/ils1crs-set") == 1) {
				me["Simple_L4"].setFontSize(normal); 
			} else {
				me["Simple_L4"].setFontSize(small); 
			}
			if (getprop("/FMGC/internal/adf1freq-set") == 1) {
				me["Simple_L5"].setFont(default); 
				me["Simple_L5"].setFontSize(normal); 
				me["Simple_L5"].setText(sprintf("%3.0f", adf1));
			} else {
				me["Simple_L5"].setFont(bracket); 
				me["Simple_L5"].setFontSize(small); 
				me["Simple_L5"].setText("[    ]/[     . ]");
			}
			
			if (getprop("/FMGC/internal/vor2freq-set") == 1) {
				me["Simple_R1"].setFontSize(normal); 
			} else {
				me["Simple_R1"].setFontSize(small); 
			}
			if (getprop("/FMGC/internal/vor2crs-set") == 1) {
				me["Simple_R2"].setFontSize(normal); 
			} else {
				me["Simple_R2"].setFontSize(small); 
			}
			if (getprop("/FMGC/internal/adf2freq-set") == 1) {
				me["Simple_R5"].setFont(default); 
				me["Simple_R5"].setFontSize(normal); 
				me["Simple_R5"].setText(sprintf("%3.0f", adf2));
			} else {
				me["Simple_R5"].setFont(bracket); 
				me["Simple_R5"].setFontSize(small); 
				me["Simple_R5"].setText("[     . ]/[    ]");
			}
			
			me["Simple_L1"].setText(" " ~ vor1);
			me["Simple_L2"].setText(sprintf("%3.0f", getprop("/instrumentation/nav[2]/radials/selected-deg")));
			me["Simple_L3"].setText(" " ~ ils);
			me["Simple_L4"].setText(sprintf("%3.0f", getprop("/instrumentation/nav[0]/radials/selected-deg")));
			me["Simple_L1S"].setText("VOR1/FREQ");
			me["Simple_L2S"].setText("CRS");
			me["Simple_L3S"].setText("ILS /FREQ");
			me["Simple_L4S"].setText("CRS");
			me["Simple_L5S"].setText("ADF1/FREQ");
			me["Simple_R1"].setText(" " ~ vor2);
			me["Simple_R2"].setText(sprintf("%3.0f", getprop("/instrumentation/nav[3]/radials/selected-deg")));
			me["Simple_R3"].setText("[   ]/[    ]");
			me["Simple_R4"].setText("-.-   [   ]");
			me["Simple_R1S"].setText("FREQ/VOR2");
			me["Simple_R2S"].setText("CRS");
			me["Simple_R3S"].setText("CHAN/ MLS");
			me["Simple_R4S"].setText("SLOPE   CRS");
			me["Simple_R5S"].setText("FREQ/ADF2");
		} else if (page == "INITA") {
			me["Simple"].show();
			me["Simple_Center"].hide();
			me["INITA"].show();
			me["Simple_Title"].setText("INIT");
			me["Simple_PageNum"].setText("X/X");
			me["Simple_PageNum"].hide();
			me["ArrowLeft"].show();
			me["ArrowRight"].show();
			
			me["Simple_L2"].show();
			me["Simple_L4"].show();
			me["Simple_L6"].show();
			me["Simple_L1S"].show();
			me["Simple_L2S"].show();
			me["Simple_L3S"].show();
			me["Simple_L4S"].show();
			me["Simple_L5S"].show();
			me["Simple_L6S"].show();
			me["Simple_L1_Arrow"].hide();
			me["Simple_L2_Arrow"].hide();
			me["Simple_L3_Arrow"].hide();
			me["Simple_L4_Arrow"].hide();
			me["Simple_L5_Arrow"].hide();
			me["Simple_L6_Arrow"].hide();
			me["Simple_R4"].show();
			me["Simple_R5"].show();
			me["Simple_R6"].show();
			me["Simple_R1S"].show();
			me["Simple_R3S"].hide();
			me["Simple_R4S"].show();
			me["Simple_R5S"].hide();
			me["Simple_R6S"].show();
			me["Simple_R1_Arrow"].hide();
			me["Simple_R2_Arrow"].hide();
			me["Simple_R3_Arrow"].hide();
			me["Simple_R4_Arrow"].hide();
			me["Simple_R5_Arrow"].show();
			me["Simple_R6_Arrow"].hide();
			
			me.fontLeft(default, default, default, default, default, default);
			me.fontLeftS(default, default, default, default, default, default);
			me.fontRight(default, default, default, default, default, default);
			me.fontRightS(default, default, default, default, default, default);
			
			me.fontSizeLeft(normal, normal, normal, normal, normal, normal);
			me.fontSizeRight(normal, normal, normal, normal, normal, 0);
			
			me.colorLeft("blu", "wht", "blu", "blu", "ack", "ack");
			me.colorLeftS("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorLeftArrow("wht", "wht", "wht", "wht", "wht", "wht");
			me.colorRight("blu", "amb", "amb", "blu", "wht", "blu");
			me.colorRightS("wht", "amb", "wht", "wht", "wht", "wht");
			me.colorRightArrow("wht", "wht", "wht", "wht", "wht", "wht");
			
			if (getprop("/MCDUC/flight-num-set") == 1) {
				me["INITA_FltNbr"].hide();
				me["Simple_L3"].show();
			} else {
				me["INITA_FltNbr"].show();
				me["Simple_L3"].hide();
			}
			if (getprop("/FMGC/internal/tofrom-set") != 1 and getprop("/FMGC/internal/cost-index-set") != 1) {
				me["INITA_CostIndex"].hide();
				me["Simple_L5"].setColor(1,1,1);
				me["Simple_L5"].show();
				me["Simple_L5"].setText("---");
			} else if (getprop("/FMGC/internal/cost-index-set") == 1) {
				me["INITA_CostIndex"].hide();
				me["Simple_L5"].setColor(0.0901,0.6039,0.7176);
				me["Simple_L5"].show();
				me["Simple_L5"].setText(sprintf("%s", getprop("/FMGC/internal/cost-index")));
			} else {
				me["INITA_CostIndex"].show();
				me["Simple_L5"].hide();
			}
			if (getprop("/FMGC/internal/tofrom-set") != 1 and getprop("/FMGC/internal/cruise-lvl-set") != 1) {
				me["INITA_CruiseFLTemp"].hide();
				me["Simple_L6"].setColor(1,1,1);
				me["Simple_L6"].setText("-----/---g");
			} else if (getprop("/FMGC/internal/cruise-lvl-set") == 1) {
				me["INITA_CruiseFLTemp"].hide();
				me["Simple_L6"].setColor(0.0901,0.6039,0.7176);
				me["Simple_L6"].setText(sprintf("%s", "FL" ~ getprop("/FMGC/internal/cruise-fl") ~ "/---g"));
			} else {
				me["INITA_CruiseFLTemp"].show();
				me["Simple_L6"].setColor(0.7333,0.3803,0);
				me["Simple_L6"].setText("         g");
			}
			if (getprop("/FMGC/internal/tofrom-set") == 1) {
				me["INITA_CoRoute"].hide();
				me["INITA_FromTo"].hide();
				me["Simple_L1"].show();
				me["Simple_L2"].setColor(0.0901,0.6039,0.7176);
				me["Simple_L2"].setText("NONE");
				me["Simple_R1"].show();
				me["Simple_R2"].hide();
				me["Simple_R2S"].hide();
				me["INITA_InitRequest"].hide();
			} else {
				me["INITA_CoRoute"].show();
				me["INITA_FromTo"].show();
				me["Simple_L1"].hide();
				me["Simple_L2"].setColor(1,1,1);
				me["Simple_L2"].setText("----/----------");
				me["Simple_R1"].hide();
				me["Simple_R2"].show();
				me["Simple_R2S"].show();
				me["INITA_InitRequest"].show();
			}
			if (getprop("/FMGC/internal/tofrom-set") == 1 and getprop("/controls/adirs/mcducbtn") != 1) {
				me["INITA_AlignIRS"].show();
				me["Simple_R3"].show();
			} else {
				me["INITA_AlignIRS"].hide();
				me["Simple_R3"].hide();
			}
			if (getprop("/FMGC/internal/tropo-set") == 1) {
				me["Simple_R6"].setFontSize(normal); 
			} else {
				me["Simple_R6"].setFontSize(small); 
			}
			
			me["Simple_L1S"].setText(" CO RTE");
			me["Simple_L2S"].setText("ALTN/CO RTE");
			me["Simple_L3S"].setText("FLT NBR");
			me["Simple_L4S"].setText("LAT");
			me["Simple_L5S"].setText("COST INDEX");
			me["Simple_L6S"].setText("CRZ FL/TEMP");
			me["Simple_L1"].setText("NONE");
			me["Simple_L3"].setText(sprintf("%s", getprop("/MCDUC/flight-num")));
			me["Simple_L4"].setText("----.-");
			me["Simple_R1S"].setText("FROM/TO   ");
			me["Simple_R2S"].setText("INIT ");
			me["Simple_R4S"].setText("LONG");
			me["Simple_R6S"].setText("TROPO");
			me["Simple_R1"].setText(sprintf("%s", getprop("/FMGC/internal/dep-arpt") ~ "/" ~ getprop("/FMGC/internal/arr-arpt")));
			me["Simple_R2"].setText("REQUEST ");
			me["Simple_R3"].setText("ALIGN IRS ");
			me["Simple_R4"].setText("-----.--");
			me["Simple_R5"].setText("WIND ");
			me["Simple_R6"].setText(sprintf("%5.0f", getprop("/FMGC/internal/tropo")));
		} else {
			me["Simple"].hide();
			me["ArrowLeft"].hide();
			me["ArrowRight"].hide();
		}
		
		me["Scratchpad"].setText(sprintf("%s", getprop("/MCDU[" ~ i ~ "]/scratchpad")));
	},
	# ack = ignore, wht = white, grn = green, blu = blue, amb = amber, yel = yellow
	colorLeft: func(a, b, c, d, e, f) {
		if (a != "ack") {
			me["Simple_L1"].setColor(getprop("/MCDUC/colors/" ~ a ~ "/r"), getprop("/MCDUC/colors/" ~ a ~ "/g"), getprop("/MCDUC/colors/" ~ a ~ "/b"));
		}
		if (b != "ack") {
			me["Simple_L2"].setColor(getprop("/MCDUC/colors/" ~ b ~ "/r"), getprop("/MCDUC/colors/" ~ b ~ "/g"), getprop("/MCDUC/colors/" ~ b ~ "/b"));
		}
		if (c != "ack") {
			me["Simple_L3"].setColor(getprop("/MCDUC/colors/" ~ c ~ "/r"), getprop("/MCDUC/colors/" ~ c ~ "/g"), getprop("/MCDUC/colors/" ~ c ~ "/b"));
		}
		if (d != "ack") {
			me["Simple_L4"].setColor(getprop("/MCDUC/colors/" ~ d ~ "/r"), getprop("/MCDUC/colors/" ~ d ~ "/g"), getprop("/MCDUC/colors/" ~ d ~ "/b"));
		}
		if (e != "ack") {
			me["Simple_L5"].setColor(getprop("/MCDUC/colors/" ~ e ~ "/r"), getprop("/MCDUC/colors/" ~ e ~ "/g"), getprop("/MCDUC/colors/" ~ e ~ "/b"));
		}
		if (f != "ack") {
			me["Simple_L6"].setColor(getprop("/MCDUC/colors/" ~ f ~ "/r"), getprop("/MCDUC/colors/" ~ f ~ "/g"), getprop("/MCDUC/colors/" ~ f ~ "/b"));
		}
	},
	colorLeftS: func(a, b, c, d, e, f) {
		if (a != "ack") {
			me["Simple_L1S"].setColor(getprop("/MCDUC/colors/" ~ a ~ "/r"), getprop("/MCDUC/colors/" ~ a ~ "/g"), getprop("/MCDUC/colors/" ~ a ~ "/b"));
		}
		if (b != "ack") {
			me["Simple_L2S"].setColor(getprop("/MCDUC/colors/" ~ b ~ "/r"), getprop("/MCDUC/colors/" ~ b ~ "/g"), getprop("/MCDUC/colors/" ~ b ~ "/b"));
		}
		if (c != "ack") {
			me["Simple_L3S"].setColor(getprop("/MCDUC/colors/" ~ c ~ "/r"), getprop("/MCDUC/colors/" ~ c ~ "/g"), getprop("/MCDUC/colors/" ~ c ~ "/b"));
		}
		if (d != "ack") {
			me["Simple_L4S"].setColor(getprop("/MCDUC/colors/" ~ d ~ "/r"), getprop("/MCDUC/colors/" ~ d ~ "/g"), getprop("/MCDUC/colors/" ~ d ~ "/b"));
		}
		if (e != "ack") {
			me["Simple_L5S"].setColor(getprop("/MCDUC/colors/" ~ e ~ "/r"), getprop("/MCDUC/colors/" ~ e ~ "/g"), getprop("/MCDUC/colors/" ~ e ~ "/b"));
		}
		if (f != "ack") {
			me["Simple_L6S"].setColor(getprop("/MCDUC/colors/" ~ f ~ "/r"), getprop("/MCDUC/colors/" ~ f ~ "/g"), getprop("/MCDUC/colors/" ~ f ~ "/b"));
		}
	},
	colorLeftArrow: func(a, b, c, d, e, f) {
		if (a != "ack") {
			me["Simple_L1_Arrow"].setColor(getprop("/MCDUC/colors/" ~ a ~ "/r"), getprop("/MCDUC/colors/" ~ a ~ "/g"), getprop("/MCDUC/colors/" ~ a ~ "/b"));
		}
		if (b != "ack") {
			me["Simple_L2_Arrow"].setColor(getprop("/MCDUC/colors/" ~ b ~ "/r"), getprop("/MCDUC/colors/" ~ b ~ "/g"), getprop("/MCDUC/colors/" ~ b ~ "/b"));
		}
		if (c != "ack") {
			me["Simple_L3_Arrow"].setColor(getprop("/MCDUC/colors/" ~ c ~ "/r"), getprop("/MCDUC/colors/" ~ c ~ "/g"), getprop("/MCDUC/colors/" ~ c ~ "/b"));
		}
		if (d != "ack") {
			me["Simple_L4_Arrow"].setColor(getprop("/MCDUC/colors/" ~ d ~ "/r"), getprop("/MCDUC/colors/" ~ d ~ "/g"), getprop("/MCDUC/colors/" ~ d ~ "/b"));
		}
		if (e != "ack") {
			me["Simple_L5_Arrow"].setColor(getprop("/MCDUC/colors/" ~ e ~ "/r"), getprop("/MCDUC/colors/" ~ e ~ "/g"), getprop("/MCDUC/colors/" ~ e ~ "/b"));
		}
		if (f != "ack") {
			me["Simple_L6_Arrow"].setColor(getprop("/MCDUC/colors/" ~ f ~ "/r"), getprop("/MCDUC/colors/" ~ f ~ "/g"), getprop("/MCDUC/colors/" ~ f ~ "/b"));
		}
	},
	colorRight: func(a, b, c, d, e, f) {
		if (a != "ack") {
			me["Simple_R1"].setColor(getprop("/MCDUC/colors/" ~ a ~ "/r"), getprop("/MCDUC/colors/" ~ a ~ "/g"), getprop("/MCDUC/colors/" ~ a ~ "/b"));
		}
		if (b != "ack") {
			me["Simple_R2"].setColor(getprop("/MCDUC/colors/" ~ b ~ "/r"), getprop("/MCDUC/colors/" ~ b ~ "/g"), getprop("/MCDUC/colors/" ~ b ~ "/b"));
		}
		if (c != "ack") {
			me["Simple_R3"].setColor(getprop("/MCDUC/colors/" ~ c ~ "/r"), getprop("/MCDUC/colors/" ~ c ~ "/g"), getprop("/MCDUC/colors/" ~ c ~ "/b"));
		}
		if (d != "ack") {
			me["Simple_R4"].setColor(getprop("/MCDUC/colors/" ~ d ~ "/r"), getprop("/MCDUC/colors/" ~ d ~ "/g"), getprop("/MCDUC/colors/" ~ d ~ "/b"));
		}
		if (e != "ack") {
			me["Simple_R5"].setColor(getprop("/MCDUC/colors/" ~ e ~ "/r"), getprop("/MCDUC/colors/" ~ e ~ "/g"), getprop("/MCDUC/colors/" ~ e ~ "/b"));
		}
		if (f != "ack") {
			me["Simple_R6"].setColor(getprop("/MCDUC/colors/" ~ f ~ "/r"), getprop("/MCDUC/colors/" ~ f ~ "/g"), getprop("/MCDUC/colors/" ~ f ~ "/b"));
		}
	},
	colorRightS: func(a, b, c, d, e, f) {
		if (a != "ack") {
			me["Simple_R1S"].setColor(getprop("/MCDUC/colors/" ~ a ~ "/r"), getprop("/MCDUC/colors/" ~ a ~ "/g"), getprop("/MCDUC/colors/" ~ a ~ "/b"));
		}
		if (b != "ack") {
			me["Simple_R2S"].setColor(getprop("/MCDUC/colors/" ~ b ~ "/r"), getprop("/MCDUC/colors/" ~ b ~ "/g"), getprop("/MCDUC/colors/" ~ b ~ "/b"));
		}
		if (c != "ack") {
			me["Simple_R3S"].setColor(getprop("/MCDUC/colors/" ~ c ~ "/r"), getprop("/MCDUC/colors/" ~ c ~ "/g"), getprop("/MCDUC/colors/" ~ c ~ "/b"));
		}
		if (d != "ack") {
			me["Simple_R4S"].setColor(getprop("/MCDUC/colors/" ~ d ~ "/r"), getprop("/MCDUC/colors/" ~ d ~ "/g"), getprop("/MCDUC/colors/" ~ d ~ "/b"));
		}
		if (e != "ack") {
			me["Simple_R5S"].setColor(getprop("/MCDUC/colors/" ~ e ~ "/r"), getprop("/MCDUC/colors/" ~ e ~ "/g"), getprop("/MCDUC/colors/" ~ e ~ "/b"));
		}
		if (f != "ack") {
			me["Simple_R6S"].setColor(getprop("/MCDUC/colors/" ~ f ~ "/r"), getprop("/MCDUC/colors/" ~ f ~ "/g"), getprop("/MCDUC/colors/" ~ f ~ "/b"));
		}
	},
	colorRightArrow: func(a, b, c, d, e, f) {
		if (a != "ack") {
			me["Simple_R1_Arrow"].setColor(getprop("/MCDUC/colors/" ~ a ~ "/r"), getprop("/MCDUC/colors/" ~ a ~ "/g"), getprop("/MCDUC/colors/" ~ a ~ "/b"));
		}
		if (b != "ack") {
			me["Simple_R2_Arrow"].setColor(getprop("/MCDUC/colors/" ~ b ~ "/r"), getprop("/MCDUC/colors/" ~ b ~ "/g"), getprop("/MCDUC/colors/" ~ b ~ "/b"));
		}
		if (c != "ack") {
			me["Simple_R3_Arrow"].setColor(getprop("/MCDUC/colors/" ~ c ~ "/r"), getprop("/MCDUC/colors/" ~ c ~ "/g"), getprop("/MCDUC/colors/" ~ c ~ "/b"));
		}
		if (d != "ack") {
			me["Simple_R4_Arrow"].setColor(getprop("/MCDUC/colors/" ~ d ~ "/r"), getprop("/MCDUC/colors/" ~ d ~ "/g"), getprop("/MCDUC/colors/" ~ d ~ "/b"));
		}
		if (e != "ack") {
			me["Simple_R5_Arrow"].setColor(getprop("/MCDUC/colors/" ~ e ~ "/r"), getprop("/MCDUC/colors/" ~ e ~ "/g"), getprop("/MCDUC/colors/" ~ e ~ "/b"));
		}
		if (f != "ack") {
			me["Simple_R6_Arrow"].setColor(getprop("/MCDUC/colors/" ~ f ~ "/r"), getprop("/MCDUC/colors/" ~ f ~ "/g"), getprop("/MCDUC/colors/" ~ f ~ "/b"));
		}
	},
	# 0 = ignore
	fontLeft: func (a, b, c, d, e, f) {
		if (a != 0) {
			me["Simple_L1"].setFont(a); 
		}
		if (b != 0) {
			me["Simple_L2"].setFont(b); 
		}
		if (c != 0) {
			me["Simple_L3"].setFont(c); 
		}
		if (d != 0) {
			me["Simple_L4"].setFont(d); 
		}
		if (e != 0) {
			me["Simple_L5"].setFont(e); 
		}
		if (f != 0) {
			me["Simple_L6"].setFont(f); 
		}
	},
	fontLeftS: func (a, b, c, d, e, f) {
		if (a != 0) {
			me["Simple_L1S"].setFont(a); 
		}
		if (b != 0) {
			me["Simple_L2S"].setFont(b); 
		}
		if (c != 0) {
			me["Simple_L3S"].setFont(c); 
		}
		if (d != 0) {
			me["Simple_L4S"].setFont(d); 
		}
		if (e != 0) {
			me["Simple_L5S"].setFont(e); 
		}
		if (f != 0) {
			me["Simple_L6S"].setFont(f); 
		}
	},
	fontRight: func (a, b, c, d, e, f) {
		if (a != 0) {
			me["Simple_R1"].setFont(a); 
		}
		if (b != 0) {
			me["Simple_R2"].setFont(b); 
		}
		if (c != 0) {
			me["Simple_R3"].setFont(c); 
		}
		if (d != 0) {
			me["Simple_R4"].setFont(d); 
		}
		if (e != 0) {
			me["Simple_R5"].setFont(e); 
		}
		if (f != 0) {
			me["Simple_R6"].setFont(f); 
		}
	},
	fontRightS: func (a, b, c, d, e, f) {
		if (a != 0) {
			me["Simple_R1S"].setFont(a); 
		}
		if (b != 0) {
			me["Simple_R2S"].setFont(b); 
		}
		if (c != 0) {
			me["Simple_R3S"].setFont(c); 
		}
		if (d != 0) {
			me["Simple_R4S"].setFont(d); 
		}
		if (e != 0) {
			me["Simple_R5S"].setFont(e); 
		}
		if (f != 0) {
			me["Simple_R6S"].setFont(f); 
		}
	},
	fontSizeLeft: func (a, b, c, d, e, f) {
		if (a != 0) {
			me["Simple_L1"].setFontSize(a); 
		}
		if (b != "ack") {
			me["Simple_L2"].setFontSize(b); 
		}
		if (c != "ack") {
			me["Simple_L3"].setFontSize(c); 
		}
		if (d != "ack") {
			me["Simple_L4"].setFontSize(d); 
		}
		if (e != "ack") {
			me["Simple_L5"].setFontSize(e); 
		}
		if (f != "ack") {
			me["Simple_L6"].setFontSize(f); 
		}
	},
	fontSizeRight: func (a, b, c, d, e, f) {
		if (a != 0) {
			me["Simple_R1"].setFontSize(a); 
		}
		if (b != 0) {
			me["Simple_R2"].setFontSize(b); 
		}
		if (c != 0) {
			me["Simple_R3"].setFontSize(c); 
		}
		if (d != 0) {
			me["Simple_R4"].setFontSize(d); 
		}
		if (e != 0) {
			me["Simple_R5"].setFontSize(e); 
		}
		if (f != 0) {
			me["Simple_R6"].setFontSize(f); 
		}
	},
};

var canvas_MCDU_1 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_MCDU_1, canvas_MCDU_base]};
		m.init(canvas_group, file);

		return m;
	},
	update: func() {
		me.updateCommon(0);
	},
};

var canvas_MCDU_2 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_MCDU_2, canvas_MCDU_base]};
		m.init(canvas_group, file);

		return m;
	},
	update: func() {
		me.updateCommon(1);
	},
};

setlistener("sim/signals/fdm-initialized", func {
	MCDU1_display = canvas.new({
		"name": "MCDU1",
		"size": [1024, 864],
		"view": [1024, 864],
		"mipmapping": 1
	});
	MCDU2_display = canvas.new({
		"name": "MCDU2",
		"size": [1024, 864],
		"view": [1024, 864],
		"mipmapping": 1
	});
	MCDU1_display.addPlacement({"node": "mcdu1.screen"});
	MCDU2_display.addPlacement({"node": "mcdu2.screen"});
	var group_MCDU1 = MCDU1_display.createGroup();
	var group_MCDU2 = MCDU2_display.createGroup();

	MCDU_1 = canvas_MCDU_1.new(group_MCDU1, "Aircraft/IDG-A32X/Models/Instruments/MCDU/res/mcdu.svg");
	MCDU_2 = canvas_MCDU_2.new(group_MCDU2, "Aircraft/IDG-A32X/Models/Instruments/MCDU/res/mcdu.svg");
	
	MCDU_update.start();
});

var MCDU_update = maketimer(0.125, func {
	canvas_MCDU_base.update();
});

var showMCDU1 = func {
	var dlg = canvas.Window.new([512, 432], "dialog").set("resize", 1);
	dlg.setCanvas(MCDU1_display);
}

var showMCDU2 = func {
	var dlg = canvas.Window.new([512, 432], "dialog").set("resize", 1);
	dlg.setCanvas(MCDU2_display);
}
