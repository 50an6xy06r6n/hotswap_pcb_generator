include <parameters.scad>
include <param_processing.scad>

use <switch.scad>
use <mcu.scad>
use <trrs.scad>
use <stabilizer.scad>
use <standoff.scad>
use <via.scad>

module pcb(
    switch_layout,
    mcu_layout,
    trrs_layout,
    stab_layout,
    standoff_layout,
    via_layout
) {
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
            switch_socket_cutout($borders, $extra_data, $trim);
        }
        layout_pattern(mcu_layout) {
            mcu_pcb_cutout($borders, $extra_data, $trim);
        }
        layout_pattern(trrs_layout) {
            trrs_pcb_cutout($borders, $extra_data, $trim);
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

// 2-D outline of the PCB. Useful for subtracting from other things (e.g. cases)
module pcb_footprint(
    switch_layout,
    mcu_layout,
    trrs_layout,
    stab_layout,
) {
    difference() {
        union() {
            layout_pattern(switch_layout) {
                switch_footprint($borders);
            }
            layout_pattern(mcu_layout) {
                mcu_footprint($borders);
            }
            layout_pattern(trrs_layout) {
                trrs_footprint($borders);
            }
            layout_pattern(stab_layout) {
                stabilizer_footprint($borders, $extra_data);
            }
        }
        layout_pattern(switch_layout) {
            switch_footprint_trim($borders, $trim);
        }
        layout_pattern(mcu_layout) {
            mcu_footprint_trim($borders, $trim);
        }
        layout_pattern(trrs_layout) {
            trrs_footprint_trim($borders, $trim);
        }
        layout_pattern(stab_layout) {
            stabilizer_footprint_trim($borders, $extra_data[1], $trim);
        }
    }
}

pcb(
    switch_layout_final,
    mcu_layout_final,
    trrs_layout_final,
    stab_layout_final,
    standoff_layout_final,
    via_layout_final
);