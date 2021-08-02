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
  [[[0,1],1,[0,0,0]],[1,1,1,1],false],
  [[[1,1],1,[0,0,0]],[1,1,1,1],false],
  [[[2,1],1,[0,0,0]],[1,1,1,1],false],
  [[[0,2],1,[0,0,0]],[1,1,1,1],false],
  [[[1,2],1,[0,0,0]],[1,1,1,1],false],
  [[[2,2],1,[0,0,0]],[1,1,1,1],false],
  [[[0,3],1,[0,0,0]],[1,1,1,1],false],
  [[[1,3],1,[0,0,0]],[1,1,1,1],false],
  [[[2,3],1,[0,0,0]],[1,1,1,1],false],
  [[[0,4],2,[0,0,0]],[1,1,1+0.5*unit*mm,1+0.5*unit*mm],false],
  [[[2,4],1,[0,0,0]],[1,1,1,1],false],
  [[[4,1],2,[-90,4,1]],[1,1,1+0.5*unit*mm,1+0.5*unit*mm],true],
  [[[4,3],2,[-90,4,3]],[1,1,1+0.5*unit*mm,1+0.5*unit*mm],true],
];

// MCU Position(s)
base_mcu_layout = [];

// TRRS Position(s)
base_trrs_layout = [];

// Stabilizer layout
//     (extra_data = [key_size, left_offset, right_offset, switch_offset=0])
//     (see stabilizer_spacing.scad for presets)
base_stab_layout = [
  [[[0,4],2,[0,0,0]],[1,1,1,1],2u],
  [[[4,1],2,[-90,4,1]],[1,1,1,1],2u],
  [[[4,3],2,[-90,4,3]],[1,1,1,1],2u],
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
layout_type = "column";  // [column, row]
