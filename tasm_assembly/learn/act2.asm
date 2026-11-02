.model small
.stack
.data
    uni db "C E B U   I N S T I T U T E   O F   T E C H N O L O G Y$"
    
    subjCode db "C P E   4 6 3   H 1$"
    subj1 db "COMPUTER SYSTEM ORGANIZATION$"
    subj2 db "D O M A I N   E X P A N S I O N$"
    subj3 db "A S S E M B L Y   L A N G U A G E$"
    subj4 db "P R O G R A M M I N G$"

    lastName db "PACRES$"
    firstName db "JOHN EMMANUEL$"
    sectionTxt db "CPE-463$"
    courseTxt db "B S C p E$"
    year db "4$"
.code

main proc
    mov ax, @data
    mov ds, ax
    
    ; call helper procedures
    call layer1
    call layer2
    call layer3
    call layer4
    call finalLayer
    ; park cursor
    mov ah, 02h
    mov bh, 00h
    mov dh, 23
    mov dl, 0
    int 10h
    
    mov ah, 4ch
    int 21h
    ret
main endp

; background (layer 1)
layer1 proc
    mov ah, 06h
    mov al, 00h
    mov bh, 42h ; red (background), green (text)
    mov ch, 0
    mov cl, 0
    mov dh, 24
    mov dl, 79 
    int 10h
    ret
layer1 endp

; blue box top (layer 2)
layer2 proc
    ; outer blue box
    mov ah, 06h
    mov al, 00h
    mov bh, 13h ; blue (background), cyan (text)
    mov ch, 2   ; top row (0-24) y
    mov cl, 1   ; top col (0-79) x
    mov dh, 5   ; bot row (0-24) y
    mov dl, 78  ; bot col (0-79) x
    int 10h
    
    ; inner box
    mov ah, 06h
    mov al, 00h
    mov bh, 6eh ; gold (background), yellow (text)
    mov ch, 4    ; top row
    mov cl, 3    ; top col
    mov dh, 4    ; bot row
    mov dl, 76   ; bot col
    int 10h
    
    ; cursor move and print school name
    mov ah, 02h
    mov bh, 00h
    mov dh, 4   ; bot row
    mov dl, 12  ; bot col
    int 10h
    
    mov ah, 09h
    lea dx, uni
    int 21h
    ret  
layer2 endp

; center box
layer3 proc
    ; top outer green box
    mov ah, 06h
    mov al, 00h
    mov bh, 20h
    mov ch, 7
    mov cl, 4
    mov dh, 17
    mov dl, 77
    int 10h
    
    ; lower outer blue box
    mov ah, 06h
    mov al, 00h
    mov bh, 10h
    mov ch, 9
    mov cl, 2
    mov dh, 19
    mov dl, 75
    int 10h
    
    ; center gray box
    mov ah, 06h
    mov al, 00h
    mov bh, 78h
    mov ch, 8
    mov cl, 3
    mov dh, 18
    mov dl, 76
    int 10h
    ret
layer3 endp


; text inside the gray box
layer4 proc
    ; subject code
    mov ah, 02h
    mov bh, 00h
    mov dh, 9
    mov dl, 31
    int 10h
    mov ah, 09h
    lea dx, subjCode
    int 21h
    ; subject 1
    mov ah, 02h
    mov dh, 11
    mov dl, 26
    int 10h
    mov ah, 09h
    lea dx, subj1
    int 21h
    ; subject 2
    mov ah, 02h
    mov dh, 13
    mov dl, 25
    int 10h
    mov ah, 09h
    lea dx, subj2
    int 21h
    ; subject 3
    mov ah, 02h
    mov dh, 15
    mov dl, 24
    int 10h
    mov ah, 09h
    lea dx, subj3
    int 21h
    ; subject 4
    mov ah, 02h
    mov dh, 17
    mov dl, 30
    int 10h
    mov ah, 09h
    lea dx, subj4
    int 21h
    ret
layer4 endp

finalLayer proc
    ; left side
    ; bottom outer blue box
    mov ah, 06h
    mov al, 00h
    mov bh, 10h
    mov ch, 22
    mov cl, 4
    mov dh, 23
    mov dl, 26
    int 10h
    ; upper gray box
    mov ah, 06h
    mov al, 00h
    mov bh, 78h
    mov ch, 21
    mov cl, 2
    mov dh, 22
    mov dl, 24
    int 10h
    ; last name
    mov ah, 02h
    mov bh, 00h
    mov dh, 21
    mov dl, 10
    int 10h
    mov ah, 09h
    lea dx, lastName
    int 21h
    ; first name
    mov ah, 02h
    mov bh, 00h
    mov dh, 22
    mov dl, 8
    int 10h
    mov ah, 09h
    lea dx, firstName
    int 21h
    ; section txt
    mov ah, 02h
    mov dh, 22
    mov dl, 37
    int 10h
    mov ah, 09h
    lea dx, sectionTxt
    int 21h
    ; right side
    ; bottom outer blue box
    mov ah, 06h
    mov al, 00h
    mov bh, 10h
    mov ch, 22
    mov cl, 58
    mov dh, 23
    mov dl, 76
    int 10h
    ; upper gray box
    mov ah, 06h
    mov al, 00h
    mov bh, 78h
    mov ch, 21
    mov cl, 56
    mov dh, 22
    mov dl, 74
    int 10h
    ; course text
    mov ah, 02h
    mov bh, 00h
    mov dh, 21
    mov dl, 61
    int 10h
    mov ah, 09h
    lea dx, courseTxt
    int 21h
    ; year
    mov ah, 02h
    mov bh, 00h
    mov dh, 22
    mov dl, 65
    int 10h
    mov ah, 09h
    lea dx, year
    int 21h
    ret
finalLayer endp
end main


    