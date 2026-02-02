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

isqrt_rec_:
    ; lit x0 <- 1;
    mov r13, 1
    ; x1 <- r - x0;
    mov r15, r9
    sub r15, r13
    ; if l != x1 \{ ... \}
    cmp rdi, r15
    jne lab2
    ; else branch
    ; substitute (l := l)(a0 := a0);
    ; #move variables
    mov rdx, rdi
    mov rsi, r10
    mov rdi, r11
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

lab2:
    ; then branch
    ; substitute (n := n)(l := l)(r := r)(a0 := a0);
    ; x2 <- l + r;
    mov r13, rdi
    add r13, r9
    ; lit x3 <- 2;
    mov r15, 2
    ; m <- x2 / x3;
    mov rcx, rdx
    mov [rsp + 2024], rax
    mov rax, r13
    cqo
    idiv r15
    mov rdx, rax
    mov rax, [rsp + 2024]
    mov [rsp + 2024], rdx
    mov rdx, rcx
    ; substitute (n := n)(l := l)(r := r)(a0 := a0)(m := m);
    ; #move variables
    mov r13, [rsp + 2024]
    ; x4 <- m * m;
    mov r15, r13
    imul r15, r13
    ; if x4 <= n \{ ... \}
    cmp r15, rdx
    jle lab3
    ; else branch
    ; substitute (n := n)(l := l)(m := m)(a0 := a0);
    ; #move variables
    mov r9, r13
    ; isqrt_rec(...)
    jmp isqrt_rec_

lab3:
    ; then branch
    ; substitute (n := n)(m := m)(r := r)(a0 := a0);
    ; #move variables
    mov rdi, r13
    ; isqrt_rec(...)
    jmp isqrt_rec_

isqrt_:
    ; lit x0 <- 0;
    mov r9, 0
    ; lit x1 <- 1;
    mov r11, 1
    ; x2 <- n - x1;
    mov r13, rdx
    sub r13, r11
    ; substitute (n := n)(x0 := x0)(x2 := x2)(a0 := a0);
    ; #move variables
    mov r10, rsi
    mov r11, rdi
    mov rdi, r9
    mov r9, r13
    ; isqrt_rec(...)
    jmp isqrt_rec_

is_prime_rec_:
    ; if last >= n \{ ... \}
    cmp rdi, rdx
    jge lab4
    ; else branch
    ; x0 <- n % last;
    mov rcx, rdx
    mov r11, rax
    mov rax, rdx
    cqo
    idiv rdi
    mov rax, r11
    mov r11, rdx
    mov rdx, rcx
    ; if x0 == 0 \{ ... \}
    cmp r11, 0
    je lab5
    ; else branch
    ; substitute (n := n)(last := last)(a0 := a0);
    ; lit x1 <- 1;
    mov r11, 1
    ; x2 <- last + x1;
    mov r13, rdi
    add r13, r11
    ; substitute (n := n)(x2 := x2)(a0 := a0);
    ; #move variables
    mov rdi, r13
    ; is_prime_rec(...)
    jmp is_prime_rec_

lab5:
    ; then branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 False
    add rdx, 5
    jmp rdx

lab4:
    ; then branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 True
    add rdx, 0
    jmp rdx

is_prime_:
    ; lit x0 <- 2;
    mov r9, 2
    ; substitute (n := n)(x0 := x0)(a0 := a0);
    ; #move variables
    mov r8, rsi
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; is_prime_rec(...)
    jmp is_prime_rec_

next_prime_:
    ; substitute (upper0 := upper)(a0 := a0)(upper := upper);
    ; #move variables
    mov r9, rdx
    ; create a1: Bool = (a0, upper)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov qword [rbx + 48], 0
    mov [rbx + 40], rdi
    mov [rbx + 32], rsi
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rsi, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab17
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab18

lab17:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab15
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab8
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab6
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab7

lab6:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab7:

lab8:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab11
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab9
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab10

lab9:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab10:

lab11:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab14
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab12
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab13

lab12:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab13:

lab14:
    jmp lab16

lab15:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab16:

lab18:
    ; #load tag
    lea rdi, [rel Bool_19]
    ; is_prime(...)
    jmp is_prime_

Bool_19:
    jmp near Bool_19_True
    jmp near Bool_19_False

Bool_19_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab21
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab20
    ; ####increment refcount
    add qword [rax + 0], 1

lab20:
    jmp lab22

lab21:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab22:
    ; substitute (upper := upper)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

