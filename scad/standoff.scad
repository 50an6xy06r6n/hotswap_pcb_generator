include <parameters.scad>
include <utils.scad>

module standoff(height, solid=false) {
    difference() {
        translate([h_unit/2,-v_unit/2,0]) 
            cylinder(h=height,d=standoff_diameter,center=true);
        if (!solid) 
            standoff_hole(height+1);
    }
}

module standoff_hole(height) {
    translate([h_unit/2,-v_unit/2,0]) 
        cylinder(h=height,d=standoff_pilot_hole_diameter,center=true);
}

module standoff_screw_hole(depth) {
    translate([h_unit/2,-v_unit/2,0]) cylinder(h=depth,d=standoff_clearance_hole_diameter,center=true);
}

module standoff_through_hole(depth) {
    translate([h_unit/2,-v_unit/2,0]) cylinder(h=depth,d=standoff_diameter+1,center=true);
}

module pcb_standoff(standoff_config, solid=false) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    
    if (standoff_integration == "pcb") {
        height = standoff_attachment == "plate"
            ? pcb_plate_spacing + pcb_thickness/2 - plate_thickness - fit_tolerance
            : standoff_attachment == "backplate"
                ? pcb_backplate_spacing + pcb_thickness/2 - fit_tolerance
                : assert(false, str("standoff_config ", standoff_config," is invalid"));
        standoff_offset = standoff_attachment == "plate"
            ? height/2
            : standoff_attachment == "backplate"
                ? -height/2
                : assert(false, str("standoff_config ", standoff_config," is invalid"));
        
        translate([0,0,standoff_offset]) 
            standoff(height, solid);
    }
}

module plate_standoff(standoff_config, solid=false) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    
    if (standoff_integration == "plate") {
        height = standoff_attachment == "pcb"
            ? pcb_plate_spacing - min(border_z_offset * 2, 0) - fit_tolerance
            : standoff_attachment == "backplate"
                ? pcb_plate_spacing + pcb_thickness + pcb_backplate_spacing - fit_tolerance
                : assert(false, str("standoff_config ", standoff_config," is invalid"));
        standoff_offset = standoff_attachment == "pcb" || standoff_attachment == "backplate"
            ? -(height-plate_thickness)/2
            : assert(false, str("standoff_config ", standoff_config," is invalid"));
        
        translate([0,0,standoff_offset]) 
            standoff(height, solid);
    }
}

module backplate_standoff(standoff_config, solid=false) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    
    if (standoff_integration == "backplate") {
        height = standoff_attachment == "pcb"
            ? pcb_backplate_spacing + max(border_z_offset * 2, 0) - fit_tolerance
            : standoff_attachment == "plate"
                ? pcb_backplate_spacing + pcb_thickness + pcb_plate_spacing 
                    - plate_thickness - fit_tolerance
                : assert(false, str("standoff_config ", standoff_config," is invalid"));
        standoff_offset = standoff_attachment == "pcb" || standoff_attachment == "plate"
            ? height/2 + backplate_thickness/2
            : assert(false, str("standoff_config ", standoff_config," is invalid"));
        
        translate([0,0,standoff_offset]) 
            standoff(height, solid);
    }
}

module pcb_standoff_hole(standoff_config) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];

    if (
        (standoff_integration == "plate" && standoff_attachment == "pcb") || 
        (standoff_integration == "backplate" && standoff_attachment == "pcb") || 
        (standoff_integration == "separate" && standoff_attachment == "plate") ||
        (standoff_integration == "separate" && standoff_attachment == "backplate")
    ) {
        // Standoff screwed into PCB
        standoff_screw_hole(pcb_thickness+1);
    } else if (
        (standoff_integration == "plate" && standoff_attachment == "backplate") || 
        (standoff_integration == "backplate" && standoff_attachment == "plate") || 
        (standoff_integration == "separate" && standoff_attachment == "plate_backplate")
    ) {
        // Standoff goes through PCB
        standoff_through_hole(pcb_thickness+1);
    }
}

module plate_standoff_hole(standoff_config) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
       
    if (
        (standoff_integration == "pcb" && standoff_attachment == "plate") || 
        (standoff_integration == "backplate" && standoff_attachment == "plate") || 
        (standoff_integration == "separate" && standoff_attachment == "plate") ||
        (standoff_integration == "separate" && standoff_attachment == "plate_backplate")
    ) {
        // Standoff screwed into PCB
        standoff_screw_hole(pcb_thickness+1);
    } 
}

module backplate_standoff_hole(standoff_config) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
       
    if (
        (standoff_integration == "pcb" && standoff_attachment == "backplate") || 
        (standoff_integration == "plate" && standoff_attachment == "backplate") || 
        (standoff_integration == "separate" && standoff_attachment == "backplate") ||
        (standoff_integration == "separate" && standoff_attachment == "plate_backplate")
    ) {
        // Standoff screwed into PCB
        standoff_screw_hole(backplate_thickness+1);
    } 
} 

module case_standoff_hole(standoff_config) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
       
    if (
        (standoff_integration == "plate" && standoff_attachment == "pcb") || 
        (standoff_integration == "plate" && standoff_attachment == "backplate") 
    ) {
        height = pcb_plate_spacing + pcb_thickness + pcb_backplate_spacing + backplate_thickness;
        translate([0,0,-(height+plate_thickness)/2])
            standoff_hole(height);
    } 
}

standoff(10);