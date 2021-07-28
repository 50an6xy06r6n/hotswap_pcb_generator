include <parameters.scad>
include <utils.scad>

use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <stabilizer.scad>
use <standoff.scad>
use <via.scad>

module pcb(switch_layout, mcu_layout, trrs_layout, stab_layout, standoff_layout, via_layout) {
    difference() {
        union() {
            layout_pattern(switch_layout) {
                switch_socket_base($borders);
            }
            layout_pattern(mcu_layout) {
                mcu($borders);
            }
            layout_pattern(trrs_layout) {
                trrs($borders);
            }
            layout_pattern(stab_layout) {
                stabilizer_pcb_base($borders, $extra_data);
            }
            layout_pattern(standoff_layout) {
                pcb_standoff($extra_data);
            }
        }
        layout_pattern(switch_layout) {
            switch_socket_cutout($borders, $extra_data);
        }
        layout_pattern(stab_layout) {
            stabilizer_pcb_cutout($extra_data);
        }
        layout_pattern(standoff_layout) {
            pcb_standoff_hole($extra_data);
        }
        layout_pattern(via_layout) {
            via($extra_data);
        }
    }
}

pcb(switch_layout_final, mcu_layout_final, trrs_layout_final, stab_layout_final, standoff_layout_final, via_layout_final);