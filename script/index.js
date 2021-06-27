const kle = require("@ijprest/kle-serial");
const fs = require('fs')
const util = require('util')


var kle_filename = process.argv[2] ?? 'layout.json';
var output_filename = process.argv[3] ?? '../layout.scad';

try {
    var kle_json = fs.readFileSync(kle_filename, 'UTF-8');
} catch (err) {
    console.error(err);
}

var keyboard = kle.Serial.parse(kle_json);

var formatted_keys = keyboard.keys.map(
    key =>
        [
            [
                [key.x, key.y],
                [-key.rotation_angle, key.rotation_x, key.rotation_y]
            ],
            [key.width, [1, 1, 1, 1], false]
        ]

)

var file_content = formatted_keys.reduce(
    (total, key) => total + "  " + JSON.stringify(key) + ",\n",
    "base_layout = [\n"
);
file_content = file_content + "];\nbase_hole_layout = [];\n";

try {
    const data = fs.writeFileSync(output_filename, file_content);
} catch (err) {
    console.error(err);
}
