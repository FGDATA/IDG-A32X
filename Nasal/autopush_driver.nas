# AUTOPUSH
# Pushback driver class.
#
# Command the pushback to tow/push the aircract facing set heading.
#
# Copyright (c) 2018 Michael Danilov <mike.d.ft402 -eh- gmail.com>
# Distribute under the terms of GPLv2.


# FIXME When facing, acccount for current steering position, to work without dry steering.


var _K_V_push = nil;
var _F_V_push = nil;
var _S_min = nil;
var _K_psi_push = nil;
var _K_V_turn = nil;
var _F_V_turn = nil;
var _K_psi_turn = nil;
var _V_min = nil;

var _turning = nil;
var _sign = nil;
var _target = nil;
var _psi_parking = nil;
var _psi_turn = nil;

var loop = func() {
 if(!getprop("/sim/model/pushback/connected")){
  stop();
  return;
 }
 var V = 0.0;
 var steering = 0.0;
 var deltapsi = 0.0;
 var psi = getprop("/orientation/heading-deg");
 if(!_turning){
  # Initially follow a straight line parallel to our initial heading.
  var (A, S) = courseAndDistance(_target);
  S *= NM2M;
  # Stop when the bearing flips, guarante against infinite pushing.
  if(
   (abs(S) < _S_min) +
   (abs(saw180(_psi_parking - A - math.min(_sign, 0.0) * 180.0) > 90.0))
  ){
   _turning = 1;
   screen.log.write("(pushback): Turning to face heading " ~ int(_psi_turn) ~ ".");
  }
  deltapsi = saw180(_psi_parking - psi);
  V = math.min(math.max(_K_V_push * _sign * (S / _S_min), -_F_V_push), _F_V_push);
  steering = math.min(math.max(_K_psi_push * _sign * deltapsi, -1.0), 1.0);
 }else{
  # Turn (almost) in place.
  deltapsi = saw180(_psi_turn - psi);
  V = math.min(math.max(_K_V_turn * _sign * abs(deltapsi), -_F_V_turn), _F_V_turn);
  # We are done when the heading error is small.
  if(abs(V) < _V_min){
   stop();
   return;
  }
  steering = math.min(math.max(_K_psi_turn * _sign * deltapsi, -1.0), 1.0);
 }
 setprop("/sim/model/pushback/target-speed-km_h", V);
 setprop("/sim/model/pushback/driver/steer-cmd-norm", steering);
}

var timer = maketimer(0.051, func{loop()});

var start = func() {
 _K_V_push = getprop("/sim/model/pushback/driver/K_V_push");
 _F_V_push = getprop("/sim/model/pushback/driver/F_V_push");
 _S_min = getprop("/sim/model/pushback/driver/S_min-m");
 _K_psi_push = getprop("/sim/model/pushback/driver/K_psi_push");
 _K_V_turn = getprop("/sim/model/pushback/driver/K_V_turn");
 _F_V_turn = getprop("/sim/model/pushback/driver/F_V_turn");
 _K_psi_turn = getprop("/sim/model/pushback/driver/K_psi_turn");
 _V_min = getprop("/sim/model/pushback/driver/V_min");
 if(!getprop("/sim/model/pushback/connected")){
  return;
 }
 towdist = getprop("/sim/model/pushback/driver/tow-distance-m");
 _target = geo.aircraft_position();
 _psi_parking = getprop("/orientation/heading-deg");
 _target.apply_course_distance(_psi_parking, towdist);
 _psi_turn = getprop("/sim/model/pushback/driver/face-heading-deg");
 _sign = 1.0 - 2.0 * (towdist < 0.0);
 _turning = 0;
 timer.start();
 if(_sign < 0.0){
  screen.log.write("(pushback): Pushing back.");
 }else{
  screen.log.write("(pushback): Towing.");
 }
}

var stop = func() {
 if(timer.isRunning){
  screen.log.write("(pushback): Done.");
 }
 timer.stop();
 setprop("/sim/model/pushback/target-speed-km_h", 0.0);
}

# Sawtooth: -180..+180 deg.
var saw180 = func(p) {
 while (p <= -180.0){
  p += 360.0;
 }
 while (p > 180.0){
  p -= 360.0;
 }
 return p;
}
