# A3XX Lower ECAM Canvas
# Joshua Davidson (it0uchpods)

#########################################
# Copyright (c) it0uchpods Design Group #
#########################################

var lowerECAM_apu = nil;
var lowerECAM_eng = nil;
var lowerECAM_fctl = nil;
var lowerECAM_wheel = nil;
var lowerECAM_elec = nil;
var lowerECAM_display = nil;
var page = "eng";
var oat = getprop("/environment/temperature-degc");
var blue_psi = 0;
var green_psi = 0;
var yellow_psi = 0;
var autobrakemode = 0;
var nosegear = 0;
var leftgear = 0;
var rightgear = 0;
var leftdoor = 0;
var rightdoor = 0;
var nosedoor = 0;
var gearlvr = 0;
var askidsw = 0;
var brakemode = 0;
var accum = 0;

setprop("/systems/electrical/extra/apu-load", 0);
setprop("/systems/electrical/extra/apu-volts", 0);
setprop("/systems/electrical/extra/apu-hz", 0);
setprop("/systems/electrical/bat1direction", 0);
setprop("/systems/electrical/bat2direction", 0);
setprop("/ECAM/Lower/bat1-contactrotation", 0);
setprop("/ECAM/Lower/bat2-contactrotation", 0);
setprop("/systems/pneumatic/bleedapu", 0);
setprop("/engines/engine[0]/oil-psi-actual", 0);
setprop("/engines/engine[1]/oil-psi-actual", 0);
setprop("/ECAM/Lower/door-left", 0);
setprop("/ECAM/Lower/door-right", 0);
setprop("/ECAM/Lower/door-nose-left", 0);
setprop("/ECAM/Lower/door-nose-right", 0);
setprop("/ECAM/Lower/APU-N", 0);
setprop("/ECAM/Lower/APU-EGT", 0);
setprop("/ECAM/Lower/Oil-QT[0]", 0);
setprop("/ECAM/Lower/Oil-QT[1]", 0);
setprop("/ECAM/Lower/Oil-PSI[0]", 0);
setprop("/ECAM/Lower/Oil-PSI[1]", 0);
setprop("/ECAM/Lower/aileron-ind-left", 0);
setprop("/ECAM/Lower/aileron-ind-right", 0);
setprop("/ECAM/Lower/elevator-ind-left", 0);
setprop("/ECAM/Lower/elevator-ind-right", 0);
setprop("/ECAM/Lower/elevator-trim-deg", 0);
setprop("/controls/flight/rudder-fdm", 0);
setprop("/environment/temperature-degc", 0);
setprop("/FMGC/internal/gw", 0);
setprop("/controls/flight/spoiler-l1-failed", 0);
setprop("/controls/flight/spoiler-l2-failed", 0);
setprop("/controls/flight/spoiler-l3-failed", 0);
setprop("/controls/flight/spoiler-l4-failed", 0);
setprop("/controls/flight/spoiler-l5-failed", 0);
setprop("/controls/flight/spoiler-r1-failed", 0);
setprop("/controls/flight/spoiler-r2-failed", 0);
setprop("/controls/flight/spoiler-r3-failed", 0);
setprop("/controls/flight/spoiler-r4-failed", 0);
setprop("/controls/flight/spoiler-r5-failed", 0);

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
		if (getprop("/systems/electrical/bus/ac1") >= 110 and getprop("/systems/electrical/bus/ac2") >= 110 and getprop("/controls/electrical/switches/emer-gen") != 1) {
			page = getprop("/ECAM/Lower/page");
			if (page == "apu") {
				lowerECAM_apu.page.show();
				lowerECAM_eng.page.hide();
				lowerECAM_fctl.page.hide();
				lowerECAM_wheel.page.hide();
				lowerECAM_apu.update();
			} else if (page == "eng") {
				lowerECAM_apu.page.hide();
				lowerECAM_eng.page.show();
				lowerECAM_eng.update();
				lowerECAM_fctl.page.hide();
				lowerECAM_wheel.page.hide();
			} else if (page == "fctl") {
				lowerECAM_apu.page.hide();
				lowerECAM_eng.page.hide();
				lowerECAM_fctl.page.show();
				lowerECAM_wheel.page.hide();
				lowerECAM_fctl.update();
			} else if (page == "wheel") {
				lowerECAM_apu.page.hide();
				lowerECAM_eng.page.hide();
				lowerECAM_fctl.page.hide();
				lowerECAM_wheel.page.show();
				lowerECAM_wheel.update();
			} else if (page == "elec") {
				lowerECAM_apu.page.hide();
				lowerECAM_eng.page.hide();
				lowerECAM_fctl.page.hide();
				lowerECAM_wheel.page.hide();
				lowerECAM_elec.page.show();
				lowerECAM_elec.update();
			} else {
				lowerECAM_apu.page.hide();
				lowerECAM_eng.page.hide();
				lowerECAM_fctl.page.hide();
				lowerECAM_wheel.page.hide();
				lowerECAM_elec.page.hide();
			}
		} else {
			lowerECAM_apu.page.hide();
			lowerECAM_eng.page.hide();
			lowerECAM_fctl.page.hide();
			lowerECAM_wheel.page.hide();
			lowerECAM_elec.page.hide();
		}
	},
	updateBottomStatus: func() {
		me["TAT"].setText(sprintf("%s", math.round(getprop("/environment/temperature-degc"))));
		me["SAT"].setText(sprintf("%s", math.round(getprop("/environment/temperature-degc"))));
		me["GW"].setText(sprintf("%s", math.round(getprop("/FMGC/internal/gw"))));
	},
};

