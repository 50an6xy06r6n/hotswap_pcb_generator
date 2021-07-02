include <parameters.scad>
include <default_layout.scad>
include <layout.scad>

// Determine whether to invert the layout
layout_final = invert_layout_flag ? invert_layout(base_layout) : base_layout;
mcu_layout_final = invert_layout_flag ? invert_layout(base_mcu_layout) : base_mcu_layout;
trrs_layout_final = invert_layout_flag ? invert_layout(base_trrs_layout) : base_trrs_layout;
standoff_layout_final = invert_layout_flag ? invert_layout(base_standoff_layout) : base_standoff_layout;

// Moves the flat part to the top if layout is row-staggered so column wires 
// can be routed. PCB should be printed upside down in this case.
border_z_offset =
    layout_type == "column"
    ? -1
    : layout_type == "row"
        ? 1
        : assert(false, "layout_type parameter is invalid");

// Tweaks to make wire channels connect properly depending on the key alignment
row_cutout_length =
    layout_type == "column"
    ? h_unit+1
    : layout_type == "row"
        ? 1000
        : assert(false, "layout_type parameter is invalid");

col_cutout_length =
    layout_type == "column"
    ? 1000
    : layout_type == "row"
        ? v_unit+1
        : assert(false, "layout_type parameter is invalid");

switch_rotation = 
    switch_orientation == "south"
    ? 0
    : switch_orientation == "north"
        ? 180
        : assert(false, "switch_orientation is invalid");


function invert_layout(layout) = [
    for(key = layout)
        let(
            location = len(key[0]) == 2 ? key[0] : [key[0][0],[0,0,0,0]],
            shape = len(key) == 2 ? key[1] : [1,[1,1,1,1],false]
        )
        [
            [
                [-location[0][0]-shape[0], location[0][1]],
                [-location[1][0], -location[1][1], location[1][2]]],
            [
                shape[0],
                [shape[1][0], shape[1][1], shape[1][3], shape[1][2]],
                shape[2]
            ]
        ]
];
    
module layout_pattern(layout) {
    union() {
        for (param = layout) {
            // Setting defaults
            location = len(param[0]) == 2 ? param[0] : [param[0][0],[0,0,0,0]];
            shape = len(param) == 2 ? param[1] : [1,[1,1,1,1],false];

            switch_offset = (shape[0]-1)/2;

            translate([location[1][1]*h_unit,-location[1][2]*v_unit,0]) {
                rotate([0,0,location[1][0]]) {
                    translate([(location[0][0]-location[1][1]+switch_offset)*h_unit,
                               (location[1][2]-location[0][1])*v_unit,
                               0]) {
                        $borders = shape[1];
                        $rotate_column = shape[2];
                        children();
                    }
                }
            }
        }
    }
}

module border(base_size, borders, thickness, h_unit=1, v_unit=1) {
    translate([
        h_unit/2 * (borders[3] - borders[2]),
        v_unit/2 * (borders[0] - borders[1]),
        0
    ]) {
        cube([
            base_size[0]+h_unit*(borders[2]+borders[3])+0.001,
            base_size[1]+v_unit*(borders[0]+borders[1])+0.001,
            thickness
        ], center=true);
    }
}