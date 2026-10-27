[⬅ Back to Main Repo](../README.md)

# Nano Aquarium Underwater Drone (Micro-ROV) Implementation Plan

Building an underwater Remotely Operated Vehicle (ROV) specifically for a **nano aquarium** (typically 5 to 15 gallons / 20 to 60 liters) is a unique engineering challenge. Unlike open-water ROVs that prioritize high thrust and deep-pressure ratings, a nano-aquarium drone must prioritize **micro-scale dimensions ($< 8\text{ cm}$ footprint)**, **ultra-low thruster wash** (so you do not uproot plants, stir up aquasoil, or stress the fish), **shrouded propulsion**, and **aquarium-safe materials**.

Because water depth in a nano tank is rarely more than $30\text{ to }40\text{ cm}$, hydrostatic pressure is minimal ($\approx 0.5\text{ PSI}$ above atmospheric). Furthermore, while $2.4\text{ GHz}$ Wi-Fi attenuates rapidly in open water, in a nano aquarium the signal only has to travel through $5\text{ to }15\text{ cm}$ of freshwater before hitting the glass, meaning a fully wireless Wi-Fi control and video link is viable if you place your control device or access point near the tank.

---

## 1. System Architecture Overview

- **Target Form Factor:** $65\text{ mm} \times 50\text{ mm} \times 45\text{ mm}$ (approx. egg-to-mouse size).
- **Propulsion Configuration:** 3-Motor Differential + Vertical setup (Left Thruster, Right Thruster for surge/yaw, and 1 Central Vertical Thruster for heave/depth holding), or a **Vectored Micro-Pump Jet** system for zero exposed blades.
- **Control & Video Link:** Wi-Fi MJPEG video stream + WebSocket control interface hosted directly on the microcontroller (or an ultra-thin 2-wire micro-tether if you want unlimited runtime).

---

## 2. Bill of Materials (BOM)

| Category                                 | Component                                                          | Specs / Details                                                                             | Qty                    | Purpose                                                                                     |
| :--------------------------------------- | :----------------------------------------------------------------- | :------------------------------------------------------------------------------------------ | :--------------------- | :------------------------------------------------------------------------------------------ |
| **Compute & Vision**                     | **ESP32-S3 CAM Module**                                            | With OV3660 or OV2640 sensor (PSRAM included)                                               | 1                      | Main MCU, Wi-Fi AP/Station, MJPEG video streaming, and PWM generation.                      |
| **Motor Control**                        | **DRV8833** (or dual L9110S)                                       | Dual H-Bridge Driver ($2.7\text{ V}\text{--}10.8\text{ V}$, $1.5\text{ A}$ per channel)     | 2                      | Bidirectional PWM speed control for up to 4 micro motors.                                   |
| **Propulsion (Option A: Micro Prop)**    | **Coreless Brushed Motors (716 or 8520)**                          | $3.7\text{ V}$ waterproofed coreless motors + $20\text{--}25\text{ mm}$ 3-blade micro props | 3                      | Compact propulsion. _(Requires full 3D-printed nozzle shrouds + mesh)._                     |
| **Propulsion (Option B: Fish-Safe Jet)** | **Submersible Micro Water Pumps**                                  | $3\text{ V}\text{--}5\text{ V}$ DC micro brushless/coreless centrifugal pumps               | 3                      | Safer alternative: uses water jets via $4\text{ mm}$ silicone tubing instead of open props. |
| **Power System**                         | **1S LiPo Battery**                                                | $3.7\text{ V}$, $400\text{ mAh}\text{--}650\text{ mAh}$ (e.g., tiny drone battery)          | 1                      | Main onboard power ($\approx 20\text{--}30\text{ mins}$ runtime at low thrust).             |
| **Power Regulation**                     | **5V Step-Up/Step-Down (Buck-Boost)**                              | Pololu S7V7F5 or MT3608 + Low-ESR $470\ \mu\text{F}$ Capacitor                              | 1                      | Stabilizes $3.7\text{ V}$ LiPo voltage so ESP32-S3 does not brown out when motors spin up.  |
| **Switching & Charging**                 | **Magnetic Latching Reed Switch** (or Hall Sensor + MOSFET)        | Normally Open (NO) reed switch + small Neodymium magnet                                     | 1                      | Allows turning the drone ON/OFF from outside the sealed hull using a magnet.                |
| **Charging Module**                      | **TP4056 LiPo Charger**                                            | USB-C 1S charging board (with protection circuit)                                           | 1                      | Recharging the battery when opened, or via waterproof magnetic pogo pins.                   |
| **Lighting**                             | **3mm Warm White / Neutral LEDs**                                  | Paired with $220\ \Omega\text{--}330\ \Omega$ current-limiting resistors                    | 2                      | Low-glare auxiliary lighting (avoid harsh cool-white LEDs that startle fish).               |
| **Hull & Structural**                    | **PETG Filament**                                                  | $1.75\text{ mm}$ (Natural/Clear or Matte Black to reduce glass reflections)                 | $\approx 100\text{ g}$ | 3D-printed pressure hull, motor ducts, and internal electronics tray.                       |
| **Viewport & Sealing**                   | **Clear Acrylic Sheet / Tube**                                     | $2\text{ mm}\text{--}3\text{ mm}$ laser-cut acrylic disc + Nitrile (Buna-N) O-Rings         | 1 set                  | Optically clear flat port for the camera and waterproof hull flange seal.                   |
| **Consumables & Ballast**                | **100% Pure Neutral-Cure Silicone** & **316 Stainless Steel Nuts** | GE Silicone 1 / Aquarium sealant + M4/M5 SS316 nuts                                         | As needed              | Potting wire pass-throughs and adjusting center of gravity / neutral buoyancy.              |

