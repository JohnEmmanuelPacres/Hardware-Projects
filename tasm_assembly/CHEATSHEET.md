[⬅ Back to Main Repo](../README.md)

# 8086 Assembly Language Cheatsheet (GUI Turbo Assembler / TASM)

Welcome to x86 Assembly! In most Computer Engineering courses using **GUI Turbo Assembler (TASM)**, you are programming for the **16-bit Intel 8086 architecture** running in a DOS environment.

---

## 1. 8086 Registers Overview

In 16-bit assembly, the four main general-purpose registers (`AX`, `BX`, `CX`, `DX`) are $16\text{-bit}$ wide and can be split into two independent $8\text{-bit}$ registers: **High (`H`)** and **Low (`L`)**.

### General-Purpose Registers

| 16-Bit   | High (8-Bit) | Low (8-Bit) | Name            | Primary Academic / Hardware Use Case                                                                                                     |
| :------- | :----------- | :---------- | :-------------- | :--------------------------------------------------------------------------------------------------------------------------------------- |
| **`AX`** | `AH`         | `AL`        | **Accumulator** | Arithmetic operations (`MUL`/`DIV`), I/O operations, and holding interrupt function numbers (in `AH`).                                   |
| **`BX`** | `BH`         | `BL`        | **Base**        | Memory addressing (can be used as a pointer like `[BX]`) and general storage.                                                            |
| **`CX`** | `CH`         | `CL`        | **Counter**     | Loop counter (`LOOP` automatically decrements `CX`) and bit-shift counts (using `CL`).                                                   |
| **`DX`** | `DH`         | `DL`        | **Data**        | Holds high $16\text{ bits}$ in $32\text{-bit}$ `MUL`/`DIV`, stores memory addresses for `INT 21h` strings, and character output in `DL`. |

### Segment, Pointer, & Index Registers

| Register | Name                | Purpose & Use Case                                                                                |
| :------- | :------------------ | :------------------------------------------------------------------------------------------------ |
| **`CS`** | Code Segment        | Points to the memory segment containing the executable program instructions.                      |
| **`DS`** | Data Segment        | Points to the memory segment where variables are stored. Must be initialized manually at startup. |
| **`SS`** | Stack Segment       | Points to the stack memory segment (used by `PUSH`, `POP`, `CALL`, `RET`).                        |
| **`ES`** | Extra Segment       | Additional data segment, heavily used in string operations (`DI`).                                |
| **`SI`** | Source Index        | Used as an offset pointer for reading arrays and source strings (e.g., `[SI]`).                   |
| **`DI`** | Destination Index   | Used as an offset pointer for writing arrays and destination strings (e.g., `[DI]`).              |
| **`BP`** | Base Pointer        | Used to reference parameters and local variables passed on the stack.                             |
| **`SP`** | Stack Pointer       | Points to the current top of the stack. Decrements by $2$ on `PUSH`, increments by $2$ on `POP`.  |
| **`IP`** | Instruction Pointer | Holds the offset of the next instruction to be executed (paired as `CS:IP`).                      |

### Common Status Flags (in the `FLAGS` Register)

| Flag              | Symbol | Set ($1$) When...                                                  | Cleared ($0$) When...            |
| :---------------- | :----- | :----------------------------------------------------------------- | :------------------------------- |
| **Zero Flag**     | `ZF`   | Result of an operation is $0$ (or two values in `CMP` are equal).  | Result is non-zero.              |
| **Carry Flag**    | `CF`   | Unsigned arithmetic generates a carry-out or borrow.               | No carry/borrow occurs.          |
| **Sign Flag**     | `SF`   | Result is negative (Most Significant Bit is $1$).                  | Result is positive (MSB is $0$). |
| **Overflow Flag** | `OF`   | Signed arithmetic result is too large/small to fit in destination. | Signed result fits properly.     |

---

## 2. Data Directives & Addressing Modes

### Memory Allocation Directives (Inside `.DATA`)