var canvas_lowerECAM_apu = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_apu, canvas_lowerECAM_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["TAT","SAT","GW","APUN-needle","APUEGT-needle","APUN","APUEGT","APUAvail","APUFlapOpen","APUBleedValve","APUBleedOnline","APUGenOnline","APUGentext","APUGenLoad","APUGenbox","APUGenVolt","APUGenHz","APUBleedPSI","APUfuelLO","text3724","text3728",
		"text3732"];
	},
	update: func() {
		oat = getprop("/environment/temperature-degc");
		
		# Avail and Flap Open
		if (getprop("/systems/apu/flap") == 1) {
			me["APUFlapOpen"].show();
		} else {
			me["APUFlapOpen"].hide();
		}

		if (getprop("/systems/apu/rpm") > 94.9) {
			me["APUAvail"].show();
		} else {
			me["APUAvail"].hide();
		}
		
		if (getprop("/fdm/jsbsim/propulsion/tank[2]/contents-lbs") < 100) {
			me["APUfuelLO"].show();
		} else {
			me["APUfuelLO"].hide();
		}
		
		# APU Gen
		if (getprop("/systems/electrical/extra/apu-volts") > 110) {
			me["APUGenVolt"].setColor(0.0667,0.9450,0.3686);
		} else {
			me["APUGenVolt"].setColor(0.7333,0.3803,0);
		}

		if (getprop("/systems/electrical/extra/apu-hz") > 380) {
			me["APUGenHz"].setColor(0.0667,0.9450,0.3686);
		} else {
			me["APUGenHz"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/controls/APU/master") == 1 or getprop("/systems/apu/rpm") >= 94.9) {
			me["APUGenbox"].show();
			me["APUGenHz"].show();
			me["APUGenVolt"].show();
			me["APUGenLoad"].show();
			me["text3724"].show();
			me["text3728"].show();
			me["text3732"].show();
		} else {
			me["APUGenbox"].hide();
			me["APUGenHz"].hide();
			me["APUGenVolt"].hide();
			me["APUGenLoad"].hide();
			me["text3724"].hide();
			me["text3728"].hide();
			me["text3732"].hide();
		}
		
		if ((getprop("/systems/apu/rpm") > 94.9) and (getprop("/controls/electrical/switches/gen-apu") == 1)) {
			me["APUGenOnline"].show();
		} else {
			me["APUGenOnline"].hide();
		}
		
		if ((getprop("/controls/APU/master") == 0) or ((getprop("/controls/APU/master") == 1) and (getprop("/controls/electrical/switches/gen-apu") == 1) and (getprop("/systems/apu/rpm") > 94.9))) {
			me["APUGentext"].setColor(0.8078,0.8039,0.8078);
		} else if ((getprop("/controls/APU/master") == 1) and (getprop("/controls/electrical/switches/gen-apu") == 0) and (getprop("/systems/apu/rpm") < 94.9)) { 
			me["APUGentext"].setColor(0.7333,0.3803,0);
		}

		me["APUGenLoad"].setText(sprintf("%s", math.round(getprop("/systems/electrical/extra/apu-load"))));
		me["APUGenVolt"].setText(sprintf("%s", math.round(getprop("/systems/electrical/extra/apu-volts"))));
		me["APUGenHz"].setText(sprintf("%s", math.round(getprop("/systems/electrical/extra/apu-hz"))));

		# APU Bleed
		if (getprop("/controls/adirs/ir[1]/knob") != 1 and (getprop("/controls/APU/master") == 1 or getprop("/systems/pneumatic/bleedapu") > 0)) {
			me["APUBleedPSI"].setColor(0.0667,0.9450,0.3686);
			me["APUBleedPSI"].setText(sprintf("%s", math.round(getprop("/systems/pneumatic/bleedapu"))));
		} else {
			me["APUBleedPSI"].setColor(0.7333,0.3803,0);
			me["APUBleedPSI"].setText(sprintf("%s", "XX"));
		}

		if (getprop("/controls/pneumatic/switches/bleedapu") == 1) {
			me["APUBleedValve"].setRotation(90 * D2R);
			me["APUBleedOnline"].show();
		} else {
			me["APUBleedValve"].setRotation(0);
			me["APUBleedOnline"].hide();
		}

		# APU N and EGT
		if (getprop("/controls/APU/master") == 1) {
			me["APUN"].setColor(0.0667,0.9450,0.3686);
			me["APUN"].setText(sprintf("%s", math.round(getprop("/systems/apu/rpm"))));
			me["APUEGT"].setColor(0.0667,0.9450,0.3686);
			me["APUEGT"].setText(sprintf("%s", math.round(getprop("/systems/apu/egt"))));
		} else if (getprop("/systems/apu/rpm") >= 1) {
			me["APUN"].setColor(0.0667,0.9450,0.3686);
			me["APUN"].setText(sprintf("%s", math.round(getprop("/systems/apu/rpm"))));
			me["APUEGT"].setColor(0.0667,0.9450,0.3686);
			me["APUEGT"].setText(sprintf("%s", math.round(getprop("/systems/apu/egt"))));
		} else {
			me["APUN"].setColor(0.7333,0.3803,0);
			me["APUN"].setText(sprintf("%s", "XX"));
			me["APUEGT"].setColor(0.7333,0.3803,0);
			me["APUEGT"].setText(sprintf("%s", "XX"));
		}
		me["APUN-needle"].setRotation((getprop("/ECAM/Lower/APU-N") + 90) * D2R);
		me["APUEGT-needle"].setRotation((getprop("/ECAM/Lower/APU-EGT") + 90) * D2R);

		me.updateBottomStatus();
	},
};

var canvas_lowerECAM_eng = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_eng, canvas_lowerECAM_base]};
		m.init(canvas_group, file);
		
		return m;
	},
	getKeys: func() {
		return ["TAT","SAT","GW","OilQT1-needle","OilQT2-needle","OilQT1","OilQT2","OilQT1-decimal","OilQT2-decimal","OilPSI1-needle","OilPSI2-needle","OilPSI1","OilPSI2"];
	},
	update: func() {
		# Oil Quantity
		me["OilQT1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/oil-qt-actual"))));
		me["OilQT2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/oil-qt-actual"))));
		me["OilQT1-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[0]/oil-qt-actual"),1))));
		me["OilQT2-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/engines/engine[1]/oil-qt-actual"),1))));
		
		me["OilQT1-needle"].setRotation((getprop("/ECAM/Lower/Oil-QT[0]") + 90) * D2R);
		me["OilQT2-needle"].setRotation((getprop("/ECAM/Lower/Oil-QT[1]") + 90) * D2R);
		
		# Oil Pressure
		if (getprop("/engines/engine[0]/oil-psi-actual") >= 20) {
			me["OilPSI1"].setColor(0.0667,0.9450,0.3686);
			me["OilPSI1-needle"].setColorFill(0.0667,0.9450,0.3686);
		} else {
			me["OilPSI1"].setColor(1,0,0);
			me["OilPSI1-needle"].setColorFill(1,0,0);
		}
		
		if (getprop("/engines/engine[1]/oil-psi-actual") >= 20) {
			me["OilPSI2"].setColor(0.0667,0.9450,0.3686);
			me["OilPSI2-needle"].setColorFill(0.0667,0.9450,0.3686);
		} else {
			me["OilPSI2"].setColor(1,0,0);
			me["OilPSI2-needle"].setColorFill(1,0,0);
		}
		
		me["OilPSI1"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/oil-psi-actual"))));
		me["OilPSI2"].setText(sprintf("%s", math.round(getprop("/engines/engine[1]/oil-psi-actual"))));
		
		me["OilPSI1-needle"].setRotation((getprop("/ECAM/Lower/Oil-PSI[0]") + 90) * D2R);
		me["OilPSI2-needle"].setRotation((getprop("/ECAM/Lower/Oil-PSI[1]") + 90) * D2R);
		
		me.updateBottomStatus();
	},
};


