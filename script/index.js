const kle = require("@ijprest/kle-serial");
const fs = require('fs')
const util = require('util')


var layout_filename = process.argv[2] ?? 'layout.json';

try {
    var layout_json = fs.readFileSync(layout_filename, 'UTF-8');
} catch (err) {
    console.error(err);
}

var keyboard = kle.Serial.parse(layout_json);

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

console.log(JSON.stringify(formatted_keys));
