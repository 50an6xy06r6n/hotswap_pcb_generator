include <parameters.scad>

/* Creates a flat 2D teardrop on the XY plane,
 * where no angle in the positive y direction is greater than 45º. */
module teardrop2d(radius, angle=teardrop_overhang_angle){
	// Find tangents on the circle at `angle` degrees
	// Radius is triangle hypotenuse
	function tangent_point(circle_r, angle) = [
        circle_r * cos(angle),
                 circle_r * sin(angle),
	];
    triangle_bl = tangent_point(radius, angle);
    // Top of teardrop should be such that from the tangent point to
    // the top has an angle of `angle`.
    // a = triangle_bl.x, o = teardrop tip y
    // tan(angle) = o/a
	teardrop_point = [0, tan(270 - angle) *  triangle_bl.x + triangle_bl.y];
	circle(radius);
	polygon([
		triangle_bl,
		tangent_point(radius, 180-angle),
		teardrop_point
	]);
}

// Skews the child geometry.
// xy: Angle towards X along Y axis.
// xz: Angle towards X along Z axis.
// yx: Angle towards Y along X axis.
// yz: Angle towards Y along Z axis.
// zx: Angle towards Z along X axis.
// zy: Angle towards Z along Y axis.
module skew(xy = 0, xz = 0, yx = 0, yz = 0, zx = 0, zy = 0) {
	matrix = [
		[ 1, tan(xy), tan(xz), 0 ],
		[ tan(yx), 1, tan(yz), 0 ],
		[ tan(zx), tan(zy), 1, 0 ],
		[ 0, 0, 0, 1 ]
	];
	multmatrix(matrix)
	children();
}

// Useful for manipulating layout elements
function slice(array, bounds, extra_data_override=undef, trim_override=undef) = [
    let(
        lower = bounds[0] >= 0 ? bounds[0] : max(len(array)+bounds[0], 0),
        upper = bounds[1] > 0 ? min(bounds[1], len(array)) : len(array)+bounds[1],
        step = len(bounds) == 3 ? bounds[2] : 1
    )
    for (i = [lower:step:upper-1]) ([
        array[i][0],
        array[i][1],
        extra_data_override ?
            extra_data_override :
            array[i][2],
        trim_override ?
            trim_override :
            array[i][3]
    ])
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

// Invert an array of items
function invert_layout(layout, invert=invert_layout_flag) = [
    for (item = layout)
        invert_layout_item(item, invert)
];

// Invert location and associated data
function invert_layout_item(layout_item, invert=invert_layout_flag) = (
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

// Swap left and right border values
function invert_borders(borders, invert=invert_layout_flag) =
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

// Position item according to KLE convention (i.e. move to a position and rotate around a specified point)
// Since the rotate() module operates around the origin, we move the item to its position
// relative to the point of rotation, perform the rotation, and then place the point of rotation
module position_item(layout_item) {
    $display_item = layout_item;
    location = layout_item[0];
    $borders = layout_item[1];
    $extra_data = layout_item[2];
    $trim = layout_item[3];

    switch_offset = (location[1]-1)/2;  // Coordinate offset based on key shape

    // Move into final position
    translate([location[2][1]*h_unit,-location[2][2]*v_unit,0]) {
        // Perform rotation
        rotate([0,0,location[2][0]]) {
            // Translate the item to put the center of rotation at the origin
            translate([
                (location[0][0]-location[2][1]+switch_offset)*h_unit,
                -(location[0][1] - location[2][2])*v_unit,
                0
            ]) {
                children();
            }
        }
    }
}

// The equivalent of position_item() that operates on coordinate vectors directly
// instead of geometry. Useful for doing math on an object's final position.
function calc_layout_location(location, offset=[0,0]) = (
    let(
        switch_offset = (location[1]-1)/2  // Coordinate offset based on key shape
    )
    // Move center of rotation to proper position
    [location[2][1]*h_unit,-location[2][2]*v_unit,0] +
    // Perform rotation
    rotate_vector(
        [0,0,location[2][0]],
        // Position of item relative to center of rotation
        [
            (location[0][0]-location[2][1]+switch_offset+offset[0])*h_unit,
            -(location[0][1] - location[2][2]-offset[1])*v_unit,
            0
        ]
    )
);

// The equivalent of the rotate() module that operates on a single point
function rotate_vector(angles, vector) = (
    let(
        a = angles[0],
        b = angles[1],
        c = angles[2],
        rot_x = [
            [1,      0,       0],
            [0, cos(a), -sin(a)],
            [0, sin(a),  cos(a)]
        ],
        rot_y = [
            [ cos(b), 0, sin(b)],
            [0,       1,      0],
            [-sin(b), 0, cos(b)]
        ],
        rot_z = [
            [cos(c), -sin(c), 0],
            [sin(c),  cos(c), 0],
            [     0,       0, 1]
        ]
    )
    // Rotate x then y then z (matches rotate() module)
    rot_z*rot_y*rot_x*vector
);

// Transfers children vertically to the specified plane while preserving geometry
// Allows you to specify features on a tilted plane (i.e. tented base) indexed
// off of existing layout features
module project_onto_plane(rotations, rotation_point, location, offset) {
    projected_pos = project_onto_plane(
        rotations,
        rotation_point,
        calc_layout_location(location, offset)
    );

    translate(projected_pos)
    rotate(rotations)
        children();
}

// Determines the point on a plan with the specified x-y coordinates
// Plane is defined by a series of rotations of the x-y plane around a specified point
function project_onto_plane(rotations, rotation_point, projection_xy) = (
    let(
        // calculate the base plane rotation
        before_offset = project_onto_plane_helper(rotations, projection_xy),
        // Since the z-offset from 0 is constant across the plane, we can determine the 
        // offset by inverting the z-distance of the rotation point from the plane
        // rotated around the origin.
        rotation_point_projection = project_onto_plane_helper(rotations, rotation_point),
        z_offset = rotation_point_projection[2] - rotation_point[2]
    )
    [
        before_offset[0],
        before_offset[1],
        before_offset[2] + z_offset
    ]
);

// Determines the point on a plan with the specified x-y coordinates
// Plane is defined by a series of rotations of the x-y plane around the origin
function project_onto_plane_helper(rotations, projection_xy) = (
    let(
        plane_norm = rotate_vector(rotations, [0,0,1]),
        x = projection_xy[0],
        y = projection_xy[1]
    )
    [
        x,
        y,
        -(plane_norm[0]*x + plane_norm[1]*y)/plane_norm[2]
    ]
);

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
