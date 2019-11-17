read_sector:
	push bp
	mov bp,sp
	; +4 block num
	; +6 offset
	; +8 segment
	; +A sector num
	push ax
	push bx
	push dx
	push cx
	
	mov ax,word [bp+04h]
	mov bx,18
	xor dx,dx
	div bx
	
	; ax - track, dx - sector
	inc dl
	mov cl,dl
	
	mov bx,2
	xor dx,dx
	div bx
	
	mov ch,al
	shl dx,8
	
	mov bx,word [bp+06h]
	mov es,word [bp+08h]
	mov ax,word [bp+0Ah]
	mov dl,byte [drive_num]
	mov ah,02h
	int 13h	
	
	pop cx
	pop dx
	pop bx
	pop ax
	
	mov bp,sp
	pop bp
	ret 08h

;read_sector:
	;push bp
	;mov bp,sp
	; +4 block num
	; +6 offset
	; +8 segment
	; +A sector num
	
	;mov ax,word [bp+04h]
	;mov word [ata_lbaadrl],ax
	
	;mov ax,word [bp+06h]
	;mov word [ata_buf_off],ax
	
	;mov ax,word [bp+08h]
	;mov word [ata_buf_seg],ax
	
	;mov ax,word [bp+0Ah]
	;mov word [ata_num_sec],ax
	
	;push ds
	;mov ax,cs
	;mov ds,ax
	
	;mov ah,42h
	;mov dl,80h
	;mov si,ata_packet
	;int 13h
	;pop ds
	
	;mov bp,sp
	;pop bp
	;ret 08h