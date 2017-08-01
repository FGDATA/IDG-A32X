# A3XX Lower ECAM Canvas
# Joshua Davidson (it0uchpods)

#######################################
# Copyright (c) A3XX Development Team #
#######################################

var lowerECAM_apu = nil;
var lowerECAM_eng1 = nil;
var lowerECAM_eng = nil;
var lowerECAM_fctl = nil;
var lowerECAM_display = nil;
var page = "eng";
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
setprop("/ECAM/Lower/elevator-ind-left", 0);
setprop("/ECAM/Lower/elevator-ind-right", 0);
setprop("/ECAM/Lower/elevator-trim-deg", 0);
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
				lowerECAM_eng1.page.hide();
				lowerECAM_eng.page.hide();
				lowerECAM_fctl.page.hide();
			} else if (page == "eng") {
				lowerECAM_apu.page.hide();
				if (getprop("/options/EIS2") == 1) {
					lowerECAM_eng1.page.hide();
					lowerECAM_eng.page.show();
				} else {
					lowerECAM_eng1.page.show();
					lowerECAM_eng.page.hide();
				}
				lowerECAM_fctl.page.hide();
                        } else if (page == "fctl") {
                                lowerECAM_eng1.page.hide();
				lowerECAM_eng.page.hide();
				lowerECAM_apu.page.hide();
                                lowerECAM_fctl.page.show();
			} else {
				lowerECAM_apu.page.hide();
				lowerECAM_eng1.page.hide();
				lowerECAM_eng.page.hide();
				lowerECAM_fctl.page.hide();
			}
		} else {
			lowerECAM_apu.page.hide();
			lowerECAM_eng1.page.hide();
			lowerECAM_eng.page.hide();
                        lowerECAM_fctl.page.hide();
		}
		
		settimer(func me.update(), 0.02);
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


