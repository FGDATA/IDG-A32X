AUTOMATIC PUSHBACK FOR FLIGHTGEAR
Version 0.1.1

Copyright (c) 2018 Michael Danilov <mike.d.ft402 -eh- gmail.com>
Some of the code (c) FlightGear
Distribute under the terms of GPLv2.


FILES

Nasal/autopush-README.txt       this file
Models/Goldhofert-autopush.xml  the animation for FGDATA's Goldhofer
Nasal/autopush.nas              basic pushback logic
Nasal/autopush_driver.nas       pushback driver
gui/dialogs/autopush.xml	GUI dialog


INSTALLATION

Only the minimal working example is covered here. Later you will have
to implement correct steering in your FDM (driving the
"/sim/model/pushback/yaw-deg") and pushback availability
("/sim/model/pushback/available") -- because those are too
aircraft-specific.

1. Set up the pushback logic. Add the following tags in your set.xml.
   Replace the "/fdm/jsbsim/gear/unit[0]/steering/pos-deg" with the
   property for the front wheel steering degrees of your aircraft.

   Under <sim><model>:

 <pushback>
  <enabled type="int"/>
  <available type="int">1</available>
  <yaw-deg alias="/fdm/jsbsim/gear/unit[0]/steering/pos-deg"/>
  <target-speed-km_h type="float">0.0</target-speed-km_h>
  <K_p type="float">100.0</K_p>
  <K_i type="float">25.0</K_i>
  <F_i type="float">25000.0</F_i>
  <K_d type="float">0.0</K_d>
  <driver>
   <tow-distance-m type="float">-60.0</tow-distance-m>
   <face-heading-deg type="float">0.0</face-heading-deg>
   <steer-cmd-norm alias="/controls/flight/rudder"/>
   <K_V_push type="float">10.0</K_V_push>
   <F_V_push type="float">10.0</F_V_push>
   <S_min-m type="float">5.0</S_min-m>
   <K_psi_push type="float">0.05</K_psi_push>
   <K_V_turn type="float">1.4</K_V_turn>
   <F_V_turn type="float">7.0</F_V_turn>
   <K_psi_turn type="float">0.2</K_psi_turn>
   <V_min type="float">2.5</V_min>
  </driver>
 </pushback>

   Under <nasal>:

 <autopush>
  <file>Nasal/autopush.nas</file>
 </autopush>
 <autopush_driver>
  <file>Nasal/autopush_driver.nas</file>
 </autopush_driver>

2. Connect the FDM's external force.

 a) JSBSim:

  a.1. Add the following under <external_reactions> of your
       JSBSim XML. Change the coordinates under <location> to equal
       those of your front bogey.

 <force name="tractor" frame="BODY">
  <location unit="M">
   <x>0.0</x>
   <y>0.0</y>
   <z>0.0</z>
  </location>
  <direction>
   <x>1.0</x>
   <y>0.0</y>
   <z>0.0</z>
  </direction>
 </force>

  a.2. Add the following under <fdm><jsbsim><external_reactions> of
       your set.xml.

   <tractor>
    <magnitude alias="/sim/model/pushback/force-lbf"/>
    <x alias="/sim/model/pushback/force-x"/>
    <y alias="/sim/model/pushback/force-y"/>
   </tractor>

 b) YASim: TODO

3. Copy the gui/dialogs/autopush.xml from the distribution to your
   aircraft's gui/dialogs directory. Add it to the menu (see
   FlightGear documentation for editing the menu).

4. Copy the Models/Goldhofert-autopush.xml to your aircraft's Models/
   directory. Edit all the places marked by "SETTING" to match your
   setup. Include it in your Model XML, with offsets equal to the
   front wheel's contact point.

5. Add the following in your Model XML. Change the coordinates under
   <offsets> to equal those of your front bogey.

 <model>
  <name>Pushback</name>
  <path>Models/Airport/Pushback/Goldhofert-autopush.xml</path>
  <offsets>
   <x-m>0.0</x-m>
   <y-m>0.0</y-m>
   <z-m>0.0</z-m>
  </offsets>
 </model>
