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
    ; if i < 0 \{ ... \}
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
    je lab9
    ; else branch
    ; lit x0 <- 1;
    mov r9, 1
    ; x1 <- i - x0;
    mov r11, rdx
    sub r11, r9
    ; substitute (x1 := x1)(a0 := a0)(a00 := a0);
    ; #share a0
    cmp rsi, 0
    je lab10
    ; ####increment refcount
    add qword [rsi + 0], 1

lab10:
    ; #move variables
    mov r8, rsi
    mov r9, rdi
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
    ; if i == 0 \{ ... \}
    cmp rdx, 0
    je lab11
    ; else branch
    ; substitute (i := i)(k := k);
    ; #erase a0
    cmp r8, 0
    je lab14
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab12
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab13

lab12:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab13:

lab14:
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

lab11:
    ; then branch
    ; substitute (k := k);
    ; #erase a0
    cmp r8, 0
    je lab17
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab15
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab16

lab15:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab16:

lab17:
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
    je lab29
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab30

lab29:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab27
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab20
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab18
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab19

lab18:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab19:

lab20:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab23
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab21
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab22

lab21:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab22:

lab23:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab28

lab27:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab28:

lab30:
    ; #load tag
    lea rdi, [rel _Cont_31]
    ; jump abs_i_
    jmp abs_i_

_Cont_31:

_Cont_31_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab33
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab32
    ; ####increment refcount
    add qword [rsi + 0], 1

lab32:
    jmp lab34

lab33:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab34:
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
    je lab46
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab47

lab46:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab44
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab37
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab35
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab36

lab35:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab36:

lab37:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab40
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab38
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab39

lab38:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab39:

lab40:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab43
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab41
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab42

lab41:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab42:

lab43:
    jmp lab45

lab44:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab45:

lab47:
    ; #load tag
    lea rdi, [rel _Cont_48]
    ; jump abs_i_
    jmp abs_i_

_Cont_48:

_Cont_48_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab50
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab49
    ; ####increment refcount
    add qword [rsi + 0], 1

lab49:
    jmp lab51

lab50:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab51:
    ; substitute (x0 := x0)(a0 := a0)(a00 := a0);
    ; #share a0
    cmp rsi, 0
    je lab52
    ; ####increment refcount
    add qword [rsi + 0], 1

lab52:
    ; #move variables
    mov r8, rsi
    mov r9, rdi
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
    je lab64
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab65

lab64:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab62
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab55
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab53
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab54

lab53:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab54:

lab55:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab58
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab56
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab57

lab56:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab57:

lab58:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab61
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab59
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab60

lab59:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab60:

lab61:
    jmp lab63

lab62:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab63:

lab65:
    ; #load tag
    lea rdi, [rel Bool_66]
    ; jump even_
    jmp even_

Bool_66:
    jmp near Bool_66_True
    jmp near Bool_66_False

Bool_66_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab68
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab67
    ; ####increment refcount
    add qword [rsi + 0], 1

lab67:
    mov rdx, [rax + 24]
    jmp lab69

lab68:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]

lab69:
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

Bool_66_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab71
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab70
    ; ####increment refcount
    add qword [rsi + 0], 1

lab70:
    mov rdx, [rax + 24]
    jmp lab72

lab71:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]

lab72:
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
    je lab84
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab85

lab84:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab82
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab75
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab73
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab74

lab73:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab74:

lab75:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab78
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab76
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab77

lab76:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab77:

lab78:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab81
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab79
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab80

lab79:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab80:

lab81:
    jmp lab83

lab82:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab83:

lab85:
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
    je lab97
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab98

lab97:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab95
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab91
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab89
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab90

lab89:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab90:

lab91:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab96

lab95:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab96:

lab98:
    ; #load tag
    lea rdi, [rel Bool_99]
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
    je lab111
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab112

lab111:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab109
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab102
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab100
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab101

lab100:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab101:

lab102:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab105
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab103
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab104

lab103:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab104:

lab105:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab108
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab106
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab107

lab106:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab107:

lab108:
    jmp lab110

lab109:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab110:

lab112:
    ; #load tag
    lea rdi, [rel Bool_113]
    ; jump odd_
    jmp odd_

Bool_113:
    jmp near Bool_113_True
    jmp near Bool_113_False

Bool_113_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab115
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab114
    ; ####increment refcount
    add qword [rax + 0], 1

lab114:
    jmp lab116

lab115:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab116:
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

Bool_113_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab118
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab117
    ; ####increment refcount
    add qword [rax + 0], 1

lab117:
    jmp lab119

lab118:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab119:
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

Bool_99:
    jmp near Bool_99_True
    jmp near Bool_99_False

Bool_99_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab122
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
    je lab120
    ; ####increment refcount
    add qword [r10 + 0], 1

lab120:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab121
    ; ####increment refcount
    add qword [r8 + 0], 1

lab121:
    mov rdi, [rsi + 24]
    jmp lab123

lab122:
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

lab123:
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

Bool_99_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab126
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
    je lab124
    ; ####increment refcount
    add qword [r10 + 0], 1

lab124:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab125
    ; ####increment refcount
    add qword [r8 + 0], 1

lab125:
    mov rdi, [rsi + 24]
    jmp lab127

lab126:
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

lab127:
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
    je lab139
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab140

lab139:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab137
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab130
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab128
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab129

lab128:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab129:

lab130:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab133
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab131
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab132

lab131:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab132:

lab133:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab136
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab134
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab135

lab134:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab135:

lab136:
    jmp lab138

lab137:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab138:

lab140:
    ; #load tag
    lea r9, [rel Bool_141]
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

Bool_141:
    jmp near Bool_141_True
    jmp near Bool_141_False

Bool_141_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab143
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab142
    ; ####increment refcount
    add qword [r8 + 0], 1

lab142:
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    jmp lab144

lab143:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]

lab144:
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

Bool_141_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab146
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab145
    ; ####increment refcount
    add qword [r8 + 0], 1

lab145:
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    jmp lab147

lab146:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]

lab147:
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
    je lab148
    ; else branch
    ; substitute (a0 := a0)(iters := iters)(n := n);
    ; #erase res
    cmp r10, 0
    je lab151
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab149
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab150

lab149:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab150:

lab151:
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

lab148:
    ; then branch
    ; substitute (a0 := a0)(res := res);
    ; #move variables
    mov rsi, r10
    mov rdi, r11
    ; switch res \{ ... \};
    lea rcx, [rel Bool_152]
    add rcx, rdi
    jmp rcx

Bool_152:
    jmp near Bool_152_True
    jmp near Bool_152_False

Bool_152_True:
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

Bool_152_False:
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