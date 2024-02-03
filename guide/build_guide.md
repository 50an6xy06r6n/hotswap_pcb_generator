# Build Guide

### Introduction
This guide covers how to print, wire, and assemble your keyboard once you've finalized your design. If you only need the PCB you can skip the parts that cover physical assembly.

### Bill of Materials
#### Consumables:
- 3D-printed PCB
- 3D-printed plate or integrated-plate case (optional)
- 3D-printed backplate (optional)
- 2-3 colors of stranded 22AWG silicone wire
- 1N4148 through-hole diodes (one per switch)
- Key switches (type depends on your configuration)
- Microcontroller board (optional)
- TRRS socket (optional)
- M2 screws (one per standoff, optional)
- Self-adhesive rubber feet (recommended)
- Electrical tape (recommended)

#### Tools:
- 3D-printed diode-bending guide
- Utility knife (choose one with a narrow blade, like an Olfa or Xacto)
- Wire strippers
- Screwdriver (profile depends on your screws)
- 1mm drill bit and pin vise (optional)
- 1/16" drill bit (optional)
- Electric drill (optional)
- Sewing needle, sewing pin or drawing pin
- Flush cutters (recommended)
- Needlenose pliers (recommended)
- Tweezers (2A-SA profile recommended)
- Switch puller (recommended)

### Printing Tips
Plates, cases, and backplates are pretty straightforward to print, as long as your printer can produce reasonably accurate holes (&pm;0.2mm). The most important thing to remember on the plate is to try to avoid squishing the first layer too much (i.e. elephant's foot), as that can cause your holes to be undersized and require you to spend a bunch of time trimming away the excess material. If you're using a 1.5mm plate, you may want to adjust your first layer height to make sure you can hit that exactly (e.g. for 0.2mm layers, set the first layer height to 0.3mm). This isn't strictly necessary, as 1.6mm plates work almost as well (FR4 plates are 1.6mm). I usually use 2 perimeters on a 0.4mm nozzle and enough top/bottom layers to make the whole plate solid infill. An infill percentage of 15% is sufficient. No supports should be needed for anything.

When printing the PCB, you may want to slow down your perimeter speed because there are a lot of small features that can cause fit issues if they're a little out of spec. It's better to spend a little more time printing and save yourself time cleaning up a ton of tiny holes and channels that didn't quite come out right. You should also make sure your flow and retraction are calibrated properly so you don't get underextrusion on small features like standoffs and the tops of wire channels. If you're printing a staggered-row layout, you should print the PCB top-side-down so that you don't end up with a bunch of unsupported bridges and overhangs.

In general, I recommend printing out standalone switch, MCU, and TRRS sockets to test fit before you print the full PCB. You can use these test fits to tweak the values in `parameters.scad` to best suit your particular printing setup, as well as calibrate your printer for the holes etc.

### Print Cleanup
<p align="center"><img src="../img/build_guide/01_case_flatlay.JPG" width="750px"></p>

Unless your printer is super dialed-in, you'll probably need to do some amount of cleanup on your parts after you've printed them.
The tools you might need for this, depending on the issues you have, are a utility knife, a 1mm drill bit in a pin vise (which is a handle you use to hold tiny drill bits), and a 1/16" drill bit in an electric drill.

As mentioned previously, elephant's foot can cause issues with the switch cutouts in the plate. If you notice this, use your utility knife to trim off the excess. If you find yourself needing to take off a lot of material, it may be faster to tweak your print settings and print it again.

If any standoffs have their internal holes plugged up, the 1/16" drill bit is the exact size needed to create a good pilot hole that the screws can cut threads into.

On the PCB, the two most common issues involve the small holes that hold the switch pins. On the top side, the holes that hold the small plastic pins can easily get clogged up or be a little misshapen, causing the switch to not fit nicely, as in the image below). You can clear these holes by gently drilling them out with the 1/16" bit for a near-perfect fit.
<p align="center"><img src="../img/build_guide/02_socket_closeup.JPG" width="750px"></p>

