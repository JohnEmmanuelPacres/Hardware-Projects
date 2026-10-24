# iPad 1 (A1219) 9.7" IPS LCD to HDMI Monitor — DIY Hardware Hack

Convert a salvaged 1st Generation iPad (`Model A1219`) 9.7-inch IPS LCD panel (`LP097X02-SLA1` / `LTN097XL01`) into a standalone 4:3 HDMI monitor using a generic universal LVDS driver board and an `MT3608` DC-DC boost converter, bypassing overpriced proprietary adapter kits.

---

## 1. Project Overview & Architecture

Commercial iPad 1/2 HDMI conversion kits cost $3\times\text{–}4\times$ more than standard laptop LCD controller boards solely because the iPad panel integrates its ~19.2V LED backlight power rails directly into its 30-pin micro-coaxial LVDS connector rather than using a separate inverter harness.

This project splits the system into two clean, low-cost stages:
1. **Video & 3.3V Logic Stage:** A generic `PCB800099` / `VS-TY2662-V1` (Realtek `RTD2660` / `RTD2662`) universal HDMI/VGA controller board configured for `1024×768` (Single-Channel, 6-Bit LVDS) hooked up to the salvaged Apple `821-0752-A` LVDS harness.
2. **LED Backlight Boost Stage:** An `MT3608` DC-DC boost converter stepping $5\text{V}$ up to $\sim 17\text{V}\text{–}19.2\text{V}$ with series current-limiting protection to drive the panel's internal 6S6P edge-lit WLED array.

### Target Panel Specifications (`LG Display LP097X02-SLA1`)
* **Resolution:** $1024 \times 768$ (XGA), 132 PPI, 4:3 Aspect Ratio
* **Panel Type:** IPS, Normally Black, Transmissive
* **Signal Interface:** LVDS (1 Channel, 6-bit), 30-pin I-PEX `20453-030T-11` (0.5mm pitch)
* **Logic Supply Voltage ($V_{CC}$):** $3.3\text{V}$ Typical ($3.0\text{V}\text{–}3.6\text{V}$ max, $\sim 240\text{mA}$)
* **Backlight Architecture:** 6-series, 6-parallel (6S6P) White LED array
  * **Forward Voltage ($V_{\text{LED}}$):** $18.0\text{V}\text{–}19.8\text{V}$ Typical ($16.0\text{V}$ dim wake-up)
  * **Forward Current ($I_{\text{LED}}$):** $20\text{mA}$ per string ($120\text{mA}$ total across all 6 strings at 100% brightness; $60\text{mA}\text{–}80\text{mA}$ recommended for cool continuous operation)

---

## 2. Bill of Materials (BOM)

| Item | Component | Specifications / Notes | Est. Cost (PHP) |
| :--- | :--- | :--- | :--- |
| **1** | **Salvaged LCD Panel** | LG `LP097X02-SLA1` (or Samsung `LTN097XL01`) from iPad 1 (`A1219`) | *Salvaged* |
| **2** | **Salvaged LVDS Harness** | Original Apple braided LVDS cable (`821-0752-A`) | *Salvaged* |
| **3** | **Backlight Boost Module** | `MT3608` DC-DC Step-Up Converter (USB Type-C or solder-pad version) | ₱32 |
| **4** | **Universal HDMI Controller** | `PCB800099` or `VS-TY2662-V1` (`RTD2662`) flashed/jumpered for `1024×768` 1ch 6-bit | ₱320 – ₱420 |
| **5** | **Current-Limiting Resistors** | $6\times$ $100\Omega\text{–}150\Omega$ ($1/4\text{W}$) resistors (one per LED cathode string) OR $1\times$ $470\Omega$ ($1/2\text{W}$) for single-string bench testing | ₱10 |
| **6** | **3.3V Regulator (For BIST Test)** | `AMS1117-3.3` LDO module (or `3V3` pin from an ESP32 / Arduino / Raspberry Pi) | ₱15 |
| **7** | **Wiring & Consumables** | 28–30 AWG enameled magnet wire or Kynar wire, heat-shrink tubing, Kapton/electrical tape | ₱50 |

