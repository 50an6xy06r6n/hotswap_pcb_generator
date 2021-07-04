include <parameters.scad>
include <utils.scad>


module mcu(borders=[0,0,0,0]) {
    translate([
        h_unit/2,
        -(mcu_v_unit_size*v_unit+mcu_socket_length)/2+2,
        0
    ]) rotate([0,layout_type == "row"?180:0,0]) translate([0,0,-pcb_thickness/2]) {
            if (mcu_type == "bare") {
                bare_mcu(invert_borders(borders,layout_type == "row"));
            } else if (mcu_type == "socketed") {
                socketed_mcu(invert_borders(borders,layout_type == "row"));
            } else {
                assert(false, "mcu_type is invalid");
            }
    }
}


module socketed_mcu(borders=[0,0,0,0]) {
    difference() {
        union() {
            // Base
            translate([-mcu_socket_width/2,-2,0]) 
                cube([mcu_socket_width,mcu_socket_length,pcb_thickness]);
            // Border
            translate([0,mcu_socket_length/2-2,pcb_thickness/2-1])
                border(
                    [mcu_h_unit_size*h_unit,mcu_v_unit_size*v_unit], 
                    borders, 
                    pcb_thickness-2
                );
        }
        // Wire Channels
        for (row = [-1,1]) {
            for (pin = [0:mcu_pin_count/2-1]) {
                translate([row*mcu_row_spacing/2,(pin+0.5)*mcu_pin_pitch,-wire_diameter/3]) 
                    cylinder(h=pcb_thickness,d=wire_diameter);
                translate([
                    row*(mcu_row_spacing/2-1),
                    (pin+0.5)*mcu_pin_pitch,
                    pcb_thickness-wire_diameter/3
                ]) rotate([0,row*90,0])
                    cylinder(h=1000,d=wire_diameter);
            }
        }
    }

     // Retention Tabs
    for (x = [-1,1]) {
        translate([x*(mcu_width+mcu_connector_width)/4,0,(pcb_thickness+mcu_height+1)/2]) {
            for (y = [-1,mcu_length+1]) {
                translate([0,y,0])
                    cube(
                        [(mcu_width-mcu_connector_width)/2,2,pcb_thickness+mcu_height+1],
                        center=true
                    );
            }
        }
        translate([x*(mcu_width+mcu_connector_width)/4,0,pcb_thickness+mcu_height+0.5]) {
            rotate([0,90,0]) {
                for (y = [0,mcu_length]) {
                translate([0,y,0]) 
                    cylinder(h=(mcu_width-mcu_connector_width)/2,d=1,center=true);
                }
            }
        }
    }

}

module bare_mcu(borders=[0,0,0,0]) {    
    difference() {
        union() {
            // Socket base
            translate([-mcu_socket_width/2,-2,0]) 
                cube([mcu_socket_width,mcu_socket_length,pcb_thickness+mcu_pcb_thickness]);
            // Border
            translate([0,mcu_socket_length/2-2,pcb_thickness/2-1])
                border(
                    [mcu_h_unit_size*h_unit,mcu_v_unit_size*v_unit], 
                    borders, 
                    pcb_thickness-2
                );
        }
        
        // Wire cutouts
        for (row = [-1,1]) {
            for (pin = [0:mcu_pin_count/2-1]) {
                translate([
                    row*(mcu_row_spacing/2-1),
                    (pin+0.5)*mcu_pin_pitch,
                    pcb_thickness-wire_diameter/3
                ]) rotate([0,row*90,0])
                    cylinder(h=1000,d=wire_diameter);
            }
        }
        // MCU cutout
        translate([-mcu_width/2,0,pcb_thickness]) 
            cube([mcu_width, mcu_length,mcu_pcb_thickness+1]);
        // Side cutout
        translate([-(mcu_socket_width+2)/2,0,pcb_thickness]) 
            cube([mcu_socket_width+2,mcu_pin_count/2*mcu_pin_pitch,mcu_pcb_thickness+1]);
        // USB cutout
        translate([-mcu_connector_width/2,-3,pcb_thickness]) 
            cube([mcu_connector_width,mcu_socket_length+2,mcu_pcb_thickness+1]);
        translate([-mcu_connector_width/2,mcu_length-mcu_connector_length,pcb_thickness-2]) 
            cube([mcu_connector_width,mcu_connector_length+3,pcb_thickness+1]);
        
        // Relief to let you pop the MCU out
        translate([0,0,pcb_thickness-1])
            cylinder(h=mcu_pcb_thickness+2,d=mcu_connector_width);
        translate([-mcu_connector_width/2,-3,pcb_thickness-1])
            cube([mcu_connector_width,3,mcu_pcb_thickness+2]);
    }

    // Retention Tabs
    for (x = [-1,1]) {
        translate([x*(mcu_width+mcu_connector_width)/4,0,(pcb_thickness+mcu_pcb_thickness+1)/2]) {
            for (y = [-1,mcu_length+1]) {
                translate([0,y,0])
                    cube(
                        [(mcu_width-mcu_connector_width)/2,2,pcb_thickness+mcu_pcb_thickness+1],
                        center=true
                    );
            }
        }
        translate([x*(mcu_width+mcu_connector_width)/4,0,pcb_thickness+mcu_pcb_thickness+0.5]) {
            rotate([0,90,0]) {
                for (y = [0,mcu_length]) {
                translate([0,y,0]) 
                    cylinder(h=(mcu_width-mcu_connector_width)/2,d=1,center=true);
                }
            }
        }
    }
}

module mcu_plate_base(borders=[0,0,0,0], thickness=plate_thickness) {
    translate([h_unit/2,-mcu_v_unit_size*v_unit/2,0]) {
        border(
            [mcu_h_unit_size*h_unit,mcu_v_unit_size*v_unit], 
            borders, 
            thickness
        );
    }
}

module mcu_plate_cutout(thickness=plate_thickness) {
    if (mcu_type == "bare") {
        translate([h_unit/2,-mcu_v_unit_size*v_unit/2,0]) {
            if (switch_type == "mx") {
                // Only connector will interfere, so limit cutout to that.
                // If mid-mounted this cutout can be eliminated with 
                // mcu_connector_length = 0
                border(
                    [mcu_width,mcu_length], 
                    [
                        1000,
                        mcu_connector_length-mcu_length,
                        (mcu_connector_width-mcu_width)/2,
                        (mcu_connector_width-mcu_width)/2
                    ], 
                    thickness+1
                );
            } else if (switch_type == "choc") {
                // The whole socket is too thick for choc plate spacing
                border(
                    [mcu_socket_width,mcu_socket_length], 
                    [1000,0,0,0], 
                    thickness+1
                );
            } else {
                assert(false, "switch_type is invalid");
            }
        }
    } else if (mcu_type == "socketed") {
        // Will interfere with plate, so cutout must fit the whole MCU. 
        // Extend cutout above for connector
        translate([h_unit/2,-mcu_v_unit_size*v_unit/2,0]) {
            border(
                [mcu_width,mcu_length], 
                [1000,0,0,0], 
                thickness+1
            );
        }
    } else {
        assert(false, "mcu_type is invalid");
    }
}

mcu();