On the bottom of the PCB, the small channels that the diode legs go through can also be easily clogged up.
If they aren't too clogged, especially if it's just a bit of elephant's foot, the sewing needle or pin can often get through these fine.
Otherwise, you can drill these out from the top with the 1mm bit. Be careful not to apply too much downward force, as you can easily snap the bit.
<p align="center">
    <img src="../img/build_guide/03_blocked_wire_channel.JPG" width="400px" style="padding: 10px">
    <img src="../img/build_guide/04_cleared_wire_channel.JPG" width="400px" style="padding: 10px">
</p>

The wire channels on the PCB can also be affected by print artifacts. Elephant's foot can cause the openings to be too narrow for the wire to be easily pressed into place. If this happens, use the utility knife to carefully trim away the excess material around the edges.

If the fit on the MCU socket is too tight for the MCU to snap in place, you may need to slightly trim or sand down the bottom tabs, or reprint the PCB with a slightly larger `mcu_length` value.

The TRRS socket has 4 small holes that go through the PCB and must be large enough to thread your wire through. The fit should be snug, but not overly tight. The 1/16" drill bit also seems to be a good size to clear out any printing artifacts. If the socket doesn't fit, you can trim the edges a bit, but you may be best off changing the model size slightly and reprinting.

Before you proceed you should do a test fit of each socket, as it's easier to correct issues before the PCB is wired up.
<p align="center"><img src="../img/build_guide/05_test_fits.JPG" width="750px"></p>

### Wiring
When wiring your PCB, it helps to use different colors for your row, column, and TRRS wires (if applicable). Use the PCB to measure out and cut each row and column wire, taking into account routing to the corresponding MCU pin and adding a bit of excess length just in case.
<p align="center">
    <img src="../img/build_guide/07_row_wires.JPG" width="400px" style="padding: 10px">
    <img src="../img/build_guide/08_column_wires.JPG" width="400px" style="padding: 10px">
</p>

Next you should measure out your wires for the TRRS socket. For these, you should start by threading one end up through the PCB so it sticks out past the socket. Lay it along the route you want it to take to the PCB and cut close to the final length. Once you have all 4 wires cut, insert each leg of the TRRS socket into the end of its corresponding wire. I recommend connecting the VCC wire to the tip contact and Ground to the sleeve contact, so that they don't short when the cable is plugged/unplugged. Pull gently downward on all the wires until the socket is sitting just above the PCB, and then press the socket into place. The wires with the socket legs should be slightly oversized for the holes in the PCB, creating a friction fit that holds the wires securely. Route the wires to the MCU socket.
<p align="center">
    <img src="../img/build_guide/10_trrs_wiring.JPG" width="400px" style="padding: 10px">
    <img src="../img/build_guide/11_via.JPG" width="400px" style="padding: 10px">
</p>

After you have all your wires cut you should attach them to the MCU. For each wire, strip ~5mm of insulation off the end and twist so that it stays together. If you're just prototyping, you can connect them to the MCU by simply threading the stripped end through the plated through hole and folding it over. When the MCU is snapped into the socket all the wires will be held in place reasonably securely. You're free to solder these joints if you need a more robust connection, but it's not strictly necessary. The row/column wires can be removed from their channels for this step, but the TRRS wires should be routed in their final configurations. I usually start with the TRRS wires since they are the most constrained. After you have all the wires connected you can snap the MCU in place to lock them in. It's easiest to start with the connector side in first so you can press down on the PCB without damaging the connector. Make sure all the wires are roughly perpendicular to the sides of the MCU so that they sit properly in their channels. Use the tweezers to make sure that adjacent wires aren't shorting with each other.
<p align="center">
    <img src="../img/build_guide/12_mcu_wired.JPG" width="400px" style="padding: 10px">
    <img src="../img/build_guide/13_mcu_installed.JPG" width="400px" style="padding: 10px">
</p>

### Diodes
<p align="center"><img src="../img/build_guide/14_diodes.JPG" width="750px"></p>

