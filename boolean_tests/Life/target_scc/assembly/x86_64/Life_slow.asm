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
    ; create x1: Fun[i64, Unit] = ()\{ ... \};
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    lea r9, [rel Fun_i64_Unit_1]
    ; substitute (iters0 := iters)(steps0 := steps)(x1 := x1)(iters := iters)(steps := steps);
    ; #move variables
    mov r11, rdx
    mov r13, rdi
    ; create a2: _Cont = (iters, steps)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab13
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab14

lab13:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab11
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab4
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3

lab2:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3:

lab4:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab7
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab5
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab6

lab5:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab6:

lab7:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab10
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab8
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab9

lab8:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab9:

lab10:
    jmp lab12

lab11:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab12:

lab14:
    ; #load tag
    lea r11, [rel _Cont_15]
    ; jump go_loop_
    jmp go_loop_

_Cont_15:

_Cont_15_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab16
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    jmp lab17

lab16:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]

lab17:
    ; print_i64 gun_res;
    ; #save caller-save registers
    mov r12, rdx
    mov r13, rdi
    mov r14, r9
    sub rsp, 8
    ; #move argument into place
    mov rdi, rdx
    call print_i64
    ; #restore caller-save registers
    mov rdx, r12
    mov rdi, r13
    mov r9, r14
    add rsp, 8
    ; substitute (steps := steps)(iters := iters);
    ; #move variables
    mov rdx, r9
    ; create x2: Fun[i64, Unit] = ()\{ ... \};
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    lea r9, [rel Fun_i64_Unit_18]
    ; create a3: _Cont = ()\{ ... \};
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    lea r11, [rel _Cont_19]
    ; substitute (iters := iters)(steps := steps)(x2 := x2)(a3 := a3);
    ; #move variables
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump go_loop_
    jmp go_loop_

_Cont_19:

_Cont_19_Ret:
    ; println_i64 shuttle_res;
    ; #save caller-save registers
    mov r12, rdx
    sub rsp, 8
    ; #move argument into place
    mov rdi, rdx
    call println_i64
    ; #restore caller-save registers
    mov rdx, r12
    add rsp, 8
    ; substitute ;
    ; lit x0 <- 0;
    mov rdx, 0
    ; exit x0
    mov rax, rdx
    jmp cleanup

Fun_i64_Unit_18:

Fun_i64_Unit_18_Apply:
    ; let a0: Fun[i64, Unit] = Apply(x4, a01);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdi
    mov [rbx + 48], rsi
    mov [rbx + 40], rdx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab31
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab32

lab31:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab29
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab22
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab20
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab21

lab20:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab21:

lab22:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab30

lab29:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab30:

lab32:
    ; #load tag
    mov rdx, 0
    ; jump go_shuttle_
    jmp go_shuttle_

Fun_i64_Unit_1:

Fun_i64_Unit_1_Apply:
    ; let a1: Fun[i64, Unit] = Apply(x3, a00);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdi
    mov [rbx + 48], rsi
    mov [rbx + 40], rdx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab44
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab45

lab44:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab42
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab41
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab39
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab40

lab39:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab40:

lab41:
    jmp lab43

lab42:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab43:

lab45:
    ; #load tag
    mov rdx, 0
    ; jump go_gun_
    jmp go_gun_

pair_eq_:
    ; substitute (a0 := a0)(p2 := p2)(p1 := p1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch p1 \{ ... \};
    ; #there is only one clause, so we can just fall through

Pair_i64_i64_46:

Pair_i64_i64_46_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab47
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r9, [r8 + 40]
    jmp lab48

lab47:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r9, [r8 + 40]

lab48:
    ; substitute (a0 := a0)(snd1 := snd1)(fst1 := fst1)(p2 := p2);
    ; #move variables
    mov r10, rsi
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; switch p2 \{ ... \};
    ; #there is only one clause, so we can just fall through

Pair_i64_i64_49:

Pair_i64_i64_49_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab50
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r11, [r10 + 40]
    jmp lab51

lab50:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r11, [r10 + 40]

lab51:
    ; if fst1 == fst2 \{ ... \}
    cmp r9, r11
    je lab52
    ; else branch
    ; substitute (a0 := a0);
    ; invoke a0 False
    add rdx, 5
    jmp rdx

lab52:
    ; then branch
    ; if snd1 == snd2 \{ ... \}
    cmp rdi, r13
    je lab53
    ; else branch
    ; substitute (a0 := a0);
    ; invoke a0 False
    add rdx, 5
    jmp rdx

lab53:
    ; then branch
    ; substitute (a0 := a0);
    ; invoke a0 True
    add rdx, 0
    jmp rdx

or_:
    ; substitute (a0 := a0)(b2 := b2)(b1 := b1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch b1 \{ ... \};
    lea rcx, [rel Bool_54]
    add rcx, r9
    jmp rcx

Bool_54:
    jmp near Bool_54_True
    jmp near Bool_54_False

Bool_54_True:
    ; substitute (a0 := a0);
    ; #erase b2
    cmp rsi, 0
    je lab57
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab55
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab56

lab55:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab56:

lab57:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_54_False:
    ; switch b2 \{ ... \};
    lea rcx, [rel Bool_58]
    add rcx, rdi
    jmp rcx

Bool_58:
    jmp near Bool_58_True
    jmp near Bool_58_False

Bool_58_True:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_58_False:
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
    lea rcx, [rel Bool_59]
    add rcx, rdi
    jmp rcx

Bool_59:
    jmp near Bool_59_True
    jmp near Bool_59_False

Bool_59_True:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Bool_59_False:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

fold_:
    ; substitute (a := a)(a0 := a0)(f := f)(xs := xs);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; switch xs \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_60]
    add rcx, r11
    jmp rcx

List_Pair_i64_i64_60:
    jmp near List_Pair_i64_i64_60_Nil
    jmp near List_Pair_i64_i64_60_Cons

List_Pair_i64_i64_60_Nil:
    ; substitute (a0 := a0)(a := a);
    ; #erase f
    cmp r8, 0
    je lab63
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab61
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab62

lab61:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab62:

lab63:
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch a \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_64]
    add rcx, rdi
    jmp rcx

List_Pair_i64_i64_64:
    jmp near List_Pair_i64_i64_64_Nil
    jmp near List_Pair_i64_i64_64_Cons

List_Pair_i64_i64_64_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_64_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab67
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab65
    ; ####increment refcount
    add qword [r8 + 0], 1

lab65:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab66
    ; ####increment refcount
    add qword [rsi + 0], 1

lab66:
    jmp lab68

lab67:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab68:
    ; substitute (x1 := x1)(xs0 := xs0)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

List_Pair_i64_i64_60_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab71
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab69
    ; ####increment refcount
    add qword [r12 + 0], 1

lab69:
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]
    cmp r10, 0
    je lab70
    ; ####increment refcount
    add qword [r10 + 0], 1

lab70:
    jmp lab72

lab71:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]

lab72:
    ; substitute (a := a)(b := b)(f0 := f)(f := f)(x := x)(a0 := a0);
    ; #share f
    cmp r8, 0
    je lab73
    ; ####increment refcount
    add qword [r8 + 0], 1

lab73:
    ; #move variables
    mov r14, rsi
    mov r15, rdi
    mov rsi, r10
    mov r10, r8
    mov rdi, r11
    mov r11, r9
    ; create a1: List[Pair[i64, i64]] = (f, x, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    mov [rbx + 24], r11
    mov [rbx + 16], r10
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab85
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab86

lab85:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab83
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab76
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab74
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab75

lab74:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab75:

lab76:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab79
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab77
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab78

lab77:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab78:

lab79:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab84

lab83:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab84:

lab86:
    ; #load tag
    lea r11, [rel List_Pair_i64_i64_87]
    ; substitute (a := a)(b := b)(a1 := a1)(f0 := f0);
    ; #move variables
    mov rcx, r10
    mov r10, r8
    mov r8, rcx
    mov rcx, r11
    mov r11, r9
    mov r9, rcx
    ; invoke f0 Apply2
    ; #there is only one clause, so we can jump there directly
    jmp r11

List_Pair_i64_i64_87:
    jmp near List_Pair_i64_i64_87_Nil
    jmp near List_Pair_i64_i64_87_Cons

List_Pair_i64_i64_87_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab91
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab88
    ; ####increment refcount
    add qword [r8 + 0], 1

lab88:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab89
    ; ####increment refcount
    add qword [rsi + 0], 1

lab89:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab90
    ; ####increment refcount
    add qword [rax + 0], 1

lab90:
    jmp lab92

lab91:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab92:
    ; let x0: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (x0 := x0)(x := x)(f := f)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump fold_
    jmp fold_

List_Pair_i64_i64_87_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab96
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab93
    ; ####increment refcount
    add qword [r12 + 0], 1

lab93:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab94
    ; ####increment refcount
    add qword [r10 + 0], 1

lab94:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab95
    ; ####increment refcount
    add qword [r8 + 0], 1

lab95:
    jmp lab97

lab96:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]

lab97:
    ; substitute (a0 := a0)(x := x)(f := f)(x2 := x2)(xs1 := xs1);
    ; #move variables
    mov rcx, r12
    mov r12, rsi
    mov rsi, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r13
    mov r13, rdi
    mov rdi, r11
    mov r11, rdx
    mov rdx, rcx
    ; let x0: List[Pair[i64, i64]] = Cons(x2, xs1);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab109
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab110

lab109:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab107
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab103
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab101
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab102

lab101:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab102:

lab103:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab106
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab104
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab105

lab104:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab105:

lab106:
    jmp lab108

lab107:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab108:

lab110:
    ; #load tag
    mov r11, 5
    ; substitute (x0 := x0)(x := x)(f := f)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; jump fold_
    jmp fold_

accumulate_:
    ; jump fold_
    jmp fold_

revonto_:
    ; create x0: Fun2[List[Pair[i64, i64]], Pair[i64, i64], List[Pair[i64, i64]]] = ()\{ ... \};
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    lea r11, [rel Fun2_List_Pair_i64_i64_Pair_i64_i64_List_Pair_i64_i64_111]
    ; substitute (x := x)(y := y)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, r8
    mov r8, rcx
    mov rcx, r11
    mov r11, r9
    mov r9, rcx
    ; jump accumulate_
    jmp accumulate_

Fun2_List_Pair_i64_i64_Pair_i64_i64_List_Pair_i64_i64_111:

Fun2_List_Pair_i64_i64_Pair_i64_i64_List_Pair_i64_i64_111_Apply2:
    ; substitute (h := h)(t := t)(a1 := a1);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a1 Cons
    add r9, 5
    jmp r9

collect_accum_:
    ; substitute (sofar := sofar)(a0 := a0)(f := f)(xs := xs);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; switch xs \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_112]
    add rcx, r11
    jmp rcx

List_Pair_i64_i64_112:
    jmp near List_Pair_i64_i64_112_Nil
    jmp near List_Pair_i64_i64_112_Cons

List_Pair_i64_i64_112_Nil:
    ; substitute (a0 := a0)(sofar := sofar);
    ; #erase f
    cmp r8, 0
    je lab115
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab113
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab114

lab113:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab114:

lab115:
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch sofar \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_116]
    add rcx, rdi
    jmp rcx

List_Pair_i64_i64_116:
    jmp near List_Pair_i64_i64_116_Nil
    jmp near List_Pair_i64_i64_116_Cons

List_Pair_i64_i64_116_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_116_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab119
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab117
    ; ####increment refcount
    add qword [r8 + 0], 1

lab117:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab118
    ; ####increment refcount
    add qword [rsi + 0], 1

lab118:
    jmp lab120

lab119:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab120:
    ; substitute (x2 := x2)(xs1 := xs1)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

List_Pair_i64_i64_112_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab123
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab121
    ; ####increment refcount
    add qword [r12 + 0], 1

lab121:
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]
    cmp r10, 0
    je lab122
    ; ####increment refcount
    add qword [r10 + 0], 1

lab122:
    jmp lab124

lab123:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]

lab124:
    ; substitute (sofar := sofar)(p := p)(f0 := f)(f := f)(xs0 := xs0)(a0 := a0);
    ; #share f
    cmp r8, 0
    je lab125
    ; ####increment refcount
    add qword [r8 + 0], 1

lab125:
    ; #move variables
    mov r14, rsi
    mov r15, rdi
    mov rsi, r10
    mov r10, r8
    mov rdi, r11
    mov r11, r9
    ; create a1: List[Pair[i64, i64]] = (f, xs0, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    mov [rbx + 24], r11
    mov [rbx + 16], r10
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab137
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab138

lab137:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab135
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab131
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab129
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab130

lab129:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab130:

lab131:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab134
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab132
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab133

lab132:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab133:

lab134:
    jmp lab136

lab135:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab136:

lab138:
    ; #load tag
    lea r11, [rel List_Pair_i64_i64_139]
    ; substitute (f0 := f0)(p := p)(sofar := sofar)(a1 := a1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a2: List[Pair[i64, i64]] = (sofar, a1)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab151
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab152

lab151:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab149
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab142
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab140
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab141

lab140:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab141:

lab142:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab145
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab143
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab144

lab143:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab144:

lab145:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab148
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab146
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab147

lab146:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab147:

lab148:
    jmp lab150

lab149:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab150:

lab152:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_153]
    ; substitute (p := p)(a2 := a2)(f0 := f0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke f0 Apply
    ; #there is only one clause, so we can jump there directly
    jmp r9

List_Pair_i64_i64_153:
    jmp near List_Pair_i64_i64_153_Nil
    jmp near List_Pair_i64_i64_153_Cons

List_Pair_i64_i64_153_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab156
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab154
    ; ####increment refcount
    add qword [rsi + 0], 1

lab154:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab155
    ; ####increment refcount
    add qword [rax + 0], 1

lab155:
    jmp lab157

lab156:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab157:
    ; let x1: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (sofar := sofar)(x1 := x1)(a1 := a1);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump revonto_
    jmp revonto_

List_Pair_i64_i64_153_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab160
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab158
    ; ####increment refcount
    add qword [r10 + 0], 1

lab158:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab159
    ; ####increment refcount
    add qword [r8 + 0], 1

lab159:
    jmp lab161

lab160:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab161:
    ; substitute (a1 := a1)(sofar := sofar)(x4 := x4)(xs3 := xs3);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; let x1: List[Pair[i64, i64]] = Cons(x4, xs3);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab173
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab174

lab173:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab171
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab164
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab162
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab163

lab162:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab163:

lab164:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab167
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab165
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab166

lab165:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab166:

lab167:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab170
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab168
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab169

lab168:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab169:

lab170:
    jmp lab172

lab171:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab172:

lab174:
    ; #load tag
    mov r9, 5
    ; substitute (sofar := sofar)(x1 := x1)(a1 := a1);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump revonto_
    jmp revonto_

List_Pair_i64_i64_139:
    jmp near List_Pair_i64_i64_139_Nil
    jmp near List_Pair_i64_i64_139_Cons

List_Pair_i64_i64_139_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab178
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab175
    ; ####increment refcount
    add qword [r8 + 0], 1

lab175:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab176
    ; ####increment refcount
    add qword [rsi + 0], 1

lab176:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab177
    ; ####increment refcount
    add qword [rax + 0], 1

lab177:
    jmp lab179

lab178:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab179:
    ; let x0: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (x0 := x0)(xs0 := xs0)(f := f)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump collect_accum_
    jmp collect_accum_

List_Pair_i64_i64_139_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab183
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab180
    ; ####increment refcount
    add qword [r12 + 0], 1

lab180:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab181
    ; ####increment refcount
    add qword [r10 + 0], 1

lab181:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab182
    ; ####increment refcount
    add qword [r8 + 0], 1

lab182:
    jmp lab184

lab183:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]

lab184:
    ; substitute (a0 := a0)(xs0 := xs0)(f := f)(x3 := x3)(xs2 := xs2);
    ; #move variables
    mov rcx, r12
    mov r12, rsi
    mov rsi, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r13
    mov r13, rdi
    mov rdi, r11
    mov r11, rdx
    mov rdx, rcx
    ; let x0: List[Pair[i64, i64]] = Cons(x3, xs2);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab196
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab197

lab196:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab194
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab187
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab185
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab186

lab185:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab186:

lab187:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab190
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab188
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab189

lab188:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab189:

lab190:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab193
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab191
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab192

lab191:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab192:

lab193:
    jmp lab195

lab194:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab195:

lab197:
    ; #load tag
    mov r11, 5
    ; substitute (x0 := x0)(xs0 := xs0)(f := f)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; jump collect_accum_
    jmp collect_accum_

collect_:
    ; let x0: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (x0 := x0)(l := l)(f := f)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump collect_accum_
    jmp collect_accum_

exists_:
    ; substitute (a0 := a0)(f := f)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_198]
    add rcx, r9
    jmp rcx

List_Pair_i64_i64_198:
    jmp near List_Pair_i64_i64_198_Nil
    jmp near List_Pair_i64_i64_198_Cons

List_Pair_i64_i64_198_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab201
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab199
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab200

lab199:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab200:

lab201:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

List_Pair_i64_i64_198_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab204
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab202
    ; ####increment refcount
    add qword [r10 + 0], 1

lab202:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab203
    ; ####increment refcount
    add qword [r8 + 0], 1

lab203:
    jmp lab205

lab204:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab205:
    ; substitute (p := p)(f0 := f)(f := f)(ps := ps)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab206
    ; ####increment refcount
    add qword [rsi + 0], 1

