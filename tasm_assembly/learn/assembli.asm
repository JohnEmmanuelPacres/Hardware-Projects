.MODEL SMALL
.STACK 100h

.DATA
    cardTitle DB "[ OFFICIAL STUDENT ID ]$"
    studentName DB "Name: John Emmanuel Pacres$"
    studentCourse DB "Course: BSCPE$"
.CODE
MAIN PROC
    MOV AX, @data
    MOV DS, AX
    
    ; Clear the whole screen to Dark Gray
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 80H
    MOV CH, 0
    MOV CL, 0
    MOV DH, 24
    MOV DL, 79
    INT 10H
    ; first part
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 70H ; COLOR (BG + TEXT)
    MOV CH, 07  ; TOP ROW (0-24)
    MOV CL, 20  ; LEFT COL (0-79)
    MOV DH, 16  ; BOTTOM ROW (0-24)
    MOV DL, 60  ; RIGHT COL (0-79)
    INT 10H     ; SNAP BRICK
    ; second part
    MOV AH, 06H
    MOV AL, 00H
    MOV BH, 4EH ; COLOR (BG + TEXT)
    MOV CH, 7  ; TOP ROW (0-24)
    MOV CL, 20  ; LEFT COL (0-79)
    MOV DH, 7  ; BOTTOM ROW (0-24)
    MOV DL, 60  ; RIGHT COL (0-79)
    INT 10H     ; SNAP BRICK
    ; third part
    MOV AH, 02H
    MOV BH, 00H
    MOV DH, 7
    MOV DL, 29
    INT 10H
    
    MOV AH, 09H
    LEA DX, cardTitle
    INT 21H
    ; fourth part
    MOV AH, 02H
    MOV BH, 00H
    MOV DH, 10
    MOV DL, 24
    INT 10H
    
    MOV AH, 09H
    LEA DX, studentName
    INT 21H
    
    ; fifth part
    MOV AH, 02H
    MOV BH, 00H
    MOV DH, 12
    MOV DL, 24
    INT 10H
    
    MOV AH, 09H
    LEA DX, studentCourse
    INT 21H
    
    ; park cursor
    MOV AH, 02H
    MOV BH, 00H
    MOV DH, 18
    MOV DL, 0
    INT 10H
    
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
    
    
    
    