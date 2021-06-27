/* [PCB Properties] */
// Diameter of row/column wire channels
wire_diameter = 2.15;
// Upward angle of switch pin in contact with diode anode (gives more reliable
// connections but slightly deforms pin)
diode_pin_angle = 5;  // [0:15]
// Diameter of integrated standoffs
standoff_diameter = 4;
// Diameter of standoff clearance hole
standoff_clearance_hole_diameter = 2.5;
// Diameter of standoff pilot hole
standoff_pilot_hole_diameter = 1.6;
// Overall thickness of PCB
pcb_thickness = 5;
// Thickness of the plate
plate_thickness = 1.5;
// Distance the plate sticks out past the PCB
plate_margin = 5;

/* [Advanced Values (related to switch size)] */
// Switch spacing distance
unit = 19.05;
// Size of socket body
socket_size = 14;
// Depth of the socket holes
socket_depth = 3.5;
// Size of the plate cutout
plate_cutout_size = 14;
// Spacing between the top of the PCB and top of the plate
pcb_plate_spacing = 5;
// Increase this if your standoffs are a bit too long due to printing tolerances
fit_tolerance = 0;
// Spacing of grid for pins
grid = 1.27;
// Resolution of holes (affects render times)
$fn=12;

module __Customizer_Limit__ () {}

// Thickness of a border unit around the socket (for joining adjacent sockets)
border_width = (unit - socket_size)/2;
// Conversion factor from border width to mm (for use in layouts)
mm = 1/border_width;