lab206:
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov rax, r8
    mov r8, rsi
    mov rdx, r9
    mov r9, rdi
    ; create a1: Bool = (f, ps, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    mov [rbx + 24], r9
    mov [rbx + 16], r8
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab218
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab219

lab218:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab216
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab209
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab207
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab208

lab207:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab208:

lab209:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab212
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab210
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab211

lab210:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab211:

lab212:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab215
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab213
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab214

lab213:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab214:

lab215:
    jmp lab217

lab216:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab217:

lab219:
    ; #load tag
    lea r9, [rel Bool_220]
    ; substitute (p := p)(a1 := a1)(f0 := f0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; invoke f0 Apply
    ; #there is only one clause, so we can jump there directly
    jmp r9

Bool_220:
    jmp near Bool_220_True
    jmp near Bool_220_False

Bool_220_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab224
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab221
    ; ####increment refcount
    add qword [r8 + 0], 1

lab221:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab222
    ; ####increment refcount
    add qword [rsi + 0], 1

lab222:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab223
    ; ####increment refcount
    add qword [rax + 0], 1

lab223:
    jmp lab225

lab224:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab225:
    ; let x0: Bool = True();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(f := f)(ps := ps)(x0 := x0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump lift_exists_0_
    jmp lift_exists_0_

Bool_220_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab229
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab226
    ; ####increment refcount
    add qword [r8 + 0], 1

lab226:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab227
    ; ####increment refcount
    add qword [rsi + 0], 1

lab227:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab228
    ; ####increment refcount
    add qword [rax + 0], 1

lab228:
    jmp lab230

lab229:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab230:
    ; let x0: Bool = False();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(f := f)(ps := ps)(x0 := x0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump lift_exists_0_
    jmp lift_exists_0_

lift_exists_0_:
    ; substitute (ps := ps)(f := f)(a0 := a0)(x0 := x0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a2: Bool = (a0, x0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab242
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab243

lab242:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab240
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab233
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab231
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab232

lab231:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab232:

lab233:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab236
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab234
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab235

lab234:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab235:

lab236:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab239
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab237
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab238

lab237:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab238:

lab239:
    jmp lab241

lab240:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab241:

lab243:
    ; #load tag
    lea r9, [rel Bool_244]
    ; jump exists_
    jmp exists_

Bool_244:
    jmp near Bool_244_True
    jmp near Bool_244_False

Bool_244_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab247
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab245
    ; ####increment refcount
    add qword [rsi + 0], 1

lab245:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab246
    ; ####increment refcount
    add qword [rax + 0], 1

lab246:
    jmp lab248

lab247:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab248:
    ; let x1: Bool = True();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x0 := x0)(x1 := x1)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump or_
    jmp or_

Bool_244_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab251
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab249
    ; ####increment refcount
    add qword [rsi + 0], 1

lab249:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab250
    ; ####increment refcount
    add qword [rax + 0], 1

lab250:
    jmp lab252

lab251:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab252:
    ; let x1: Bool = False();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (x0 := x0)(x1 := x1)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump or_
    jmp or_

append_:
    ; substitute (a0 := a0)(l2 := l2)(l1 := l1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l1 \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_253]
    add rcx, r9
    jmp rcx

List_Pair_i64_i64_253:
    jmp near List_Pair_i64_i64_253_Nil
    jmp near List_Pair_i64_i64_253_Cons

List_Pair_i64_i64_253_Nil:
    ; switch l2 \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_254]
    add rcx, rdi
    jmp rcx

List_Pair_i64_i64_254:
    jmp near List_Pair_i64_i64_254_Nil
    jmp near List_Pair_i64_i64_254_Cons

List_Pair_i64_i64_254_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_254_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab257
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab255
    ; ####increment refcount
    add qword [r8 + 0], 1

lab255:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab256
    ; ####increment refcount
    add qword [rsi + 0], 1

lab256:
    jmp lab258

lab257:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab258:
    ; substitute (x1 := x1)(xs0 := xs0)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

List_Pair_i64_i64_253_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab261
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab259
    ; ####increment refcount
    add qword [r10 + 0], 1

lab259:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab260
    ; ####increment refcount
    add qword [r8 + 0], 1

lab260:
    jmp lab262

lab261:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab262:
    ; substitute (iss := iss)(l2 := l2)(is := is)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; create a1: List[Pair[i64, i64]] = (is, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab274
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab275

lab274:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab272
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab265
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab263
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab264

lab263:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab264:

lab265:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab268
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab266
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab267

lab266:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab267:

lab268:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab271
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab269
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab270

lab269:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab270:

lab271:
    jmp lab273

lab272:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab273:

lab275:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_276]
    ; jump append_
    jmp append_

List_Pair_i64_i64_276:
    jmp near List_Pair_i64_i64_276_Nil
    jmp near List_Pair_i64_i64_276_Cons

List_Pair_i64_i64_276_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab279
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab277
    ; ####increment refcount
    add qword [rsi + 0], 1

lab277:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab278
    ; ####increment refcount
    add qword [rax + 0], 1

lab278:
    jmp lab280

lab279:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab280:
    ; let x0: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (is := is)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

List_Pair_i64_i64_276_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab283
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab281
    ; ####increment refcount
    add qword [r10 + 0], 1

lab281:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab282
    ; ####increment refcount
    add qword [r8 + 0], 1

lab282:
    jmp lab284

lab283:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab284:
    ; substitute (a0 := a0)(is := is)(x2 := x2)(xs1 := xs1);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; let x0: List[Pair[i64, i64]] = Cons(x2, xs1);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab296
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab297

lab296:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab294
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab287
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab285
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab286

lab285:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab286:

lab287:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab290
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab288
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab289

lab288:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab289:

lab290:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab293
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab291
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab292

lab291:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab292:

lab293:
    jmp lab295

lab294:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab295:

lab297:
    ; #load tag
    mov r9, 5
    ; substitute (is := is)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

map_:
    ; substitute (a0 := a0)(f := f)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_298]
    add rcx, r9
    jmp rcx

List_Pair_i64_i64_298:
    jmp near List_Pair_i64_i64_298_Nil
    jmp near List_Pair_i64_i64_298_Cons

List_Pair_i64_i64_298_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab301
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab299
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab300

lab299:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab300:

lab301:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_298_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab304
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab302
    ; ####increment refcount
    add qword [r10 + 0], 1

lab302:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab303
    ; ####increment refcount
    add qword [r8 + 0], 1

lab303:
    jmp lab305

lab304:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab305:
    ; substitute (p := p)(f0 := f)(f := f)(ps := ps)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab306
    ; ####increment refcount
    add qword [rsi + 0], 1

lab306:
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov rax, r8
    mov r8, rsi
    mov rdx, r9
    mov r9, rdi
    ; create a1: Pair[i64, i64] = (f, ps, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    mov [rbx + 24], r9
    mov [rbx + 16], r8
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab318
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab319

lab318:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab316
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab309
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab307
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab308

lab307:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab308:

lab309:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab312
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab310
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab311

lab310:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab311:

lab312:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab315
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab313
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab314

lab313:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab314:

lab315:
    jmp lab317

lab316:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab317:

lab319:
    ; #load tag
    lea r9, [rel Pair_i64_i64_320]
    ; substitute (p := p)(a1 := a1)(f0 := f0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; invoke f0 Apply
    ; #there is only one clause, so we can jump there directly
    jmp r9

Pair_i64_i64_320:

Pair_i64_i64_320_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab324
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab321
    ; ####increment refcount
    add qword [r12 + 0], 1

lab321:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab322
    ; ####increment refcount
    add qword [r10 + 0], 1

lab322:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab323
    ; ####increment refcount
    add qword [r8 + 0], 1

lab323:
    jmp lab325

lab324:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]

lab325:
    ; substitute (a0 := a0)(ps := ps)(f := f)(fst0 := fst0)(snd0 := snd0);
    ; #move variables
    mov rcx, r13
    mov r13, rdi
    mov rdi, r11
    mov r11, rdx
    mov rdx, rcx
    mov rsi, r10
    mov rax, r12
    ; let x0: Pair[i64, i64] = Tup(fst0, snd0);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab337
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab338

lab337:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab335
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab328
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab326
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab327

lab326:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab327:

lab328:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab331
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab329
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab330

lab329:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab330:

lab331:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab334
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab332
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab333

lab332:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab333:

lab334:
    jmp lab336

lab335:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab336:

lab338:
    ; #load tag
    mov r11, 0
    ; substitute (f := f)(ps := ps)(a0 := a0)(x0 := x0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a2: List[Pair[i64, i64]] = (a0, x0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab350
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab351

lab350:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab348
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab341
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab339
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab340

lab339:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab340:

lab341:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab344
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab342
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab343

lab342:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab343:

lab344:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab347
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab345
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab346

lab345:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab346:

lab347:
    jmp lab349

lab348:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab349:

lab351:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_352]
    ; substitute (ps := ps)(f := f)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump map_
    jmp map_

List_Pair_i64_i64_352:
    jmp near List_Pair_i64_i64_352_Nil
    jmp near List_Pair_i64_i64_352_Cons

List_Pair_i64_i64_352_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab355
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab353
    ; ####increment refcount
    add qword [rsi + 0], 1

lab353:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab354
    ; ####increment refcount
    add qword [rax + 0], 1

lab354:
    jmp lab356

lab355:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab356:
    ; let x1: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x0 := x0)(x1 := x1)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

List_Pair_i64_i64_352_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab359
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab357
    ; ####increment refcount
    add qword [r10 + 0], 1

lab357:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab358
    ; ####increment refcount
    add qword [r8 + 0], 1

lab358:
    jmp lab360

lab359:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab360:
    ; substitute (x0 := x0)(a0 := a0)(x2 := x2)(xs0 := xs0);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; let x1: List[Pair[i64, i64]] = Cons(x2, xs0);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab372
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab373

lab372:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab370
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab363
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab361
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab362

lab361:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab362:

lab363:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab366
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab364
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab365

lab364:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab365:

lab366:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab369
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab367
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab368

lab367:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab368:

lab369:
    jmp lab371

lab370:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab371:

lab373:
    ; #load tag
    mov r9, 5
    ; substitute (x0 := x0)(x1 := x1)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

member_:
    ; substitute (l := l)(a0 := a0)(p := p);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create x0: Fun[Pair[i64, i64], Bool] = (p)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab385
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab386

lab385:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab383
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab376
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab374
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab375

lab374:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab375:

lab376:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab379
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab377
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab378

lab377:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab378:

lab379:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab382
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab380
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab381

lab380:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab381:

lab382:
    jmp lab384

lab383:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab384:

lab386:
    ; #load tag
    lea r9, [rel Fun_Pair_i64_i64_Bool_387]
    ; substitute (l := l)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump exists_
    jmp exists_

Fun_Pair_i64_i64_Bool_387:

Fun_Pair_i64_i64_Bool_387_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab389
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab388
    ; ####increment refcount
    add qword [r8 + 0], 1

lab388:
    jmp lab390

lab389:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab390:
    ; substitute (p := p)(p1 := p1)(a1 := a1);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump pair_eq_
    jmp pair_eq_

len_:
    ; substitute (a0 := a0)(l := l);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_391]
    add rcx, rdi
    jmp rcx

List_Pair_i64_i64_391:
    jmp near List_Pair_i64_i64_391_Nil
    jmp near List_Pair_i64_i64_391_Cons

List_Pair_i64_i64_391_Nil:
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

List_Pair_i64_i64_391_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab394
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab392
    ; ####increment refcount
    add qword [r8 + 0], 1

lab392:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab393
    ; ####increment refcount
    add qword [rsi + 0], 1

lab393:
    jmp lab395

lab394:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab395:
    ; substitute (a0 := a0)(ps := ps);
    ; #erase p
    cmp rsi, 0
    je lab398
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab396
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab397

lab396:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab397:

lab398:
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; lit x0 <- 1;
    mov r9, 1
    ; substitute (ps := ps)(a0 := a0)(x0 := x0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; create a1: _Cont = (a0, x0)\{ ... \};
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
    je lab410
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab411

lab410:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab408
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab401
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab399
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab400

lab399:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab400:

lab401:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab404
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab402
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab403

lab402:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab403:

lab404:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab407
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab405
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab406

lab405:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab406:

lab407:
    jmp lab409

lab408:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab409:

lab411:
    ; #load tag
    lea rdi, [rel _Cont_412]
    ; jump len_
    jmp len_

_Cont_412:

_Cont_412_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab414
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab413
    ; ####increment refcount
    add qword [rsi + 0], 1

lab413:
    jmp lab415

lab414:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab415:
    ; x3 <- x0 + x1;
    mov r11, r9
    add r11, rdx
    ; substitute (x3 := x3)(a0 := a0);
    ; #move variables
    mov rdx, r11
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

filter_:
    ; substitute (a0 := a0)(f := f)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_416]
    add rcx, r9
    jmp rcx

List_Pair_i64_i64_416:
    jmp near List_Pair_i64_i64_416_Nil
    jmp near List_Pair_i64_i64_416_Cons

List_Pair_i64_i64_416_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab419
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab417
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab418

lab417:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab418:

lab419:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_416_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab422
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab420
    ; ####increment refcount
    add qword [r10 + 0], 1

lab420:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab421
    ; ####increment refcount
    add qword [r8 + 0], 1

lab421:
    jmp lab423

lab422:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab423:
    ; substitute (p0 := p)(f0 := f)(p := p)(ps := ps)(a0 := a0)(f := f);
    ; #share f
    cmp rsi, 0
    je lab424
    ; ####increment refcount
    add qword [rsi + 0], 1

lab424:
    ; #share p
    cmp r8, 0
    je lab425
    ; ####increment refcount
    add qword [r8 + 0], 1

lab425:
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov r14, rsi
    mov r15, rdi
    mov rax, r8
    mov rdx, r9
    ; create a2: Bool = (p, ps, a0, f)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    mov [rbx + 24], r11
    mov [rbx + 16], r10
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab437
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab438

lab437:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab435
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab428
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab426
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab427

lab426:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab427:

lab428:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab431
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab429
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab430

lab429:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab430:

lab431:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab434
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab432
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab433

lab432:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab433:

lab434:
    jmp lab436

lab435:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab436:

lab438:
    ; ##store link to previous block
    mov [rbx + 48], r10
    ; ##store values
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab450
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab451

lab450:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab448
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab441
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab439
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab440

lab439:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab440:

lab441:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab444
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab442
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab443

lab442:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab443:

lab444:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab447
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab445
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab446

lab445:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab446:

lab447:
    jmp lab449

lab448:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab449:

lab451:
    ; #load tag
    lea r9, [rel Bool_452]
    ; substitute (p0 := p0)(a2 := a2)(f0 := f0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; invoke f0 Apply
    ; #there is only one clause, so we can jump there directly
    jmp r9

Bool_452:
    jmp near Bool_452_True
    jmp near Bool_452_False

Bool_452_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab457
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab453
    ; ####increment refcount
    add qword [rax + 0], 1

lab453:
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab454
    ; ####increment refcount
    add qword [r10 + 0], 1

lab454:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab455
    ; ####increment refcount
    add qword [r8 + 0], 1

lab455:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab456
    ; ####increment refcount
    add qword [rsi + 0], 1

lab456:
    jmp lab458

lab457:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]

lab458:
    ; substitute (f := f)(ps := ps)(a0 := a0)(p := p);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; create a1: List[Pair[i64, i64]] = (a0, p)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab470
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab471

lab470:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab468
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab461
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab459
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab460

lab459:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab460:

lab461:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab464
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab462
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab463

lab462:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab463:

lab464:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab467
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab465
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab466

lab465:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab466:

lab467:
    jmp lab469

lab468:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab469:

lab471:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_472]
    ; substitute (ps := ps)(f := f)(a1 := a1);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump filter_
    jmp filter_

List_Pair_i64_i64_472:
    jmp near List_Pair_i64_i64_472_Nil
    jmp near List_Pair_i64_i64_472_Cons

List_Pair_i64_i64_472_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab475
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab473
    ; ####increment refcount
    add qword [rsi + 0], 1

lab473:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab474
    ; ####increment refcount
    add qword [rax + 0], 1

lab474:
    jmp lab476

lab475:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab476:
    ; let x0: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (p := p)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

List_Pair_i64_i64_472_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab479
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab477
    ; ####increment refcount
    add qword [r10 + 0], 1

lab477:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab478
    ; ####increment refcount
    add qword [r8 + 0], 1

lab478:
    jmp lab480

lab479:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab480:
    ; substitute (p := p)(a0 := a0)(x1 := x1)(xs0 := xs0);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; let x0: List[Pair[i64, i64]] = Cons(x1, xs0);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab492
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab493

lab492:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab490
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab483
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab481
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab482

lab481:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab482:

lab483:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab486
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab484
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab485

lab484:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab485:

lab486:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab489
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab487
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab488

lab487:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab488:

lab489:
    jmp lab491

lab490:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab491:

lab493:
    ; #load tag
    mov r9, 5
    ; substitute (p := p)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

Bool_452_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab498
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab494
    ; ####increment refcount
    add qword [rax + 0], 1

lab494:
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab495
    ; ####increment refcount
    add qword [r10 + 0], 1

lab495:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab496
    ; ####increment refcount
    add qword [r8 + 0], 1

lab496:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab497
    ; ####increment refcount
    add qword [rsi + 0], 1

lab497:
    jmp lab499

lab498:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]

lab499:
    ; substitute (ps := ps)(f := f)(a0 := a0);
    ; #erase p
    cmp rax, 0
    je lab502
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab500
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab501

lab500:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab501:

lab502:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    mov rsi, r10
    mov rdi, r11
    ; jump filter_
    jmp filter_

diff_:
    ; substitute (x := x)(a0 := a0)(y := y);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create x0: Fun[Pair[i64, i64], Bool] = (y)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab514
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab515

lab514:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab512
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab505
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab503
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab504

lab503:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab504:

lab505:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab508
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab506
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab507

lab506:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab507:

lab508:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab511
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab509
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab510

lab509:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab510:

lab511:
    jmp lab513

lab512:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab513:

lab515:
    ; #load tag
    lea r9, [rel Fun_Pair_i64_i64_Bool_516]
    ; substitute (x := x)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump filter_
    jmp filter_

Fun_Pair_i64_i64_Bool_516:

Fun_Pair_i64_i64_Bool_516_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab518
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab517
    ; ####increment refcount
    add qword [r8 + 0], 1

lab517:
    jmp lab519

lab518:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab519:
    ; substitute (p := p)(y := y)(a1 := a1);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create a2: Bool = (a1)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab531
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab532

lab531:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab529
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab522
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab520
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab521

lab520:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab521:

lab522:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab525
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab523
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab524

lab523:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab524:

lab525:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab528
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab526
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab527

lab526:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab527:

lab528:
    jmp lab530

lab529:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab530:

lab532:
    ; #load tag
    lea r9, [rel Bool_533]
    ; substitute (y := y)(p := p)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump member_
    jmp member_

Bool_533:
    jmp near Bool_533_True
    jmp near Bool_533_False

Bool_533_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab535
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab534
    ; ####increment refcount
    add qword [rax + 0], 1

lab534:
    jmp lab536

lab535:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab536:
    ; let x1: Bool = True();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; substitute (x1 := x1)(a1 := a1);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

Bool_533_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab538
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab537
    ; ####increment refcount
    add qword [rax + 0], 1

lab537:
    jmp lab539

lab538:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab539:
    ; let x1: Bool = False();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 5
    ; substitute (x1 := x1)(a1 := a1);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

collect_neighbors_:
    ; substitute (xover := xover)(x3 := x3)(x2 := x2)(x1 := x1)(a0 := a0)(xs := xs);
    ; #move variables
    mov rcx, r14
    mov r14, r12
    mov r12, rcx
    mov rcx, r15
    mov r15, r13
    mov r13, rcx
    ; switch xs \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_540]
    add rcx, r15
    jmp rcx

List_Pair_i64_i64_540:
    jmp near List_Pair_i64_i64_540_Nil
    jmp near List_Pair_i64_i64_540_Cons

List_Pair_i64_i64_540_Nil:
    ; substitute (x3 := x3)(xover := xover)(a0 := a0);
    ; #erase x1
    cmp r10, 0
    je lab543
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab541
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab542

lab541:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab542:

lab543:
    ; #erase x2
    cmp r8, 0
    je lab546
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab544
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab545

lab544:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab545:

lab546:
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov r8, r12
    mov r9, r13
    ; jump diff_
    jmp diff_

List_Pair_i64_i64_540_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r14 + 0], 0
    je lab549
    ; ##either decrement refcount and share children...
    add qword [r14 + 0], -1
    ; ###load values
    mov rcx, [r14 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r14 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab547
    ; ####increment refcount
    add qword [rcx + 0], 1

lab547:
    mov r15, [r14 + 40]
    mov r14, [r14 + 32]
    cmp r14, 0
    je lab548
    ; ####increment refcount
    add qword [r14 + 0], 1

lab548:
    jmp lab550

lab549:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r14 + 0], rbx
    mov rbx, r14
    ; ###load values
    mov rcx, [r14 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r14 + 48]
    mov [rsp + 2032], rcx
    mov r15, [r14 + 40]
    mov r14, [r14 + 32]

lab550:
    ; substitute (xover0 := xover)(a8 := a)(x2 := x2)(x1 := x1)(a0 := a0)(a := a)(x := x)(xover := xover)(x3 := x3);
    ; #share a
    cmp r14, 0
    je lab551
    ; ####increment refcount
    add qword [r14 + 0], 1

lab551:
    ; #share xover
    cmp rax, 0
    je lab552
    ; ####increment refcount
    add qword [rax + 0], 1

lab552:
    ; #move variables
    mov [rsp + 2016], rax
    mov [rsp + 2008], rdx
    mov [rsp + 2000], rsi
    mov [rsp + 1992], rdi
    mov rsi, r14
    mov rdi, r15
    ; create a1: Bool = (x2, x1, a0, a, x, xover, x3)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2000]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 32], rcx
    mov rcx, [rsp + 2024]
    mov [rbx + 24], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 16], rcx
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab564
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab565

lab564:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab562
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab555
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab553
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab554

lab553:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab554:

lab555:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab558
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab556
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab557

lab556:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab557:

lab558:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab561
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab559
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab560

lab559:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab560:

lab561:
    jmp lab563

lab562:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab563:

lab565:
    ; ##store link to previous block
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    ; ##store values
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    mov [rbx + 24], r13
    mov [rbx + 16], r12
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab577
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab578

lab577:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab575
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab568
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab566
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab567

lab566:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab567:

lab568:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab571
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab569
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab570

lab569:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab570:

lab571:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab574
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab572
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab573

lab572:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab573:

lab574:
    jmp lab576

lab575:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab576:

lab578:
    ; ##store link to previous block
    mov [rbx + 48], r12
    ; ##store values
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    mov [rbx + 24], r9
    mov [rbx + 16], r8
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab590
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab591

lab590:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab588
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab581
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab579
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab580

lab579:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab580:

lab581:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab584
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab582
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab583

lab582:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab583:

lab584:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab587
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab585
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab586

lab585:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab586:

lab587:
    jmp lab589

lab588:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab589:

lab591:
    ; #load tag
    lea r9, [rel Bool_592]
    ; jump member_
    jmp member_

Bool_592:
    jmp near Bool_592_True
    jmp near Bool_592_False

Bool_592_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab600
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab593
    ; ####increment refcount
    add qword [rsi + 0], 1

lab593:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab594
    ; ####increment refcount
    add qword [rax + 0], 1

lab594:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab595
    ; ####increment refcount
    add qword [r10 + 0], 1

lab595:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab596
    ; ####increment refcount
    add qword [r8 + 0], 1

lab596:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab597
    ; ####increment refcount
    add qword [rcx + 0], 1

lab597:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab598
    ; ####increment refcount
    add qword [r14 + 0], 1

lab598:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab599
    ; ####increment refcount
    add qword [r12 + 0], 1

lab599:
    jmp lab601

lab600:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]

lab601:
    ; substitute (xover := xover)(x3 := x3)(x2 := x2)(x1 := x1)(x := x)(a0 := a0);
    ; #erase a
    cmp r10, 0
    je lab604
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab602
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab603

lab602:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab603:

lab604:
    ; #move variables
    mov rcx, r14
    mov r14, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r15
    mov r15, r9
    mov r9, rdx
    mov rdx, rcx
    mov r10, rsi
    mov r11, rdi
    mov rsi, [rsp + 2032]
    mov rdi, [rsp + 2024]
    ; jump collect_neighbors_
    jmp collect_neighbors_

Bool_592_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab612
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab605
    ; ####increment refcount
    add qword [rsi + 0], 1

lab605:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab606
    ; ####increment refcount
    add qword [rax + 0], 1

lab606:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab607
    ; ####increment refcount
    add qword [r10 + 0], 1

lab607:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab608
    ; ####increment refcount
    add qword [r8 + 0], 1

lab608:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab609
    ; ####increment refcount
    add qword [rcx + 0], 1

lab609:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab610
    ; ####increment refcount
    add qword [r14 + 0], 1

lab610:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab611
    ; ####increment refcount
    add qword [r12 + 0], 1

lab611:
    jmp lab613

lab612:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]

lab613:
    ; substitute (x30 := x3)(a7 := a)(a0 := a0)(a := a)(x := x)(xover := xover)(x3 := x3)(x2 := x2)(x1 := x1);
    ; #share a
    cmp r10, 0
    je lab614
    ; ####increment refcount
    add qword [r10 + 0], 1

lab614:
    ; #share x3
    cmp qword [rsp + 2032], 0
    je lab615
    ; ####increment refcount
    mov rcx, [rsp + 2032]
    add qword [rcx + 0], 1

lab615:
    ; #move variables
    mov [rsp + 2016], rax
    mov [rsp + 2008], rdx
    mov [rsp + 2000], rsi
    mov [rsp + 1992], rdi
    mov rsi, r10
    mov rdi, r11
    mov rax, [rsp + 2032]
    mov rdx, [rsp + 2024]
    ; create a2: Bool = (a0, a, x, xover, x3, x2, x1)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2000]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 32], rcx
    mov rcx, [rsp + 2024]
    mov [rbx + 24], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 16], rcx
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab627
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab628

lab627:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab625
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab618
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab616
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab617

lab616:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab617:

lab618:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab621
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab619
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab620

lab619:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab620:

lab621:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab624
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab622
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab623

lab622:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab623:

lab624:
    jmp lab626

lab625:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab626:

lab628:
    ; ##store link to previous block
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    ; ##store values
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    mov [rbx + 24], r13
    mov [rbx + 16], r12
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab640
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab641

lab640:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab638
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab631
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab629
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab630

lab629:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab630:

lab631:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab634
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab632
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab633

lab632:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab633:

lab634:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab637
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab635
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab636

lab635:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab636:

lab637:
    jmp lab639

lab638:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab639:

lab641:
    ; ##store link to previous block
    mov [rbx + 48], r12
    ; ##store values
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    mov [rbx + 24], r9
    mov [rbx + 16], r8
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab653
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab654

lab653:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab651
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab644
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab642
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab643

lab642:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab643:

lab644:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab647
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab645
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab646

lab645:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab646:

lab647:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab650
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab648
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab649

lab648:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab649:

lab650:
    jmp lab652

lab651:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab652:

lab654:
    ; #load tag
    lea r9, [rel Bool_655]
    ; jump member_
    jmp member_

Bool_655:
    jmp near Bool_655_True
    jmp near Bool_655_False

Bool_655_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab663
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab656
    ; ####increment refcount
    add qword [rsi + 0], 1

lab656:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab657
    ; ####increment refcount
    add qword [rax + 0], 1

lab657:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab658
    ; ####increment refcount
    add qword [r10 + 0], 1

lab658:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab659
    ; ####increment refcount
    add qword [r8 + 0], 1

lab659:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab660
    ; ####increment refcount
    add qword [rcx + 0], 1

lab660:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab661
    ; ####increment refcount
    add qword [r14 + 0], 1

lab661:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab662
    ; ####increment refcount
    add qword [r12 + 0], 1

lab662:
    jmp lab664

lab663:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]

lab664:
    ; substitute (a0 := a0)(x1 := x1)(x := x)(x2 := x2)(x3 := x3)(a := a)(xover := xover);
    ; #move variables
    mov rcx, [rsp + 2032]
    mov [rsp + 2032], r10
    mov r10, r14
    mov r14, rsi
    mov rsi, rcx
    mov rcx, [rsp + 2024]
    mov [rsp + 2024], r11
    mov r11, r15
    mov r15, rdi
    mov rdi, rcx
    ; let x0: List[Pair[i64, i64]] = Cons(a, xover);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab676
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab677

lab676:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab674
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab667
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab665
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab666

lab665:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab666:

lab667:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab670
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab668
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab669

lab668:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab669:

lab670:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab673
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab671
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab672

lab671:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab672:

lab673:
    jmp lab675

lab674:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab675:

lab677:
    ; #load tag
    mov r15, 5
    ; substitute (x0 := x0)(x3 := x3)(x2 := x2)(x1 := x1)(x := x)(a0 := a0);
    ; #move variables
    mov rcx, r14
    mov r14, rax
    mov rax, rcx
    mov rcx, r15
    mov r15, rdx
    mov rdx, rcx
    mov rcx, r12
    mov r12, r8
    mov r8, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r13
    mov r13, r9
    mov r9, r11
    mov r11, rdi
    mov rdi, rcx
    ; jump collect_neighbors_
    jmp collect_neighbors_

Bool_655_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab685
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab678
    ; ####increment refcount
    add qword [rsi + 0], 1

lab678:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab679
    ; ####increment refcount
    add qword [rax + 0], 1

lab679:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab680
    ; ####increment refcount
    add qword [r10 + 0], 1

lab680:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab681
    ; ####increment refcount
    add qword [r8 + 0], 1

lab681:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab682
    ; ####increment refcount
    add qword [rcx + 0], 1

lab682:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab683
    ; ####increment refcount
    add qword [r14 + 0], 1

lab683:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab684
    ; ####increment refcount
    add qword [r12 + 0], 1

lab684:
    jmp lab686

lab685:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]

lab686:
    ; substitute (x20 := x2)(a6 := a)(x := x)(xover := xover)(x3 := x3)(x2 := x2)(x1 := x1)(a0 := a0)(a := a);
    ; #share a
    cmp rsi, 0
    je lab687
    ; ####increment refcount
    add qword [rsi + 0], 1

lab687:
    ; #share x2
    cmp r14, 0
    je lab688
    ; ####increment refcount
    add qword [r14 + 0], 1