var canvas_lowerECAM_fctl = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_fctl, canvas_lowerECAM_base]};
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return["TAT","SAT","GW","ailL","ailR","elevL","elevR","PTcc","PT","PTupdn","elac1","elac2","sec1","sec2","sec3","ailLblue","ailRblue","elevLblue","elevRblue","rudderblue","ailLgreen","ailRgreen","elevLgreen","ruddergreen","PTgreen","elevRyellow",
		"rudderyellow","PTyellow","rudder","spdbrkblue","spdbrkgreen","spdbrkyellow","spoiler1Rex","spoiler1Rrt","spoiler2Rex","spoiler2Rrt","spoiler3Rex","spoiler3Rrt","spoiler4Rex","spoiler4Rrt","spoiler5Rex","spoiler5Rrt","spoiler1Lex","spoiler1Lrt",
		"spoiler2Lex","spoiler2Lrt","spoiler3Lex","spoiler3Lrt","spoiler4Lex","spoiler4Lrt","spoiler5Lex","spoiler5Lrt","spoiler1Rf","spoiler2Rf","spoiler3Rf","spoiler4Rf","spoiler5Rf","spoiler1Lf","spoiler2Lf","spoiler3Lf","spoiler4Lf","spoiler5Lf",
		"ailLscale","ailRscale","path4249","path4249-3","path4249-3-6-7","path4249-3-6-7-5","path4249-3-6"];
	},
	update: func() {
		blue_psi = getprop("/systems/hydraulic/blue-psi");
		green_psi = getprop("/systems/hydraulic/green-psi");
		yellow_psi = getprop("/systems/hydraulic/yellow-psi");
		
		# Pitch Trim
		me["PT"].setText(sprintf("%2.1f", getprop("/ECAM/Lower/elevator-trim-deg")));

		if (getprop("/controls/flight/elevator-trim") <= 0) {
			me["PTupdn"].setText(sprintf("UP"));
		} else if (getprop("/controls/flight/elevator-trim") > 0) {
			me["PTupdn"].setText(sprintf("DN"));
		}

		if (green_psi < 1500 and yellow_psi < 1500) {
			me["PT"].setColor(0.7333,0.3803,0);
			me["PTupdn"].setColor(0.7333,0.3803,0);
			me["PTcc"].setColor(0.7333,0.3803,0);
		} else {
			me["PT"].setColor(0.0667,0.9450,0.3686);
			me["PTupdn"].setColor(0.0667,0.9450,0.3686);
			me["PTcc"].setColor(0.0667,0.9450,0.3686);
		}
		
		# Ailerons
		me["ailL"].setTranslation(0,getprop("/ECAM/Lower/aileron-ind-left")*100);
		me["ailR"].setTranslation(0,getprop("/ECAM/Lower/aileron-ind-right")*(-100));
			
		if (blue_psi < 1500 and green_psi < 1500) {
			me["ailL"].setColor(0.7333,0.3803,0);
			me["ailR"].setColor(0.7333,0.3803,0);
		} else {
			me["ailL"].setColor(0.0667,0.9450,0.3686);
			me["ailR"].setColor(0.0667,0.9450,0.3686);
		}
		
		# Elevators
		me["elevL"].setTranslation(0,getprop("/ECAM/Lower/elevator-ind-left")*100);
		me["elevR"].setTranslation(0,getprop("/ECAM/Lower/elevator-ind-right")*100);

		if (blue_psi < 1500 and green_psi < 1500) {
			me["elevL"].setColor(0.7333,0.3803,0);
		} else {
			me["elevL"].setColor(0.0667,0.9450,0.3686);
		}
		
		if (blue_psi < 1500 and yellow_psi < 1500) {
			me["elevR"].setColor(0.7333,0.3803,0);
		} else {
			me["elevR"].setColor(0.0667,0.9450,0.3686);
		}
		
		# Rudder
		me["rudder"].setRotation(getprop("/controls/flight/rudder-fdm")*(-0.6));

		if (blue_psi < 1500 and yellow_psi < 1500 and green_psi < 1500) {
			me["rudder"].setColor(0.7333,0.3803,0);
		} else {
			me["rudder"].setColor(0.0667,0.9450,0.3686);
		}
		
		# Spoilers
		if (getprop("/controls/flight/spoiler-l1") < 0.033) {
			me["spoiler1Lex"].hide();
			me["spoiler1Lrt"].show();
		} else {
			me["spoiler1Lrt"].hide();
			me["spoiler1Lex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-l2") < 0.033) {
			me["spoiler2Lex"].hide();
			me["spoiler2Lrt"].show();
		} else {
			me["spoiler2Lrt"].hide();
			me["spoiler2Lex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-l3") < 0.033) {
			me["spoiler3Lex"].hide();
			me["spoiler3Lrt"].show();
		} else {
			me["spoiler3Lrt"].hide();
			me["spoiler3Lex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-l4") < 0.033) {
			me["spoiler4Lex"].hide();
			me["spoiler4Lrt"].show();
		} else {
			me["spoiler4Lrt"].hide();
			me["spoiler4Lex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-l5") < 0.033) {
			me["spoiler5Lex"].hide();
			me["spoiler5Lrt"].show();
		} else {
			me["spoiler5Lrt"].hide();
			me["spoiler5Lex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-r1") < 0.033) {
			me["spoiler1Rex"].hide();
			me["spoiler1Rrt"].show();
		} else {
			me["spoiler1Rrt"].hide();
			me["spoiler1Rex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-r2") < 0.033) {
			me["spoiler2Rex"].hide();
			me["spoiler2Rrt"].show();
		} else {
			me["spoiler2Rrt"].hide();
			me["spoiler2Rex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-r3") < 0.033) {
			me["spoiler3Rex"].hide();
			me["spoiler3Rrt"].show();
		} else {
			me["spoiler3Rrt"].hide();
			me["spoiler3Rex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-r4") < 0.033) {
			me["spoiler4Rex"].hide();
			me["spoiler4Rrt"].show();
		} else {
			me["spoiler4Rrt"].hide();
			me["spoiler4Rex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-r5") < 0.033) {
			me["spoiler5Rex"].hide();
			me["spoiler5Rrt"].show();
		} else {
			me["spoiler5Rrt"].hide();
			me["spoiler5Rex"].show();
		}
		
		# Spoiler Fail
		if (getprop("/controls/flight/spoiler-l1-failed") or green_psi < 1500) {
			me["spoiler1Lex"].setColor(0.7333,0.3803,0);
			me["spoiler1Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-l1") < 0.033) {
				me["spoiler1Lf"].show();
			} else {
				me["spoiler1Lf"].hide();
			}
		} else {
			me["spoiler1Lex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler1Lrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler1Lf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-l2-failed") or yellow_psi < 1500) {
			me["spoiler2Lex"].setColor(0.7333,0.3803,0);
			me["spoiler2Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-l2") < 0.033) {
				me["spoiler2Lf"].show();
			} else {
				me["spoiler2Lf"].hide();
			}
		} else {
			me["spoiler2Lex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler2Lrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler2Lf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-l3-failed") or blue_psi < 1500) {
			me["spoiler3Lex"].setColor(0.7333,0.3803,0);
			me["spoiler3Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-l3") < 0.033) {
				me["spoiler3Lf"].show();
			} else {
				me["spoiler3Lf"].hide();
			}
		} else {
			me["spoiler3Lex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler3Lrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler3Lf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-l4-failed") or yellow_psi < 1500) {
			me["spoiler4Lex"].setColor(0.7333,0.3803,0);
			me["spoiler4Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-l4") < 0.033) {
				me["spoiler4Lf"].show();
			} else {
				me["spoiler4Lf"].hide();
			}
		} else {
			me["spoiler4Lex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler4Lrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler4Lf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-l5-failed") or green_psi < 1500) {
			me["spoiler5Lex"].setColor(0.7333,0.3803,0);
			me["spoiler5Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-l5") < 0.033) {
				me["spoiler5Lf"].show();
			} else {
				me["spoiler5Lf"].hide();
			}
		} else {
			me["spoiler5Lex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler5Lrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler5Lf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-r1-failed") or green_psi < 1500) {
			me["spoiler1Rex"].setColor(0.7333,0.3803,0);
			me["spoiler1Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-r1") < 0.033) {
				me["spoiler1Rf"].show();
			} else {
				me["spoiler1Rf"].hide();
			}
		} else {
			me["spoiler1Rex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler1Rrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler1Rf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-r2-failed") or yellow_psi < 1500) {
			me["spoiler2Rex"].setColor(0.7333,0.3803,0);
			me["spoiler2Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-r2") < 0.033) {
				me["spoiler2Rf"].show();
			} else {
				me["spoiler2Rf"].hide();
			}
		} else {
			me["spoiler2Rex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler2Rrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler2Rf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-r3-failed") or blue_psi < 1500) {
			me["spoiler3Rex"].setColor(0.7333,0.3803,0);
			me["spoiler3Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-r3") < 0.033) {
				me["spoiler3Rf"].show();
			} else {
				me["spoiler3Rf"].hide();
			}
		} else {
			me["spoiler3Rex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler3Rrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler3Rf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-r4-failed") or yellow_psi < 1500) {
			me["spoiler4Rex"].setColor(0.7333,0.3803,0);
			me["spoiler4Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-r4") < 0.033) {
				me["spoiler4Rf"].show();
			} else {
				me["spoiler4Rf"].hide();
			}
		} else {
			me["spoiler4Rex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler4Rrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler4Rf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-r5-failed") or green_psi < 1500) {
			me["spoiler5Rex"].setColor(0.7333,0.3803,0);
			me["spoiler5Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-r5") < 0.033) {
				me["spoiler5Rf"].show();
			} else {
				me["spoiler5Rf"].hide();
			}
		} else {
			me["spoiler5Rex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler5Rrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler5Rf"].hide();
		}
		
		# Flight Computers		
		if (getprop("/systems/fctl/elac1")) {
			me["elac1"].setColor(0.0667,0.9450,0.3686);
			me["path4249"].setColor(0.0667,0.9450,0.3686);
		} else if ((getprop("/systems/fctl/elac1") == 0) or (getprop("/systems/failures/elac1") == 1)) {
			me["elac1"].setColor(0.7333,0.3803,0);
			me["path4249"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/fctl/elac2")) {
			me["elac2"].setColor(0.0667,0.9450,0.3686);
			me["path4249-3"].setColor(0.0667,0.9450,0.3686);
		} else if ((getprop("/systems/fctl/elac2") == 0) or (getprop("/systems/failures/elac2") == 1)) {
			me["elac2"].setColor(0.7333,0.3803,0);
			me["path4249-3"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/fctl/sec1")) {
			me["sec1"].setColor(0.0667,0.9450,0.3686);
			me["path4249-3-6-7"].setColor(0.0667,0.9450,0.3686);
		} else if ((getprop("/systems/fctl/sec1") == 0) or (getprop("/systems/failures/sec1") == 1)) {
			me["sec1"].setColor(0.7333,0.3803,0);
			me["path4249-3-6-7"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/fctl/sec2")) {
			me["sec2"].setColor(0.0667,0.9450,0.3686);
			me["path4249-3-6-7-5"].setColor(0.0667,0.9450,0.3686);
		} else if ((getprop("/systems/fctl/sec2") == 0) or (getprop("/systems/failures/sec2") == 1)) {
			me["sec2"].setColor(0.7333,0.3803,0);
			me["path4249-3-6-7-5"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/fctl/sec3")) {
			me["sec3"].setColor(0.0667,0.9450,0.3686);
			me["path4249-3-6"].setColor(0.0667,0.9450,0.3686);
		} else if ((getprop("/systems/fctl/sec3") == 0) or (getprop("/systems/failures/sec3") == 1)) {
			me["sec3"].setColor(0.7333,0.3803,0);
			me["path4249-3-6"].setColor(0.7333,0.3803,0);
		}
		
		# Hydraulic Indicators
		if (getprop("/systems/hydraulic/blue-psi") >= 1500) {
			me["ailLblue"].setColor(0.0667,0.9450,0.3686);
			me["ailRblue"].setColor(0.0667,0.9450,0.3686);
			me["elevLblue"].setColor(0.0667,0.9450,0.3686);
			me["elevRblue"].setColor(0.0667,0.9450,0.3686);
			me["rudderblue"].setColor(0.0667,0.9450,0.3686);
			me["spdbrkblue"].setColor(0.0667,0.9450,0.3686);
		} else {
			me["ailLblue"].setColor(0.7333,0.3803,0);
			me["ailRblue"].setColor(0.7333,0.3803,0);
			me["elevLblue"].setColor(0.7333,0.3803,0);
			me["elevRblue"].setColor(0.7333,0.3803,0);
			me["rudderblue"].setColor(0.7333,0.3803,0);
			me["spdbrkblue"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/hydraulic/green-psi") >= 1500) {
			me["ailLgreen"].setColor(0.0667,0.9450,0.3686);
			me["ailRgreen"].setColor(0.0667,0.9450,0.3686);
			me["elevLgreen"].setColor(0.0667,0.9450,0.3686);
			me["ruddergreen"].setColor(0.0667,0.9450,0.3686);
			me["PTgreen"].setColor(0.0667,0.9450,0.3686);
			me["spdbrkgreen"].setColor(0.0667,0.9450,0.3686);
		} else {
			me["ailLgreen"].setColor(0.7333,0.3803,0);
			me["ailRgreen"].setColor(0.7333,0.3803,0);
			me["elevLgreen"].setColor(0.7333,0.3803,0);
			me["ruddergreen"].setColor(0.7333,0.3803,0);
			me["PTgreen"].setColor(0.7333,0.3803,0);
			me["spdbrkgreen"].setColor(0.7333,0.3803,0);
		}
		
		if (getprop("/systems/hydraulic/yellow-psi") >= 1500) {
			me["elevRyellow"].setColor(0.0667,0.9450,0.3686);
			me["rudderyellow"].setColor(0.0667,0.9450,0.3686);
			me["PTyellow"].setColor(0.0667,0.9450,0.3686);
			me["spdbrkyellow"].setColor(0.0667,0.9450,0.3686);
		} else {
			me["elevRyellow"].setColor(0.7333,0.3803,0);
			me["rudderyellow"].setColor(0.7333,0.3803,0);
			me["PTyellow"].setColor(0.7333,0.3803,0);
			me["spdbrkyellow"].setColor(0.7333,0.3803,0);
		}
		
		me.updateBottomStatus();
	},
};

var canvas_lowerECAM_wheel = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_wheel, canvas_lowerECAM_base]};
		m.init(canvas_group, file);
		
		return m;
	},
	getKeys: func() {
		return ["TAT","SAT","GW","lgctltext","NORMbrk","NWStext","leftdoor","rightdoor","nosegeardoorL","nosegeardoorR","autobrk","autobrkind","NWS","NWSrect","normbrk-rect","altnbrk","normbrkhyd","spoiler1Rex","spoiler1Rrt","spoiler2Rex","spoiler2Rrt","spoiler3Rex","spoiler3Rrt","spoiler4Rex","spoiler4Rrt","spoiler5Rex","spoiler5Rrt","spoiler1Lex","spoiler1Lrt",
		"spoiler2Lex","spoiler2Lrt","spoiler3Lex","spoiler3Lrt","spoiler4Lex","spoiler4Lrt","spoiler5Lex","spoiler5Lrt","spoiler1Rf","spoiler2Rf","spoiler3Rf","spoiler4Rf","spoiler5Rf","spoiler1Lf","spoiler2Lf","spoiler3Lf","spoiler4Lf","spoiler5Lf","ALTNbrk","altnbrkhyd","altnbrk-rect",
		"antiskidtext","brakearrow","accupress_text","accuonlyarrow","accuonly","braketemp1","normbrkhyd","braketemp2","braketemp3","braketemp4","leftuplock","noseuplock","rightuplock","Triangle-Left1","Triangle-Left2","Triangle-Nose1","Triangle-Nose2","Triangle-Right1","Triangle-Right2","BSCUrect1","BSCUrect2","BSCU1","BSCU2"];
	},
	update: func() {
		blue_psi = getprop("/systems/hydraulic/blue-psi");
		green_psi = getprop("/systems/hydraulic/green-psi");
		yellow_psi = getprop("/systems/hydraulic/yellow-psi");
		autobrakemode = getprop("/controls/autobrake/mode");
		nosegear = getprop("gear/gear[0]/position-norm");
		leftgear = getprop("gear/gear[1]/position-norm");
		rightgear = getprop("gear/gear[2]/position-norm");
		leftdoor = getprop("/systems/hydraulic/gear/door-left");
		rightdoor = getprop("/systems/hydraulic/gear/door-right");
		nosedoor = getprop("/systems/hydraulic/gear/door-nose");
		gearlvr = getprop("/controls/gear/gear-down");
		askidsw = getprop("/systems/hydraulic/brakes/askidnwssw");
		brakemode = getprop("/systems/hydraulic/brakes/mode");
		accum = getprop("/systems/hydraulic/brakes/accumulator-pressure-psi");
		
		# L/G CTL
		if ((leftgear == 0 or nosegear == 0 or rightgear == 0 and gearlvr == 0) or (leftgear == 1 or nosegear == 1 or rightgear == 1 and gearlvr == 1)) {
			me["lgctltext"].hide();
		} else {
			me["lgctltext"].show();
		}
		
		# NWS / Antiskid / Brakes
		if (askidsw and yellow_psi >= 1500) {
			me["NWStext"].hide();
			me["NWS"].hide();
			me["NWSrect"].hide();
			me["antiskidtext"].hide();
			me["BSCUrect1"].hide();
			me["BSCUrect2"].hide();
			me["BSCU1"].hide();
			me["BSCU2"].hide();
		} else if (!askidsw and yellow_psi >= 1500) {
			me["NWStext"].show();
			me["NWS"].show();
			me["NWS"].setColor(0.0667,0.9450,0.3686);
			me["NWSrect"].show();
			me["antiskidtext"].show();
			me["antiskidtext"].setColor(0.7333,0.3803,0);
			me["BSCUrect1"].show();
			me["BSCUrect2"].show();
			me["BSCU1"].show();
			me["BSCU2"].show();
		} else {
			me["NWStext"].show();
			me["NWS"].show();
			me["NWS"].setColor(0.7333,0.3803,0);
			me["NWSrect"].show();
			me["antiskidtext"].show();
			me["antiskidtext"].setColor(0.7333,0.3803,0);
			me["BSCUrect1"].show();
			me["BSCUrect2"].show();
			me["BSCU1"].show();
			me["BSCU2"].show();
		}
		
		if (green_psi >= 1500 and brakemode == 1) {
			me["NORMbrk"].hide();
			me["normbrk-rect"].hide();
			me["normbrkhyd"].hide();
		} else if (green_psi >= 1500 and askidsw) {
			me["NORMbrk"].show();
			me["normbrk-rect"].show();
			me["NORMbrk"].setColor(0.7333,0.3803,0);
			me["normbrkhyd"].setColor(0.0667,0.9450,0.3686);
		} else if (green_psi < 1500 or !askidsw) {
			me["NORMbrk"].show();
			me["normbrk-rect"].show();
			me["NORMbrk"].setColor(0.7333,0.3803,0);
			me["normbrkhyd"].setColor(0.7333,0.3803,0);
		}
		
		if (brakemode != 2) {
			me["ALTNbrk"].hide();
			me["altnbrk-rect"].hide();
			me["altnbrkhyd"].hide();
		} else if (yellow_psi >= 1500) {
			me["ALTNbrk"].show();
			me["altnbrk-rect"].show();
			me["altnbrkhyd"].setColor(0.0667,0.9450,0.3686);
		} else {
			me["ALTNbrk"].show();
			me["altnbrk-rect"].show();
			me["altnbrkhyd"].setColor(0.7333,0.3803,0);
		}
		
		if (brakemode == 2 and accum < 200 and yellow_psi < 1500) {
			me["accupress_text"].show();
			me["brakearrow"].hide();
			me["accupress_text"].setColor(0.7333,0.3803,0);
		} else if (brakemode == 2 and accum > 200 and yellow_psi >= 1500){
			me["accupress_text"].show();
			me["brakearrow"].show();
			me["accupress_text"].setColor(0.0667,0.9450,0.3686);
		} else if (brakemode == 2 and accum > 200 and yellow_psi < 1500) {
			me["accuonlyarrow"].show();
			me["accuonly"].show();
			me["brakearrow"].hide();
			me["accupress_text"].hide();
		} else {
			me["accuonlyarrow"].hide();
			me["accuonly"].hide();
			me["brakearrow"].hide();
			me["accupress_text"].hide();
		}
		
		# Gear Doors
		me["leftdoor"].setRotation(getprop("/ECAM/Lower/door-left") * D2R);
		me["rightdoor"].setRotation(getprop("/ECAM/Lower/door-right") * D2R);
		me["nosegeardoorL"].setRotation(getprop("/ECAM/Lower/door-nose-left") * D2R);
		me["nosegeardoorR"].setRotation(getprop("/ECAM/Lower/door-nose-right") * D2R);
		
		if (nosedoor == 0) {
			me["nosegeardoorL"].setColorFill(0.0667,0.9450,0.3686);
			me["nosegeardoorR"].setColorFill(0.0667,0.9450,0.3686);
		} else {
			me["nosegeardoorL"].setColorFill(0.7333,0.3803,0);
			me["nosegeardoorR"].setColorFill(0.7333,0.3803,0);
		}
		
		if (leftdoor == 0) {
			me["leftdoor"].setColorFill(0.0667,0.9450,0.3686);
		} else {
			me["leftdoor"].setColorFill(0.7333,0.3803,0);
		}
		
		if (rightdoor == 0) {
			me["rightdoor"].setColorFill(0.0667,0.9450,0.3686);
		} else {
			me["rightdoor"].setColorFill(0.7333,0.3803,0);
		}
		
		# Triangles
		if (leftgear < 0.2 or leftgear > 0.8) {
			me["Triangle-Left1"].hide();
			me["Triangle-Left2"].hide();
		} else {
			me["Triangle-Left1"].show();
			me["Triangle-Left2"].show();
		}
		
		if (leftgear == 1) {
			me["Triangle-Left1"].setColor(0.0667,0.9450,0.3686);
			me["Triangle-Left2"].setColor(0.0667,0.9450,0.3686);
		} else {
			me["Triangle-Left1"].setColor(1,0,0);
			me["Triangle-Left2"].setColor(1,0,0);
		}
		
		if (nosegear < 0.2 or nosegear > 0.8) {
			me["Triangle-Nose1"].hide();
			me["Triangle-Nose2"].hide();
		} else {
			me["Triangle-Nose1"].show();
			me["Triangle-Nose2"].show();
		}
		
		if (nosegear == 1) {
			me["Triangle-Nose1"].setColor(0.0667,0.9450,0.3686);
			me["Triangle-Nose2"].setColor(0.0667,0.9450,0.3686);
		} else {
			me["Triangle-Nose1"].setColor(1,0,0);
			me["Triangle-Nose2"].setColor(1,0,0);
		}
		
		if (rightgear < 0.2 or rightgear > 0.8) {
			me["Triangle-Right1"].hide();
			me["Triangle-Right2"].hide();
		} else {
			me["Triangle-Right1"].show();
			me["Triangle-Right2"].show();
		}
		
		if (rightgear == 1) {
			me["Triangle-Right1"].setColor(0.0667,0.9450,0.3686);
			me["Triangle-Right2"].setColor(0.0667,0.9450,0.3686);
		} else {
			me["Triangle-Right1"].setColor(1,0,0);
			me["Triangle-Right2"].setColor(1,0,0);
		}
		
		# Autobrake
		if (autobrakemode == 0) {
			me["autobrkind"].hide();
		} elsif (autobrakemode == 1) {
			me["autobrkind"].show();
			me["autobrkind"].setText(sprintf("%s", "LO"));
		} elsif (autobrakemode == 2) {
			me["autobrkind"].show();
			me["autobrkind"].setText(sprintf("%s", "MED"));
		} elsif (autobrakemode == 3) {
			me["autobrkind"].show();
			me["autobrkind"].setText(sprintf("%s", "MAX"));
		}
		
		if (getprop("/controls/autobrake/mode") != 0) {
			me["autobrk"].show();
		} elsif (getprop("/controls/autobrake/mode") == 0) {
			me["autobrk"].hide();
		}
		
		# Spoilers
		if (getprop("/controls/flight/spoiler-l1") < 0.033) {
			me["spoiler1Lex"].hide();
			me["spoiler1Lrt"].show();
		} else {
			me["spoiler1Lrt"].hide();
			me["spoiler1Lex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-l2") < 0.033) {
			me["spoiler2Lex"].hide();
			me["spoiler2Lrt"].show();
		} else {
			me["spoiler2Lrt"].hide();
			me["spoiler2Lex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-l3") < 0.033) {
			me["spoiler3Lex"].hide();
			me["spoiler3Lrt"].show();
		} else {
			me["spoiler3Lrt"].hide();
			me["spoiler3Lex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-l4") < 0.033) {
			me["spoiler4Lex"].hide();
			me["spoiler4Lrt"].show();
		} else {
			me["spoiler4Lrt"].hide();
			me["spoiler4Lex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-l5") < 0.033) {
			me["spoiler5Lex"].hide();
			me["spoiler5Lrt"].show();
		} else {
			me["spoiler5Lrt"].hide();
			me["spoiler5Lex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-r1") < 0.033) {
			me["spoiler1Rex"].hide();
			me["spoiler1Rrt"].show();
		} else {
			me["spoiler1Rrt"].hide();
			me["spoiler1Rex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-r2") < 0.033) {
			me["spoiler2Rex"].hide();
			me["spoiler2Rrt"].show();
		} else {
			me["spoiler2Rrt"].hide();
			me["spoiler2Rex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-r3") < 0.033) {
			me["spoiler3Rex"].hide();
			me["spoiler3Rrt"].show();
		} else {
			me["spoiler3Rrt"].hide();
			me["spoiler3Rex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-r4") < 0.033) {
			me["spoiler4Rex"].hide();
			me["spoiler4Rrt"].show();
		} else {
			me["spoiler4Rrt"].hide();
			me["spoiler4Rex"].show();
		}
		
		if (getprop("/controls/flight/spoiler-r5") < 0.033) {
			me["spoiler5Rex"].hide();
			me["spoiler5Rrt"].show();
		} else {
			me["spoiler5Rrt"].hide();
			me["spoiler5Rex"].show();
		}
		
		# Spoiler Fail
		if (getprop("/controls/flight/spoiler-l1-failed") or green_psi < 1500) {
			me["spoiler1Lex"].setColor(0.7333,0.3803,0);
			me["spoiler1Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-l1") < 0.033) {
				me["spoiler1Lf"].show();
			} else {
				me["spoiler1Lf"].hide();
			}
		} else {
			me["spoiler1Lex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler1Lrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler1Lf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-l2-failed") or yellow_psi < 1500) {
			me["spoiler2Lex"].setColor(0.7333,0.3803,0);
			me["spoiler2Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-l2") < 0.033) {
				me["spoiler2Lf"].show();
			} else {
				me["spoiler2Lf"].hide();
			}
		} else {
			me["spoiler2Lex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler2Lrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler2Lf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-l3-failed") or blue_psi < 1500) {
			me["spoiler3Lex"].setColor(0.7333,0.3803,0);
			me["spoiler3Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-l3") < 0.033) {
				me["spoiler3Lf"].show();
			} else {
				me["spoiler3Lf"].hide();
			}
		} else {
			me["spoiler3Lex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler3Lrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler3Lf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-l4-failed") or yellow_psi < 1500) {
			me["spoiler4Lex"].setColor(0.7333,0.3803,0);
			me["spoiler4Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-l4") < 0.033) {
				me["spoiler4Lf"].show();
			} else {
				me["spoiler4Lf"].hide();
			}
		} else {
			me["spoiler4Lex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler4Lrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler4Lf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-l5-failed") or green_psi < 1500) {
			me["spoiler5Lex"].setColor(0.7333,0.3803,0);
			me["spoiler5Lrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-l5") < 0.033) {
				me["spoiler5Lf"].show();
			} else {
				me["spoiler5Lf"].hide();
			}
		} else {
			me["spoiler5Lex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler5Lrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler5Lf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-r1-failed") or green_psi < 1500) {
			me["spoiler1Rex"].setColor(0.7333,0.3803,0);
			me["spoiler1Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-r1") < 0.033) {
				me["spoiler1Rf"].show();
			} else {
				me["spoiler1Rf"].hide();
			}
		} else {
			me["spoiler1Rex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler1Rrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler1Rf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-r2-failed") or yellow_psi < 1500) {
			me["spoiler2Rex"].setColor(0.7333,0.3803,0);
			me["spoiler2Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-r2") < 0.033) {
				me["spoiler2Rf"].show();
			} else {
				me["spoiler2Rf"].hide();
			}
		} else {
			me["spoiler2Rex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler2Rrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler2Rf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-r3-failed") or blue_psi < 1500) {
			me["spoiler3Rex"].setColor(0.7333,0.3803,0);
			me["spoiler3Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-r3") < 0.033) {
				me["spoiler3Rf"].show();
			} else {
				me["spoiler3Rf"].hide();
			}
		} else {
			me["spoiler3Rex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler3Rrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler3Rf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-r4-failed") or yellow_psi < 1500) {
			me["spoiler4Rex"].setColor(0.7333,0.3803,0);
			me["spoiler4Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-r4") < 0.033) {
				me["spoiler4Rf"].show();
			} else {
				me["spoiler4Rf"].hide();
			}
		} else {
			me["spoiler4Rex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler4Rrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler4Rf"].hide();
		}
		
		if (getprop("/controls/flight/spoiler-r5-failed") or green_psi < 1500) {
			me["spoiler5Rex"].setColor(0.7333,0.3803,0);
			me["spoiler5Rrt"].setColor(0.7333,0.3803,0);
			if (getprop("/controls/flight/spoiler-r5") < 0.033) {
				me["spoiler5Rf"].show();
			} else {
				me["spoiler5Rf"].hide();
			}
		} else {
			me["spoiler5Rex"].setColor(0.0667,0.9450,0.3686);
			me["spoiler5Rrt"].setColor(0.0667,0.9450,0.3686);
			me["spoiler5Rf"].hide();
		}
		
		# Hide not yet implemented stuff
		me["braketemp1"].hide();
		me["braketemp2"].hide();
		me["braketemp3"].hide();
		me["braketemp4"].hide();
		me["leftuplock"].hide();
		me["noseuplock"].hide();
		me["rightuplock"].hide();

		me.updateBottomStatus();
	},
};