Bool_19_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab24
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab23
    ; ####increment refcount
    add qword [rax + 0], 1

lab23:
    jmp lab25

lab24:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab25:
    ; lit x0 <- 1;
    mov r9, 1
    ; x1 <- upper - x0;
    mov r11, rdi
    sub r11, r9
    ; substitute (x1 := x1)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rdi, rdx
    mov rdx, r11
    ; next_prime(...)
    jmp next_prime_

largest_prime_factor_rec_:
    ; x0 <- n % next_check;
    mov rcx, rdx
    mov r11, rax
    mov rax, rdx
    cqo
    idiv rdi
    mov rax, r11
    mov r11, rdx
    mov rdx, rcx
    ; if x0 == 0 \{ ... \}
    cmp r11, 0
    je lab26
    ; else branch
    ; substitute (n := n)(next_check := next_check)(a0 := a0);
    ; lit x1 <- 1;
    mov r11, 1
    ; x2 <- next_check - x1;
    mov r13, rdi
    sub r13, r11
    ; substitute (x2 := x2)(n := n)(a0 := a0);
    ; #move variables
    mov rdi, rdx
    mov rdx, r13
    ; create a1: _Cont = (n, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    mov [rbx + 40], rdi
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rsi, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab38
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab39

lab38:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab36
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab35
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab33
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab34

lab33:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab34:

lab35:
    jmp lab37

lab36:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab37:

lab39:
    ; #load tag
    lea rdi, [rel _Cont_40]
    ; next_prime(...)
    jmp next_prime_

_Cont_40:

_Cont_40_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab42
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab41
    ; ####increment refcount
    add qword [r8 + 0], 1

lab41:
    mov rdi, [rsi + 40]
    jmp lab43

lab42:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]

lab43:
    ; substitute (n := n)(next := next)(a0 := a0);
    ; #move variables
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; largest_prime_factor_rec(...)
    jmp largest_prime_factor_rec_

lab26:
    ; then branch
    ; substitute (next_check := next_check)(a0 := a0);
    ; #move variables
    mov rdx, rdi
    mov rsi, r8
    mov rdi, r9
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

largest_prime_factor_:
    ; substitute (n0 := n)(a0 := a0)(n := n);
    ; #move variables
    mov r9, rdx
    ; create a1: _Cont = (a0, n)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov qword [rbx + 48], 0
    mov [rbx + 40], rdi
    mov [rbx + 32], rsi
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rsi, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab55
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab56

lab55:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab53
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab46
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab44
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab45

lab44:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab45:

lab46:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab49
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab47
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab48

lab47:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab48:

lab49:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab52
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab50
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab51

lab50:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab51:

lab52:
    jmp lab54

lab53:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab54:

lab56:
    ; #load tag
    lea rdi, [rel _Cont_57]
    ; isqrt(...)
    jmp isqrt_

_Cont_57:

_Cont_57_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab59
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab58
    ; ####increment refcount
    add qword [rsi + 0], 1

lab58:
    jmp lab60

lab59:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab60:
    ; substitute (n := n)(max_check := max_check)(a0 := a0);
    ; #move variables
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov r8, rsi
    ; largest_prime_factor_rec(...)
    jmp largest_prime_factor_rec_

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
    je lab72
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab73

lab72:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab70
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab63
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab61
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab62

lab61:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab62:

lab63:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab66
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab64
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab65

lab64:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab65:

lab66:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab69
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab67
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab68

lab67:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab68:

lab69:
    jmp lab71

lab70:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab71:

lab73:
    ; #load tag
    lea rdi, [rel _Cont_74]
    ; largest_prime_factor(...)
    jmp largest_prime_factor_

_Cont_74:

_Cont_74_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab76
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab75
    ; ####increment refcount
    add qword [r8 + 0], 1

lab75:
    mov rdi, [rsi + 24]
    jmp lab77

lab76:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]

lab77:
    ; if iters == 0 \{ ... \}
    cmp r11, 0
    je lab78
    ; else branch
    ; substitute (iters := iters)(n := n)(a0 := a0);
    ; #move variables
    mov rdx, r11
    ; lit x0 <- 1;
    mov r11, 1
    ; x1 <- iters - x0;
    mov r13, rdx
    sub r13, r11
    ; substitute (x1 := x1)(n := n)(a0 := a0);
    ; #move variables
    mov rdx, r13
    ; main_loop(...)
    jmp main_loop_

lab78:
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