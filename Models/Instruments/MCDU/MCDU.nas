# A3XX MCDU
# Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

# MCDU Colors are different from Main Displays
# White: 1,1,1
# Blue: 0.0862,0.5176,0.6470
# Green: 0.0509,0.7529,0.2941

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
		return ["Simple","Scratchpad","Simple_Title","Simple_PageNum","ArrowLeft","ArrowRight","Simple_L1","Simple_L2","Simple_L3","Simple_L4","Simple_L5","Simple_L6","Simple_L1S","Simple_L2S","Simple_L3S","Simple_L4S","Simple_L5S","Simple_L6S","Simple_L1_Arrow",
		"Simple_L2_Arrow","Simple_L3_Arrow","Simple_L4_Arrow","Simple_L5_Arrow","Simple_L6_Arrow","Simple_R1","Simple_R2","Simple_R3","Simple_R4","Simple_R5","Simple_R6","Simple_R1S","Simple_R2S","Simple_R3S","Simple_R4S","Simple_R5S","Simple_R6S",
		"Simple_R1_Arrow","Simple_R2_Arrow","Simple_R3_Arrow","Simple_R4_Arrow","Simple_R5_Arrow","Simple_R6_Arrow"];
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
			
			me["Simple_L1"].setFont(default);
			me["Simple_L2"].setFont(default);
			me["Simple_L3"].setFont(default);
			me["Simple_L4"].setFont(default);
			me["Simple_L5"].setFont(default);
			me["Simple_L6"].setFont(default);
			me["Simple_L1S"].setFont(default);
			me["Simple_L2S"].setFont(default);
			me["Simple_L3S"].setFont(default);
			me["Simple_L4S"].setFont(default);
			me["Simple_L5S"].setFont(default);
			me["Simple_L6S"].setFont(default);
			me["Simple_R1"].setFont(default);
			me["Simple_R2"].setFont(default);
			me["Simple_R3"].setFont(default);
			me["Simple_R4"].setFont(default);
			me["Simple_R5"].setFont(default);
			me["Simple_R6"].setFont(default);
			me["Simple_R1S"].setFont(default);
			me["Simple_R2S"].setFont(default);
			me["Simple_R3S"].setFont(default);
			me["Simple_R4S"].setFont(default);
			me["Simple_R5S"].setFont(default);
			me["Simple_R6S"].setFont(default);
			
			me["Simple_L1"].setFontSize(normal);
			me["Simple_L2"].setFontSize(normal);
			me["Simple_L3"].setFontSize(normal);
			me["Simple_L4"].setFontSize(normal);
			me["Simple_L5"].setFontSize(normal);
			me["Simple_L6"].setFontSize(normal);
			me["Simple_R1"].setFontSize(normal);
			me["Simple_R2"].setFontSize(normal);
			me["Simple_R3"].setFontSize(normal);
			me["Simple_R4"].setFontSize(normal);
			me["Simple_R5"].setFontSize(normal);
			me["Simple_R6"].setFontSize(normal);
			
			me["Simple_L2"].setColor(1,1,1);
			me["Simple_L3"].setColor(1,1,1);
			me["Simple_L4"].setColor(1,1,1);
			me["Simple_L5"].setColor(1,1,1);
			me["Simple_L6"].setColor(1,1,1);
			me["Simple_L1S"].setColor(1,1,1);
			me["Simple_L2S"].setColor(1,1,1);
			me["Simple_L3S"].setColor(1,1,1);
			me["Simple_L4S"].setColor(1,1,1);
			me["Simple_L5S"].setColor(1,1,1);
			me["Simple_L6S"].setColor(1,1,1);
			me["Simple_L1_Arrow"].setColor(1,1,1);
			me["Simple_L2_Arrow"].setColor(1,1,1);
			me["Simple_L3_Arrow"].setColor(1,1,1);
			me["Simple_L4_Arrow"].setColor(1,1,1);
			me["Simple_L5_Arrow"].setColor(1,1,1);
			me["Simple_L6_Arrow"].setColor(1,1,1);
			me["Simple_R1"].setColor(1,1,1);
			me["Simple_R2"].setColor(1,1,1);
			me["Simple_R3"].setColor(1,1,1);
			me["Simple_R4"].setColor(1,1,1);
			me["Simple_R5"].setColor(1,1,1);
			me["Simple_R6"].setColor(1,1,1);
			me["Simple_R1S"].setColor(1,1,1);
			me["Simple_R2S"].setColor(1,1,1);
			me["Simple_R3S"].setColor(1,1,1);
			me["Simple_R4S"].setColor(1,1,1);
			me["Simple_R5S"].setColor(1,1,1);
			me["Simple_R6S"].setColor(1,1,1);
			me["Simple_R1_Arrow"].setColor(1,1,1);
			me["Simple_R2_Arrow"].setColor(1,1,1);
			me["Simple_R3_Arrow"].setColor(1,1,1);
			me["Simple_R4_Arrow"].setColor(1,1,1);
			me["Simple_R5_Arrow"].setColor(1,1,1);
			me["Simple_R6_Arrow"].setColor(1,1,1);
			
			if (getprop("/MCDU[" ~ i ~ "]/active") == 0) {
				me["Simple_L1"].setText(" FMGC");
				me["Simple_L1"].setColor(1,1,1);
			} else if (getprop("/MCDU[" ~ i ~ "]/active") == 1) {
				me["Simple_L1"].setText(" FMGC(SEL)");
				me["Simple_L1"].setColor(0.0862,0.5176,0.6470);
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
			
			me["Simple_L1"].setFont(default);
			me["Simple_L2"].setFont(default);
			me["Simple_L3"].setFont(default);
			me["Simple_L4"].setFont(default);
			me["Simple_L5"].setFont(bracket);
			me["Simple_L6"].setFont(default);
			me["Simple_L1S"].setFont(default);
			me["Simple_L2S"].setFont(default);
			me["Simple_L3S"].setFont(default);
			me["Simple_L4S"].setFont(default);
			me["Simple_L5S"].setFont(default);
			me["Simple_L6S"].setFont(default);
			me["Simple_R1"].setFont(default);
			me["Simple_R2"].setFont(default);
			me["Simple_R3"].setFont(default);
			me["Simple_R4"].setFont(default);
			me["Simple_R5"].setFont(default);
			me["Simple_R6"].setFont(default);
			me["Simple_R1S"].setFont(default);
			me["Simple_R2S"].setFont(default);
			me["Simple_R3S"].setFont(default);
			me["Simple_R4S"].setFont(default);
			me["Simple_R5S"].setFont(default);
			me["Simple_R6S"].setFont(default);
			
			me["Simple_L1"].setFontSize(normal);
			me["Simple_L2"].setFontSize(normal);
			me["Simple_L3"].setFontSize(normal);
			me["Simple_L4"].setFontSize(normal);
			me["Simple_L5"].setFontSize(small);
			me["Simple_L6"].setFontSize(normal);
			me["Simple_R1"].setFontSize(normal);
			me["Simple_R2"].setFontSize(normal);
			me["Simple_R3"].setFontSize(normal);
			me["Simple_R4"].setFontSize(normal);
			me["Simple_R5"].setFontSize(normal);
			me["Simple_R6"].setFontSize(normal);
			
			me["Simple_L1"].setColor(0.0509,0.7529,0.2941);
			me["Simple_L2"].setColor(0.0862,0.5176,0.6470);
			me["Simple_L3"].setColor(0.0862,0.5176,0.6470);
			me["Simple_L4"].setColor(1,1,1);
			me["Simple_L5"].setColor(0.0862,0.5176,0.6470);
			me["Simple_L6"].setColor(0.0509,0.7529,0.2941);
			me["Simple_L1S"].setColor(1,1,1);
			me["Simple_L2S"].setColor(1,1,1);
			me["Simple_L3S"].setColor(1,1,1);
			me["Simple_L4S"].setColor(1,1,1);
			me["Simple_L5S"].setColor(1,1,1);
			me["Simple_L6S"].setColor(1,1,1);
			me["Simple_L1_Arrow"].setColor(1,1,1);
			me["Simple_L2_Arrow"].setColor(0.0862,0.5176,0.6470);
			me["Simple_L3_Arrow"].setColor(0.0862,0.5176,0.6470);
			me["Simple_L4_Arrow"].setColor(1,1,1);
			me["Simple_L5_Arrow"].setColor(1,1,1);
			me["Simple_L6_Arrow"].setColor(1,1,1);
			me["Simple_R1"].setColor(1,1,1);
			me["Simple_R2"].setColor(0.0509,0.7529,0.2941);
			me["Simple_R3"].setColor(1,1,1);
			me["Simple_R4"].setColor(1,1,1);
			me["Simple_R5"].setColor(1,1,1);
			me["Simple_R6"].setColor(1,1,1);
			me["Simple_R1S"].setColor(1,1,1);
			me["Simple_R2S"].setColor(1,1,1);
			me["Simple_R3S"].setColor(1,1,1);
			me["Simple_R4S"].setColor(1,1,1);
			me["Simple_R5S"].setColor(1,1,1);
			me["Simple_R6S"].setColor(1,1,1);
			me["Simple_R1_Arrow"].setColor(1,1,1);
			me["Simple_R2_Arrow"].setColor(1,1,1);
			me["Simple_R3_Arrow"].setColor(1,1,1);
			me["Simple_R4_Arrow"].setColor(1,1,1);
			me["Simple_R5_Arrow"].setColor(1,1,1);
			me["Simple_R6_Arrow"].setColor(1,1,1);
			
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
			
			me["Simple_L1"].setFont(default);
			me["Simple_L2"].setFont(default);
			me["Simple_L3"].setFont(default);
			me["Simple_L4"].setFont(default);
			me["Simple_L5"].setFont(default);
			me["Simple_L6"].setFont(default);
			me["Simple_L1S"].setFont(default);
			me["Simple_L2S"].setFont(default);
			me["Simple_L3S"].setFont(default);
			me["Simple_L4S"].setFont(default);
			me["Simple_L5S"].setFont(default);
			me["Simple_L6S"].setFont(default);
			me["Simple_R1"].setFont(default);
			me["Simple_R2"].setFont(default);
			me["Simple_R3"].setFont(default);
			me["Simple_R4"].setFont(default);
			me["Simple_R5"].setFont(default);
			me["Simple_R6"].setFont(default);
			me["Simple_R1S"].setFont(default);
			me["Simple_R2S"].setFont(default);
			me["Simple_R3S"].setFont(default);
			me["Simple_R4S"].setFont(default);
			me["Simple_R5S"].setFont(default);
			me["Simple_R6S"].setFont(default);
			
			me["Simple_L1"].setFontSize(normal);
			me["Simple_L2"].setFontSize(normal);
			me["Simple_L3"].setFontSize(normal);
			me["Simple_L4"].setFontSize(normal);
			me["Simple_L5"].setFontSize(normal);
			me["Simple_L6"].setFontSize(normal);
			me["Simple_R1"].setFontSize(normal);
			me["Simple_R2"].setFontSize(normal);
			me["Simple_R3"].setFontSize(normal);
			me["Simple_R4"].setFontSize(normal);
			me["Simple_R5"].setFontSize(normal);
			me["Simple_R6"].setFontSize(normal);
			
			me["Simple_L1"].setColor(1,1,1);
			me["Simple_L2"].setColor(1,1,1);
			me["Simple_L3"].setColor(1,1,1);
			me["Simple_L4"].setColor(1,1,1);
			me["Simple_L5"].setColor(1,1,1);
			me["Simple_L6"].setColor(1,1,1);
			me["Simple_L1S"].setColor(1,1,1);
			me["Simple_L2S"].setColor(1,1,1);
			me["Simple_L3S"].setColor(1,1,1);
			me["Simple_L4S"].setColor(1,1,1);
			me["Simple_L5S"].setColor(1,1,1);
			me["Simple_L6S"].setColor(1,1,1);
			me["Simple_L1_Arrow"].setColor(1,1,1);
			me["Simple_L2_Arrow"].setColor(1,1,1);
			me["Simple_L3_Arrow"].setColor(1,1,1);
			me["Simple_L4_Arrow"].setColor(1,1,1);
			me["Simple_L5_Arrow"].setColor(1,1,1);
			me["Simple_L6_Arrow"].setColor(1,1,1);
			me["Simple_R1"].setColor(1,1,1);
			me["Simple_R2"].setColor(1,1,1);
			me["Simple_R3"].setColor(1,1,1);
			me["Simple_R4"].setColor(1,1,1);
			me["Simple_R5"].setColor(1,1,1);
			me["Simple_R6"].setColor(1,1,1);
			me["Simple_R1S"].setColor(1,1,1);
			me["Simple_R2S"].setColor(1,1,1);
			me["Simple_R3S"].setColor(1,1,1);
			me["Simple_R4S"].setColor(1,1,1);
			me["Simple_R5S"].setColor(1,1,1);
			me["Simple_R6S"].setColor(1,1,1);
			me["Simple_R1_Arrow"].setColor(1,1,1);
			me["Simple_R2_Arrow"].setColor(1,1,1);
			me["Simple_R3_Arrow"].setColor(1,1,1);
			me["Simple_R4_Arrow"].setColor(1,1,1);
			me["Simple_R5_Arrow"].setColor(1,1,1);
			me["Simple_R6_Arrow"].setColor(1,1,1);
			
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
			
			me["Simple_L1"].setFont(default);
			me["Simple_L2"].setFont(default);
			me["Simple_L3"].setFont(default);
			me["Simple_L4"].setFont(default);
			me["Simple_L5"].setFont(default);
			me["Simple_L6"].setFont(default);
			me["Simple_L1S"].setFont(default);
			me["Simple_L2S"].setFont(default);
			me["Simple_L3S"].setFont(default);
			me["Simple_L4S"].setFont(default);
			me["Simple_L5S"].setFont(default);
			me["Simple_L6S"].setFont(default);
			me["Simple_R1"].setFont(default);
			me["Simple_R2"].setFont(default);
			me["Simple_R3"].setFont(default);
			me["Simple_R4"].setFont(default);
			me["Simple_R5"].setFont(default);
			me["Simple_R6"].setFont(default);
			me["Simple_R1S"].setFont(default);
			me["Simple_R2S"].setFont(default);
			me["Simple_R3S"].setFont(default);
			me["Simple_R4S"].setFont(default);
			me["Simple_R5S"].setFont(default);
			me["Simple_R6S"].setFont(default);
			
			me["Simple_L1"].setFontSize(normal);
			me["Simple_L2"].setFontSize(normal);
			me["Simple_L3"].setFontSize(normal);
			me["Simple_L4"].setFontSize(normal);
			me["Simple_L5"].setFontSize(normal);
			me["Simple_L6"].setFontSize(normal);
			me["Simple_R1"].setFontSize(normal);
			me["Simple_R2"].setFontSize(normal);
			me["Simple_R3"].setFontSize(normal);
			me["Simple_R4"].setFontSize(normal);
			me["Simple_R5"].setFontSize(normal);
			me["Simple_R6"].setFontSize(normal);
			
			me["Simple_L1"].setColor(1,1,1);
			me["Simple_L2"].setColor(1,1,1);
			me["Simple_L3"].setColor(1,1,1);
			me["Simple_L4"].setColor(1,1,1);
			me["Simple_L5"].setColor(1,1,1);
			me["Simple_L6"].setColor(1,1,1);
			me["Simple_L1S"].setColor(1,1,1);
			me["Simple_L2S"].setColor(1,1,1);
			me["Simple_L3S"].setColor(1,1,1);
			me["Simple_L4S"].setColor(1,1,1);
			me["Simple_L5S"].setColor(1,1,1);
			me["Simple_L6S"].setColor(1,1,1);
			me["Simple_L1_Arrow"].setColor(1,1,1);
			me["Simple_L2_Arrow"].setColor(1,1,1);
			me["Simple_L3_Arrow"].setColor(1,1,1);
			me["Simple_L4_Arrow"].setColor(1,1,1);
			me["Simple_L5_Arrow"].setColor(1,1,1);
			me["Simple_L6_Arrow"].setColor(1,1,1);
			me["Simple_R1"].setColor(1,1,1);
			me["Simple_R2"].setColor(1,1,1);
			me["Simple_R3"].setColor(1,1,1);
			me["Simple_R4"].setColor(1,1,1);
			me["Simple_R5"].setColor(1,1,1);
			me["Simple_R6"].setColor(1,1,1);
			me["Simple_R1S"].setColor(1,1,1);
			me["Simple_R2S"].setColor(1,1,1);
			me["Simple_R3S"].setColor(1,1,1);
			me["Simple_R4S"].setColor(1,1,1);
			me["Simple_R5S"].setColor(1,1,1);
			me["Simple_R6S"].setColor(1,1,1);
			me["Simple_R1_Arrow"].setColor(1,1,1);
			me["Simple_R2_Arrow"].setColor(1,1,1);
			me["Simple_R3_Arrow"].setColor(1,1,1);
			me["Simple_R4_Arrow"].setColor(1,1,1);
			me["Simple_R5_Arrow"].setColor(1,1,1);
			me["Simple_R6_Arrow"].setColor(1,1,1);
			
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
		} else {
			me["Simple"].hide();
			me["ArrowLeft"].hide();
			me["ArrowRight"].hide();
		}
		
		me["Scratchpad"].setText(sprintf("%s", getprop("/MCDU[" ~ i ~ "]/scratchpad")));
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

var MCDU_update = maketimer(0.2, func {
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
