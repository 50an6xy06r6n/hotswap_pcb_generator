include <parameters.scad>

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

function set_defaults(layout, extra_data_default=[]) = [
    for (item = layout)
        set_item_defaults(item, extra_data_default)
];

function set_item_defaults(layout_item, extra_data_default=[]) = (
    let(
        // Set unspecified rotations to [0, 0, 0]
        location = len(layout_item[0]) == 3
            ? layout_item[0]
            : len(layout_item[0]) == 2
                ? [layout_item[0][0],layout_item[0][1],[0,0,0]]
                : [layout_item[0][0],1,[0,0,0]],
        borders = len(layout_item) >= 2
            ? layout_item[1]
            : [1,1,1,1],
        extra_data = len(layout_item) >= 3
            ? layout_item[2]
            : extra_data_default,
        trim = len(layout_item) == 4
            ? layout_item[3]
            : undef
    )
    [
        location,
        borders,
        extra_data,
        trim
    ]
);

function invert_layout(layout) = [
    for (item = layout)
        invert_layout_item(item, true)
];

function invert_layout_item(layout_item, invert=true) = (
    invert
        ? let(
            location = layout_item[0],
            borders = layout_item[1],
            extra_data = layout_item[2],
            trim = layout_item[3]
        )
        [
            [
                [-location[0][0]-location[1], location[0][1]],
                location[1],
                [-location[2][0], -location[2][1], location[2][2]],
            ],
            invert_borders(borders),
            extra_data,
            invert_borders(trim),
        ]
        : layout_item
);

function invert_borders(borders, invert=true) =
    invert
        ? [borders[0], borders[1], borders[3], borders[2]]
        : borders;

module layout_pattern(layout) {
    union() {
        for (item = layout) {
            position_item(item) {
                children();
            }
        }
    }
}

module position_item(layout_item) {
    $display_item = layout_item;
    location = layout_item[0];
    $borders = layout_item[1];
    $extra_data = layout_item[2];
    $trim = layout_item[3];

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

module border(base_size, borders, thickness, h_unit=1, v_unit=1) {
    linear_extrude(thickness, center=true)
        border_footprint(base_size, borders, h_unit, v_unit);
}

module border_footprint(base_size, borders, h_unit=1, v_unit=1) {
    translate([
        h_unit/2 * (borders[3] - borders[2]),
        v_unit/2 * (borders[0] - borders[1]),
        0
    ]) {
        square([
            base_size[0]+h_unit*(borders[2]+borders[3])+0.001,
            base_size[1]+v_unit*(borders[0]+borders[1])+0.001
        ], center=true);
    }
}

module border_trim(base_size, borders, trim, h_unit=1, v_unit=1) {
    translate([
        h_unit/2 * (borders[3] - borders[2]),
        v_unit/2 * (borders[0] - borders[1]),
        0
    ]) {
        union() {
            for (direction = [0 : 3]) {
                if (trim[direction]) {
                    rotate(direction_to_rotation(direction))
                    translate([
                        -1000,
                        abs(direction_to_vector(direction) * [
                            base_size[0]+h_unit*(borders[2]+borders[3])+0.001,
                            base_size[1]+v_unit*(borders[0]+borders[1])+0.001
                        ] / 2),
                        0
                    ])
                    square([2000, 1000]);
                }
            }
        }
    }
}

function direction_to_vector(direction) = (
    [
        [ 0,  1], // top
        [ 0, -1], // bottom
        [-1,  0], // left
        [ 1,  0], // right
    ][direction]
);

function direction_to_rotation(direction) = (
    [
        0, // top
        180, // bottom
        90, // left
        270, // right
    ][direction]
);
