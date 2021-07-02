include <parameters.scad>
include <utils.scad>
$fn=120;

socket_length = trrs_length+4;
socket_width = trrs_width+4;
    

module wire_channel(length=pcb_thickness) {
    translate([0,0,-1]) cylinder(d=wire_diameter+.1,h=length+2);
}

module trrs(borders=[0,0,0,0]) {
    translate([h_unit-trrs_length-4,-(v_unit+trrs_width+4)/2,-2])
        uxcell_trrs(borders);
}

module uxcell_trrs(borders=[0,0,0,0]) {
    difference() {
        union() {
            // Socket Base
            cube([socket_length,socket_width,2+trrs_flange_diameter*2/3]);
            translate([socket_length-trrs_flange_length,socket_width/2,pcb_thickness-2+trrs_flange_diameter/2]) rotate([0,90,0]) intersection() {
                cylinder(d=trrs_flange_diameter+2,trrs_flange_length);
                translate([0,0,trrs_flange_length/2]) cube([trrs_flange_diameter/3,trrs_flange_diameter+2,trrs_flange_length],center=true);
            }
            
            // Borders
            translate([socket_length-h_unit/2,socket_width/2,(pcb_thickness-2)/2])
                border(
                    [h_unit,v_unit], 
                    borders, 
                    pcb_thickness-2
                );
        }
        // Socket Cutout
        translate([2,4-trrs_flange_length,pcb_thickness-2]) 
            cube([trrs_length,trrs_width,trrs_height]);
        // Flange Cutout
        translate([
            socket_length-1-trrs_flange_length,
            socket_width/2,
            pcb_thickness-2+trrs_flange_diameter/2
        ]) rotate([0,90,0]) 
            cylinder(d=trrs_flange_diameter,h=trrs_flange_length+2);
        
        // Wire Channels
        translate([4-trrs_flange_length+0.5,(trrs_width+trrs_pin_spacing)/2+2,0]) 
            wire_channel(pcb_thickness+trrs_height-3);
        for (x=[1.8,5.8,9.1]) {
            translate([4-trrs_flange_length+x,(trrs_width-trrs_pin_spacing)/2+2,0]) 
                wire_channel(pcb_thickness+trrs_height-3);
        }
        
        // Locating Pins
        for (x=[trrs_length-trrs_nub_offset,trrs_length-trrs_nub_offset-trrs_nub_spacing]) {
            translate([4-trrs_flange_length+x,socket_width/2,pcb_thickness-2-trrs_nub_height])
                cylinder(d=trrs_nub_diameter,h=pcb_thickness);
        }
    }
}

module trrs_plate_base(borders=[0,0,0,0]) {
    translate([h_unit/2,-v_unit/2,0])
        border(
            [h_unit,v_unit], 
            borders, 
            plate_thickness
        );
}
switch_type = "choc";
module trrs_plate_cutout() {
    if (switch_type == "mx") {
        // MX spacing is sufficient to fit the TRRS socket with no cutout
    } else if (switch_type == "choc") {
        translate([h_unit-socket_length/2,-v_unit/2,])
                border(
                    [socket_length,socket_width], 
                    [0,0,0,1000], 
                    plate_thickness+1
                );
    } else {
        assert(false, "switch_type is invalid");
    }
}

trrs();