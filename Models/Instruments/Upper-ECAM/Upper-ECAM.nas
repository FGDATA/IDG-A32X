# A3XX Upper ECAM Canvas
# Joshua Davidson (it0uchpods)

##############################################
# Copyright (c) Joshua Davidson (it0uchpods) #
##############################################

var upperECAM_cfm_eis2 = nil;
var upperECAM_iae_eis2 = nil;
var upperECAM_test = nil;
var upperECAM_display = nil;
var elapsedtime = 0;
setprop("/engines/engine[0]/fuel-flow_actual", 0);
setprop("/engines/engine[1]/fuel-flow_actual", 0);
setprop("/ECAM/Upper/EPR[0]", 0);
setprop("/ECAM/Upper/EPR[1]", 0);
setprop("/ECAM/Upper/EPRthr[0]", 0);
setprop("/ECAM/Upper/EPRthr[1]", 0);
setprop("/ECAM/Upper/EPRylim", 0);
setprop("/ECAM/Upper/EGT[0]", 0);
setprop("/ECAM/Upper/EGT[1]", 0);
setprop("/ECAM/Upper/N1[0]", 0);
setprop("/ECAM/Upper/N1[1]", 0);
setprop("/ECAM/Upper/N1thr[0]", 0);
setprop("/ECAM/Upper/N1thr[1]", 0);
setprop("/ECAM/Upper/N1ylim", 0);
setprop("/instrumentation/du/du3-test", 0);
setprop("/instrumentation/du/du3-test-time", 0);

