# OpenSCAD Source
`pcb.scad`, `case.scad`, `plate.scad`, and `backplate.scad` are the files responsible for generating the actual PCB, case, plate, and backplate STLs. `keyboard.scad` just combines all three relevant components so you can preview the final result before you print anything. There's also `diode_bending_template.scad`, which generates a small jig for bending the diode legs repeatably, though the STLs for these are already in the [`stl`](../stl) directory.

 General parameters for the PCB and plate come from `parameters.scad` and layout data comes from `layout.scad`. If you have a layout in KLE, you can use the [conversion script](../script) to generate a stub with the key positions converted. If `layout.scad` doesn't exist, layout data is taken from `default_layout.scad`, which contains default values (to avoid issues with undefined variables/modules).

 Below are descriptions of all the values that can be customized to suit your needs without breaking the code (I think). File an issue if a customization is broken or you have an idea for a feature.

### Layout Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `base_switch_layout` | Defines position, orientation, and size of each key socket, as well as the size of the border that connects each socket to adjacent ones. For each key, the layout looks like this: <pre>[<br/>&nbsp;&nbsp;[<br/>&nbsp;&nbsp;&nbsp;&nbsp;[x_location, y_location],<br/>&nbsp;&nbsp;&nbsp;&nbsp;key_size,<br/>&nbsp;&nbsp;&nbsp;&nbsp;[rotation, rotation_x, rotation_y]<br/>&nbsp;&nbsp;],<br/>&nbsp;&nbsp;[top_border, bottom_border, left_border, right_border],<br/>&nbsp;&nbsp;extra_data,<br/>&nbsp;&nbsp;[top_trim, bottom_trim, left_trim, right_trim]<br/>]</pre>All variables besides `x_location` and `y_location` are optional, though within each grouping values must be defined in order. For switches, border values define multiples of `border_width`, which is calculated from the difference between `socket_size` and `unit`. If you want to define the size of the border in mm, multiply by the `mm` variable, which does the conversion. If you have different vertical and horizontal spacing, use `h_mm` and `v_mm` instead. `extra_data` corresponds to the `rotate_column` parameter in the switch modules, which allows you to rotate the column wire channels for easier routing for things like thumb clusters. The `trim` parameters are used (if `use_plate_layout_only = true`) to indicate component edges that form hard outer boundaries of the plate. Anything that sticks out past that will be trimmed off. This can be useful when dealing with edges that meet at an external angle, where it may be hard to get borders to meet at a single point. | `layout.scad` |
| `base_mcu_layout` | Defines the position of an (optional) microcontroller daughterboard. Data format is identical to that of `base_switch_layout`, though `key_size` should be set to `mcu_h_unit_size`, which is the socket's width in key units calculated from `mcu_width` and `mcu_unit_resolution`. Border values are defined in mm. No `extra_data` is defined. | `layout.scad` |
| `base_trrs_layout` | Defines the position of an (optional) TRRS socket for a split layout. Data format is identical to that of `base_switch_layout`, with the socket pointing upwards. This allows the socket to be properly rotated when using the `invert_layout_flag`. Border values are defined in mm. No `extra_data` is defined. | `layout.scad` |
| `base_stab_layout` | Optional parameter that allows you to add stabilizer holes and cutouts to your PCB and plate/case. Data format is identical to that of `base_switch_layout`, where `extra_data` is a layout vector of the form `[key_size, left_offset, right_offset, switch_offset=0]`. Most of the stabilizer sizes you'll need are included in `stabilizer_spacing.scad`, and can be referenced by name (i.e. `2u`, `6_25u`, etc). You can usually add stabilizers to a key by copying its layout data, setting borders to `[1,1,1,1]`, and adding the `extra_data`. | `layout.scad` |
| `base_via_layout` | Defines the position of (optional) "vias" (i.e. holes) in the PCB that allow wires to be more cleanly routed from one side to the other. Data format is identical to that of `base_switch_layout`, with the via placed at the center of the key unit. Each via is an oblong hole constructed by hulling two cylinders. By default, via size is controlled by `via_width` and `via_length`, but this can be overridden for each via using `extra_data`. | `layout.scad` |
| `base_plate_layout` | Optional parameter that allows greater control when defining the shape of the plate and case. Unlike the other layout parameters, this is actually a vector of layouts in the `base_switch_layout` format. <br/><br/>If `use_plate_layout_only` is `false`, all elements in this parameter will be flattened and added to the hull used to define the plate shape (before the offset is applied). In this mode, it can be used to refine the overall shape of the plate, such as adding more room for longer modifier keys or squaring up the plate profile. <br/><br/>If `use_plate_layout_only` is `true`, then the plate shape is completely defined by `base_plate_layout`. In this mode, each layout within the vector is hulled individually, and the resulting shapes are unioned before the plate offset and fillets are applied. This mode can be used to create concave plate shapes not possible with simple hulling operations. `extra_data` for each element is a vector `[component_type, extra_extra_data]`, where `component_type` is selected from `["switch", "mcu", "trrs", "stab"]`, and `extra_extra_data` is anything you want passed down to the component's plate footprint extra data (currently only relevant for stabilizers). "switch" is the default. Since this mode requires all key positions to be copied, I've provided a `slice()` helper that can be used to partially copy the existing switch layout. See `default_layout.scad` for an example of this usage mode. | `layout.scad` |
| `additional_plate_cutouts()` | Unlike all the other parameters, this is a module, not a variable. You can use it to define custom cutouts in the plate (also applies to cases). You can use `position_item()` from `utils.scad` to help place the cutouts relative to existing components. The sample `layout.scad` uses this to create a large cutout above the MCU and TRRS. | `layout.scad` |
| `use_plate_layout_only` | Changes the way the plate profile is generated. For more details, see `base_plate_layout`. | `layout.scad` |
| `base_standoff_layout` | Defines the position of each (optional) standoff. Data format is identical to that of `base_switch_layout`, with the standoff placed at the center of the key unit. This makes it means that you can place a standoff in between two keys by just averaging their positions. By default, standoffs are configured according to the `standoff_integration_default` and `standoff_attachment_default` parameters defined in `parameters.scad`, but these can be overridden on a per-standoff basis using the `extra_data` parameter. | `layout.scad` |
| `invert_layout_flag` | If set to true, the layout will be inverted when generating the PCB and plate. This is handy for split layouts with identical left and right hands, as it saves you the trouble of copying over any changes you make to the borders and standoff positions. | `layout.scad` |
| `layout_type` | This can be set to either `column` or `row` (depending on the layout stagger), and affects which side the recessed grid is printed on, which is necessary for routing matrix wires that don't run in a straight line. For row-staggered layouts, the grid will be on the bottom (column-side) of the PCB, so it will be easier to print upside down. | `layout.scad` |
| `tent_angle_x` | Angle at which the keyboard is tilted around the x-axis. Currently unimplemented. | `layout.scad` |
| `tent_angle_y` | Angle at which the keyboard is tilted around the y-axis. Currently unimplemented. | `layout.scad` |
| `tent_point` | Point around which the keyboard is tented. This is the point that will stay at 0 elevation above the desk. Useful for positive typing angles. | `layout.scad` |