lab688:
    ; #move variables
    mov [rsp + 2016], rax
    mov [rsp + 2008], rdx
    mov [rsp + 2000], rsi
    mov [rsp + 1992], rdi
    mov rax, r14
    mov rdx, r15
    ; create a3: Bool = (x, xover, x3, x2, x1, a0, a)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2000]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 32], rcx
    mov rcx, [rsp + 2024]
    mov [rbx + 24], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 16], rcx
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab700
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab701

lab700:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab698
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab691
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab689
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab690

lab689:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab690:

lab691:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab694
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab692
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab693

lab692:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab693:

lab694:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab697
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab695
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab696

lab695:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab696:

lab697:
    jmp lab699

lab698:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab699:

lab701:
    ; ##store link to previous block
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    ; ##store values
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    mov [rbx + 24], r13
    mov [rbx + 16], r12
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab713
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab714

lab713:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab711
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab704
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab702
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab703

lab702:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab703:

lab704:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab707
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab705
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab706

lab705:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab706:

lab707:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab710
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab708
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab709

lab708:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab709:

lab710:
    jmp lab712

lab711:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab712:

lab714:
    ; ##store link to previous block
    mov [rbx + 48], r12
    ; ##store values
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    mov [rbx + 24], r9
    mov [rbx + 16], r8
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab726
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab727

lab726:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab724
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab717
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab715
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab716

lab715:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab716:

lab717:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab720
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab718
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab719

lab718:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab719:

lab720:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab723
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab721
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab722

lab721:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab722:

lab723:
    jmp lab725

lab724:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab725:

lab727:
    ; #load tag
    lea r9, [rel Bool_728]
    ; jump member_
    jmp member_

Bool_728:
    jmp near Bool_728_True
    jmp near Bool_728_False

Bool_728_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab736
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab729
    ; ####increment refcount
    add qword [rsi + 0], 1

lab729:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab730
    ; ####increment refcount
    add qword [rax + 0], 1

lab730:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab731
    ; ####increment refcount
    add qword [r10 + 0], 1

lab731:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab732
    ; ####increment refcount
    add qword [r8 + 0], 1

lab732:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab733
    ; ####increment refcount
    add qword [rcx + 0], 1

lab733:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab734
    ; ####increment refcount
    add qword [r14 + 0], 1

lab734:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab735
    ; ####increment refcount
    add qword [r12 + 0], 1

lab735:
    jmp lab737

lab736:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]

lab737:
    ; substitute (x := x)(xover := xover)(a0 := a0)(x2 := x2)(x1 := x1)(a := a)(x3 := x3);
    ; #move variables
    mov rcx, r14
    mov r14, [rsp + 2032]
    mov [rsp + 2032], r8
    mov r8, rcx
    mov rcx, r15
    mov r15, [rsp + 2024]
    mov [rsp + 2024], r9
    mov r9, rcx
    ; let x4: List[Pair[i64, i64]] = Cons(a, x3);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab749
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab750

lab749:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab747
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab740
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab738
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab739

lab738:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab739:

lab740:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab743
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab741
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab742

lab741:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab742:

lab743:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab746
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab744
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab745

lab744:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab745:

lab746:
    jmp lab748

lab747:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab748:

lab750:
    ; #load tag
    mov r15, 5
    ; substitute (xover := xover)(x4 := x4)(x2 := x2)(x1 := x1)(x := x)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r14
    mov r14, r8
    mov r8, r10
    mov r10, r12
    mov r12, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r15
    mov r15, r9
    mov r9, r11
    mov r11, r13
    mov r13, rdx
    mov rdx, rcx
    ; jump collect_neighbors_
    jmp collect_neighbors_

Bool_728_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab758
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab751
    ; ####increment refcount
    add qword [rsi + 0], 1

lab751:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab752
    ; ####increment refcount
    add qword [rax + 0], 1

lab752:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab753
    ; ####increment refcount
    add qword [r10 + 0], 1

lab753:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab754
    ; ####increment refcount
    add qword [r8 + 0], 1

lab754:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab755
    ; ####increment refcount
    add qword [rcx + 0], 1

lab755:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab756
    ; ####increment refcount
    add qword [r14 + 0], 1

lab756:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab757
    ; ####increment refcount
    add qword [r12 + 0], 1

lab757:
    jmp lab759

lab758:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]

lab759:
    ; substitute (a5 := a)(x10 := x1)(x3 := x3)(x2 := x2)(x1 := x1)(a0 := a0)(a := a)(x := x)(xover := xover);
    ; #share a
    cmp qword [rsp + 2032], 0
    je lab760
    ; ####increment refcount
    mov rcx, [rsp + 2032]
    add qword [rcx + 0], 1

lab760:
    ; #share x1
    cmp r12, 0
    je lab761
    ; ####increment refcount
    add qword [r12 + 0], 1

lab761:
    ; #move variables
    mov [rsp + 2016], rax
    mov [rsp + 2008], rdx
    mov [rsp + 2000], rsi
    mov [rsp + 1992], rdi
    mov rsi, r12
    mov rdi, r13
    mov rax, [rsp + 2032]
    mov rdx, [rsp + 2024]
    ; create a4: Bool = (x3, x2, x1, a0, a, x, xover)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2000]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 32], rcx
    mov rcx, [rsp + 2024]
    mov [rbx + 24], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 16], rcx
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab773
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab774

lab773:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab771
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab764
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab762
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab763

lab762:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab763:

lab764:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab767
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab765
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab766

lab765:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab766:

lab767:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab770
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab768
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab769

lab768:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab769:

lab770:
    jmp lab772

lab771:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab772:

lab774:
    ; ##store link to previous block
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    ; ##store values
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    mov [rbx + 24], r13
    mov [rbx + 16], r12
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab786
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab787

lab786:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab784
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab777
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab775
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab776

lab775:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab776:

lab777:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab780
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab778
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab779

lab778:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab779:

lab780:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab783
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab781
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab782

lab781:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab782:

lab783:
    jmp lab785

lab784:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab785:

lab787:
    ; ##store link to previous block
    mov [rbx + 48], r12
    ; ##store values
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    mov [rbx + 24], r9
    mov [rbx + 16], r8
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab799
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab800

lab799:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab797
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab790
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab788
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab789

lab788:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab789:

lab790:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab793
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab791
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab792

lab791:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab792:

lab793:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab796
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab794
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab795

lab794:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab795:

lab796:
    jmp lab798

lab797:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab798:

lab800:
    ; #load tag
    lea r9, [rel Bool_801]
    ; substitute (x10 := x10)(a5 := a5)(a4 := a4);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump member_
    jmp member_

Bool_801:
    jmp near Bool_801_True
    jmp near Bool_801_False

Bool_801_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab809
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab802
    ; ####increment refcount
    add qword [rsi + 0], 1

lab802:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab803
    ; ####increment refcount
    add qword [rax + 0], 1

lab803:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab804
    ; ####increment refcount
    add qword [r10 + 0], 1

lab804:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab805
    ; ####increment refcount
    add qword [r8 + 0], 1

lab805:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab806
    ; ####increment refcount
    add qword [rcx + 0], 1

lab806:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab807
    ; ####increment refcount
    add qword [r14 + 0], 1

lab807:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab808
    ; ####increment refcount
    add qword [r12 + 0], 1

lab808:
    jmp lab810

lab809:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]

lab810:
    ; substitute (x3 := x3)(xover := xover)(x1 := x1)(a0 := a0)(x := x)(a := a)(x2 := x2);
    ; #move variables
    mov rcx, [rsp + 2032]
    mov [rsp + 2032], rsi
    mov rsi, rcx
    mov rcx, [rsp + 2024]
    mov [rsp + 2024], rdi
    mov rdi, rcx
    mov rcx, r14
    mov r14, r12
    mov r12, rcx
    mov rcx, r15
    mov r15, r13
    mov r13, rcx
    ; let x5: List[Pair[i64, i64]] = Cons(a, x2);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab822
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab823

lab822:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab820
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab813
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab811
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab812

lab811:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab812:

lab813:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab816
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab814
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab815

lab814:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab815:

lab816:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab819
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab817
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab818

lab817:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab818:

lab819:
    jmp lab821

lab820:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab821:

lab823:
    ; #load tag
    mov r15, 5
    ; substitute (xover := xover)(x3 := x3)(x5 := x5)(x1 := x1)(x := x)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rcx, r14
    mov r14, r10
    mov r10, r8
    mov r8, rcx
    mov rcx, r15
    mov r15, r11
    mov r11, r9
    mov r9, rcx
    ; jump collect_neighbors_
    jmp collect_neighbors_

Bool_801_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab831
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab824
    ; ####increment refcount
    add qword [rsi + 0], 1

lab824:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab825
    ; ####increment refcount
    add qword [rax + 0], 1

lab825:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab826
    ; ####increment refcount
    add qword [r10 + 0], 1

lab826:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab827
    ; ####increment refcount
    add qword [r8 + 0], 1

lab827:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab828
    ; ####increment refcount
    add qword [rcx + 0], 1

lab828:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab829
    ; ####increment refcount
    add qword [r14 + 0], 1

lab829:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab830
    ; ####increment refcount
    add qword [r12 + 0], 1

lab830:
    jmp lab832

lab831:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]

lab832:
    ; substitute (x3 := x3)(x2 := x2)(xover := xover)(a0 := a0)(x := x)(a := a)(x1 := x1);
    ; #move variables
    mov rcx, [rsp + 2032]
    mov [rsp + 2032], r8
    mov r8, rcx
    mov rcx, [rsp + 2024]
    mov [rsp + 2024], r9
    mov r9, rcx
    mov rcx, r14
    mov r14, r12
    mov r12, rcx
    mov rcx, r15
    mov r15, r13
    mov r13, rcx
    ; let x6: List[Pair[i64, i64]] = Cons(a, x1);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab844
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab845

lab844:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab842
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab835
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab833
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab834

lab833:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab834:

lab835:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab838
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab836
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab837

lab836:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab837:

lab838:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab841
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab839
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab840

lab839:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab840:

lab841:
    jmp lab843

lab842:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab843:

lab845:
    ; #load tag
    mov r15, 5
    ; substitute (xover := xover)(x3 := x3)(x2 := x2)(x6 := x6)(x := x)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rcx, r14
    mov r14, r10
    mov r10, rcx
    mov rcx, r15
    mov r15, r11
    mov r11, rcx
    ; jump collect_neighbors_
    jmp collect_neighbors_

occurs3_:
    ; let x0: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; let x1: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; let x2: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; let x3: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r14, 0
    ; #load tag
    mov r15, 0
    ; substitute (x0 := x0)(x1 := x1)(x2 := x2)(x3 := x3)(l := l)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, r12
    mov r12, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, r13
    mov r13, rdx
    mov rdx, rcx
    mov rcx, r10
    mov r10, r14
    mov r14, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, r15
    mov r15, rdi
    mov rdi, rcx
    ; jump collect_neighbors_
    jmp collect_neighbors_

neighbours_:
    ; substitute (a0 := a0)(p := p);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch p \{ ... \};
    ; #there is only one clause, so we can just fall through

Pair_i64_i64_846:

Pair_i64_i64_846_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab847
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    jmp lab848

lab847:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]

lab848:
    ; lit x0 <- 1;
    mov r11, 1
    ; x1 <- fst - x0;
    mov r13, rdi
    sub r13, r11
    ; substitute (a0 := a0)(fst := fst)(snd := snd)(x1 := x1);
    ; #move variables
    mov r11, r13
    ; lit x2 <- 1;
    mov r13, 1
    ; x3 <- snd - x2;
    mov r15, r9
    sub r15, r13
    ; substitute (a0 := a0)(fst := fst)(snd := snd)(x1 := x1)(x3 := x3);
    ; #move variables
    mov r13, r15
    ; let x4: Pair[i64, i64] = Tup(x1, x3);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab860
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab861

lab860:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab858
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab851
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab849
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab850

lab849:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab850:

lab851:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab854
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab852
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab853

lab852:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab853:

lab854:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab857
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab855
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab856

lab855:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab856:

lab857:
    jmp lab859

lab858:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab859:

lab861:
    ; #load tag
    mov r11, 0
    ; lit x5 <- 1;
    mov r13, 1
    ; x6 <- fst - x5;
    mov r15, rdi
    sub r15, r13
    ; substitute (a0 := a0)(fst := fst)(snd := snd)(x4 := x4)(x6 := x6)(snd0 := snd);
    ; #move variables
    mov r13, r15
    mov r15, r9
    ; let x7: Pair[i64, i64] = Tup(x6, snd0);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov qword [rbx + 48], 0
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab873
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab874

lab873:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab871
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab864
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab862
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab863

lab862:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab863:

lab864:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab867
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab865
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab866

lab865:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab866:

lab867:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab870
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab868
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab869

lab868:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab869:

lab870:
    jmp lab872

lab871:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab872:

lab874:
    ; #load tag
    mov r13, 0
    ; lit x8 <- 1;
    mov r15, 1
    ; x9 <- fst - x8;
    mov rcx, rdi
    sub rcx, r15
    mov [rsp + 2024], rcx
    ; substitute (a0 := a0)(fst := fst)(snd := snd)(x4 := x4)(x7 := x7)(x9 := x9);
    ; #move variables
    mov r15, [rsp + 2024]
    ; lit x10 <- 1;
    mov qword [rsp + 2024], 1
    ; x11 <- snd + x10;
    mov rcx, r9
    add rcx, [rsp + 2024]
    mov [rsp + 2008], rcx
    ; substitute (a0 := a0)(fst := fst)(snd := snd)(x4 := x4)(x7 := x7)(x9 := x9)(x11 := x11);
    ; #move variables
    mov rcx, [rsp + 2008]
    mov [rsp + 2024], rcx
    ; let x12: Pair[i64, i64] = Tup(x9, x11);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov [rbx + 40], r15
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab886
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab887

lab886:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab884
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab877
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab875
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab876

lab875:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab876:

lab877:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab880
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab878
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab879

lab878:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab879:

lab880:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab883
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab881
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab882

lab881:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab882:

lab883:
    jmp lab885

lab884:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab885:

lab887:
    ; #load tag
    mov r15, 0
    ; lit x13 <- 1;
    mov qword [rsp + 2024], 1
    ; x14 <- snd - x13;
    mov rcx, r9
    sub rcx, [rsp + 2024]
    mov [rsp + 2008], rcx
    ; substitute (a0 := a0)(fst := fst)(snd := snd)(x4 := x4)(x7 := x7)(x12 := x12)(fst0 := fst)(x14 := x14);
    ; #move variables
    mov [rsp + 2024], rdi
    ; let x15: Pair[i64, i64] = Tup(fst0, x14);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab899
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab900

lab899:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab897
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab890
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab888
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab889

lab888:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab889:

lab890:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab893
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab891
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab892

lab891:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab892:

lab893:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab896
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab894
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab895

lab894:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab895:

lab896:
    jmp lab898

lab897:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab898:

lab900:
    ; #load tag
    mov qword [rsp + 2024], 0
    ; lit x16 <- 1;
    mov qword [rsp + 2008], 1
    ; x17 <- snd + x16;
    mov rcx, r9
    add rcx, [rsp + 2008]
    mov [rsp + 1992], rcx
    ; substitute (a0 := a0)(fst := fst)(snd := snd)(x4 := x4)(x7 := x7)(x12 := x12)(x15 := x15)(fst1 := fst)(x17 := x17);
    ; #move variables
    mov [rsp + 2008], rdi
    ; let x18: Pair[i64, i64] = Tup(fst1, x17);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2016], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab912
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab913

lab912:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab910
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab903
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab901
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab902

lab901:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab902:

lab903:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab906
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab904
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab905

lab904:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab905:

lab906:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab909
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab907
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab908

lab907:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab908:

lab909:
    jmp lab911

lab910:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab911:

lab913:
    ; #load tag
    mov qword [rsp + 2008], 0
    ; lit x19 <- 1;
    mov qword [rsp + 1992], 1
    ; x20 <- fst + x19;
    mov rcx, rdi
    add rcx, [rsp + 1992]
    mov [rsp + 1976], rcx
    ; substitute (a0 := a0)(fst := fst)(snd := snd)(x4 := x4)(x7 := x7)(x12 := x12)(x15 := x15)(x18 := x18)(x20 := x20);
    ; #move variables
    mov rcx, [rsp + 1976]
    mov [rsp + 1992], rcx
    ; lit x21 <- 1;
    mov qword [rsp + 1976], 1
    ; x22 <- snd - x21;
    mov rcx, r9
    sub rcx, [rsp + 1976]
    mov [rsp + 1960], rcx
    ; substitute (a0 := a0)(fst := fst)(snd := snd)(x4 := x4)(x7 := x7)(x12 := x12)(x15 := x15)(x18 := x18)(x20 := x20)(x22 := x22);
    ; #move variables
    mov rcx, [rsp + 1960]
    mov [rsp + 1976], rcx
    ; let x23: Pair[i64, i64] = Tup(x20, x22);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1976]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1992]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2000], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab925
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab926

lab925:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab923
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab916
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab914
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab915

lab914:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab915:

lab916:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab919
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab917
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab918

lab917:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab918:

lab919:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab922
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab920
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab921

lab920:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab921:

lab922:
    jmp lab924

lab923:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab924:

lab926:
    ; #load tag
    mov qword [rsp + 1992], 0
    ; lit x24 <- 1;
    mov qword [rsp + 1976], 1
    ; x25 <- fst + x24;
    mov rcx, rdi
    add rcx, [rsp + 1976]
    mov [rsp + 1960], rcx
    ; substitute (a0 := a0)(fst := fst)(snd := snd)(x4 := x4)(x7 := x7)(x12 := x12)(x15 := x15)(x18 := x18)(x23 := x23)(x25 := x25)(snd1 := snd);
    ; #move variables
    mov rcx, [rsp + 1960]
    mov [rsp + 1976], rcx
    mov [rsp + 1960], r9
    ; let x26: Pair[i64, i64] = Tup(x25, snd1);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1960]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1976]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 1984], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab938
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab939

lab938:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab936
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab929
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab927
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab928

lab927:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab928:

lab929:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab932
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab930
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab931

lab930:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab931:

lab932:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab935
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab933
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab934

lab933:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab934:

lab935:
    jmp lab937

lab936:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab937:

lab939:
    ; #load tag
    mov qword [rsp + 1976], 0
    ; lit x27 <- 1;
    mov qword [rsp + 1960], 1
    ; x28 <- fst + x27;
    mov rcx, rdi
    add rcx, [rsp + 1960]
    mov [rsp + 1944], rcx
    ; substitute (a0 := a0)(x28 := x28)(snd := snd)(x4 := x4)(x7 := x7)(x12 := x12)(x15 := x15)(x18 := x18)(x23 := x23)(x26 := x26);
    ; #move variables
    mov rdi, [rsp + 1944]
    ; lit x29 <- 1;
    mov qword [rsp + 1960], 1
    ; x30 <- snd + x29;
    mov rcx, r9
    add rcx, [rsp + 1960]
    mov [rsp + 1944], rcx
    ; substitute (a0 := a0)(x26 := x26)(x23 := x23)(x4 := x4)(x7 := x7)(x12 := x12)(x15 := x15)(x18 := x18)(x28 := x28)(x30 := x30);
    ; #move variables
    mov r9, [rsp + 1992]
    mov [rsp + 1992], rdi
    mov r8, [rsp + 2000]
    mov rsi, [rsp + 1984]
    mov rdi, [rsp + 1976]
    mov rcx, [rsp + 1944]
    mov [rsp + 1976], rcx
    ; let x31: Pair[i64, i64] = Tup(x28, x30);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1976]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1992]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2000], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab951
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab952

lab951:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab949
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab942
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab940
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab941

lab940:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab941:

lab942:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab945
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab943
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab944

lab943:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab944:

lab945:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab948
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab946
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab947

lab946:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab947:

lab948:
    jmp lab950

lab949:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab950:

lab952:
    ; #load tag
    mov qword [rsp + 1992], 0
    ; let x32: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov qword [rsp + 1984], 0
    ; #load tag
    mov qword [rsp + 1976], 0
    ; let x33: List[Pair[i64, i64]] = Cons(x31, x32);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1976]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 1984]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 1992]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2000]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2000], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab964
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab965

lab964:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab962
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab955
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab953
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab954

lab953:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab954:

lab955:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab958
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab956
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab957

lab956:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab957:

lab958:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab961
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab959
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab960

lab959:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab960:

lab961:
    jmp lab963

lab962:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab963:

lab965:
    ; #load tag
    mov qword [rsp + 1992], 5
    ; substitute (a0 := a0)(x18 := x18)(x23 := x23)(x4 := x4)(x7 := x7)(x12 := x12)(x15 := x15)(x26 := x26)(x33 := x33);
    ; #move variables
    mov rcx, [rsp + 2016]
    mov [rsp + 2016], rsi
    mov rsi, rcx
    mov rcx, [rsp + 2008]
    mov [rsp + 2008], rdi
    mov rdi, rcx
    ; let x34: List[Pair[i64, i64]] = Cons(x26, x33);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2000]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2016], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab977
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab978

lab977:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab975
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab968
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab966
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab967

lab966:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab967:

lab968:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab971
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab969
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab970

lab969:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab970:

lab971:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab974
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab972
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab973

lab972:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab973:

lab974:
    jmp lab976

lab975:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab976:

lab978:
    ; #load tag
    mov qword [rsp + 2008], 5
    ; substitute (a0 := a0)(x18 := x18)(x15 := x15)(x4 := x4)(x7 := x7)(x12 := x12)(x23 := x23)(x34 := x34);
    ; #move variables
    mov rcx, [rsp + 2032]
    mov [rsp + 2032], r8
    mov r8, rcx
    mov rcx, [rsp + 2024]
    mov [rsp + 2024], r9
    mov r9, rcx
    ; let x35: List[Pair[i64, i64]] = Cons(x23, x34);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab990
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab991

lab990:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab988
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab981
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab979
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab980

lab979:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab980:

lab981:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab984
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab982
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab983

lab982:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab983:

lab984:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab987
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab985
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab986

lab985:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab986:

lab987:
    jmp lab989

lab988:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab989:

lab991:
    ; #load tag
    mov qword [rsp + 2024], 5
    ; substitute (a0 := a0)(x12 := x12)(x15 := x15)(x4 := x4)(x7 := x7)(x18 := x18)(x35 := x35);
    ; #move variables
    mov rcx, r14
    mov r14, rsi
    mov rsi, rcx
    mov rcx, r15
    mov r15, rdi
    mov rdi, rcx
    ; let x36: List[Pair[i64, i64]] = Cons(x18, x35);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1003
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab1004

lab1003:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1001
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab994
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab992
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab993

lab992:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab993:

lab994:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab997
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab995
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab996

lab995:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab996:

lab997:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1000
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab998
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab999

lab998:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab999:

lab1000:
    jmp lab1002

lab1001:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1002:

lab1004:
    ; #load tag
    mov r15, 5
    ; substitute (a0 := a0)(x12 := x12)(x7 := x7)(x4 := x4)(x15 := x15)(x36 := x36);
    ; #move variables
    mov rcx, r12
    mov r12, r8
    mov r8, rcx
    mov rcx, r13
    mov r13, r9
    mov r9, rcx
    ; let x37: List[Pair[i64, i64]] = Cons(x15, x36);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1016
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1017

lab1016:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1014
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1007
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1005
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1006

lab1005:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1006:

lab1007:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1010
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1008
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1009

lab1008:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1009:

lab1010:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1013
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1011
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1012

lab1011:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1012:

lab1013:
    jmp lab1015

lab1014:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1015:

lab1017:
    ; #load tag
    mov r13, 5
    ; substitute (a0 := a0)(x4 := x4)(x7 := x7)(x12 := x12)(x37 := x37);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; let x38: List[Pair[i64, i64]] = Cons(x12, x37);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1029
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1030

lab1029:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1027
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1020
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1018
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1019

lab1018:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1019:

lab1020:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1023
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1021
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1022

lab1021:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1022:

lab1023:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1026
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1024
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1025

lab1024:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1025:

lab1026:
    jmp lab1028

lab1027:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1028:

lab1030:
    ; #load tag
    mov r11, 5
    ; let x39: List[Pair[i64, i64]] = Cons(x7, x38);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1042
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1043

lab1042:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1040
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1033
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1031
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1032

lab1031:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1032:

lab1033:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1036
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1034
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1035

lab1034:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1035:

lab1036:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1039
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1037
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1038

lab1037:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1038:

lab1039:
    jmp lab1041

lab1040:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1041:

lab1043:
    ; #load tag
    mov r9, 5
    ; substitute (x4 := x4)(x39 := x39)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

alive_:
    ; substitute (a0 := a0)(g := g);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch g \{ ... \};
    ; #there is only one clause, so we can just fall through

Gen_1044:

Gen_1044_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1046
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab1045
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1045:
    jmp lab1047

lab1046:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab1047:
    ; switch livecoords \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_1048]
    add rcx, rdi
    jmp rcx

List_Pair_i64_i64_1048:
    jmp near List_Pair_i64_i64_1048_Nil
    jmp near List_Pair_i64_i64_1048_Cons

List_Pair_i64_i64_1048_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_1048_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1051
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab1049
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1049:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab1050
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1050:
    jmp lab1052

lab1051:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab1052:
    ; substitute (x0 := x0)(xs0 := xs0)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

twoorthree_:
    ; lit x0 <- 2;
    mov r9, 2
    ; if n == x0 \{ ... \}
    cmp rdx, r9
    je lab1053
    ; else branch
    ; substitute (n := n)(a0 := a0);
    ; lit x1 <- 3;
    mov r9, 3
    ; if n == x1 \{ ... \}
    cmp rdx, r9
    je lab1054
    ; else branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 False
    add rdx, 5
    jmp rdx

lab1054:
    ; then branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 True
    add rdx, 0
    jmp rdx

lab1053:
    ; then branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 True
    add rdx, 0
    jmp rdx

nextgen_:
    ; create a12: List[Pair[i64, i64]] = (a0)\{ ... \};
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
    je lab1066
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1067

lab1066:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1064
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1057
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1055
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1056

lab1055:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1056:

lab1057:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1060
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1058
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1059

lab1058:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1059:

lab1060:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1063
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1061
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1062

lab1061:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1062:

lab1063:
    jmp lab1065

lab1064:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1065:

lab1067:
    ; #load tag
    lea rdi, [rel List_Pair_i64_i64_1068]
    ; jump alive_
    jmp alive_

List_Pair_i64_i64_1068:
    jmp near List_Pair_i64_i64_1068_Nil
    jmp near List_Pair_i64_i64_1068_Cons

List_Pair_i64_i64_1068_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1070
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1069
    ; ####increment refcount
    add qword [rax + 0], 1

lab1069:
    jmp lab1071

lab1070:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1071:
    ; let living: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_nextgen_0_
    jmp lift_nextgen_0_

List_Pair_i64_i64_1068_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1073
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1072
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1072:
    jmp lab1074

lab1073:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1074:
    ; substitute (a0 := a0)(x16 := x16)(xs7 := xs7);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let living: List[Pair[i64, i64]] = Cons(x16, xs7);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab1086
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1087

lab1086:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1084
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1077
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1075
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1076

lab1075:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1076:

lab1077:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1080
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1078
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1079

lab1078:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1079:

lab1080:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1083
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1081
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1082

lab1081:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1082:

lab1083:
    jmp lab1085

lab1084:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1085:

lab1087:
    ; #load tag
    mov rdi, 5
    ; jump lift_nextgen_0_
    jmp lift_nextgen_0_

lift_nextgen_0_:
    ; substitute (a0 := a0)(living0 := living)(living := living);
    ; #share living
    cmp rsi, 0
    je lab1088
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1088:
    ; #move variables
    mov r8, rsi
    mov r9, rdi
    ; create isalive: Fun[Pair[i64, i64], Bool] = (living)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1100
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1101

lab1100:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1098
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1091
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1089
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1090

lab1089:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1090:

lab1091:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1094
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1092
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1093

lab1092:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1093:

lab1094:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1097
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1095
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1096

lab1095:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1096:

lab1097:
    jmp lab1099

lab1098:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1099:

lab1101:
    ; #load tag
    lea r9, [rel Fun_Pair_i64_i64_Bool_1102]
    ; substitute (a0 := a0)(living0 := living0)(isalive0 := isalive)(isalive := isalive);
    ; #share isalive
    cmp r8, 0
    je lab1103
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1103:
    ; #move variables
    mov r10, r8
    mov r11, r9
    ; create liveneighbours: Fun[Pair[i64, i64], i64] = (isalive)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1115
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1116

lab1115:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1113
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1106
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1104
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1105

lab1104:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1105:

lab1106:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1109
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1107
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1108

lab1107:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1108:

lab1109:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1112
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1110
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1111

lab1110:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1111:

lab1112:
    jmp lab1114

lab1113:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1114:

lab1116:
    ; #load tag
    lea r11, [rel Fun_Pair_i64_i64_i64_1117]
    ; create x2: Fun[Pair[i64, i64], Bool] = (liveneighbours)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1129
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1130

lab1129:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1127
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1120
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1118
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1119

lab1118:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1119:

lab1120:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1123
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1121
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1122

lab1121:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1122:

lab1123:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1126
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1124
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1125

lab1124:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1125:

lab1126:
    jmp lab1128

lab1127:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1128:

lab1130:
    ; #load tag
    lea r11, [rel Fun_Pair_i64_i64_Bool_1131]
    ; substitute (x2 := x2)(living00 := living0)(isalive0 := isalive0)(living0 := living0)(a0 := a0);
    ; #share living0
    cmp rsi, 0
    je lab1132
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1132:
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov rax, r10
    mov r10, rsi
    mov rdx, r11
    mov r11, rdi
    ; create a13: List[Pair[i64, i64]] = (isalive0, living0, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    mov [rbx + 24], r9
    mov [rbx + 16], r8
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1144
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1145

lab1144:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1142
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1135
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1133
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1134

lab1133:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1134:

lab1135:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1138
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1136
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1137

lab1136:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1137:

lab1138:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1141
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1139
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1140

lab1139:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1140:

lab1141:
    jmp lab1143

lab1142:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1143:

lab1145:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_1146]
    ; substitute (living00 := living00)(x2 := x2)(a13 := a13);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump filter_
    jmp filter_

List_Pair_i64_i64_1146:
    jmp near List_Pair_i64_i64_1146_Nil
    jmp near List_Pair_i64_i64_1146_Cons

List_Pair_i64_i64_1146_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1150
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1147
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1147:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1148
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1148:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1149
    ; ####increment refcount
    add qword [rax + 0], 1

lab1149:
    jmp lab1151

lab1150:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab1151:
    ; let survivors: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(isalive0 := isalive0)(living0 := living0)(survivors := survivors);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump lift_nextgen_1_
    jmp lift_nextgen_1_

List_Pair_i64_i64_1146_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1155
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab1152
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1152:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab1153
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1153:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab1154
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1154:
    jmp lab1156

lab1155:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]

lab1156:
    ; substitute (a0 := a0)(living0 := living0)(isalive0 := isalive0)(x15 := x15)(xs6 := xs6);
    ; #move variables
    mov rcx, r12
    mov r12, rsi
    mov rsi, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r13
    mov r13, rdi
    mov rdi, r11
    mov r11, rdx
    mov rdx, rcx
    ; let survivors: List[Pair[i64, i64]] = Cons(x15, xs6);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1168
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1169

lab1168:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1166
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1159
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1157
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1158

lab1157:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1158:

lab1159:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1162
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1160
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1161

lab1160:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1161:

lab1162:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1165
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1163
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1164

lab1163:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1164:

lab1165:
    jmp lab1167

lab1166:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1167:

lab1169:
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(isalive0 := isalive0)(living0 := living0)(survivors := survivors);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump lift_nextgen_1_
    jmp lift_nextgen_1_

Fun_Pair_i64_i64_Bool_1131:

Fun_Pair_i64_i64_Bool_1131_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1171
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1170
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1170:
    jmp lab1172

lab1171:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1172:
    ; substitute (p1 := p1)(liveneighbours := liveneighbours)(a6 := a6);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create a7: _Cont = (a6)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1184
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1185

lab1184:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1182
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1175
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1173
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1174

lab1173:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1174:

lab1175:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1178
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1176
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1177

lab1176:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1177:

lab1178:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1181
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1179
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1180

lab1179:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1180:

lab1181:
    jmp lab1183

lab1182:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1183:

lab1185:
    ; #load tag
    lea r9, [rel _Cont_1186]
    ; substitute (p1 := p1)(a7 := a7)(liveneighbours := liveneighbours);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; invoke liveneighbours Apply
    ; #there is only one clause, so we can jump there directly
    jmp r9

_Cont_1186:

_Cont_1186_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1188
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab1187
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1187:
    jmp lab1189

lab1188:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab1189:
    ; jump twoorthree_
    jmp twoorthree_

Fun_Pair_i64_i64_i64_1117:

Fun_Pair_i64_i64_i64_1117_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1191
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1190
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1190:
    jmp lab1192

lab1191:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1192:
    ; substitute (p0 := p0)(isalive := isalive)(a8 := a8);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create a9: List[Pair[i64, i64]] = (a8)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1204
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1205

lab1204:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1202
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1195
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1193
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1194

lab1193:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1194:

lab1195:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1198
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1196
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1197

lab1196:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1197:

lab1198:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1201
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1199
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1200

lab1199:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1200:

lab1201:
    jmp lab1203

lab1202:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1203:

lab1205:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_1206]
    ; create a10: List[Pair[i64, i64]] = (isalive, a9)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab1218
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1219

lab1218:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1216
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1209
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1207
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1208

lab1207:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1208:

lab1209:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1212
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1210
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1211

lab1210:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1211:

lab1212:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1215
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1213
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1214

lab1213:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1214:

lab1215:
    jmp lab1217

lab1216:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1217:

lab1219:
    ; #load tag
    lea rdi, [rel List_Pair_i64_i64_1220]
    ; jump neighbours_
    jmp neighbours_

List_Pair_i64_i64_1220:
    jmp near List_Pair_i64_i64_1220_Nil
    jmp near List_Pair_i64_i64_1220_Cons

List_Pair_i64_i64_1220_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1223
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1221
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1221:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1222
    ; ####increment refcount
    add qword [rax + 0], 1

lab1222:
    jmp lab1224

lab1223:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1224:
    ; let x1: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x1 := x1)(isalive := isalive)(a9 := a9);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump filter_
    jmp filter_

List_Pair_i64_i64_1220_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1227
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1225
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1225:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1226
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1226:
    jmp lab1228

lab1227:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1228:
    ; substitute (a9 := a9)(isalive := isalive)(x10 := x10)(xs1 := xs1);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; let x1: List[Pair[i64, i64]] = Cons(x10, xs1);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1240
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1241

lab1240:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1238
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1231
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1229
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1230

lab1229:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1230:

lab1231:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1234
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1232
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1233

lab1232:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1233:

lab1234:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1237
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1235
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1236

lab1235:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1236:

lab1237:
    jmp lab1239

lab1238:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1239:

lab1241:
    ; #load tag
    mov r9, 5
    ; substitute (x1 := x1)(isalive := isalive)(a9 := a9);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump filter_
    jmp filter_

List_Pair_i64_i64_1206:
    jmp near List_Pair_i64_i64_1206_Nil
    jmp near List_Pair_i64_i64_1206_Cons

List_Pair_i64_i64_1206_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1243
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1242
    ; ####increment refcount
    add qword [rax + 0], 1

lab1242:
    jmp lab1244

lab1243:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1244:
    ; let x0: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; substitute (x0 := x0)(a8 := a8);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump len_
    jmp len_

List_Pair_i64_i64_1206_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1246
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1245
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1245:
    jmp lab1247

lab1246:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1247:
    ; substitute (a8 := a8)(x9 := x9)(xs0 := xs0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let x0: List[Pair[i64, i64]] = Cons(x9, xs0);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab1259
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1260

lab1259:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1257
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1250
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1248
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1249

lab1248:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1249:

lab1250:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1253
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1251
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1252

lab1251:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1252:

lab1253:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1256
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1254
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1255

lab1254:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1255:

lab1256:
    jmp lab1258

lab1257:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1258:

lab1260:
    ; #load tag
    mov rdi, 5
    ; substitute (x0 := x0)(a8 := a8);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump len_
    jmp len_

Fun_Pair_i64_i64_Bool_1102:

Fun_Pair_i64_i64_Bool_1102_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1262
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1261
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1261:
    jmp lab1263

lab1262:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1263:
    ; substitute (living := living)(p := p)(a11 := a11);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump member_
    jmp member_

lift_nextgen_1_:
    ; substitute (a0 := a0)(survivors := survivors)(living := living)(isalive := isalive);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; create x3: Fun[Pair[i64, i64], List[Pair[i64, i64]]] = (isalive)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1275
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1276

lab1275:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1273
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1266
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1264
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1265

lab1264:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1265:

lab1266:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1269
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1267
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1268

lab1267:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1268:

lab1269:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1272
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1270
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1271

lab1270:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1271:

lab1272:
    jmp lab1274

lab1273:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1274:

lab1276:
    ; #load tag
    lea r11, [rel Fun_Pair_i64_i64_List_Pair_i64_i64_1277]
    ; substitute (x3 := x3)(living := living)(survivors := survivors)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create a14: List[Pair[i64, i64]] = (survivors, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1289
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1290

lab1289:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1287
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1280
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1278
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1279

lab1278:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1279:

lab1280:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1283
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1281
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1282

lab1281:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1282:

lab1283:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1286
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1284
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1285

lab1284:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1285:

lab1286:
    jmp lab1288

lab1287:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1288:

lab1290:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_1291]
    ; substitute (living := living)(x3 := x3)(a14 := a14);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump collect_
    jmp collect_

List_Pair_i64_i64_1291:
    jmp near List_Pair_i64_i64_1291_Nil
    jmp near List_Pair_i64_i64_1291_Cons

List_Pair_i64_i64_1291_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1294
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1292
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1292:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1293
    ; ####increment refcount
    add qword [rax + 0], 1

lab1293:
    jmp lab1295

lab1294:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1295:
    ; let newbrnlist: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (a0 := a0)(newbrnlist := newbrnlist)(survivors := survivors);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump lift_nextgen_3_
    jmp lift_nextgen_3_

List_Pair_i64_i64_1291_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1298
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1296
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1296:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1297
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1297:
    jmp lab1299

lab1298:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1299:
    ; substitute (a0 := a0)(survivors := survivors)(x14 := x14)(xs5 := xs5);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; let newbrnlist: List[Pair[i64, i64]] = Cons(x14, xs5);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1311
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1312

lab1311:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1309
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1302
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1300
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1301

lab1300:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1301:

lab1302:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1305
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1303
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1304

lab1303:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1304:

lab1305:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1308
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1306
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1307

lab1306:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1307:

lab1308:
    jmp lab1310

lab1309:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1310:

lab1312:
    ; #load tag
    mov r9, 5
    ; substitute (a0 := a0)(newbrnlist := newbrnlist)(survivors := survivors);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump lift_nextgen_3_
    jmp lift_nextgen_3_

Fun_Pair_i64_i64_List_Pair_i64_i64_1277:

Fun_Pair_i64_i64_List_Pair_i64_i64_1277_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1314
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1313
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1313:
    jmp lab1315

lab1314:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1315:
    ; create a3: List[Pair[i64, i64]] = (a2, isalive)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab1327
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1328

lab1327:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1325
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1318
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1316
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1317

lab1316:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1317:

lab1318:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1321
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1319
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1320

lab1319:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1320:

lab1321:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1324
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1322
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1323

lab1322:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1323:

lab1324:
    jmp lab1326

lab1325:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1326:

lab1328:
    ; #load tag
    lea rdi, [rel List_Pair_i64_i64_1329]
    ; jump neighbours_
    jmp neighbours_

List_Pair_i64_i64_1329:
    jmp near List_Pair_i64_i64_1329_Nil
    jmp near List_Pair_i64_i64_1329_Cons

List_Pair_i64_i64_1329_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1332
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1330
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1330:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1331
    ; ####increment refcount
    add qword [rax + 0], 1

lab1331:
    jmp lab1333

lab1332:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1333:
    ; let x5: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; jump lift_nextgen_2_
    jmp lift_nextgen_2_

List_Pair_i64_i64_1329_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1336
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1334
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1334:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1335
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1335:
    jmp lab1337

lab1336:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1337:
    ; substitute (isalive := isalive)(a2 := a2)(x11 := x11)(xs2 := xs2);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; let x5: List[Pair[i64, i64]] = Cons(x11, xs2);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1349
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1350

lab1349:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1347
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1340
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1338
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1339

lab1338:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1339:

lab1340:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1343
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1341
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1342

lab1341:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1342:

lab1343:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1346
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1344
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1345

lab1344:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1345:

lab1346:
    jmp lab1348

lab1347:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1348:

lab1350:
    ; #load tag
    mov r9, 5
    ; substitute (a2 := a2)(isalive := isalive)(x5 := x5);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump lift_nextgen_2_
    jmp lift_nextgen_2_

lift_nextgen_3_:
    ; substitute (newbrnlist := newbrnlist)(a0 := a0)(survivors := survivors);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; create a15: List[Pair[i64, i64]] = (a0, survivors)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab1362
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1363

lab1362:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1360
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1353
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1351
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1352

lab1351:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1352:

lab1353:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1356
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1354
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1355

lab1354:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1355:

lab1356:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1359
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1357
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1358

lab1357:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1358:

lab1359:
    jmp lab1361

lab1360:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1361:

lab1363:
    ; #load tag
    lea rdi, [rel List_Pair_i64_i64_1364]
    ; jump occurs3_
    jmp occurs3_

List_Pair_i64_i64_1364:
    jmp near List_Pair_i64_i64_1364_Nil
    jmp near List_Pair_i64_i64_1364_Cons

List_Pair_i64_i64_1364_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1367
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1365
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1365:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1366
    ; ####increment refcount
    add qword [rax + 0], 1

lab1366:
    jmp lab1368

lab1367:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1368:
    ; let newborn: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (a0 := a0)(newborn := newborn)(survivors := survivors);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump lift_nextgen_4_
    jmp lift_nextgen_4_

List_Pair_i64_i64_1364_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1371
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1369
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1369:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1370
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1370:
    jmp lab1372

lab1371:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1372:
    ; substitute (survivors := survivors)(a0 := a0)(x13 := x13)(xs4 := xs4);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; let newborn: List[Pair[i64, i64]] = Cons(x13, xs4);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1384
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1385

lab1384:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1382
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1375
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1373
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1374

lab1373:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1374:

lab1375:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1378
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1376
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1377

lab1376:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1377:

lab1378:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1381
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1379
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1380

lab1379:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1380:

lab1381:
    jmp lab1383

lab1382:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1383:

lab1385:
    ; #load tag
    mov r9, 5
    ; substitute (a0 := a0)(newborn := newborn)(survivors := survivors);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump lift_nextgen_4_
    jmp lift_nextgen_4_

lift_nextgen_4_:
    ; substitute (survivors := survivors)(newborn := newborn)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a1: List[Pair[i64, i64]] = (a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1397
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1398

lab1397:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1395
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1388
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1386
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1387

lab1386:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1387:

lab1388:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1391
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1389
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1390

lab1389:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1390:

lab1391:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1394
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1392
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1393

lab1392:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1393:

lab1394:
    jmp lab1396

lab1395:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1396:

lab1398:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_1399]
    ; jump append_
    jmp append_

List_Pair_i64_i64_1399:
    jmp near List_Pair_i64_i64_1399_Nil
    jmp near List_Pair_i64_i64_1399_Cons

List_Pair_i64_i64_1399_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1401
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1400
    ; ####increment refcount
    add qword [rax + 0], 1

lab1400:
    jmp lab1402

lab1401:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1402:
    ; let x4: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; substitute (x4 := x4)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Gen
    ; #there is only one clause, so we can jump there directly
    jmp rdi

List_Pair_i64_i64_1399_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1404
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1403
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1403:
    jmp lab1405

lab1404:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1405:
    ; substitute (a0 := a0)(x12 := x12)(xs3 := xs3);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let x4: List[Pair[i64, i64]] = Cons(x12, xs3);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab1417
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1418

lab1417:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1415
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1408
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1406
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1407

lab1406:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1407:

lab1408:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1411
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1409
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1410

lab1409:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1410:

lab1411:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1414
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1412
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1413

lab1412:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1413:

lab1414:
    jmp lab1416

lab1415:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1416:

lab1418:
    ; #load tag
    mov rdi, 5
    ; substitute (x4 := x4)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Gen
    ; #there is only one clause, so we can jump there directly
    jmp rdi

lift_nextgen_2_:
    ; substitute (a2 := a2)(x5 := x5)(isalive := isalive);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create x6: Fun[Pair[i64, i64], Bool] = (isalive)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1430
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1431

lab1430:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1428
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1421
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1419
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1420

lab1419:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1420:

lab1421:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1424
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1422
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1423

lab1422:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1423:

lab1424:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1427
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1425
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1426

lab1425:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1426:

lab1427:
    jmp lab1429

lab1428:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1429:

lab1431:
    ; #load tag
    lea r9, [rel Fun_Pair_i64_i64_Bool_1432]
    ; substitute (x5 := x5)(x6 := x6)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump filter_
    jmp filter_

Fun_Pair_i64_i64_Bool_1432:

Fun_Pair_i64_i64_Bool_1432_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1434
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1433
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1433:
    jmp lab1435

lab1434:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1435:
    ; substitute (n := n)(isalive := isalive)(a4 := a4);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create a5: Bool = (a4)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1447
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1448

lab1447:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1445
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1438
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1436
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1437

lab1436:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1437:

lab1438:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1441
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1439
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1440

lab1439:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1440:

lab1441:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1444
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1442
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1443

lab1442:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1443:

lab1444:
    jmp lab1446

lab1445:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1446:

lab1448:
    ; #load tag
    lea r9, [rel Bool_1449]
    ; substitute (n := n)(a5 := a5)(isalive := isalive);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; invoke isalive Apply
    ; #there is only one clause, so we can jump there directly
    jmp r9

Bool_1449:
    jmp near Bool_1449_True
    jmp near Bool_1449_False

Bool_1449_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1451
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1450
    ; ####increment refcount
    add qword [rax + 0], 1

lab1450:
    jmp lab1452

lab1451:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1452:
    ; let x7: Bool = True();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; substitute (x7 := x7)(a4 := a4);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

Bool_1449_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1454
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1453
    ; ####increment refcount
    add qword [rax + 0], 1

lab1453:
    jmp lab1455

lab1454:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1455:
    ; let x7: Bool = False();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 5
    ; substitute (x7 := x7)(a4 := a4);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

nthgen_:
    ; if i == 0 \{ ... \}
    cmp rdi, 0
    je lab1456
    ; else branch
    ; create a1: Gen = (i, a0)\{ ... \};
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
    je lab1468
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1469

lab1468:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1466
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1459
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1457
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1458

lab1457:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1458:

lab1459:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1462
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1460
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1461

lab1460:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1461:

lab1462:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1465
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1463
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1464

lab1463:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1464:

lab1465:
    jmp lab1467

lab1466:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1467:

lab1469:
    ; #load tag
    lea rdi, [rel Gen_1470]
    ; jump nextgen_
    jmp nextgen_

Gen_1470:

Gen_1470_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1472
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab1471
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1471:
    mov rdi, [rsi + 40]
    jmp lab1473

lab1472:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]

