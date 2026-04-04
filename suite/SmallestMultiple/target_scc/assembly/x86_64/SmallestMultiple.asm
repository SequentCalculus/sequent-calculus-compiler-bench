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

divide_range_:
    ; if min >= max \{ ... \}
    cmp rdx, rdi
    jge lab2
    ; else branch
    ; x0 <- test % min;
    mov rcx, rdx
    mov r13, rax
    mov rax, r9
    cqo
    idiv rcx
    mov rax, r13
    mov r13, rdx
    mov rdx, rcx
    ; if x0 == 0 \{ ... \}
    cmp r13, 0
    je lab3
    ; else branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, r10
    mov rdx, r11
    ; invoke a0 False
    add rdx, 5
    jmp rdx

lab3:
    ; then branch
    ; substitute (min := min)(max := max)(test := test)(a0 := a0);
    ; lit x1 <- 1;
    mov r13, 1
    ; x2 <- min + x1;
    mov r15, rdx
    add r15, r13
    ; substitute (x2 := x2)(max := max)(test := test)(a0 := a0);
    ; #move variables
    mov rdx, r15
    ; divide_range(...)
    jmp divide_range_

lab2:
    ; then branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, r10
    mov rdx, r11
    ; invoke a0 True
    add rdx, 0
    jmp rdx

smallest_multiple_rec_:
    ; lit x0 <- 1;
    mov r11, 1
    ; substitute (n0 := n)(curr0 := curr)(x0 := x0)(a0 := a0)(n := n)(curr := curr);
    ; #move variables
    mov r13, rdx
    mov r15, rdi
    mov r10, r8
    mov rcx, r11
    mov r11, r9
    mov r9, rcx
    ; create a1: Bool = (a0, n, curr)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov qword [rbx + 48], 0
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    mov [rbx + 24], r11
    mov [rbx + 16], r10
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab15
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
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
    lea r11, [rel Bool_17]
    ; substitute (x0 := x0)(n0 := n0)(curr0 := curr0)(a1 := a1);
    ; #move variables
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; divide_range(...)
    jmp divide_range_

Bool_17:
    jmp near Bool_17_True
    jmp near Bool_17_False

Bool_17_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab19
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab18
    ; ####increment refcount
    add qword [rax + 0], 1

lab18:
    jmp lab20

lab19:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab20:
    ; substitute (curr := curr)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rdi, rdx
    mov rdx, r9
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

Bool_17_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab22
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab21
    ; ####increment refcount
    add qword [rax + 0], 1

lab21:
    jmp lab23

lab22:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab23:
    ; lit x1 <- 1;
    mov r11, 1
    ; x2 <- curr + x1;
    mov r13, r9
    add r13, r11
    ; substitute (n := n)(x2 := x2)(a0 := a0);
    ; #move variables
    mov r8, rax
    mov r9, rdx
    mov rdx, rdi
    mov rdi, r13
    ; smallest_multiple_rec(...)
    jmp smallest_multiple_rec_

smallest_multiple_:
    ; lit x0 <- 1;
    mov r9, 1
    ; substitute (n := n)(x0 := x0)(a0 := a0);
    ; #move variables
    mov r8, rsi
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; smallest_multiple_rec(...)
    jmp smallest_multiple_rec_

main_loop_:
    ; substitute (n0 := n)(n := n)(a0 := a0)(iters := iters);
    ; #move variables
    mov r11, rdx
    mov rdx, rdi
    ; create a1: _Cont = (n, a0, iters)\{ ... \};
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
    je lab35
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab36

lab35:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab33
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab26
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab24
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab25

lab24:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab25:

lab26:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab29
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab27
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab28

lab27:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab28:

lab29:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab32
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab30
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab31

lab30:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab31:

lab32:
    jmp lab34

lab33:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab34:

lab36:
    ; #load tag
    lea rdi, [rel _Cont_37]
    ; smallest_multiple(...)
    jmp smallest_multiple_

_Cont_37:

_Cont_37_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab39
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab38
    ; ####increment refcount
    add qword [r8 + 0], 1

lab38:
    mov rdi, [rsi + 24]
    jmp lab40

lab39:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]

lab40:
    ; lit x0 <- 1;
    mov r13, 1
    ; if iters == x0 \{ ... \}
    cmp r11, r13
    je lab41
    ; else branch
    ; substitute (iters := iters)(n := n)(a0 := a0);
    ; #move variables
    mov rdx, r11
    ; lit x1 <- 1;
    mov r11, 1
    ; x2 <- iters - x1;
    mov r13, rdx
    sub r13, r11
    ; substitute (x2 := x2)(n := n)(a0 := a0);
    ; #move variables
    mov rdx, r13
    ; main_loop(...)
    jmp main_loop_

lab41:
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
    ; lit x3 <- 0;
    mov rdi, 0
    ; substitute (x3 := x3)(a0 := a0);
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