var canvas_upperECAM_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});

		var svg_keys = me.getKeys();
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
		}

		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		elapsedtime = getprop("/sim/time/elapsed-sec");
		if (getprop("/systems/electrical/bus/ac-ess") >= 110) {
			if (getprop("/systems/acconfig/autoconfig-running") != 1 and getprop("/instrumentation/du/du3-test") != 1) {
				setprop("/instrumentation/du/du3-test", 1);
				setprop("/instrumentation/du/du3-test-time", getprop("/sim/time/elapsed-sec"));
			} else if (getprop("/systems/acconfig/autoconfig-running") == 1 and getprop("/instrumentation/du/du3-test") != 1) {
				setprop("/instrumentation/du/du3-test", 1);
				setprop("/instrumentation/du/du3-test-time", getprop("/sim/time/elapsed-sec") - 35);
			}
		} else {
			setprop("/instrumentation/du/du3-test", 0);
		}
		
		if (getprop("/systems/electrical/bus/ac-ess") >= 110 and getprop("/controls/lighting/DU/du3") > 0) {
			if (getprop("/instrumentation/du/du3-test-time") + 39 >= elapsedtime) {
				upperECAM_cfm_eis2.page.hide();
				upperECAM_iae_eis2.page.hide();
				upperECAM_test.page.show();
			} else {
				upperECAM_test.page.hide();
				if (getprop("/options/eng") == "CFM") {
					upperECAM_cfm_eis2.page.show();
					upperECAM_iae_eis2.page.hide();
					upperECAM_cfm_eis2.update();
				} else if (getprop("/options/eng") == "IAE") {
					upperECAM_cfm_eis2.page.hide();
					upperECAM_iae_eis2.page.show();
					upperECAM_iae_eis2.update();
				}
			}
		} else {
			upperECAM_test.page.hide();
			upperECAM_cfm_eis2.page.hide();
			upperECAM_iae_eis2.page.hide();
		}
	},
	updateBase: func() {
		# Reversers
		if (getprop("/engines/engine[0]/reverser-pos-norm") >= 0.01 and getprop("/systems/fadec/eng1/n1") == 1 and getprop("/options/eng") == "CFM") {
			me["REV1"].show();
			me["REV1-box"].show();
		} else if (getprop("/engines/engine[0]/reverser-pos-norm") >= 0.01 and getprop("/systems/fadec/eng1/epr") == 1 and getprop("/options/eng") == "IAE") {
			me["REV1"].show();
			me["REV1-box"].show();
		} else {
			me["REV1"].hide();
			me["REV1-box"].hide();
		}
		
		if (getprop("/engines/engine[0]/reverser-pos-norm") >= 0.95) {
			me["REV1"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["REV1"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/engines/engine[1]/reverser-pos-norm") >= 0.01 and getprop("/systems/fadec/eng2/n1") == 1 and getprop("/options/eng") == "CFM") {
			me["REV2"].show();
			me["REV2-box"].show();
		} else if (getprop("/engines/engine[1]/reverser-pos-norm") >= 0.01 and getprop("/systems/fadec/eng2/epr") == 1 and getprop("/options/eng") == "IAE") {
			me["REV2"].show();
			me["REV2-box"].show();
		} else {
			me["REV2"].hide();
			me["REV2-box"].hide();
		}
		
		if (getprop("/engines/engine[1]/reverser-pos-norm") >= 0.95) {
			me["REV2"].setColor(0.0509,0.7529,0.2941);
		} else {
			me["REV2"].setColor(0.7333,0.3803,0);
		}
		
		# Flap Indicator
		me["FlapTxt"].setText(sprintf("%s", getprop("/controls/flight/flap-txt")));
		
		if (getprop("/controls/flight/flap-pos") > 0) {
			me["FlapDots"].show();
		} else {
			me["FlapDots"].hide();
		}
		
		# FOB
		me["FOB-LBS"].setText(sprintf("%s", math.round(getprop("/consumables/fuel/total-fuel-lbs"), 10)));
		
		# Left ECAM Messages
		if (getprop("/ECAM/left-msg") == "MSG") {
			me["ECAML1"].setText(sprintf("%s", getprop("/ECAM/msg/line1")));
			me["ECAML2"].setText(sprintf("%s", getprop("/ECAM/msg/line2")));
			me["ECAML3"].setText(sprintf("%s", getprop("/ECAM/msg/line3")));
			me["ECAML4"].setText(sprintf("%s", getprop("/ECAM/msg/line4")));
			me["ECAML5"].setText(sprintf("%s", getprop("/ECAM/msg/line5")));
			me["ECAML6"].setText(sprintf("%s", getprop("/ECAM/msg/line6")));
			me["ECAML7"].setText(sprintf("%s", getprop("/ECAM/msg/line7")));
			me["ECAML8"].setText(sprintf("%s", getprop("/ECAM/msg/line8")));
			
			if (getprop("/ECAM/msg/line1c") == "w") {
				me["ECAML1"].setColor(0.8078,0.8039,0.8078);
			} else if (getprop("/ECAM/msg/line1c") == "b") {
				me["ECAML1"].setColor(0.0901,0.6039,0.7176);
			} else if (getprop("/ECAM/msg/line1c") == "g") {
				me["ECAML1"].setColor(0.0509,0.7529,0.2941);
			} else if (getprop("/ECAM/msg/line1c") == "a") {
				me["ECAML1"].setColor(0.7333,0.3803,0);
			} else if (getprop("/ECAM/msg/line1c") == "r") {
				me["ECAML1"].setColor(1,0,0);
			}
			
			if (getprop("/ECAM/msg/line2c") == "w") {
				me["ECAML2"].setColor(0.8078,0.8039,0.8078);
			} else if (getprop("/ECAM/msg/line2c") == "b") {
				me["ECAML2"].setColor(0.0901,0.6039,0.7176);
			} else if (getprop("/ECAM/msg/line2c") == "g") {
				me["ECAML2"].setColor(0.0509,0.7529,0.2941);
			} else if (getprop("/ECAM/msg/line2c") == "a") {
				me["ECAML2"].setColor(0.7333,0.3803,0);
			} else if (getprop("/ECAM/msg/line2c") == "r") {
				me["ECAML2"].setColor(1,0,0);
			}
			
			if (getprop("/ECAM/msg/line3c") == "w") {
				me["ECAML3"].setColor(0.8078,0.8039,0.8078);
			} else if (getprop("/ECAM/msg/line3c") == "b") {
				me["ECAML3"].setColor(0.0901,0.6039,0.7176);
			} else if (getprop("/ECAM/msg/line3c") == "g") {
				me["ECAML3"].setColor(0.0509,0.7529,0.2941);
			} else if (getprop("/ECAM/msg/line3c") == "a") {
				me["ECAML3"].setColor(0.7333,0.3803,0);
			} else if (getprop("/ECAM/msg/line3c") == "r") {
				me["ECAML3"].setColor(1,0,0);
			}
			
			if (getprop("/ECAM/msg/line4c") == "w") {
				me["ECAML4"].setColor(0.8078,0.8039,0.8078);
			} else if (getprop("/ECAM/msg/line4c") == "b") {
				me["ECAML4"].setColor(0.0901,0.6039,0.7176);
			} else if (getprop("/ECAM/msg/line4c") == "g") {
				me["ECAML4"].setColor(0.0509,0.7529,0.2941);
			} else if (getprop("/ECAM/msg/line4c") == "a") {
				me["ECAML4"].setColor(0.7333,0.3803,0);
			} else if (getprop("/ECAM/msg/line4c") == "r") {
				me["ECAML4"].setColor(1,0,0);
			}
			
			if (getprop("/ECAM/msg/line5c") == "w") {
				me["ECAML5"].setColor(0.8078,0.8039,0.8078);
			} else if (getprop("/ECAM/msg/line5c") == "b") {
				me["ECAML5"].setColor(0.0901,0.6039,0.7176);
			} else if (getprop("/ECAM/msg/line5c") == "g") {
				me["ECAML5"].setColor(0.0509,0.7529,0.2941);
			} else if (getprop("/ECAM/msg/line5c") == "a") {
				me["ECAML5"].setColor(0.7333,0.3803,0);
			} else if (getprop("/ECAM/msg/line5c") == "r") {
				me["ECAML5"].setColor(1,0,0);
			}
			
			if (getprop("/ECAM/msg/line6c") == "w") {
				me["ECAML6"].setColor(0.8078,0.8039,0.8078);
			} else if (getprop("/ECAM/msg/line6c") == "b") {
				me["ECAML6"].setColor(0.0901,0.6039,0.7176);
			} else if (getprop("/ECAM/msg/line6c") == "g") {
				me["ECAML6"].setColor(0.0509,0.7529,0.2941);
			} else if (getprop("/ECAM/msg/line6c") == "a") {
				me["ECAML6"].setColor(0.7333,0.3803,0);
			} else if (getprop("/ECAM/msg/line6c") == "r") {
				me["ECAML6"].setColor(1,0,0);
			}
			
			if (getprop("/ECAM/msg/line7c") == "w") {
				me["ECAML7"].setColor(0.8078,0.8039,0.8078);
			} else if (getprop("/ECAM/msg/line7c") == "b") {
				me["ECAML7"].setColor(0.0901,0.6039,0.7176);
			} else if (getprop("/ECAM/msg/line7c") == "g") {
				me["ECAML7"].setColor(0.0509,0.7529,0.2941);
			} else if (getprop("/ECAM/msg/line7c") == "a") {
				me["ECAML7"].setColor(0.7333,0.3803,0);
			} else if (getprop("/ECAM/msg/line7c") == "r") {
				me["ECAML7"].setColor(1,0,0);
			}
			
			if (getprop("/ECAM/msg/line8c") == "w") {
				me["ECAML8"].setColor(0.8078,0.8039,0.8078);
			} else if (getprop("/ECAM/msg/line8c") == "b") {
				me["ECAML8"].setColor(0.0901,0.6039,0.7176);
			} else if (getprop("/ECAM/msg/line8c") == "g") {
				me["ECAML8"].setColor(0.0509,0.7529,0.2941);
			} else if (getprop("/ECAM/msg/line8c") == "a") {
				me["ECAML8"].setColor(0.7333,0.3803,0);
			} else if (getprop("/ECAM/msg/line8c") == "r") {
				me["ECAML8"].setColor(1,0,0);
			}
			
			me["TO_Memo"].hide();
			me["ECAM_Left"].show();
		} else if (getprop("/ECAM/left-msg") == "TO-MEMO") {
			if (getprop("/controls/autobrake/mode") == 3) {
				me["TO_Autobrake"].setText("AUTO BRK MAX");
				me["TO_Autobrake_B"].hide();
			} else {
				me["TO_Autobrake"].setText("AUTO BRK");
				me["TO_Autobrake_B"].show();
			}
			
			if (getprop("/controls/switches/no-smoking-sign") == 1 and getprop("/controls/switches/seatbelt-sign") == 1) {
				me["TO_Signs"].setText("SIGNS ON");
				me["TO_Signs_B"].hide();
			} else {
				me["TO_Signs"].setText("SIGNS");
				me["TO_Signs_B"].show();
			}
			
			if (getprop("/controls/flight/speedbrake-arm") == 1) {
				me["TO_Spoilers"].setText("SPLRS ARM");
				me["TO_Spoilers_B"].hide();
			} else {
				me["TO_Spoilers"].setText("SPLRS");
				me["TO_Spoilers_B"].show();
			}
			
			if (getprop("/controls/flight/flap-pos") > 0 and getprop("/controls/flight/flap-pos") < 5) {
				me["TO_Flaps"].setText("FLAPS T.O");
				me["TO_Flaps_B"].hide();
			} else {
				me["TO_Flaps"].setText("FLAPS");
				me["TO_Flaps_B"].show();
			}
			
			if (getprop("/controls/autobrake/mode") == 3 and getprop("/controls/switches/no-smoking-sign") == 1 and getprop("/controls/switches/seatbelt-sign") == 1 and getprop("/controls/flight/speedbrake-arm") == 1 and getprop("/controls/flight/flap-pos") > 0 
			and getprop("/controls/flight/flap-pos") < 5) {
				me["TO_Config"].setText("T.O CONFIG NORMAL");
				me["TO_Config_B"].hide();
			} else {
				me["TO_Config"].setText("T.O CONFIG");
				me["TO_Config_B"].show();
			}
			
			me["ECAM_Left"].hide();
			me["TO_Memo"].show();
		} else {
			me["ECAM_Left"].hide();
			me["TO_Memo"].hide();
		}
	},
};

var canvas_upperECAM_cfm_eis2 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_upperECAM_cfm_eis2, canvas_upperECAM_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["N11-needle","N11-thr","N11-ylim","N11","N11-decpnt","N11-decimal","N11-box","N11-scale","N11-scale2","N11-scaletick","N11-scalenum","N11-XX","N11-XX2","N11-XX-box","EGT1-needle","EGT1","EGT1-scale","EGT1-box","EGT1-scale2","EGT1-scaletick",
		"EGT1-XX","N21","N21-decpnt","N21-decimal","N21-XX","FF1","FF1-XX","N12-needle","N12-thr","N12-ylim","N12","N12-decpnt","N12-decimal","N12-box","N12-scale","N12-scale2","N12-scaletick","N12-scalenum","N12-XX","N12-XX2","N12-XX-box","EGT2-needle","EGT2",
		"EGT2-scale","EGT2-box","EGT2-scale2","EGT2-scaletick","EGT2-XX","N22","N22-decpnt","N22-decimal","N22-XX","FF2","FF2-XX","FOB-LBS","FlapTxt","FlapDots","N1Lim-mode","N1Lim","N1Lim-decpnt","N1Lim-decimal","N1Lim-percent","N1Lim-XX","N1Lim-XX2","REV1",
		"REV1-box","REV2","REV2-box","ECAM_Left","ECAML1","ECAML2","ECAML3","ECAML4","ECAML5","ECAML6","ECAML7","ECAML8","TO_Memo","TO_Autobrake","TO_Signs","TO_Spoilers","TO_Flaps","TO_Config","TO_Autobrake_B","TO_Signs_B","TO_Spoilers_B","TO_Flaps_B",
		"TO_Config_B"];
	},
	update: func() {
		# N1
		me["N11"].setText(sprintf("%s", math.floor(getprop("/engines/engine[0]/n1-actual") + 0.05)));
		me["N11-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/n1-actual") + 0.05,1))));
		
		me["N12"].setText(sprintf("%s", math.floor(getprop("/engines/engine[1]/n1-actual") + 0.05)));
		me["N12-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[1]/n1-actual") + 0.05,1))));
		
		me["N11-needle"].setRotation((getprop("/ECAM/Upper/N1[0]") + 90) * D2R);
		me["N11-thr"].setRotation((getprop("/ECAM/Upper/N1thr[0]") + 90) * D2R);
		me["N11-ylim"].setRotation((getprop("/ECAM/Upper/N1ylim") + 90) * D2R);
		
		me["N12-needle"].setRotation((getprop("/ECAM/Upper/N1[1]") + 90) * D2R);
		me["N12-thr"].setRotation((getprop("/ECAM/Upper/N1thr[1]") + 90) * D2R);
		me["N12-ylim"].setRotation((getprop("/ECAM/Upper/N1ylim") + 90) * D2R);
		
		if (getprop("/systems/fadec/eng1/n1") == 1) {
			me["N11-scale"].setColor(0.8078,0.8039,0.8078);
			me["N11-scale2"].setColor(1,0,0);
			me["N11"].show();
			me["N11-decimal"].show();
			me["N11-decpnt"].show();
			me["N11-needle"].show();
			me["N11-ylim"].show();
			me["N11-scaletick"].show();
			me["N11-scalenum"].show();
			me["N11-box"].show();
			me["N11-XX"].hide();
			me["N11-XX2"].hide();
			me["N11-XX-box"].hide();
		} else {
			me["N11-scale"].setColor(0.7333,0.3803,0);
			me["N11-scale2"].setColor(0.7333,0.3803,0);
			me["N11"].hide();
			me["N11-decimal"].hide();
			me["N11-decpnt"].hide();
			me["N11-needle"].hide();
			me["N11-ylim"].hide();
			me["N11-scaletick"].hide();
			me["N11-scalenum"].hide();
			me["N11-box"].hide();
			me["N11-XX"].show();
			me["N11-XX2"].show();
			me["N11-XX-box"].show();
		}
		
		if (getprop("/engines/engine[0]/reverser-pos-norm") < 0.01 and getprop("/systems/fadec/eng1/n1") == 1) {
			me["N11-thr"].show();
		} else {
			me["N11-thr"].hide();
		}
		
		if (getprop("/systems/fadec/eng2/n1") == 1) {
			me["N12-scale"].setColor(0.8078,0.8039,0.8078);
			me["N12-scale2"].setColor(1,0,0);
			me["N12"].show();
			me["N12-decimal"].show();
			me["N12-decpnt"].show();
			me["N12-needle"].show();
			me["N12-ylim"].show();
			me["N12-scaletick"].show();
			me["N12-scalenum"].show();
			me["N12-box"].show();
			me["N12-XX"].hide();
			me["N12-XX2"].hide();
			me["N12-XX-box"].hide();
		} else {
			me["N12-scale"].setColor(0.7333,0.3803,0);
			me["N12-scale2"].setColor(0.7333,0.3803,0);
			me["N12"].hide();
			me["N12-decimal"].hide();
			me["N12-decpnt"].hide();
			me["N12-needle"].hide();
			me["N12-ylim"].hide();
			me["N12-scaletick"].hide();
			me["N12-scalenum"].hide();
			me["N12-box"].hide();
			me["N12-XX"].show();
			me["N12-XX2"].show();
			me["N12-XX-box"].show();
		}
		
		if (getprop("/engines/engine[1]/reverser-pos-norm") < 0.01 and getprop("/systems/fadec/eng2/n1") == 1) {
			me["N12-thr"].show();
		} else {
			me["N12-thr"].hide();
		}
		
		# EGT
		me["EGT1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/egt-actual"))));
		me["EGT2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/egt-actual"))));
		
		me["EGT1-needle"].setRotation((getprop("/ECAM/Upper/EGT[0]") + 90) * D2R);
		me["EGT2-needle"].setRotation((getprop("/ECAM/Upper/EGT[1]") + 90) * D2R);
		
		if (getprop("/systems/fadec/eng1/egt") == 1) {
			me["EGT1-scale"].setColor(0.8078,0.8039,0.8078);
			me["EGT1-scale2"].setColor(1,0,0);
			me["EGT1"].show();
			me["EGT1-needle"].show();
			me["EGT1-scaletick"].show();
			me["EGT1-box"].show();
			me["EGT1-XX"].hide();
		} else {
			me["EGT1-scale"].setColor(0.7333,0.3803,0);
			me["EGT1-scale2"].setColor(0.7333,0.3803,0);
			me["EGT1"].hide();
			me["EGT1-needle"].hide();
			me["EGT1-scaletick"].hide();
			me["EGT1-box"].hide();
			me["EGT1-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng2/egt") == 1) {
			me["EGT2-scale"].setColor(0.8078,0.8039,0.8078);
			me["EGT2-scale2"].setColor(1,0,0);
			me["EGT2"].show();
			me["EGT2-needle"].show();
			me["EGT2-scaletick"].show();
			me["EGT2-box"].show();
			me["EGT2-XX"].hide();
		} else {
			me["EGT2-scale"].setColor(0.7333,0.3803,0);
			me["EGT2-scale2"].setColor(0.7333,0.3803,0);
			me["EGT2"].hide();
			me["EGT2-needle"].hide();
			me["EGT2-scaletick"].hide();
			me["EGT2-box"].hide();
			me["EGT2-XX"].show();
		}
		
		# N2
		me["N21"].setText(sprintf("%s", math.floor(getprop("/engines/engine[0]/n2-actual") + 0.05)));
		me["N21-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/n2-actual") + 0.05,1))));
		me["N22"].setText(sprintf("%s", math.floor(getprop("/engines/engine[1]/n2-actual") + 0.05)));
		me["N22-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[1]/n2-actual") + 0.05,1))));
		
		if (getprop("/systems/fadec/eng1/n2") == 1) {
			me["N21"].show();
			me["N21-decimal"].show();
			me["N21-decpnt"].show();
			me["N21-XX"].hide();
		} else {
			me["N21"].hide();
			me["N21-decimal"].hide();
			me["N21-decpnt"].hide();
			me["N21-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng2/n2") == 1) {
			me["N22"].show();
			me["N22-decimal"].show();
			me["N22-decpnt"].show();
			me["N22-XX"].hide();
		} else {
			me["N22"].hide();
			me["N22-decimal"].hide();
			me["N22-decpnt"].hide();
			me["N22-XX"].show();
		}
		
		# FF
		me["FF1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/fuel-flow_actual"), 10)));
		me["FF2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/fuel-flow_actual"), 10)));
		
		if (getprop("/systems/fadec/eng1/ff") == 1) {
			me["FF1"].show();
			me["FF1-XX"].hide();
		} else {
			me["FF1"].hide();
			me["FF1-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng2/ff") == 1) {
			me["FF2"].show();
			me["FF2-XX"].hide();
		} else {
			me["FF2"].hide();
			me["FF2-XX"].show();
		}
		
		# N1 Limit
		me["N1Lim-mode"].setText(sprintf("%s", getprop("/controls/engines/thrust-limit")));
		me["N1Lim"].setText(sprintf("%s", math.floor(getprop("/controls/engines/n1-limit") + 0.05)));
		me["N1Lim-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/controls/engines/n1-limit") + 0.05,1))));
		
		if (getprop("/systems/fadec/powered1") == 1 or getprop("/systems/fadec/powered2") == 1 or getprop("/systems/fadec/powerup")) {
			me["N1Lim-mode"].show();
			me["N1Lim-XX"].hide();
			me["N1Lim-XX2"].hide();
		} else {
			me["N1Lim-mode"].hide();
			me["N1Lim-XX"].show();
			me["N1Lim-XX2"].show();
		}
		
		if ((getprop("/systems/fadec/powered1") == 1 or getprop("/systems/fadec/powered2") == 1 or getprop("/systems/fadec/powerup")) and getprop("/controls/engines/thrust-limit") != "MREV") {
			me["N1Lim"].show();
			me["N1Lim-decpnt"].show();
			me["N1Lim-decimal"].show();
			me["N1Lim-percent"].show();
		} else {
			me["N1Lim"].hide();
			me["N1Lim-decpnt"].hide();
			me["N1Lim-decimal"].hide();
			me["N1Lim-percent"].hide();
		}
		
		me.updateBase();
	},
};

