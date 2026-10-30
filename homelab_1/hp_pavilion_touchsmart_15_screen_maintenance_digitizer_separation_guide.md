# HP Pavilion TouchSmart 15 Sleekbook: Screen Spots Diagnosis & Digitizer Separation Guide

**Target Device:** HP Pavilion TouchSmart 15 Sleekbook (15.6" Air-Gapped Touchscreen Assembly)  
**Display Type:** Perimeter-bonded capacitive touch glass over a standard 15.6" 40-pin LVDS LCD panel.

---

## Part 1: Diagnosing the Black Spots (Before You Open It)

Before disassembling the screen, confirm whether the spots are sitting in the air gap behind the outer touch glass or inside the LCD panel itself.

### 1. The Parallax (Head-Tilt) Test
* **How to test:** Open a plain white window, look closely at one of the dark spots, and move your head slowly from side to side.
* **Result A — Moves relative to the pixels / casts a faint shadow:** The debris is sitting in the gap between the outer touch glass and the LCD surface. **Separating the touch glass will fix this.**
* **Result B — Stays locked on the exact same pixel plane:** The issue is inside the LCD panel itself (dead pixels, internal LCD bruising, or debris/mold inside the backlight diffuser sheets). Separating the outer touch glass will *not* reach this layer.

### 2. Visual Identification Under Magnification (Phone Macro / Magnifying Glass)
* **Dust or Degraded Foam Crumbs:** Irregular, sharp-edged dark specs sitting slightly in front of the pixel grid. Caused by the perimeter foam seal drying out and crumbling inward over time.
* **Dead Pixels / LCD Bruising:** Dead pixels align neatly with the square RGB pixel grid. LCD bruising looks like a tiny, smooth ink blot on the exact same plane as the pixels.
* **Mold / Fungus:** Slightly fuzzy, circular spots with microscopic spiderweb/branching edges. Can grow either on the inside of the touch glass or between internal diffuser films in humid climates.
* **Trapped Insects (Thrips / Thunderflies):** Tiny, elongated 1mm–2mm dark dashes. *(Warning: Never press on these, or they will permanently stain the screen layers).*

---

## Part 2: Tools & Materials Checklist

If your spots pass the parallax test and are trapped behind the touch glass, gather these supplies before starting:

- [ ] **Small Phillips Screwdriver** (PH0 or PH1)
- [ ] **Heat Source:** Hair dryer or heat gun (used on low setting only)
- [ ] **Thin Plastic Pry Tools:** Guitar picks, old plastic playing cards, or thin PET plastic strips cut from a clean soda bottle *(Never use metal blades or flathead screwdrivers between the glass and LCD)*
- [ ] **Suction Cup** (Optional, helps lift the first corner safely)
- [ ] **99% Isopropyl Alcohol (IPA)** and a dropper/cotton swabs (to dissolve old adhesive and clean glass)
- [ ] **Lint-Free Microfiber Cloths**
- [ ] **Manual Rubber Air Blower** (Rocket blower) or canned compressed air
- [ ] **Replacement Adhesive:** 2mm to 3mm wide double-sided black acrylic foam tape (about 0.5mm to 1mm thick to match the original air-gap spacer)

---

## Part 3: Step-by-Step Disassembly & Glass Separation

### Step 1: Prepare the Laptop & Remove the Screen Assembly
1. Shut down the laptop completely, unplug the AC adapter, and **remove the external battery**. Hold the power button for 10 seconds to drain residual power.
2. Locate the two small plastic mylar screw covers on the **bottom-left and bottom-right corners** of the front screen bezel. Pry them off gently with a fingernail or plastic pick and remove the **2 Phillips screws** underneath.
3. Carefully unclip the front plastic bezel frame by working a plastic pick around the outer perimeter seam. Lift the outer bezel trim away.
4. Remove the **4 Phillips mounting screws** holding the metal LCD hinge brackets to the top lid housing.
5. Tilt the screen assembly forward and lay it face-down on a clean towel resting over the keyboard.
6. Peel back the clear adhesive tape and disconnect:
   * The wide **40-pin LVDS video cable** (bottom left/right of the panel).
   * The smaller **touch digitizer controller cable** (usually connected to a small narrow circuit board along the edge of the panel).
7. Move the entire screen + glass assembly to a clean, flat, well-lit table.

### Step 2: Map Out the Digitizer Ribbon Cable (CRITICAL)
1. Flip the screen assembly over and look at the back edges.
2. Locate where the thin orange/copper **flat flex ribbon cable (FPC)** goes from the small touch controller board into the front glass layer (typically along the bottom edge or top edge near the webcam cutout).
3. **Mental Note:** Mark this edge with a piece of painter's tape. **Do not slide your playing card or pry picks through this section**, and save this edge for last when separating the glass.

### Step 3: Heat and Soften the Perimeter Foam Tape
1. Lay the assembly flat with the glass facing up.
2. Turn on your hair dryer or heat gun (low setting) and warm one of the upper corners **away from the ribbon cable**.
3. Keep the nozzle moving continuously along the black border. Aim for **$60^\circ\text{C}$ to $70^\circ\text{C}$** (very warm to the touch, but you should still be able to touch it briefly without burning yourself). *Excessive concentrated heat can warp the plastic diffuser sheets inside the LCD.*
4. Apply 1–2 drops of **99% Isopropyl Alcohol** on a cotton swab or the tip of your plastic card so it wicks into the seam between the rear of the glass and the metal frame of the LCD. IPA immediately weakens aged acrylic foam adhesive.

### Step 4: Slice the Perimeter Seal
1. Place a suction cup near the heated corner (or gently lift the edge with a fingernail) to create a tiny gap, and slide a thin guitar pick or plastic playing card between the touch glass and the metal bezel of the LCD.
2. **Depth Limit (5mm – 8mm max):** Never push the card deeper than the width of the black border printed on the glass. Pushing the card into the active viewing area can scratch the delicate LCD polarizer film.
3. Slowly slide the card down the side edge like a knife slicing through foam tape. Whenever you feel strong resistance, stop, apply a little more warm air and a drop of IPA, and continue.
4. Leave guitar picks wedged in the already-separated corners every few inches so the warm adhesive doesn't stick back together behind you.
5. Repeat this process around the three safe edges first.
6. **Final Edge (Ribbon Cable Side):** Once three sides are completely free, gently lift the glass slightly (like opening a book hinged on the ribbon cable side) and carefully peel or slice the remaining foam tape away while watching the ribbon cable from underneath.

---

## Part 4: Cleaning & Re-Sealing Without Dust

1. **Prep the Room:** Turn off ceiling fans and AC units for 15 minutes before cleaning so airborne dust settles.
2. **Strip Old Adhesive:** Scrape off all deteriorated black foam tape from both the inner border of the touch glass and the metal perimeter of the LCD panel. Wipe the borders clean with 99% IPA.
3. **Clean Both Optical Surfaces:**
   * Wipe the **inside of the touch glass** thoroughly with 99% IPA and a clean microfiber cloth until completely streak-free.
   * Gently wipe the **front polarizer surface of the LCD** using a lightly dampened microfiber cloth (use minimal pressure on the bare LCD).
4. **Apply New Perimeter Tape:**
   * Apply your new 2mm–3mm double-sided foam tape along the entire metal border of the LCD panel.
   * **Important:** Ensure the corners meet flush with **zero gaps**. Any gap in the foam seal will allow dust and tiny insects to crawl right back inside later.
5. **Final Dust Check & Bonding:**
   * Peel the backing off the new foam tape.
   * Hold the touch glass at a $45^\circ$ angle over the LCD, inspect both surfaces under a bright flashlight angle, and use your air blower to blast away any final stray lint specks.
   * Carefully lower the glass onto the LCD frame, aligning all four corners, and press gently along the black outer borders to seal the tape.
6. **Reassemble:** Reconnect the LVDS video cable and touch digitizer cable, test the display and touch input before screwing everything back in, and then reinstall the 4 bracket screws and front bezel.