lab1473:
    ; substitute (a0 := a0)(i := i)(coordslist1 := coordslist1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; let x0: Gen = Gen(coordslist1);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1485
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1486

lab1485:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1483
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1476
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1474
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1475

lab1474:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1475:

lab1476:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1479
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1477
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1478

lab1477:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1478:

lab1479:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1482
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1480
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1481

lab1480:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1481:

lab1482:
    jmp lab1484

lab1483:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1484:

lab1486:
    ; #load tag
    mov r9, 0
    ; lit x1 <- 1;
    mov r11, 1
    ; x2 <- i - x1;
    mov r13, rdi
    sub r13, r11
    ; substitute (x0 := x0)(x2 := x2)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov rdi, r13
    ; jump nthgen_
    jmp nthgen_

lab1456:
    ; then branch
    ; substitute (a0 := a0)(g := g);
    ; #move variables
    mov rsi, rax
    mov rdi, rdx
    mov rax, r8
    mov rdx, r9
    ; switch g \{ ... \};
    ; #there is only one clause, so we can just fall through

Gen_1487:

Gen_1487_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1489
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab1488
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1488:
    jmp lab1490

lab1489:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab1490:
    ; substitute (coordslist0 := coordslist0)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Gen
    ; #there is only one clause, so we can jump there directly
    jmp rdi

gun_:
    ; lit x0 <- 9;
    mov rdi, 9
    ; lit x1 <- 29;
    mov r9, 29
    ; let x2: Pair[i64, i64] = Tup(x0, x1);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov qword [rbx + 48], 0
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
    je lab1502
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1503

lab1502:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1500
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1493
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1491
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1492

lab1491:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1492:

lab1493:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1496
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1494
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1495

lab1494:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1495:

lab1496:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1499
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1497
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1498

lab1497:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1498:

lab1499:
    jmp lab1501

lab1500:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1501:

lab1503:
    ; #load tag
    mov rdi, 0
    ; lit x3 <- 9;
    mov r9, 9
    ; lit x4 <- 30;
    mov r11, 30
    ; let x5: Pair[i64, i64] = Tup(x3, x4);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1515
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1516

lab1515:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1513
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1506
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1504
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1505

lab1504:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1505:

lab1506:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1509
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1507
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1508

lab1507:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1508:

lab1509:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1512
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1510
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1511

lab1510:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1511:

lab1512:
    jmp lab1514

lab1513:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1514:

lab1516:
    ; #load tag
    mov r9, 0
    ; lit x6 <- 9;
    mov r11, 9
    ; lit x7 <- 31;
    mov r13, 31
    ; let x8: Pair[i64, i64] = Tup(x6, x7);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1528
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1529

lab1528:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1526
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1519
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1517
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1518

lab1517:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1518:

lab1519:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1522
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1520
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1521

lab1520:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1521:

lab1522:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1525
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1523
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1524

lab1523:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1524:

lab1525:
    jmp lab1527

lab1526:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1527:

lab1529:
    ; #load tag
    mov r11, 0
    ; lit x9 <- 9;
    mov r13, 9
    ; lit x10 <- 32;
    mov r15, 32
    ; let x11: Pair[i64, i64] = Tup(x9, x10);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov qword [rbx + 48], 0
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1541
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1542

lab1541:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1539
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1532
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1530
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1531

lab1530:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1531:

lab1532:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1535
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1533
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1534

lab1533:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1534:

lab1535:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1538
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1536
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1537

lab1536:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1537:

lab1538:
    jmp lab1540

lab1539:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1540:

lab1542:
    ; #load tag
    mov r13, 0
    ; let x12: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r14, 0
    ; #load tag
    mov r15, 0
    ; let x13: List[Pair[i64, i64]] = Cons(x11, x12);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1554
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1555

lab1554:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1552
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1545
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1543
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1544

lab1543:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1544:

lab1545:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1548
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1546
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1547

lab1546:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1547:

lab1548:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1551
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1549
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1550

lab1549:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1550:

lab1551:
    jmp lab1553

lab1552:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1553:

lab1555:
    ; #load tag
    mov r13, 5
    ; let x14: List[Pair[i64, i64]] = Cons(x8, x13);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1567
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1568

lab1567:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1565
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1558
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1556
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1557

lab1556:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1557:

lab1558:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1561
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1559
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1560

lab1559:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1560:

lab1561:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1564
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1562
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1563

lab1562:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1563:

lab1564:
    jmp lab1566

lab1565:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1566:

lab1568:
    ; #load tag
    mov r11, 5
    ; let x15: List[Pair[i64, i64]] = Cons(x5, x14);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1580
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1581

lab1580:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1578
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1571
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1569
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1570

lab1569:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1570:

lab1571:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1574
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1572
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1573

lab1572:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1573:

lab1574:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1577
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1575
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1576

lab1575:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1576:

lab1577:
    jmp lab1579

lab1578:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1579:

lab1581:
    ; #load tag
    mov r9, 5
    ; let r9: List[Pair[i64, i64]] = Cons(x2, x15);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab1593
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1594

lab1593:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1591
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1584
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1582
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1583

lab1582:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1583:

lab1584:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1587
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1585
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1586

lab1585:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1586:

lab1587:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1590
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1588
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1589

lab1588:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1589:

lab1590:
    jmp lab1592

lab1591:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1592:

lab1594:
    ; #load tag
    mov rdi, 5
    ; lit x16 <- 8;
    mov r9, 8
    ; lit x17 <- 20;
    mov r11, 20
    ; let x18: Pair[i64, i64] = Tup(x16, x17);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1606
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1607

lab1606:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1604
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1597
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1595
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1596

lab1595:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1596:

lab1597:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1600
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1598
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1599

lab1598:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1599:

lab1600:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1603
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1601
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1602

lab1601:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1602:

lab1603:
    jmp lab1605

lab1604:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1605:

lab1607:
    ; #load tag
    mov r9, 0
    ; lit x19 <- 8;
    mov r11, 8
    ; lit x20 <- 28;
    mov r13, 28
    ; let x21: Pair[i64, i64] = Tup(x19, x20);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1619
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1620

lab1619:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1617
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1610
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1608
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1609

lab1608:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1609:

lab1610:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1613
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1611
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1612

lab1611:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1612:

lab1613:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1616
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1614
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1615

lab1614:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1615:

lab1616:
    jmp lab1618

lab1617:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1618:

lab1620:
    ; #load tag
    mov r11, 0
    ; lit x22 <- 8;
    mov r13, 8
    ; lit x23 <- 29;
    mov r15, 29
    ; let x24: Pair[i64, i64] = Tup(x22, x23);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov qword [rbx + 48], 0
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1632
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1633

lab1632:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1630
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1623
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1621
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1622

lab1621:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1622:

lab1623:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1626
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1624
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1625

lab1624:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1625:

lab1626:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1629
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1627
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1628

lab1627:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1628:

lab1629:
    jmp lab1631

lab1630:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1631:

lab1633:
    ; #load tag
    mov r13, 0
    ; lit x25 <- 8;
    mov r15, 8
    ; lit x26 <- 30;
    mov qword [rsp + 2024], 30
    ; let x27: Pair[i64, i64] = Tup(x25, x26);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov [rbx + 40], r15
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1645
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab1646

lab1645:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1643
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1636
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1634
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1635

lab1634:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1635:

lab1636:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1639
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1637
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1638

lab1637:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1638:

lab1639:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1642
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1640
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1641

lab1640:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1641:

lab1642:
    jmp lab1644

lab1643:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1644:

lab1646:
    ; #load tag
    mov r15, 0
    ; lit x28 <- 8;
    mov qword [rsp + 2024], 8
    ; lit x29 <- 31;
    mov qword [rsp + 2008], 31
    ; let x30: Pair[i64, i64] = Tup(x28, x29);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1658
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1659

lab1658:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1656
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1649
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1647
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1648

lab1647:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1648:

lab1649:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1652
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1650
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1651

lab1650:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1651:

lab1652:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1655
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1653
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1654

lab1653:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1654:

lab1655:
    jmp lab1657

lab1656:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1657:

lab1659:
    ; #load tag
    mov qword [rsp + 2024], 0
    ; lit x31 <- 8;
    mov qword [rsp + 2008], 8
    ; lit x32 <- 40;
    mov qword [rsp + 1992], 40
    ; let x33: Pair[i64, i64] = Tup(x31, x32);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2016], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1671
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1672

lab1671:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1669
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1662
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1660
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1661

lab1660:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1661:

lab1662:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1665
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1663
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1664

lab1663:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1664:

lab1665:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1668
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1666
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1667

lab1666:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1667:

lab1668:
    jmp lab1670

lab1669:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1670:

lab1672:
    ; #load tag
    mov qword [rsp + 2008], 0
    ; lit x34 <- 8;
    mov qword [rsp + 1992], 8
    ; lit x35 <- 41;
    mov qword [rsp + 1976], 41
    ; let x36: Pair[i64, i64] = Tup(x34, x35);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1976]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1992]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2000], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1684
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1685

lab1684:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1682
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1675
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1673
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1674

lab1673:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1674:

lab1675:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1678
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1676
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1677

lab1676:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1677:

lab1678:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1681
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1679
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1680

lab1679:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1680:

lab1681:
    jmp lab1683

lab1682:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1683:

lab1685:
    ; #load tag
    mov qword [rsp + 1992], 0
    ; substitute (a0 := a0)(x33 := x33)(x18 := x18)(x21 := x21)(x24 := x24)(x27 := x27)(x30 := x30)(x36 := x36)(r9 := r9);
    ; #move variables
    mov rcx, [rsp + 2016]
    mov [rsp + 2040], rcx
    mov rcx, [rsp + 2000]
    mov [rsp + 2016], rcx
    mov [rsp + 2000], rsi
    mov rsi, [rsp + 2040]
    mov rcx, [rsp + 2008]
    mov [rsp + 2040], rcx
    mov rcx, [rsp + 1992]
    mov [rsp + 2008], rcx
    mov [rsp + 1992], rdi
    mov rdi, [rsp + 2040]
    ; let x37: List[Pair[i64, i64]] = Cons(x36, r9);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2000]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2016], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1697
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1698

lab1697:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1695
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1688
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1686
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1687

lab1686:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1687:

lab1688:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1691
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1689
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1690

lab1689:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1690:

lab1691:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1694
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1692
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1693

lab1692:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1693:

lab1694:
    jmp lab1696

lab1695:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1696:

lab1698:
    ; #load tag
    mov qword [rsp + 2008], 5
    ; substitute (a0 := a0)(x30 := x30)(x18 := x18)(x21 := x21)(x24 := x24)(x27 := x27)(x33 := x33)(x37 := x37);
    ; #move variables
    mov rcx, [rsp + 2032]
    mov [rsp + 2032], rsi
    mov rsi, rcx
    mov rcx, [rsp + 2024]
    mov [rsp + 2024], rdi
    mov rdi, rcx
    ; let x38: List[Pair[i64, i64]] = Cons(x33, x37);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1710
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1711

lab1710:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1708
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1701
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1699
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1700

lab1699:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1700:

lab1701:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1704
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1702
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1703

lab1702:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1703:

lab1704:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1707
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1705
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1706

lab1705:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1706:

lab1707:
    jmp lab1709

lab1708:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1709:

lab1711:
    ; #load tag
    mov qword [rsp + 2024], 5
    ; substitute (a0 := a0)(x27 := x27)(x18 := x18)(x21 := x21)(x24 := x24)(x30 := x30)(x38 := x38);
    ; #move variables
    mov rcx, r14
    mov r14, rsi
    mov rsi, rcx
    mov rcx, r15
    mov r15, rdi
    mov rdi, rcx
    ; let x39: List[Pair[i64, i64]] = Cons(x30, x38);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1723
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab1724

lab1723:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1721
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1714
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1712
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1713

lab1712:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1713:

lab1714:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1717
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1715
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1716

lab1715:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1716:

lab1717:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1720
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1718
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1719

lab1718:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1719:

lab1720:
    jmp lab1722

lab1721:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1722:

lab1724:
    ; #load tag
    mov r15, 5
    ; substitute (a0 := a0)(x24 := x24)(x18 := x18)(x21 := x21)(x27 := x27)(x39 := x39);
    ; #move variables
    mov rcx, r12
    mov r12, rsi
    mov rsi, rcx
    mov rcx, r13
    mov r13, rdi
    mov rdi, rcx
    ; let x40: List[Pair[i64, i64]] = Cons(x27, x39);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1736
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1737

lab1736:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1734
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1727
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1725
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1726

lab1725:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1726:

lab1727:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1730
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1728
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1729

lab1728:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1729:

lab1730:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1733
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1731
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1732

lab1731:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1732:

lab1733:
    jmp lab1735

lab1734:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1735:

lab1737:
    ; #load tag
    mov r13, 5
    ; substitute (a0 := a0)(x21 := x21)(x18 := x18)(x24 := x24)(x40 := x40);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; let x41: List[Pair[i64, i64]] = Cons(x24, x40);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1749
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1750

lab1749:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1747
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1740
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1738
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1739

lab1738:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1739:

lab1740:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1743
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1741
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1742

lab1741:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1742:

lab1743:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1746
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1744
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1745

lab1744:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1745:

lab1746:
    jmp lab1748

lab1747:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1748:

lab1750:
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(x18 := x18)(x21 := x21)(x41 := x41);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; let x42: List[Pair[i64, i64]] = Cons(x21, x41);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1762
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1763

lab1762:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1760
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1753
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1751
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1752

lab1751:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1752:

lab1753:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1756
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1754
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1755

lab1754:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1755:

lab1756:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1759
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1757
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1758

lab1757:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1758:

lab1759:
    jmp lab1761

lab1760:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1761:

lab1763:
    ; #load tag
    mov r9, 5
    ; let r8: List[Pair[i64, i64]] = Cons(x18, x42);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab1775
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1776

lab1775:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1773
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1766
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1764
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1765

lab1764:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1765:

lab1766:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1769
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1767
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1768

lab1767:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1768:

lab1769:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1772
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1770
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1771

lab1770:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1771:

lab1772:
    jmp lab1774

lab1773:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1774:

lab1776:
    ; #load tag
    mov rdi, 5
    ; lit x43 <- 7;
    mov r9, 7
    ; lit x44 <- 19;
    mov r11, 19
    ; let x45: Pair[i64, i64] = Tup(x43, x44);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1788
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1789

lab1788:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1786
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1779
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1777
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1778

lab1777:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1778:

lab1779:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1782
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1780
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1781

lab1780:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1781:

lab1782:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1785
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1783
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1784

lab1783:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1784:

lab1785:
    jmp lab1787

lab1786:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1787:

lab1789:
    ; #load tag
    mov r9, 0
    ; lit x46 <- 7;
    mov r11, 7
    ; lit x47 <- 21;
    mov r13, 21
    ; let x48: Pair[i64, i64] = Tup(x46, x47);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1801
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1802

lab1801:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1799
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1792
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1790
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1791

lab1790:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1791:

lab1792:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1795
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1793
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1794

lab1793:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1794:

lab1795:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1798
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1796
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1797

lab1796:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1797:

lab1798:
    jmp lab1800

lab1799:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1800:

lab1802:
    ; #load tag
    mov r11, 0
    ; lit x49 <- 7;
    mov r13, 7
    ; lit x50 <- 28;
    mov r15, 28
    ; let x51: Pair[i64, i64] = Tup(x49, x50);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov qword [rbx + 48], 0
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1814
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1815

lab1814:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1812
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1805
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1803
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1804

lab1803:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1804:

lab1805:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1808
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1806
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1807

lab1806:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1807:

lab1808:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1811
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1809
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1810

lab1809:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1810:

lab1811:
    jmp lab1813

lab1812:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1813:

lab1815:
    ; #load tag
    mov r13, 0
    ; lit x52 <- 7;
    mov r15, 7
    ; lit x53 <- 31;
    mov qword [rsp + 2024], 31
    ; let x54: Pair[i64, i64] = Tup(x52, x53);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov [rbx + 40], r15
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1827
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab1828

lab1827:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1825
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1818
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1816
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1817

lab1816:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1817:

lab1818:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1821
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1819
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1820

lab1819:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1820:

lab1821:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1824
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1822
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1823

lab1822:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1823:

lab1824:
    jmp lab1826

lab1825:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1826:

lab1828:
    ; #load tag
    mov r15, 0
    ; lit x55 <- 7;
    mov qword [rsp + 2024], 7
    ; lit x56 <- 40;
    mov qword [rsp + 2008], 40
    ; let x57: Pair[i64, i64] = Tup(x55, x56);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1840
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1841

lab1840:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1838
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1831
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1829
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1830

lab1829:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1830:

lab1831:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1834
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1832
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1833

lab1832:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1833:

lab1834:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1837
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1835
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1836

lab1835:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1836:

lab1837:
    jmp lab1839

lab1838:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1839:

lab1841:
    ; #load tag
    mov qword [rsp + 2024], 0
    ; lit x58 <- 7;
    mov qword [rsp + 2008], 7
    ; lit x59 <- 41;
    mov qword [rsp + 1992], 41
    ; let x60: Pair[i64, i64] = Tup(x58, x59);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2016], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1853
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1854

lab1853:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1851
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1844
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1842
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1843

lab1842:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1843:

lab1844:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1847
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1845
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1846

lab1845:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1846:

lab1847:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1850
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1848
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1849

lab1848:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1849:

lab1850:
    jmp lab1852

lab1851:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1852:

lab1854:
    ; #load tag
    mov qword [rsp + 2008], 0
    ; substitute (a0 := a0)(x57 := x57)(x45 := x45)(x48 := x48)(x51 := x51)(x54 := x54)(x60 := x60)(r8 := r8);
    ; #move variables
    mov rcx, [rsp + 2032]
    mov [rsp + 2040], rcx
    mov rcx, [rsp + 2016]
    mov [rsp + 2032], rcx
    mov [rsp + 2016], rsi
    mov rsi, [rsp + 2040]
    mov rcx, [rsp + 2024]
    mov [rsp + 2040], rcx
    mov rcx, [rsp + 2008]
    mov [rsp + 2024], rcx
    mov [rsp + 2008], rdi
    mov rdi, [rsp + 2040]
    ; let x61: List[Pair[i64, i64]] = Cons(x60, r8);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1866
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1867

lab1866:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1864
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1857
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1855
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1856

lab1855:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1856:

lab1857:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1860
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1858
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1859

lab1858:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1859:

lab1860:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1863
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1861
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1862

lab1861:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1862:

lab1863:
    jmp lab1865

lab1864:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1865:

lab1867:
    ; #load tag
    mov qword [rsp + 2024], 5
    ; substitute (a0 := a0)(x54 := x54)(x45 := x45)(x48 := x48)(x51 := x51)(x57 := x57)(x61 := x61);
    ; #move variables
    mov rcx, r14
    mov r14, rsi
    mov rsi, rcx
    mov rcx, r15
    mov r15, rdi
    mov rdi, rcx
    ; let x62: List[Pair[i64, i64]] = Cons(x57, x61);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1879
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab1880

lab1879:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1877
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1870
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1868
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1869

lab1868:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1869:

lab1870:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1873
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1871
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1872

lab1871:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1872:

lab1873:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1876
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1874
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1875

lab1874:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1875:

lab1876:
    jmp lab1878

lab1877:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1878:

lab1880:
    ; #load tag
    mov r15, 5
    ; substitute (a0 := a0)(x51 := x51)(x45 := x45)(x48 := x48)(x54 := x54)(x62 := x62);
    ; #move variables
    mov rcx, r12
    mov r12, rsi
    mov rsi, rcx
    mov rcx, r13
    mov r13, rdi
    mov rdi, rcx
    ; let x63: List[Pair[i64, i64]] = Cons(x54, x62);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1892
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1893

lab1892:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1890
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1883
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1881
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1882

lab1881:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1882:

lab1883:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1886
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1884
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1885

lab1884:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1885:

lab1886:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1889
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1887
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1888

lab1887:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1888:

lab1889:
    jmp lab1891

lab1890:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1891:

lab1893:
    ; #load tag
    mov r13, 5
    ; substitute (a0 := a0)(x48 := x48)(x45 := x45)(x51 := x51)(x63 := x63);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; let x64: List[Pair[i64, i64]] = Cons(x51, x63);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1905
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1906

lab1905:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1903
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1896
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1894
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1895

lab1894:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1895:

lab1896:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1899
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1897
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1898

lab1897:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1898:

lab1899:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1902
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1900
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1901

lab1900:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1901:

lab1902:
    jmp lab1904

lab1903:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1904:

lab1906:
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(x45 := x45)(x48 := x48)(x64 := x64);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; let x65: List[Pair[i64, i64]] = Cons(x48, x64);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1918
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1919

lab1918:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1916
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1909
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1907
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1908

lab1907:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1908:

lab1909:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1912
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1910
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1911

lab1910:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1911:

lab1912:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1915
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1913
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1914

lab1913:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1914:

lab1915:
    jmp lab1917

lab1916:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1917:

lab1919:
    ; #load tag
    mov r9, 5
    ; let r7: List[Pair[i64, i64]] = Cons(x45, x65);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab1931
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1932

lab1931:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1929
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1922
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1920
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1921

lab1920:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1921:

lab1922:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1925
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1923
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1924

lab1923:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1924:

lab1925:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1928
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1926
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1927

lab1926:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1927:

lab1928:
    jmp lab1930

lab1929:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1930:

lab1932:
    ; #load tag
    mov rdi, 5
    ; lit x66 <- 6;
    mov r9, 6
    ; lit x67 <- 7;
    mov r11, 7
    ; let x68: Pair[i64, i64] = Tup(x66, x67);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1944
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1945

lab1944:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1942
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1935
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1933
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1934

lab1933:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1934:

lab1935:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1938
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1936
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1937

lab1936:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1937:

lab1938:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1941
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1939
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1940

lab1939:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1940:

lab1941:
    jmp lab1943

lab1942:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1943:

lab1945:
    ; #load tag
    mov r9, 0
    ; lit x69 <- 6;
    mov r11, 6
    ; lit x70 <- 8;
    mov r13, 8
    ; let x71: Pair[i64, i64] = Tup(x69, x70);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1957
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1958

lab1957:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1955
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1948
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1946
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1947

lab1946:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1947:

lab1948:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1951
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1949
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1950

lab1949:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1950:

lab1951:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1954
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1952
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1953

lab1952:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1953:

lab1954:
    jmp lab1956

lab1955:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1956:

lab1958:
    ; #load tag
    mov r11, 0
    ; lit x72 <- 6;
    mov r13, 6
    ; lit x73 <- 18;
    mov r15, 18
    ; let x74: Pair[i64, i64] = Tup(x72, x73);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov qword [rbx + 48], 0
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1970
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1971

lab1970:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1968
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1961
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1959
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1960

lab1959:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1960:

lab1961:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1964
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1962
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1963

lab1962:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1963:

lab1964:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1967
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1965
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1966

lab1965:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1966:

lab1967:
    jmp lab1969

lab1968:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1969:

lab1971:
    ; #load tag
    mov r13, 0
    ; lit x75 <- 6;
    mov r15, 6
    ; lit x76 <- 22;
    mov qword [rsp + 2024], 22
    ; let x77: Pair[i64, i64] = Tup(x75, x76);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov [rbx + 40], r15
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1983
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab1984

lab1983:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1981
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1974
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1972
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1973

lab1972:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1973:

lab1974:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1977
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1975
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1976

lab1975:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1976:

lab1977:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1980
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1978
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1979

lab1978:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1979:

lab1980:
    jmp lab1982

lab1981:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1982:

lab1984:
    ; #load tag
    mov r15, 0
    ; lit x78 <- 6;
    mov qword [rsp + 2024], 6
    ; lit x79 <- 23;
    mov qword [rsp + 2008], 23
    ; let x80: Pair[i64, i64] = Tup(x78, x79);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1996
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1997

lab1996:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1994
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1987
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1985
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1986

lab1985:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1986:

lab1987:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1990
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1988
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1989

lab1988:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1989:

lab1990:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1993
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1991
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1992

lab1991:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1992:

lab1993:
    jmp lab1995

lab1994:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1995:

lab1997:
    ; #load tag
    mov qword [rsp + 2024], 0
    ; lit x81 <- 6;
    mov qword [rsp + 2008], 6
    ; lit x82 <- 28;
    mov qword [rsp + 1992], 28
    ; let x83: Pair[i64, i64] = Tup(x81, x82);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2016], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2009
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2010

lab2009:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2007
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2000
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1998
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1999

lab1998:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1999:

lab2000:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2003
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2001
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2002

lab2001:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2002:

lab2003:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2006
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2004
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2005

lab2004:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2005:

lab2006:
    jmp lab2008

lab2007:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2008:

lab2010:
    ; #load tag
    mov qword [rsp + 2008], 0
    ; lit x84 <- 6;
    mov qword [rsp + 1992], 6
    ; lit x85 <- 29;
    mov qword [rsp + 1976], 29
    ; let x86: Pair[i64, i64] = Tup(x84, x85);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1976]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1992]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2000], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2022
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2023

lab2022:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2020
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2013
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2011
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2012

lab2011:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2012:

lab2013:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2016
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2014
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2015

lab2014:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2015:

lab2016:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2019
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2017
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2018

lab2017:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2018:

lab2019:
    jmp lab2021

lab2020:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2021:

lab2023:
    ; #load tag
    mov qword [rsp + 1992], 0
    ; lit x87 <- 6;
    mov qword [rsp + 1976], 6
    ; lit x88 <- 30;
    mov qword [rsp + 1960], 30
    ; let x89: Pair[i64, i64] = Tup(x87, x88);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1960]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1976]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 1984], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2035
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2036

lab2035:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2033
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2026
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2024
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2025

lab2024:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2025:

lab2026:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2029
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2027
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2028

lab2027:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2028:

lab2029:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2032
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2030
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2031

lab2030:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2031:

lab2032:
    jmp lab2034

lab2033:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2034:

lab2036:
    ; #load tag
    mov qword [rsp + 1976], 0
    ; lit x90 <- 6;
    mov qword [rsp + 1960], 6
    ; lit x91 <- 31;
    mov qword [rsp + 1944], 31
    ; let x92: Pair[i64, i64] = Tup(x90, x91);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1944]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1960]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 1968], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2048
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2049

