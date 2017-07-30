# A3XX Upper ECAM Canvas
# Joshua Davidson (it0uchpods)

#######################################
# Copyright (c) A3XX Development Team #
#######################################

var upperECAM_iae_eis2 = nil;
var upperECAM_display = nil;
setprop("/engines/engine[0]/epr-actual", 1);
setprop("/engines/engine[1]/epr-actual", 1);
setprop("/engines/engine[0]/egt-actual", 1);
setprop("/engines/engine[1]/egt-actual", 1);
setprop("/engines/engine[0]/ff-actual", 0);
setprop("/engines/engine[1]/ff-actual", 0);
setprop("/ECAM/Upper/EPR[0]", 0);
setprop("/ECAM/Upper/EPR[1]", 0);
setprop("/ECAM/Upper/EPRthr[0]", 0);
setprop("/ECAM/Upper/ERPthr[1]", 0);
setprop("/ECAM/Upper/EPRylim[0]", 0);
setprop("/ECAM/Upper/EPRylim[1]", 0);
setprop("/ECAM/Upper/EGT[0]", 0);
setprop("/ECAM/Upper/EGT[1]", 0);
setprop("/ECAM/Upper/N1[0]", 0);
setprop("/ECAM/Upper/N1[1]", 0);

var canvas_upperECAM_base = {
	init: func(canvas_group, file) {
		var font_mapper = func(family, weight) {
			return "LiberationFonts/LiberationSans-Regular.ttf";
		};

		canvas.parsesvg(canvas_group, file, {'font-mapper': font_mapper});

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
		if (getprop("/systems/electrical/bus/ac1") >= 110 or getprop("/systems/electrical/bus/ac2") >= 110) {
			# Choose between CFM, IAE, and EIS versions
			upperECAM_iae_eis2.page.show();
		} else {
			upperECAM_iae_eis2.page.hide();
		}
		
		settimer(func me.update(), 0.02);
	},
	updateBase: func() {
		# FOB
		me["FOB-LBS"].setText(sprintf("%7.0f", getprop("/consumables/fuel/total-fuel-lbs")));
		
		# Left ECAM Messages
		me["ECAML1"].hide();
		me["ECAML2"].hide();
		me["ECAML3"].hide();
		me["ECAML4"].hide();
		me["ECAML5"].hide();
		me["ECAML6"].hide();
		me["ECAML7"].hide();
		me["ECAML8"].hide();
	},
};

var canvas_upperECAM_iae_eis2 = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_upperECAM_iae_eis2 , canvas_upperECAM_base] };
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["EPR1-needle","EPR1-thr","EPR1","EPR1-box","EPR1-scale","EPR1-scalenum","EPR1-XX","EPR1-XX2","EGT1-needle","EGT1","EGT1-scale","EGT1-box","EGT1-scale2","EGT1-scaletick","EGT1-XX","N11-needle","N11","N11-decpnt","N11-decimal","N11-scale",
		"N11-scale2","N11-scalenum","N11-XX","N21","N21-decpnt","N21-decimal","N21-XX","FF1","FF1-XX","FOB-LBS","ECAML1","ECAML2","ECAML3","ECAML4","ECAML5","ECAML6","ECAML7","ECAML8"];
	},
	update: func() {
		# EPR 1
		me["EPR1"].setText(sprintf("%1.3f", getprop("/engines/engine[0]/epr-actual")));
		
		me["EPR1-needle"].setRotation((getprop("/ECAM/Upper/EPR[0]") + 90)*D2R);
		me["EPR1-thr"].setRotation((getprop("/ECAM/Upper/EPRthr[0]") + 90)*D2R);
		
		if (getprop("/systems/fadec/eng1/epr") == 1) {
			me["EPR1-scale"].setColor(1,1,1);
			me["EPR1"].show();
			me["EPR1-needle"].show();
			me["EPR1-thr"].show();
			me["EPR1-scalenum"].show();
			me["EPR1-box"].show();
			me["EPR1-XX"].hide();
			me["EPR1-XX2"].hide();
		} else {
			me["EPR1-scale"].setColor(1,0.6,0);
			me["EPR1"].hide();
			me["EPR1-needle"].hide();
			me["EPR1-thr"].hide();
			me["EPR1-scalenum"].hide();
			me["EPR1-box"].hide();
			me["EPR1-XX"].show();
			me["EPR1-XX2"].show();
		}
		
		# EGT 1
		me["EGT1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/egt-actual"))));
		
		me["EGT1-needle"].setRotation((getprop("/ECAM/Upper/EGT[0]") + 90)*D2R);
		
		if (getprop("/systems/fadec/eng1/egt") == 1) {
			me["EGT1-scale"].setColor(1,1,1);
			me["EGT1-scale2"].setColor(1,0,0);
			me["EGT1"].show();
			me["EGT1-needle"].show();
			me["EGT1-scaletick"].show();
			me["EGT1-box"].show();
			me["EGT1-XX"].hide();
		} else {
			me["EGT1-scale"].setColor(1,0.6,0);
			me["EGT1-scale2"].setColor(1,0.6,0);
			me["EGT1"].hide();
			me["EGT1-needle"].hide();
			me["EGT1-scaletick"].hide();
			me["EGT1-box"].hide();
			me["EGT1-XX"].show();
		}
		
		# N1 1
		me["N11"].setText(sprintf("%s", math.floor(getprop("/engines/engine[0]/n1") + 0.05)));
		me["N11-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/n1") + 0.05,1))));
		
		me["N11-needle"].setRotation((getprop("/ECAM/Upper/N1[0]") + 90)*D2R);
		
		if (getprop("/systems/fadec/eng1/n1") == 1) {
			me["N11-scale"].setColor(1,1,1);
			me["N11-scale2"].setColor(1,0,0);
			me["N11"].show();
			me["N11-decimal"].show();
			me["N11-decpnt"].show();
			me["N11-needle"].show();
			me["N11-scalenum"].show();
			me["N11-XX"].hide();
		} else {
			me["N11-scale"].setColor(1,0.6,0);
			me["N11-scale2"].setColor(1,0.6,0);
			me["N11"].hide();
			me["N11-decimal"].hide();
			me["N11-decpnt"].hide();
			me["N11-needle"].hide();
			me["N11-scalenum"].hide();
			me["N11-XX"].show();
		}
		
		# N2 1
		me["N21"].setText(sprintf("%s", math.floor(getprop("/engines/engine[0]/n2") + 0.05)));
		me["N21-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/n2") + 0.05,1))));
		
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
		
		# FF1
		me["FF1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/ff-actual"))));
		
		if (getprop("/systems/fadec/eng1/ff") == 1) {
			me["FF1"].show();
			me["FF1-XX"].hide();
		} else {
			me["FF1"].hide();
			me["FF1-XX"].show();
		}
		
		me.updateBase();
		
		settimer(func me.update(), 0.02);
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
	var group_iae_eis2 = upperECAM_display.createGroup();

	upperECAM_iae_eis2 = canvas_upperECAM_iae_eis2.new(group_iae_eis2, "Aircraft/A320Family/Models/Instruments/Upper-ECAM/res/iae-eis2.svg");

	upperECAM_iae_eis2.update();
	canvas_upperECAM_base.update();
});

var showUpperECAM = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(upperECAM_display);
}
