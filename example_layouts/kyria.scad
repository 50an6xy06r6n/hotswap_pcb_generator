include <parameters.scad>

/* [Layout Values] */
/* Layout Format (each key):
    [
        [
            [x_location, y_location],
            [rotation, rotation_x, rotation_y]
        ],
        [
            key_size,
            [top_border, bottom_border, left_border, right_border],
            rotate_column
        ]
    ]
*/
// Keyswitch Layout
base_layout = [
  [[[3,0.25],[0,0,0]],[1,[1,1,1,1],false]],
  [[[2,0.5],[0,0,0]],[1,[1,1,1,1],false]],
  [[[4,0.5],[0,0,0]],[1,[1,1,1,1],false]],
  [[[5,0.625],[0,0,0]],[1,[1,1,1,1],false]],
  [[[0,1],[0,0,0]],[1,[1,1,1,1],false]],
  [[[1,1],[0,0,0]],[1,[1,1,1,1],false]],
  [[[3,1.25],[0,0,0]],[1,[1,1,1,1],false]],
  [[[2,1.5],[0,0,0]],[1,[1,1,1,1],false]],
  [[[4,1.5],[0,0,0]],[1,[1,1,1,1],false]],
  [[[5,1.625],[0,0,0]],[1,[1,1,1,1],false]],
  [[[0,2],[0,0,0]],[1,[1,1,1,1],false]],
  [[[1,2],[0,0,0]],[1,[1,1,1,1],false]],
  [[[3,2.25],[0,0,0]],[1,[1,1+0.25*unit*mm,1,1],false]],
  [[[2,2.5],[0,0,0]],[1,[1,1,1,1],false]],
  [[[4,2.5],[0,0,0]],[1,[1,1+0.25*unit*mm,1,1],false]],
  [[[5,2.625],[0,0,0]],[1,[1,1+0.5*unit*mm,1,1],false]],
  [[[0,3],[0,0,0]],[1,[1,1,1,1],false]],
  [[[1,3],[0,0,0]],[1,[1,1,1,1+0.5*unit*mm],false]],
  [[[2.5,3.5],[0,0,0]],[1,[1,1,1,1],false]],
  [[[3.5,3.5],[0,4,8.175]],[1,[1,1,1,1+0.25*unit*mm],false]],
  [[[3.5,3.5],[-15,4,8.175]],[1,[1,1,1+0.25*unit*mm,1+0.25*unit*mm],false]],
  [[[3.5,2.5],[-30,4,8.175]],[1,[1,1,1+0.5*unit*mm,1+0.25*unit*mm],false]],
  [[[3.5,3.5],[-30,4,8.175]],[1,[1,1,1+0.25*unit*mm,1+0.25*unit*mm],false]],
  [[[3.5,2.5],[-45,4,8.175]],[1,[1,1,1+0.25*unit*mm,1],false]],
  [[[3.5,3.5],[-45,4,8.175]],[1,[1,1,1+0.25*unit*mm,1],false]],
];

// Standoff hole layout
base_standoff_layout = [];

// Whether to flip the layout
invert_layout_flag = false;

// Whether the layout is staggered-row or staggered-column
layout_type = "column";  // [column, row]

// Standoff configuration
standoff_type = "plate"; // [plate, pcb, separate, none]
