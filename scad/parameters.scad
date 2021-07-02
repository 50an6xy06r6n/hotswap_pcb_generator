/* PCB Properties */
// Diameter of row/column wire channels
wire_diameter = 2.15;
// Upward angle of switch pin in contact with diode anode (gives more reliable
// connections but slightly deforms pin)
diode_pin_angle = 5;  // [0:15]
// Overall thickness of PCB
pcb_thickness = 4;  // [4:0.1:10]
// Distance the plate sticks out past the PCB
plate_margin = 5;

/* Switch Properties */
// Switch type
switch_type = "mx";  // [mx, choc]
// Switch orientation (based on LED location)
switch_orientation = "south";  // [north, south]

/* MCU Properties (Default values for Pro Micro) */
mcu_type = "bare";  // [bare, socketed]
mcu_width = 18;  
mcu_length = 32.75;
mcu_height = 4.25;  // Distance to top of PCB
mcu_row_spacing = 15.24;
mcu_row_count = 2;  // Unused
mcu_pin_pitch = 2.54;
mcu_pin_count = 24;
mcu_pin_offset = 0;  // Offset from the rear of the PCB
mcu_connector_width = 10;  // Width of the connector (for plate cutout)
mcu_connector_length = 4;  // Distance the connector extends onto the MCU (for plate cutout)
mcu_pcb_thickness = 1.6;

/* TRRS Socket Properties */
trrs_width = 6;
trrs_length = 12.1; 
trrs_height = 5;
trrs_flange_length = 2;
trrs_flange_diameter = 5;
trrs_pin_spacing = 4.4;
trrs_nub_diameter = 1;  // Little locating nubs on the bottom of the socket
trrs_nub_height = 1;
trrs_nub_spacing = 7;
trrs_nub_offset = 1.5;  // Distance from the front of the socket (not including flange)


/* Standoff Properties */
// Standoff configuration
standoff_type = "plate";  // [plate, pcb, separate, none]
// Diameter of integrated standoffs
standoff_diameter = 4;
// Diameter of standoff clearance hole
standoff_clearance_hole_diameter = 2.5;
// Diameter of standoff pilot hole
standoff_pilot_hole_diameter = 1.6;

/* Misc Values */
// Increase this if your standoffs are a bit too long due to printing tolerances
fit_tolerance = 0;
// Resolution of holes (affects render times)
$fn=12;

/* Advanced Values (related to switch size) */
// Switch spacing distance
unit = 19.05;
// Horizontal unit size (18mm for choc keycaps)
h_unit = unit;
// Vertical unit size (17mm for choc keycaps)
v_unit = unit;
// Spacing of grid for MX pins
grid = 1.27;
// Size of socket body
socket_size = 
    switch_type == "mx"
    ? 14
    : switch_type == "choc"
        ? 15
        : assert(false, "switch_type is invalid");
// Depth of the socket holes
socket_depth = 3.5;

module __Customizer_Limit__ () {}

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

// Thickness of a border unit around the socket (for joining adjacent sockets)
border_width = (unit - socket_size)/2;
h_border_width = (h_unit - socket_size)/2;
v_border_width = (v_unit - socket_size)/2;

// Conversion factor from border width to mm (for use in layouts)
mm = 1/border_width;
h_mm = 1/h_border_width;
v_mm = 1/v_border_width;

