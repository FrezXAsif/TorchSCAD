# 🔦 Smart Torch Enclosure: Master Engineering & CAD Blueprint

## 🎯 Project Goal
Design a production-ready, 3D-printable clamshell enclosure for a handheld "Smart Torch." The torch integrates a 4G LTE cellular module, an ESP32 microcontroller, I2S audio (Mic + Amp + Speaker), an OLED display, and a 40mm salvaged flashlight reflector. 

The enclosure must physically secure all components without relying on glue, provide a dedicated "Wiring Valley" for jumper routing, support capacitive touch interfaces through the outer shell, and be optimized for FDM 3D printing without complex, failing geometries.

---

## 📦 Hardware Inventory & Exact Clearances

| Component | Dimensions (X, Y, Z) | Shape/Notes | Color (X-Ray) |
| :--- | :--- | :--- | :--- |
| **ESP32 CP2102** | 29mm x 52mm x 5mm | Rectangular board | Black |
| **SIM A7670C** | 32mm x 45mm x 5mm | Rectangular board | Green |
| **OLED (0.96")** | 28mm x 28mm x 4mm | Needs flush front window | Cyan |
| **INMP441 Mic** | 14mm dia x 2mm | **Round disk**, pinhole needed | Black |
| **Speaker (8-Ohm)** | 18mm dia x 5mm | Round disk, needs grill | White/Black |
| **MAX98357A Amp** | 20mm x 18mm x 3mm | Free-floating in wiring valley| Orange |
| **TP4056 Charger**| 17mm x 27mm x 5mm | Needs bottom USB-C slot | Blue |
| **18650 Battery** | 18mm dia x 65mm | Heavy cylinder, needs clips | Grey |
| **Antenna (SIM)** | ~15mm x 40mm | Flat paper/PCB, sticks to wall | Dark Green |
| **Reflector Cone**| 40mm (Top) to 13mm (Bot) | 32mm height, conical | White |
| **Top Glass** | 40mm dia x 2mm | Flush mount at top rim | Translucent |

---

## 🏗️ Architectural Layout (Z-Axis Zones)

The internal height of the torch is **175mm**. It is divided into three strict zones separated by physical plastic shelves:

1. **Zone 1: Power Basement (Z = 0mm to 80mm)**
   * **Floor:** TP4056 charger locked in a 3-walled containment box at Z=0.
   * **Back:** 18650 Battery held by aggressive C-Clips.
   * **Front:** 18mm Speaker mounted against a honeycomb grill.
   * **Ceiling:** Mid-Shelf at Z=80mm with a 16x10mm center hole for routing power wires up.

2. **Zone 2: Brain Room & Wiring Valley (Z = 80mm to 135mm)**
   * **Front Wall:** ESP32 secured in slotted rails. OLED bracket and Mic horseshoe bracket mounted in front of it.
   * **Back Wall:** SIM A7670C secured in slotted rails. Antenna plastered to the upper right side-wall.
   * **Center Void:** A 20mm empty gap between the boards for folding jumper wires and stashing the MAX98357A Amp.
   * **Right Outer Wall:** 4x Recessed 10x10mm squares with 2mm through-holes for copper capacitive touch pads.

3. **Zone 3: Light Chamber (Z = 135mm to 175mm)**
   * **Basket:** A thin conical basket tapering from 44mm down to 17mm to cradle the physical reflector cone.
   * **Rim:** A 2mm stepped lip at the absolute peak to hold the 40mm glass flush.

---

## ✅ The Exhaustive CAD & Execution Checklist

Before finalizing the CAD model or exporting STLs, verify every single item below.

### 1. Outer Shell & Ergonomics
- [ ] **Dimensions:** Total bounding box is exactly 52mm (W) x 48mm (D) x 175mm (H).
- [ ] **Thickness:** Uniform 3mm wall thickness on all sides.
- [ ] **Fillets:** 8mm corner rounding on the long vertical edges for an ergonomic grip.
- [ ] **Clamshell Split:** Model is mathematically sliced exactly in half along the depth (Y-axis), leaving a distinct Front Half and Back Half.

### 2. Front Casing (UI & Fastening)
- [ ] **USB-C Port:** 12x6mm cutout at the bottom seam.
- [ ] **Speaker Grill:** 35mm up from bottom. Symmetrical honeycomb pattern of 1.5mm holes tightly packed within an 18mm diameter boundary.
- [ ] **Speaker Ring:** Internal retaining ring (22mm outer, 18.5mm inner) to secure the speaker flush against the grill.
- [ ] **OLED Window:** 28x28mm cutout positioned 96mm up from the bottom.
- [ ] **OLED Bracket:** Internal 32x32mm frame surrounding the window to hold the screen PCB perfectly flat.
- [ ] **Mic Bracket (Round):** 14.5mm internal horseshoe/drop-in bracket positioned above the OLED, with a 3mm pinhole through the outer wall. **Must not overlap the OLED.**
- [ ] **ESP32 Rails:** Dual vertical grooves spaced exactly 29mm apart, starting at Z=84. Includes a bottom solid ledge (floor) and top Z-stop blocks so the board cannot slide vertically.
- [ ] **Female Bosses (Front):** Four 7x7x7mm solid blocks anchored *flush* into the internal corners. Each has a 2.8mm pilot hole to catch M3 screw threads.

### 3. Back Casing (Power, Comms, & Touch)
- [ ] **Copper Touch Pads:** Right side wall contains 4x distinct 10x10mm recessed squares (for copper tape), spaced 15mm apart, each with a 2mm center pinhole for wire routing.
- [ ] **TP4056 Box:** Tight containment walls at the bottom to prevent the USB-C board from shifting when plugged in.
- [ ] **Battery C-Clips:** Two aggressive internal C-clips (Z=25, Z=60) dimensioned for an 18.5mm cylinder.
- [ ] **Battery Roof:** A solid plastic block at Z=78mm sitting directly over the battery to prevent it from jumping upward into the microcontrollers.
- [ ] **SIM Rails:** Dual vertical grooves spaced exactly 32mm apart, starting at Z=87. Includes a bottom solid ledge and top Z-stop.
- [ ] **Clearance Bosses (Back):** Four 7x7x7mm solid blocks anchored flush into the internal corners. 
- [ ] **M3 Hardware Cutouts:** 3.2mm clearance holes drilled entirely through the back shell and bosses, with 6.5mm countersinks on the outer shell so screw heads sit flush.

### 4. The Reflector & Top Assembly
- [ ] **Universal Basket:** Internal conical shell starting at Z=140. Outer diameter goes 17mm to 44mm. Inner void tapers 13mm to 40.5mm to catch the reflector without crushing internal wires.
- [ ] **Glass Lip:** 40.5mm diameter, 5mm deep flush cutout at the absolute top rim to seat the top glass.

### 5. 3D Printing & Slicing Protocol
- [ ] **Orientation:** Front and Back halves must be laid entirely flat on their sliced seams against the build plate.
- [ ] **Supports (CRITICAL):** Enable supports "Everywhere" (not just touching build plate). The internal board ledges, mid-shelf, and reflector basket are floating overhangs that will fail without internal scaffolding.
- [ ] **Support Overhang Angle:** Set to **50° or 55°** to ensure the slicer does not try to jam support material inside the tiny 2.8mm/3.2mm screw holes.
- [ ] **Layer Height:** 0.2mm for structural precision on the board rails and screw threads.
- [ ] **Infill:** 15% to 20% Gyroid or Cubic for impact resistance. 

---
**Verification Sign-Off:** Render the X-Ray view. If any component intersects another component, or if any screw boss is floating away from the wall, the model fails verification and must be corrected before STL export.