---

## 3. Phased Implementation Plan

### Phase 1: Benchtop Prototyping & Optical Tuning

1. **Firmware & UI Setup:**
   - Program the ESP32-S3 to host an asynchronous web server (`ESPAsyncWebServer`) serving an HTML5 virtual dual-joystick interface.
   - Use **WebSockets** to transmit joystick $(X, Y, Z)$ vectors at $20\text{ Hz}$ to control the DRV8833 PWM pins, while streaming the camera feed on a separate port (`:81/stream`).
   - **Implement Exponential Thrust Ramping:** In code, cap maximum PWM duty cycle to $30\%\text{--}50\%$ for "Inspection Mode" and apply a low-pass filter (ramping PWM smoothly over $200\text{ ms}$) so the drone glides gently rather than jerking and spooking the fish.
2. **Macro Focus Modification (Crucial Step):**
   - Standard OV2640/OV3660 camera lenses are factory-focused from $\approx 50\text{ cm}$ to infinity. In a nano aquarium, you will be inspecting fish $3\text{ cm to }15\text{ cm}$ away, and water's refractive index ($n \approx 1.33$) magnifies the image and shifts focus further.
   - Carefully scrape away the tiny dab of factory glue on the camera lens barrel using a craft knife, and unscrew the lens **$1/4$ to $1/2$ turn counter-clockwise** while viewing the live stream until objects at $5\text{ cm}$ are razor-sharp.

### Phase 2: CAD & Hydrodynamic Hull Design

1. **Two-Part Clamshell or Cylinder Hull:**
   - A **cylindrical hull** (e.g., a $35\text{--}40\text{ mm}$ OD clear acrylic tube with 3D-printed PETG end-caps and radial O-ring grooves) is the easiest to seal reliably and gives the camera an automatic window.
   - Alternatively, design a **two-part flanged PETG hull** with a face-seal O-ring groove (design the groove depth to compress the O-ring cross-section by $\approx 20\%\text{--}25\%$ when bolted shut with M2.5 stainless screws).
2. **Fish-Safe Thruster Shrouds (Kort Nozzles):**
   - Never leave micro-propellers exposed in an aquarium. Curious fish (especially bettas, guppies, or nano rasboras) and shrimp will investigate the drone.
   - Design integrated **Kort nozzles** around the propellers with a 3D-printed $1.5\text{ mm}$ protective intake/exhaust grid (or glue a piece of black fiberglass window screen over the thruster tunnels).
3. **Internal Component Tray:**
   - Place heavy components (LiPo battery and stainless steel ballast weights) at the **very bottom** of the hull, and buoyancy pockets (air volume) at the **very top**. This creates a high vertical separation between the Center of Buoyancy (CB) and Center of Gravity (CG), making the drone passively self-righting in roll and pitch.

### Phase 3: 3D Printing & Waterproofing Treatment

1. **Watertight Slicer Settings (PETG):**
   - Standard 3D prints weep water through micro-gaps between layer lines and seam joints. Configure your slicer for watertightness:
     - **Wall Loops / Perimeters:** 5 to 6 walls.
     - **Top / Bottom Shell Layers:** 6 layers minimum.
     - **Extrusion Multiplier / Flow Ratio:** Increase slightly (e.g., $1.02$ to $1.04$) to intentionally over-extrude and fuse inter-layer voids.
     - **Nozzle Temp:** Print on the hotter end of your PETG range (e.g., $245^\circ\text{C--}250^\circ\text{C}$) with low cooling fan speeds for maximum layer adhesion.
     - **Seam Position:** Set to _Random_ so seam points do not align into a vertical capillary leak channel.