The diodes get their own section because they are the most tedious part of the build. I would highly recommend 3D-printing the diode bending guide, which makes the pre-bending step much faster and much more repeatable. The first step for each diode is to make a 90-degree bend in the diode's anode leg (the leg further from the black stripe) as close to the housing as possible. This will allow you to place the diode in the bending jig, and from there you just bend both legs down at a 90-degree angle. Repeat this step for each diode.
<p align="center">
    <img src="../img/build_guide/17_diode_template_placement.JPG" width="400px" style="padding: 10px">
    <img src="../img/build_guide/18_diode_leg_bends.JPG" width="400px" style="padding: 10px">
    <img src="../img/build_guide/19_bent_diode.JPG" width="400px" style="padding: 10px">
    <img src="../img/build_guide/20_bent_diodes.JPG" width="400px" style="padding: 10px">
</p>

The anode leg of each diode goes through the same hole in the socket as the bottom switch pin, while the cathode leg goes through the column wire on the back of the PCB. In order to get the diode leg through the wire, you must first pierce a hole through the wire using the sewing needle. Hold the wire down to the PCB on either side of the hole and poke the needle through the hole and through the wire. It may help to twist a bit as you push to ease it through. Make sure the needle went through the actual strands of wire and not just through the side of the insulation. Pull the needle all the way through and then carefully push the diode leg through the hole you just created. If you encounter too much resistance, just run the needle through again to widen the hole. Once the diode is through, bend the bottom leg to the right to lock the wire in place and ~bend the top leg upwards to lock the diode in place~ - Actually, don't do this. Use tape to hold the diode if you need to, but the first bend might be sufficent. Make sure the diode legs aren't touching each other, or you might get issues with ghosting using NKRO.
The pictures below have the wires touching, which shorts the diode and makes it pointless.
Trim the legs, leaving about 5mm on each.
<p align="center">
    <img src="../img/build_guide/21_wire_pierced.JPG" width="400px" style="padding: 10px">
    <img src="../img/build_guide/22_diodes_inserted.JPG" width="400px" style="padding: 10px">
    <img src="../img/build_guide/23_diodes_locked.JPG" width="400px" style="padding: 10px">
</p>

On each switch socket, use the utility knife to cut a slit in the row wire insulation where the top switch pin will be inserted. This isn't strictly necessary, but helps improve ease of installation and reduce the incidence of bent switch pins.
<p align="center"><img src="../img/build_guide/24_diodes_front.JPG" width="750px" style="padding: 10px"></p>

Note that either diode orientation will work, as long as you're consistent. The orientation described here corresponds to a `ROW2COL` diode direction in QMK.
(Note that the QMK default is COL2ROW, so be sure to change this in firmware).

### Testing
Before you assemble, it's a good idea to do a test fit of all the switches you want to use and test the switch matrix, as it's much easier to fix electrical problems before you have everything cased up. This will also slightly bend the diode and switch legs, making them easier to insert later. I use VIA to test the matrix, though if your firmware isn't VIA-enabled you can still just test every key and make sure the keyboard outputs the right values. See the [Firmware Guide](./firmware_guide.md) for instructions on how to create a VIA-enabled firmware and corresponding JSON file.

### Assembly (optional)
At this point the electronics are complete, so we can assemble the keyboard. If you're only using the PCB from this repo, you can assemble it according to whatever case you're using. For each standoff in your assembly, it's a good idea to precut the threads for easier assembly later. Place a screw in the pilot hole and press down firmly with your screwdriver. Screw it in slowly while continuing to apply downward pressure until the screw is as deep as you need it to go in your final assembly. Make sure that the end of the screw doesn't go past the bottom of the standoff, as this can cause the standoff to break off.
<p align="center"><img src="../img/build_guide/06_thread_cutting.JPG" width="750px"></p>

Remove the screws from the standoffs and assemble your keyboard based on your standoff layout. In this example the plate has all the standoffs, connecting to both the PCB and the backplate.
<p align="center">
    <img src="../img/build_guide/26_plate_attached.JPG" width="400px" style="padding: 10px">
    <img src="../img/build_guide/27_backplate_attached.JPG" width="400px" style="padding: 10px">
</p>

Finish off the assembly with some rubber feet on the bottom and install your switches.
<p align="center">
    <img src="../img/build_guide/28_feet_attached.JPG" width="400px" style="padding: 10px">
    <img src="../img/build_guide/29_switches_placed.JPG" width="400px" style="padding: 10px">
</p>

You're done! Post a picture on Reddit or something. I'd love to see what you came up with.
