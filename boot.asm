org 0x7C00
use16

; In bootloader we need to load demo.bin
; And far call it
; sector 2-3 demo.bin

DEMO_SEG equ 07E0h

mov ax,DEMO_SEG
mov es,ax
xor bx,bx

mov ah,02h
mov al,2 ; 2 Sectors
mov ch,0 ; Cylinder
mov cl,2 ; Sector 2
xor dx,dx
int 13h

;mov ax,cs
;mov ds,ax

;mov ah,42h
;mov si,ata_packet
;mov dl,0x80
;xor dl,dl
;int 13h

;Here we far jump
jmp DEMO_SEG:0000h

ata_packet:
		db 16
		db 0
num_sec dw 2
buf_off dw 0
buf_seg dw DEMO_SEG
lbaadrl dd 1 ; sector 2
lbaadrh dd 0
	
TIMES 510 - ($ - $$) db 0
dw 0xAA55

