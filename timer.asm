; Timer

irq0_handler:
	mov ax,word [cs:count]
	test ax,ax
	jz .skip
	dec ax
	mov word [cs:count],ax
.skip:
	iret

; Clubbes bx
sleep:
	push dx
	push bx
	push ax
	; ax - milliseconds
	xor dx,dx
	mov bx,55
	div bx
	mov word [cs:count],ax
.loop:
	mov ax,word [cs:count]
	test ax,ax
	jz .loop_end
	jmp .loop
.loop_end:
	pop ax
	pop bx
	pop dx
	ret
	
install_timer:
	xor ax,ax
	mov es,ax
	
	mov ax,word [es:70h]
	mov word [old_timer],ax
	mov ax,word [es:72h]
	mov word [old_timer+2],ax
	
	mov word [es:70h],irq0_handler
	mov word [es:72h],cs
	ret
	
remove_timer:
	xor ax,ax
	mov es,ax
	
	mov ax,word [old_timer]
	mov word [es:70h],ax
	mov ax,word [old_timer+2]
	mov word [es:72h],ax
	ret