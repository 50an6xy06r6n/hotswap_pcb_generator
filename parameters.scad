/* [PCB Properties] */
// Diameter of row/column wire channels
wire_diameter = 2.15;
// Upward angle of switch pin in contact with diode anode (gives more reliable
// connections but slightly deforms pin)
diode_pin_angle = 5;  // [0:15]
// Diameter of standoff hole
standoff_hole_diameter = 3;
// Overall thickness of PCB
thickness = 4;


/* [Advanced Values (related to switch size)] */
// Switch spacing distance
unit = 19.05;
// Size of socket body
socket_size = 14;
// Depth of the socket holes
socket_depth = 3.5;
// Spacing of grid for pins
grid = 1.27;
// Resolution of holes (affects render times)
$fn=12;

module __Customizer_Limit__ () {}
