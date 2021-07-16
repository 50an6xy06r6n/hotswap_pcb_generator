include <parameters.scad>
include <default_layout.scad>
include <layout.scad>


// Determine whether to invert the layout
switch_layout_final = invert_layout_flag 
    ? invert_layout(set_defaults(base_switch_layout, false)) 
    : set_defaults(base_switch_layout, false);
mcu_layout_final = invert_layout_flag 
    ? invert_layout(set_defaults(base_mcu_layout)) 
    : set_defaults(base_mcu_layout);
trrs_layout_final = invert_layout_flag 
    ? invert_layout(set_defaults(base_trrs_layout)) 
    : set_defaults(base_trrs_layout);
standoff_layout_final = invert_layout_flag 
    ? invert_layout(set_defaults(base_standoff_layout, standoff_config_default)) 
    : set_defaults(base_standoff_layout, standoff_config_default);
via_layout_final = invert_layout_flag 
    ? invert_layout(set_defaults(base_via_layout, via_shape)) 
    : set_defaults(base_via_layout, via_shape);

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


function set_defaults(layout, extra_data_default=[]) = [
    for (item = layout)
        let(
            location = len(item[0]) == 3 
                ? item[0] 
                : len(item[0]) == 2
                    ? [item[0][0],item[0][1],[0,0,0]]
                    : [item[0][0],1,[0,0,0]],
            borders = len(item) >= 2 
                ? item[1] 
                : [1,1,1,1],
            extra_data = len(item) == 3 
                ? item[2] 
                : extra_data_default
        )
        [
            location,
            borders,
            extra_data
        ]
];

function invert_borders(borders, invert=true) = 
    invert
        ? [borders[0], borders[1], borders[3], borders[2]]
        : borders;

function invert_layout(layout) = [
    for (item = layout)
        let(
            location = item[0],
            borders = item[1],
            extra_data = item[2]
        )
        [
            [
                [-location[0][0]-location[1], location[0][1]],
                location[1],
                [-location[2][0], -location[2][1], location[2][2]],
            ],
            invert_borders(borders),
            extra_data
        ]
];
    
module layout_pattern(layout) {
    union() {
        for (item = layout) {
            location = item[0];
            $borders = item[1];
            $extra_data = item[2];

            switch_offset = (location[1]-1)/2;  // Coordinate offset based on key shape

            translate([location[2][1]*h_unit,-location[2][2]*v_unit,0]) {
                rotate([0,0,location[2][0]]) {
                    translate([(location[0][0]-location[2][1]+switch_offset)*h_unit,
                               (location[2][2]-location[0][1])*v_unit,
                               0]) {
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