var canvas_upperECAM_iae_eis2 = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_upperECAM_iae_eis2, canvas_upperECAM_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["EPR1-needle","EPR1-thr","EPR1-ylim","EPR1","EPR1-decpnt","EPR1-decimal","EPR1-box","EPR1-scale","EPR1-scaletick","EPR1-scalenum","EPR1-XX","EPR1-XX2","EGT1-needle","EGT1","EGT1-scale","EGT1-box","EGT1-scale2","EGT1-scaletick","EGT1-XX",
		"N11-needle","N11-thr","N11-ylim","N11","N11-decpnt","N11-decimal","N11-scale","N11-scale2","N11-scaletick","N11-scalenum","N11-XX","N21","N21-decpnt","N21-decimal","N21-XX","FF1","FF1-XX","EPR2-needle","EPR2-thr","EPR2-ylim","EPR2","EPR2-decpnt",
		"EPR2-decimal","EPR2-box","EPR2-scale","EPR2-scaletick","EPR2-scalenum","EPR2-XX","EPR2-XX2","EGT2-needle","EGT2","EGT2-scale","EGT2-scale2","EGT2-box","EGT2-scaletick","EGT2-XX","N12-needle","N12-thr","N12-ylim","N12","N12-decpnt","N12-decimal",
		"N12-scale","N12-scale2","N12-scaletick","N12-scalenum","N12-XX","N22","N22-decpnt","N22-decimal","N22-XX","FF2","FF2-XX","FOB-LBS","FlapTxt","FlapDots","EPRLim-mode","EPRLim","EPRLim-decpnt","EPRLim-decimal","EPRLim-XX","EPRLim-XX2","REV1","REV1-box",
		"REV2","REV2-box","ECAM_Left","ECAML1","ECAML2","ECAML3","ECAML4","ECAML5","ECAML6","ECAML7","ECAML8","TO_Memo","TO_Autobrake","TO_Signs","TO_Spoilers","TO_Flaps","TO_Config","TO_Autobrake_B","TO_Signs_B","TO_Spoilers_B","TO_Flaps_B","TO_Config_B"];
	},
	update: func() {
		# EPR
		me["EPR1"].setText(sprintf("%1.0f", math.floor(getprop("/engines/engine[0]/epr-actual"))));
		me["EPR1-decimal"].setText(sprintf("%03d", (getprop("/engines/engine[0]/epr-actual") - int(getprop("/engines/engine[0]/epr-actual"))) * 1000));
		me["EPR2"].setText(sprintf("%1.0f", math.floor(getprop("/engines/engine[1]/epr-actual"))));
		me["EPR2-decimal"].setText(sprintf("%03d", (getprop("/engines/engine[1]/epr-actual") - int(getprop("/engines/engine[1]/epr-actual"))) * 1000));
		
		me["EPR1-needle"].setRotation((getprop("/ECAM/Upper/EPR[0]") + 90) * D2R);
		me["EPR1-thr"].setRotation((getprop("/ECAM/Upper/EPRthr[0]") + 90) * D2R);
		me["EPR1-ylim"].setRotation((getprop("/ECAM/Upper/EPRylim") + 90) * D2R);
		me["EPR2-needle"].setRotation((getprop("/ECAM/Upper/EPR[1]") + 90) * D2R);
		me["EPR2-thr"].setRotation((getprop("/ECAM/Upper/EPRthr[1]") + 90) * D2R);
		me["EPR2-ylim"].setRotation((getprop("/ECAM/Upper/EPRylim") + 90) * D2R);
		
		if (getprop("/systems/fadec/eng1/epr") == 1) {
			me["EPR1-scale"].setColor(0.8078,0.8039,0.8078);
			me["EPR1"].show();
			me["EPR1-decpnt"].show();
			me["EPR1-decimal"].show();
			me["EPR1-needle"].show();
			me["EPR1-ylim"].show();
			me["EPR1-scaletick"].show();
			me["EPR1-scalenum"].show();
			me["EPR1-box"].show();
			me["EPR1-XX"].hide();
			me["EPR1-XX2"].hide();
		} else {
			me["EPR1-scale"].setColor(0.7333,0.3803,0);
			me["EPR1"].hide();
			me["EPR1-decpnt"].hide();
			me["EPR1-decimal"].hide();
			me["EPR1-needle"].hide();
			me["EPR1-ylim"].hide();
			me["EPR1-scaletick"].hide();
			me["EPR1-scalenum"].hide();
			me["EPR1-box"].hide();
			me["EPR1-XX"].show();
			me["EPR1-XX2"].show();
		}
		
		if (getprop("/engines/engine[0]/reverser-pos-norm") < 0.01 and getprop("/systems/fadec/eng1/epr") == 1) {
			me["EPR1-thr"].show();
		} else {
			me["EPR1-thr"].hide();
		}
		
		if (getprop("/systems/fadec/eng2/epr") == 1) {
			me["EPR2-scale"].setColor(0.8078,0.8039,0.8078);
			me["EPR2"].show();
			me["EPR2-decpnt"].show();
			me["EPR2-decimal"].show();
			me["EPR2-needle"].show();
			me["EPR2-ylim"].show();
			me["EPR2-scaletick"].show();
			me["EPR2-scalenum"].show();
			me["EPR2-box"].show();
			me["EPR2-XX"].hide();
			me["EPR2-XX2"].hide();
		} else {
			me["EPR2-scale"].setColor(0.7333,0.3803,0);
			me["EPR2"].hide();
			me["EPR2-decpnt"].hide();
			me["EPR2-decimal"].hide();
			me["EPR2-needle"].hide();
			me["EPR2-ylim"].hide();
			me["EPR2-scaletick"].hide();
			me["EPR2-scalenum"].hide();
			me["EPR2-box"].hide();
			me["EPR2-XX"].show();
			me["EPR2-XX2"].show();
		}
		
		if (getprop("/engines/engine[1]/reverser-pos-norm") < 0.01 and getprop("/systems/fadec/eng2/epr") == 1) {
			me["EPR2-thr"].show();
		} else {
			me["EPR2-thr"].hide();
		}
		
		# EGT
		me["EGT1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/egt-actual"))));
		me["EGT2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/egt-actual"))));
		
		me["EGT1-needle"].setRotation((getprop("/ECAM/Upper/EGT[0]") + 90) * D2R);
		me["EGT2-needle"].setRotation((getprop("/ECAM/Upper/EGT[1]") + 90) * D2R);
		
		if (getprop("/systems/fadec/eng1/egt") == 1) {
			me["EGT1-scale"].setColor(0.8078,0.8039,0.8078);
			me["EGT1-scale2"].setColor(1,0,0);
			me["EGT1"].show();
			me["EGT1-needle"].show();
			me["EGT1-scaletick"].show();
			me["EGT1-box"].show();
			me["EGT1-XX"].hide();
		} else {
			me["EGT1-scale"].setColor(0.7333,0.3803,0);
			me["EGT1-scale2"].setColor(0.7333,0.3803,0);
			me["EGT1"].hide();
			me["EGT1-needle"].hide();
			me["EGT1-scaletick"].hide();
			me["EGT1-box"].hide();
			me["EGT1-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng2/egt") == 1) {
			me["EGT2-scale"].setColor(0.8078,0.8039,0.8078);
			me["EGT2-scale2"].setColor(1,0,0);
			me["EGT2"].show();
			me["EGT2-needle"].show();
			me["EGT2-scaletick"].show();
			me["EGT2-box"].show();
			me["EGT2-XX"].hide();
		} else {
			me["EGT2-scale"].setColor(0.7333,0.3803,0);
			me["EGT2-scale2"].setColor(0.7333,0.3803,0);
			me["EGT2"].hide();
			me["EGT2-needle"].hide();
			me["EGT2-scaletick"].hide();
			me["EGT2-box"].hide();
			me["EGT2-XX"].show();
		}
		
		# N1
		me["N11"].setText(sprintf("%s", math.floor(getprop("/engines/engine[0]/n1-actual") + 0.05)));
		me["N11-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/n1-actual") + 0.05,1))));
		
		me["N12"].setText(sprintf("%s", math.floor(getprop("/engines/engine[1]/n1-actual") + 0.05)));
		me["N12-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[1]/n1-actual") + 0.05,1))));
		
		me["N11-needle"].setRotation((getprop("/ECAM/Upper/N1[0]") + 90) * D2R);
		me["N11-thr"].setRotation((getprop("/ECAM/Upper/N1thr[0]") + 90) * D2R);
		me["N11-ylim"].setRotation((getprop("/ECAM/Upper/N1ylim") + 90) * D2R);
		
		me["N12-needle"].setRotation((getprop("/ECAM/Upper/N1[1]") + 90) * D2R);
		me["N12-thr"].setRotation((getprop("/ECAM/Upper/N1thr[1]") + 90) * D2R);
		me["N12-ylim"].setRotation((getprop("/ECAM/Upper/N1ylim") + 90) * D2R);
		
		if (getprop("/systems/fadec/eng1/n1") == 1) {
			me["N11-scale"].setColor(0.8078,0.8039,0.8078);
			me["N11-scale2"].setColor(1,0,0);
			me["N11"].show();
			me["N11-decimal"].show();
			me["N11-decpnt"].show();
			me["N11-needle"].show();
			me["N11-scaletick"].show();
			me["N11-scalenum"].show();
			me["N11-XX"].hide();
		} else {
			me["N11-scale"].setColor(0.7333,0.3803,0);
			me["N11-scale2"].setColor(0.7333,0.3803,0);
			me["N11"].hide();
			me["N11-decimal"].hide();
			me["N11-decpnt"].hide();
			me["N11-needle"].hide();
			me["N11-scaletick"].hide();
			me["N11-scalenum"].hide();
			me["N11-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng2/n1") == 1) {
			me["N12-scale"].setColor(0.8078,0.8039,0.8078);
			me["N12-scale2"].setColor(1,0,0);
			me["N12"].show();
			me["N12-decimal"].show();
			me["N12-decpnt"].show();
			me["N12-needle"].show();
			me["N12-scaletick"].show();
			me["N12-scalenum"].show();
			me["N12-XX"].hide();
		} else {
			me["N12-scale"].setColor(0.7333,0.3803,0);
			me["N12-scale2"].setColor(0.7333,0.3803,0);
			me["N12"].hide();
			me["N12-decimal"].hide();
			me["N12-decpnt"].hide();
			me["N12-needle"].hide();
			me["N12-scaletick"].hide();
			me["N12-scalenum"].hide();
			me["N12-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng1/n1") == 1 and getprop("/systems/fadec/n1mode1") == 1) {
			me["N11-thr"].show();
			me["N11-ylim"].hide(); # Keep it hidden, since N1 mode limit calculation is not done yet
		} else {
			me["N11-thr"].hide();
			me["N11-ylim"].hide();
		}
		
		if (getprop("/systems/fadec/eng1/n2") == 1 and getprop("/systems/fadec/n1mode2") == 1) {
			me["N12-thr"].show();
			me["N12-ylim"].hide(); # Keep it hidden, since N1 mode limit calculation is not done yet
		} else {
			me["N12-thr"].hide();
			me["N12-ylim"].hide();
		}
		
		# N2
		me["N21"].setText(sprintf("%s", math.floor(getprop("/engines/engine[0]/n2-actual") + 0.05)));
		me["N21-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/n2-actual") + 0.05,1))));
		me["N22"].setText(sprintf("%s", math.floor(getprop("/engines/engine[1]/n2-actual") + 0.05)));
		me["N22-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[1]/n2-actual") + 0.05,1))));
		
		if (getprop("/systems/fadec/eng1/n2") == 1) {
			me["N21"].show();
			me["N21-decimal"].show();
			me["N21-decpnt"].show();
			me["N21-XX"].hide();
		} else {
			me["N21"].hide();
			me["N21-decimal"].hide();
			me["N21-decpnt"].hide();
			me["N21-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng2/n2") == 1) {
			me["N22"].show();
			me["N22-decimal"].show();
			me["N22-decpnt"].show();
			me["N22-XX"].hide();
		} else {
			me["N22"].hide();
			me["N22-decimal"].hide();
			me["N22-decpnt"].hide();
			me["N22-XX"].show();
		}
		
		# FF
		me["FF1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/fuel-flow_actual"), 10)));
		me["FF2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/fuel-flow_actual"), 10)));
		
		if (getprop("/systems/fadec/eng1/ff") == 1) {
			me["FF1"].show();
			me["FF1-XX"].hide();
		} else {
			me["FF1"].hide();
			me["FF1-XX"].show();
		}
		
		if (getprop("/systems/fadec/eng2/ff") == 1) {
			me["FF2"].show();
			me["FF2-XX"].hide();
		} else {
			me["FF2"].hide();
			me["FF2-XX"].show();
		}
		
		# EPR Limit
		me["EPRLim-mode"].setText(sprintf("%s", getprop("/controls/engines/thrust-limit")));
		me["EPRLim"].setText(sprintf("%1.0f", math.floor(getprop("/controls/engines/epr-limit"))));
		me["EPRLim-decimal"].setText(sprintf("%03d", (getprop("/controls/engines/epr-limit") - int(getprop("/controls/engines/epr-limit"))) * 1000));
		
		if (getprop("/systems/fadec/powered1") == 1 or getprop("/systems/fadec/powered2") == 1 or getprop("/systems/fadec/powerup")) {
			me["EPRLim-mode"].show();
			me["EPRLim-XX"].hide();
			me["EPRLim-XX2"].hide();
		} else {
			me["EPRLim-mode"].hide();
			me["EPRLim-XX"].show();
			me["EPRLim-XX2"].show();
		}
		
		if ((getprop("/systems/fadec/powered1") == 1 or getprop("/systems/fadec/powered2") == 1 or getprop("/systems/fadec/powerup")) and getprop("/controls/engines/thrust-limit") != "MREV") {
			me["EPRLim"].show();
			me["EPRLim-decpnt"].show();
			me["EPRLim-decimal"].show();
		} else {
			me["EPRLim"].hide();
			me["EPRLim-decpnt"].hide();
			me["EPRLim-decimal"].hide();
		}
		
		me.updateBase();
	},
};

