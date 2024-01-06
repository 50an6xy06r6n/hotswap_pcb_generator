/* PCB Parameters */
// Diameter of row/column wire channels
wire_diameter = 2.15;
// Upward angle of switch pin in contact with diode anode (gives more reliable
// connections but slightly deforms pin)
diode_pin_angle = 5;  // [0:15]
// Amount the diode folds over
diode_foldover = 4;
// Overall thickness of PCB
pcb_thickness = 4;  // [1.6:0.1:10]
// If using a traditional PCB, cases can still be generated
pcb_type = "printed";  // [printed, traditional]

/* Switch Parameters */
// Switch type
switch_type = "mx";  // [mx, choc]
// Switch orientation (based on LED location)
switch_orientation = "south";  // [north, south]
// Whether to use experimental diode leg contact
use_folded_contact = false;


/* Stabilizer Parameters */
stabilizer_type = "pcb";  // [pcb, plate]


/* Case Parameters */
// Type of case to generate
case_type = "plate_case";  // [sandwich, plate_case, backplate_case]
// Thickness of case walls
case_wall_thickness = 4;
// Case wall draft angle (convex cases only)
case_wall_draft_angle = 15;
// Width of the case chamfer (convex cases only)
case_chamfer_width = 1;
// Angle of the case chamfer (convex cases only)
case_chamfer_angle = 45;
// Height of the vertical portion at the bottom of the case 
// (not including backplate flange)
case_base_height = 2;
// Fit tolerance between interlocking case parts
case_fit_tolerance = 0.2;


/* Plate Parameters */
// Distance the plate sticks out past the PCB
plate_margin = 5;
// Radius of outer fillets
plate_outer_fillet = 2.5;
// Radius of inner fillets
plate_inner_fillet = 50;
// Setting this lower can help fix geometry issues when using custom plate shapes
// (i.e. two components that don't meet at exactly the same point can cause offset issues)
plate_precision = 1/100;


/* Backplate Parameters */
// Thickness of the backplate
backplate_thickness = 3;
// Thickness of flange around backplate if using an integrated-plate case
backplate_case_flange = 2;
// Spacing between the bottom of the PCB and the top of the backplate
pcb_backplate_spacing = 3;


/* MCU Parameters (Default values for Pro Micro) */
mcu_type = "bare";  // [bare, socketed]
mcu_width = 18;
mcu_length = 33;
mcu_height = 4.25;  // Distance to top of PCB
mcu_row_spacing = 15.24;
mcu_row_count = 2;  // Unused
mcu_pin_count = 24;
mcu_pin_pitch = 2.54;
mcu_pin_offset = 0;  // Offset from the rear of the PCB
mcu_connector_width = 13;  // Width of the connector (for plate cutout)
mcu_connector_length = 4;  // Distance the connector extends onto the MCU (for plate cutout)
mcu_connector_height = 8;  // Height of the plug housing
mcu_connector_offset = 1.5; // Vertical offset of plug center from PCB center
mcu_pcb_thickness = 1.6;
mcu_pcb_offset = 0; // Vertical offset of MCU from PCB (useful for traditional PCBs)
mcu_socket_width = mcu_width+4;
mcu_socket_length = mcu_length+4;
expose_mcu = false; // Opens up cutout grid above MCU footprint


/* TRRS Socket Parameters */
trrs_type = "pj320a";
trrs_width = 6;
trrs_length = 12.1;
trrs_height = 5;
trrs_flange_length = 2;
trrs_flange_diameter = 5;
trrs_pin_spacing = 4.4;
trrs_nub_diameter = 1.5;  // Little locating nubs on the bottom of the socket
trrs_nub_height = 1;
trrs_nub_spacing = 7;
trrs_nub_offset = 1.5;  // Distance from the front of the socket (not including flange)
trrs_plug_width = 10;  // Width of a plug for plate clearance


