org 0h
use16

jmp _start

%include "timer.asm"
%include "blaster.asm"
%include "x86ata.asm"

BUF_SEG equ 0820h
SND_SEG1 equ 0900h
SND_SEG2 equ 0100h

_exit:
	; Restore timer
	cli
	call remove_timer
	sti
	
	jmp $
	
; Main code

setup_video:
	xor ax,ax
	mov al,13h
	int 10h
	ret
	
load_palette:
	; Load sectors
	push 2		; Sector number
	push BUF_SEG	; Segment
	push 0 		; Offset
	push 3 		; Block
	call read_sector
	; Load palette to VGA
	mov dx,03C8h
	xor al,al
	out dx,al
	
	push ds
	mov ax,BUF_SEG
	mov ds,ax
	xor si,si
	
	mov cx,256
	mov dx,03C9h
	cli
.write_palette:
	lodsb
	out dx,al
	lodsb
	out dx,al
	lodsb
	out dx,al
	loop .write_palette
	sti

	pop ds
	ret
	
load_image:
	; Load image directly to video buf
	; by 64 sectors at once
	
	push 64	; Sector num
	push 0A000h	; Segment
	push 0		; Offset
	push 5		; Block
	call read_sector
	
	push 64	; Sector num
	push 0A000h	; Segment
	push 8000h		; Offset
	push 69		; Block
	call read_sector
	
	ret

play_sound:
	push bp
	mov bp,sp
	sub sp,04h ; Allocate 2 variables
	; -2 - block pointer
	; -4 - parity
	
	; Load first sectors
	push 32
	push SND_SEG1
	push 0
	push 132
	call read_sector
	mov word [bp-02h],164
	mov word [bp-04h],0
.play_n_load:
	mov word [cs:count],72
	
	mov ax,word [bp-04h]
	test ax,ax
	jnz .play_odd
	push 4000h
	push SND_SEG1
	push 0 ; Offset
	mov word [bp-04h],1
	call play_dsp
	jmp .play_finish
.play_odd:
	push 4000h
	push SND_SEG2
	push 0 ; Offset
	call play_dsp
	mov word [bp-04h],0
.play_finish:

	mov ax,word [bp-04h]
	test ax,ax
	jnz .load_odd
	push 32
	push SND_SEG1
	push 0
	push word [bp-02h]
	call read_sector
	jmp .load_finish
.load_odd:
	push 32
	push SND_SEG2
	push 0
	push word [bp-02h]
	call read_sector
.load_finish:
	; Wait
	nop
	nop
	nop
	mov ax,word [cs:count]
	test ax,ax
	jnz .load_finish
	
	; Next step
	mov cx,word [bp-02h]
	add cx,32
	mov word [bp-02h],cx
	cmp cx,694
	jl .play_n_load
	
	; Return
	mov sp,bp
	pop bp
	ret
	
_start:
	mov byte [drive_num],dl

	; Setup segments
	mov ax,cs
	mov ds,ax
	; Setup stack
	mov ax,50h
	mov ss,ax
	mov sp,1F0h ; 1 KiB stack

	; Install timer
	cli
	call install_timer
	sti
	
	; Setup video
	call setup_video
	
	mov ax,1000
	call sleep
	
	call load_palette
	call load_image
	
	; Sound part
	mov word [dsp_base],220h
	cli
	call install_dsp
	sti
	
	; Load and play sound
	call speaker_on
	;mov ax,0D1h
	;call write_dsp
	
	;call init_dsp
	call reset_dsp
	
hang:
	call play_sound
	jmp hang
	
	;call speaker_off
	
	;jmp _exit

%include "data.asm"