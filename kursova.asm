.model small
.386
.stack 2000h
.data
	dijk		db 'Dijkstra', endl, 0
	keyboard_in	db '1.Enter from keyboard', endl, 0 
	file_in	    db '2.Enter from file', endl, 0 
	str_n		db 'n=', 0
	str_error	db 'Error!', endl, 0 
	str_end	    db 'Enter ESC for exit', endl, 0
	str_matr1	db 'matrix[', 0 
	str_matr2	db '][', 0 
	str_matr3	db ']=', 0 
	str_start	db 'start=', 0
	str_file	db 'file: ', 0 
	n			dw 0
	beg			dw 0
	len			dw ?
	matrix		dw ?
	distance	dw ?
	visited		dw ?
	handle		dw ?	
	file_name	db 80 dup(0)
	m_out		db 80 dup(0)
	tmp 		db 80 dup(0)
.code

LOCALS

include m_io.inc

index proc c
	arg i
	uses ax, cx
	mov ax, n
	add ax, ax 
	mov cx, i 
	xor bx, bx
index_cycle:  
	cmp cx, 0
	je index_end
	add bx, ax 
	dec cx
	jmp index_cycle 
index_end: 
	add bx, matrix
	ret
index endp

dijkstra proc c
	uses ax, bx, cx, dx, si, di
	local @count, @index, @i, @u, @min
	mov cx, n
	dec cx
dijkstra_cycle1: 
	cmp cx, 0 
	je dijkstra_end2 
	mov @min, -1
	xor si, si
dijkstra_cycle2: 
	cmp si, n
	je dijkstra_end 
	mov bx, visited
	add bx, si
	cmp byte ptr[bx], 0
	jne dijkstra_endif1 
	mov bx, distance
	add bx, si 
	add bx, si 
	mov ax, @min
	cmp word ptr[bx], ax 
	ja dijkstra_endif1 
	mov ax, word ptr[bx] 
	mov @min, ax
	mov @index, si
dijkstra_endif1: 
	inc si
	jmp dijkstra_cycle2 
dijkstra_end: 
	mov ax, @index
	mov @u, ax
	mov bx, visited
	add bx, ax
	mov byte ptr[bx], 1
	xor si, si
dijkstra_cycle3: 
	cmp si, n
	je equal
	mov bx, visited
	add bx, si
	cmp byte ptr[bx], 0
	jne dijkstra_endif2
	push @u
	call index
	add sp, 2
	add bx, si
	add bx, si
	cmp word ptr[bx], 0
	je dijkstra_endif2 
	mov ax, word ptr[bx]
	mov bx, distance
	add bx, @u
	add bx, @u
	cmp word ptr[bx], -1
	je dijkstra_endif2 
	add ax, word ptr[bx]
	mov bx, distance
	add bx, si
	add bx, si
	cmp ax, word ptr[bx]
	jnb dijkstra_endif2 
	mov word ptr[bx], ax
dijkstra_endif2: 
	inc si
	jmp dijkstra_cycle3 
equal: 	
	dec cx
	jmp dijkstra_cycle1 
dijkstra_end2: 
	ret
dijkstra endp

main proc
    mov ax, @data
    mov ds, ax
	
pochatok: 
	puts dijk
	puts keyboard_in
	puts file_in
	
check_input: 
	call _getch
	cmp al, '1'
	je keyboard_input
	cmp al, '2'
	je file_input
	cmp ah, 1
	jne check_input
	_exit
	
file_input: 
	putc endl
	puts str_file
	push offset file_name
	call gets
	putc endl
	putc endl
	push RO
    push offset file_name
    call fopen
    add sp, 4
	test ax, ax
    jne file_er
	puts str_error
	jmp pochatok 
	
file_er:
	mov handle, ax
	push offset tmp
	push handle
	call ifin
	add sp, 4
	cmp bl, 0
	je file_open
	puts str_error
	jmp pochatok 
	
file_open: 
	mov n, ax	
	cwd
	mul ax
	add ax, ax
	mov len, ax
	sub sp, ax
	mov matrix, sp	
	puts str_n
	puts tmp	
	push handle
	push n
	push matrix
	call m_ifin
	add sp, 6	
	push ax
	putc endl
	pop ax	
	cmp al, 0
	je prisv 
	puts str_error
	add sp, len
	jmp pochatok 
	
keyboard_input: 
	push offset str_n
	call icin
	add sp, 2
	mov n, ax
	cwd
	mul ax
	add ax, ax
	mov len, ax
	sub sp, ax
	mov matrix, sp
	push sp
	push n
	call matrix_input
	add sp, 4
	
prisv: 
	mov ax, n
	sub sp, ax
	mov visited, sp
	add ax, ax
	sub sp, ax
	mov distance, sp
	push offset str_start
	
poch_versh: 
	call icin
	dec ax
	cmp ax, n
	jb norm_versh
	puts str_error
	jmp poch_versh
	
norm_versh: 
	add sp, 2
	mov beg, ax
	putc endl	
	mov si, visited
	mov di, distance
	mov cx, n

my_cycle:
	cmp cx, 0
	je alg_beg
	mov byte ptr[si], 0
	mov word ptr[di], -1
	inc si
	dec cx
	jmp my_cycle
	
alg_beg:
	mov si, distance
	mov ax, beg
	add si, ax
	add si, ax 
	mov word ptr[si], 0	
	push beg
	call dijkstra
	add sp, 2	
	xor cx, cx
	mov bx, distance
	
vivid:
	cmp cx, n
	jnb kin
	push 10
	push offset tmp
	push word ptr[bx]
	call itoa
	add sp, 6
	puts tmp
	putc endl
	inc cx
	add bx, 2
	jmp vivid
	
kin:
	add sp, len
	add sp, n
	add sp, n
	add sp, n
	getc 
	_exit
main endp
end main