var canvas_upperECAM_test = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {"font-mapper": font_mapper});

		me.page = canvas_group;

		return me;
	},
	new: func(canvas_group, file) {
		var m = {parents: [canvas_upperECAM_test]};
		m.init(canvas_group, file);

		return m;
	},
};

setlistener("sim/signals/fdm-initialized", func {
	upperECAM_display = canvas.new({
		"name": "upperECAM",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	upperECAM_display.addPlacement({"node": "uecam.screen"});
	var group_cfm_eis2 = upperECAM_display.createGroup();
	var group_iae_eis2 = upperECAM_display.createGroup();
	var group_test = upperECAM_display.createGroup();

	upperECAM_cfm_eis2 = canvas_upperECAM_cfm_eis2.new(group_cfm_eis2, "Aircraft/IDG-A32X/Models/Instruments/Upper-ECAM/res/cfm-eis2.svg");
	upperECAM_iae_eis2 = canvas_upperECAM_iae_eis2.new(group_iae_eis2, "Aircraft/IDG-A32X/Models/Instruments/Upper-ECAM/res/iae-eis2.svg");
	upperECAM_test = canvas_upperECAM_test.new(group_test, "Aircraft/IDG-A32X/Models/Instruments/Common/res/du-test.svg");
	
	upperECAM_update.start();
});

var upperECAM_update = maketimer(0.05, func {
	canvas_upperECAM_base.update();
});

var showUpperECAM = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(upperECAM_display);
}
