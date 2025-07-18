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

and_:
    ; substitute (a0 := a0)(b2 := b2)(b1 := b1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch b1 \{ ... \};
    lea rcx, [rel Bool_2]
    add rcx, r9
    jmp rcx

Bool_2:
    jmp near Bool_2_True
    jmp near Bool_2_False

Bool_2_True:
    ; switch b2 \{ ... \};
    lea rcx, [rel Bool_3]
    add rcx, rdi
    jmp rcx

Bool_3:
    jmp near Bool_3_True
    jmp near Bool_3_False

Bool_3_True:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_3_False:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Bool_2_False:
    ; substitute (a0 := a0);
    ; #erase b2
    cmp rsi, 0
    je lab6
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab4
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab5

lab4:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab5:

lab6:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

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
    lea rcx, [rel Bool_7]
    add rcx, rdi
    jmp rcx

Bool_7:
    jmp near Bool_7_True
    jmp near Bool_7_False

Bool_7_True:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Bool_7_False:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

abs_i_:
    ; if n < 0 \{ ... \}
    cmp rdx, 0
    jl lab8
    ; else branch
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

lab8:
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
    je lab9
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

lab9:
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
    je lab10
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

lab10:
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
    je lab22
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab23

lab22:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab20
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab13
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab11
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab12

lab11:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab12:

lab13:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab16
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab14
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab15

lab14:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab15:

lab16:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab19
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab17
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab18

lab17:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab18:

lab19:
    jmp lab21

lab20:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab21:

lab23:
    ; #load tag
    lea rdi, [rel _Cont_24]
    ; jump abs_i_
    jmp abs_i_

_Cont_24:

_Cont_24_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab26
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab25
    ; ####increment refcount
    add qword [rsi + 0], 1

lab25:
    jmp lab27

lab26:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab27:
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
    je lab39
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab40

lab39:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab37
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab30
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab28
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab29

lab28:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab29:

lab30:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab33
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab31
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab32

lab31:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab32:

lab33:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab36
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab34
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab35

lab34:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab35:

lab36:
    jmp lab38

lab37:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab38:

lab40:
    ; #load tag
    lea rdi, [rel _Cont_41]
    ; jump abs_i_
    jmp abs_i_

_Cont_41:

_Cont_41_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab43
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab42
    ; ####increment refcount
    add qword [rsi + 0], 1

lab42:
    jmp lab44

lab43:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab44:
    ; jump odd_abs_
    jmp odd_abs_

main_loop_:
    ; substitute (n0 := n)(n := n)(a0 := a0)(iters := iters);
    ; #move variables
    mov r11, rdx
    mov rdx, rdi
    ; create a1: Bool = (n, a0, iters)\{ ... \};
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
    je lab56
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab57

lab56:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab54
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab47
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab45
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab46

lab45:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab46:

lab47:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab55

lab54:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab55:

lab57:
    ; #load tag
    lea rdi, [rel Bool_58]
    ; jump even_
    jmp even_

Bool_58:
    jmp near Bool_58_True
    jmp near Bool_58_False

Bool_58_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab60
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab59
    ; ####increment refcount
    add qword [rsi + 0], 1

lab59:
    mov rdx, [rax + 24]
    jmp lab61

lab60:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]

lab61:
    ; let x0: Bool = True();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(iters := iters)(n := n)(x0 := x0);
    ; #move variables
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, rsi
    ; jump lift_main_loop_0_
    jmp lift_main_loop_0_

Bool_58_False:
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
    ; let x0: Bool = False();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(iters := iters)(n := n)(x0 := x0);
    ; #move variables
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, rsi
    ; jump lift_main_loop_0_
    jmp lift_main_loop_0_

lift_main_loop_0_:
    ; substitute (n0 := n)(iters := iters)(n := n)(x0 := x0)(a0 := a0);
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov rdx, r9
    ; create a2: Bool = (iters, n, x0, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    mov [rbx + 24], r9
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab76
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    ; ##store link to previous block
    mov [rbx + 48], r8
    ; ##store values
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
    je lab89
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab90

lab89:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab87
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab80
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab78
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab79

lab78:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab79:

lab80:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab83
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab81
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab82

lab81:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab82:

lab83:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab86
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab84
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab85

lab84:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab85:

lab86:
    jmp lab88

lab87:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab88:

lab90:
    ; #load tag
    lea rdi, [rel Bool_91]
    ; create a3: Bool = (a2)\{ ... \};
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
    je lab103
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab104

lab103:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab101
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab94
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab92
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab93

lab92:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab93:

lab94:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab97
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab95
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab96

lab95:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab96:

lab97:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab100
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab98
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab99

lab98:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab99:

lab100:
    jmp lab102

lab101:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab102:

lab104:
    ; #load tag
    lea rdi, [rel Bool_105]
    ; jump odd_
    jmp odd_

Bool_105:
    jmp near Bool_105_True
    jmp near Bool_105_False

Bool_105_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab107
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab106
    ; ####increment refcount
    add qword [rax + 0], 1

lab106:
    jmp lab108

lab107:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab108:
    ; let x2: Bool = True();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; substitute (x2 := x2)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

Bool_105_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab110
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab109
    ; ####increment refcount
    add qword [rax + 0], 1

lab109:
    jmp lab111

lab110:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab111:
    ; let x2: Bool = False();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 5
    ; substitute (x2 := x2)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

Bool_91:
    jmp near Bool_91_True
    jmp near Bool_91_False

Bool_91_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab114
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab112
    ; ####increment refcount
    add qword [r10 + 0], 1

lab112:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab113
    ; ####increment refcount
    add qword [r8 + 0], 1

lab113:
    mov rdi, [rsi + 24]
    jmp lab115

lab114:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]

