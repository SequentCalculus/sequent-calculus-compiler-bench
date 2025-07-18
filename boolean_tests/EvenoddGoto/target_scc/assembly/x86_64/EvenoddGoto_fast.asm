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
    ; if i < 0 \{ ... \}
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
    ; x1 <- x0 * i;
    mov r11, r9
    imul r11, rdx
    ; substitute (x1 := x1)(a0 := a0);
    ; #move variables
    mov rdx, r11
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

even_abs_:
    ; if i == 0 \{ ... \}
    cmp rdx, 0
    je lab4
    ; else branch
    ; lit x0 <- 1;
    mov r9, 1
    ; x1 <- i - x0;
    mov r11, rdx
    sub r11, r9
    ; substitute (x1 := x1)(a0 := a0)(a00 := a0);
    ; #share a0
    cmp rsi, 0
    je lab5
    ; ####increment refcount
    add qword [rsi + 0], 1

lab5:
    ; #move variables
    mov r8, rsi
    mov r9, rdi
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
    ; if i == 0 \{ ... \}
    cmp rdx, 0
    je lab6
    ; else branch
    ; substitute (i := i)(k := k);
    ; #erase a0
    cmp r8, 0
    je lab9
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab7
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab8

lab7:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab8:

lab9:
    ; lit x0 <- 1;
    mov r9, 1
    ; x1 <- i - x0;
    mov r11, rdx
    sub r11, r9
    ; substitute (x1 := x1)(k := k);
    ; #move variables
    mov rdx, r11
    ; jump even_abs_
    jmp even_abs_

lab6:
    ; then branch
    ; substitute (k := k);
    ; #erase a0
    cmp r8, 0
    je lab12
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab10
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab11

lab10:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab11:

lab12:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke k False
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
    je lab24
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab25

lab24:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab22
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab15
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab13
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab14

lab13:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab14:

lab15:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab18
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab16
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab17

lab16:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab17:

lab18:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab21
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab19
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab20

lab19:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab20:

lab21:
    jmp lab23

lab22:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab23:

lab25:
    ; #load tag
    lea rdi, [rel _Cont_26]
    ; jump abs_i_
    jmp abs_i_

_Cont_26:

_Cont_26_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab28
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab27
    ; ####increment refcount
    add qword [rsi + 0], 1

lab27:
    jmp lab29

lab28:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab29:
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
    je lab41
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab42

lab41:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab39
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab38
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab36
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab37

lab36:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab37:

lab38:
    jmp lab40

lab39:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab40:

lab42:
    ; #load tag
    lea rdi, [rel _Cont_43]
    ; jump abs_i_
    jmp abs_i_

_Cont_43:

_Cont_43_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab45
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab44
    ; ####increment refcount
    add qword [rsi + 0], 1

lab44:
    jmp lab46

lab45:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab46:
    ; substitute (x0 := x0)(a0 := a0)(a00 := a0);
    ; #share a0
    cmp rsi, 0
    je lab47
    ; ####increment refcount
    add qword [rsi + 0], 1

lab47:
    ; #move variables
    mov r8, rsi
    mov r9, rdi
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
    je lab59
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab60

lab59:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab57
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab50
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab48
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab49

lab48:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab49:

lab50:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab53
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab51
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab52

lab51:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab52:

lab53:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab56
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab54
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab55

lab54:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab55:

lab56:
    jmp lab58

lab57:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab58:

lab60:
    ; #load tag
    lea rdi, [rel Bool_61]
    ; jump even_
    jmp even_

Bool_61:
    jmp near Bool_61_True
    jmp near Bool_61_False

Bool_61_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab63
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab62
    ; ####increment refcount
    add qword [rsi + 0], 1

lab62:
    mov rdx, [rax + 24]
    jmp lab64

lab63:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]

lab64:
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
    je lab76
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab77

lab76:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab74
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab67
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab65
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab66

lab65:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab66:

lab67:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab70
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab68
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab69

lab68:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab69:

lab70:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab73
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab71
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab72

lab71:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab72:

lab73:
    jmp lab75

lab74:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab75:

lab77:
    ; #load tag
    lea rdi, [rel Bool_78]
    ; jump odd_
    jmp odd_

Bool_78:
    jmp near Bool_78_True
    jmp near Bool_78_False

Bool_78_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab80
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab79
    ; ####increment refcount
    add qword [rax + 0], 1

lab79:
    jmp lab81

lab80:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab81:
    ; let x0: Bool = True();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; jump lift_main_loop_0_
    jmp lift_main_loop_0_

Bool_78_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab83
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab82
    ; ####increment refcount
    add qword [rax + 0], 1

lab82:
    jmp lab84

lab83:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab84:
    ; let x0: Bool = False();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 5
    ; jump lift_main_loop_0_
    jmp lift_main_loop_0_

Bool_61_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab86
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab85
    ; ####increment refcount
    add qword [rsi + 0], 1

lab85:
    mov rdx, [rax + 24]
    jmp lab87

lab86:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]

lab87:
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
    je lab99
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab100

lab99:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab97
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab90
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab88
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab89

lab88:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab89:

lab90:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab93
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab91
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab92

lab91:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab92:

lab93:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab96
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab94
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab95

lab94:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab95:

lab96:
    jmp lab98

lab97:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab98:

lab100:
    ; #load tag
    lea rdi, [rel Bool_101]
    ; jump not_
    jmp not_

Bool_101:
    jmp near Bool_101_True
    jmp near Bool_101_False

Bool_101_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab103
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab102
    ; ####increment refcount
    add qword [r8 + 0], 1

lab102:
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    jmp lab104

lab103:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]

lab104:
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

Bool_101_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab106
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab105
    ; ####increment refcount
    add qword [r8 + 0], 1

lab105:
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    jmp lab107

lab106:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]

lab107:
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
    je lab108
    ; else branch
    ; substitute (a0 := a0)(iters := iters)(n := n);
    ; #erase res
    cmp r10, 0
    je lab111
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab109
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab110

lab109:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab110:

lab111:
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

lab108:
    ; then branch
    ; substitute (a0 := a0)(res := res);
    ; #move variables
    mov rsi, r10
    mov rdi, r11
    ; switch res \{ ... \};
    lea rcx, [rel Bool_112]
    add rcx, rdi
    jmp rcx

Bool_112:
    jmp near Bool_112_True
    jmp near Bool_112_False

Bool_112_True:
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

Bool_112_False:
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