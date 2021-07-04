include <parameters.scad>
include <utils.scad>

use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <standoff.scad>

module pcb(key_layout, mcu_layout, trrs_layout, standoff_layout) {
    difference() {
        union() {
            layout_pattern(key_layout) {
                key_socket_base($borders);
            }
            layout_pattern(mcu_layout) {
                mcu($borders);
            }
            layout_pattern(trrs_layout) {
                trrs($borders);
            }
            layout_pattern(standoff_layout) {
                pcb_standoff($extra_data);
            }
        }
        layout_pattern(key_layout) {
            key_socket_cutouts($borders, $extra_data);
        }
        layout_pattern(standoff_layout) {
            pcb_standoff_hole($extra_data);
        }
    }
}

pcb(key_layout_final, mcu_layout_final, trrs_layout_final, standoff_layout_final);
