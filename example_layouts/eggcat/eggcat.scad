include <parameters.scad>
include <stabilizer_spacing.scad>

use <utils.scad>

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
        extra_data,                             // Extra data (depending on component type)
        [                                       // Trim (optional booleans)
            top_border,
            bottom_border,
            left_border,
            right_border
        ],
    ]
*/

// Keyswitch Layout
//     (extra_data = rotate_column)
base_switch_layout = [
    [[[0,0.125],1,[0,0,0]],[0,1,0,2],false],
    [[[0,1.125],1,[0,0,0]],[1,1,0,1],false],
    [[[0,2.125],1,[0,0,0]],[1,1,0,1],false],
    [[[0,3.125],1,[0,0,0]],[1,0,0,0],false],
    [[[1,0],1,[0,0,0]],[0,1,0,0],false],
    [[[1,1],1,[0,0,0]],[1,1,1,1],false],
    [[[1,2],1,[0,0,0]],[1,1,1,1],false],
    [[[1,3],1,[0,0,0]],[1,0,2,2],false],
    [[[2,0.125],1,[0,0,0]],[0,1,2,2],false],
    [[[2,1.125],1,[0,0,0]],[1,1,1,1],false],
    [[[2,2.125],1,[0,0,0]],[1,1,1,1],false],
    [[[2,3.125],1,[0,0,0]],[1,0,0,0],false],
    [[[3,0],1,[0,0,0]],[0,1,0,0],false],
    [[[3,1],1,[0,0,0]],[1,1,1,1],false],
    [[[3,2],1,[0,0,0]],[1,1,1,1],false],
    [[[3,3],1,[0,0,0]],[1,0,2,2],false],
    [[[4,0.125],1,[0,0,0]],[0,1,2,0],false],
    [[[4,1.125],1,[0,0,0]],[1,1,1,1],false],
    [[[4,2.125],1,[0,0,0]],[1,1,1,0],false],
    [[[4,3.125],1,[0,0,0]],[1,0,0,0],false],
    [[[5,0.25],1,[0,0,0]],[0,1,2,0],false],
    [[[5,1.25],1,[0,0,0]],[1,1,2,0],false],
    [[[5,2.25],1,[0,0,0]],[1,1+15*mm,2,0],false],
    [[[4.875,4.625],1.5,[60,4.875,4.625]],[30*mm,1,0.25*unit*mm,20*mm],true],
    [[[4.875,5.625],1.5,[60,4.875,4.625]],[1,0,0.25*unit*mm,20*mm],true, [false, true, false, false]],
];

// MCU Position(s)
base_mcu_layout = [
    [[[6,0.5],mcu_h_unit_size],[0,0,h_border_width,0]],
];

// TRRS Position(s)
base_trrs_layout = [
    [[[6.5,2.5],1,[-90,7,3]],[0,h_unit/2+h_border_width,0,20*mm]],
];

// Stabilizer layout
//     (extra_data = [key_size, left_offset, right_offset, switch_offset=0])
//     (see stabilizer_spacing.scad for presets)
base_stab_layout = [];

// Via layout
//     (extra_data = [via_width, via_length])
base_via_layout = [
    [[[5.5,3]]]
];

// Plate Layout (if different than PCB)
//     (extra_data = component_type)
base_plate_layout = [
    concat(
        slice(base_switch_layout, [0,-2], ["switch"]),
        [[[[6,0.5],mcu_h_unit_size],[-2,0,h_border_width,0], ["mcu"], [false, false, false, true]]],
        slice(base_trrs_layout, [0,0], ["trrs"])
    ),
    slice(base_switch_layout, [-2,0], ["switch"])
];

module additional_plate_cutouts() {
    position_item(
        invert_layout_item(
            set_item_defaults(base_mcu_layout[0]),
            invert_layout_flag
        )
    ) {
        translate([h_unit/2,-mcu_v_unit_size*v_unit/2,0])
        offset(10,$fn=360)
        offset(delta=-10)
        border_footprint(
            [mcu_socket_width,mcu_v_unit_size*v_unit], 
            invert_borders(
                [1000,(unit+trrs_plug_width)/2,0,100],
                invert_layout_flag
            )
        );
    }
}

// Whether to only use base_plate_layout to generate the plate footprint
use_plate_layout_only = true;

// Standoff layout
//     (extra_data = [standoff_integration_override, standoff_attachment_override])
base_standoff_layout = [
    // PCB-Plate standoffs
    [[[0.5,0.125]]],
    [[[0.5,3]]],
    [[[2.5,1.5]]],
    [[[3.5,3]]],
    [[[4.5,0.25]]],
    [[[4.875,5.125],1.5,[60,4.875,4.625]], [0,0,0,0]],
    // PCB-Backplate standoffs
    [[[-0.5,-0.375+.05*mm]],[0,0,0,0],["plate", "backplate"]],
    [[[-0.5,3.625]],[0,0,0,0],["plate", "backplate"]],
    [[[3.5,3.75]],[0,0,0,0],["plate", "backplate"]],
    [[[3,-0.53125]],[0,0,0,0],["plate", "backplate"]],
    [[[4.125,6.125],1.5,[60,4.875,4.625]],[0,0,0,0],["plate", "backplate"]],
    [[[6.5,3]],[0,0,0,0],["plate", "backplate"]],
    [[[5.5,-0.1875]],[0,0,0,0],["plate", "backplate"]],
    [[[7.125,0]],[0,0,0,0],["plate", "backplate"]],
];

// Whether to flip the layout
invert_layout_flag = false;

// Whether the layout is staggered-row or staggered-column
layout_type = "column";  // [column, row]

// Tenting
// Angle around y-axis (i.e. typing angle)
tent_angle_y = 5;
// Angle around x-axis
tent_angle_x = 5;
// Point around which keyboard is tented
tent_point = [0,4.125*19.05];