var canvas_lowerECAM_elec = {
	new: func(canvas_group, file) {
		var m = {parents: [canvas_lowerECAM_elec, canvas_lowerECAM_base]};
		m.init(canvas_group, file);
		
		return m;
	},
	getKeys: func() {
		return ["TAT","SAT","GW","BAT1connectorA","BAT1connectorB","BAT2connectorA","BAT2connectorB","BAT1volts","BAT1amps","BAT1v","BAT1a","BAT1off","BAT2volts","BAT2amps","BAT2v","BAT2a","BAT2off","TR1volts","TR1amps","TR2volts","TR2amps","EMERGENvolts","EXTvolts","EXThz",
				"DCbattext","ESSTRvolts","ESSTRv","ESSTRamps","ESSTRa","ESSTRvolts","ESSTRbox","EMERGENtoESSTRarrow","ESSTRtoDCESSline"];
	},
	update: func() {
		if (getprop("/controls/electrical/switches/battery1") == 0) {
			me["BAT1volts"].hide();
			me["BAT1amps"].hide();
			me["BAT1v"].hide();
			me["BAT1a"].hide();
			me["BAT1off"].show();
		} else {
			me["BAT1volts"].show();
			me["BAT1amps"].show();
			me["BAT1v"].show();
			me["BAT1a"].show();
			me["BAT1off"].hide();
		}
		if (getprop("/controls/electrical/switches/battery2") == 0) {
			me["BAT2volts"].hide();
			me["BAT2amps"].hide();
			me["BAT2v"].hide();
			me["BAT2a"].hide();
			me["BAT2off"].show();
		} else {
			me["BAT2volts"].show();
			me["BAT2amps"].show();
			me["BAT2v"].show();
			me["BAT2a"].show();
			me["BAT2off"].hide();
		}
		
		if (getprop("/systems/electrical/battery1-contact") == 0 and getprop("/systems/electrical/bat1direction") == 0) {
			me["BAT1connectorA"].hide();
			me["BAT1connectorB"].hide();
		} else if (getprop("/systems/electrical/battery1-contact") == 1 and getprop("/systems/electrical/bat1direction") == -1) {
			me["BAT1connectorA"].hide();
			me["BAT1connectorB"].show();
			me["BAT1connectorB"].setRotation(getprop("/ECAM/Lower/bat1-contactrotation") * D2R);
		} else if (getprop("/systems/electrical/battery1-contact") == 1 and getprop("/systems/electrical/bat1direction") == 2) {
			me["BAT1connectorA"].show();
			me["BAT1connectorB"].hide();
		} else if (getprop("/systems/electrical/battery1-contact") == 1 and getprop("/systems/electrical/bat1direction") == 1) {
			me["BAT1connectorA"].hide();
			me["BAT1connectorB"].show();
			me["BAT1connectorB"].setRotation(getprop("/ECAM/Lower/bat2-contactrotation") * D2R);
		}
		
		if (getprop("/systems/electrical/battery2-contact") == 0 and getprop("/systems/electrical/bat2direction") == 0) {
			me["BAT2connectorA"].hide();
			me["BAT2connectorB"].hide();
		} else if (getprop("/systems/electrical/battery2-contact") == 1 and getprop("/systems/electrical/bat2direction") == -1) {
			me["BAT2connectorA"].hide();
			me["BAT2connectorB"].show();
			me["BAT2connectorB"].setRotation(getprop("/ECAM/Lower/bat2-contactrotation") * D2R);
		} else if (getprop("/systems/electrical/battery2-contact") == 1 and getprop("/systems/electrical/bat2direction") == 2) {
			me["BAT2connectorA"].show();
			me["BAT2connectorB"].hide();
		} else if (getprop("/systems/electrical/battery2-contact") == 1 and getprop("/systems/electrical/bat2direction") == 1) {
			me["BAT2connectorA"].hide();
			me["BAT2connectorB"].show();
			me["BAT2connectorB"].setRotation(getprop("/ECAM/Lower/bat2-contactrotation") * D2R);
		}
		
		if (getprop("/systems/electrical/bus/dcbat") < 25) {
			me["DCbattext"].setColor(0.7333,0.3803,0);
		} else {
			me["DCbattext"].setColor(0.0667,0.9450,0.3686);
		}
		
		if (getprop("/systems/electrical/bus/dc1") < 25) {
			me["TR1volts"].setColor(0.7333,0.3803,0);
		} else {
			me["TR1volts"].setColor(0.0667,0.9450,0.3686);
		}
		
		if (getprop("/systems/electrical/bus/dc2") < 25) {
			me["TR2volts"].setColor(0.7333,0.3803,0);
		} else {
			me["TR2volts"].setColor(0.0667,0.9450,0.3686);
		}
		
		if (getprop("/systems/electrical/bus/dc1-amps") <= 5) {
			me["TR1amps"].setColor(0.7333,0.3803,0);
		} else {
			me["TR1amps"].setColor(0.0667,0.9450,0.3686);
		}
		
		if (getprop("/systems/electrical/bus/dc2-amps") <= 5) {
			me["TR2amps"].setColor(0.7333,0.3803,0);
		} else {
			me["TR2amps"].setColor(0.0667,0.9450,0.3686);
		}
		
		me["BAT1volts"].setText(sprintf("%2.0f", getprop("/systems/electrical/battery1-volts")));
		me["BAT2volts"].setText(sprintf("%2.0f", getprop("/systems/electrical/battery2-volts")));
		me["BAT1amps"].setText(sprintf("%3.0f", getprop("/systems/electrical/battery1-amps")));
		me["BAT2amps"].setText(sprintf("%3.0f", getprop("/systems/electrical/battery2-amps")));
		
		me["TR1volts"].setText(sprintf("%2.0f", getprop("/systems/electrical/bus/dc1")));
		me["TR1amps"].setText(sprintf("%2.0f", getprop("/systems/electrical/bus/dc1-amps")));
		me["TR2volts"].setText(sprintf("%2.0f", getprop("/systems/electrical/bus/dc2")));
		me["TR2amps"].setText(sprintf("%2.0f", getprop("/systems/electrical/bus/dc2-amps")));
		
		
		me["EXTvolts"].setText(sprintf("%2.0f", getprop("/systems/electrical/extra/ext-volts")));
		me["EXThz"].setText(sprintf("%2.0f", getprop("/systems/electrical/extra/ext-hz")));
		
		me["ESSTRvolts"].hide();
		me["ESSTRv"].hide();
		me["ESSTRamps"].hide();
		me["ESSTRa"].hide();
		me["ESSTRvolts"].hide();
		me["ESSTRbox"].hide();
		me["EMERGENtoESSTRarrow"].hide();
		me["ESSTRtoDCESSline"].hide();
		me.updateBottomStatus();
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
	var groupEng = lowerECAM_display.createGroup();
	var groupFctl = lowerECAM_display.createGroup();
	var groupWheel = lowerECAM_display.createGroup();
	var groupElec = lowerECAM_display.createGroup();

	lowerECAM_apu = canvas_lowerECAM_apu.new(groupApu, "Aircraft/IDG-A32X/Models/Instruments/Lower-ECAM/res/apu.svg");
	lowerECAM_eng = canvas_lowerECAM_eng.new(groupEng, "Aircraft/IDG-A32X/Models/Instruments/Lower-ECAM/res/eng-eis2.svg");
	lowerECAM_fctl = canvas_lowerECAM_fctl.new(groupFctl, "Aircraft/IDG-A32X/Models/Instruments/Lower-ECAM/res/fctl.svg");
	lowerECAM_wheel = canvas_lowerECAM_wheel.new(groupWheel, "Aircraft/IDG-A32X/Models/Instruments/Lower-ECAM/res/wheel.svg");
	lowerECAM_elec = canvas_lowerECAM_elec.new(groupElec, "Aircraft/IDG-A32X/Models/Instruments/Lower-ECAM/res/elec.svg");
	
	lowerECAM_update.start();
});

var lowerECAM_update = maketimer(0.05, func {
	canvas_lowerECAM_base.update();
});

var showLowerECAM = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(lowerECAM_display);
}