lab115:
    ; let x1: Bool = True();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; substitute (a0 := a0)(iters := iters)(n := n)(x0 := x0)(x1 := x1);
    ; #move variables
    mov rcx, r11
    mov r11, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, r10
    mov r10, r8
    ; jump lift_main_loop_1_
    jmp lift_main_loop_1_

Bool_91_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab118
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab116
    ; ####increment refcount
    add qword [r10 + 0], 1

lab116:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab117
    ; ####increment refcount
    add qword [r8 + 0], 1

lab117:
    mov rdi, [rsi + 24]
    jmp lab119

lab118:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]

lab119:
    ; let x1: Bool = False();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 5
    ; substitute (a0 := a0)(iters := iters)(n := n)(x0 := x0)(x1 := x1);
    ; #move variables
    mov rcx, r11
    mov r11, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, r10
    mov r10, r8
    ; jump lift_main_loop_1_
    jmp lift_main_loop_1_

lift_main_loop_1_:
    ; substitute (x1 := x1)(x0 := x0)(n := n)(iters := iters)(a0 := a0);
    ; #move variables
    mov rcx, r12
    mov r12, rax
    mov rax, rcx
    mov rcx, r13
    mov r13, rdx
    mov rdx, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    mov rsi, r10
    ; create a4: Bool = (n, iters, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    mov [rbx + 24], r9
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab131
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab132

lab131:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab129
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab122
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab120
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab121

lab120:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab121:

lab122:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab125
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab123
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab124

lab123:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab124:

lab125:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab128
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab126
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab127

lab126:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab127:

lab128:
    jmp lab130

lab129:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab130:

lab132:
    ; #load tag
    lea r9, [rel Bool_133]
    ; substitute (x0 := x0)(x1 := x1)(a4 := a4);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump and_
    jmp and_

Bool_133:
    jmp near Bool_133_True
    jmp near Bool_133_False

Bool_133_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab135
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab134
    ; ####increment refcount
    add qword [r8 + 0], 1

lab134:
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    jmp lab136

lab135:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]

lab136:
    ; let res: Bool = True();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(iters := iters)(n := n)(res := res);
    ; #move variables
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r8
    ; jump lift_main_loop_2_
    jmp lift_main_loop_2_

Bool_133_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab138
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab137
    ; ####increment refcount
    add qword [r8 + 0], 1

lab137:
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    jmp lab139

lab138:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]

lab139:
    ; let res: Bool = False();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(iters := iters)(n := n)(res := res);
    ; #move variables
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r8
    ; jump lift_main_loop_2_
    jmp lift_main_loop_2_

lift_main_loop_2_:
    ; lit x3 <- 1;
    mov r13, 1
    ; if iters == x3 \{ ... \}
    cmp rdi, r13
    je lab140
    ; else branch
    ; substitute (a0 := a0)(iters := iters)(n := n);
    ; #erase res
    cmp r10, 0
    je lab143
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab141
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab142

lab141:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab142:

lab143:
    ; lit x6 <- 1;
    mov r11, 1
    ; x7 <- iters - x6;
    mov r13, rdi
    sub r13, r11
    ; substitute (x7 := x7)(n := n)(a0 := a0);
    ; #move variables
    mov r8, rax
    mov rdi, r9
    mov r9, rdx
    mov rdx, r13
    ; jump main_loop_
    jmp main_loop_

lab140:
    ; then branch
    ; substitute (a0 := a0)(res := res);
    ; #move variables
    mov rsi, r10
    mov rdi, r11
    ; switch res \{ ... \};
    lea rcx, [rel Bool_144]
    add rcx, rdi
    jmp rcx

Bool_144:
    jmp near Bool_144_True
    jmp near Bool_144_False

Bool_144_True:
    ; lit x4 <- 1;
    mov rdi, 1
    ; println_i64 x4;
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
    ; lit x8 <- 0;
    mov rdi, 0
    ; substitute (x8 := x8)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

Bool_144_False:
    ; lit x5 <- 0;
    mov rdi, 0
    ; println_i64 x5;
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
    ; lit x9 <- 0;
    mov rdi, 0
    ; substitute (x9 := x9)(a0 := a0);
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