lab2048:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2046
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2039
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2037
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2038

lab2037:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2038:

lab2039:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2042
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2040
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2041

lab2040:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2041:

lab2042:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2045
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2043
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2044

lab2043:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2044:

lab2045:
    jmp lab2047

lab2046:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2047:

lab2049:
    ; #load tag
    mov qword [rsp + 1960], 0
    ; lit x93 <- 6;
    mov qword [rsp + 1944], 6
    ; lit x94 <- 36;
    mov qword [rsp + 1928], 36
    ; let x95: Pair[i64, i64] = Tup(x93, x94);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1928]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1944]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 1952], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2061
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2062

lab2061:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2059
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2052
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2050
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2051

lab2050:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2051:

lab2052:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2055
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2053
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2054

lab2053:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2054:

lab2055:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2058
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2056
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2057

lab2056:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2057:

lab2058:
    jmp lab2060

lab2059:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2060:

lab2062:
    ; #load tag
    mov qword [rsp + 1944], 0
    ; substitute (a0 := a0)(x92 := x92)(x68 := x68)(x71 := x71)(x74 := x74)(x77 := x77)(x80 := x80)(x83 := x83)(x86 := x86)(x89 := x89)(x95 := x95)(r7 := r7);
    ; #move variables
    mov rcx, [rsp + 1968]
    mov [rsp + 2040], rcx
    mov rcx, [rsp + 1952]
    mov [rsp + 1968], rcx
    mov [rsp + 1952], rsi
    mov rsi, [rsp + 2040]
    mov rcx, [rsp + 1960]
    mov [rsp + 2040], rcx
    mov rcx, [rsp + 1944]
    mov [rsp + 1960], rcx
    mov [rsp + 1944], rdi
    mov rdi, [rsp + 2040]
    ; let x96: List[Pair[i64, i64]] = Cons(x95, r7);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1944]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 1952]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 1960]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 1968]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 1968], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2074
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2075

lab2074:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2072
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2065
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2063
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2064

lab2063:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2064:

lab2065:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2068
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2066
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2067

lab2066:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2067:

lab2068:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2071
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2069
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2070

lab2069:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2070:

lab2071:
    jmp lab2073

lab2072:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2073:

lab2075:
    ; #load tag
    mov qword [rsp + 1960], 5
    ; substitute (a0 := a0)(x89 := x89)(x68 := x68)(x71 := x71)(x74 := x74)(x77 := x77)(x80 := x80)(x83 := x83)(x86 := x86)(x92 := x92)(x96 := x96);
    ; #move variables
    mov rcx, [rsp + 1984]
    mov [rsp + 1984], rsi
    mov rsi, rcx
    mov rcx, [rsp + 1976]
    mov [rsp + 1976], rdi
    mov rdi, rcx
    ; let x97: List[Pair[i64, i64]] = Cons(x92, x96);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1960]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 1968]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 1976]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 1984]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 1984], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2087
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2088

lab2087:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2085
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2078
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2076
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2077

lab2076:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2077:

lab2078:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2081
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2079
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2080

lab2079:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2080:

lab2081:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2084
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2082
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2083

lab2082:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2083:

lab2084:
    jmp lab2086

lab2085:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2086:

lab2088:
    ; #load tag
    mov qword [rsp + 1976], 5
    ; substitute (a0 := a0)(x86 := x86)(x68 := x68)(x71 := x71)(x74 := x74)(x77 := x77)(x80 := x80)(x83 := x83)(x89 := x89)(x97 := x97);
    ; #move variables
    mov rcx, [rsp + 2000]
    mov [rsp + 2000], rsi
    mov rsi, rcx
    mov rcx, [rsp + 1992]
    mov [rsp + 1992], rdi
    mov rdi, rcx
    ; let x98: List[Pair[i64, i64]] = Cons(x89, x97);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1976]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 1984]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 1992]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2000]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2000], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2100
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2101

lab2100:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2098
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2091
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2089
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2090

lab2089:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2090:

lab2091:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2094
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2092
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2093

lab2092:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2093:

lab2094:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2097
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2095
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2096

lab2095:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2096:

lab2097:
    jmp lab2099

lab2098:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2099:

lab2101:
    ; #load tag
    mov qword [rsp + 1992], 5
    ; substitute (a0 := a0)(x83 := x83)(x68 := x68)(x71 := x71)(x74 := x74)(x77 := x77)(x80 := x80)(x86 := x86)(x98 := x98);
    ; #move variables
    mov rcx, [rsp + 2016]
    mov [rsp + 2016], rsi
    mov rsi, rcx
    mov rcx, [rsp + 2008]
    mov [rsp + 2008], rdi
    mov rdi, rcx
    ; let x99: List[Pair[i64, i64]] = Cons(x86, x98);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2000]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2016], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2113
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2114

lab2113:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2111
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2104
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2102
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2103

lab2102:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2103:

lab2104:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2107
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2105
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2106

lab2105:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2106:

lab2107:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2110
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2108
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2109

lab2108:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2109:

lab2110:
    jmp lab2112

lab2111:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2112:

lab2114:
    ; #load tag
    mov qword [rsp + 2008], 5
    ; substitute (a0 := a0)(x80 := x80)(x68 := x68)(x71 := x71)(x74 := x74)(x77 := x77)(x83 := x83)(x99 := x99);
    ; #move variables
    mov rcx, [rsp + 2032]
    mov [rsp + 2032], rsi
    mov rsi, rcx
    mov rcx, [rsp + 2024]
    mov [rsp + 2024], rdi
    mov rdi, rcx
    ; let x100: List[Pair[i64, i64]] = Cons(x83, x99);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2126
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2127

lab2126:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2124
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2117
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2115
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2116

lab2115:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2116:

lab2117:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2120
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2118
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2119

lab2118:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2119:

lab2120:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2123
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2121
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2122

lab2121:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2122:

lab2123:
    jmp lab2125

lab2124:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2125:

lab2127:
    ; #load tag
    mov qword [rsp + 2024], 5
    ; substitute (a0 := a0)(x77 := x77)(x68 := x68)(x71 := x71)(x74 := x74)(x80 := x80)(x100 := x100);
    ; #move variables
    mov rcx, r14
    mov r14, rsi
    mov rsi, rcx
    mov rcx, r15
    mov r15, rdi
    mov rdi, rcx
    ; let x101: List[Pair[i64, i64]] = Cons(x80, x100);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2139
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab2140

lab2139:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2137
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2130
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2128
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2129

lab2128:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2129:

lab2130:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2133
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2131
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2132

lab2131:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2132:

lab2133:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2136
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2134
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2135

lab2134:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2135:

lab2136:
    jmp lab2138

lab2137:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2138:

lab2140:
    ; #load tag
    mov r15, 5
    ; substitute (a0 := a0)(x74 := x74)(x68 := x68)(x71 := x71)(x77 := x77)(x101 := x101);
    ; #move variables
    mov rcx, r12
    mov r12, rsi
    mov rsi, rcx
    mov rcx, r13
    mov r13, rdi
    mov rdi, rcx
    ; let x102: List[Pair[i64, i64]] = Cons(x77, x101);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2152
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2153

lab2152:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2150
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2143
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2141
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2142

lab2141:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2142:

lab2143:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2146
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2144
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2145

lab2144:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2145:

lab2146:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2149
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2147
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2148

lab2147:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2148:

lab2149:
    jmp lab2151

lab2150:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2151:

lab2153:
    ; #load tag
    mov r13, 5
    ; substitute (a0 := a0)(x71 := x71)(x68 := x68)(x74 := x74)(x102 := x102);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; let x103: List[Pair[i64, i64]] = Cons(x74, x102);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2165
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2166

lab2165:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2163
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2156
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2154
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2155

lab2154:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2155:

lab2156:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2159
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2157
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2158

lab2157:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2158:

lab2159:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2162
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2160
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2161

lab2160:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2161:

lab2162:
    jmp lab2164

lab2163:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2164:

lab2166:
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(x68 := x68)(x71 := x71)(x103 := x103);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; let x104: List[Pair[i64, i64]] = Cons(x71, x103);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2178
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2179

lab2178:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2176
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2169
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2167
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2168

lab2167:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2168:

lab2169:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2172
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2170
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2171

lab2170:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2171:

lab2172:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2175
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2173
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2174

lab2173:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2174:

lab2175:
    jmp lab2177

lab2176:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2177:

lab2179:
    ; #load tag
    mov r9, 5
    ; let r6: List[Pair[i64, i64]] = Cons(x68, x104);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab2191
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2192

lab2191:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2189
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2182
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2180
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2181

lab2180:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2181:

lab2182:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2185
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2183
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2184

lab2183:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2184:

lab2185:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2188
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2186
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2187

lab2186:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2187:

lab2188:
    jmp lab2190

lab2189:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2190:

lab2192:
    ; #load tag
    mov rdi, 5
    ; lit x105 <- 5;
    mov r9, 5
    ; lit x106 <- 7;
    mov r11, 7
    ; let x107: Pair[i64, i64] = Tup(x105, x106);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2204
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2205

lab2204:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2202
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2195
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2193
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2194

lab2193:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2194:

lab2195:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2198
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2196
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2197

lab2196:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2197:

lab2198:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2201
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2199
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2200

lab2199:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2200:

lab2201:
    jmp lab2203

lab2202:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2203:

lab2205:
    ; #load tag
    mov r9, 0
    ; lit x108 <- 5;
    mov r11, 5
    ; lit x109 <- 8;
    mov r13, 8
    ; let x110: Pair[i64, i64] = Tup(x108, x109);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2217
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2218

lab2217:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2215
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2208
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2206
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2207

lab2206:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2207:

lab2208:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2211
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2209
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2210

lab2209:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2210:

lab2211:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2214
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2212
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2213

lab2212:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2213:

lab2214:
    jmp lab2216

lab2215:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2216:

lab2218:
    ; #load tag
    mov r11, 0
    ; lit x111 <- 5;
    mov r13, 5
    ; lit x112 <- 18;
    mov r15, 18
    ; let x113: Pair[i64, i64] = Tup(x111, x112);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov qword [rbx + 48], 0
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2230
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2231

lab2230:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2228
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2221
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2219
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2220

lab2219:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2220:

lab2221:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2224
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2222
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2223

lab2222:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2223:

lab2224:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2227
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2225
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2226

lab2225:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2226:

lab2227:
    jmp lab2229

lab2228:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2229:

lab2231:
    ; #load tag
    mov r13, 0
    ; lit x114 <- 5;
    mov r15, 5
    ; lit x115 <- 22;
    mov qword [rsp + 2024], 22
    ; let x116: Pair[i64, i64] = Tup(x114, x115);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov [rbx + 40], r15
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2243
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab2244

lab2243:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2241
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2234
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2232
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2233

lab2232:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2233:

lab2234:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2237
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2235
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2236

lab2235:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2236:

lab2237:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2240
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2238
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2239

lab2238:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2239:

lab2240:
    jmp lab2242

lab2241:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2242:

lab2244:
    ; #load tag
    mov r15, 0
    ; lit x117 <- 5;
    mov qword [rsp + 2024], 5
    ; lit x118 <- 23;
    mov qword [rsp + 2008], 23
    ; let x119: Pair[i64, i64] = Tup(x117, x118);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2256
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2257

lab2256:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2254
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2247
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2245
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2246

lab2245:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2246:

lab2247:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2250
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2248
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2249

lab2248:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2249:

lab2250:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2253
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2251
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2252

lab2251:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2252:

lab2253:
    jmp lab2255

lab2254:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2255:

lab2257:
    ; #load tag
    mov qword [rsp + 2024], 0
    ; lit x120 <- 5;
    mov qword [rsp + 2008], 5
    ; lit x121 <- 29;
    mov qword [rsp + 1992], 29
    ; let x122: Pair[i64, i64] = Tup(x120, x121);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2016], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2269
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2270

lab2269:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2267
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2260
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2258
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2259

lab2258:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2259:

lab2260:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2263
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2261
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2262

lab2261:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2262:

lab2263:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2266
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2264
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2265

lab2264:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2265:

lab2266:
    jmp lab2268

lab2267:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2268:

lab2270:
    ; #load tag
    mov qword [rsp + 2008], 0
    ; lit x123 <- 5;
    mov qword [rsp + 1992], 5
    ; lit x124 <- 30;
    mov qword [rsp + 1976], 30
    ; let x125: Pair[i64, i64] = Tup(x123, x124);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1976]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1992]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2000], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2282
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2283

lab2282:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2280
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2273
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2271
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2272

lab2271:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2272:

lab2273:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2276
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2274
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2275

lab2274:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2275:

lab2276:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2279
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2277
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2278

lab2277:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2278:

lab2279:
    jmp lab2281

lab2280:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2281:

lab2283:
    ; #load tag
    mov qword [rsp + 1992], 0
    ; lit x126 <- 5;
    mov qword [rsp + 1976], 5
    ; lit x127 <- 31;
    mov qword [rsp + 1960], 31
    ; let x128: Pair[i64, i64] = Tup(x126, x127);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1960]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1976]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 1984], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2295
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2296

lab2295:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2293
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2286
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2284
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2285

lab2284:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2285:

lab2286:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2289
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2287
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2288

lab2287:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2288:

lab2289:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2292
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2290
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2291

lab2290:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2291:

lab2292:
    jmp lab2294

lab2293:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2294:

lab2296:
    ; #load tag
    mov qword [rsp + 1976], 0
    ; lit x129 <- 5;
    mov qword [rsp + 1960], 5
    ; lit x130 <- 32;
    mov qword [rsp + 1944], 32
    ; let x131: Pair[i64, i64] = Tup(x129, x130);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1944]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1960]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 1968], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2308
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2309

lab2308:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2306
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2299
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2297
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2298

lab2297:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2298:

lab2299:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2302
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2300
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2301

lab2300:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2301:

lab2302:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2305
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2303
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2304

lab2303:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2304:

lab2305:
    jmp lab2307

lab2306:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2307:

lab2309:
    ; #load tag
    mov qword [rsp + 1960], 0
    ; lit x132 <- 5;
    mov qword [rsp + 1944], 5
    ; lit x133 <- 36;
    mov qword [rsp + 1928], 36
    ; let x134: Pair[i64, i64] = Tup(x132, x133);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1928]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 1944]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 1952], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2321
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2322

lab2321:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2319
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2312
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2310
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2311

lab2310:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2311:

lab2312:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2315
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2313
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2314

lab2313:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2314:

lab2315:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2318
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2316
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2317

lab2316:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2317:

lab2318:
    jmp lab2320

lab2319:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2320:

lab2322:
    ; #load tag
    mov qword [rsp + 1944], 0
    ; substitute (a0 := a0)(x131 := x131)(x107 := x107)(x110 := x110)(x113 := x113)(x116 := x116)(x119 := x119)(x122 := x122)(x125 := x125)(x128 := x128)(x134 := x134)(r6 := r6);
    ; #move variables
    mov rcx, [rsp + 1968]
    mov [rsp + 2040], rcx
    mov rcx, [rsp + 1952]
    mov [rsp + 1968], rcx
    mov [rsp + 1952], rsi
    mov rsi, [rsp + 2040]
    mov rcx, [rsp + 1960]
    mov [rsp + 2040], rcx
    mov rcx, [rsp + 1944]
    mov [rsp + 1960], rcx
    mov [rsp + 1944], rdi
    mov rdi, [rsp + 2040]
    ; let x135: List[Pair[i64, i64]] = Cons(x134, r6);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1944]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 1952]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 1960]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 1968]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 1968], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2334
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2335

lab2334:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2332
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2325
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2323
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2324

lab2323:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2324:

lab2325:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2328
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2326
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2327

lab2326:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2327:

lab2328:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2331
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2329
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2330

lab2329:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2330:

lab2331:
    jmp lab2333

lab2332:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2333:

lab2335:
    ; #load tag
    mov qword [rsp + 1960], 5
    ; substitute (a0 := a0)(x128 := x128)(x107 := x107)(x110 := x110)(x113 := x113)(x116 := x116)(x119 := x119)(x122 := x122)(x125 := x125)(x131 := x131)(x135 := x135);
    ; #move variables
    mov rcx, [rsp + 1984]
    mov [rsp + 1984], rsi
    mov rsi, rcx
    mov rcx, [rsp + 1976]
    mov [rsp + 1976], rdi
    mov rdi, rcx
    ; let x136: List[Pair[i64, i64]] = Cons(x131, x135);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1960]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 1968]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 1976]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 1984]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 1984], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2347
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2348

lab2347:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2345
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2338
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2336
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2337

lab2336:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2337:

lab2338:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2341
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2339
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2340

lab2339:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2340:

lab2341:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2344
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2342
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2343

lab2342:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2343:

lab2344:
    jmp lab2346

lab2345:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2346:

lab2348:
    ; #load tag
    mov qword [rsp + 1976], 5
    ; substitute (a0 := a0)(x125 := x125)(x107 := x107)(x110 := x110)(x113 := x113)(x116 := x116)(x119 := x119)(x122 := x122)(x128 := x128)(x136 := x136);
    ; #move variables
    mov rcx, [rsp + 2000]
    mov [rsp + 2000], rsi
    mov rsi, rcx
    mov rcx, [rsp + 1992]
    mov [rsp + 1992], rdi
    mov rdi, rcx
    ; let x137: List[Pair[i64, i64]] = Cons(x128, x136);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1976]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 1984]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 1992]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2000]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2000], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2360
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2361

lab2360:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2358
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2351
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2349
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2350

lab2349:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2350:

lab2351:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2354
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2352
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2353

lab2352:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2353:

lab2354:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2357
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2355
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2356

lab2355:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2356:

lab2357:
    jmp lab2359

lab2358:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2359:

lab2361:
    ; #load tag
    mov qword [rsp + 1992], 5
    ; substitute (a0 := a0)(x122 := x122)(x107 := x107)(x110 := x110)(x113 := x113)(x116 := x116)(x119 := x119)(x125 := x125)(x137 := x137);
    ; #move variables
    mov rcx, [rsp + 2016]
    mov [rsp + 2016], rsi
    mov rsi, rcx
    mov rcx, [rsp + 2008]
    mov [rsp + 2008], rdi
    mov rdi, rcx
    ; let x138: List[Pair[i64, i64]] = Cons(x125, x137);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 1992]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2000]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2008]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2016], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2373
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2374

lab2373:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2371
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2364
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2362
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2363

lab2362:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2363:

lab2364:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2367
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2365
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2366

lab2365:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2366:

lab2367:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2370
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2368
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2369

lab2368:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2369:

lab2370:
    jmp lab2372

lab2371:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2372:

lab2374:
    ; #load tag
    mov qword [rsp + 2008], 5
    ; substitute (a0 := a0)(x119 := x119)(x107 := x107)(x110 := x110)(x113 := x113)(x116 := x116)(x122 := x122)(x138 := x138);
    ; #move variables
    mov rcx, [rsp + 2032]
    mov [rsp + 2032], rsi
    mov rsi, rcx
    mov rcx, [rsp + 2024]
    mov [rsp + 2024], rdi
    mov rdi, rcx
    ; let x139: List[Pair[i64, i64]] = Cons(x122, x138);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 32], rcx
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rcx, rbx
    mov [rsp + 2032], rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2386
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2387

lab2386:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2384
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2377
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2375
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2376

lab2375:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2376:

lab2377:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2380
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2378
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2379

lab2378:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2379:

lab2380:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2383
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2381
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2382

lab2381:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2382:

lab2383:
    jmp lab2385

lab2384:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2385:

lab2387:
    ; #load tag
    mov qword [rsp + 2024], 5
    ; substitute (a0 := a0)(x116 := x116)(x107 := x107)(x110 := x110)(x113 := x113)(x119 := x119)(x139 := x139);
    ; #move variables
    mov rcx, r14
    mov r14, rsi
    mov rsi, rcx
    mov rcx, r15
    mov r15, rdi
    mov rdi, rcx
    ; let x140: List[Pair[i64, i64]] = Cons(x119, x139);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    mov [rbx + 40], r15
    mov [rbx + 32], r14
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2399
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab2400

lab2399:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2397
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2390
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2388
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2389

lab2388:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2389:

lab2390:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2393
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2391
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2392

lab2391:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2392:

lab2393:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2396
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2394
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2395

lab2394:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2395:

lab2396:
    jmp lab2398

lab2397:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2398:

lab2400:
    ; #load tag
    mov r15, 5
    ; substitute (a0 := a0)(x113 := x113)(x107 := x107)(x110 := x110)(x116 := x116)(x140 := x140);
    ; #move variables
    mov rcx, r12
    mov r12, rsi
    mov rsi, rcx
    mov rcx, r13
    mov r13, rdi
    mov rdi, rcx
    ; let x141: List[Pair[i64, i64]] = Cons(x116, x140);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2412
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2413

lab2412:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2410
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2403
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2401
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2402

lab2401:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2402:

lab2403:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2406
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2404
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2405

lab2404:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2405:

lab2406:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2409
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2407
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2408

lab2407:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2408:

lab2409:
    jmp lab2411

lab2410:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2411:

lab2413:
    ; #load tag
    mov r13, 5
    ; substitute (a0 := a0)(x110 := x110)(x107 := x107)(x113 := x113)(x141 := x141);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; let x142: List[Pair[i64, i64]] = Cons(x113, x141);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2425
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2426

lab2425:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2423
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2416
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2414
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2415

lab2414:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2415:

lab2416:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2419
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2417
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2418

lab2417:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2418:

lab2419:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2422
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2420
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2421

lab2420:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2421:

lab2422:
    jmp lab2424

lab2423:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2424:

lab2426:
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(x107 := x107)(x110 := x110)(x142 := x142);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; let x143: List[Pair[i64, i64]] = Cons(x110, x142);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2438
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2439

lab2438:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2436
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2429
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2427
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2428

lab2427:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2428:

lab2429:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2432
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2430
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2431

lab2430:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2431:

lab2432:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2435
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2433
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2434

lab2433:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2434:

lab2435:
    jmp lab2437

lab2436:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2437:

lab2439:
    ; #load tag
    mov r9, 5
    ; let r5: List[Pair[i64, i64]] = Cons(x107, x143);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab2451
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2452

lab2451:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2449
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2442
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2440
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2441

lab2440:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2441:

lab2442:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2445
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2443
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2444

lab2443:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2444:

lab2445:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2448
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2446
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2447

lab2446:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2447:

lab2448:
    jmp lab2450

lab2449:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2450:

lab2452:
    ; #load tag
    mov rdi, 5
    ; lit x144 <- 4;
    mov r9, 4
    ; lit x145 <- 18;
    mov r11, 18
    ; let x146: Pair[i64, i64] = Tup(x144, x145);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2464
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2465

lab2464:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2462
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2455
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2453
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2454

lab2453:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2454:

lab2455:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2458
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2456
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2457

lab2456:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2457:

lab2458:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2461
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2459
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2460

lab2459:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2460:

lab2461:
    jmp lab2463

lab2462:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2463:

lab2465:
    ; #load tag
    mov r9, 0
    ; lit x147 <- 4;
    mov r11, 4
    ; lit x148 <- 22;
    mov r13, 22
    ; let x149: Pair[i64, i64] = Tup(x147, x148);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2477
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2478

lab2477:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2475
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2468
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2466
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2467

lab2466:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2467:

lab2468:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2471
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2469
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2470

lab2469:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2470:

lab2471:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2474
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2472
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2473

lab2472:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2473:

lab2474:
    jmp lab2476

lab2475:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2476:

lab2478:
    ; #load tag
    mov r11, 0
    ; lit x150 <- 4;
    mov r13, 4
    ; lit x151 <- 23;
    mov r15, 23
    ; let x152: Pair[i64, i64] = Tup(x150, x151);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov qword [rbx + 48], 0
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2490
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2491

lab2490:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2488
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2481
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2479
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2480

lab2479:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2480:

lab2481:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2484
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2482
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2483

lab2482:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2483:

lab2484:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2487
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2485
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2486

lab2485:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2486:

lab2487:
    jmp lab2489

lab2488:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2489:

lab2491:
    ; #load tag
    mov r13, 0
    ; lit x153 <- 4;
    mov r15, 4
    ; lit x154 <- 32;
    mov qword [rsp + 2024], 32
    ; let x155: Pair[i64, i64] = Tup(x153, x154);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov [rbx + 40], r15
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2503
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab2504

lab2503:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2501
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2494
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2492
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2493

lab2492:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2493:

lab2494:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2497
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2495
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2496

lab2495:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2496:

lab2497:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2500
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2498
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2499

lab2498:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2499:

lab2500:
    jmp lab2502

lab2501:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2502:

