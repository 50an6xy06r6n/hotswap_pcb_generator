include <parameters.scad>
include <utils.scad>

socket_length = trrs_length+4;
socket_width = trrs_width+4;
    

module wire_channel(length=pcb_thickness) {
    translate([0,0,-1]) cylinder(d=wire_diameter+.1,h=length+2);
}

module trrs(borders=[0,0,0,0]) {
    translate([h_unit/2,-socket_length,0])
        rotate([0,layout_type == "row"?180:0,0])
            translate([-socket_width/2,0,-pcb_thickness/2]) {
                if(trrs_type == "pj320a") {
                    pj320a_trrs(invert_borders(borders,layout_type == "row"));
                } else if(trrs_type == "pj324m") {
                    pj324m_trs(invert_borders(borders,layout_type == "row"));
                } else {
                    assert(false, "trrs_type is invalid");
                }
            }
}

module pj320a_trrs(borders=[0,0,0,0]) {
    difference() {
        union() {
            // Socket Base
            cube([socket_width,socket_length,pcb_thickness-2+trrs_flange_diameter*2/3]);
            translate([
                socket_width/2,
                socket_length-trrs_flange_length,
                pcb_thickness-2+trrs_flange_diameter/2
            ]) rotate([-90,0,0]) intersection() {
                cylinder(d=trrs_flange_diameter+2,trrs_flange_length);
                translate([0,0,trrs_flange_length/2]) 
                    cube([trrs_flange_diameter+2,trrs_flange_diameter/3,trrs_flange_length],center=true);
            }
            
            // Borders
            translate([socket_width/2,socket_length-v_unit/2,pcb_thickness/2-1])
                border(
                    [h_unit,v_unit], 
                    borders, 
                    pcb_thickness-2
                );
        }
        // Socket Cutout
        translate([4-trrs_flange_length,2,pcb_thickness-2]) 
            cube([trrs_width,trrs_length,trrs_height]);
        // Flange Cutout
        translate([
            socket_width/2,
            socket_length-1-trrs_flange_length,
            pcb_thickness-2+trrs_flange_diameter/2
        ]) rotate([-90,0,0]) 
            cylinder(d=trrs_flange_diameter,h=trrs_flange_length+2);
        
        // Wire Channels
        translate([(trrs_width-trrs_pin_spacing)/2+2,4-trrs_flange_length+0.5,0]) 
            wire_channel(pcb_thickness+trrs_height-3);
        for (y=[1.8,5.8,9.1]) {
            translate([(trrs_width+trrs_pin_spacing)/2+2,4-trrs_flange_length+y,0]) 
                wire_channel(pcb_thickness+trrs_height-3);
        }
        
        // Locating Pins
        for (y=[trrs_length-trrs_nub_offset,trrs_length-trrs_nub_offset-trrs_nub_spacing]) {
            translate([socket_width/2,4-trrs_flange_length+y,pcb_thickness-2-trrs_nub_height])
                cylinder(d=trrs_nub_diameter,h=pcb_thickness);
        }
    }
}

module pj324m_trs(borders=[0,0,0,0]) {

    difference() {
        union() {
            // Socket Base
            translate([0,-trrs_flange_length/2+1,0])
                cube([socket_width,socket_length+trrs_flange_length/2-1,pcb_thickness-2+trrs_flange_diameter*2/3]);
            translate([
                socket_width/2,
                socket_length-trrs_flange_length,
                pcb_thickness-2+trrs_flange_diameter/2
            ]) rotate([-90,0,0]) intersection() {
                cylinder(d=trrs_flange_diameter+2,trrs_flange_length);
                translate([0,0,trrs_flange_length/2]) 
                    cube([trrs_flange_diameter+2,trrs_flange_diameter/3,trrs_flange_length],center=true);
            }
            // Borders
            translate([socket_width/2,socket_length-v_unit/2,pcb_thickness/2-1])
                border(
                    [h_unit,v_unit], 
                    borders, 
                    pcb_thickness-2
                );
        }
        // Socket Cutout
        translate([2,4-trrs_flange_length,pcb_thickness-2]) 
            cube([trrs_width,trrs_length,trrs_height]);
        // Flange Cutout
        translate([
            socket_width/2-.25,
            socket_length-1-trrs_flange_length,
            pcb_thickness-2+trrs_flange_diameter/2
        ]) rotate([-90,0,0]) 
            cylinder(d=trrs_flange_diameter,h=trrs_flange_length+2);
        
        // Wire Channels
//        translate([(trrs_width-trrs_pin_spacing)/2+2,4-trrs_flange_length+0.5,0]) 
//            wire_channel(pcb_thickness+trrs_height-3);
//        for (y=[1.8,5.8,9.1]) {
        for( pos = [[-.25,12.5],[-4.85,8.3],[2.35,5.6],[4.95,4.6],[-4.85,1]] ){
            translate([(trrs_width+pos[0]*2)/2+2,4-trrs_flange_length+pos[1],0]) 
                wire_channel(pcb_thickness+trrs_height-3);
        }
        
        // Locating Pins
//        for (y=[trrs_length-trrs_nub_offset,trrs_length-trrs_nub_offset-trrs_nub_spacing]) {
//            translate([socket_width/2,4-trrs_flange_length+y,pcb_thickness-2-trrs_nub_height])
//                cylinder(d=trrs_nub_diameter,h=pcb_thickness);
//        }
    }
}

module trrs_plate_footprint(borders=[0,0,0,0]) {
    translate([h_unit/2,-v_unit/2,0])
        border_footprint(
            [h_unit,v_unit], 
            borders
        );
}

module trrs_plate_cutout_footprint() {
    if (switch_type == "mx") {
        // MX spacing is sufficient to fit the TRRS socket with no cutout, so we just need plug clearance
        translate([h_unit/2,-socket_length/2]) {
            border_footprint(
                [socket_width,socket_length], 
                [
                    1000,
                    -socket_length,
                    (trrs_plug_width-socket_width)/2,
                    (trrs_plug_width-socket_width)/2
                ]
            );
        }
    } else if (switch_type == "choc") {
        translate([h_unit/2,-socket_length/2]) {
            border_footprint(
                [socket_width,socket_length], 
                [1000,0,0,0]
            );
            border_footprint(
                [socket_width,socket_length], 
                [
                    1000,
                    -socket_length,
                    (trrs_plug_width-socket_width)/2,
                    (trrs_plug_width-socket_width)/2
                ]
            );
        }
    } else {
        assert(false, "switch_type is invalid");
    }
}

module trrs_plate_base(borders=[0,0,0,0], thickness=plate_thickness) {
    linear_extrude(thickness, center=true)
        trrs_plate_footprint(borders);
}

module trrs_plate_cutout(thickness=plate_thickness) {
    linear_extrude(thickness+1, center=true)
        trrs_plate_cutout_footprint();
}

module trrs_case_cutout() {
    translate([
        h_unit/2,
        0,
        plate_thickness/2-pcb_plate_spacing+trrs_flange_diameter/2-2
    ]) rotate([-90,0,0]) {
        cylinder(h=1000, d=trrs_plug_width);
        translate([-trrs_plug_width/2,-trrs_plug_width,0])
            cube([trrs_plug_width, trrs_plug_width, 1000]);
    }
}

trrs();
