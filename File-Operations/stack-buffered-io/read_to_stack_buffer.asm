;nasm -f elf64 read_to_stack_buffer.asm -o read_to_stack_buffer.o
;ld read_to_stack_buffer.o -o read_to_stack_buffer

global _start


_start:



    sub rsp, 0x8000
    and rsp, -16
    mov rbp, rsp            ; anchor
    
    lea rsi, [rel texts]  		;
    lea rdi, [rbp + 0x100]     	; 
    mov rcx, 4096                ; packet size
    rep movsb
    
    
    jmp _contiune
    file_path db "/etc/passwd",0
    message db "THATS ALL",10
    texts times 4096 db 0

_contiune:
	lea rdi, [rel file_path]
	mov rax, 2
	xor rsi,rsi
	syscall
	push rax
	
	xor rax,rax
	pop rdi
	lea rsi, [rbp + 0x100]
	mov rdx, 4096
	syscall
	push rdi
	
	mov rax, 1
	mov rdi, 1
	lea rsi, [rbp + 0x100]
	syscall
	
	mov rax, 1
	mov rdi, 1
	lea rsi, [rel message]
	mov rdx, 10
	syscall
	
	mov rax, 3
	pop rdi
	syscall
	
	
	mov rax,60
	xor rdi,rdi
	syscall
	