lab2504:
    ; #load tag
    mov r15, 0
    ; substitute (a0 := a0)(x152 := x152)(x146 := x146)(x149 := x149)(x155 := x155)(r5 := r5);
    ; #move variables
    mov rcx, r12
    mov r12, r14
    mov r14, rsi
    mov rsi, rcx
    mov rcx, r13
    mov r13, r15
    mov r15, rdi
    mov rdi, rcx
    ; let x156: List[Pair[i64, i64]] = Cons(x155, r5);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2516
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2517

lab2516:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2514
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2507
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2505
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2506

lab2505:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2506:

lab2507:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2510
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2508
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2509

lab2508:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2509:

lab2510:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2513
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2511
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2512

lab2511:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2512:

lab2513:
    jmp lab2515

lab2514:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2515:

lab2517:
    ; #load tag
    mov r13, 5
    ; substitute (a0 := a0)(x149 := x149)(x146 := x146)(x152 := x152)(x156 := x156);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; let x157: List[Pair[i64, i64]] = Cons(x152, x156);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2529
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2530

lab2529:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2527
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2520
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2518
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2519

lab2518:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2519:

lab2520:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2523
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2521
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2522

lab2521:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2522:

lab2523:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2526
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2524
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2525

lab2524:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2525:

lab2526:
    jmp lab2528

lab2527:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2528:

lab2530:
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(x146 := x146)(x149 := x149)(x157 := x157);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; let x158: List[Pair[i64, i64]] = Cons(x149, x157);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2542
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2543

lab2542:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2540
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2533
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2531
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2532

lab2531:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2532:

lab2533:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2536
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2534
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2535

lab2534:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2535:

lab2536:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2539
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2537
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2538

lab2537:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2538:

lab2539:
    jmp lab2541

lab2540:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2541:

lab2543:
    ; #load tag
    mov r9, 5
    ; let r4: List[Pair[i64, i64]] = Cons(x146, x158);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab2555
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2556

lab2555:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2553
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2546
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2544
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2545

lab2544:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2545:

lab2546:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2549
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2547
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2548

lab2547:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2548:

lab2549:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2552
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2550
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2551

lab2550:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2551:

lab2552:
    jmp lab2554

lab2553:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2554:

lab2556:
    ; #load tag
    mov rdi, 5
    ; lit x159 <- 3;
    mov r9, 3
    ; lit x160 <- 19;
    mov r11, 19
    ; let x161: Pair[i64, i64] = Tup(x159, x160);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2568
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2569

lab2568:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2566
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2559
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2557
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2558

lab2557:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2558:

lab2559:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2562
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2560
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2561

lab2560:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2561:

lab2562:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2565
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2563
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2564

lab2563:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2564:

lab2565:
    jmp lab2567

lab2566:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2567:

lab2569:
    ; #load tag
    mov r9, 0
    ; lit x162 <- 3;
    mov r11, 3
    ; lit x163 <- 21;
    mov r13, 21
    ; let x164: Pair[i64, i64] = Tup(x162, x163);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2581
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2582

lab2581:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2579
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2572
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2570
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2571

lab2570:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2571:

lab2572:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2575
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2573
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2574

lab2573:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2574:

lab2575:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2578
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2576
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2577

lab2576:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2577:

lab2578:
    jmp lab2580

lab2579:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2580:

lab2582:
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(x161 := x161)(x164 := x164)(r4 := r4);
    ; #move variables
    mov rcx, r8
    mov r8, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, r11
    mov r11, rdi
    mov rdi, rcx
    ; let x165: List[Pair[i64, i64]] = Cons(x164, r4);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2594
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2595

lab2594:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2592
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2585
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2583
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2584

lab2583:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2584:

lab2585:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2588
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2586
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2587

lab2586:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2587:

lab2588:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2591
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2589
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2590

lab2589:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2590:

lab2591:
    jmp lab2593

lab2592:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2593:

lab2595:
    ; #load tag
    mov r9, 5
    ; let r3: List[Pair[i64, i64]] = Cons(x161, x165);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab2607
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2608

lab2607:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2605
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2598
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2596
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2597

lab2596:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2597:

lab2598:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2601
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2599
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2600

lab2599:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2600:

lab2601:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2604
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2602
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2603

lab2602:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2603:

lab2604:
    jmp lab2606

lab2605:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2606:

lab2608:
    ; #load tag
    mov rdi, 5
    ; lit x166 <- 2;
    mov r9, 2
    ; lit x167 <- 20;
    mov r11, 20
    ; let x168: Pair[i64, i64] = Tup(x166, x167);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2620
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2621

lab2620:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2618
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2611
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2609
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2610

lab2609:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2610:

lab2611:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2614
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2612
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2613

lab2612:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2613:

lab2614:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2617
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2615
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2616

lab2615:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2616:

lab2617:
    jmp lab2619

lab2618:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2619:

lab2621:
    ; #load tag
    mov r9, 0
    ; substitute (a0 := a0)(x168 := x168)(r3 := r3);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; let r2: List[Pair[i64, i64]] = Cons(x168, r3);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab2633
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2634

lab2633:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2631
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2624
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2622
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2623

lab2622:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2623:

lab2624:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2627
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2625
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2626

lab2625:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2626:

lab2627:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2630
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2628
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2629

lab2628:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2629:

lab2630:
    jmp lab2632

lab2631:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2632:

lab2634:
    ; #load tag
    mov rdi, 5
    ; substitute (r2 := r2)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Gen
    ; #there is only one clause, so we can jump there directly
    jmp rdi

go_gun_:
    ; switch a0 \{ ... \};
    ; #there is only one clause, so we can just fall through

Fun_i64_Unit_2635:

Fun_i64_Unit_2635_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab2637
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab2636
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2636:
    mov rdx, [rax + 40]
    jmp lab2638

lab2637:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]

lab2638:
    ; create a2: Gen = (steps, a1)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdi
    mov [rbx + 48], rsi
    mov [rbx + 40], rdx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2650
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab2651

lab2650:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2648
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2641
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2639
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2640

lab2639:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2640:

lab2641:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2644
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2642
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2643

lab2642:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2643:

lab2644:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2647
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2645
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2646

lab2645:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2646:

lab2647:
    jmp lab2649

lab2648:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2649:

lab2651:
    ; #load tag
    lea rdx, [rel Gen_2652]
    ; jump gun_
    jmp gun_

Gen_2652:

Gen_2652_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab2654
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab2653
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2653:
    mov rdi, [rsi + 40]
    jmp lab2655

lab2654:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]

lab2655:
    ; substitute (a1 := a1)(steps := steps)(coordslist1 := coordslist1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; let x0: Gen = Gen(coordslist1);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2667
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2668

lab2667:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2665
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2658
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2656
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2657

lab2656:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2657:

lab2658:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2661
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2659
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2660

lab2659:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2660:

lab2661:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2664
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2662
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2663

lab2662:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2663:

lab2664:
    jmp lab2666

lab2665:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2666:

lab2668:
    ; #load tag
    mov r9, 0
    ; substitute (x0 := x0)(steps := steps)(a1 := a1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a3: Gen = (a1)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2680
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2681

lab2680:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2678
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2671
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2669
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2670

lab2669:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2670:

lab2671:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2674
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2672
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2673

lab2672:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2673:

lab2674:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2677
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2675
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2676

lab2675:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2676:

lab2677:
    jmp lab2679

lab2678:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2679:

lab2681:
    ; #load tag
    lea r9, [rel Gen_2682]
    ; jump nthgen_
    jmp nthgen_

Gen_2682:

Gen_2682_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab2684
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab2683
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2683:
    jmp lab2685

lab2684:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab2685:
    ; substitute (a1 := a1)(coordslist0 := coordslist0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let gen: Gen = Gen(coordslist0);
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
    je lab2697
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2698

lab2697:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2695
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2688
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2686
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2687

lab2686:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2687:

lab2688:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2691
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2689
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2690

lab2689:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2690:

lab2691:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2694
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2692
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2693

lab2692:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2693:

lab2694:
    jmp lab2696

lab2695:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2696:

lab2698:
    ; #load tag
    mov rdi, 0
    ; substitute (a1 := a1);
    ; #erase gen
    cmp rsi, 0
    je lab2701
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab2699
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab2700

lab2699:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab2700:

lab2701:
    ; invoke a1 Unit
    ; #there is only one clause, so we can jump there directly
    jmp rdx

centerLine_:
    ; lit x0 <- 5;
    mov rdi, 5
    ; substitute (x0 := x0)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

bail_:
    ; lit x0 <- 0;
    mov rdi, 0
    ; lit x1 <- 0;
    mov r9, 0
    ; let x2: Pair[i64, i64] = Tup(x0, x1);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov qword [rbx + 48], 0
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
    je lab2713
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2714

lab2713:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2711
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2704
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2702
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2703

lab2702:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2703:

lab2704:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2707
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2705
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2706

lab2705:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2706:

lab2707:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2710
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2708
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2709

lab2708:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2709:

lab2710:
    jmp lab2712

lab2711:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2712:

lab2714:
    ; #load tag
    mov rdi, 0
    ; lit x3 <- 0;
    mov r9, 0
    ; lit x4 <- 1;
    mov r11, 1
    ; let x5: Pair[i64, i64] = Tup(x3, x4);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2726
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2727

lab2726:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2724
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2717
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2715
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2716

lab2715:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2716:

lab2717:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2720
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2718
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2719

lab2718:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2719:

lab2720:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2723
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2721
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2722

lab2721:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2722:

lab2723:
    jmp lab2725

lab2724:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2725:

lab2727:
    ; #load tag
    mov r9, 0
    ; lit x6 <- 1;
    mov r11, 1
    ; lit x7 <- 0;
    mov r13, 0
    ; let x8: Pair[i64, i64] = Tup(x6, x7);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2739
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2740

lab2739:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2737
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2730
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2728
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2729

lab2728:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2729:

lab2730:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2733
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2731
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2732

lab2731:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2732:

lab2733:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2736
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2734
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2735

lab2734:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2735:

lab2736:
    jmp lab2738

lab2737:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2738:

lab2740:
    ; #load tag
    mov r11, 0
    ; lit x9 <- 1;
    mov r13, 1
    ; lit x10 <- 1;
    mov r15, 1
    ; let x11: Pair[i64, i64] = Tup(x9, x10);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov qword [rbx + 48], 0
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2752
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2753

lab2752:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2750
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2743
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2741
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2742

lab2741:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2742:

lab2743:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2746
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2744
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2745

lab2744:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2745:

lab2746:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2749
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2747
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2748

lab2747:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2748:

lab2749:
    jmp lab2751

lab2750:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2751:

lab2753:
    ; #load tag
    mov r13, 0
    ; let x12: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r14, 0
    ; #load tag
    mov r15, 0
    ; let x13: List[Pair[i64, i64]] = Cons(x11, x12);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2765
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2766

lab2765:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2763
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2756
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2754
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2755

lab2754:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2755:

lab2756:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2759
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2757
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2758

lab2757:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2758:

lab2759:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2762
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2760
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2761

lab2760:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2761:

lab2762:
    jmp lab2764

lab2763:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2764:

lab2766:
    ; #load tag
    mov r13, 5
    ; let x14: List[Pair[i64, i64]] = Cons(x8, x13);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2778
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2779

lab2778:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2776
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2769
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2767
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2768

lab2767:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2768:

lab2769:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2772
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2770
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2771

lab2770:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2771:

lab2772:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2775
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2773
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2774

lab2773:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2774:

lab2775:
    jmp lab2777

lab2776:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2777:

lab2779:
    ; #load tag
    mov r11, 5
    ; let x15: List[Pair[i64, i64]] = Cons(x5, x14);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2791
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2792

lab2791:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2789
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2782
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2780
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2781

lab2780:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2781:

lab2782:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2785
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2783
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2784

lab2783:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2784:

lab2785:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2788
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2786
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2787

lab2786:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2787:

lab2788:
    jmp lab2790

lab2789:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2790:

lab2792:
    ; #load tag
    mov r9, 5
    ; substitute (x2 := x2)(x15 := x15)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

shuttle_:
    ; lit x0 <- 4;
    mov rdi, 4
    ; lit x1 <- 1;
    mov r9, 1
    ; let x2: Pair[i64, i64] = Tup(x0, x1);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov qword [rbx + 48], 0
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
    je lab2804
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2805

lab2804:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2802
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2795
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2793
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2794

lab2793:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2794:

lab2795:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2798
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2796
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2797

lab2796:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2797:

lab2798:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2801
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2799
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2800

lab2799:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2800:

lab2801:
    jmp lab2803

lab2802:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2803:

lab2805:
    ; #load tag
    mov rdi, 0
    ; lit x3 <- 4;
    mov r9, 4
    ; lit x4 <- 0;
    mov r11, 0
    ; let x5: Pair[i64, i64] = Tup(x3, x4);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2817
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2818

lab2817:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2815
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2808
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2806
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2807

lab2806:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2807:

lab2808:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2811
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2809
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2810

lab2809:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2810:

lab2811:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2814
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2812
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2813

lab2812:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2813:

lab2814:
    jmp lab2816

lab2815:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2816:

lab2818:
    ; #load tag
    mov r9, 0
    ; lit x6 <- 4;
    mov r11, 4
    ; lit x7 <- 5;
    mov r13, 5
    ; let x8: Pair[i64, i64] = Tup(x6, x7);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2830
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2831

lab2830:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2828
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2821
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2819
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2820

lab2819:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2820:

lab2821:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2824
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2822
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2823

lab2822:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2823:

lab2824:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2827
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2825
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2826

lab2825:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2826:

lab2827:
    jmp lab2829

lab2828:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2829:

lab2831:
    ; #load tag
    mov r11, 0
    ; lit x9 <- 4;
    mov r13, 4
    ; lit x10 <- 6;
    mov r15, 6
    ; let x11: Pair[i64, i64] = Tup(x9, x10);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov qword [rbx + 48], 0
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2843
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2844

lab2843:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2841
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2834
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2832
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2833

lab2832:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2833:

lab2834:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2837
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2835
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2836

lab2835:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2836:

lab2837:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2840
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2838
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2839

lab2838:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2839:

lab2840:
    jmp lab2842

lab2841:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2842:

lab2844:
    ; #load tag
    mov r13, 0
    ; let x12: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r14, 0
    ; #load tag
    mov r15, 0
    ; let x13: List[Pair[i64, i64]] = Cons(x11, x12);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2856
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2857

lab2856:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2854
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2847
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2845
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2846

lab2845:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2846:

lab2847:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2850
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2848
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2849

lab2848:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2849:

lab2850:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2853
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2851
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2852

lab2851:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2852:

lab2853:
    jmp lab2855

lab2854:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2855:

lab2857:
    ; #load tag
    mov r13, 5
    ; let x14: List[Pair[i64, i64]] = Cons(x8, x13);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2869
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2870

lab2869:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2867
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2860
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2858
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2859

lab2858:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2859:

lab2860:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2863
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2861
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2862

lab2861:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2862:

lab2863:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2866
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2864
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2865

lab2864:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2865:

lab2866:
    jmp lab2868

lab2867:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2868:

lab2870:
    ; #load tag
    mov r11, 5
    ; let x15: List[Pair[i64, i64]] = Cons(x5, x14);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2882
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2883

lab2882:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2880
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2873
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2871
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2872

lab2871:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2872:

lab2873:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2876
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2874
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2875

lab2874:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2875:

lab2876:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2879
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2877
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2878

lab2877:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2878:

lab2879:
    jmp lab2881

lab2880:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2881:

lab2883:
    ; #load tag
    mov r9, 5
    ; let r4: List[Pair[i64, i64]] = Cons(x2, x15);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab2895
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2896

lab2895:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2893
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2886
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2884
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2885

lab2884:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2885:

lab2886:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2889
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2887
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2888

lab2887:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2888:

lab2889:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2892
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2890
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2891

lab2890:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2891:

lab2892:
    jmp lab2894

lab2893:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2894:

lab2896:
    ; #load tag
    mov rdi, 5
    ; lit x16 <- 3;
    mov r9, 3
    ; lit x17 <- 2;
    mov r11, 2
    ; let x18: Pair[i64, i64] = Tup(x16, x17);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2908
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2909

lab2908:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2906
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2899
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2897
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2898

lab2897:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2898:

lab2899:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2902
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2900
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2901

lab2900:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2901:

lab2902:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2905
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2903
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2904

lab2903:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2904:

lab2905:
    jmp lab2907

lab2906:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2907:

lab2909:
    ; #load tag
    mov r9, 0
    ; lit x19 <- 3;
    mov r11, 3
    ; lit x20 <- 3;
    mov r13, 3
    ; let x21: Pair[i64, i64] = Tup(x19, x20);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2921
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2922

lab2921:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2919
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2912
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2910
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2911

lab2910:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2911:

lab2912:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2915
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2913
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2914

lab2913:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2914:

lab2915:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2918
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2916
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2917

lab2916:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2917:

lab2918:
    jmp lab2920

lab2919:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2920:

lab2922:
    ; #load tag
    mov r11, 0
    ; lit x22 <- 3;
    mov r13, 3
    ; lit x23 <- 4;
    mov r15, 4
    ; let x24: Pair[i64, i64] = Tup(x22, x23);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov qword [rbx + 48], 0
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2934
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2935

lab2934:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2932
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2925
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2923
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2924

lab2923:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2924:

lab2925:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2928
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2926
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2927

lab2926:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2927:

lab2928:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2931
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2929
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2930

lab2929:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2930:

lab2931:
    jmp lab2933

lab2932:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2933:

lab2935:
    ; #load tag
    mov r13, 0
    ; substitute (a0 := a0)(x21 := x21)(x18 := x18)(x24 := x24)(r4 := r4);
    ; #move variables
    mov rcx, r10
    mov r10, r12
    mov r12, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, r13
    mov r13, rdi
    mov rdi, rcx
    ; let x25: List[Pair[i64, i64]] = Cons(x24, r4);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    mov [rbx + 40], r11
    mov [rbx + 32], r10
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2947
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2948

lab2947:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2945
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2938
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2936
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2937

lab2936:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2937:

lab2938:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2941
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2939
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2940

lab2939:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2940:

lab2941:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2944
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2942
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2943

lab2942:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2943:

lab2944:
    jmp lab2946

lab2945:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2946:

lab2948:
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(x18 := x18)(x21 := x21)(x25 := x25);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; let x26: List[Pair[i64, i64]] = Cons(x21, x25);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2960
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2961

lab2960:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2958
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2951
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2949
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2950

lab2949:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2950:

lab2951:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2954
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2952
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2953

lab2952:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2953:

lab2954:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2957
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2955
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2956

lab2955:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2956:

lab2957:
    jmp lab2959

lab2958:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2959:

lab2961:
    ; #load tag
    mov r9, 5
    ; let r3: List[Pair[i64, i64]] = Cons(x18, x26);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab2973
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2974

lab2973:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2971
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2964
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2962
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2963

lab2962:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2963:

lab2964:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2967
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2965
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2966

lab2965:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2966:

lab2967:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2970
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2968
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2969

lab2968:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2969:

lab2970:
    jmp lab2972

lab2971:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2972:

lab2974:
    ; #load tag
    mov rdi, 5
    ; lit x27 <- 2;
    mov r9, 2
    ; lit x28 <- 1;
    mov r11, 1
    ; let x29: Pair[i64, i64] = Tup(x27, x28);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2986
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2987

lab2986:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2984
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2977
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2975
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2976

lab2975:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2976:

lab2977:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2980
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2978
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2979

lab2978:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2979:

lab2980:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2983
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2981
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2982

lab2981:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2982:

lab2983:
    jmp lab2985

lab2984:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2985:

lab2987:
    ; #load tag
    mov r9, 0
    ; lit x30 <- 2;
    mov r11, 2
    ; lit x31 <- 5;
    mov r13, 5
    ; let x32: Pair[i64, i64] = Tup(x30, x31);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2999
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab3000

lab2999:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2997
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2990
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2988
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2989

lab2988:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2989:

lab2990:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2993
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2991
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2992

lab2991:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2992:

lab2993:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2996
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2994
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2995

lab2994:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2995:

lab2996:
    jmp lab2998

lab2997:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2998:

lab3000:
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(x29 := x29)(x32 := x32)(r3 := r3);
    ; #move variables
    mov rcx, r8
    mov r8, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, r11
    mov r11, rdi
    mov rdi, rcx
    ; let x33: List[Pair[i64, i64]] = Cons(x32, r3);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3012
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3013

lab3012:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3010
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3003
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3001
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3002

lab3001:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3002:

lab3003:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3006
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3004
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3005

lab3004:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3005:

lab3006:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3009
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3007
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3008

lab3007:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3008:

lab3009:
    jmp lab3011

lab3010:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3011:

lab3013:
    ; #load tag
    mov r9, 5
    ; let r2: List[Pair[i64, i64]] = Cons(x29, x33);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab3025
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3026

lab3025:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3023
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3016
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3014
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3015

lab3014:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3015:

lab3016:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3019
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3017
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3018

lab3017:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3018:

lab3019:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3022
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3020
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3021

lab3020:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3021:

lab3022:
    jmp lab3024

lab3023:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3024:

lab3026:
    ; #load tag
    mov rdi, 5
    ; lit x34 <- 1;
    mov r9, 1
    ; lit x35 <- 2;
    mov r11, 2
    ; let x36: Pair[i64, i64] = Tup(x34, x35);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3038
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3039

lab3038:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3036
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3029
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3027
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3028

lab3027:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3028:

lab3029:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3032
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3030
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3031

lab3030:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3031:

lab3032:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3035
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3033
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3034

lab3033:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3034:

lab3035:
    jmp lab3037

lab3036:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3037:

lab3039:
    ; #load tag
    mov r9, 0
    ; lit x37 <- 1;
    mov r11, 1
    ; lit x38 <- 4;
    mov r13, 4
    ; let x39: Pair[i64, i64] = Tup(x37, x38);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3051
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab3052

lab3051:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3049
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3042
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3040
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3041

lab3040:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3041:

lab3042:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3045
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3043
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3044

lab3043:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3044:

lab3045:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3048
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3046
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3047

lab3046:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3047:

lab3048:
    jmp lab3050

lab3049:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3050:

lab3052:
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(x36 := x36)(x39 := x39)(r2 := r2);
    ; #move variables
    mov rcx, r8
    mov r8, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, r11
    mov r11, rdi
    mov rdi, rcx
    ; let x40: List[Pair[i64, i64]] = Cons(x39, r2);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3064
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3065

lab3064:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3062
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3055
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3053
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3054

lab3053:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3054:

lab3055:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3058
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3056
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3057

lab3056:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3057:

lab3058:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3061
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3059
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3060

lab3059:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3060:

lab3061:
    jmp lab3063

lab3062:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3063:

lab3065:
    ; #load tag
    mov r9, 5
    ; let r1: List[Pair[i64, i64]] = Cons(x36, x40);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab3077
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3078

lab3077:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3075
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3068
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3066
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3067

lab3066:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3067:

lab3068:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3071
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3069
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3070

lab3069:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3070:

lab3071:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3074
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3072
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3073

lab3072:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3073:

lab3074:
    jmp lab3076

lab3075:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3076:

lab3078:
    ; #load tag
    mov rdi, 5
    ; lit x41 <- 0;
    mov r9, 0
    ; lit x42 <- 3;
    mov r11, 3
    ; let x43: Pair[i64, i64] = Tup(x41, x42);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3090
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3091

lab3090:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3088
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3081
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3079
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3080

lab3079:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3080:

lab3081:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3084
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3082
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3083

lab3082:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3083:

lab3084:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3087
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3085
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3086

lab3085:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3086:

lab3087:
    jmp lab3089

lab3088:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3089:

lab3091:
    ; #load tag
    mov r9, 0
    ; substitute (x43 := x43)(r1 := r1)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

at_pos_:
    ; substitute (coordlist := coordlist)(a0 := a0)(p := p);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create move: Fun[Pair[i64, i64], Pair[i64, i64]] = (p)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3103
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3104

lab3103:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3101
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3094
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3092
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3093

lab3092:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3093:

lab3094:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3097
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3095
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3096

lab3095:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3096:

lab3097:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3100
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3098
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3099

lab3098:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3099:

lab3100:
    jmp lab3102

lab3101:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3102:

lab3104:
    ; #load tag
    lea r9, [rel Fun_Pair_i64_i64_Pair_i64_i64_3105]
    ; substitute (coordlist := coordlist)(move := move)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump map_
    jmp map_

Fun_Pair_i64_i64_Pair_i64_i64_3105:

Fun_Pair_i64_i64_Pair_i64_i64_3105_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3107
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3106
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3106:
    jmp lab3108

lab3107:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3108:
    ; substitute (p := p)(a1 := a1)(a := a);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch a \{ ... \};
    ; #there is only one clause, so we can just fall through

Pair_i64_i64_3109:

Pair_i64_i64_3109_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3110
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r9, [r8 + 40]
    jmp lab3111

lab3110:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r9, [r8 + 40]

lab3111:
    ; substitute (snd1 := snd1)(a1 := a1)(fst1 := fst1)(p := p);
    ; #move variables
    mov r10, rax
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; switch p \{ ... \};
    ; #there is only one clause, so we can just fall through

Pair_i64_i64_3112:

Pair_i64_i64_3112_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab3113
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r11, [r10 + 40]
    jmp lab3114

lab3113:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r11, [r10 + 40]

lab3114:
    ; x0 <- fst1 + fst2;
    mov r15, r9
    add r15, r11
    ; substitute (snd1 := snd1)(a1 := a1)(x0 := x0)(snd2 := snd2);
    ; #move variables
    mov r11, r13
    mov r9, r15
    ; x1 <- snd1 + snd2;
    mov r13, rdx
    add r13, r11
    ; substitute (x0 := x0)(x1 := x1)(a1 := a1);
    ; #move variables
    mov r8, rsi
    mov rdx, r9
    mov r9, rdi
    mov rdi, r13
    ; invoke a1 Tup
    ; #there is only one clause, so we can jump there directly
    jmp r9

non_steady_:
    ; create a1: List[Pair[i64, i64]] = (a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdx
    mov [rbx + 48], rax
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3126
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3127

lab3126:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3124
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3117
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3115
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3116

lab3115:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3116:

lab3117:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3120
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3118
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3119

lab3118:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3119:

lab3120:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3123
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3121
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3122

lab3121:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3122:

lab3123:
    jmp lab3125

lab3124:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3125:

lab3127:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3128]
    ; create a2: List[Pair[i64, i64]] = (a1)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdx
    mov [rbx + 48], rax
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3140
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3141

lab3140:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3138
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3131
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3129
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3130

lab3129:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3130:

lab3131:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3134
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3132
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3133

lab3132:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3133:

lab3134:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3137
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3135
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3136

lab3135:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3136:

lab3137:
    jmp lab3139

lab3138:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3139:

lab3141:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3142]
    ; create a3: List[Pair[i64, i64]] = (a2)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdx
    mov [rbx + 48], rax
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3154
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3155

lab3154:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3152
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3145
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3143
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3144

lab3143:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3144:

lab3145:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3148
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3146
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3147

lab3146:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3147:

lab3148:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3151
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3149
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3150

lab3149:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3150:

lab3151:
    jmp lab3153

lab3152:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3153:

lab3155:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3156]
    ; create a4: List[Pair[i64, i64]] = (a3)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdx
    mov [rbx + 48], rax
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3168
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3169

lab3168:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3166
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3159
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3157
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3158

lab3157:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3158:

lab3159:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3162
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3160
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3161

lab3160:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3161:

lab3162:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3165
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3163
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3164

lab3163:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3164:

lab3165:
    jmp lab3167

lab3166:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3167:

lab3169:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3170]
    ; jump bail_
    jmp bail_

