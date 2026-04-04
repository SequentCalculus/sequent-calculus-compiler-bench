    ; asmsyntax=nasm
section .note.GNU-stack noalloc noexec nowrite progbits
section .text
extern print_i64
extern println_i64
global asm_main

asm_main:
    ; setup
    ; save registers
    push rbx
    push rbp
    push r12
    push r13
    push r14
    push r15
    ; reserve space for register spills
    sub rsp, 2048
    ; initialize heap pointer
    mov rbx, rdi
    ; initialize free pointer
    mov rbp, rbx
    add rbp, 64
    ; move parameters into place
    mov rdi, rdx
    ; move parameters into place
    mov rdx, rsi
    ; actual code

main_:
    ; create a0: _Cont = ()\{ ... \};
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    lea r9, [rel _Cont_1]
    ; main_loop(...)
    jmp main_loop_

_Cont_1:

_Cont_1_Ret:
    ; exit x0
    mov rax, rdx
    jmp cleanup

sum_fib_acc_:
    ; next <- curr + last;
    mov r15, rdx
    add r15, rdi
    ; if next > max \{ ... \}
    cmp r15, r9
    jg lab2
    ; else branch
    ; substitute (curr := curr)(next := next)(max := max)(acc := acc)(a0 := a0);
    ; #move variables
    mov rdi, r15
    ; lit x0 <- 2;
    mov r15, 2
    ; x1 <- next % x0;
    mov rcx, rdx
    mov [rsp + 2024], rax
    mov rax, rdi
    cqo
    idiv r15
    mov rax, [rsp + 2024]
    mov [rsp + 2024], rdx
    mov rdx, rcx
    ; if x1 == 0 \{ ... \}
    cmp qword [rsp + 2024], 0
    je lab3
    ; else branch
    ; substitute (next := next)(curr := curr)(max := max)(acc := acc)(a0 := a0);
    ; #move variables
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; sum_fib_acc(...)
    jmp sum_fib_acc_

lab3:
    ; then branch
    ; substitute (curr := curr)(next := next)(max := max)(acc := acc)(a0 := a0);
    ; x2 <- next + acc;
    mov r15, rdi
    add r15, r11
    ; substitute (next := next)(curr := curr)(max := max)(x2 := x2)(a0 := a0);
    ; #move variables
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov r11, r15
    ; sum_fib_acc(...)
    jmp sum_fib_acc_

lab2:
    ; then branch
    ; substitute (acc := acc)(a0 := a0);
    ; #move variables
    mov rdx, r11
    mov rsi, r12
    mov rdi, r13
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

sum_fib_:
    ; lit x0 <- 1;
    mov r9, 1
    ; lit x1 <- 1;
    mov r11, 1
    ; lit x2 <- 0;
    mov r13, 0
    ; substitute (x0 := x0)(x1 := x1)(max := max)(x2 := x2)(a0 := a0);
    ; #move variables
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov r12, rsi
    mov rcx, r11
    mov r11, r13
    mov r13, rdi
    mov rdi, rcx
    ; sum_fib_acc(...)
    jmp sum_fib_acc_

main_loop_:
    ; substitute (max0 := max)(max := max)(a0 := a0)(iters := iters);
    ; #move variables
    mov r11, rdx
    mov rdx, rdi
    ; create a1: _Cont = (max, a0, iters)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    mov [rbx + 24], rdi
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rsi, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab15
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab16

lab15:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab13
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab6
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab4
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab5

lab4:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab5:

lab6:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab9
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab7
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab8

lab7:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab8:

lab9:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab12
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab10
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab11

lab10:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab11:

lab12:
    jmp lab14

lab13:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab14:

lab16:
    ; #load tag
    lea rdi, [rel _Cont_17]
    ; sum_fib(...)
    jmp sum_fib_

_Cont_17:

_Cont_17_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab19
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab18
    ; ####increment refcount
    add qword [r8 + 0], 1

lab18:
    mov rdi, [rsi + 24]
    jmp lab20

lab19:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]

lab20:
    ; if iters == 0 \{ ... \}
    cmp r11, 0
    je lab21
    ; else branch
    ; substitute (iters := iters)(max := max)(a0 := a0);
    ; #move variables
    mov rdx, r11
    ; lit x0 <- 1;
    mov r11, 1
    ; x1 <- iters - x0;
    mov r13, rdx
    sub r13, r11
    ; substitute (x1 := x1)(max := max)(a0 := a0);
    ; #move variables
    mov rdx, r13
    ; main_loop(...)
    jmp main_loop_

lab21:
    ; then branch
    ; substitute (res := res)(a0 := a0);
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; println_i64 res;
    ; #save caller-save registers
    mov r12, rdx
    mov r13, rsi
    mov r14, rdi
    sub rsp, 8
    ; #move argument into place
    mov rdi, rdx
    call println_i64
    ; #restore caller-save registers
    mov rdx, r12
    mov rsi, r13
    mov rdi, r14
    add rsp, 8
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; lit x2 <- 0;
    mov rdi, 0
    ; substitute (x2 := x2)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

cleanup:
    ; free space for register spills
    add rsp, 2048
    ; restore registers
    pop r15
    pop r14
    pop r13
    pop r12
    pop rbp
    pop rbx
    ret