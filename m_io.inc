include io.inc

matrix_input proc c
	arg @n, @matrix
	uses bx, si, di
	mov bx, @matrix
	xor si, si
@@cycle1:
	cmp si, @n
	je @@end
	xor di, di
@@cycle2:
	cmp di, @n
	je @@ns
	push offset str_matr1
	push offset m_out
	call strcpy
	add sp, 4
	push 10
	push offset tmp
	push si
	call itoa
	add sp, 6
	push offset tmp
	push offset m_out
	call strcat
	add sp, 4
	push offset str_matr2
	push offset m_out
	call strcat
	add sp, 4
	push 10
	push offset tmp
	push di
	call itoa
	add sp, 6
	push offset tmp
	push offset m_out
	call strcat
	add sp, 4
	push offset str_matr3
	push offset m_out
	call strcat
	add sp, 4
	push offset m_out
	call icin
	add sp, 2
	mov word ptr[bx], ax
	add bx, 2
	inc di
	jmp @@cycle2
@@ns:	
	inc si
	jmp @@cycle1
@@end:
	ret
matrix_input endp

m_ifin proc c
	arg @m, @n, @handle
	uses bx, cx, dx, si, di
	
	mov ax, n
	cwd
	mul ax
	mov di, ax
	
	sub sp, 80
	mov dx, sp
	
	mov si, @m
	xor cx, cx
	
	push dx
	push @handle
	
@@cycle:
	cmp cx, di
	je @@end
	call ifin
	cmp bl, 0
	je @@ns
	add sp, 84
	mov ax, 1
	ret
@@ns:
	mov [si], ax
	add si, 2
	inc cx
	jmp @@cycle
	
@@end:
	add sp, 84
	putc endl
	xor ax, ax
	ret
m_ifin endp