| Directive | Meaning           | Size                                | Range (Unsigned / Signed)                      | TASM Example                             |
| :-------- | :---------------- | :---------------------------------- | :--------------------------------------------- | :--------------------------------------- |
| **`DB`**  | Define Byte       | $8\text{ bits}$ ($1\text{ byte}$)   | $0\text{ to }255$ / $-128\text{ to }127$       | `num1 DB 25`<br>`msg DB 'Hello$'`        |
| **`DW`**  | Define Word       | $16\text{ bits}$ ($2\text{ bytes}$) | $0\text{ to }65535$ / $-32768\text{ to }32767$ | `num2 DW 1024`                           |
| **`DD`**  | Define Doubleword | $32\text{ bits}$ ($4\text{ bytes}$) | $0\text{ to }2^{32}-1$                         | `bigNum DD 100000`                       |
| **`EQU`** | Equate (Constant) | $0\text{ bytes}$ (Macro)            | N/A                                            | `MAX_SIZE EQU 10`                        |
| **`DUP`** | Duplicate         | Variable                            | N/A                                            | `arr DB 10 DUP(0)` _(Array of ten $0$s)_ |

### Common Addressing Modes

| Mode                  | Syntax Example      | Explanation                                                                  |
| :-------------------- | :------------------ | :--------------------------------------------------------------------------- |
| **Register**          | `MOV AX, BX`        | Copies data directly from one register to another.                           |
| **Immediate**         | `MOV AL, 05h`       | Loads a constant value ($5$ in hex) into a register.                         |
| **Direct**            | `MOV AL, [var1]`    | Accesses the memory value stored at variable `var1`.                         |
| **Register Indirect** | `MOV AL, [SI]`      | Uses the address stored inside `BX`, `SI`, or `DI` as a pointer to memory.   |
| **Based / Indexed**   | `MOV AL, [BX + SI]` | Combines a base register and index register to calculate the memory address. |

---

## 3. Instructions Categorized by Use Case

### A. Data Transfer Instructions

| Instruction | Syntax           | Description                                                                                             | Example & Notes                                   |
| :---------- | :--------------- | :------------------------------------------------------------------------------------------------------ | :------------------------------------------------ |
| **`MOV`**   | `MOV dest, src`  | Copies `src` to `dest`. **Note:** Cannot `MOV` memory-to-memory directly!                               | `MOV AX, BX`<br>`MOV AL, 'A'`                     |
| **`LEA`**   | `LEA reg16, mem` | Loads the **Effective Address** (offset pointer) of a variable into a $16\text{-bit}$ register.         | `LEA DX, msg`<br>_(Same as `MOV DX, OFFSET msg`)_ |
| **`XCHG`**  | `XCHG op1, op2`  | Swaps the contents of two operands (useful in sorting algorithms like Bubble Sort).                     | `XCHG AL, BL`                                     |
| **`PUSH`**  | `PUSH src16`     | Decrements `SP` by $2$ and stores a $16\text{-bit}$ value onto the top of the stack.                    | `PUSH AX`                                         |
| **`POP`**   | `POP dest16`     | Retrieves the $16\text{-bit}$ value from the top of the stack into `dest16` and increments `SP` by $2$. | `POP AX` _(Must match `PUSH` in reverse order)_   |

### B. Arithmetic Instructions

| Instruction | Syntax          | Mathematical Operation                                                                                                                                                                              | Implicit Registers & Important Rules                                                                                                                                                  |
| :---------- | :-------------- | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **`ADD`**   | `ADD dest, src` | $\text{dest} = \text{dest} + \text{src}$                                                                                                                                                            | Operands must be the same size ($8\text{-bit}$ or $16\text{-bit}$).                                                                                                                   |
| **`ADC`**   | `ADC dest, src` | $\text{dest} = \text{dest} + \text{src} + \text{CF}$                                                                                                                                                | Add with Carry (used for multi-word addition).                                                                                                                                        |
| **`SUB`**   | `SUB dest, src` | $\text{dest} = \text{dest} - \text{src}$                                                                                                                                                            | Sets `CF=1` if an unsigned borrow occurs (`dest < src`).                                                                                                                              |
| **`INC`**   | `INC dest`      | $\text{dest} = \text{dest} + 1$                                                                                                                                                                     | Does **not** affect the Carry Flag (`CF`).                                                                                                                                            |
| **`DEC`**   | `DEC dest`      | $\text{dest} = \text{dest} - 1$                                                                                                                                                                     | Does **not** affect the Carry Flag (`CF`).                                                                                                                                            |
| **`NEG`**   | `NEG dest`      | $\text{dest} = -\text{dest}$                                                                                                                                                                        | Computes the two's complement of `dest`.                                                                                                                                              |
| **`CMP`**   | `CMP op1, op2`  | Computes $\text{op1} - \text{op2}$                                                                                                                                                                  | Updates `FLAGS` without changing `op1` or `op2`. Used before conditional jumps.                                                                                                       |
| **`MUL`**   | `MUL src`       | **8-bit:** $\text{AX} = \text{AL} \times \text{src8}$<br>**16-bit:** $\text{DX:AX} = \text{AX} \times \text{src16}$                                                                                 | **Unsigned** multiply. `src` cannot be an immediate constant (put it in a register first).                                                                                            |
| **`IMUL`**  | `IMUL src`      | Same as `MUL`, but preserves sign                                                                                                                                                                   | **Signed** multiply.                                                                                                                                                                  |
| **`DIV`**   | `DIV src`       | **8-bit:** $\frac{\text{AX}}{\text{src8}} \rightarrow \text{AL (Quotient)}, \text{AH (Remainder)}$<br>**16-bit:** $\frac{\text{DX:AX}}{\text{src16}} \rightarrow \text{AX (Quot)}, \text{DX (Rem)}$ | **Unsigned** divide. **CRITICAL:** Always clear `AH` (`MOV AH, 0`) before $8\text{-bit}$ division, or `DX` (`XOR DX, DX`) before $16\text{-bit}$ division to prevent Divide Overflow! |
| **`IDIV`**  | `IDIV src`      | Same as `DIV`, but preserves sign                                                                                                                                                                   | **Signed** divide (use `CBW` or `CWD` to sign-extend before dividing).                                                                                                                |

