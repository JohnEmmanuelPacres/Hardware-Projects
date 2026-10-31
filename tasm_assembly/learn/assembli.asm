.MODEL SMALL
.STACK 100h

.DATA
    ; --- Define your variables here ---
    promptMsg  DB 'Enter a single character: $'
    outputMsg  DB 13, 10, 'You entered: $'  ; 13 = Carriage Return (CR), 10 = Line Feed (LF)
    userChar   DB ?                         ; '?' means uninitialized byte

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    LEA DX, promptMsg        
    MOV AH, 09h              
    INT 21h
    MOV AH, 01h           
    INT 21h
    MOV userChar, AL      
    LEA DX, outputMsg
    MOV AH, 09h
    INT 21h
    MOV DL, userChar        
    MOV AH, 02h              
    INT 21h
    MOV AH, 4Ch
    INT 21h
MAIN ENDP
END MAIN