var canvas_lowerECAM_fctl = {
        new: func(canvas_group, file) {
                var m = { parents: [canvas_lowerECAM_fctl , canvas_lowerECAM_base] };
                m.init(canvas_group, file);
                
                return m;
	},
	getKeys: func() {
		return ["ailL","ailR","elevL","elevR","PTcc","PT","PTupdn","GW","TAT","SAT","elac1","elac2","sec1","sec2","sec3","ailLblue","ailRblue","elevLblue","elevRblue","rudderblue","ailLgreen","ailRgreen","elevLgreen","ruddergreen","PTgreen","elevRyellow","rudderyellow","PTyellow","rudder","spdbrkblue","spdbrkgreen","spdbrkyellow","spoiler1Rex","spoiler1Rrt","spoiler2Rex","spoiler2Rrt","spoiler3Rex","spoiler3Rrt","spoiler4Rex","spoiler4Rrt","spoiler5Rex","spoiler5Rrt","spoiler1Lex","spoiler1Lrt","spoiler2Lex","spoiler2Lrt","spoiler3Lex","spoiler3Lrt","spoiler4Lex","spoiler4Lrt","spoiler5Lex","spoiler5Lrt"
		,"spoiler1Rf","spoiler2Rf","spoiler3Rf","spoiler4Rf","spoiler5Rf","spoiler1Lf","spoiler2Lf","spoiler3Lf","spoiler4Lf","spoiler5Lf","ailLscale","ailRscale"];
	},
	update: func() {
		var blue_psi=getprop("/systems/hydraulic/blue-psi");
		var green_psi=getprop("/systems/hydraulic/green-psi");
		var yellow_psi=getprop("/systems/hydraulic/yellow-psi");
		
	
		#PITCH TRIM
		me["PT"].setText(sprintf("%2.1f", getprop("/ECAM/Lower/elevator-trim-deg")));
		#me["PT-decimal"].setText(sprintf("%s", int(10*math.mod(getprop("/ECAM/Lower/elevator-trim-deg"),1))));
		if(getprop("/controls/flight/elevator-trim")<0){
			me["PTupdn"].setText(sprintf("UP"));
		}else if(getprop("/controls/flight/elevator-trim")>0){
			me["PTupdn"].setText(sprintf("DN"));
		}else{
			me["PTupdn"].setText(sprintf(""));
		}
		#Pitch Trim numbers become amber if green+yellow hydraulic pressure decreases
		if(green_psi<2900 and yellow_psi<2900){
			me["PT"].setColor(1,0.6,0);
			me["PTupdn"].setColor(1,0.6,0);
			me["PTcc"].setColor(1,0.6,0);
		}else{
			me["PT"].setColor(0,1,0);
			me["PTupdn"].setColor(0,1,0);
			me["PTcc"].setColor(0,1,0);
		}
		
		#AILERONS
		#Becomes amber if no green and blue servojack
		if(blue_psi<2900 and green_psi<2900){
			me["ailL"].setColor(1,0.6,0);
			me["ailR"].setColor(1,0.6,0);
			me["ailLscale"].setColor(1,0.6,0);
			me["ailRscale"].setColor(1,0.6,0);
			me["ailL"].setTranslation(0,100);
			me["ailR"].setTranslation(0,100);
		}else{
			me["ailL"].setColor(0,1,0);
			me["ailR"].setColor(0,1,0);
			me["ailLscale"].setColor(1,1,1);
			me["ailRscale"].setColor(1,1,1);
			me["ailL"].setTranslation(0,getprop("/controls/flight/aileron-left")*100);
			me["ailR"].setTranslation(0,getprop("/controls/flight/aileron-right")*(-100));
		}
		
		#ELEVATORS
		me["elevL"].setTranslation(0,getprop("/ECAM/Lower/elevator-ind-left")*100);
		me["elevR"].setTranslation(0,getprop("/ECAM/Lower/elevator-ind-right")*100);
		#Index becomes amber when both actuators don't work
		if(blue_psi<2900 and green_psi<2900){
			me["elevL"].setColor(1,0.6,0);
		}else{
			me["elevL"].setColor(0,1,0);
		}
		
		if(blue_psi<2900 and yellow_psi<2900){
			me["elevR"].setColor(1,0.6,0);
		}else{
			me["elevR"].setColor(0,1,0);
		}
		
		#RUDDER
		me["rudder"].setRotation(getprop("/controls/flight/rudder")*(-0.6));
		#Indicator becomes amber if green yellow and blue hydraulic pressure is low
		if(blue_psi<2900 and yellow_psi<2900 and green_psi<2900){
			me["rudder"].setColor(1,0.6,0);
		}else{
			me["rudder"].setColor(0,1,0);
		}
		
		#SPOILERS
		if(getprop("/controls/flight/spoiler-r1")<0.083){
			me["spoiler1Rex"].hide();
			me["spoiler1Rrt"].show();
		}else{
			me["spoiler1Rrt"].hide();
			me["spoiler1Rex"].show();
		}
		if(getprop("/controls/flight/spoiler-r2")<0.083){
			me["spoiler2Rex"].hide();
			me["spoiler2Rrt"].show();
		}else{
			me["spoiler2Rrt"].hide();
			me["spoiler2Rex"].show();
		}
		if(getprop("/controls/flight/spoiler-r3")<0.083){
			me["spoiler3Rex"].hide();
			me["spoiler3Rrt"].show();
		}else{
			me["spoiler3Rrt"].hide();
			me["spoiler3Rex"].show();
		}
		if(getprop("/controls/flight/spoiler-r4")<0.083){
			me["spoiler4Rex"].hide();
			me["spoiler4Rrt"].show();
		}else{
			me["spoiler4Rrt"].hide();
			me["spoiler4Rex"].show();
		}
		if(getprop("/controls/flight/spoiler-r5")<0.083){
			me["spoiler5Rex"].hide();
			me["spoiler5Rrt"].show();
		}else{
			me["spoiler5Rrt"].hide();
			me["spoiler5Rex"].show();
		}
		
			
		
		if(getprop("/controls/flight/spoiler-l1")<0.083){
			me["spoiler1Lex"].hide();
			me["spoiler1Lrt"].show();
		}else{
			me["spoiler1Lrt"].hide();
			me["spoiler1Lex"].show();
		}
		if(getprop("/controls/flight/spoiler-l2")<0.083){
			me["spoiler2Lex"].hide();
			me["spoiler2Lrt"].show();
		}else{
			me["spoiler2Lrt"].hide();
			me["spoiler2Lex"].show();
		}
		if(getprop("/controls/flight/spoiler-l3")<0.083){
			me["spoiler3Lex"].hide();
			me["spoiler3Lrt"].show();
		}else{
			me["spoiler3Lrt"].hide();
			me["spoiler3Lex"].show();
		}
		if(getprop("/controls/flight/spoiler-l4")<0.083){
			me["spoiler4Lex"].hide();
			me["spoiler4Lrt"].show();
		}else{
			me["spoiler4Lrt"].hide();
			me["spoiler4Lex"].show();
		}
		if(getprop("/controls/flight/spoiler-l5")<0.083){
			me["spoiler5Lex"].hide();
			me["spoiler5Lrt"].show();
		}else{
			me["spoiler5Lrt"].hide();
			me["spoiler5Lex"].show();
		}
		
		#STBY CODE - SPOILER FAIL
		if(getprop("/controls/flight/spoiler-r1-failed")){
			me["spoiler1Rex"].setColor(1,0.6,0);
			me["spoiler1Rrt"].setColor(1,0.6,0);
			if(getprop("/controls/flight/spoiler-r1")<0.083){
				me["spoiler1Rf"].show();
			}else{
				me["spoiler1Rf"].hide();
			}
			
		}else{
			me["spoiler1Rex"].setColor(0,1,0);
			me["spoiler1Rrt"].setColor(0,1,0);
			me["spoiler1Rf"].hide();
		}
		if(getprop("/controls/flight/spoiler-r2-failed")){
			me["spoiler2Rex"].setColor(1,0.6,0);
			me["spoiler2Rrt"].setColor(1,0.6,0);
			if(getprop("/controls/flight/spoiler-r2")<0.083){
				me["spoiler2Rf"].show();
			}else{
				me["spoiler2Rf"].hide();
			}
			
		}else{
			me["spoiler2Rex"].setColor(0,1,0);
			me["spoiler2Rrt"].setColor(0,1,0);
			me["spoiler2Rf"].hide();
		}
		if(getprop("/controls/flight/spoiler-r3-failed")){
			me["spoiler3Rex"].setColor(1,0.6,0);
			me["spoiler3Rrt"].setColor(1,0.6,0);
			if(getprop("/controls/flight/spoiler-r3")<0.083){
				me["spoiler3Rf"].show();
			}else{
				me["spoiler3Rf"].hide();
			}
			
		}else{
			me["spoiler3Rex"].setColor(0,1,0);
			me["spoiler3Rrt"].setColor(0,1,0);
			me["spoiler3Rf"].hide();
		}
		if(getprop("/controls/flight/spoiler-r4-failed")){
			me["spoiler4Rex"].setColor(1,0.6,0);
			me["spoiler4Rrt"].setColor(1,0.6,0);
			if(getprop("/controls/flight/spoiler-r4")<0.083){
				me["spoiler4Rf"].show();
			}else{
				me["spoiler4Rf"].hide();
			}
			
		}else{
			me["spoiler4Rex"].setColor(0,1,0);
			me["spoiler4Rrt"].setColor(0,1,0);
			me["spoiler4Rf"].hide();
		}
		if(getprop("/controls/flight/spoiler-r5-failed")){
			me["spoiler5Rex"].setColor(1,0.6,0);
			me["spoiler5Rrt"].setColor(1,0.6,0);
			if(getprop("/controls/flight/spoiler-r5")<0.083){
				me["spoiler5Rf"].show();
			}else{
				me["spoiler5Rf"].hide();
			}
			
		}else{
			me["spoiler5Rex"].setColor(0,1,0);
			me["spoiler5Rrt"].setColor(0,1,0);
			me["spoiler5Rf"].hide();
		}
		
			if(getprop("/controls/flight/spoiler-l1-failed")){
			me["spoiler1Lex"].setColor(1,0.6,0);
			me["spoiler1Lrt"].setColor(1,0.6,0);
			if(getprop("/controls/flight/spoiler-l1")<0.083){
				me["spoiler1Lf"].show();
			}else{
				me["spoiler1Lf"].hide();
			}
			
		}else{
			me["spoiler1Lex"].setColor(0,1,0);
			me["spoiler1Lrt"].setColor(0,1,0);
			me["spoiler1Lf"].hide();
		}
		if(getprop("/controls/flight/spoiler-l2-failed")){
			me["spoiler2Lex"].setColor(1,0.6,0);
			me["spoiler2Lrt"].setColor(1,0.6,0);
			if(getprop("/controls/flight/spoiler-l2")<0.083){
				me["spoiler2Lf"].show();
			}else{
				me["spoiler2Lf"].hide();
			}
			
		}else{
			me["spoiler2Lex"].setColor(0,1,0);
			me["spoiler2Lrt"].setColor(0,1,0);
			me["spoiler2Lf"].hide();
		}
		if(getprop("/controls/flight/spoiler-l3-failed")){
			me["spoiler3Lex"].setColor(1,0.6,0);
			me["spoiler3Lrt"].setColor(1,0.6,0);
			if(getprop("/controls/flight/spoiler-l3")<0.083){
				me["spoiler3Lf"].show();
			}else{
				me["spoiler3Lf"].hide();
			}
			
		}else{
			me["spoiler3Lex"].setColor(0,1,0);
			me["spoiler3Lrt"].setColor(0,1,0);
			me["spoiler3Lf"].hide();
		}
		if(getprop("/controls/flight/spoiler-l4-failed")){
			me["spoiler4Lex"].setColor(1,0.6,0);
			me["spoiler4Lrt"].setColor(1,0.6,0);
			if(getprop("/controls/flight/spoiler-l4")<0.083){
				me["spoiler4Lf"].show();
			}else{
				me["spoiler4Lf"].hide();
			}
			
		}else{
			me["spoiler4Lex"].setColor(0,1,0);
			me["spoiler4Lrt"].setColor(0,1,0);
			me["spoiler4Lf"].hide();
		}
		if(getprop("/controls/flight/spoiler-l5-failed")){
			me["spoiler5Lex"].setColor(1,0.6,0);
			me["spoiler5Lrt"].setColor(1,0.6,0);
			if(getprop("/controls/flight/spoiler-l5")<0.083){
				me["spoiler5Lf"].show();
			}else{
				me["spoiler5Lf"].hide();
			}
			
		}else{
			me["spoiler5Lex"].setColor(0,1,0);
			me["spoiler5Lrt"].setColor(0,1,0);
			me["spoiler5Lf"].hide();
		}
		
		#FLIGHT COMPUTERS		
		if(getprop("/systems/fctl/elac1")){
			me["elac1"].setColor(0,1,0);
		}else{
			me["elac1"].setColor(1,0.6,0);
		}
		if(getprop("/systems/fctl/elac2")){
			me["elac2"].setColor(0,1,0);
		}else{
			me["elac2"].setColor(1,0.6,0);
		}
		if(getprop("/systems/fctl/sec1")){
			me["sec1"].setColor(0,1,0);
		}else{
			me["sec1"].setColor(1,0.6,0);
		}
		if(getprop("/systems/fctl/sec2")){
			me["sec2"].setColor(0,1,0);
		}else{
			me["sec2"].setColor(1,0.6,0);
		}
		if(getprop("/systems/fctl/sec3")){
			me["sec3"].setColor(0,1,0);
		}else{
			me["sec3"].setColor(1,0.6,0);
		}
		
		#HYDRAULIC INDICATORS
		if(getprop("/systems/hydraulic/blue-psi")>2900){
			me["ailLblue"].setColor(0,1,0);
			me["ailRblue"].setColor(0,1,0);
			me["elevLblue"].setColor(0,1,0);
			me["elevRblue"].setColor(0,1,0);
			me["rudderblue"].setColor(0,1,0);
			me["spdbrkblue"].setColor(0,1,0);
		}else{
			me["ailLblue"].setColor(1,0.6,0);
			me["ailRblue"].setColor(1,0.6,0);
			me["elevLblue"].setColor(1,0.6,0);
			me["elevRblue"].setColor(1,0.6,0);
			me["rudderblue"].setColor(1,0.6,0);
			me["spdbrkblue"].setColor(1,0.6,0);
		}
		if(getprop("/systems/hydraulic/green-psi")>2900){
			me["ailLgreen"].setColor(0,1,0);
			me["ailRgreen"].setColor(0,1,0);
			me["elevLgreen"].setColor(0,1,0);
			me["ruddergreen"].setColor(0,1,0);
			me["PTgreen"].setColor(0,1,0);
			me["spdbrkgreen"].setColor(0,1,0);
		}else{
			me["ailLgreen"].setColor(1,0.6,0);
			me["ailRgreen"].setColor(1,0.6,0);
			me["elevLgreen"].setColor(1,0.6,0);
			me["ruddergreen"].setColor(1,0.6,0);
			me["PTgreen"].setColor(1,0.6,0);
			me["spdbrkgreen"].setColor(1,0.6,0);
		}
		if(getprop("/systems/hydraulic/yellow-psi")>2900){
			me["elevRyellow"].setColor(0,1,0);
			me["rudderyellow"].setColor(0,1,0);
			me["PTyellow"].setColor(0,1,0);
			me["spdbrkyellow"].setColor(0,1,0);
		}else{
			me["elevRyellow"].setColor(1,0.6,0);
			me["rudderyellow"].setColor(1,0.6,0);
			me["PTyellow"].setColor(1,0.6,0);
			me["spdbrkyellow"].setColor(1,0.6,0);
		}
		
		
		
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
	var groupFctl = lowerECAM_display.createGroup();
	var groupEng1 = lowerECAM_display.createGroup();
	var groupEng = lowerECAM_display.createGroup();

	lowerECAM_apu = canvas_lowerECAM_apu.new(groupApu, "Aircraft/A320Family/Models/Instruments/Lower-ECAM/res/apu.svg");
	lowerECAM_fctl = canvas_lowerECAM_fctl.new(groupFctl, "Aircraft/A320Family/Models/Instruments/Lower-ECAM/res/fctl.svg");
	lowerECAM_eng1 = canvas_lowerECAM_eng1.new(groupEng1, "Aircraft/A320Family/Models/Instruments/Lower-ECAM/res/eng-eis1.svg");
	lowerECAM_eng = canvas_lowerECAM_eng.new(groupEng, "Aircraft/A320Family/Models/Instruments/Lower-ECAM/res/eng-eis2.svg");

	lowerECAM_apu.update();
	lowerECAM_fctl.update();
	lowerECAM_eng1.update();
	lowerECAM_eng.update();
	canvas_lowerECAM_base.update();
});

var showLowerECAM = func {
	var dlg = canvas.Window.new([512, 512], "dialog").set("resize", 1);
	dlg.setCanvas(lowerECAM_display);
}