### PCB Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `wire_diameter` | The diameter of wire (in mm) used for the matrix. The default value of 2.15 works for 22AWG silicone-sleeved wire, which is what I used, but it can be tweaked based on your fit preferences or a different kind of wire. | `parameters.scad` |
| `diode_pin_angle` | This changes the angle of the channel that forms the bottom switch pin socket. The bottom switch pin makes contact the diode anode leg, and the connection can sometimes be a bit flaky. Slightly angling the channel upwards forces the switch pin into the diode leg as it's inserted, and makes for a more robust connection. This can put a slight bend in the switch pin that can be easily bent back (the bottom pin tends to be the sturdier of the two), but if you don't want that you can set the angle to 0. | `parameters.scad` |
| `diode_foldover` | Length that the diode folds over on the back of the PCB. Only applies when `use_folded_contact = true` | `parameters.scad` |
| `pcb_thickness` | Defines the overall thickness of the PCB. This must be at least 4mm, which is the minimum needed to fit both row and column wires. Can be increased if you want a sturdier PCB. | `parameters.scad` |
| `pcb_type` | If you decide to have a traditional PCB fabricated for your board, you can change this from `printed` to `traditional` to help convert your existing case. Currently it just adjusts the height of the plate-to-PCB standoffs, since a traditional PCB won't have the step between the base of the socket and the wire routing area. | `parameters.scad` |

### Switch Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `switch_type` | This can be set to either `mx` or `choc`, depending on the type of switch you plan to use. This changes the PCB cutouts, as well as the plate thickness and spacing used for standoffs. Support for other switch types is possible if I'm able to obtain them. | `parameters.scad` |
| `switch_orientation` | This can be set to either `north` or `south`, and defines the LED orientation of the switch. South-facing offers better compatibility with Cherry-profile keycaps, while north-facing may result in better illumination of shine-through legends (though there is not yet support for LEDs). | `parameters.scad` |
| `use_folded_contact` | This generates an experimental socket for MX switches that provides more robust hotswap contacts at the expense of more complexity when bending diodes. | `parameters.scad` |

