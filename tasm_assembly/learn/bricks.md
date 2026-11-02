Here is a complete, saveable **Markdown Reference Guide**. It covers the memory tricks for registers, how to design custom UI shapes, how **Procedures (`PROC`)** actually work, and every Lego brick you need.

---

# 🧱 The Ultimate TASM UI & Procedures Cheat Guide

## 1. How to Remember Which Register Does What

You never have to guess which register to use—BIOS (`INT 10H`) and DOS (`INT 21H`) look at specific registers like labeled mail slots. Use this **A-B-C-D Memory Trick**:

| Register        | Memory Trick          | What Goes Inside It                                                                                                    |
| :-------------- | :-------------------- | :--------------------------------------------------------------------------------------------------------------------- |
| **`AH`**        | **A**ction **H**eader | **The Command Number** (`06H` = Paint Box, `02H` = Move Cursor, `09H` = Print String, `01H` = Key Input, `4CH` = Exit) |
| **`AL`**        | **A**ction **L**ow    | Extra setting (`00H` = fill whole box) **OR** holds the key pressed by the user                                        |
| **`BH`**        | **B**rush **H**ue     | **Color Code** (`[Bg][Text]`) when painting a box, **OR** `00H` (Page 0) when moving cursor                            |
| **`CH` / `CL`** | **C**orner 1 (Start)  | **Top-Left of Box:** `CH` = Top Row (`0–24`), `CL` = Left Col (`0–79`)                                                 |
| **`DH` / `DL`** | **D**estination (End) | **Bottom-Right of Box OR Cursor Spot:** `DH` = Row (`0–24`), `DL` = Col (`0–79`)                                       |
| **`DX`**        | **D**ata Address      | Holds the `.DATA` variable name when printing text (`LEA DX, varName`)                                                 |

> 💡 **Golden Rule for `H` vs `L` in Coordinates:**
>
> - **`H` (`CH`, `DH`)** = **H**orizontal Row (**Up/Down: `0` to `24`**)
> - **`L` (`CL`, `DL`)** = **L**eft-to-Right Column (**Left/Right: `0` to `79`**)

---

## 2. How Procedures (`PROC`) Actually Work (No More Confusion!)

When your UI gets big, putting 200 lines inside `MAIN PROC` gets messy. **Procedures** let you group bricks into named functions (like `drawBackground`, `drawWindow`, `showText`) and run them using **`CALL`**.

### ⚠️ The 3 Rules of Procedures:

1. **`MAIN PROC` is the Boss:** It ends with `MOV AH, 4CH` / `INT 21H` (which shuts down the program).
2. **Custom Procedures are Helpers:** They **MUST** end with **`RET`** (Return) right before `ENDP`. `RET` tells the CPU: _"Go back to `MAIN PROC` right where `CALL` left off!"_
3. **Where to put them:** Place all your custom procedures **AFTER `MAIN ENDP`**, Status-quo right **BEFORE `END MAIN`**.

### 📋 Copy-Paste Procedure Skeleton

```assembly
.MODEL SMALL
.STACK 100h

.DATA
    titleTxt DB "MY SYSTEM UI$"

.CODE
; =========================================================
; BOSS PROCEDURE (Your main checklist)
; =========================================================
MAIN PROC
    MOV AX, @data
    MOV DS, AX

    CALL clearScreen    ; Jumps to clearScreen, runs it, and comes back!
    CALL drawCard       ; Jumps to drawCard, runs it, and comes back!
    CALL exitCleanly    ; Parks cursor and closes program
MAIN ENDP

; =========================================================
; HELPER PROCEDURES (Put all your Lego bricks inside these!)
; =========================================================
clearScreen PROC
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 80H
    MOV CH, 0
    MOV CL, 0
    MOV DH, 24
    MOV DL, 79
    INT 10H
    RET                 ; <-- REQUIRED! Returns back to MAIN
clearScreen ENDP

drawCard PROC
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 70H
    MOV CH, 7
    MOV CL, 20
    MOV DH, 16
    MOV DL, 60
    INT 10H
    RET                 ; <-- REQUIRED! Returns back to MAIN
drawCard ENDP

exitCleanly PROC
    MOV AH, 02H
    MOV BH, 00H
    MOV DH, 18
    MOV DL, 0
    INT 10H

    MOV AH, 4CH
    INT 21H
    RET
exitCleanly ENDP

END MAIN                ; <-- Always the very last line of the file!
```

---

## 3. How to Design Your Own UI Patterns (Using Just Brick 1!)

You can create almost any UI shape just by changing how `CH/DH` (Rows) and `CL/DL` (Cols) relate to each other in **Brick 1 (`AH = 06H`)**:

| UI Shape You Want                            | How to Set the Numbers in Brick 1                                                                               | Example Coordinates                                                                      |
| :------------------------------------------- | :-------------------------------------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------- |
| **1. Full Background**                       | Cover the entire grid                                                                                           | `CH=0, CL=0` to `DH=24, DL=79`                                                           |
| **2. Big Window / Card**                     | `CH` is smaller than `DH`, `CL` is smaller than `DL`                                                            | `CH=5, CL=15` to `DH=18, DL=65`                                                          |
| **3. Horizontal Bar / Input Field / Button** | Make **Top Row (`CH`) = Bottom Row (`DH`)** _(1 row thick!)_                                                    | `CH=5, CL=15` to `DH=5, DL=65`                                                           |
| **4. Vertical Line / Sidebar / Pillar**      | Make **Left Col (`CL`) = Right Col (`DL`)** _(1 col thick!)_                                                    | `CH=5, CL=15` to `DH=18, DL=15`                                                          |
| **5. 3D Drop Shadow**                        | Draw a Black box (`BH=00H`) shifted **`+1` Row down** and **`+2` Cols right** _before_ drawing your main window | Shadow: `CH=6, CL=17, DH=19, DL=67`<br>Window: `CH=5, CL=15, DH=18, DL=65`               |
| **6. Outlined Frame (Border Box)**           | Draw an Outer Box first, then draw a smaller Inner Box shifted **`+1` Row inward** and **`+2` Cols inward**     | Outer (`4FH`): `CH=5, CL=15, DH=18, DL=65`<br>Inner (`70H`): `CH=6, CL=17, DH=17, DL=63` |

---

## 4. All Boilerplate Lego Bricks (Copy-Paste Library)

### 🟦 BRICK 1: Paint Any Box / Bar / Line / Background

```assembly
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 70H     ; Color: [Bg 0-7][Text 0-F] (Add leading 0 if A-F, e.g., 0F0H)
    MOV CH, 5       ; Top Row (0-24)
    MOV CL, 20      ; Left Col (0-79)
    MOV DH, 15      ; Bottom Row (0-24)
    MOV DL, 60      ; Right Col (0-79)
    INT 10H
```

### 🟨 BRICK 2: Move Cursor Position

```assembly
    MOV AH, 02H
    MOV BH, 00H     ; Always 00H (Page 0)
    MOV DH, 10      ; Row (0-24)
    MOV DL, 25      ; Col (0-79)
    INT 10H
```

### 🟩 BRICK 3: Print a `.DATA` String Variable

_(Remember: Variable in `.DATA` must end with `$`!)_

```assembly
    MOV AH, 09H
    LEA DX, myVarName
    INT 21H
```

### 🟧 BRICK 4: Print a Single Character (Fast Icons/Borders)

```assembly
    MOV AH, 02H
    MOV DL, '*'     ; Put any single character or ASCII code here
    INT 21H
```

### 🟪 BRICK 5: Draw a Repeating Line of Characters (Using `LOOP`)

_Want to print `====================` (20 times) without typing it in `.DATA`? `CX` acts as a loop counter!_

```assembly
    MOV CX, 20      ; How many times to repeat
drawLineLoop:
    MOV AH, 02H
    MOV DL, '='     ; Character to repeat
    INT 21H
    LOOP drawLineLoop ; Automatically subtracts 1 from CX and repeats until CX=0!
```

### 🟫 BRICK 6: Single-Key Menu Input (`1`, `2`, `3` Selection)

```assembly
    MOV AH, 01H     ; Wait for 1 key (use 07H if you don't want the key echoed on screen)
    INT 21H         ; Key pressed is now inside AL

    CMP AL, '1'
    JE  optionOneLabel
    CMP AL, '2'
    JE  optionTwoLabel
```

### ⬜ BRICK 7: Type a Full Word / Name Input (Like a Login Box!)

_If your UI has a textbox where the user needs to type their name and press `Enter`, put this in `.DATA`:_

```assembly
.DATA
    inputBuffer DB 20, ?, 20 DUP('$') ; Holds up to 20 characters
```

_And snap this brick into `.CODE` right after moving the cursor inside your textbox:_

```assembly
    MOV AH, 0AH             ; Command: Read full string until Enter is pressed
    LEA DX, inputBuffer     ; Save typed text into inputBuffer
    INT 21H
```

### ⬛ BRICK 8: Clean Exit (Hides `"Press any key to exit..."`)

```assembly
    ; Park cursor in the black background area below your UI (Row 18-20)
    MOV AH, 02H
    MOV BH, 00H
    MOV DH, 19
    MOV DL, 0
    INT 10H

    MOV AH, 4CH
    INT 21H
```

---

## 🎨 Quick Color Reference Table (`BH = [Bg][Text]`)

> **Note:** For the **first digit (Background)**, stick to **`0`–`7`** so the text doesn't blink. For the **second digit (Text)**, you can use **`0`–`F`**.

|   Hex   | Color (Bg or Text)                       |   Hex   | Bright Color (Text Only) |
| :-----: | :--------------------------------------- | :-----: | :----------------------- |
| **`0`** | Black _(Use `80H` for stealth black bg)_ | **`8`** | Dark Gray                |
| **`1`** | Blue                                     | **`9`** | Light Blue               |
| **`2`** | Green                                    | **`A`** | Light Green              |
| **`3`** | Cyan                                     | **`B`** | Light Cyan               |
| **`4`** | Red                                      | **`C`** | Light Red                |
| **`5`** | Magenta / Purple                         | **`D`** | Light Magenta / Pink     |
| **`6`** | Brown / Gold                             | **`E`** | Yellow                   |
| **`7`** | Light Gray                               | **`F`** | Bright White             |
