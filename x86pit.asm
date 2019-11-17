
unmask_irq0:
	; PIC 20h
	mov dx,21h
	in al,dx
	nop
	and al,0b11111110
	nop
	out dx,al
	nop
	
	ret

setup_pic:
	; Start
	mov al,11h
	out 20h,al
	nop
	
	out 0A0h,al
	nop
	; 1. Map
	mov al,20h
	out 21h,al
	nop
	
	mov al,28h
	out 0A1h,al
	nop
	; 2. Connect each other
	mov al,04h
	out 21h,al
	nop
	
	mov al,02h
	out 0A1h,al
	nop
	; 3. Final
	mov al,1
	
	out 21h,al
	nop
	out 0A1h,al
	nop
	; 4. Clear
	xor al,al
	out 21h,al
	nop
	out 0A1h,al
	nop
	
	ret
	
setup_pit:
	mov al,00110110b
	out 43h,al
	nop
	xor cx,cx
	
	mov al,cl
	out 40h,al
	nop
	
	mov al,ch
	out 40h,al
	nop
	
	ret