### Stabilizer Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `stabilizer_type` | This can be set to either `pcb` or `plate`. The plate cutouts for both are the same, and the only difference is that `pcb` adds holes in the PCB, so I recommend just always using `pcb`. | `parameters.scad` |

### Case Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `case_type` | This can be set to `sandwich`, `plate_case`, or `backplate_case`, and defines the structure of the optional case. `sandwich` is the most basic, and consists of a switch plate, PCB, and backplate connected by standoffs. `plate_case` is an integrated-plate case, where the sides are enclosed by a wall connected to the plate. The backplate is slightly inset into the case. `backplate_case` is currently unimplemented, but will likely be some kind of tray-mount case. | `parameters.scad` |
| `case_wall_thickness` | Thickness of the case wall, if applicable. Default value of 2 is probably the minimum recommended thickness. | `parameters.scad` |
| `case_wall_draft_angle` | Angle at which the case walls slope outwards. Only used when `use_plate_layout_only = false`, as the technique used only works on convex profiles. | `parameters.scad` |
| `case_chamfer_width` | Width of the chamfer on the top of the case. Only used when `use_plate_layout_only = false`, as the technique used only works on convex profiles. | `parameters.scad` |
| `case_chamfer_angle` | Angle (from horizontal) of the chamfer on the top of the case. Only used when `use_plate_layout_only = false`, and the technique used only works on convex profiles. | `parameters.scad` |
| `case_base_height` | Height of the vertical portion of the case wall at its base. Only applies when a draft angle is applied to the case wall. Does not include the height of the backplate flange. | `parameters.scad` |
| `case_fit_tolerance` | Fit tolerance between interlocking case parts (e.g. an integrated-plate case and its backplate), so that they can be easily taken apart when unscrewed. Default value of 0.2 creates a pretty snug fit that doesn't get stuck. | `parameters.scad` |

### Plate Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `plate_margin` | Defines how far the plate sticks out beyond the PCB. If you wish to have more granular control over the plate shape, you can set this to 0 and generate a separate layout for the plate and edit the borders directly. | `parameters.scad` |
| `plate_outer_fillet` | Radius of outer fillets on the plate. | `parameters.scad` |
| `plate_inner_fillet` | Radius of inner fillets on the plate. Can be set large for nice curves on thumb cluster connections, for example. | `parameters.scad` |
| `plate_precision` | **[DEPRECATED - You should use the `trim` parameter in the layout section to fix this issue]** Approximate point precision (in mm) of the basic plate outline. This setting allows vertices placed near enough each other to be merged when using the plate layout override. Since not all the elements are hulled, adjacent elements that are angled with each other and meet at a point (such as in a thumb cluster) may not meet exactly at a point, creating a weird jagged edge when the plate offset is applied. The default layout has an example of this where the thumb cluster meets the footprint of the TRRS socket. The default value of 1/100 is a good balance of usability and precision, but if you're having trouble getting rid of the jagged edges you can lower it. | `parameters.scad` |

### Backplate Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `backplate_thickness` | Defines the thickness of the backplate. | `parameters.scad` |
| `backplate_case_flange` | If using the `plate_case` case type, this defines the thickness of the flange that forms the bottom surface of the case. | `parameters.scad` |
| `pcb_backplate_spacing` | Defines the distance between the bottom of the PCB and the top of the backplate. Can be decreased for a lower profile or increased for more room to route wires. | `parameters.scad` |

