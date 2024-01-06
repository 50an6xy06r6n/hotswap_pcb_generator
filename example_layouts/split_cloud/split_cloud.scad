include <parameters.scad>
include <stabilizer_spacing.scad>

/* [Layout Values] */
/* Layout Format (each key):
    [
        [                                       // Location Data
            [x_location, y_location],
            key_size,
            [rotation, rotation_x, rotation_y],
        ],
        [                                       // Borders
            top_border,
            bottom_border,
            left_border,
            right_border
        ],
        extra_data                              // Extra data (depending on component type)
    ]
*/

// Keyswitch Layout
//     (extra_data = rotate_column)
base_switch_layout = [
  [[[0,0],1,[0,0,0]],[1,1,1,1],false],
  [[[1,0],1,[0,0,0]],[1,1,1,1],false],
  [[[2,0],1,[0,0,0]],[1,1,1,1],false],
  [[[3,0],1,[0,0,0]],[1,1,1,1],false],
  [[[4,0],1,[0,0,0]],[1,1,1,1],false],
  [[[5,0],1,[0,0,0]],[1,1,1,1],false],
  [[[0,1],1,[0,0,0]],[1,1,1,1],false],
  [[[1,1],1,[0,0,0]],[1,1,1,1],false],
  [[[2,1],1,[0,0,0]],[1,1,1,1],false],
  [[[3,1],1,[0,0,0]],[1,1,1,1],false],
  [[[4,1],1,[0,0,0]],[1,1,1,1],false],
  [[[5,1],1,[0,0,0]],[1,1,1,1],false],
  [[[0,2],1,[0,0,0]],[1,1,1,1],false],
  [[[1,2],1,[0,0,0]],[1,1,1,1],false],
  [[[2,2],1,[0,0,0]],[1,1,1,1],false],
  [[[3,2],1,[0,0,0]],[1,1,1,1],false],
  [[[4,2],1,[0,0,0]],[1,1,1,1],false],
  [[[5,2],1,[0,0,0]],[1,1,1,1],false],
  [[[0,3],1,[0,0,0]],[1,1,1,1],false],
  [[[1,3],1,[0,0,0]],[1,1,1,1],false],
  [[[2,3],1,[0,0,0]],[1,1,1,1],false],
  [[[3,3],1,[0,0,0]],[1,1,1,1],false],
  [[[4,3],1,[0,0,0]],[1,1,1,1],false],
  [[[5,3],1,[0,0,0]],[1,1,1,1],false],
  [[[0,4],1,[0,0,0]],[1,1,1,1],false],
  [[[1,4],1,[0,0,0]],[1,1,1,1],false],
  [[[2,4],1,[0,0,0]],[1,1,1,1],false],
  [[[3,4],1,[0,0,0]],[1,1,1,1],false],
  [[[4,4],1,[0,0,0]],[1,1,1,1],false],
  [[[5,4],1,[0,0,0]],[1,1,1,1],false],
];

// MCU Position(s)
base_mcu_layout = [
    [[[6.3,0.0524933],1,[0,0,0]],[1,8,1,1],false]
];

// TRRS Position(s)
base_trrs_layout = [
    [[[6.3,2.75],1,[-90,7.05,3.25]],[1,12,1,1]]
];

// Stabilizer layout
//     (extra_data = [key_size, left_offset, right_offset, switch_offset=0])
//     (see stabilizer_spacing.scad for presets)
base_stab_layout = [];

// Via layout
//     (extra_data = [via_width, via_length])
base_via_layout = [
//    [[[6.75,2.9],0,[-90,6.75,2.9]],[0,0,0,0],[5,10]]
];

// Plate Layout (if different than PCB)
//     (extra_data = component_type)
base_plate_layout = [];

// Whether to only use base_plate_layout to generate the plate footprint
use_plate_layout_only = false;

// Standoff layout
//     (extra_data = [standoff_integration_override, standoff_attachment_override])
base_standoff_layout = [
    // PCB-Plate standoffs
    [[[0.5,0.125]]],
    [[[0.5,4]]],
    [[[2.5,2]]],
    [[[4.5,4]]],
    [[[4.5,0.125]]],
//    [[[4.875,5.125],1.5,[60,4.875,4.625]], [0,0,0,0]],
    [[[6.25,1.8]]],
    // PCB-Backplate standoffs
    [[[-0.5,-0.375]],[0,0,0,0],["plate", "backplate"]],
    [[[-0.5,4.625]],[0,0,0,0],["plate", "backplate"]],
    [[[7.1,3]],[0,0,0,0],["plate", "backplate"]],
    [[[5.5,4.625]],[0,0,0,0],["plate", "backplate"]],
    [[[5.5,-0.375]],[0,0,0,0],["plate", "backplate"]],
    [[[7.1,-0.375]],[0,0,0,0],["plate", "backplate"]],
//    [[[4.125,6.125],1.5,[60,4.875,4.625]],[0,0,0,0],["plate", "backplate"]],
//    [[[6.5,3]],[0,0,0,0],["plate", "backplate"]],
//    [[[5.5,-0.1875]],[0,0,0,0],["plate", "backplate"]],
//    [[[7,0]],[0,0,0,0],["plate", "backplate"]],
];

// Whether to flip the layout
invert_layout_flag = true;

// Whether the layout is staggered-row or staggered-column
layout_type = "column";  // [column, row]
