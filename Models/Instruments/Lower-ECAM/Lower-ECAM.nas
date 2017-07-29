# A3XX Lower ECAM Canvas
# Joshua Davidson (it0uchpods)

#######################################
# Copyright (c) A3XX Development Team #
#######################################

var lowerECAM_apu = nil;
var lowerECAM_eng1 = nil;
var lowerECAM_eng = nil;
var lowerECAM_display = nil;
setprop("/systems/electrical/extra/apu-load", 0);
setprop("/systems/electrical/extra/apu-volts", 0);
setprop("/systems/electrical/extra/apu-hz", 0);
setprop("/systems/pneumatic/bleedapu", 0);
setprop("/engines/engine[0]/oil-psi-actual", 0);
setprop("/engines/engine[1]/oil-psi-actual", 0);
setprop("/ECAM/Lower/APU-N", 0);
setprop("/ECAM/Lower/APU-EGT", 0);
setprop("/ECAM/Lower/Oil-QT[0]", 0);
setprop("/ECAM/Lower/Oil-QT[1]", 0);
setprop("/ECAM/Lower/Oil-PSI[0]", 0);
setprop("/ECAM/Lower/Oil-PSI[1]", 0);
setprop("/environment/temperature-degc", 0);
setprop("/FMGC/internal/gw", 0);

var canvas_lowerECAM_base = {
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

	},
	
	updateBottomStatus: func() {
		me["TAT"].setText(sprintf("%s", math.round(getprop("/environment/temperature-degc"))));
		me["SAT"].setText(sprintf("%s", math.round(getprop("/environment/temperature-degc"))));
		me["GW"].setText(sprintf("%s", math.round(getprop("/FMGC/internal/gw"))));
	},
};

var canvas_lowerECAM_apu = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_lowerECAM_apu , canvas_lowerECAM_base] };
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["APUN-needle","APUEGT-needle","APUN","APUEGT","APUAvail","APUFlapOpen","APUBleedValve","APUBleedOnline","APUGenLoad","APUGenVolt","APUGenHz","APUBleedPSI","GW","TAT","SAT"];
	},
	update: func() {
		# Avail and Flap Open
		if (getprop("/systems/apu/rpm") > 3.5 and getprop("/controls/APU/master") == 1) {
			me["APUFlapOpen"].show();
		} else {
			me["APUFlapOpen"].hide();
		}

		if (getprop("/systems/apu/rpm") > 94.9) {
			me["APUAvail"].show();
		} else {
			me["APUAvail"].hide();
		}

		# APU Gen
		if (getprop("/systems/electrical/extra/apu-volts") > 110) {
			me["APUGenVolt"].setColor(0,1,0);
		} else {
			me["APUGenVolt"].setColor(1,0.6,0);
		}

		if (getprop("/systems/electrical/extra/apu-hz") > 380) {
			me["APUGenHz"].setColor(0,1,0);
		} else {
			me["APUGenHz"].setColor(1,0.6,0);
		}

		me["APUGenLoad"].setText(sprintf("%s", math.round(getprop("/systems/electrical/extra/apu-load"))));
		me["APUGenVolt"].setText(sprintf("%s", math.round(getprop("/systems/electrical/extra/apu-volts"))));
		me["APUGenHz"].setText(sprintf("%s", math.round(getprop("/systems/electrical/extra/apu-hz"))));

		# APU Bleed
		if (getprop("/systems/apu/rpm") >= 94.9) {
			me["APUBleedPSI"].setColor(0,1,0);
			me["APUBleedPSI"].setText(sprintf("%s", math.round(getprop("/systems/pneumatic/bleedapu"))));
		} else {
			me["APUBleedPSI"].setColor(1,0.6,0);
			me["APUBleedPSI"].setText(sprintf("%s", "XX"));
		}

		if (getprop("/systems/pneumatic/bleedapu") > 0 and getprop("/controls/pneumatic/switches/bleedapu") == 1) {
			me["APUBleedValve"].setRotation(90*D2R);
			me["APUBleedOnline"].show();
		} else {
			me["APUBleedValve"].setRotation(0);
			me["APUBleedOnline"].hide();
		}

		# APU N and EGT
		me["APUN"].setText(sprintf("%s", math.round(getprop("/systems/apu/rpm"))));
		me["APUEGT"].setText(sprintf("%s", math.round(getprop("/systems/apu/egt"))));
		me["APUN-needle"].setRotation((getprop("/ECAM/Lower/APU-N") + 90)*D2R);
		me["APUEGT-needle"].setRotation((getprop("/ECAM/Lower/APU-EGT") + 90)*D2R);

		me.updateBottomStatus();

		settimer(func me.update(), 0.02);
	},
};