### MCU Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `mcu_type` | This can be set to `bare` or `socketed`, depending on whether your MCU has pins soldered into it. Bare MCUs are a little easier to wire up and are lower-profile. Socketed MCUs are a little more tricky to wire and stick up more, but if you have an MCU salvaged from a previous build it's likely to have the pins already soldered in. | `parameters.scad` |
| `mcu_width` | Width of the daughterboard PCB in mm. Default value of 18 works for Pro Micro footprint. | `parameters.scad` |
| `mcu_length` | Length of the daughterboard PCB in mm. Default value of 33 works for Pro Micro footprint. | `parameters.scad` |
| `mcu_height` | Distance from the top of the daughterboard PCB to the base of the header pins in mm. Default value of 4.25 works for Pro Micro footprint on generic square header pins. Only relevant for socketed MCUs. | `parameters.scad` |
| `mcu_row_spacing` | Center-to-center distance between rows of pins in mm. Default value of 15.24 (0.6 inches) works for Pro Micro footprint. | `parameters.scad` |
| `mcu_row_count` | Number of pin rows. Currently can't be changed from the default value of 2, as I don't know of any boards like that, and it would make the code very complicated. | `parameters.scad` |
| `mcu_pin_count` | Total number of pins on the daughterboard. Default value of 24 works for Pro Micro footprint. | `parameters.scad` |
| `mcu_pin_pitch` | Center-to-center distance between adjacent pins in mm. Default value of 2.54 (0.1 inches) is pretty standard and works for Pro Micro footprint. | `parameters.scad` |
| `mcu_pin_offset` | Offset from the rear of the daughterboard to the boundary of the nearest pin. Default of value of 0 works for Pro Micro footprint, and any other board where the pins extend all the way to the back of the board. | `parameters.scad` |
| `mcu_connector_width` | Width of the daughterboard connector (for making plate cutouts) in mm. Default value of 13 works for Micro-USB and USB-C connectors. May not be necessary for mid-mount connectors that don't stick very far above the board (i.e. Elite-C). | `parameters.scad` |
| `mcu_connector_length` | Length that the daughterboard connector extends into the board (for making plate cutouts) in mm. Default value of 4 works for Micro-USB and USB-C connectors. May not be necessary for mid-mount connectors that don't stick very far above the board (i.e. Elite-C). | `parameters.scad` |
| `mcu_connector_height` | Height of the connector plug you intend to use in mm, for plate/case cutouts. Default value of 8 should cover most Micro-USB and USB-C cables. | `parameters.scad` |
| `mcu_connector_offset` | Distance between the center plane of the daughterboard connector and the center plane of the daughterboard PCB in mm, used for making accurate case cutouts. Default value of 2 works for Pro Micro. | `parameters.scad` |
| `mcu_pcb_thickness` | Thickness of the daughterboard PCB. Default value of 1.6 is pretty standard. | `parameters.scad` |
| `mcu_socket_width` | Width of the socket holding the MCU. Default value of `mcu_width + 4` works pretty well. | `parameters.scad` |
| `mcu_socket_length` | Length of the socket holding the MCU. Default value of `mcu_length + 4` works pretty well. | `parameters.scad` |
| `expose_mcu` | Experimental feature to create a cutout in the plate above the MCU, to allow status lights to be seen and/or pins to be accessed. Also looks cool maybe? | `parameters.scad` |

### TRRS Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `trrs_width` | Width of the TRRS socket in mm. Default value of 6 works for the popular PJ-320A socket. | `parameters.scad` |
| `trrs_length` | Length of the TRRS socket in mm (not including the round flange). Default value of 12.1 works for the popular PJ-320A socket. | `parameters.scad` |
| `trrs_height` | Height of the TRRS socket in mm. Default value of 5 works for the popular PJ-320A socket. | `parameters.scad` |
| `trrs_flange_length` | Length of the round flange (where the plug inserts) in mm. Default value of 2 works for the popular PJ-320A socket. | `parameters.scad` |
| `trrs_flange_diameter` | Diameter of the round flange (where the plug inserts) in mm. Default value of 5 works for the popular PJ-320A socket (though this may vary slightly by manufacturer). | `parameters.scad` |
| `trrs_pin_spacing` | Distance between the two rows of pins in mm. Default value of 4.4 works for the popular PJ-320A socket. | `parameters.scad` |
| `trrs_nub_diameter` | Diameter of the little plastic locating nubs at the bottom of the socket in mm. Default value of 1.5 works for the popular PJ-320A socket. | `parameters.scad` |
| `trrs_nub_height` | Height of the little plastic locating nubs at the bottom of the socket in mm. Default value of 1 works for the popular PJ-320A socket. | `parameters.scad` |
| `trrs_nub_spacing` | Space between the little plastic locating nubs at the bottom of the socket in mm. Default value of 7 works for the popular PJ-320A socket. | `parameters.scad` |
| `trrs_nub_offset` | Offset between the front of the socket and the closest locating nub in mm. Default value of 1.5 works for the popular PJ-320A socket. | `parameters.scad` |
| `trrs_plug_width` | Width of the TRRS plug being used, for plate/case cutouts. | `parameters.scad` |