### Tools Required
* Digital Multimeter (with continuity buzzer and DC voltage mode)
* Soldering iron with a fine conical or chisel tip + flux + fine solder
* Tweezers, wire strippers/flush cutters, and magnifier (or phone macro camera)
* $5\text{V}$ USB power supply (USB-A to USB-C cable) & $12\text{V}$ $2\text{A}$ DC adapter (for the HDMI board)

---

## 3. Complete 30-Pin Connector Pinout (`LP097X02-SLA1`)

Looking at the back of the LCD panel with the gold 30-pin I-PEX connector at the bottom, verify **Pin 1** via the small silkscreen dot/arrow or trace continuity to ground.

> **CRITICAL WARNING:** Never apply $>3.6\text{V}$ to Pins 2 or 3 ($V_{CC}$), and never let the $18\text{V}$ backlight rail touch any logic or LVDS pins. Doing so will permanently destroy the panel's T-CON IC.

| Pin # | Symbol | Description | Target Connection |
| :---: | :--- | :--- | :--- |
| **1** | `GND` | Ground | Common Ground (`GND`) |
| **2** | `VCC` | $+3.3\text{V}$ Logic Power Supply | $+3.3\text{V}$ Output from Driver Board / LDO |
| **3** | `VCC` | $+3.3\text{V}$ Logic Power Supply | $+3.3\text{V}$ Output from Driver Board / LDO |
| **4** | `V_EDID` | $+3.3\text{V}$ EDID EEPROM Power | Leave unconnected (or $+3.3\text{V}$) |
| **5** | `NC` | No Connection (or BIST trigger on select revisions) | Leave unconnected |
| **6** | `CLK_EDID` | I2C Clock for EDID | Leave unconnected |
| **7** | `DATA_EDID`| I2C Data for EDID | Leave unconnected |
| **8** | `RxIN0-` | LVDS Differential Data 0 Negative | Driver Board `TXO0-` (`RXO0-`) |
| **9** | `RxIN0+` | LVDS Differential Data 0 Positive | Driver Board `TXO0+` (`RXO0+`) |
| **10** | `GND` | Ground Shield | Common Ground (`GND`) |
| **11** | `RxIN1-` | LVDS Differential Data 1 Negative | Driver Board `TXO1-` (`RXO1-`) |
| **12** | `RxIN1+` | LVDS Differential Data 1 Positive | Driver Board `TXO1+` (`RXO1+`) |
| **13** | `GND` | Ground Shield | Common Ground (`GND`) |
| **14** | `RxIN2-` | LVDS Differential Data 2 Negative | Driver Board `TXO2-` (`RXO2-`) |
| **15** | `RxIN2+` | LVDS Differential Data 2 Positive | Driver Board `TXO2+` (`RXO2+`) |
| **16** | `GND` | Ground Shield | Common Ground (`GND`) |
| **17** | `RxCLK-` | LVDS Differential Clock Negative | Driver Board `TXOC-` (`RXOC-`) |
| **18** | `RxCLK+` | LVDS Differential Clock Positive | Driver Board `TXOC+` (`RXOC+`) |
| **19** | `GND` | Ground Shield | Common Ground (`GND`) |
| **20** | `NC` | No Connection | Leave unconnected |
| **21** | `VLED_K1` | LED Backlight Cathode String 1 (`-`) | To `MT3608 OUT-` via $100\Omega$ resistor |
| **22** | `VLED_K2` | LED Backlight Cathode String 2 (`-`) | To `MT3608 OUT-` via $100\Omega$ resistor |
| **23** | `VLED_K3` | LED Backlight Cathode String 3 (`-`) | To `MT3608 OUT-` via $100\Omega$ resistor |
| **24** | `VLED_K4` | LED Backlight Cathode String 4 (`-`) | To `MT3608 OUT-` via $100\Omega$ resistor |
| **25** | `VLED_K5` | LED Backlight Cathode String 5 (`-`) | To `MT3608 OUT-` via $100\Omega$ resistor |
| **26** | `VLED_K6` | LED Backlight Cathode String 6 (`-`) | To `MT3608 OUT-` via $100\Omega$ resistor |
| **27** | `NC` | No Connection | Leave unconnected |
| **28** | `VLED_A` | LED Backlight Common Anode (`+`) | To `MT3608 OUT+` ($17.5\text{V}\text{–}18.5\text{V}$) |
| **29** | `VLED_A` | LED Backlight Common Anode (`+`) | To `MT3608 OUT+` ($17.5\text{V}\text{–}18.5\text{V}$) |
| **30** | `NC` | No Connection | Leave unconnected |

