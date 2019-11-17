; Sound

dsp_handler:
	mov al,20h
	out 20h,al
	iret

install_dsp:
	; Get interrupt
	mov dx,word [dsp_base]
	add dx,0Eh
	in ax,dx
	shl ax,2 ; Mul by 4
	; Install IRQ handler
	mov bx,ax
	xor ax,ax
	mov es,ax
	mov word [es:bx],dsp_handler
	mov word [es:bx+2],cs
	
	ret
	
write_dsp:
	push ax
	mov dx,word [dsp_base]
	add dx,0Ch
.dsp_write_loop:
	in ax,dx
	and al,80h
	jnz .dsp_write_loop
	
	mov dx,word [dsp_base]
	add dx,0Ch
	pop ax
	out dx,al
	ret
	
read_dsp:
	mov ax,word [dsp_base]
	add ax,0Eh
.dsp_read_loop:
	in ax,dx
	and dx,80h
	jz .dsp_read_loop
	mov ax,word [dsp_base]
	add ax,0Ah
	in ax,dx
	mov ax,dx
	ret
	
reset_dsp:
	mov dx,word [dsp_base]
	add dx,06h
	mov ax,1
	out dx,al
	
	push ax
	mov ax,55
	call sleep
	
	pop ax
	xor ax,ax
	out dx,al
	
	ret

play_dsp:
	push bp
	mov bp,sp
	; 1 +4 - offset
	; 2 +6 - segment
	; 3 +8 - size
	dec word [bp+08h]
	
	mov ax,5
	out 0Ah,al
	
	xor ax,ax
	out 0Ch,al
	
	mov al,49h
	out 0Bh,al
	
	; Calc offset
	mov ax,word [bp+06h] ; Segment
	shl ax,4
	add ax,word [bp+04h] ; Offset
	
	out 02h,al
	shr ax,8
	out 02h,al
	
	; Calc page
	mov ax,word [bp+04h] ; Offset
	shr ax,4
	add ax,word [bp+06h] ; Segment
	shr ax,12
	
	out 83h,al
	
	; Calc size
	mov ax,word [bp+08h] ; Size
	out 03h,al
	shr ax,8
	out 03h,al
	
	;
	xor al,al
	inc al
	out 0Ah,al
	
	; Write time constant = 6
	mov al,40h
	call write_dsp
	
	mov al,06h
	call write_dsp
	; Set the playback type
	mov al,14h
	call write_dsp
	
	mov ax,word [bp+08h]
	
	call write_dsp ; Lo(size)
	shr ax,8
	call write_dsp ; Hi(size)
	
	mov sp,bp
	pop bp
	ret 06h

speaker_on:
	mov ax,0D1h
	call write_dsp
	ret
	
speaker_off:
	mov ax,0D3h
	call write_dsp
	ret