2. **Wire Pass-Through Sealing:**
   - Where the 6 motor wires exit the hull, route them through tight printed channels and pot a $10\text{ mm}$ deep plug of **100% pure aquarium-safe silicone** around the stripped insulation (water can wick _inside_ stranded wire insulation if you do not seal a small exposed/soldered section or use solid-core magnet wire through the bulkhead).
3. **The Dry Tissue Test:**
   - Before installing electronics, stuff a dry paper towel inside the sealed hull, weight it down at the bottom of a bucket of water for 2 hours, and inspect the tissue for any moisture.

### Phase 4: Assembly, Ballasting & Trim Calibration

1. **Electronics Integration:**
   - Solder a $470\ \mu\text{F}$ electrolytic capacitor across the battery/buck-boost input and a $0.1\ \mu\text{F}$ ceramic capacitor across each coreless motor's terminals to suppress brush noise and voltage dips that cause camera frame drops.
   - Mount the magnetic reed switch flat against the inner top wall of the hull so placing a small magnet on the top exterior disconnects the battery when not in use, and removing the magnet powers the drone ON.
2. **Neutral Buoyancy & Trim Tuning:**
   - Place the fully assembled drone in a test bucket of freshwater.
   - **Goal:** You want the drone to be **$0.5\text{ g to }1\text{ g}$ positively buoyant** (so it very slowly floats to the surface if power fails or Wi-Fi drops, making recovery easy without putting your hands in the tank).
   - Add or remove M3/M4 316-stainless steel nuts into dedicated bottom ballast slots until the drone sits completely level ($0^\circ$ pitch, $0^\circ$ roll) just below the waterline.

### Phase 5: In-Tank Trials & Fish Acclimation

1. **Pre-Soak & Rinse:**
   - Soak the sealed exterior in dechlorinated water for 24 hours after all silicone has fully cured (wait at least 48 hours for silicone curing so no acetic acid or curing byproducts enter the tank).
2. **Gentle Introduction:**
   - Place the drone in the aquarium with the motors off for $15\text{--}30\text{ minutes}$ first so the fish treat it as an inert piece of hardscape.
   - Start with low PWM limits ($20\%\text{--}30\%$ thrust) and verify Wi-Fi RSSI at the deepest corner of the tank.

---

## 4. Pro-Tips for Execution

- **Avoid Exposed Copper & Brass in the Tank:**
  Never leave exposed copper wires, brass inserts, or solder joints in direct contact with aquarium water—especially if they carry a voltage potential. Electrolysis will rapidly dissolve copper ions ($\text{Cu}^{2+}$) into the water column, which is lethal to freshwater shrimp, snails, and scaleless nano fish. Coat any external solder joints on the motors thoroughly in aquarium silicone or food-safe epoxy, and use **316 Stainless Steel** or **Nylon** fasteners externally.
- **Improving Wi-Fi Penetration in Water:**
  Water absorbs $2.4\text{ GHz}$ RF energy heavily, but air and glass do not. Mount your ESP32-S3 PCB antenna at the **very top of the hull** (within the air pocket at the top of the enclosure) and orient it parallel to the front glass. If your Wi-Fi router is far from the tank, connect your phone/laptop directly to the ESP32's SoftAP right in front of the aquarium glass—this reduces the water path to just a few centimeters and yields smooth $15\text{--}25\text{ FPS}$ video.
- **The "Ultra-Thin Micro-Tether" Backup Plan:**
  If your hardscape (heavy rocks/ironwood) blocks Wi-Fi in certain caves of the tank, or if you want to shrink the drone to the size of a ping-pong ball by removing the battery, keep the battery outside the tank. Run a pair of **30 AWG silicone wires** (or twisted enameled magnet wire) into the hull for $5\text{ V}$ power. At 30 AWG, the wire is as thin as a human hair and applies virtually zero drag on the drone.
- **Preventing Internal Fogging (Condensation):**
  Warm electronics inside a cool aquarium hull will cause humidity trapped inside the enclosure to condense directly onto the cold acrylic camera lens. Always toss a **$0.5\text{ g}$ silica gel desiccant packet** inside the hull right before sealing it shut.
- **Eliminating Glass & Internal Reflections:**
  If you put status LEDs or inspection LEDs inside the same clear window as the camera, the light will bounce off the inside of the acrylic and blind the camera sensor. Print a snug **black TPU or PETG shroud/gasket** that presses the camera lens barrel flush against the acrylic viewport to isolate it optically from any internal light sources.