/* TRS Socket Parameters */
//trrs_type = "pj324m";
//trrs_width = 11.55;
//trrs_length = 14.25;
//trrs_height = 6.3;
//trrs_flange_length = 3.5;
//trrs_flange_diameter = 6;
//trrs_pin_spacing = 4.4;
//trrs_nub_diameter = 1.5;  // Little locating nubs on the bottom of the socket
//trrs_nub_height = 1;
//trrs_nub_spacing = 7;
//trrs_nub_offset = 1.5;  // Distance from the front of the socket (not including flange)
//trrs_plug_width = 10;  // Width of a plug for plate clearance


/* Via Parameters */
via_width = 5;
via_length = 15;
via_shape = [via_width, via_length];


/* Standoff Parameters */
// Component the standoff is integrated with
standoff_integration_default = "plate";  // [plate, backplate, pcb, separate, none]
// Component the standoff is screwed to
standoff_attachment_default = "pcb";  // [plate, backplate, pcb, plate_backplate, none]
// Intermediate shape variable to pass around
standoff_config_default = [
    standoff_integration_default,
    standoff_attachment_default
];
// Diameter of integrated standoffs
standoff_diameter = 4.5;
// Diameter of standoff clearance hole
standoff_clearance_hole_diameter = 2.5;
// Diameter of standoff pilot hole
standoff_pilot_hole_diameter = 1.6;
// Diameter of standoff screw head counterbores
standoff_counterbore_diameter = 4.5;


// Cutout Grid Parameters
cutout_grid_size = 8;
cutout_grid_spacing = 1.6;


/* Misc Parameters */
// Increase this if your standoffs are a bit too long due to printing tolerances
fit_tolerance = 0;
// Resolution of holes (affects render times)
$fn= $preview ? 12 : 36;


/* Advanced Parameters (related to switch size) */
// Switch spacing distance
unit = 19.05;
// Horizontal unit size (18mm for choc keycaps)
h_unit = unit;
// Vertical unit size (17mm for choc keycaps)
v_unit = unit;
// Spacing of grid for MX pins
grid = 1.27;
// Size of socket body
assert(
    switch_type == "mx" || switch_type == "choc",
    "switch_type is invalid"
);

socket_size =
    switch_type == "mx" ? 14
    : switch_type == "choc" ? 15
    : undef;
// Depth of the socket holes
socket_depth = 3.5;
// Thickness of the plate
plate_thickness =
    switch_type == "mx" ? 1.5
    : switch_type == "choc" ? 1.3
    : undef;
// Size of the plate cutout
plate_cutout_size =
    switch_type == "mx" ? 14
    : switch_type == "choc" ? 13.8
    : undef;
// Spacing between the top of the PCB and top of the plate
pcb_plate_spacing =
    switch_type == "mx" ? 5
    : switch_type == "choc" ? 2.2
    : undef;

// Total assembly thickness (for reference)
total_thickness =
    pcb_plate_spacing + pcb_thickness + pcb_backplate_spacing + backplate_thickness;

// Width of a border unit around the socket (for joining adjacent sockets)
border_width = (unit - socket_size)/2;
h_border_width = (h_unit - socket_size)/2;
v_border_width = (v_unit - socket_size)/2;

// Conversion factor from border width to mm (for use in layouts)
mm = 1/border_width;
h_mm = 1/h_border_width;
v_mm = 1/v_border_width;

// Align mcu to a unit
mcu_unit_resolution = .5;  // Grid size to snap to (as fractional unit)
mcu_h_unit_size = ceil(mcu_socket_width/mcu_unit_resolution/h_unit) * mcu_unit_resolution;
mcu_v_unit_size = ceil(mcu_socket_length/mcu_unit_resolution/v_unit) * mcu_unit_resolution;

// Useful for manipulating layout elements
function slice(array, bounds, extra_data_override="") = [
    let(
        lower = bounds[0] >= 0 ? bounds[0] : max(len(array)+bounds[0], 0),
        upper = bounds[1] > 0 ? min(bounds[1], len(array)) : len(array)+bounds[1],
        step = len(bounds) == 3 ? bounds[2] : 1
    )
    for (i = [lower:step:upper-1])
       (len(array[i]) >= 2 && extra_data_override != "")
            ? [array[i][0], array[i][1], extra_data_override, array[i][3]]
            : array[i]
];