*(Note: Because the panel also exposes a separate 8-pin white backlight connector `248021AG` at the bottom corner of the T-CON board, you can wire the `MT3608` backlight power directly to that 8-pin backlight connector instead of soldering to Pins 21–29 of the 30-pin LVDS connector!)*

---

## 4. Phase 1: Standalone Backlight Test (`MT3608`)

Before buying or wiring the HDMI controller board, verify the internal LED strip and optical diffuser stack are healthy.

1. **Configure the `MT3608` Voltage:**
   * Plug a $5\text{V}$ USB-A to Type-C cable into the `MT3608` module (**do not** connect the LCD yet).
   * Place your multimeter probes on `VOUT+` and `VOUT-`.
   * Turn the brass potentiometer screw counter-clockwise (10–15 turns) until the voltage climbs and stabilizes at **$17.5\text{V}$ DC**.
2. **Wire the Test Probe:**
   * Disconnect USB power.
   * Solder a **$470\Omega$ resistor** in series with a jumper wire on `VOUT+`.
3. **Illuminate the Backlight (`248021AG` 8-Pin Socket):**
   * Locate the small white 8-pin connector at the bottom corner of the LCD where the orange LED flex ribbon enters the panel.
   * Identify the **Common Anode (`+`)** pins (the 2–3 pins bridged together by the wide copper trace on the orange ribbon) and the 6 individual **Cathode (`-`)** pins.
   * Touch `VOUT+` (through the resistor) to the Common Anode and `VOUT-` to each Cathode pin one at a time.
   * **Expected Result:** Each LED zone should glow bright white with no dark spots or watermarks inside the diffuser layers.

---

## 5. Phase 2: T-CON & Pixel Built-In Self-Test (BIST)

Once the backlight is confirmed working, test the panel's row/column drivers and liquid crystal pixels without an HDMI board.

1. **Prepare a Clean $3.3\text{V}$ Supply:**
   * Use an `AMS1117-3.3` regulator or the `3V3` and `GND` pins of an ESP32/Raspberry Pi. Verify with your multimeter that the output is strictly **$3.25\text{V}\text{–}3.35\text{V}$**.
2. **Locate T-CON Power Pads:**
   * Gently peel back the black protective tape on the green T-CON board adjacent to the 30-pin gold LVDS connector (or plug in your salvaged `821-0752-A` black cable to use as a breakout harness).
   * Use your multimeter in continuity mode to confirm the `GND` test pad (continuous with the outer metal frame and Pin 1) and the `VCC`/`VDD` test pad (continuous with Pins 2 & 3).
3. **Power Up Logic & Backlight:**
   * Connect `GND` to the panel frame/Pin 1 and $+3.3\text{V}$ to `VCC` (Pins 2 & 3) while the backlight is illuminated (or shine a bright phone flashlight into the screen).
   * **Expected Result:** With no LVDS clock present, the panel will either initialize to a clean uniform black/gray raster or cycle through its built-in RGBW test patterns (on revisions with BIST Pin 5 pulled high via a $10\text{k}\Omega$ resistor to $3.3\text{V}$), proving there are no cracked traces or vertical/horizontal line defects.

---

## 6. Phase 3: Universal HDMI Driver Board Integration

Once Phases 1 and 2 pass, convert the salvaged `821-0752-A` black LVDS cable into a custom interface harness for a generic universal controller board (`PCB800099` / `VS-TY2662-V1`).

