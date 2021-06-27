# 3D-Printable Hotswap Keyboard PCB Generator
![Example PCB](img/pcb_0.jpg)

This is an OpenSCAD script that can be used to generate 3D-printable hotswap "PCBs" for prototyping new keyboard layouts. I originally wrote this to help me prototype a split ergo layout without needing to solder/desolder all the switches every time. If you're only going to be building the keyboard once, this is probably a lot more work than just handwiring, but it might be useful if you're iterating on a design and want to reuse your switches. Currently only supports MX-style switches.

### Usage
The OpenSCAD script reads the layout data from the `layout.scad` header file, which you can either write by hand (the format is described in `default_layout.scad`) or generate from a KLE json file using the provided script:
```
cd script/
npm install
npm start -- <layout json file>
```
Once the basic layout is set there are more values you can tweak in `layout.scad` to change the footprint of the PCB or add standoff positions. Other parameters such as wire/pin diameters and pcb/plate thicknesses are contained in `parameters.scad`. These values are described in a bit more detail below.

### Assembly
1. Use `pcb.scad` to generate an STL for 3D printing. Column-staggered layouts can be printed as-is, while row-staggered layouts should be flipped for better printability. Any print settings should work, though you may want to tweak the hole sizes depending on your printer's tolerances and desired fit tightness. Make sure the holes are clear and that wires can be pushed into the wire channels without too much effort. A utility knife, a set of tiny drill bits, and a pin vise can help with this.

2. (Optional) If desired, you can use `plate.scad` to generate a basic plate STL.

3. Measure and cut wires for the rows and columns, and press them into the corresponding channels in the PCB. I recommend cutting them long, since swapping them out if they're too short will be a pain (especially the columns).

4. Next you want to insert the diodes. I designed this for glass 1N4148 diodes, though you can tweak the size of the diode cutout if the ones you have don't fit for some reason. Either orientation will work, as long as it's consistent. I put the cathode on the right, which corresponds to a `ROW2COL` diode direction in QMK. Bending diode legs is probably the most tedious part of the assembly, so it helps to develop a consistent technique so you can get into a rhythm. Start by bending the anode leg right next to the diode body, then use the diode bending template to make the vertical bends. The cathode leg needs to be pushed through the column wire, but isn't sharp or stiff enough to cut its own hole reliably, even in silicone-sleeved wire. I recommend using a sewing needle to pre-pierce a hole. Once the diode leg is through, bend it to the right to lock the diode and wire into place. Bend the anode leg upwards to lock it in place.

5. Use a utility/craft knife to cut slits in the row wires where the switch pins go. This isn't strictly necessary, as most of the time switch pins are sharp enough to cut through silicone insulation, but cutting the insulation beforehand will help prevent bent pins.

6. At this point you have a completed PCB, and you can mount it to your plate and add switches (as you would with any other PCB).

### Additional Context
My original design was inspired by [stingray127's handwirehotswap project](https://github.com/stingray127/handwirehotswap), with the key difference being that I wanted to use stranded wire for the row contacts. That design worked pretty well, but I was using diode legs to connect the sockets vertically, and those connections turned out to be pretty flaky. In addition, there was nothing holding the sockets in place besides friction with the switch legs, and when seating switches you had to be pushing up on the socket from the back. I solved these problems by just using another set of wires for the columns and combining all the sockets into a solid plate.

The design uses 22AWG stranded wire for the matrix rows and columns (wire gauge is configurable via `wire_diameter`), with the top switch pin plugging directly into the row wire and the diode cathode sticking through the column wire. The bottom switch pin makes contact with the diode anode, though that connection can be a bit finicky. I've solved this for now by putting a slight angle on the channel that holds the anode leg and switch pin, but it does slightly bend the switch pin in the process. The bend is pretty minor and can be easily bent back, but the angle is configurable via `diode_pin_angle` if you prefer not to have one. You can also use a bit of aluminum foil to solidify the contact point, but I found that to be too tedious in practice. Electrical integrity is pretty good overall once the switches are properly seated. Hole sizes and such are tuned to my printer, which isn't the most dimensionally accurate, so you may get a better fit by tweaking the hole sizes slightly. I also recommend generating the final STL with a larger `$fn` value (the edge count for circles), though it does take a while to finish.

The basic layout format matches the commonly-used Keyboard Layout Editor (KLE) format, and the provided node.js script can convert a KLE json into an SCAD file that is included in the main script as a header. I originally wanted to use the OpenSCAD customizer to do this, but it turns out that doesn't support nested vectors at the moment. There are also a couple of additional parameters on each key in the `base_layout` array pertaining to the geometry of the PCB that you might want to change. One affects how much the PCB extends past each socket, which allows you to trim off excess on the edges and connect parts that are not directly adjacent (such as thumb clusters). Another allows you to rotate the wire channels for the column wires, which is also useful for wiring parts that don't follow a grid, like thumb clusters.

The design was originally designed for use with staggered-column or ortholinear layouts, but there is experimental support for staggered-row layouts via the `layout_type` parameter. Note that staggered-row PCBs should be printed upside down for better printability.

By default, the plates are generated with a 5mm margin around the PCB, but this can be changed via the `plate_margin` variable. Default plate thickness is 1.5mm and is likewise controlled by `plate_thickness`.

Finally, there's also a `base_standoff_layout` parameter that you can use to add standoffs and clearance holes for mounting the PCB and plate together (or to mount the PCB to a separate case). Standoffs can be attached to either the plate or PCB, or be completely separated using the `standoff_type` parameter. Default standoff size is for M2 screws. You may need to tweak the `fit_tolerance` parameter a little bit if you find that the PCB and plate are too far apart due to print tolerances.
