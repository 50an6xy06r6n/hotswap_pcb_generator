const kle = require("@ijprest/kle-serial");
const fs = require('fs')
const util = require('util')


var kle_filename = process.argv[2] ?? 'layout.json';
var output_filename = process.argv[3] ?? '../scad/layout.scad';

try {
    var kle_json = fs.readFileSync(kle_filename, 'UTF-8');
} catch (err) {
    console.error(err);
}

var keyboard = kle.Serial.parse(kle_json);

var formatted_keys = keyboard.keys.map(
    key => {
        let side_border = ((key.width-1)/2);
        return [
            [
                [key.x, key.y],
                key.width,
                [-key.rotation_angle, key.rotation_x, key.rotation_y]
            ],
            [
                1,
                1,
                side_border ? "1+" + side_border.toString() + "*unit*mm" : 1,
                side_border ? "1+" + side_border.toString() + "*unit*mm" : 1,
            ],
            false
        ];
    }
)

var file_content =
`include <parameters.scad>
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
`
file_content += formatted_keys.reduce(
    (total, key) => total + "  " + JSON.stringify(key).replace(/"/g, "") + ",\n",
    "base_switch_layout = [\n"
);
file_content +=
`];

// MCU Position(s)
base_mcu_layout = [];

// TRRS Position(s)
base_trrs_layout = [];

// Stabilizer layout
//     (extra_data = [key_size, left_offset, right_offset, switch_offset=0])
//     (see stabilizer_spacing.scad for presets)
base_stab_layout = [];

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
`;

try {
    const data = fs.writeFileSync(output_filename, file_content);
} catch (err) {
    console.error(err);
}