List_Pair_i64_i64_3170:
    jmp near List_Pair_i64_i64_3170_Nil
    jmp near List_Pair_i64_i64_3170_Cons

List_Pair_i64_i64_3170_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3172
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3171
    ; ####increment refcount
    add qword [rax + 0], 1

lab3171:
    jmp lab3173

lab3172:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3173:
    ; let x3: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_non_steady_4_
    jmp lift_non_steady_4_

List_Pair_i64_i64_3170_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3175
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3174
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3174:
    jmp lab3176

lab3175:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3176:
    ; substitute (a3 := a3)(x26 := x26)(xs7 := xs7);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let x3: List[Pair[i64, i64]] = Cons(x26, xs7);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab3188
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3189

lab3188:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3186
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3179
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3177
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3178

lab3177:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3178:

lab3179:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3182
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3180
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3181

lab3180:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3181:

lab3182:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3185
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3183
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3184

lab3183:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3184:

lab3185:
    jmp lab3187

lab3186:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3187:

lab3189:
    ; #load tag
    mov rdi, 5
    ; jump lift_non_steady_4_
    jmp lift_non_steady_4_

List_Pair_i64_i64_3156:
    jmp near List_Pair_i64_i64_3156_Nil
    jmp near List_Pair_i64_i64_3156_Cons

List_Pair_i64_i64_3156_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3191
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3190
    ; ####increment refcount
    add qword [rax + 0], 1

lab3190:
    jmp lab3192

lab3191:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3192:
    ; let x2: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_non_steady_2_
    jmp lift_non_steady_2_

List_Pair_i64_i64_3156_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3194
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3193
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3193:
    jmp lab3195

lab3194:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3195:
    ; substitute (a2 := a2)(x25 := x25)(xs6 := xs6);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let x2: List[Pair[i64, i64]] = Cons(x25, xs6);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab3207
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3208

lab3207:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3205
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3198
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3196
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3197

lab3196:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3197:

lab3198:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3201
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3199
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3200

lab3199:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3200:

lab3201:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3204
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3202
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3203

lab3202:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3203:

lab3204:
    jmp lab3206

lab3205:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3206:

lab3208:
    ; #load tag
    mov rdi, 5
    ; jump lift_non_steady_2_
    jmp lift_non_steady_2_

List_Pair_i64_i64_3142:
    jmp near List_Pair_i64_i64_3142_Nil
    jmp near List_Pair_i64_i64_3142_Cons

List_Pair_i64_i64_3142_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3210
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3209
    ; ####increment refcount
    add qword [rax + 0], 1

lab3209:
    jmp lab3211

lab3210:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3211:
    ; let x1: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_non_steady_0_
    jmp lift_non_steady_0_

List_Pair_i64_i64_3142_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3213
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3212
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3212:
    jmp lab3214

lab3213:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3214:
    ; substitute (a1 := a1)(x22 := x22)(xs3 := xs3);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let x1: List[Pair[i64, i64]] = Cons(x22, xs3);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab3226
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3227

lab3226:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3224
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3217
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3215
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3216

lab3215:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3216:

lab3217:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3220
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3218
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3219

lab3218:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3219:

lab3220:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3223
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3221
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3222

lab3221:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3222:

lab3223:
    jmp lab3225

lab3224:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3225:

lab3227:
    ; #load tag
    mov rdi, 5
    ; jump lift_non_steady_0_
    jmp lift_non_steady_0_

List_Pair_i64_i64_3128:
    jmp near List_Pair_i64_i64_3128_Nil
    jmp near List_Pair_i64_i64_3128_Cons

List_Pair_i64_i64_3128_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3229
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3228
    ; ####increment refcount
    add qword [rax + 0], 1

lab3228:
    jmp lab3230

lab3229:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3230:
    ; let x0: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; substitute (x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Gen
    ; #there is only one clause, so we can jump there directly
    jmp rdi

List_Pair_i64_i64_3128_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3232
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3231
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3231:
    jmp lab3233

lab3232:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3233:
    ; substitute (a0 := a0)(x19 := x19)(xs0 := xs0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let x0: List[Pair[i64, i64]] = Cons(x19, xs0);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab3245
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3246

lab3245:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3243
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3236
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3234
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3235

lab3234:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3235:

lab3236:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3239
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3237
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3238

lab3237:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3238:

lab3239:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3242
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3240
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3241

lab3240:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3241:

lab3242:
    jmp lab3244

lab3243:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3244:

lab3246:
    ; #load tag
    mov rdi, 5
    ; substitute (x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Gen
    ; #there is only one clause, so we can jump there directly
    jmp rdi

lift_non_steady_4_:
    ; lit x4 <- 1;
    mov r9, 1
    ; create a5: _Cont = (a3, x3, x4)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov qword [rbx + 48], 0
    mov [rbx + 40], rdi
    mov [rbx + 32], rsi
    mov [rbx + 24], rdx
    mov [rbx + 16], rax
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3258
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3259

lab3258:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3256
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3249
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3247
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3248

lab3247:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3248:

lab3249:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3252
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3250
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3251

lab3250:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3251:

lab3252:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3255
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3253
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3254

lab3253:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3254:

lab3255:
    jmp lab3257

lab3256:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3257:

lab3259:
    ; #load tag
    lea rdx, [rel _Cont_3260]
    ; jump centerLine_
    jmp centerLine_

_Cont_3260:

_Cont_3260_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab3263
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab3261
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3261:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab3262
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3262:
    jmp lab3264

lab3263:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]

lab3264:
    ; substitute (x3 := x3)(a3 := a3)(x4 := x4)(x5 := x5);
    ; #move variables
    mov rcx, r9
    mov r9, r11
    mov r11, rdx
    mov rdx, rcx
    mov rax, r8
    ; let x6: Pair[i64, i64] = Tup(x4, x5);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3276
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3277

lab3276:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3274
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3267
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3265
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3266

lab3265:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3266:

lab3267:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3270
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3268
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3269

lab3268:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3269:

lab3270:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3273
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3271
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3272

lab3271:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3272:

lab3273:
    jmp lab3275

lab3274:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3275:

lab3277:
    ; #load tag
    mov r9, 0
    ; substitute (x3 := x3)(x6 := x6)(a3 := a3);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump at_pos_
    jmp at_pos_

lift_non_steady_2_:
    ; create a6: List[Pair[i64, i64]] = (a2, x2)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdi
    mov [rbx + 48], rsi
    mov [rbx + 40], rdx
    mov [rbx + 32], rax
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3289
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3290

lab3289:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3287
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3280
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3278
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3279

lab3278:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3279:

lab3280:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3283
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3281
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3282

lab3281:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3282:

lab3283:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3286
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3284
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3285

lab3284:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3285:

lab3286:
    jmp lab3288

lab3287:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3288:

lab3290:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3291]
    ; create a7: List[Pair[i64, i64]] = (a6)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdx
    mov [rbx + 48], rax
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3303
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3304

lab3303:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3301
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3294
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3292
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3293

lab3292:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3293:

lab3294:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3297
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3295
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3296

lab3295:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3296:

lab3297:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3300
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3298
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3299

lab3298:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3299:

lab3300:
    jmp lab3302

lab3301:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3302:

lab3304:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3305]
    ; jump bail_
    jmp bail_

List_Pair_i64_i64_3305:
    jmp near List_Pair_i64_i64_3305_Nil
    jmp near List_Pair_i64_i64_3305_Cons

List_Pair_i64_i64_3305_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3307
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3306
    ; ####increment refcount
    add qword [rax + 0], 1

lab3306:
    jmp lab3308

lab3307:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3308:
    ; let x8: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_non_steady_3_
    jmp lift_non_steady_3_

List_Pair_i64_i64_3305_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3310
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3309
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3309:
    jmp lab3311

lab3310:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3311:
    ; substitute (a6 := a6)(x24 := x24)(xs5 := xs5);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let x8: List[Pair[i64, i64]] = Cons(x24, xs5);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab3323
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3324

lab3323:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3321
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3314
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3312
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3313

lab3312:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3313:

lab3314:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3317
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3315
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3316

lab3315:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3316:

lab3317:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3320
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3318
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3319

lab3318:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3319:

lab3320:
    jmp lab3322

lab3321:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3322:

lab3324:
    ; #load tag
    mov rdi, 5
    ; jump lift_non_steady_3_
    jmp lift_non_steady_3_

List_Pair_i64_i64_3291:
    jmp near List_Pair_i64_i64_3291_Nil
    jmp near List_Pair_i64_i64_3291_Cons

List_Pair_i64_i64_3291_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3327
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab3325
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3325:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab3326
    ; ####increment refcount
    add qword [rax + 0], 1

lab3326:
    jmp lab3328

lab3327:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab3328:
    ; let x7: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x2 := x2)(x7 := x7)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump append_
    jmp append_

List_Pair_i64_i64_3291_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3331
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab3329
    ; ####increment refcount
    add qword [r10 + 0], 1

lab3329:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab3330
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3330:
    jmp lab3332

lab3331:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab3332:
    ; substitute (x2 := x2)(a2 := a2)(x23 := x23)(xs4 := xs4);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; let x7: List[Pair[i64, i64]] = Cons(x23, xs4);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3344
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3345

lab3344:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3342
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3335
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3333
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3334

lab3333:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3334:

lab3335:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3338
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3336
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3337

lab3336:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3337:

lab3338:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3341
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3339
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3340

lab3339:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3340:

lab3341:
    jmp lab3343

lab3342:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3343:

lab3345:
    ; #load tag
    mov r9, 5
    ; substitute (x2 := x2)(x7 := x7)(a2 := a2);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump append_
    jmp append_

lift_non_steady_3_:
    ; lit x9 <- 21;
    mov r9, 21
    ; create a8: _Cont = (a6, x8, x9)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov qword [rbx + 48], 0
    mov [rbx + 40], rdi
    mov [rbx + 32], rsi
    mov [rbx + 24], rdx
    mov [rbx + 16], rax
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3357
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3358

lab3357:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3355
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3348
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3346
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3347

lab3346:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3347:

lab3348:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3351
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3349
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3350

lab3349:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3350:

lab3351:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3354
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3352
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3353

lab3352:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3353:

lab3354:
    jmp lab3356

lab3355:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3356:

lab3358:
    ; #load tag
    lea rdx, [rel _Cont_3359]
    ; jump centerLine_
    jmp centerLine_

_Cont_3359:

_Cont_3359_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab3362
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab3360
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3360:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab3361
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3361:
    jmp lab3363

lab3362:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]

lab3363:
    ; substitute (x8 := x8)(a6 := a6)(x9 := x9)(x10 := x10);
    ; #move variables
    mov rcx, r9
    mov r9, r11
    mov r11, rdx
    mov rdx, rcx
    mov rax, r8
    ; let x11: Pair[i64, i64] = Tup(x9, x10);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3375
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3376

lab3375:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3373
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3366
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3364
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3365

lab3364:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3365:

lab3366:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3369
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3367
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3368

lab3367:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3368:

lab3369:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3372
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3370
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3371

lab3370:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3371:

lab3372:
    jmp lab3374

lab3373:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3374:

lab3376:
    ; #load tag
    mov r9, 0
    ; substitute (x8 := x8)(x11 := x11)(a6 := a6);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump at_pos_
    jmp at_pos_

lift_non_steady_0_:
    ; create a9: List[Pair[i64, i64]] = (a1, x1)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdi
    mov [rbx + 48], rsi
    mov [rbx + 40], rdx
    mov [rbx + 32], rax
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3388
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3389

lab3388:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3386
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3379
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3377
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3378

lab3377:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3378:

lab3379:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3382
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3380
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3381

lab3380:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3381:

lab3382:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3385
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3383
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3384

lab3383:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3384:

lab3385:
    jmp lab3387

lab3386:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3387:

lab3389:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3390]
    ; create a10: List[Pair[i64, i64]] = (a9)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdx
    mov [rbx + 48], rax
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3402
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3403

lab3402:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3400
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3393
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3391
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3392

lab3391:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3392:

lab3393:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3396
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3394
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3395

lab3394:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3395:

lab3396:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3399
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3397
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3398

lab3397:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3398:

lab3399:
    jmp lab3401

lab3400:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3401:

lab3403:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3404]
    ; jump shuttle_
    jmp shuttle_

List_Pair_i64_i64_3404:
    jmp near List_Pair_i64_i64_3404_Nil
    jmp near List_Pair_i64_i64_3404_Cons

List_Pair_i64_i64_3404_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3406
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3405
    ; ####increment refcount
    add qword [rax + 0], 1

lab3405:
    jmp lab3407

lab3406:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3407:
    ; let x13: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_non_steady_1_
    jmp lift_non_steady_1_

List_Pair_i64_i64_3404_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3409
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3408
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3408:
    jmp lab3410

lab3409:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3410:
    ; substitute (a9 := a9)(x21 := x21)(xs2 := xs2);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let x13: List[Pair[i64, i64]] = Cons(x21, xs2);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
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
    je lab3422
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3423

lab3422:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3420
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3413
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3411
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3412

lab3411:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3412:

lab3413:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3416
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3414
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3415

lab3414:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3415:

lab3416:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3419
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3417
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3418

lab3417:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3418:

lab3419:
    jmp lab3421

lab3420:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3421:

lab3423:
    ; #load tag
    mov rdi, 5
    ; jump lift_non_steady_1_
    jmp lift_non_steady_1_

List_Pair_i64_i64_3390:
    jmp near List_Pair_i64_i64_3390_Nil
    jmp near List_Pair_i64_i64_3390_Cons

List_Pair_i64_i64_3390_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3426
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab3424
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3424:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab3425
    ; ####increment refcount
    add qword [rax + 0], 1

lab3425:
    jmp lab3427

lab3426:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab3427:
    ; let x12: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x1 := x1)(x12 := x12)(a1 := a1);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump append_
    jmp append_

List_Pair_i64_i64_3390_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3430
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab3428
    ; ####increment refcount
    add qword [r10 + 0], 1

lab3428:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab3429
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3429:
    jmp lab3431

lab3430:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab3431:
    ; substitute (x1 := x1)(a1 := a1)(x20 := x20)(xs1 := xs1);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; let x12: List[Pair[i64, i64]] = Cons(x20, xs1);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3443
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3444

lab3443:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3441
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3434
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3432
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3433

lab3432:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3433:

lab3434:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3437
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3435
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3436

lab3435:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3436:

lab3437:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3440
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3438
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3439

lab3438:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3439:

lab3440:
    jmp lab3442

lab3441:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3442:

lab3444:
    ; #load tag
    mov r9, 5
    ; substitute (x1 := x1)(x12 := x12)(a1 := a1);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump append_
    jmp append_

lift_non_steady_1_:
    ; lit x14 <- 6;
    mov r9, 6
    ; create a11: _Cont = (a9, x13, x14)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov qword [rbx + 48], 0
    mov [rbx + 40], rdi
    mov [rbx + 32], rsi
    mov [rbx + 24], rdx
    mov [rbx + 16], rax
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3456
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3457

lab3456:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3454
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3447
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3445
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3446

lab3445:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3446:

lab3447:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3450
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3448
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3449

lab3448:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3449:

lab3450:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3453
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3451
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3452

lab3451:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3452:

lab3453:
    jmp lab3455

lab3454:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3455:

lab3457:
    ; #load tag
    lea rdx, [rel _Cont_3458]
    ; jump centerLine_
    jmp centerLine_

_Cont_3458:

_Cont_3458_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab3461
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab3459
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3459:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab3460
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3460:
    jmp lab3462

lab3461:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]

lab3462:
    ; lit x16 <- 2;
    mov r13, 2
    ; x17 <- x15 - x16;
    mov r15, rdx
    sub r15, r13
    ; substitute (x13 := x13)(a9 := a9)(x14 := x14)(x17 := x17);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    mov r9, r11
    mov r11, r15
    ; let x18: Pair[i64, i64] = Tup(x14, x17);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
    mov [rbx + 40], r9
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3474
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3475

lab3474:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3472
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3465
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3463
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3464

lab3463:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3464:

lab3465:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3468
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3466
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3467

lab3466:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3467:

lab3468:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3471
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3469
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3470

lab3469:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3470:

lab3471:
    jmp lab3473

lab3472:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3473:

lab3475:
    ; #load tag
    mov r9, 0
    ; substitute (x13 := x13)(x18 := x18)(a9 := a9);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump at_pos_
    jmp at_pos_

go_shuttle_:
    ; switch a0 \{ ... \};
    ; #there is only one clause, so we can just fall through

Fun_i64_Unit_3476:

Fun_i64_Unit_3476_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3478
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab3477
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3477:
    mov rdx, [rax + 40]
    jmp lab3479

lab3478:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]

lab3479:
    ; create a2: Gen = (steps, a1)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], rdi
    mov [rbx + 48], rsi
    mov [rbx + 40], rdx
    mov qword [rbx + 32], 0
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3491
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3492

lab3491:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3489
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3482
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3480
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3481

lab3480:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3481:

lab3482:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3485
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3483
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3484

lab3483:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3484:

lab3485:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3488
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3486
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3487

lab3486:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3487:

lab3488:
    jmp lab3490

lab3489:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3490:

lab3492:
    ; #load tag
    lea rdx, [rel Gen_3493]
    ; jump non_steady_
    jmp non_steady_

Gen_3493:

Gen_3493_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab3495
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab3494
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3494:
    mov rdi, [rsi + 40]
    jmp lab3496

lab3495:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]

lab3496:
    ; substitute (a1 := a1)(steps := steps)(coordslist1 := coordslist1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; let x0: Gen = Gen(coordslist1);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3508
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3509

lab3508:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3506
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3499
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3497
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3498

lab3497:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3498:

lab3499:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3502
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3500
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3501

lab3500:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3501:

lab3502:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3505
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3503
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3504

lab3503:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3504:

lab3505:
    jmp lab3507

lab3506:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3507:

lab3509:
    ; #load tag
    mov r9, 0
    ; substitute (x0 := x0)(steps := steps)(a1 := a1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a3: Gen = (a1)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3521
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3522

lab3521:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3519
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3512
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3510
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3511

lab3510:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3511:

lab3512:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3515
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3513
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3514

lab3513:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3514:

lab3515:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3518
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3516
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3517

lab3516:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3517:

lab3518:
    jmp lab3520

lab3519:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3520:

lab3522:
    ; #load tag
    lea r9, [rel Gen_3523]
    ; jump nthgen_
    jmp nthgen_

Gen_3523:

Gen_3523_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab3525
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab3524
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3524:
    jmp lab3526

lab3525:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab3526:
    ; substitute (a1 := a1)(coordslist0 := coordslist0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let gen: Gen = Gen(coordslist0);
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
    je lab3538
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3539

lab3538:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3536
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3529
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3527
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3528

lab3527:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3528:

lab3529:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3532
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3530
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3531

lab3530:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3531:

lab3532:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3535
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3533
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3534

lab3533:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3534:

lab3535:
    jmp lab3537

lab3536:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3537:

lab3539:
    ; #load tag
    mov rdi, 0
    ; substitute (a1 := a1);
    ; #erase gen
    cmp rsi, 0
    je lab3542
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab3540
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab3541

lab3540:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab3541:

lab3542:
    ; invoke a1 Unit
    ; #there is only one clause, so we can jump there directly
    jmp rdx

go_loop_:
    ; if iters == 0 \{ ... \}
    cmp rdx, 0
    je lab3543
    ; else branch
    ; substitute (go0 := go)(steps0 := steps)(go := go)(a0 := a0)(iters := iters)(steps := steps);
    ; #share go
    cmp r8, 0
    je lab3544
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3544:
    ; #move variables
    mov r13, rdx
    mov r15, rdi
    mov rax, r8
    mov rdx, r9
    ; create a1: Unit = (go, a0, iters, steps)\{ ... \};
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
    je lab3556
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab3557

lab3556:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3554
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3547
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3545
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3546

lab3545:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3546:

lab3547:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3550
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3548
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3549

lab3548:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3549:

lab3550:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3553
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3551
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3552

lab3551:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3552:

lab3553:
    jmp lab3555

lab3554:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3555:

lab3557:
    ; ##store link to previous block
    mov [rbx + 48], r10
    ; ##store values
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab3569
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3570

lab3569:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3567
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3560
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3558
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3559

lab3558:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3559:

lab3560:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3563
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3561
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3562

lab3561:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3562:

lab3563:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3566
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3564
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3565

lab3564:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3565:

lab3566:
    jmp lab3568

lab3567:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3568:

lab3570:
    ; #load tag
    lea r9, [rel Unit_3571]
    ; substitute (steps0 := steps0)(a1 := a1)(go0 := go0);
    ; #move variables
    mov rsi, r8
    mov r8, rax
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke go0 Apply
    ; #there is only one clause, so we can jump there directly
    jmp r9

Unit_3571:

Unit_3571_Unit:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3574
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab3572
    ; ####increment refcount
    add qword [rax + 0], 1

lab3572:
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab3573
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3573:
    jmp lab3575

lab3574:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]

lab3575:
    ; let res: Unit = Unit();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; substitute (go := go)(a0 := a0)(iters := iters)(steps := steps);
    ; #erase res
    cmp r12, 0
    je lab3578
    ; ######check refcount
    cmp qword [r12 + 0], 0
    je lab3576
    ; ######either decrement refcount ...
    add qword [r12 + 0], -1
    jmp lab3577

lab3576:
    ; ######... or add block to lazy free list
    mov [r12 + 0], rbp
    mov rbp, r12

lab3577:

lab3578:
    ; lit x0 <- 1;
    mov r13, 1
    ; x1 <- iters - x0;
    mov r15, r9
    sub r15, r13
    ; substitute (x1 := x1)(steps := steps)(go := go)(a0 := a0);
    ; #move variables
    mov r8, rax
    mov r9, rdx
    mov r10, rsi
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    mov rdx, r15
    ; jump go_loop_
    jmp go_loop_

lab3543:
    ; then branch
    ; substitute (a0 := a0);
    ; #erase go
    cmp r8, 0
    je lab3581
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab3579
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab3580

lab3579:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab3580:

lab3581:
    ; #move variables
    mov rax, r10
    mov rdx, r11
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