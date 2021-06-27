/* [PCB Properties] */
// Diameter of row/column wire channels
wire_diameter = 2.15;
// Upward angle of switch pin in contact with diode anode (gives more reliable
// connections but slightly deforms pin)
diode_pin_angle = 5;  // [0:15]
// Switch type
switch_type = "mx";  // [mx, choc]
// Switch orientation (based on LED location)
switch_orientation = "south";  // [north, south]
// Diameter of integrated standoffs
standoff_diameter = 4;
// Diameter of standoff clearance hole
standoff_clearance_hole_diameter = 2.5;
// Diameter of standoff pilot hole
standoff_pilot_hole_diameter = 1.6;
// Overall thickness of PCB
pcb_thickness = 4;
// Distance the plate sticks out past the PCB
plate_margin = 5;

/* [Advanced Values (related to switch size)] */
// Switch spacing distance
unit = 19.05;
// Horizontal unit size (18mm for choc keycaps)
h_unit = unit;
// Vertical unit size (17mm for choc keycaps)
v_unit = unit;
// Size of socket body
socket_size = 
    switch_type == "mx"
    ? 14
    : switch_type == "choc"
        ? 15
        : assert(false, "switch_type is invalid");
// Depth of the socket holes
socket_depth = 3.5;
// Thickness of the plate
plate_thickness = 
    switch_type == "mx"
    ? 1.5
    : switch_type == "choc"
        ? 1.3
        : assert(false, "switch_type is invalid");
// Size of the plate cutout
plate_cutout_size = 
    switch_type == "mx"
    ? 14
    : switch_type == "choc"
        ? 13.8
        : assert(false, "switch_type is invalid");
// Spacing between the top of the PCB and top of the plate
pcb_plate_spacing = 
    switch_type == "mx"
    ? 5
    : switch_type == "choc"
        ? 2.2
        : assert(false, "switch_type is invalid");
// Increase this if your standoffs are a bit too long due to printing tolerances
fit_tolerance = 0;
// Spacing of grid for pins
grid = 1.27;
// Resolution of holes (affects render times)
$fn=12;

module __Customizer_Limit__ () {}

// Thickness of a border unit around the socket (for joining adjacent sockets)
border_width = (unit - socket_size)/2;
h_border_width = (h_unit - socket_size)/2;
v_border_width = (v_unit - socket_size)/2;
// Conversion factor from border width to mm (for use in layouts)
mm = 1/border_width;
h_mm = 1/h_border_width;
v_mm = 1/v_border_width;