### Step 1: Set Up the Universal Controller Board
1. Ensure the controller board firmware/jumper is set to **`1024×768` Single-Channel 6-Bit (`1ch 6-bit`)**. On `VS-TY2662-V1` boards, this is selected simply by placing the configuration jumper across the correct pins printed on the back silkscreen.
2. **Set the Panel Logic Voltage Jumper to $3.3\text{V}$:** Locate the `VCC` selector jumper on the HDMI driver board (`3.3V / 5V / 12V`) and verify it is firmly on the **`3.3V`** position.

### Step 2: Modify the Salvaged Apple LVDS Cable (`821-0752-A`)
1. Cut off the proprietary Apple motherboard connector (the black pull-tab end), leaving the **gold 30-pin I-PEX connector** intact for the LCD side.
2. Carefully strip back $3\text{cm}$ of the outer black fabric braid and foil shield.
3. Inside, you will find **4 twisted micro-coaxial differential pairs** (for `RxIN0`, `RxIN1`, `RxIN2`, and `RxCLK`) plus individual power and ground conductors:
   * Use your multimeter in continuity mode against the gold 30-pin plug (referencing the **Section 3 Pinout Table**) to tag each wire:
     * `RxIN0-` (Pin 8) & `RxIN0+` (Pin 9)
     * `RxIN1-` (Pin 11) & `RxIN1+` (Pin 12)
     * `RxIN2-` (Pin 14) & `RxIN2+` (Pin 15)
     * `RxCLK-` (Pin 17) & `RxCLK+` (Pin 18)
     * `VCC +3.3V` (Pins 2 & 3)
     * `GND` (Outer coaxial shields & Pins 1, 10, 13, 16, 19)
4. Keep the differential pairs twisted as close to the solder joints as possible (within $5\text{mm}$) to prevent high-frequency LVDS signal skew or sparkling pixels.
5. Solder the tagged wires directly to the `2×15` LVDS pin header on the universal HDMI controller board (`TXO0-`/`+`, `TXO1-`/`+`, `TXO2-`/`+`, `TXOC-`/`+`, `VCC`, and `GND`).

### Step 3: Wire the Permanent `MT3608` Backlight Driver
1. Connect the input (`VIN+` and `VIN-`) of the `MT3608` module to the **$+5\text{V}$** and **`GND`** rails on the HDMI controller board.
2. Adjust the `MT3608` output to **$18.5\text{V}$ DC**.
3. Wire `VOUT+` to the LCD's **Common Anode** (Pins 28 & 29, or the Anode pad on the 8-pin `248021AG` backlight connector).
4. Wire each of the 6 **Cathode strings** (Pins 21–26, or the 6 cathode pins on the `248021AG` connector) through its own **$100\Omega$ ($1/4\text{W}$) current-balancing resistor** to `VOUT-` (`GND`).
   * *Optional Auto-Sleep Feature:* Place a small NPN transistor or N-channel MOSFET (`2N7002` / `AO3400`) on the `VOUT-` return path with its gate driven by the HDMI controller board's `BL_EN` (Backlight Enable) pin so the backlight automatically turns off when HDMI signal goes to sleep!

---

## 7. Pre-Flight Safety Checklist

Before plugging in power for the first full test, run through these 4 checks with a multimeter:
- [ ] **No $V_{CC}$ to $GND$ Short:** Measure resistance between $+3.3\text{V}$ (`VCC`) and `GND` on the LVDS header. It should read $>1\text{k}\Omega$.
- [ ] **Driver Board Jumper Check:** Confirm the HDMI driver board panel voltage jumper is set to **$3.3\text{V}$** (not $5\text{V}$ or $12\text{V}$).
- [ ] **Pre-Adjusted Boost Converter:** Confirm the `MT3608` output voltage was dialed in to $\le 18.5\text{V}$ *before* connecting the LED anode.
- [ ] **Strain Relief:** Secure the modified LVDS harness and `MT3608` module to the back of the LCD metal frame using Kapton tape or double-sided foam tape so flexing the wires cannot tug on the gold 30-pin socket.