var canvas_lowerECAM_eng1 = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_lowerECAM_eng1 , canvas_lowerECAM_base] };
		m.init(canvas_group, file);
		
		return m;
	},
	getKeys: func() {
		return ["OilQT1-needle","OilQT2-needle","OilQT1","OilQT2","OilQT1-decimal","OilQT2-decimal","OilPSI1-needle","OilPSI2-needle","OilPSI1","OilPSI2","GW","TAT","SAT"];
	},
	update: func() {
		# Oil Quantity
		me["OilQT1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/oil-qt-actual"))));
		me["OilQT2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/oil-qt-actual"))));
		me["OilQT1-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/oil-qt-actual"),1))));
		me["OilQT2-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[1]/oil-qt-actual"),1))));
		
		me["OilQT1-needle"].setRotation((getprop("/ECAM/Lower/Oil-QT[0]") + 90)*D2R);
		me["OilQT2-needle"].setRotation((getprop("/ECAM/Lower/Oil-QT[1]") + 90)*D2R);
		
		# Oil Pressure
		if (getprop("/engines/engine[0]/oil-psi-actual") >= 20) {
			me["OilPSI1"].setColor(0,1,0);
			me["OilPSI1-needle"].setColorFill(0,1,0);
		} else {
			me["OilPSI1"].setColor(1,0,0);
			me["OilPSI1-needle"].setColorFill(1,0,0);
		}
		
		if (getprop("/engines/engine[1]/oil-psi-actual") >= 20) {
			me["OilPSI2"].setColor(0,1,0);
			me["OilPSI2-needle"].setColorFill(0,1,0);
		} else {
			me["OilPSI2"].setColor(1,0,0);
			me["OilPSI2-needle"].setColorFill(1,0,0);
		}
		
		me["OilPSI1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/oil-psi-actual"))));
		me["OilPSI2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/oil-psi-actual"))));
		
		me["OilPSI1-needle"].setRotation((getprop("/ECAM/Lower/Oil-PSI[0]") + 90)*D2R);
		me["OilPSI2-needle"].setRotation((getprop("/ECAM/Lower/Oil-PSI[1]") + 90)*D2R);
		
		me.updateBottomStatus();
		
		settimer(func me.update(), 0.02);
	},     
};

var canvas_lowerECAM_eng = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_lowerECAM_eng , canvas_lowerECAM_base] };
		m.init(canvas_group, file);
		
		return m;
	},
	getKeys: func() {
		return ["OilQT1-needle","OilQT2-needle","OilQT1","OilQT2","OilQT1-decimal","OilQT2-decimal","OilPSI1-needle","OilPSI2-needle","OilPSI1","OilPSI2","GW","TAT","SAT"];
	},
	update: func() {
		# Oil Quantity
		me["OilQT1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/oil-qt-actual"))));
		me["OilQT2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/oil-qt-actual"))));
		me["OilQT1-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/oil-qt-actual"),1))));
		me["OilQT2-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[1]/oil-qt-actual"),1))));
		
		me["OilQT1-needle"].setRotation((getprop("/ECAM/Lower/Oil-QT[0]") + 90)*D2R);
		me["OilQT2-needle"].setRotation((getprop("/ECAM/Lower/Oil-QT[1]") + 90)*D2R);
		
		# Oil Pressure
		if (getprop("/engines/engine[0]/oil-psi-actual") >= 20) {
			me["OilPSI1"].setColor(0,1,0);
			me["OilPSI1-needle"].setColorFill(0,1,0);
		} else {
			me["OilPSI1"].setColor(1,0,0);
			me["OilPSI1-needle"].setColorFill(1,0,0);
		}
		
		if (getprop("/engines/engine[1]/oil-psi-actual") >= 20) {
			me["OilPSI2"].setColor(0,1,0);
			me["OilPSI2-needle"].setColorFill(0,1,0);
		} else {
			me["OilPSI2"].setColor(1,0,0);
			me["OilPSI2-needle"].setColorFill(1,0,0);
		}
		
		me["OilPSI1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/oil-psi-actual"))));
		me["OilPSI2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/oil-psi-actual"))));
		
		me["OilPSI1-needle"].setRotation((getprop("/ECAM/Lower/Oil-PSI[0]") + 90)*D2R);
		me["OilPSI2-needle"].setRotation((getprop("/ECAM/Lower/Oil-PSI[1]") + 90)*D2R);
		
		me.updateBottomStatus();
		
		settimer(func me.update(), 0.02);
	},
};

setlistener("sim/signals/fdm-initialized", func {
	lowerECAM_display = canvas.new({
		"name": "lowerECAM",
		"size": [1024, 1024],
		"view": [1024, 1024],
		"mipmapping": 1
	});
	lowerECAM_display.addPlacement({"node": "lecam.screen"});
	var groupApu = lowerECAM_display.createGroup();
	var groupEng1 = lowerECAM_display.createGroup();
	var groupEng = lowerECAM_display.createGroup();

	lowerECAM_apu = canvas_lowerECAM_apu.new(groupApu, "Aircraft/A320Family/Models/Instruments/Lower-ECAM/res/apu.svg");
	lowerECAM_eng1 = canvas_lowerECAM_eng1.new(groupEng1, "Aircraft/A320Family/Models/Instruments/Lower-ECAM/res/eng-eis1.svg");
	lowerECAM_eng = canvas_lowerECAM_eng.new(groupEng, "Aircraft/A320Family/Models/Instruments/Lower-ECAM/res/eng-eis2.svg");

	lowerECAM_apu.update();
	lowerECAM_eng1.update();
	lowerECAM_eng.update();
	lowerECAM_apu.page.hide();
	lowerECAM_eng_choose();
});

var showLowerECAM = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(lowerECAM_display);
}

var setLowerECAMPage = func(page) {
	if (page == "apu") {
		lowerECAM_apu.page.show();
		lowerECAM_eng1.page.hide();
		lowerECAM_eng.page.hide();
	} else if (page == "eng") {
		lowerECAM_apu.page.hide();
		lowerECAM_eng_choose();
	}
}

var lowerECAM_eng_choose = func {
	if (getprop("/options/EIS2") == 1) {
		lowerECAM_eng1.page.hide();
		lowerECAM_eng.page.show();
	} else {
		lowerECAM_eng1.page.show();
		lowerECAM_eng.page.hide();
	}
}

setlistener("/options/EIS2", lowerECAM_eng_choose);
