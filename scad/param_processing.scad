include <parameters.scad>
include <default_layout.scad>
include <layout.scad>

use <utils.scad>

// Post-processing of parameter and layout values

// Determine whether to invert the layout
switch_layout_final = invert_layout_flag
    ? invert_layout(set_defaults(base_switch_layout, false))
    : set_defaults(base_switch_layout, false);
plate_layout_final = [
    for (group = base_plate_layout)
        invert_layout_flag
            ? invert_layout(set_defaults(group, ["switch"]))
            : set_defaults(group, ["switch"])
];
mcu_layout_final = invert_layout_flag
    ? invert_layout(set_defaults(base_mcu_layout))
    : set_defaults(base_mcu_layout);
trrs_layout_final = invert_layout_flag
    ? invert_layout(set_defaults(base_trrs_layout))
    : set_defaults(base_trrs_layout);
stab_layout_final = invert_layout_flag
    ? invert_layout(set_defaults(base_stab_layout))
    : set_defaults(base_stab_layout, stab_2u);
standoff_layout_final = invert_layout_flag
    ? invert_layout(set_defaults(base_standoff_layout, standoff_config_default))
    : set_defaults(base_standoff_layout, standoff_config_default);
via_layout_final = invert_layout_flag
    ? invert_layout(set_defaults(base_via_layout, via_shape))
    : set_defaults(base_via_layout, via_shape);

assert(
    layout_type == "column" || layout_type == "row",
    "layout_type parameter is invalid"
);

assert(
    pcb_type == "printed" || pcb_type == "traditional",
    "pcb_type parameter is invalid"
);

assert(
    switch_orientation == "south" || switch_orientation == "north",
    "switch_orientation is invalid"
);

// Channels are modelled as a teardrop to print the overhang better.
// Since changing the row/column layout flips the switch print
// orientation, we also need to flip the teardrop.
upsidedown_switch = 
    layout_type == "column"
    ? false 
    : layout_type == "row"
        ? true 
        : assert(false, "layout_type parameter is invalid");

// Moves the flat part to the top if layout is row-staggered so column wires
// can be routed. PCB should be printed upside down in this case.
border_z_offset =
    pcb_type == "traditional" ? 0
        : layout_type == "column" ? -1
        : layout_type == "row" ? 1
        : undef;

trrs_inset =
    pcb_type == "printed" ? 2
    : pcb_type == "traditional" ? 0
    : undef;

// Tweaks to make wire channels connect properly depending on the key alignment
row_cutout_length =
    layout_type == "column" ? 1000
    : layout_type == "row" ? 1000
    : undef;

col_cutout_length =
    layout_type == "column" ? 1000
    : layout_type == "row" ? 1000
    : undef;

switch_rotation =
    switch_orientation == "south" ? 0
    : switch_orientation == "north" ? 180
    : undef;