### Via Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `via_width` | Width of the via (also the diameter of the rounded end). This can be overridden for an individual via via `extra_data`. | `parameters.scad` |
| `via_length` | Total length of the via (including the rounded ends). This can be overridden for an individual via via `extra_data`. | `parameters.scad` |

### Standoff Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `standoff_integration_default`,<br>`standoff_attachment_default` | These two parameters define what component standoffs are integrated with and screwed into by default. Individual standoffs can overridde these values via `extra_data`. `standoff_integration_default` can be selected from the set `[plate, backplate, pcb, separate, none]`, while `standoff_attachment_default` comes from the set `[plate, backplate, pcb, plate_backplate, none]`.However, not all combinations are valid. For example, the two parameters cannot be the same (except for `none`), and the `plate_backplate` attachment parameter only works with `separate` standoffs. `separate` standoffs also can't have the `pcb` attachment, as they are attached to the PCB by default, and the parameter specifies the other component they're attached to. | `parameters.scad` |
| `standoff_diameter` | Defines the diameter of generated standoffs. Values greater than 5mm may interfere with plate cutouts if placed between keys. Default value is set for M2 screws. | `parameters.scad` |
| `standoff_clearance_hole_diameter` | Defines the size of through holes for standoff screws. Default value is set for M2 screws. | `parameters.scad` |
| `standoff_pilot_hole_diameter` | Defines the size of pilot holes for standoff screws. This diameter should be sized such that the screw can cut threads into the plastic. Default value is set for M2 screws. | `parameters.scad` |
| `standoff_counterbore_diameter` | Defines the size of counterbore holes for standoff screw heads. Useful for tented baseplates, and other instances where you want the screws to be recessed. Default value is set for M2 screws. | `parameters.scad` |

### Cutout Grid Parameters:
| `cutout_grid_size` | Size of the holes in the grid cutout pattern. What that means exactly depends on the pattern. | `parameters.scad` |
| `cutout_grid_spacing` | Space between holes in the grid cutout pattern. Can also be thought of as the width of the lines in the mesh. | `parameters.scad` |

### Misc Parameters:
| Name | Description | Location |
| ---- | ----------- | -------- |
| `fit_tolerance` | This can be used to compensate for vertical print tolerances between the standoffs and the PCB/plate that place them too far apart. Should only be a couple tenths of a millimeter at most. | `parameters.scad` |
| `$fn` | This defines the resolution of generated circles. When previewing, this is set to 12 for quick rendering. When generating final STLs, it's set to 60 for more accurate hole shapes. You can tweak these parameters as needed. | `parameters.scad` |

### Advanced Parameters
| Name | Description | Location |
| ---- | ----------- | -------- |
| `unit` | Defines the size of "1U" in the layout. | `parameters.scad` |
| `h_unit` | Defines the size of "1U" horizontally. By default this is set to `unit`, but can be changed independently. Horizontal spacing for Choc keycaps is 18mm. | `parameters.scad` |
| `v_unit` | Defines the size of "1U" vertically. By default this is set to `unit`, but can be changed independently. Vertical spacing for Choc keycaps is 17mm. | `parameters.scad` |
| `grid` | Defines the size of the grid used for positioning elements in the MX switch footprint. Shouldn't need to be changed. | `parameters.scad` |
| `socket_size` | Size of the socket footprint for the switch. Shouldn't need to be changed. | `parameters.scad` |
| `socket_depth` | Depth of the holes in the PCB for the switch pins and legs (in mm). 3.5mm should be enough for all the common switch types, but you can increase it if you're hitting the bottom for some reason. Note that this will create more perimeters and increase print time. | `parameters.scad` |
| `plate_thickness` | Defines the thickness of the plate. This is already set for both MX and Choc switches, but can be tweaked for tighter/looser fits or to compensate for print tolerances. Note that these are not multiples of 0.2mm, so if you're printing at a 0.2mm layer height you should set a 0.3mm first layer height for accurate results. | `parameters.scad` |
| `plate_cutout_size` | Defines the size of the plate cutouts. This can be adjusted to compensate for print tolerances or for a tighter/looser fit. | `parameters.scad` |
| `pcb_plate_spacing` | Defines the distance between the PCB and plate (used to calculate standoff length). This is predefined for MX and Choc switches. If you find that the spacing is slightly off, I recommend tweaking the `fit_tolerance` parameter first. | `parameters.scad` |
| `mcu_unit_resolution` | Size of the grid to align the MCU footprint size to (done for ease of layout positioning). Default value of 0.5 seems to work pretty well for the Pro Micro. | `parameters.scad` |
