include <parameters.scad>
include <param_processing.scad>

module standoff_footprint() {
    translate([h_unit/2,-v_unit/2,0]) 
    circle(d=standoff_diameter);
}

module standoff(height, solid=false) {
    difference() {
        translate([h_unit/2,-v_unit/2,0]) 
            cylinder(h=height,d=standoff_diameter,center=true);
        if (!solid) 
            standoff_pilot_hole(height+1);
    }
}

module standoff_pilot_hole(height) {
    translate([h_unit/2,-v_unit/2,0]) 
        cylinder(h=height,d=standoff_pilot_hole_diameter,center=true);
}

module standoff_clearance_hole_footprint() {
    translate([h_unit/2,-v_unit/2,0]) 
    circle(d=standoff_clearance_hole_diameter);
}

module standoff_clearance_hole(depth) {
    translate([h_unit/2,-v_unit/2,0]) 
        cylinder(h=depth,d=standoff_clearance_hole_diameter,center=true);
}

module standoff_through_hole(depth) {
    translate([h_unit/2,-v_unit/2,0]) 
        cylinder(h=depth,d=standoff_diameter+1,center=true);
}

module standoff_counterbore(z_offset) {
    mirror_vec = z_offset > 0
        ? [0,0,0]
        : [0,0,1];
    mirror(mirror_vec)
    translate([h_unit/2,-v_unit/2,abs(z_offset)]) 
        cylinder(h=1000,d=standoff_counterbore_diameter);
}

module pcb_standoff(standoff_config, solid=false) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    
    if (standoff_integration == "pcb") {
        assert(
            standoff_attachment == "plate" || standoff_attachment == "backplate",
            str("standoff_config ", standoff_config," is invalid")
        );

        height = 
            standoff_attachment == "plate"
                ? pcb_plate_spacing + pcb_thickness/2 - plate_thickness - fit_tolerance
            : standoff_attachment == "backplate"
                ? pcb_backplate_spacing + pcb_thickness/2 - fit_tolerance
            : undef;
        standoff_offset =
            standoff_attachment == "plate" ? height/2
            : standoff_attachment == "backplate" ? -height/2
            : undef;
        
        translate([0,0,standoff_offset]) 
            standoff(height, solid);
    }
}

module standoff_config_footprint(target, standoff_config) {
    assert(
        target == "plate" || target == "backplate",
        str("Invalid standoff footprint target ", target, ".")
    );

    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    if (
        standoff_integration == "separate"
        || standoff_integration == target
        || standoff_attachment == target
    ) {
        standoff_footprint();
    }
}

module plate_standoff_footprint(standoff_config) {
    standoff_config_footprint("plate", standoff_config); 
}

module plate_standoff(standoff_config, solid=false) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    
    if (standoff_integration == "plate") {
        assert(
            standoff_attachment == "pcb" || standoff_attachment == "backplate",
            str("standoff_config ", standoff_config," is invalid")
        );

        height =
            standoff_attachment == "pcb"
                ? pcb_plate_spacing - min(border_z_offset * 2, 0) - fit_tolerance
            : standoff_attachment == "backplate"
                ? pcb_plate_spacing + pcb_thickness + pcb_backplate_spacing - fit_tolerance
            : undef;
        standoff_offset = -(height-plate_thickness)/2;
        
        translate([0,0,standoff_offset]) 
            standoff(height, solid);
    }
}

module backplate_standoff_footprint(standoff_config) {
    standoff_config_footprint("backplate", standoff_config); 
}

module backplate_standoff(standoff_config, solid=false) {
    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    
    if (standoff_integration == "backplate") {
        assert(
            standoff_attachment == "pcb" || standoff_attachment == "plate",
            str("standoff_config ", standoff_config," is invalid")
        );

        height =
            standoff_attachment == "pcb"
                ? pcb_backplate_spacing + max(border_z_offset * 2, 0) - fit_tolerance
            : standoff_attachment == "plate"
                ? pcb_backplate_spacing + pcb_thickness + pcb_plate_spacing - plate_thickness - fit_tolerance
            : undef;
        standoff_offset = height/2 + backplate_thickness/2;
        
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
        standoff_clearance_hole(pcb_thickness+1);
    } else if (
        (standoff_integration == "plate" && standoff_attachment == "backplate") || 
        (standoff_integration == "backplate" && standoff_attachment == "plate") || 
        (standoff_integration == "separate" && standoff_attachment == "plate_backplate")
    ) {
        // Standoff goes through PCB
        standoff_through_hole(pcb_thickness+1);
    }
}

module standoff_hole_footprint(target, standoff_config) {
    assert(
        target == "plate" || target == "backplate",
        str("Invalid standoff hole footprint target ", target, ".")
    );

    standoff_integration = standoff_config[0];
    standoff_attachment = standoff_config[1];
    if (
        standoff_integration == "separate"
        || standoff_attachment == target
    ) {
        standoff_clearance_hole_footprint();
    }
}

module plate_standoff_hole_footprint(standoff_config) {
    standoff_hole_footprint("plate", standoff_config);
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
        // Standoff screwed into plate
        standoff_clearance_hole(pcb_thickness+1);
    } 
}

module backplate_standoff_hole_footprint(standoff_config) {
    standoff_hole_footprint("backplate", standoff_config);
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
        // Standoff screwed into backplate
        standoff_clearance_hole(backplate_thickness+1);
        standoff_counterbore(-backplate_thickness/2);
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
            standoff_pilot_hole(height);
    } 
}

standoff(10);
