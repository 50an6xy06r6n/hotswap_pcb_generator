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
  [[[6,0],1,[0,0,0]],[1,1,1,1],false],
  [[[7,0],1,[0,0,0]],[1,1,1,1],false],
  [[[8,0],1,[0,0,0]],[1,1,1,1],false],
  [[[9,0],1,[0,0,0]],[1,1,1,1],false],
  [[[10,0],1,[0,0,0]],[1,1,1,1],false],
  [[[11,0],1,[0,0,0]],[1,1,1,1],false],
  [[[0,1],1.25,[0,0,0]],[1,1,1+0.125*unit*mm,1+0.125*unit*mm],false],
  [[[1.25,1],1,[0,0,0]],[1,1,1,1],false],
  [[[2.25,1],1,[0,0,0]],[1,1,1,1],false],
  [[[3.25,1],1,[0,0,0]],[1,1,1,1],false],
  [[[4.25,1],1,[0,0,0]],[1,1,1,1],false],
  [[[5.25,1],1,[0,0,0]],[1,1,1,1],false],
  [[[6.25,1],1,[0,0,0]],[1,1,1,1],false],
  [[[7.25,1],1,[0,0,0]],[1,1,1,1],false],
  [[[8.25,1],1,[0,0,0]],[1,1,1,1],false],
  [[[9.25,1],1,[0,0,0]],[1,1,1,1],false],
  [[[10.25,1],1.75,[0,0,0]],[1,1,1+0.375*unit*mm,1+0.375*unit*mm],false],
  [[[0,2],1.75,[0,0,0]],[1,1,1+0.375*unit*mm,1+0.375*unit*mm],false],
  [[[1.75,2],1,[0,0,0]],[1,1,1,1],false],
  [[[2.75,2],1,[0,0,0]],[1,1,1,1],false],
  [[[3.75,2],1,[0,0,0]],[1,1,1,1],false],
  [[[4.75,2],1,[0,0,0]],[1,1,1,1],false],
  [[[5.75,2],1,[0,0,0]],[1,1,1,1],false],
  [[[6.75,2],1,[0,0,0]],[1,1,1,1],false],
  [[[7.75,2],1,[0,0,0]],[1,1,1,1],false],
  [[[8.75,2],1,[0,0,0]],[1,1,1,1],false],
  [[[9.75,2],1.25,[0,0,0]],[1,1,1+0.125*unit*mm,1+0.125*unit*mm],false],
  [[[11,2],1,[0,0,0]],[1,1,1,1],false],
  [[[0,3],1.25,[0,0,0]],[1,1,1+0.125*unit*mm,1+0.125*unit*mm],false],
  [[[1.25,3],1,[0,0,0]],[1,1,1,1],false],
  [[[2.25,3],1,[0,0,0]],[1,1,1,1],false],
  [[[3.25,3],6.25,[0,0,0]],[1,1,1+2.625*unit*mm,1+2.625*unit*mm],false],
  [[[9.5,3],1.25,[0,0,0]],[1,1,1+0.125*unit*mm,1+0.125*unit*mm],false],
  [[[10.75,3],1.25,[0,0,0]],[1,1,1+0.125*unit*mm,1+0.125*unit*mm],false],
];

// MCU Position(s)
base_mcu_layout = [];

// TRRS Position(s)
base_trrs_layout = [];

// Stabilizer layout
//     (extra_data = [key_size, left_offset, right_offset, switch_offset=0])
//     (see stabilizer_spacing.scad for presets)
base_stab_layout = [
  [[[3.25,3],6.25,[0,0,0]],[1,1,1,1],stab_6_25u],
];

// Via layout
//     (extra_data = [via_width, via_length])
base_via_layout = [];

// Plate Layout (if different than PCB)
//     (extra_data = component_type)
base_plate_layout = [];

// Whether to only use base_plate_layout to generate the plate footprint
use_plate_layout_only = false;

// Standoff layout
//     (extra_data = [standoff_integration_override, standoff_attachment_override])
base_standoff_layout = [];

// Whether to flip the layout
invert_layout_flag = false;

// Whether the layout is staggered-row or staggered-column
layout_type = "row";  // [column, row]
