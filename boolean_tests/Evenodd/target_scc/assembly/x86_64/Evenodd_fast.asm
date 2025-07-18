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
    ; jump main_loop_
    jmp main_loop_

_Cont_1:

_Cont_1_Ret:
    ; exit x0
    mov rax, rdx
    jmp cleanup

not_:
    ; substitute (a0 := a0)(b := b);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch b \{ ... \};
    lea rcx, [rel Bool_2]
    add rcx, rdi
    jmp rcx

Bool_2:
    jmp near Bool_2_True
    jmp near Bool_2_False

Bool_2_True:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Bool_2_False:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

abs_i_:
    ; if n < 0 \{ ... \}
    cmp rdx, 0
    jl lab3
    ; else branch
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

lab3:
    ; then branch
    ; lit x0 <- -1;
    mov r9, -1
    ; x1 <- x0 * n;
    mov r11, r9
    imul r11, rdx
    ; substitute (x1 := x1)(a0 := a0);
    ; #move variables
    mov rdx, r11
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

even_abs_:
    ; if n == 0 \{ ... \}
    cmp rdx, 0
    je lab4
    ; else branch
    ; lit x0 <- 1;
    mov r9, 1
    ; x1 <- n - x0;
    mov r11, rdx
    sub r11, r9
    ; substitute (x1 := x1)(a0 := a0);
    ; #move variables
    mov rdx, r11
    ; jump odd_abs_
    jmp odd_abs_

lab4:
    ; then branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 True
    add rdx, 0
    jmp rdx

odd_abs_:
    ; if n == 0 \{ ... \}
    cmp rdx, 0
    je lab5
    ; else branch
    ; lit x0 <- 1;
    mov r9, 1
    ; x1 <- n - x0;
    mov r11, rdx
    sub r11, r9
    ; substitute (x1 := x1)(a0 := a0);
    ; #move variables
    mov rdx, r11
    ; jump even_abs_
    jmp even_abs_

lab5:
    ; then branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 False
    add rdx, 5
    jmp rdx

even_:
    ; create a1: _Cont = (a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdi
    mov [rbx + 48], rsi
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
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
    lea rdi, [rel _Cont_19]
    ; jump abs_i_
    jmp abs_i_

_Cont_19:

_Cont_19_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab21
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab20
    ; ####increment refcount
    add qword [rsi + 0], 1

lab20:
    jmp lab22

lab21:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab22:
    ; jump even_abs_
    jmp even_abs_

odd_:
    ; create a1: _Cont = (a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdi
    mov [rbx + 48], rsi
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov rsi, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab34
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab35

lab34:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab32
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab25
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab23
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab24

lab23:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab24:

lab25:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab28
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab26
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab27

lab26:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab27:

lab28:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab31
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab29
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab30

lab29:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab30:

lab31:
    jmp lab33

lab32:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab33:

lab35:
    ; #load tag
    lea rdi, [rel _Cont_36]
    ; jump abs_i_
    jmp abs_i_

_Cont_36:

_Cont_36_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab38
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab37
    ; ####increment refcount
    add qword [rsi + 0], 1

lab37:
    jmp lab39

lab38:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab39:
    ; jump odd_abs_
    jmp odd_abs_

main_loop_:
    ; substitute (n1 := n)(n := n)(a0 := a0)(iters := iters);
    ; #move variables
    mov r11, rdx
    mov rdx, rdi
    ; create a2: Bool = (n, a0, iters)\{ ... \};
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
    je lab51
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab52

lab51:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab49
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab42
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab40
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab41

lab40:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab41:

lab42:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab45
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab43
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab44

lab43:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab44:

lab45:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab48
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab46
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab47

lab46:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab47:

lab48:
    jmp lab50

lab49:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab50:

lab52:
    ; #load tag
    lea rdi, [rel Bool_53]
    ; jump even_
    jmp even_

Bool_53:
    jmp near Bool_53_True
    jmp near Bool_53_False

Bool_53_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab55
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab54
    ; ####increment refcount
    add qword [rsi + 0], 1

lab54:
    mov rdx, [rax + 24]
    jmp lab56

lab55:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]

lab56:
    ; substitute (n0 := n)(a0 := a0)(iters := iters)(n := n);
    ; #move variables
    mov r11, rdx
    ; create a1: Bool = (a0, iters, n)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    mov [rbx + 24], rdi
    mov [rbx + 16], rsi
    ; ##acquire free block from heap register
    mov rsi, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab68
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab69

lab68:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab66
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab59
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab57
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab58

lab57:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab58:

lab59:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab62
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab60
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab61

lab60:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab61:

lab62:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab65
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab63
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab64

lab63:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab64:

lab65:
    jmp lab67

lab66:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab67:

lab69:
    ; #load tag
    lea rdi, [rel Bool_70]
    ; jump odd_
    jmp odd_

Bool_70:
    jmp near Bool_70_True
    jmp near Bool_70_False

Bool_70_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab72
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab71
    ; ####increment refcount
    add qword [rax + 0], 1

lab71:
    jmp lab73

lab72:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab73:
    ; let x0: Bool = True();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; jump lift_main_loop_0_
    jmp lift_main_loop_0_

Bool_70_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab75
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab74
    ; ####increment refcount
    add qword [rax + 0], 1

lab74:
    jmp lab76

lab75:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab76:
    ; let x0: Bool = False();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 5
    ; jump lift_main_loop_0_
    jmp lift_main_loop_0_

Bool_53_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab78
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab77
    ; ####increment refcount
    add qword [rsi + 0], 1

lab77:
    mov rdx, [rax + 24]
    jmp lab79

lab78:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]