### C. Bitwise & Logical Instructions

| Instruction       | Syntax            | Use Case / Idiom                                                                                                                                            | Example                                   |
| :---------------- | :---------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------- | :---------------------------------------- |
| **`AND`**         | `AND dest, src`   | Clears specific bits (Masking). Also converts ASCII digit `'0'-'9'` to binary ($0-9$) via `AND AL, 0Fh`, or lowercase to uppercase via `AND AL, 11011111b`. | `AND AL, 0Fh`                             |
| **`OR`**          | `OR dest, src`    | Sets specific bits. Converts number ($0-9$) to ASCII character (`'0'-'9'`) via `OR AL, 30h`, or uppercase to lowercase via `OR AL, 00100000b`.              | `OR AL, 30h`                              |
| **`XOR`**         | `XOR dest, src`   | Inverts specific bits. **Fastest way to clear a register to $0$:** `XOR AX, AX`.                                                                            | `XOR DX, DX`                              |
| **`NOT`**         | `NOT dest`        | Inverts all bits (One's complement: $0 \leftrightarrow 1$).                                                                                                 | `NOT AL`                                  |
| **`TEST`**        | `TEST op1, op2`   | Performs `AND` and updates flags without altering `op1`. Check if number is even/odd: `TEST AL, 1` (`ZF=1` means Even, `ZF=0` means Odd).                   | `TEST AL, 01h`                            |
| **`SHL` / `SHR`** | `SHL dest, count` | Shifts bits left/right. Shifting left by $1$ multiplies by $2^1=2$. Shifting right by $1$ divides by $2$. If $\text{count} > 1$, put count in `CL`.         | `SHL AX, 1`<br>`MOV CL, 3` / `SHR AX, CL` |
| **`ROL` / `ROR`** | `ROL dest, count` | Rotates bits left/right in a circle (useful for inspecting bits one by one via the Carry Flag for binary printing).                                         | `ROL BX, 1`                               |

### D. Control Flow, Branching & Looping (After `CMP A, B`)

| Instruction       | Meaning                              | Condition Checked                                                 | Flags Checked                     |
| :---------------- | :----------------------------------- | :---------------------------------------------------------------- | :-------------------------------- |
| **`JMP label`**   | Unconditional Jump                   | Always jumps to `label`                                           | None                              |
| **`JE` / `JZ`**   | Jump if Equal / Jump if Zero         | $A = B$ (or result is $0$)                                        | `ZF = 1`                          |
| **`JNE` / `JNZ`** | Jump if Not Equal / Not Zero         | $A \neq B$ (or result $\neq 0$)                                   | `ZF = 0`                          |
| **`JA` / `JAE`**  | Jump if Above / Above or Equal       | $A > B$ / $A \ge B$ (**Unsigned**)                                | `CF = 0 and ZF = 0` / `CF = 0`    |
| **`JB` / `JBE`**  | Jump if Below / Below or Equal       | $A < B$ / $A \le B$ (**Unsigned**)                                | `CF = 1` / `CF = 1 or ZF = 1`     |
| **`JG` / `JGE`**  | Jump if Greater / Greater or Equal   | $A > B$ / $A \ge B$ (**Signed**)                                  | `ZF = 0 and SF = OF` / `SF = OF`  |
| **`JL` / `JLE`**  | Jump if Less / Less or Equal         | $A < B$ / $A \le B$ (**Signed**)                                  | `SF != OF` / `ZF = 1 or SF != OF` |
| **`JC` / `JNC`**  | Jump if Carry / No Carry             | Carry bit is $1$ / $0$                                            | `CF = 1` / `CF = 0`               |
| **`LOOP label`**  | Decrement `CX` and Jump if `CX != 0` | $\text{CX} \leftarrow \text{CX} - 1$; jumps if $\text{CX} \neq 0$ | None (Checks `CX` directly)       |
| **`CALL proc`**   | Call a Procedure                     | Pushes return `IP` to stack and jumps to `proc`                   | None                              |
| **`RET`**         | Return from Procedure                | Pops return `IP` from stack back into `IP`                        | None                              |

---

## 4. Essential DOS & BIOS Interrupts Cheat Sheet

Interrupts are subroutines built into DOS (`INT 21h`) and the BIOS (`INT 10h`) for handling screen display, keyboard input, and program termination. You always load the function code into **`AH`** before calling the interrupt.

### DOS Services (`INT 21h`)

| `AH` Value        | Service Name                   | Input Parameters Required                     | Output / Return Values                                                                                                        |
| :---------------- | :----------------------------- | :-------------------------------------------- | :---------------------------------------------------------------------------------------------------------------------------- |
| **`01h`**         | **Read Character (with Echo)** | `AH = 01h`                                    | Waits for key press, echoes it to screen, stores ASCII character in **`AL`**.                                                 |
| **`02h`**         | **Print Single Character**     | `AH = 02h`<br>`DL = ASCII character to print` | Prints the character in `DL` to the current cursor position. (`AL` gets modified to `DL`).                                    |
| **`07h` / `08h`** | **Read Character (No Echo)**   | `AH = 07h` (or `08h` for `Ctrl+C` check)      | Waits for key press without displaying it (great for passwords). Character in **`AL`**.                                       |
| **`09h`**         | **Print String**               | `AH = 09h`<br>`DX = Offset address of string` | Prints string starting at `DS:DX` until it encounters a **`'$'`** character (`24h`).                                          |
| **`0Ah`**         | **Buffered String Input**      | `AH = 0Ah`<br>`DX = Offset of buffer array`   | Reads string until `Enter`. Buffer format: `Byte 0` = Max chars, `Byte 1` = Actual chars read, `Byte 2+` = String characters. |
| **`4Ch`**         | **Exit Program to DOS**        | `AH = 4Ch`<br>`AL = 00h` (Return code)        | Safely terminates your assembly program and returns control to DOSBox.                                                        |

### BIOS Video Services (`INT 10h`)

| `AH` Value | Service Name                 | Input Parameters Required                                                                                                                                         | Description / Academic Use Case                                                       |
| :--------- | :--------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------ |
| **`00h`**  | **Set Video Mode / Clear**   | `AH = 00h`, `AL = 03h` ($80 \times 25$ text)                                                                                                                      | Quickest way to clear the screen and reset cursor to $(0,0)$.                         |
| **`02h`**  | **Set Cursor Position**      | `AH = 02h`, `BH = 00h` (Page $0$)<br>`DH = Row` ($0\text{--}24$), `DL = Column` ($0\text{--}79$)                                                                  | Moves the cursor anywhere on the screen (e.g., centering text at `DH = 12, DL = 35`). |
| **`06h`**  | **Scroll Up / Color Screen** | `AH = 06h`, `AL = 00h` (Full clear)<br>`BH = Color Attribute` (e.g., `1Fh` = White on Blue)<br>`CX = 0000h` (Top-left `0,0`), `DX = 184Fh` (Bottom-right `24,79`) | Clears the screen (or a box window) and applies background/foreground colors.         |

---

## 5. Sample Codes & Reusable Academic Procedures

### Template 1: The Standard TASM Skeleton & Basic String I/O

Use this base template for every new lab assignment in GUI Turbo Assembler.

```assembly
.MODEL SMALL
.STACK 100h

.DATA
    ; --- Define your variables here ---
    promptMsg  DB 'Enter a single character: $'
    outputMsg  DB 13, 10, 'You entered: $'  ; 13 = Carriage Return (CR), 10 = Line Feed (LF)
    userChar   DB ?                         ; '?' means uninitialized byte

.CODE
MAIN PROC
    ; 1. Initialize the Data Segment (MANDATORY in every program)
    MOV AX, @DATA
    MOV DS, AX

    ; 2. Display prompt message
    LEA DX, promptMsg       ; Load address of promptMsg into DX
    MOV AH, 09h             ; DOS function: Print '$' terminated string
    INT 21h

    ; 3. Read single character from user
    MOV AH, 01h             ; DOS function: Read character into AL
    INT 21h
    MOV userChar, AL        ; Save AL into variable before AL gets overwritten

    ; 4. Display output message (starts with newline 13, 10)
    LEA DX, outputMsg
    MOV AH, 09h
    INT 21h

    ; 5. Print the saved character
    MOV DL, userChar        ; Load character to print into DL
    MOV AH, 02h             ; DOS function: Print single char in DL
    INT 21h

    ; 6. Exit to DOS (MANDATORY to prevent crashing into random memory)
    MOV AH, 4Ch
    MOV AL, 00h
    INT 21h
MAIN ENDP
END MAIN
```

---

### Template 2: Reusable Utility Procedures (Copy-Paste Into Your Projects!)

In Assembly, printing a newline or printing a number larger than $9$ requires custom logic because `INT 21h` only understands **ASCII codes** (where `'0'` is $48$ or `30h`), not raw binary integers. Place these procedures **after** `MAIN ENDP` and **before** `END MAIN`.

```assembly
; =========================================================================
; PROCEDURE: PRINT_NEWLINE
; Purpose:   Prints a Carriage Return (13) and Line Feed (10)
; Preserves: AX, DX
; =========================================================================
PRINT_NEWLINE PROC
    PUSH AX
    PUSH DX

    MOV AH, 02h
    MOV DL, 13          ; Carriage Return (moves cursor to start of line)
    INT 21h
    MOV DL, 10          ; Line Feed (moves cursor down one line)
    INT 21h

    POP DX
    POP AX
    RET
PRINT_NEWLINE ENDP

; =========================================================================
; PROCEDURE: CLEAR_SCREEN
; Purpose:   Clears the entire screen with standard White-on-Black text
;            and resets cursor to top-left (Row 0, Col 0).
; =========================================================================
CLEAR_SCREEN PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    ; Scroll entire window up to clear
    MOV AH, 06h         ; Scroll up function
    MOV AL, 00h         ; 00h = Clear entire window
    MOV BH, 07h         ; 07h = Light Gray text on Black background (Try 1Eh for Yellow on Blue!)
    MOV CX, 0000h       ; CH = 00 (Top row), CL = 00 (Left column)
    MOV DX, 184Fh       ; DH = 18h/24 (Bottom row), DL = 4Fh/79 (Right column)
    INT 10h

    ; Reset cursor to (0, 0)
    MOV AH, 02h
    MOV BH, 00h         ; Page 0
    MOV DX, 0000h       ; DH = Row 0, DL = Col 0
    INT 10h

    POP DX
    POP CX
    POP BX
    POP AX
    RET
CLEAR_SCREEN ENDP

; =========================================================================
; PROCEDURE: PRINT_NUM_UNSIGNED
; Purpose:   Prints any 16-bit unsigned integer (0 to 65535) stored in AX.
; Input:     AX = Number to print
; Method:    Repeatedly divides AX by 10, pushes remainders onto the stack
;            (so digits reverse into correct order), and pops to print.
; =========================================================================
PRINT_NUM_UNSIGNED PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX

    MOV CX, 0           ; CX will count how many digits we push to stack
    MOV BX, 10          ; Divisor = 10

DIVIDE_LOOP:
    XOR DX, DX          ; CRITICAL: Clear DX before 16-bit division (DX:AX / BX)
    DIV BX              ; AX = Quotient, DX = Remainder (0-9)
    PUSH DX             ; Push remainder (rightmost digit) onto stack
    INC CX              ; Increment digit count
    CMP AX, 0           ; Is quotient 0 yet?
    JNE DIVIDE_LOOP     ; If not 0, keep dividing

PRINT_DIGITS_LOOP:
    POP DX              ; Pop digit from stack (Most Significant Digit comes off first!)
    ADD DL, '0'         ; Convert integer (0-9) to ASCII ('0'-'9', i.e., add 30h)
    MOV AH, 02h         ; DOS print char service
    INT 21h
    LOOP PRINT_DIGITS_LOOP  ; Decrements CX and loops until CX == 0

    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUM_UNSIGNED ENDP

; =========================================================================
; PROCEDURE: READ_NUM_UNSIGNED
; Purpose:   Reads a multi-digit unsigned integer typed by user until Enter.
; Output:    AX = The resulting 16-bit binary integer.
; Method:    Total = (Total * 10) + (NewDigit - '0')
; =========================================================================
READ_NUM_UNSIGNED PROC
    PUSH BX
    PUSH CX
    PUSH DX

    MOV BX, 0           ; BX will hold our running total
    MOV CX, 10          ; Multiplier = 10

READ_DIGIT_LOOP:
    MOV AH, 01h         ; Read character from keyboard into AL
    INT 21h

    CMP AL, 13          ; Check if user pressed ENTER (ASCII 13 = Carriage Return)
    JE DONE_READING     ; If Enter pressed, we are done!

    ; Validate if input is between '0' and '9'
    CMP AL, '0'
    JB READ_DIGIT_LOOP  ; Ignore if below '0'
    CMP AL, '9'
    JA READ_DIGIT_LOOP  ; Ignore if above '9'

    SUB AL, '0'         ; Convert ASCII ('0'-'9') to numeric value (0-9)
    MOV AH, 0           ; Clear AH so AX = numeric value of current digit
    PUSH AX             ; Save new digit on stack temporarily

    ; Compute: BX = (BX * 10) + NewDigit
    MOV AX, BX          ; Move running total into AX
    MUL CX              ; DX:AX = AX * 10
    MOV BX, AX          ; Move multiplied total back to BX

    POP AX              ; Restore the new digit from stack
    ADD BX, AX          ; BX = (BX * 10) + NewDigit
    JMP READ_DIGIT_LOOP

DONE_READING:
    MOV AX, BX          ; Place final result in AX to return to caller
    POP DX
    POP CX
    POP BX
    RET
READ_NUM_UNSIGNED ENDP
```

---

### Template 3: Academic Task — Array Traversal (Sum & Maximum Element)

A very common lab exam problem: iterating through an array of numbers using `SI` and `LOOP`, calculating the sum, and finding the largest value.

```assembly
.MODEL SMALL
.STACK 100h

.DATA
    scores     DB 12, 45, 8, 92, 33, 67, 19, 88   ; Array of 8 bytes
    ARRAY_LEN  EQU 8                              ; Constant for array length
    maxVal     DB 0
    totalSum   DW 0                               ; 16-bit word to prevent overflow

    msgMax     DB 'Maximum Value: $'
    msgSum     DB 13, 10, 'Total Sum: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; --- Initialize pointers and counters ---
    LEA SI, scores          ; SI points to the first element of 'scores'
    MOV CX, ARRAY_LEN       ; CX = Loop counter (8 iterations)

    MOV BL, [SI]            ; Assume first element is the initial maximum (BL = max)
    XOR DX, DX              ; DX will hold the 16-bit running sum (DX = 0)

ARRAY_LOOP:
    MOV AL, [SI]            ; Load current byte from array into AL

    ; 1. Add to Running Sum
    MOV AH, 0               ; Zero-extend AL to 16-bit AX so we can add to 16-bit DX
    ADD DX, AX              ; DX = DX + AX

    ; 2. Check if current element (AL) > current Max (BL)
    CMP AL, BL
    JBE NOT_GREATER         ; If AL <= BL (unsigned), skip updating max
    MOV BL, AL              ; Otherwise, update BL with new maximum!

NOT_GREATER:
    INC SI                  ; Move pointer to next byte in array (Add 2 if array is DW!)
    LOOP ARRAY_LOOP         ; Decrement CX; jump to ARRAY_LOOP if CX != 0

    ; Save results to memory variables
    MOV maxVal, BL
    MOV totalSum, DX

    ; --- Display Maximum Value ---
    LEA DX, msgMax
    MOV AH, 09h
    INT 21h

    MOV AL, maxVal
    MOV AH, 0               ; Put 8-bit maxVal into 16-bit AX for PRINT_NUM_UNSIGNED
    CALL PRINT_NUM_UNSIGNED

    ; --- Display Total Sum ---
    LEA DX, msgSum
    MOV AH, 09h
    INT 21h

    MOV AX, totalSum        ; Load 16-bit sum into AX
    CALL PRINT_NUM_UNSIGNED

    ; Exit program
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

; (Paste PRINT_NUM_UNSIGNED procedure from Template 2 here so this compiles standalone)
PRINT_NUM_UNSIGNED PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    MOV CX, 0
    MOV BX, 10
DIV_LP:
    XOR DX, DX
    DIV BX
    PUSH DX
    INC CX
    CMP AX, 0
    JNE DIV_LP
PRT_LP:
    POP DX
    ADD DL, '0'
    MOV AH, 02h
    INT 21h
    LOOP PRT_LP
    POP DX
    POP CX
    POP BX
    POP AX
    RET
PRINT_NUM_UNSIGNED ENDP

END MAIN
```

---

### Template 4: Academic Task — String Reversal Using the Stack

Another classic problem: reversing a string using the Last-In, First-Out (LIFO) property of the hardware stack.

```assembly
.MODEL SMALL
.STACK 100h

.DATA
    originalStr DB 'COMPUTER ENGINEERING$'
    STR_LENGTH  EQU 20          ; Number of characters before '$'
    msgOrig     DB 'Original: $'
    msgRev      DB 13, 10, 'Reversed: $'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    ; Print Original String
    LEA DX, msgOrig
    MOV AH, 09h
    INT 21h

    LEA DX, originalStr
    MOV AH, 09h
    INT 21h

    ; Print Reversed Label
    LEA DX, msgRev
    MOV AH, 09h
    INT 21h

    ; --- STEP 1: Push all characters onto the Stack ---
    LEA SI, originalStr         ; Point SI to start of string
    MOV CX, STR_LENGTH          ; Loop 20 times

PUSH_LOOP:
    MOV AL, [SI]                ; Get character at current pointer
    MOV AH, 0                   ; Clear AH because PUSH requires a 16-bit register!
    PUSH AX                     ; Push character onto stack
    INC SI                      ; Move to next character
    LOOP PUSH_LOOP

    ; --- STEP 2: Pop characters off the Stack and Print ---
    MOV CX, STR_LENGTH          ; Reset counter to 20

POP_LOOP:
    POP DX                      ; Pop 16-bit value into DX (Character is now in DL!)
    MOV AH, 02h                 ; Print character in DL
    INT 21h
    LOOP POP_LOOP

    ; Exit program
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN
```

---

## 6. Quick Debugging Checklist for Beginners

When your program crashes, prints garbage characters, or enters an infinite loop in GUI Turbo Assembler, check these **Top 6 Pitfalls**:

1. **Missing `'$'` Terminator**: Did you use `INT 21h / AH = 09h` on a string that doesn't end with `'$'`? It will keep printing random memory garbage until it hits a `$` by accident.
2. **ASCII vs. Integer Confusion**: If you add `3 + 4` and put `7` in `DL` to print with `AH = 02h`, DOS prints ASCII character $7$ (which is a system beep!), **not** the digit `'7'`. Always add `'0'` (`30h`) before printing a single digit, and subtract `'0'` (`30h`) after reading a digit!
3. **Divide Overflow Crash**: Before calling `DIV`, if your divisor is $8\text{-bit}$, you **must** clear `AH` (`MOV AH, 0`). If your divisor is $16\text{-bit}$, you **must** clear `DX` (`XOR DX, DX`).
4. **Corrupted `AL` or `DX` During Interrupts**: Remember that `INT 21h / AH = 02h` (print character) overwrites `AL` with the value of `DL`. If you have an important number in `AL`, save it to a variable or `BL` before printing!
5. **"Relative Jump Out of Range" Error**: Conditional jumps (`JE`, `JNE`, `JL`, `LOOP`, etc.) in 8086 can only jump $-128\text{ to }+127\text{ bytes}$ away. If TASM gives a jump out of range error, invert the condition and jump over an unconditional `JMP` (which has no range limit):
   ```assembly
   ; Instead of: JE FAR_AWAY_LABEL (which fails if too far)
   ; Use this:
   JNE SKIP_JUMP
   JMP FAR_AWAY_LABEL
   SKIP_JUMP:
   ```
6. **Unbalanced Stack (`PUSH` / `POP`)**: Inside a `PROC`, if you `PUSH` a register (or fail to `POP` it before `RET`), `RET` will pop your data into the Instruction Pointer (`IP`) instead of the return address, immediately crashing your program!
