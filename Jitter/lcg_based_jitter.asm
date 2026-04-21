_lcg_jitter:
    push rax
    push rbx
    push rcx
    push rdx
    push rsi
    push rdi
    push rbp
    push r8
    push r9
    push r10
    push r11
    push r12
    push r13
    push r14
    push r15

    rdtsc                           ; EAX = TSC low 32 bits
    imul eax, eax, 1664525          ; LCG scramble (increases entropy)
    add  eax, 1013904223
    xor  edx, edx                   ; zero EDX for div (EDX:EAX dividend)
    mov  ecx, 900000000             ; mod 900M  → [0, 900M)
    div  ecx
    add  edx, 100000000             ; shift → [100ms, 1000ms)

    sub  rsp, 32                    ; reserve stack space (aligned)
    mov  qword [rsp],    0          ; tv_sec  = 0
    mov  qword [rsp+8],  rdx        ; tv_nsec = computed value
    mov  rax, 35                    ; sys_nanosleep
    mov  rdi, rsp                   ; req = &timespec
    xor  rsi, rsi                   ; rem = NULL
    syscall
    add  rsp, 32                    ; restore stack

    pop r15
    pop r14
    pop r13
    pop r12
    pop r11
    pop r10
    pop r9
    pop r8
    pop rbp
    pop rdi
    pop rsi
    pop rdx
    pop rcx
    pop rbx
    pop rax
    ret