lab79:
    ; let res: Bool = False();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(iters := iters)(n := n)(res := res);
    ; #move variables
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, rsi
    ; jump share_main_loop_0_
    jmp share_main_loop_0_

lift_main_loop_0_:
    ; substitute (x0 := x0)(iters := iters)(n := n)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; create a3: Bool = (iters, n, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    mov [rbx + 24], rdi
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rsi, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab91
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab92

lab91:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab89
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab82
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab80
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab81

lab80:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab81:

lab82:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab85
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab83
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab84

lab83:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab84:

lab85:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab88
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab86
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab87

lab86:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab87:

lab88:
    jmp lab90

lab89:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab90:

lab92:
    ; #load tag
    lea rdi, [rel Bool_93]
    ; jump not_
    jmp not_

Bool_93:
    jmp near Bool_93_True
    jmp near Bool_93_False

Bool_93_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab95
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab94
    ; ####increment refcount
    add qword [r8 + 0], 1

lab94:
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    jmp lab96

lab95:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]

lab96:
    ; let res: Bool = True();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(iters := iters)(n := n)(res := res);
    ; #move variables
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, r8
    ; jump share_main_loop_0_
    jmp share_main_loop_0_

Bool_93_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab98
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab97
    ; ####increment refcount
    add qword [r8 + 0], 1

lab97:
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    jmp lab99

lab98:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]

lab99:
    ; let res: Bool = False();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(iters := iters)(n := n)(res := res);
    ; #move variables
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, r8
    ; jump share_main_loop_0_
    jmp share_main_loop_0_

share_main_loop_0_:
    ; lit x0 <- 1;
    mov r13, 1
    ; if iters == x0 \{ ... \}
    cmp rdi, r13
    je lab100
    ; else branch
    ; substitute (a0 := a0)(iters := iters)(n := n);
    ; #erase res
    cmp r10, 0
    je lab103
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab101
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab102

lab101:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab102:

lab103:
    ; lit x3 <- 1;
    mov r11, 1
    ; x4 <- iters - x3;
    mov r13, rdi
    sub r13, r11
    ; substitute (x4 := x4)(n := n)(a0 := a0);
    ; #move variables
    mov r8, rax
    mov rdi, r9
    mov r9, rdx
    mov rdx, r13
    ; jump main_loop_
    jmp main_loop_

lab100:
    ; then branch
    ; substitute (a0 := a0)(res := res);
    ; #move variables
    mov rsi, r10
    mov rdi, r11
    ; switch res \{ ... \};
    lea rcx, [rel Bool_104]
    add rcx, rdi
    jmp rcx

Bool_104:
    jmp near Bool_104_True
    jmp near Bool_104_False

Bool_104_True:
    ; lit x1 <- 1;
    mov rdi, 1
    ; println_i64 x1;
    ; #save caller-save registers
    mov r12, rax
    mov r13, rdx
    mov r14, rdi
    sub rsp, 8
    ; #move argument into place
    mov rdi, rdi
    call println_i64
    ; #restore caller-save registers
    mov rax, r12
    mov rdx, r13
    mov rdi, r14
    add rsp, 8
    ; substitute (a0 := a0);
    ; lit x5 <- 0;
    mov rdi, 0
    ; substitute (x5 := x5)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

Bool_104_False:
    ; lit x2 <- 0;
    mov rdi, 0
    ; println_i64 x2;
    ; #save caller-save registers
    mov r12, rax
    mov r13, rdx
    mov r14, rdi
    sub rsp, 8
    ; #move argument into place
    mov rdi, rdi
    call println_i64
    ; #restore caller-save registers
    mov rax, r12
    mov rdx, r13
    mov rdi, r14
    add rsp, 8
    ; substitute (a0 := a0);
    ; lit x6 <- 0;
    mov rdi, 0
    ; substitute (x6 := x6)(a0 := a0);
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