# Screen Coordinate & Placement Calculation Guide

This guide explains how coordinates, boxes, and text placement are calculated in TASM 8086 assembly for standard DOS 80×25 text mode..

---

## 1. Screen Grid Basics

Standard text mode (Mode 03h) uses a grid of character cells:

- **Horizontal (Columns / X-axis):** `0` to `79` (80 columns total)
- **Vertical (Rows / Y-axis):** `0` to `24` (25 rows total)
- **Top-Left Corner:** `(Row 0, Col 0)`
- **Bottom-Right Corner:** `(Row 24, Col 79)`

### Register Mapping for `INT 10H`

- **`H` registers (`CH`, `DH`)** = **Rows** (Vertical: `0–24`)
- **`L` registers (`CL`, `DL`)** = **Columns** (Horizontal: `0–79`)

| Action                       | Register | Role          | Value Range |
| :--------------------------- | :------- | :------------ | :---------- |
| **Draw Box (`AH = 06H`)**    | `CH`     | Top Row       | `0` to `24` |
|                              | `CL`     | Left Column   | `0` to `79` |
|                              | `DH`     | Bottom Row    | `0` to `24` |
|                              | `DL`     | Right Column  | `0` to `79` |
| **Move Cursor (`AH = 02H`)** | `DH`     | Target Row    | `0` to `24` |
|                              | `DL`     | Target Column | `0` to `79` |

---

## 2. Code Breakdown

```assembly
; 1. Draw Inner Box (0E1H = Yellow background, Blue text)
MOV AH, 06H     ; Service 06h: Scroll window up / clear window
MOV AL, 00H     ; 00h = blank entire designated area
MOV BH, 0E1H    ; Attribute: 0Eh = Yellow bg, 1h = Blue fg
MOV CH, 2       ; Top-left Row = 2
MOV CL, 3       ; Top-left Column = 3
MOV DH, 4       ; Bottom-right Row = 4
MOV DL, 76      ; Bottom-right Column = 76
INT 10H         ; BIOS video interrupt

; 2. Set Cursor Position for Text
MOV AH, 02H     ; Service 02h: Set cursor position
MOV BH, 00H     ; Video page 0
MOV DH, 3       ; Row = 3
MOV DL, 12      ; Column = 12
INT 10H         ; Move cursor to (3, 12)

; 3. Print School Name
MOV AH, 09H     ; DOS Service 09h: Print '$'-terminated string
LEA DX, uni     ; Load offset address of string into DX
INT 21H         ; Print string at current cursor position
RET
```

---

## 3. How Box Placement & Margins Are Calculated

When nesting an inner box inside an outer box:

### Example: Outer Box

- Top-Left: `CH = 1`, `CL = 1`
- Bottom-Right: `DH = 5`, `DL = 78`

### Margin Formulas for Inner Box

- **Top Row (`CH`):** `Outer_CH + Vertical_Padding`
  $$1 + 1 = \mathbf{2}$$
- **Bottom Row (`DH`):** `Outer_DH - Vertical_Padding`
  $$5 - 1 = \mathbf{4}$$
- **Left Column (`CL`):** `Outer_CL + Horizontal_Padding`
  $$1 + 2 = \mathbf{3}$$
- **Right Column (`DL`):** `Outer_Right - Horizontal_Padding`
  $$78 - 2 = \mathbf{76}$$

> 💡 **Why is horizontal padding larger?**
> DOS text-mode characters are roughly twice as tall as they are wide (~8×16 pixels). Adding `2` to columns and `1` to rows creates a balanced visual border.

---

## 4. How Text Placement (Centering) Is Calculated

### A. Vertical Centering

To place text dead-center vertically within a box:
$$\text{Target Row (DH)} = \frac{\text{Top Row} + \text{Bottom Row}}{2}$$

For inner box spanning rows `2` to `4`:
$$\text{Target Row} = \frac{2 + 4}{2} = \mathbf{3} \quad (\text{DH} = 3)$$

---

### B. Horizontal Centering

To center a string, count its total length (including spaces, excluding the terminating `$`):

```text
uni db "C E B U   I N S T I T U T E   O F   T E C H N O L O G Y$"
```

Character count breakdown:

- `"C E B U"` = 7 characters
- `3 spaces` = 3 characters
- `"I N S T I T U T E"` = 17 characters
- `3 spaces` = 3 characters
- `"O F"` = 3 characters
- `3 spaces` = 3 characters
- `"T E C H N O L O G Y"` = 19 characters
- **Total string length ($L$):** $7 + 3 + 17 + 3 + 3 + 3 + 19 = \mathbf{55}$

#### Method 1: Screen-Wide Centering (80 Columns)

$$\text{Start Column (DL)} = \frac{\text{Total Columns} - L}{2} = \frac{80 - 55}{2} = \frac{25}{2} = \mathbf{12} \quad (\text{DL} = 12)$$

#### Method 2: Box-Relative Centering

$$\text{Box Width} = \text{DL}_{\text{box}} - \text{CL}_{\text{box}} + 1 = 76 - 3 + 1 = 74$$
$$\text{Start Column (DL)} = \text{CL}_{\text{box}} + \frac{\text{Box Width} - L}{2} = 3 + \frac{74 - 55}{2} = 3 + 9 = \mathbf{12} \quad (\text{DL} = 12)$$

Both methods give column index **12**.

---

## 5. Quick Reference Cheat Sheet

| Calculation                    | Formula                                                   |
| :----------------------------- | :-------------------------------------------------------- |
| **Box Height**                 | $\text{DH} - \text{CH} + 1$                               |
| **Box Width**                  | $\text{DL} - \text{CL} + 1$                               |
| **Vertical Center Row**        | $(\text{CH} + \text{DH}) / 2$                             |
| **Horizontal Center (Screen)** | $(80 - \text{StringLength}) / 2$                          |
| **Horizontal Center (Box)**    | $\text{CL} + (\text{BoxWidth} - \text{StringLength}) / 2$ |
| **Right-Aligned in Box**       | $\text{DL} - \text{StringLength}$                         |
| **Left-Aligned with Margin**   | $\text{CL} + \text{Margin}$                               |
