# AUTOPUSH
# Basic pushback logic class.
#
# Copyright (c) 2018 Michael Danilov <mike.d.ft402 -eh- gmail.com>
# Distribute under the terms of GPLv2.


var _K_p = nil;
var _K_i = nil;
var _K_d = nil;
var _F_i = nil;
var _int = nil;
var _deltaV_old = nil;
var _t_old = nil;

var loop = func() {
 if(!getprop("/sim/model/pushback/available")){
  stop();
  return;
 }
 var force = 0.0;
 # Rollspeed is only adequate if the wheel is touching the ground.
 if(getprop("/gear/gear[0]/wow")){
  var deltaV =
   getprop("/sim/model/pushback/target-speed-km_h") -
   getprop("/gear/gear[0]/rollspeed-ms") * 3.6;
  var dV = deltaV - _deltaV_old;
  var t = getprop("/sim/time/elapsed-sec");
  var dt = math.max(t - _t_old, 0.0001);
  _int = math.min(math.max(_int + dV * dt, -_F_i), _F_i);
  force = (_K_p * deltaV + _K_d * dV / dt + _K_i * _int) * KG2LB;
  _deltaV_old = deltaV;
  _t_old = t;
  var yaw = getprop("/sim/model/pushback/yaw-deg") * D2R;
  setprop("/sim/model/pushback/force-x", math.cos(yaw));
  setprop("/sim/model/pushback/force-y", math.sin(yaw));
 }
 setprop("/sim/model/pushback/force-lbf", force);
}

var timer = maketimer(0.026, func{loop()});

var start = func() {
 _K_p = getprop("/sim/model/pushback/K_p");
 _K_i = getprop("/sim/model/pushback/K_i");
 _K_d = getprop("/sim/model/pushback/K_d");
 _F_i = getprop("/sim/model/pushback/F_i");
 _int = 0.0;
 _deltaV_old = 0.0;
 _t_old = getprop("/sim/time/elapsed-sec");
 setprop("/sim/model/pushback/connected", 1);
 if(!timer.isRunning){
  screen.log.write("(pushback): Release brakes.");
 }
 timer.start();
}

var stop = func() {
 if(timer.isRunning){
  screen.log.write("(pushback): Pushback disconnected, bypass pin removed.");
 }
 timer.stop();
 setprop("/sim/model/pushback/force-lbf", 0.0);
 setprop("/sim/model/pushback/connected", 0);
}

var toggle = func(){
 if(
  getprop("/sim/model/pushback/enabled") *
  getprop("/sim/model/pushback/available")
 ){
  start();
 }else{
  stop();
 }
}
