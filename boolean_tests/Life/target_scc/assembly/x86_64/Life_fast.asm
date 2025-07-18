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
    lea rcx, [rel Bool_54]
    add rcx, rdi
    jmp rcx

Bool_54:
    jmp near Bool_54_True
    jmp near Bool_54_False

Bool_54_True:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Bool_54_False:
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
    lea rcx, [rel List_Pair_i64_i64_55]
    add rcx, r11
    jmp rcx

List_Pair_i64_i64_55:
    jmp near List_Pair_i64_i64_55_Nil
    jmp near List_Pair_i64_i64_55_Cons

List_Pair_i64_i64_55_Nil:
    ; substitute (a0 := a0)(a := a);
    ; #erase f
    cmp r8, 0
    je lab58
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab56
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab57

lab56:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab57:

lab58:
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch a \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_59]
    add rcx, rdi
    jmp rcx

List_Pair_i64_i64_59:
    jmp near List_Pair_i64_i64_59_Nil
    jmp near List_Pair_i64_i64_59_Cons

List_Pair_i64_i64_59_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_59_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab62
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab60
    ; ####increment refcount
    add qword [r8 + 0], 1

lab60:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab61
    ; ####increment refcount
    add qword [rsi + 0], 1

lab61:
    jmp lab63

lab62:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab63:
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

List_Pair_i64_i64_55_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab66
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab64
    ; ####increment refcount
    add qword [r12 + 0], 1

lab64:
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]
    cmp r10, 0
    je lab65
    ; ####increment refcount
    add qword [r10 + 0], 1

lab65:
    jmp lab67

lab66:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]

lab67:
    ; substitute (a := a)(b := b)(f0 := f)(f := f)(x := x)(a0 := a0);
    ; #share f
    cmp r8, 0
    je lab68
    ; ####increment refcount
    add qword [r8 + 0], 1

lab68:
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
    je lab80
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab81

lab80:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab78
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab71
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab69
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab70

lab69:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab70:

lab71:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab74
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab72
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab73

lab72:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab73:

lab74:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab77
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab75
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab76

lab75:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab76:

lab77:
    jmp lab79

lab78:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab79:

lab81:
    ; #load tag
    lea r11, [rel List_Pair_i64_i64_82]
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

List_Pair_i64_i64_82:
    jmp near List_Pair_i64_i64_82_Nil
    jmp near List_Pair_i64_i64_82_Cons

List_Pair_i64_i64_82_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab86
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab83
    ; ####increment refcount
    add qword [r8 + 0], 1

lab83:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab84
    ; ####increment refcount
    add qword [rsi + 0], 1

lab84:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab85
    ; ####increment refcount
    add qword [rax + 0], 1

lab85:
    jmp lab87

lab86:
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

lab87:
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

List_Pair_i64_i64_82_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab91
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab88
    ; ####increment refcount
    add qword [r12 + 0], 1

lab88:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab89
    ; ####increment refcount
    add qword [r10 + 0], 1

lab89:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab90
    ; ####increment refcount
    add qword [r8 + 0], 1

lab90:
    jmp lab92

lab91:
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

lab92:
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
    je lab104
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab105

lab104:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab102
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab95
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab93
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab94

lab93:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab94:

lab95:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab98
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab96
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab97

lab96:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab97:

lab98:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab101
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab99
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab100

lab99:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab100:

lab101:
    jmp lab103

lab102:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab103:

lab105:
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
    lea r11, [rel Fun2_List_Pair_i64_i64_Pair_i64_i64_List_Pair_i64_i64_106]
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

Fun2_List_Pair_i64_i64_Pair_i64_i64_List_Pair_i64_i64_106:

Fun2_List_Pair_i64_i64_Pair_i64_i64_List_Pair_i64_i64_106_Apply2:
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
    lea rcx, [rel List_Pair_i64_i64_107]
    add rcx, r11
    jmp rcx

List_Pair_i64_i64_107:
    jmp near List_Pair_i64_i64_107_Nil
    jmp near List_Pair_i64_i64_107_Cons

List_Pair_i64_i64_107_Nil:
    ; substitute (a0 := a0)(sofar := sofar);
    ; #erase f
    cmp r8, 0
    je lab110
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab108
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab109

lab108:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab109:

lab110:
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch sofar \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_111]
    add rcx, rdi
    jmp rcx

List_Pair_i64_i64_111:
    jmp near List_Pair_i64_i64_111_Nil
    jmp near List_Pair_i64_i64_111_Cons

List_Pair_i64_i64_111_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_111_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab114
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab112
    ; ####increment refcount
    add qword [r8 + 0], 1

lab112:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab113
    ; ####increment refcount
    add qword [rsi + 0], 1

lab113:
    jmp lab115

lab114:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab115:
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

List_Pair_i64_i64_107_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab118
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab116
    ; ####increment refcount
    add qword [r12 + 0], 1

lab116:
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]
    cmp r10, 0
    je lab117
    ; ####increment refcount
    add qword [r10 + 0], 1

lab117:
    jmp lab119

lab118:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]

lab119:
    ; substitute (sofar := sofar)(p := p)(f0 := f)(f := f)(xs0 := xs0)(a0 := a0);
    ; #share f
    cmp r8, 0
    je lab120
    ; ####increment refcount
    add qword [r8 + 0], 1

lab120:
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
    je lab132
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab133

lab132:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab130
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab123
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab121
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab122

lab121:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab122:

lab123:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab126
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab124
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab125

lab124:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab125:

lab126:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab129
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab127
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab128

lab127:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab128:

lab129:
    jmp lab131

lab130:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab131:

lab133:
    ; #load tag
    lea r11, [rel List_Pair_i64_i64_134]
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
    je lab146
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab147

lab146:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab144
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab137
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab135
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab136

lab135:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab136:

lab137:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab140
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab138
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab139

lab138:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab139:

lab140:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab143
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab141
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab142

lab141:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab142:

lab143:
    jmp lab145

lab144:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab145:

lab147:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_148]
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

List_Pair_i64_i64_148:
    jmp near List_Pair_i64_i64_148_Nil
    jmp near List_Pair_i64_i64_148_Cons

List_Pair_i64_i64_148_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab151
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab149
    ; ####increment refcount
    add qword [rsi + 0], 1

lab149:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab150
    ; ####increment refcount
    add qword [rax + 0], 1

lab150:
    jmp lab152

lab151:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab152:
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

List_Pair_i64_i64_148_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab155
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab153
    ; ####increment refcount
    add qword [r10 + 0], 1

lab153:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab154
    ; ####increment refcount
    add qword [r8 + 0], 1

lab154:
    jmp lab156

lab155:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab156:
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
    je lab168
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab169

lab168:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab166
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab159
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab157
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab158

lab157:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab158:

lab159:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab162
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab160
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab161

lab160:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab161:

lab162:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab165
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab163
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab164

lab163:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab164:

lab165:
    jmp lab167

lab166:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab167:

lab169:
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

List_Pair_i64_i64_134:
    jmp near List_Pair_i64_i64_134_Nil
    jmp near List_Pair_i64_i64_134_Cons

List_Pair_i64_i64_134_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab173
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab170
    ; ####increment refcount
    add qword [r8 + 0], 1

lab170:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab171
    ; ####increment refcount
    add qword [rsi + 0], 1

lab171:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab172
    ; ####increment refcount
    add qword [rax + 0], 1

lab172:
    jmp lab174

lab173:
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

lab174:
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

List_Pair_i64_i64_134_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab178
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab175
    ; ####increment refcount
    add qword [r12 + 0], 1

lab175:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab176
    ; ####increment refcount
    add qword [r10 + 0], 1

lab176:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab177
    ; ####increment refcount
    add qword [r8 + 0], 1

lab177:
    jmp lab179

lab178:
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

lab179:
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
    je lab191
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab192

lab191:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab189
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab182
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab180
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab181

lab180:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab181:

lab182:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab185
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab183
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab184

lab183:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab184:

lab185:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab188
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab186
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab187

lab186:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab187:

lab188:
    jmp lab190

lab189:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab190:

lab192:
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
    lea rcx, [rel List_Pair_i64_i64_193]
    add rcx, r9
    jmp rcx

List_Pair_i64_i64_193:
    jmp near List_Pair_i64_i64_193_Nil
    jmp near List_Pair_i64_i64_193_Cons

List_Pair_i64_i64_193_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab196
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab194
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab195

lab194:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab195:

lab196:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

List_Pair_i64_i64_193_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab199
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab197
    ; ####increment refcount
    add qword [r10 + 0], 1

lab197:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab198
    ; ####increment refcount
    add qword [r8 + 0], 1

lab198:
    jmp lab200

lab199:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab200:
    ; substitute (p := p)(f0 := f)(f := f)(ps := ps)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab201
    ; ####increment refcount
    add qword [rsi + 0], 1

lab201:
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
    je lab213
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab214

lab213:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab211
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab204
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab202
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab203

lab202:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab203:

lab204:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab207
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab205
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab206

lab205:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab206:

lab207:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab210
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab208
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab209

lab208:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab209:

lab210:
    jmp lab212

lab211:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab212:

lab214:
    ; #load tag
    lea r9, [rel Bool_215]
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

Bool_215:
    jmp near Bool_215_True
    jmp near Bool_215_False

Bool_215_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab219
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab216
    ; ####increment refcount
    add qword [r8 + 0], 1

lab216:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab217
    ; ####increment refcount
    add qword [rsi + 0], 1

lab217:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab218
    ; ####increment refcount
    add qword [rax + 0], 1

lab218:
    jmp lab220

lab219:
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

lab220:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rax, 0
    je lab223
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab221
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab222

lab221:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab222:

lab223:
    ; #erase ps
    cmp rsi, 0
    je lab226
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab224
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab225

lab224:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab225:

lab226:
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_215_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab230
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab227
    ; ####increment refcount
    add qword [r8 + 0], 1

lab227:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab228
    ; ####increment refcount
    add qword [rsi + 0], 1

lab228:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab229
    ; ####increment refcount
    add qword [rax + 0], 1

lab229:
    jmp lab231

lab230:
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

lab231:
    ; substitute (ps := ps)(f := f)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump exists_
    jmp exists_

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
    lea rcx, [rel List_Pair_i64_i64_232]
    add rcx, r9
    jmp rcx

List_Pair_i64_i64_232:
    jmp near List_Pair_i64_i64_232_Nil
    jmp near List_Pair_i64_i64_232_Cons

List_Pair_i64_i64_232_Nil:
    ; switch l2 \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_233]
    add rcx, rdi
    jmp rcx

List_Pair_i64_i64_233:
    jmp near List_Pair_i64_i64_233_Nil
    jmp near List_Pair_i64_i64_233_Cons

List_Pair_i64_i64_233_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_233_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab236
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab234
    ; ####increment refcount
    add qword [r8 + 0], 1

lab234:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab235
    ; ####increment refcount
    add qword [rsi + 0], 1

lab235:
    jmp lab237

lab236:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab237:
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

List_Pair_i64_i64_232_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab240
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab238
    ; ####increment refcount
    add qword [r10 + 0], 1

lab238:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab239
    ; ####increment refcount
    add qword [r8 + 0], 1

lab239:
    jmp lab241

lab240:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab241:
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
    je lab253
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab254

lab253:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab251
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab244
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab242
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab243

lab242:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab243:

lab244:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab247
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab245
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab246

lab245:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab246:

lab247:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab250
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab248
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab249

lab248:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab249:

lab250:
    jmp lab252

lab251:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab252:

lab254:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_255]
    ; jump append_
    jmp append_

List_Pair_i64_i64_255:
    jmp near List_Pair_i64_i64_255_Nil
    jmp near List_Pair_i64_i64_255_Cons

List_Pair_i64_i64_255_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab258
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab256
    ; ####increment refcount
    add qword [rsi + 0], 1

lab256:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab257
    ; ####increment refcount
    add qword [rax + 0], 1

lab257:
    jmp lab259

lab258:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab259:
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

List_Pair_i64_i64_255_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab262
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab260
    ; ####increment refcount
    add qword [r10 + 0], 1

lab260:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab261
    ; ####increment refcount
    add qword [r8 + 0], 1

lab261:
    jmp lab263

lab262:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab263:
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
    je lab275
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab276

lab275:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab273
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab266
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab264
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab265

lab264:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab265:

lab266:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab269
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab267
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab268

lab267:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab268:

lab269:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab272
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab270
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab271

lab270:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab271:

lab272:
    jmp lab274

lab273:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab274:

lab276:
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
    lea rcx, [rel List_Pair_i64_i64_277]
    add rcx, r9
    jmp rcx

List_Pair_i64_i64_277:
    jmp near List_Pair_i64_i64_277_Nil
    jmp near List_Pair_i64_i64_277_Cons

List_Pair_i64_i64_277_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab280
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab278
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab279

lab278:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab279:

lab280:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_277_Cons:
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
    ; substitute (p := p)(f0 := f)(f := f)(ps := ps)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab285
    ; ####increment refcount
    add qword [rsi + 0], 1

lab285:
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
    je lab297
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab298

lab297:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab295
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab288
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab286
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab287

lab286:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab287:

lab288:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab291
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab289
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab290

lab289:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab290:

lab291:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab294
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab292
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab293

lab292:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab293:

lab294:
    jmp lab296

lab295:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab296:

lab298:
    ; #load tag
    lea r9, [rel Pair_i64_i64_299]
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

Pair_i64_i64_299:

Pair_i64_i64_299_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab303
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab300
    ; ####increment refcount
    add qword [r12 + 0], 1

lab300:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab301
    ; ####increment refcount
    add qword [r10 + 0], 1

lab301:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab302
    ; ####increment refcount
    add qword [r8 + 0], 1

lab302:
    jmp lab304

lab303:
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

lab304:
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
    je lab316
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab317

lab316:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab314
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab307
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab305
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab306

lab305:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab306:

lab307:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab310
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab308
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab309

lab308:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab309:

lab310:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab313
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab311
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab312

lab311:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab312:

lab313:
    jmp lab315

lab314:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab315:

lab317:
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
    je lab329
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab330

lab329:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab327
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab320
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab318
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab319

lab318:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab319:

lab320:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab323
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab321
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab322

lab321:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab322:

lab323:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab326
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab324
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab325

lab324:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab325:

lab326:
    jmp lab328

lab327:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab328:

lab330:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_331]
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

List_Pair_i64_i64_331:
    jmp near List_Pair_i64_i64_331_Nil
    jmp near List_Pair_i64_i64_331_Cons

List_Pair_i64_i64_331_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab334
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab332
    ; ####increment refcount
    add qword [rsi + 0], 1

lab332:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab333
    ; ####increment refcount
    add qword [rax + 0], 1

lab333:
    jmp lab335

lab334:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab335:
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

List_Pair_i64_i64_331_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab338
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab336
    ; ####increment refcount
    add qword [r10 + 0], 1

lab336:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab337
    ; ####increment refcount
    add qword [r8 + 0], 1

lab337:
    jmp lab339

lab338:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab339:
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
    je lab351
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab352

lab351:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab349
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab342
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab340
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab341

lab340:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab341:

lab342:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab345
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab343
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab344

lab343:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab344:

lab345:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab348
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab346
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab347

lab346:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab347:

lab348:
    jmp lab350

lab349:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab350:

lab352:
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
    je lab364
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab365

lab364:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab362
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab355
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab353
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab354

lab353:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab354:

lab355:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab358
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab356
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab357

lab356:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab357:

lab358:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab361
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab359
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab360

lab359:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab360:

lab361:
    jmp lab363

lab362:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab363:

lab365:
    ; #load tag
    lea r9, [rel Fun_Pair_i64_i64_Bool_366]
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

Fun_Pair_i64_i64_Bool_366:

Fun_Pair_i64_i64_Bool_366_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab368
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab367
    ; ####increment refcount
    add qword [r8 + 0], 1

lab367:
    jmp lab369

lab368:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab369:
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
    lea rcx, [rel List_Pair_i64_i64_370]
    add rcx, rdi
    jmp rcx

List_Pair_i64_i64_370:
    jmp near List_Pair_i64_i64_370_Nil
    jmp near List_Pair_i64_i64_370_Cons

List_Pair_i64_i64_370_Nil:
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

List_Pair_i64_i64_370_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab373
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab371
    ; ####increment refcount
    add qword [r8 + 0], 1

lab371:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab372
    ; ####increment refcount
    add qword [rsi + 0], 1

lab372:
    jmp lab374

lab373:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab374:
    ; substitute (a0 := a0)(ps := ps);
    ; #erase p
    cmp rsi, 0
    je lab377
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab375
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab376

lab375:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab376:

lab377:
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
    je lab389
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab390

lab389:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab387
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab380
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab378
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab379

lab378:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab379:

lab380:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab383
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab381
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab382

lab381:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab382:

lab383:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab386
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab384
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab385

lab384:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab385:

lab386:
    jmp lab388

lab387:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab388:

lab390:
    ; #load tag
    lea rdi, [rel _Cont_391]
    ; jump len_
    jmp len_

_Cont_391:

_Cont_391_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab393
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab392
    ; ####increment refcount
    add qword [rsi + 0], 1

lab392:
    jmp lab394

lab393:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab394:
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
    lea rcx, [rel List_Pair_i64_i64_395]
    add rcx, r9
    jmp rcx

List_Pair_i64_i64_395:
    jmp near List_Pair_i64_i64_395_Nil
    jmp near List_Pair_i64_i64_395_Cons

List_Pair_i64_i64_395_Nil:
    ; substitute (a0 := a0);
    ; #erase f
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
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_395_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab401
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab399
    ; ####increment refcount
    add qword [r10 + 0], 1

lab399:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab400
    ; ####increment refcount
    add qword [r8 + 0], 1

lab400:
    jmp lab402

lab401:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab402:
    ; substitute (p0 := p)(f0 := f)(p := p)(ps := ps)(a0 := a0)(f := f);
    ; #share f
    cmp rsi, 0
    je lab403
    ; ####increment refcount
    add qword [rsi + 0], 1

lab403:
    ; #share p
    cmp r8, 0
    je lab404
    ; ####increment refcount
    add qword [r8 + 0], 1

lab404:
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
    je lab416
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab417

lab416:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab414
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab410
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab408
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab409

lab408:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab409:

lab410:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab413
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab411
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab412

lab411:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab412:

lab413:
    jmp lab415

lab414:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab415:

lab417:
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
    je lab429
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab430

lab429:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab427
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab420
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab418
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab419

lab418:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab419:

lab420:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab423
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab421
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab422

lab421:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab422:

lab423:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab426
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab424
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab425

lab424:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab425:

lab426:
    jmp lab428

lab427:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab428:

lab430:
    ; #load tag
    lea r9, [rel Bool_431]
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

Bool_431:
    jmp near Bool_431_True
    jmp near Bool_431_False

Bool_431_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab436
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab432
    ; ####increment refcount
    add qword [rax + 0], 1

lab432:
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab433
    ; ####increment refcount
    add qword [r10 + 0], 1

lab433:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab434
    ; ####increment refcount
    add qword [r8 + 0], 1

lab434:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab435
    ; ####increment refcount
    add qword [rsi + 0], 1

lab435:
    jmp lab437

lab436:
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

lab437:
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
    je lab449
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab450

lab449:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab447
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab440
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab438
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab439

lab438:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab439:

lab440:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab443
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab441
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab442

lab441:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab442:

lab443:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab446
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab444
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab445

lab444:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab445:

lab446:
    jmp lab448

lab447:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab448:

lab450:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_451]
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

List_Pair_i64_i64_451:
    jmp near List_Pair_i64_i64_451_Nil
    jmp near List_Pair_i64_i64_451_Cons

List_Pair_i64_i64_451_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab454
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab452
    ; ####increment refcount
    add qword [rsi + 0], 1

lab452:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab453
    ; ####increment refcount
    add qword [rax + 0], 1

lab453:
    jmp lab455

lab454:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab455:
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

List_Pair_i64_i64_451_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab458
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab456
    ; ####increment refcount
    add qword [r10 + 0], 1

lab456:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab457
    ; ####increment refcount
    add qword [r8 + 0], 1

lab457:
    jmp lab459

lab458:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab459:
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
    je lab471
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab472

lab471:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab469
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab462
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab460
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab461

lab460:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab461:

lab462:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab465
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab463
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab464

lab463:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab464:

lab465:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab468
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab466
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab467

lab466:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab467:

lab468:
    jmp lab470

lab469:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab470:

lab472:
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

Bool_431_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab477
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab473
    ; ####increment refcount
    add qword [rax + 0], 1

lab473:
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab474
    ; ####increment refcount
    add qword [r10 + 0], 1

lab474:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab475
    ; ####increment refcount
    add qword [r8 + 0], 1

lab475:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab476
    ; ####increment refcount
    add qword [rsi + 0], 1

lab476:
    jmp lab478

lab477:
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

lab478:
    ; substitute (ps := ps)(f := f)(a0 := a0);
    ; #erase p
    cmp rax, 0
    je lab481
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab479
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab480

lab479:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab480:

lab481:
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
    je lab493
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab494

lab493:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab491
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab484
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab482
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab483

lab482:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab483:

lab484:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab487
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab485
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab486

lab485:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab486:

lab487:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab490
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab488
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab489

lab488:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab489:

lab490:
    jmp lab492

lab491:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab492:

lab494:
    ; #load tag
    lea r9, [rel Fun_Pair_i64_i64_Bool_495]
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

Fun_Pair_i64_i64_Bool_495:

Fun_Pair_i64_i64_Bool_495_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab497
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab496
    ; ####increment refcount
    add qword [r8 + 0], 1

lab496:
    jmp lab498

lab497:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab498:
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
    je lab510
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab511

lab510:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab508
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab501
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab499
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab500

lab499:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab500:

lab501:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab504
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab502
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab503

lab502:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab503:

lab504:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab507
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab505
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab506

lab505:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab506:

lab507:
    jmp lab509

lab508:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab509:

lab511:
    ; #load tag
    lea r9, [rel Bool_512]
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

Bool_512:
    jmp near Bool_512_True
    jmp near Bool_512_False

Bool_512_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab514
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab513
    ; ####increment refcount
    add qword [rax + 0], 1

lab513:
    jmp lab515

lab514:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab515:
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

Bool_512_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab517
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab516
    ; ####increment refcount
    add qword [rax + 0], 1

lab516:
    jmp lab518

lab517:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab518:
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
    lea rcx, [rel List_Pair_i64_i64_519]
    add rcx, r15
    jmp rcx

List_Pair_i64_i64_519:
    jmp near List_Pair_i64_i64_519_Nil
    jmp near List_Pair_i64_i64_519_Cons

List_Pair_i64_i64_519_Nil:
    ; substitute (x3 := x3)(xover := xover)(a0 := a0);
    ; #erase x1
    cmp r10, 0
    je lab522
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab520
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab521

lab520:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab521:

lab522:
    ; #erase x2
    cmp r8, 0
    je lab525
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab523
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab524

lab523:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab524:

lab525:
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

List_Pair_i64_i64_519_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r14 + 0], 0
    je lab528
    ; ##either decrement refcount and share children...
    add qword [r14 + 0], -1
    ; ###load values
    mov rcx, [r14 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r14 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab526
    ; ####increment refcount
    add qword [rcx + 0], 1

lab526:
    mov r15, [r14 + 40]
    mov r14, [r14 + 32]
    cmp r14, 0
    je lab527
    ; ####increment refcount
    add qword [r14 + 0], 1

lab527:
    jmp lab529

lab528:
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

lab529:
    ; substitute (xover0 := xover)(a8 := a)(x2 := x2)(x1 := x1)(a0 := a0)(a := a)(x := x)(xover := xover)(x3 := x3);
    ; #share a
    cmp r14, 0
    je lab530
    ; ####increment refcount
    add qword [r14 + 0], 1

lab530:
    ; #share xover
    cmp rax, 0
    je lab531
    ; ####increment refcount
    add qword [rax + 0], 1

lab531:
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
    je lab543
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab544

lab543:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab541
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab534
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab532
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab533

lab532:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab533:

lab534:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab537
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab535
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab536

lab535:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab536:

lab537:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab540
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab538
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab539

lab538:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab539:

lab540:
    jmp lab542

lab541:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab542:

lab544:
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
    je lab556
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab557

lab556:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab554
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab547
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab545
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab546

lab545:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab546:

lab547:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab550
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab548
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab549

lab548:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab549:

lab550:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab553
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab551
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab552

lab551:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab552:

lab553:
    jmp lab555

lab554:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab555:

lab557:
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
    je lab569
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab570

lab569:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab567
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab560
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab558
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab559

lab558:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab559:

lab560:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab563
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab561
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab562

lab561:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab562:

lab563:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab566
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab564
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab565

lab564:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab565:

lab566:
    jmp lab568

lab567:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab568:

lab570:
    ; #load tag
    lea r9, [rel Bool_571]
    ; jump member_
    jmp member_

Bool_571:
    jmp near Bool_571_True
    jmp near Bool_571_False

Bool_571_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab579
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab572
    ; ####increment refcount
    add qword [rsi + 0], 1

lab572:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab573
    ; ####increment refcount
    add qword [rax + 0], 1

lab573:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab574
    ; ####increment refcount
    add qword [r10 + 0], 1

lab574:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab575
    ; ####increment refcount
    add qword [r8 + 0], 1

lab575:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab576
    ; ####increment refcount
    add qword [rcx + 0], 1

lab576:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab577
    ; ####increment refcount
    add qword [r14 + 0], 1

lab577:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab578
    ; ####increment refcount
    add qword [r12 + 0], 1

lab578:
    jmp lab580

lab579:
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

lab580:
    ; substitute (xover := xover)(x3 := x3)(x2 := x2)(x1 := x1)(x := x)(a0 := a0);
    ; #erase a
    cmp r10, 0
    je lab583
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab581
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab582

lab581:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab582:

lab583:
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

Bool_571_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab591
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab584
    ; ####increment refcount
    add qword [rsi + 0], 1

lab584:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab585
    ; ####increment refcount
    add qword [rax + 0], 1

lab585:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab586
    ; ####increment refcount
    add qword [r10 + 0], 1

lab586:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab587
    ; ####increment refcount
    add qword [r8 + 0], 1

lab587:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab588
    ; ####increment refcount
    add qword [rcx + 0], 1

lab588:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab589
    ; ####increment refcount
    add qword [r14 + 0], 1

lab589:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab590
    ; ####increment refcount
    add qword [r12 + 0], 1

lab590:
    jmp lab592

lab591:
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

lab592:
    ; substitute (x30 := x3)(a7 := a)(a0 := a0)(a := a)(x := x)(xover := xover)(x3 := x3)(x2 := x2)(x1 := x1);
    ; #share a
    cmp r10, 0
    je lab593
    ; ####increment refcount
    add qword [r10 + 0], 1

lab593:
    ; #share x3
    cmp qword [rsp + 2032], 0
    je lab594
    ; ####increment refcount
    mov rcx, [rsp + 2032]
    add qword [rcx + 0], 1

lab594:
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
    je lab606
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab607

lab606:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab604
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab597
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab595
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab596

lab595:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab596:

lab597:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab600
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab598
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab599

lab598:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab599:

lab600:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab603
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab601
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab602

lab601:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab602:

lab603:
    jmp lab605

lab604:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab605:

lab607:
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
    je lab619
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab620

lab619:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab617
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab610
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab608
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab609

lab608:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab609:

lab610:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab613
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab611
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab612

lab611:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab612:

lab613:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab616
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab614
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab615

lab614:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab615:

lab616:
    jmp lab618

lab617:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab618:

lab620:
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
    je lab632
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab633

lab632:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab630
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab623
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab621
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab622

lab621:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab622:

lab623:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab626
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab624
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab625

lab624:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab625:

lab626:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab629
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab627
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab628

lab627:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab628:

lab629:
    jmp lab631

lab630:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab631:

lab633:
    ; #load tag
    lea r9, [rel Bool_634]
    ; jump member_
    jmp member_

Bool_634:
    jmp near Bool_634_True
    jmp near Bool_634_False

Bool_634_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab642
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab635
    ; ####increment refcount
    add qword [rsi + 0], 1

lab635:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab636
    ; ####increment refcount
    add qword [rax + 0], 1

lab636:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab637
    ; ####increment refcount
    add qword [r10 + 0], 1

lab637:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab638
    ; ####increment refcount
    add qword [r8 + 0], 1

lab638:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab639
    ; ####increment refcount
    add qword [rcx + 0], 1

lab639:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab640
    ; ####increment refcount
    add qword [r14 + 0], 1

lab640:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab641
    ; ####increment refcount
    add qword [r12 + 0], 1

lab641:
    jmp lab643

lab642:
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

lab643:
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
    je lab655
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab656

lab655:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab653
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab646
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab644
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab645

lab644:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab645:

lab646:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab649
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab647
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab648

lab647:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab648:

lab649:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab652
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab650
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab651

lab650:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab651:

lab652:
    jmp lab654

lab653:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab654:

lab656:
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

Bool_634_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab664
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab657
    ; ####increment refcount
    add qword [rsi + 0], 1

lab657:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab658
    ; ####increment refcount
    add qword [rax + 0], 1

lab658:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab659
    ; ####increment refcount
    add qword [r10 + 0], 1

lab659:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab660
    ; ####increment refcount
    add qword [r8 + 0], 1

lab660:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab661
    ; ####increment refcount
    add qword [rcx + 0], 1

lab661:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab662
    ; ####increment refcount
    add qword [r14 + 0], 1

lab662:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab663
    ; ####increment refcount
    add qword [r12 + 0], 1

lab663:
    jmp lab665

lab664:
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

lab665:
    ; substitute (x20 := x2)(a6 := a)(x := x)(xover := xover)(x3 := x3)(x2 := x2)(x1 := x1)(a0 := a0)(a := a);
    ; #share a
    cmp rsi, 0
    je lab666
    ; ####increment refcount
    add qword [rsi + 0], 1

lab666:
    ; #share x2
    cmp r14, 0
    je lab667
    ; ####increment refcount
    add qword [r14 + 0], 1

lab667:
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
    je lab679
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab680

lab679:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab677
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab676
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab674
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab675

lab674:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab675:

lab676:
    jmp lab678

lab677:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab678:

lab680:
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
    je lab692
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab693

lab692:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab690
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab683
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab681
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab682

lab681:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab682:

lab683:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab686
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab684
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab685

lab684:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab685:

lab686:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab689
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab687
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab688

lab687:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab688:

lab689:
    jmp lab691

lab690:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab691:

lab693:
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
    je lab705
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab706

lab705:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab703
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab696
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab694
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab695

lab694:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab695:

lab696:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab699
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab697
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab698

lab697:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab698:

lab699:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab702
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab700
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab701

lab700:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab701:

lab702:
    jmp lab704

lab703:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab704:

lab706:
    ; #load tag
    lea r9, [rel Bool_707]
    ; jump member_
    jmp member_

Bool_707:
    jmp near Bool_707_True
    jmp near Bool_707_False

Bool_707_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab715
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab708
    ; ####increment refcount
    add qword [rsi + 0], 1

lab708:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab709
    ; ####increment refcount
    add qword [rax + 0], 1

lab709:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab710
    ; ####increment refcount
    add qword [r10 + 0], 1

lab710:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab711
    ; ####increment refcount
    add qword [r8 + 0], 1

lab711:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab712
    ; ####increment refcount
    add qword [rcx + 0], 1

lab712:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab713
    ; ####increment refcount
    add qword [r14 + 0], 1

lab713:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab714
    ; ####increment refcount
    add qword [r12 + 0], 1

lab714:
    jmp lab716

lab715:
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

lab716:
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
    je lab728
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab729

lab728:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab726
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab719
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab717
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab718

lab717:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab718:

lab719:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab722
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab720
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab721

lab720:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab721:

lab722:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab725
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab723
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab724

lab723:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab724:

lab725:
    jmp lab727

lab726:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab727:

lab729:
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

Bool_707_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab737
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab730
    ; ####increment refcount
    add qword [rsi + 0], 1

lab730:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab731
    ; ####increment refcount
    add qword [rax + 0], 1

lab731:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab732
    ; ####increment refcount
    add qword [r10 + 0], 1

lab732:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab733
    ; ####increment refcount
    add qword [r8 + 0], 1

lab733:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab734
    ; ####increment refcount
    add qword [rcx + 0], 1

lab734:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab735
    ; ####increment refcount
    add qword [r14 + 0], 1

lab735:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab736
    ; ####increment refcount
    add qword [r12 + 0], 1

lab736:
    jmp lab738

lab737:
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

lab738:
    ; substitute (a5 := a)(x10 := x1)(x3 := x3)(x2 := x2)(x1 := x1)(a0 := a0)(a := a)(x := x)(xover := xover);
    ; #share a
    cmp qword [rsp + 2032], 0
    je lab739
    ; ####increment refcount
    mov rcx, [rsp + 2032]
    add qword [rcx + 0], 1

lab739:
    ; #share x1
    cmp r12, 0
    je lab740
    ; ####increment refcount
    add qword [r12 + 0], 1

lab740:
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
    je lab752
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab753

lab752:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab750
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab749
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab747
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab748

lab747:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab748:

lab749:
    jmp lab751

lab750:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab751:

lab753:
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
    je lab765
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab766

lab765:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab763
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab756
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab754
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab755

lab754:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab755:

lab756:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab759
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab757
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab758

lab757:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab758:

lab759:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab762
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab760
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab761

lab760:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab761:

lab762:
    jmp lab764

lab763:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab764:

lab766:
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
    je lab778
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab779

lab778:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab776
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab769
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab767
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab768

lab767:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab768:

lab769:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab772
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab770
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab771

lab770:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab771:

lab772:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab775
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab773
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab774

lab773:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab774:

lab775:
    jmp lab777

lab776:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab777:

lab779:
    ; #load tag
    lea r9, [rel Bool_780]
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

Bool_780:
    jmp near Bool_780_True
    jmp near Bool_780_False

Bool_780_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab788
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab781
    ; ####increment refcount
    add qword [rsi + 0], 1

lab781:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab782
    ; ####increment refcount
    add qword [rax + 0], 1

lab782:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab783
    ; ####increment refcount
    add qword [r10 + 0], 1

lab783:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab784
    ; ####increment refcount
    add qword [r8 + 0], 1

lab784:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab785
    ; ####increment refcount
    add qword [rcx + 0], 1

lab785:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab786
    ; ####increment refcount
    add qword [r14 + 0], 1

lab786:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab787
    ; ####increment refcount
    add qword [r12 + 0], 1

lab787:
    jmp lab789

lab788:
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

lab789:
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
    je lab801
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab802

lab801:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab799
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab792
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab790
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab791

lab790:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab791:

lab792:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab795
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab793
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab794

lab793:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab794:

lab795:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab798
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab796
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab797

lab796:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab797:

lab798:
    jmp lab800

lab799:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab800:

lab802:
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

Bool_780_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab810
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab803
    ; ####increment refcount
    add qword [rsi + 0], 1

lab803:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab804
    ; ####increment refcount
    add qword [rax + 0], 1

lab804:
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab805
    ; ####increment refcount
    add qword [r10 + 0], 1

lab805:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab806
    ; ####increment refcount
    add qword [r8 + 0], 1

lab806:
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov rcx, [r12 + 48]
    mov [rsp + 2032], rcx
    cmp rcx, 0
    je lab807
    ; ####increment refcount
    add qword [rcx + 0], 1

lab807:
    mov r15, [r12 + 40]
    mov r14, [r12 + 32]
    cmp r14, 0
    je lab808
    ; ####increment refcount
    add qword [r14 + 0], 1

lab808:
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab809
    ; ####increment refcount
    add qword [r12 + 0], 1

lab809:
    jmp lab811

lab810:
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

lab811:
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
    je lab823
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab824

lab823:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab821
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab814
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab812
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab813

lab812:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab813:

lab814:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab817
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab815
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab816

lab815:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab816:

lab817:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab820
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab818
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab819

lab818:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab819:

lab820:
    jmp lab822

lab821:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab822:

lab824:
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

Pair_i64_i64_825:

Pair_i64_i64_825_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab826
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    jmp lab827

lab826:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]

lab827:
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
    je lab839
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab840

lab839:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab837
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab830
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab828
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab829

lab828:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab829:

lab830:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab833
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab831
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab832

lab831:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab832:

lab833:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab836
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab834
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab835

lab834:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab835:

lab836:
    jmp lab838

lab837:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab838:

lab840:
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
    je lab852
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab853

lab852:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab850
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab843
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab841
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab842

lab841:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab842:

lab843:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab846
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab844
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab845

lab844:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab845:

lab846:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab849
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab847
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab848

lab847:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab848:

lab849:
    jmp lab851

lab850:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab851:

lab853:
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
    je lab865
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab866

lab865:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab863
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab856
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab854
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab855

lab854:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab855:

lab856:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab859
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab857
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab858

lab857:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab858:

lab859:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab862
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab860
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab861

lab860:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab861:

lab862:
    jmp lab864

lab863:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab864:

lab866:
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
    je lab878
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab879

lab878:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab876
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab869
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab867
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab868

lab867:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab868:

lab869:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab872
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab870
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab871

lab870:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab871:

lab872:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab875
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab873
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab874

lab873:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab874:

lab875:
    jmp lab877

lab876:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab877:

lab879:
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
    je lab891
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab892

lab891:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab889
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab882
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab880
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab881

lab880:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab881:

lab882:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab885
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab883
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab884

lab883:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab884:

lab885:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab888
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab886
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab887

lab886:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab887:

lab888:
    jmp lab890

lab889:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab890:

lab892:
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
    je lab904
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab905

lab904:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab902
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab895
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab893
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab894

lab893:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab894:

lab895:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab898
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab896
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab897

lab896:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab897:

lab898:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab901
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab899
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab900

lab899:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab900:

lab901:
    jmp lab903

lab902:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab903:

lab905:
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
    je lab917
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab918

lab917:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab915
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab908
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab906
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab907

lab906:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab907:

lab908:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab911
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab909
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab910

lab909:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab910:

lab911:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab914
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab912
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab913

lab912:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab913:

lab914:
    jmp lab916

lab915:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab916:

lab918:
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
    je lab930
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab931

lab930:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab928
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab921
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab919
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab920

lab919:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab920:

lab921:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab924
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab922
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab923

lab922:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab923:

lab924:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab927
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab925
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab926

lab925:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab926:

lab927:
    jmp lab929

lab928:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab929:

lab931:
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
    je lab943
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab944

lab943:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab941
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab934
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab932
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab933

lab932:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab933:

lab934:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab937
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab935
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab936

lab935:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab936:

lab937:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab940
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab938
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab939

lab938:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab939:

lab940:
    jmp lab942

lab941:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab942:

lab944:
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
    je lab956
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab957

lab956:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab954
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab947
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab945
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab946

lab945:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab946:

lab947:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab950
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab948
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab949

lab948:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab949:

lab950:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab953
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab951
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab952

lab951:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab952:

lab953:
    jmp lab955

lab954:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab955:

lab957:
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
    je lab969
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab970

lab969:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab967
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab960
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab958
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab959

lab958:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab959:

lab960:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab963
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab961
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab962

lab961:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab962:

lab963:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab966
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab964
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab965

lab964:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab965:

lab966:
    jmp lab968

lab967:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab968:

lab970:
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
    je lab982
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab983

lab982:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab980
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab973
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab971
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab972

lab971:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab972:

lab973:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab976
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab974
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab975

lab974:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab975:

lab976:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab979
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab977
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab978

lab977:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab978:

lab979:
    jmp lab981

lab980:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab981:

lab983:
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
    je lab995
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab996

lab995:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab993
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab986
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab984
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab985

lab984:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab985:

lab986:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab989
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab987
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab988

lab987:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab988:

lab989:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab992
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab990
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab991

lab990:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab991:

lab992:
    jmp lab994

lab993:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab994:

lab996:
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
    je lab1008
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1009

lab1008:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1006
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab999
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab997
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab998

lab997:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab998:

lab999:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1002
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1000
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1001

lab1000:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1001:

lab1002:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1005
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1003
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1004

lab1003:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1004:

lab1005:
    jmp lab1007

lab1006:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1007:

lab1009:
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
    je lab1021
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1022

lab1021:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1019
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1012
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1010
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1011

lab1010:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1011:

lab1012:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1015
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1013
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1014

lab1013:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1014:

lab1015:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1018
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1016
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1017

lab1016:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1017:

lab1018:
    jmp lab1020

lab1019:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1020:

lab1022:
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

Gen_1023:

Gen_1023_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1025
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab1024
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1024:
    jmp lab1026

lab1025:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab1026:
    ; switch livecoords \{ ... \};
    lea rcx, [rel List_Pair_i64_i64_1027]
    add rcx, rdi
    jmp rcx

List_Pair_i64_i64_1027:
    jmp near List_Pair_i64_i64_1027_Nil
    jmp near List_Pair_i64_i64_1027_Cons

List_Pair_i64_i64_1027_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Pair_i64_i64_1027_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1030
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab1028
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1028:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab1029
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1029:
    jmp lab1031

lab1030:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab1031:
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
    je lab1032
    ; else branch
    ; substitute (n := n)(a0 := a0);
    ; lit x1 <- 3;
    mov r9, 3
    ; if n == x1 \{ ... \}
    cmp rdx, r9
    je lab1033
    ; else branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 False
    add rdx, 5
    jmp rdx

lab1033:
    ; then branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 True
    add rdx, 0
    jmp rdx

lab1032:
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
    je lab1045
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1046

lab1045:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1043
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1042
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1040
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1041

lab1040:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1041:

lab1042:
    jmp lab1044

lab1043:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1044:

lab1046:
    ; #load tag
    lea rdi, [rel List_Pair_i64_i64_1047]
    ; jump alive_
    jmp alive_

List_Pair_i64_i64_1047:
    jmp near List_Pair_i64_i64_1047_Nil
    jmp near List_Pair_i64_i64_1047_Cons

List_Pair_i64_i64_1047_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1049
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1048
    ; ####increment refcount
    add qword [rax + 0], 1

lab1048:
    jmp lab1050

lab1049:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1050:
    ; let living: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_nextgen_0_
    jmp lift_nextgen_0_

List_Pair_i64_i64_1047_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1052
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1051
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1051:
    jmp lab1053

lab1052:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1053:
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
    je lab1065
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1066

lab1065:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1063
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1056
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1054
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1055

lab1054:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1055:

lab1056:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1059
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1057
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1058

lab1057:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1058:

lab1059:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1062
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1060
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1061

lab1060:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1061:

lab1062:
    jmp lab1064

lab1063:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1064:

lab1066:
    ; #load tag
    mov rdi, 5
    ; jump lift_nextgen_0_
    jmp lift_nextgen_0_

lift_nextgen_0_:
    ; substitute (a0 := a0)(living0 := living)(living := living);
    ; #share living
    cmp rsi, 0
    je lab1067
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1067:
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
    je lab1079
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1080

lab1079:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1077
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1070
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1068
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1069

lab1068:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1069:

lab1070:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1073
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1071
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1072

lab1071:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1072:

lab1073:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1076
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1074
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1075

lab1074:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1075:

lab1076:
    jmp lab1078

lab1077:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1078:

lab1080:
    ; #load tag
    lea r9, [rel Fun_Pair_i64_i64_Bool_1081]
    ; substitute (a0 := a0)(living0 := living0)(isalive0 := isalive)(isalive := isalive);
    ; #share isalive
    cmp r8, 0
    je lab1082
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1082:
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
    je lab1094
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1095

lab1094:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1092
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1085
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1083
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1084

lab1083:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1084:

lab1085:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1088
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1086
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1087

lab1086:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1087:

lab1088:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1093

lab1092:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1093:

lab1095:
    ; #load tag
    lea r11, [rel Fun_Pair_i64_i64_i64_1096]
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
    je lab1108
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1109

lab1108:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1106
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1099
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1097
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1098

lab1097:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1098:

lab1099:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1102
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1100
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1101

lab1100:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1101:

lab1102:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1105
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1103
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1104

lab1103:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1104:

lab1105:
    jmp lab1107

lab1106:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1107:

lab1109:
    ; #load tag
    lea r11, [rel Fun_Pair_i64_i64_Bool_1110]
    ; substitute (x2 := x2)(living00 := living0)(isalive0 := isalive0)(living0 := living0)(a0 := a0);
    ; #share living0
    cmp rsi, 0
    je lab1111
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1111:
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
    je lab1123
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1124

lab1123:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1121
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1114
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1112
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1113

lab1112:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1113:

lab1114:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1117
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1115
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1116

lab1115:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1116:

lab1117:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1122

lab1121:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1122:

lab1124:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_1125]
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

List_Pair_i64_i64_1125:
    jmp near List_Pair_i64_i64_1125_Nil
    jmp near List_Pair_i64_i64_1125_Cons

List_Pair_i64_i64_1125_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1129
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1126
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1126:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1127
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1127:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1128
    ; ####increment refcount
    add qword [rax + 0], 1

lab1128:
    jmp lab1130

lab1129:
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

lab1130:
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

List_Pair_i64_i64_1125_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1134
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab1131
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1131:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab1132
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1132:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab1133
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1133:
    jmp lab1135

lab1134:
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

lab1135:
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
    je lab1147
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1148

lab1147:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1145
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1144
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1142
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1143

lab1142:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1143:

lab1144:
    jmp lab1146

lab1145:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1146:

lab1148:
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

Fun_Pair_i64_i64_Bool_1110:

Fun_Pair_i64_i64_Bool_1110_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1150
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1149
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1149:
    jmp lab1151

lab1150:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1151:
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
    je lab1163
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1164

lab1163:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1161
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1154
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1152
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1153

lab1152:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1153:

lab1154:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1157
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1155
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1156

lab1155:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1156:

lab1157:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1160
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1158
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1159

lab1158:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1159:

lab1160:
    jmp lab1162

lab1161:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1162:

lab1164:
    ; #load tag
    lea r9, [rel _Cont_1165]
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

_Cont_1165:

_Cont_1165_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1167
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab1166
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1166:
    jmp lab1168

lab1167:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab1168:
    ; jump twoorthree_
    jmp twoorthree_

Fun_Pair_i64_i64_i64_1096:

Fun_Pair_i64_i64_i64_1096_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1170
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1169
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1169:
    jmp lab1171

lab1170:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1171:
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
    je lab1183
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1184

lab1183:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1181
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1174
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1172
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1173

lab1172:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1173:

lab1174:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1177
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1175
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1176

lab1175:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1176:

lab1177:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1180
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1178
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1179

lab1178:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1179:

lab1180:
    jmp lab1182

lab1181:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1182:

lab1184:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_1185]
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
    je lab1197
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1198

lab1197:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1195
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1188
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1186
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1187

lab1186:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1187:

lab1188:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1191
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1189
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1190

lab1189:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1190:

lab1191:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1194
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1192
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1193

lab1192:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1193:

lab1194:
    jmp lab1196

lab1195:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1196:

lab1198:
    ; #load tag
    lea rdi, [rel List_Pair_i64_i64_1199]
    ; jump neighbours_
    jmp neighbours_

List_Pair_i64_i64_1199:
    jmp near List_Pair_i64_i64_1199_Nil
    jmp near List_Pair_i64_i64_1199_Cons

List_Pair_i64_i64_1199_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1202
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1200
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1200:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1201
    ; ####increment refcount
    add qword [rax + 0], 1

lab1201:
    jmp lab1203

lab1202:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1203:
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

List_Pair_i64_i64_1199_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1206
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1204
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1204:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1205
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1205:
    jmp lab1207

lab1206:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1207:
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
    je lab1219
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1220

lab1219:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1217
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1210
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1208
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1209

lab1208:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1209:

lab1210:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1213
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1211
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1212

lab1211:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1212:

lab1213:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1216
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1214
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1215

lab1214:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1215:

lab1216:
    jmp lab1218

lab1217:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1218:

lab1220:
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

List_Pair_i64_i64_1185:
    jmp near List_Pair_i64_i64_1185_Nil
    jmp near List_Pair_i64_i64_1185_Cons

List_Pair_i64_i64_1185_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1222
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1221
    ; ####increment refcount
    add qword [rax + 0], 1

lab1221:
    jmp lab1223

lab1222:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1223:
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

List_Pair_i64_i64_1185_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1225
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1224
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1224:
    jmp lab1226

lab1225:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1226:
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
    je lab1238
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1239

lab1238:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1236
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1229
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1227
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1228

lab1227:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1228:

lab1229:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1232
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1230
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1231

lab1230:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1231:

lab1232:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1235
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1233
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1234

lab1233:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1234:

lab1235:
    jmp lab1237

lab1236:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1237:

lab1239:
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

Fun_Pair_i64_i64_Bool_1081:

Fun_Pair_i64_i64_Bool_1081_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1241
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1240
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1240:
    jmp lab1242

lab1241:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1242:
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
    je lab1254
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1255

lab1254:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1252
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1245
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1243
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1244

lab1243:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1244:

lab1245:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1248
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1246
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1247

lab1246:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1247:

lab1248:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1251
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1249
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1250

lab1249:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1250:

lab1251:
    jmp lab1253

lab1252:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1253:

lab1255:
    ; #load tag
    lea r11, [rel Fun_Pair_i64_i64_List_Pair_i64_i64_1256]
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
    je lab1268
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1269

lab1268:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1266
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1259
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1257
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1258

lab1257:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1258:

lab1259:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1262
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1260
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1261

lab1260:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1261:

lab1262:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1265
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1263
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1264

lab1263:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1264:

lab1265:
    jmp lab1267

lab1266:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1267:

lab1269:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_1270]
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

List_Pair_i64_i64_1270:
    jmp near List_Pair_i64_i64_1270_Nil
    jmp near List_Pair_i64_i64_1270_Cons

List_Pair_i64_i64_1270_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1273
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1271
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1271:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1272
    ; ####increment refcount
    add qword [rax + 0], 1

lab1272:
    jmp lab1274

lab1273:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1274:
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

List_Pair_i64_i64_1270_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1277
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1275
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1275:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1276
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1276:
    jmp lab1278

lab1277:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1278:
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
    je lab1290
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1291

lab1290:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1288
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1281
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1279
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1280

lab1279:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1280:

lab1281:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1284
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1282
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1283

lab1282:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1283:

lab1284:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1287
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1285
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1286

lab1285:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1286:

lab1287:
    jmp lab1289

lab1288:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1289:

lab1291:
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

Fun_Pair_i64_i64_List_Pair_i64_i64_1256:

Fun_Pair_i64_i64_List_Pair_i64_i64_1256_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1293
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1292
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1292:
    jmp lab1294

lab1293:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1294:
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
    je lab1306
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1307

lab1306:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1304
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1297
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1295
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1296

lab1295:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1296:

lab1297:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1300
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1298
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1299

lab1298:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1299:

lab1300:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1303
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1301
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1302

lab1301:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1302:

lab1303:
    jmp lab1305

lab1304:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1305:

lab1307:
    ; #load tag
    lea rdi, [rel List_Pair_i64_i64_1308]
    ; jump neighbours_
    jmp neighbours_

List_Pair_i64_i64_1308:
    jmp near List_Pair_i64_i64_1308_Nil
    jmp near List_Pair_i64_i64_1308_Cons

List_Pair_i64_i64_1308_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1311
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1309
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1309:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1310
    ; ####increment refcount
    add qword [rax + 0], 1

lab1310:
    jmp lab1312

lab1311:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1312:
    ; let x5: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; jump lift_nextgen_2_
    jmp lift_nextgen_2_

List_Pair_i64_i64_1308_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1315
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1313
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1313:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1314
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1314:
    jmp lab1316

lab1315:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1316:
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
    je lab1328
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1329

lab1328:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1326
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1319
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1317
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1318

lab1317:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1318:

lab1319:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1322
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1320
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1321

lab1320:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1321:

lab1322:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1325
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1323
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1324

lab1323:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1324:

lab1325:
    jmp lab1327

lab1326:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1327:

lab1329:
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
    je lab1341
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1342

lab1341:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1339
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1332
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1330
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1331

lab1330:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1331:

lab1332:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1335
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1333
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1334

lab1333:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1334:

lab1335:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1338
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1336
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1337

lab1336:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1337:

lab1338:
    jmp lab1340

lab1339:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1340:

lab1342:
    ; #load tag
    lea rdi, [rel List_Pair_i64_i64_1343]
    ; jump occurs3_
    jmp occurs3_

List_Pair_i64_i64_1343:
    jmp near List_Pair_i64_i64_1343_Nil
    jmp near List_Pair_i64_i64_1343_Cons

List_Pair_i64_i64_1343_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1346
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1344
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1344:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1345
    ; ####increment refcount
    add qword [rax + 0], 1

lab1345:
    jmp lab1347

lab1346:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1347:
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

List_Pair_i64_i64_1343_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1350
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1348
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1348:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1349
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1349:
    jmp lab1351

lab1350:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1351:
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
    je lab1363
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1364

lab1363:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1361
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1354
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1352
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1353

lab1352:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1353:

lab1354:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1357
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1355
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1356

lab1355:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1356:

lab1357:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1360
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1358
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1359

lab1358:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1359:

lab1360:
    jmp lab1362

lab1361:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1362:

lab1364:
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
    je lab1376
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1377

lab1376:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1374
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1367
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1365
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1366

lab1365:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1366:

lab1367:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1370
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1368
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1369

lab1368:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1369:

lab1370:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1373
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1371
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1372

lab1371:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1372:

lab1373:
    jmp lab1375

lab1374:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1375:

lab1377:
    ; #load tag
    lea r9, [rel List_Pair_i64_i64_1378]
    ; jump append_
    jmp append_

List_Pair_i64_i64_1378:
    jmp near List_Pair_i64_i64_1378_Nil
    jmp near List_Pair_i64_i64_1378_Cons

List_Pair_i64_i64_1378_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1380
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1379
    ; ####increment refcount
    add qword [rax + 0], 1

lab1379:
    jmp lab1381

lab1380:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1381:
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

List_Pair_i64_i64_1378_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1383
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1382
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1382:
    jmp lab1384

lab1383:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1384:
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
    je lab1396
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1397

lab1396:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1394
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1387
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1385
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1386

lab1385:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1386:

lab1387:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1390
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1388
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1389

lab1388:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1389:

lab1390:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1393
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1391
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1392

lab1391:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1392:

lab1393:
    jmp lab1395

lab1394:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1395:

lab1397:
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
    je lab1409
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1410

lab1409:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1407
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1400
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1398
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1399

lab1398:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1399:

lab1400:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1403
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1401
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1402

lab1401:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1402:

lab1403:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1406
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1404
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1405

lab1404:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1405:

lab1406:
    jmp lab1408

lab1407:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1408:

lab1410:
    ; #load tag
    lea r9, [rel Fun_Pair_i64_i64_Bool_1411]
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

Fun_Pair_i64_i64_Bool_1411:

Fun_Pair_i64_i64_Bool_1411_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1413
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1412
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1412:
    jmp lab1414

lab1413:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1414:
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
    je lab1426
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1427

lab1426:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1424
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1417
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1415
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1416

lab1415:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1416:

lab1417:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1420
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1418
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1419

lab1418:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1419:

lab1420:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1423
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1421
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1422

lab1421:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1422:

lab1423:
    jmp lab1425

lab1424:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1425:

lab1427:
    ; #load tag
    lea r9, [rel Bool_1428]
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

Bool_1428:
    jmp near Bool_1428_True
    jmp near Bool_1428_False

Bool_1428_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1430
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1429
    ; ####increment refcount
    add qword [rax + 0], 1

lab1429:
    jmp lab1431

lab1430:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1431:
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

Bool_1428_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1433
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1432
    ; ####increment refcount
    add qword [rax + 0], 1

lab1432:
    jmp lab1434

lab1433:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1434:
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
    je lab1435
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
    je lab1447
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
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
    lea rdi, [rel Gen_1449]
    ; jump nextgen_
    jmp nextgen_

Gen_1449:

Gen_1449_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1451
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab1450
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1450:
    mov rdi, [rsi + 40]
    jmp lab1452

lab1451:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]

lab1452:
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
    je lab1464
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1465

lab1464:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1462
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1455
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1453
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1454

lab1453:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1454:

lab1455:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1458
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1456
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1457

lab1456:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1457:

lab1458:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1461
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1459
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1460

lab1459:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1460:

lab1461:
    jmp lab1463

lab1462:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1463:

lab1465:
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

lab1435:
    ; then branch
    ; substitute (a0 := a0)(g := g);
    ; #move variables
    mov rsi, rax
    mov rdi, rdx
    mov rax, r8
    mov rdx, r9
    ; switch g \{ ... \};
    ; #there is only one clause, so we can just fall through

Gen_1466:

Gen_1466_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1468
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab1467
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1467:
    jmp lab1469

lab1468:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab1469:
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
    je lab1481
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1482

lab1481:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1479
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1472
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1470
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1471

lab1470:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1471:

lab1472:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1475
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1473
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1474

lab1473:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1474:

lab1475:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1478
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1476
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1477

lab1476:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1477:

lab1478:
    jmp lab1480

lab1479:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1480:

lab1482:
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
    je lab1494
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1495

lab1494:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1492
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1485
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1483
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1484

lab1483:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1484:

lab1485:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1488
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1486
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1487

lab1486:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1487:

lab1488:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1491
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1489
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1490

lab1489:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1490:

lab1491:
    jmp lab1493

lab1492:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1493:

lab1495:
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
    je lab1507
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1508

lab1507:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1505
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1498
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1496
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1497

lab1496:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1497:

lab1498:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1501
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1499
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1500

lab1499:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1500:

lab1501:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1504
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1502
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1503

lab1502:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1503:

lab1504:
    jmp lab1506

lab1505:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1506:

lab1508:
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
    je lab1520
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1521

lab1520:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1518
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1511
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1509
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1510

lab1509:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1510:

lab1511:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1514
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1512
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1513

lab1512:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1513:

lab1514:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1517
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1515
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1516

lab1515:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1516:

lab1517:
    jmp lab1519

lab1518:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1519:

lab1521:
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
    je lab1533
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1534

lab1533:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1531
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1524
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1522
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1523

lab1522:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1523:

lab1524:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1527
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1525
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1526

lab1525:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1526:

lab1527:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1530
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1528
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1529

lab1528:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1529:

lab1530:
    jmp lab1532

lab1531:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1532:

lab1534:
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
    je lab1546
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1547

lab1546:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1544
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1537
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1535
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1536

lab1535:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1536:

lab1537:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1540
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1538
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1539

lab1538:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1539:

lab1540:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1543
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1541
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1542

lab1541:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1542:

lab1543:
    jmp lab1545

lab1544:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1545:

lab1547:
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
    je lab1559
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1560

lab1559:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1557
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1550
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1548
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1549

lab1548:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1549:

lab1550:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1553
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1551
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1552

lab1551:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1552:

lab1553:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1556
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1554
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1555

lab1554:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1555:

lab1556:
    jmp lab1558

lab1557:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1558:

lab1560:
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
    je lab1572
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1573

lab1572:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1570
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1563
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1561
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1562

lab1561:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1562:

lab1563:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1566
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1564
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1565

lab1564:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1565:

lab1566:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1569
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1567
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1568

lab1567:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1568:

lab1569:
    jmp lab1571

lab1570:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1571:

lab1573:
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
    je lab1585
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1586

lab1585:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1583
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1576
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1574
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1575

lab1574:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1575:

lab1576:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1579
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1577
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1578

lab1577:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1578:

lab1579:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1582
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1580
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1581

lab1580:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1581:

lab1582:
    jmp lab1584

lab1583:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1584:

lab1586:
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
    je lab1598
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1599

lab1598:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1596
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1589
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1587
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1588

lab1587:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1588:

lab1589:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1592
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1590
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1591

lab1590:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1591:

lab1592:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1595
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1593
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1594

lab1593:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1594:

lab1595:
    jmp lab1597

lab1596:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1597:

lab1599:
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
    je lab1611
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1612

lab1611:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1609
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1602
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1600
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1601

lab1600:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1601:

lab1602:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1605
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1603
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1604

lab1603:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1604:

lab1605:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1608
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1606
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1607

lab1606:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1607:

lab1608:
    jmp lab1610

lab1609:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1610:

lab1612:
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
    je lab1624
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab1625

lab1624:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1622
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1615
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1613
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1614

lab1613:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1614:

lab1615:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1618
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1616
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1617

lab1616:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1617:

lab1618:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1621
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1619
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1620

lab1619:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1620:

lab1621:
    jmp lab1623

lab1622:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1623:

lab1625:
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
    je lab1637
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1638

lab1637:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1635
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1628
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1626
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1627

lab1626:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1627:

lab1628:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1631
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1629
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1630

lab1629:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1630:

lab1631:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1634
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1632
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1633

lab1632:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1633:

lab1634:
    jmp lab1636

lab1635:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1636:

lab1638:
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
    je lab1650
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1651

lab1650:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1648
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1641
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1639
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1640

lab1639:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1640:

lab1641:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1644
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1642
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1643

lab1642:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1643:

lab1644:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1647
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1645
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1646

lab1645:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1646:

lab1647:
    jmp lab1649

lab1648:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1649:

lab1651:
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
    je lab1663
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1664

lab1663:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1661
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1654
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1652
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1653

lab1652:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1653:

lab1654:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1657
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1655
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1656

lab1655:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1656:

lab1657:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1660
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1658
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1659

lab1658:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1659:

lab1660:
    jmp lab1662

lab1661:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1662:

lab1664:
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
    je lab1676
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1677

lab1676:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1674
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1667
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1665
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1666

lab1665:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1666:

lab1667:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1670
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1668
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1669

lab1668:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1669:

lab1670:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1673
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1671
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1672

lab1671:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1672:

lab1673:
    jmp lab1675

lab1674:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1675:

lab1677:
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
    je lab1689
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1690

lab1689:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1687
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1680
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1678
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1679

lab1678:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1679:

lab1680:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1683
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1681
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1682

lab1681:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1682:

lab1683:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1686
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1684
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1685

lab1684:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1685:

lab1686:
    jmp lab1688

lab1687:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1688:

lab1690:
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
    je lab1702
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab1703

lab1702:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1700
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1693
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1691
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1692

lab1691:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1692:

lab1693:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1696
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1694
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1695

lab1694:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1695:

lab1696:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1699
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1697
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1698

lab1697:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1698:

lab1699:
    jmp lab1701

lab1700:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1701:

lab1703:
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
    je lab1715
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1716

lab1715:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1713
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1706
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1704
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1705

lab1704:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1705:

lab1706:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1709
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1707
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1708

lab1707:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1708:

lab1709:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1712
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1710
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1711

lab1710:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1711:

lab1712:
    jmp lab1714

lab1713:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1714:

lab1716:
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
    je lab1728
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1729

lab1728:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1726
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1719
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1717
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1718

lab1717:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1718:

lab1719:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1722
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1720
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1721

lab1720:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1721:

lab1722:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1725
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1723
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1724

lab1723:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1724:

lab1725:
    jmp lab1727

lab1726:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1727:

lab1729:
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
    je lab1741
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1742

lab1741:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1739
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1732
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1730
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1731

lab1730:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1731:

lab1732:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1735
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1733
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1734

lab1733:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1734:

lab1735:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1738
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1736
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1737

lab1736:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1737:

lab1738:
    jmp lab1740

lab1739:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1740:

lab1742:
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
    je lab1754
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1755

lab1754:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1752
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1745
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1743
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1744

lab1743:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1744:

lab1745:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1748
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1746
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1747

lab1746:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1747:

lab1748:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1751
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1749
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1750

lab1749:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1750:

lab1751:
    jmp lab1753

lab1752:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1753:

lab1755:
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
    je lab1767
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1768

lab1767:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1765
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1758
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1756
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1757

lab1756:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1757:

lab1758:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1761
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1759
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1760

lab1759:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1760:

lab1761:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1764
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1762
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1763

lab1762:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1763:

lab1764:
    jmp lab1766

lab1765:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1766:

lab1768:
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
    je lab1780
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1781

lab1780:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1778
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1771
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1769
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1770

lab1769:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1770:

lab1771:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1774
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1772
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1773

lab1772:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1773:

lab1774:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1777
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1775
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1776

lab1775:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1776:

lab1777:
    jmp lab1779

lab1778:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1779:

lab1781:
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
    je lab1793
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1794

lab1793:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1791
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1784
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1782
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1783

lab1782:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1783:

lab1784:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1787
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1785
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1786

lab1785:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1786:

lab1787:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1790
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1788
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1789

lab1788:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1789:

lab1790:
    jmp lab1792

lab1791:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1792:

lab1794:
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
    je lab1806
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab1807

lab1806:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1804
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1797
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1795
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1796

lab1795:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1796:

lab1797:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1800
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1798
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1799

lab1798:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1799:

lab1800:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1803
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1801
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1802

lab1801:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1802:

lab1803:
    jmp lab1805

lab1804:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1805:

lab1807:
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
    je lab1819
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1820

lab1819:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1817
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1810
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1808
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1809

lab1808:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1809:

lab1810:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1813
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1811
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1812

lab1811:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1812:

lab1813:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1816
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1814
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1815

lab1814:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1815:

lab1816:
    jmp lab1818

lab1817:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1818:

lab1820:
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
    je lab1832
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1833

lab1832:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1830
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1823
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1821
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1822

lab1821:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1822:

lab1823:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1826
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1824
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1825

lab1824:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1825:

lab1826:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1829
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1827
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1828

lab1827:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1828:

lab1829:
    jmp lab1831

lab1830:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1831:

lab1833:
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
    je lab1845
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1846

lab1845:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1843
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1836
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1834
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1835

lab1834:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1835:

lab1836:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1839
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1837
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1838

lab1837:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1838:

lab1839:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1842
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1840
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1841

lab1840:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1841:

lab1842:
    jmp lab1844

lab1843:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1844:

lab1846:
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
    je lab1858
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab1859

lab1858:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1856
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1849
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1847
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1848

lab1847:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1848:

lab1849:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1852
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1850
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1851

lab1850:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1851:

lab1852:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1855
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1853
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1854

lab1853:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1854:

lab1855:
    jmp lab1857

lab1856:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1857:

lab1859:
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
    je lab1871
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1872

lab1871:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1869
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1862
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1860
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1861

lab1860:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1861:

lab1862:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1865
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1863
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1864

lab1863:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1864:

lab1865:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1868
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1866
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1867

lab1866:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1867:

lab1868:
    jmp lab1870

lab1869:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1870:

lab1872:
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
    je lab1884
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1885

lab1884:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1882
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1875
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1873
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1874

lab1873:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1874:

lab1875:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1878
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1876
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1877

lab1876:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1877:

lab1878:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1881
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1879
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1880

lab1879:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1880:

lab1881:
    jmp lab1883

lab1882:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1883:

lab1885:
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
    je lab1897
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1898

lab1897:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1895
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1888
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1886
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1887

lab1886:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1887:

lab1888:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1891
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1889
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1890

lab1889:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1890:

lab1891:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1894
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1892
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1893

lab1892:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1893:

lab1894:
    jmp lab1896

lab1895:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1896:

lab1898:
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
    je lab1910
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1911

lab1910:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1908
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1901
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1899
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1900

lab1899:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1900:

lab1901:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1904
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1902
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1903

lab1902:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1903:

lab1904:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1907
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1905
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1906

lab1905:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1906:

lab1907:
    jmp lab1909

lab1908:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1909:

lab1911:
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
    je lab1923
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1924

lab1923:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1921
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1914
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1912
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1913

lab1912:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1913:

lab1914:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1917
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1915
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1916

lab1915:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1916:

lab1917:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1920
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1918
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1919

lab1918:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1919:

lab1920:
    jmp lab1922

lab1921:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1922:

lab1924:
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
    je lab1936
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1937

lab1936:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1934
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1927
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1925
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1926

lab1925:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1926:

lab1927:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1930
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1928
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1929

lab1928:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1929:

lab1930:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1933
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1931
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1932

lab1931:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1932:

lab1933:
    jmp lab1935

lab1934:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1935:

lab1937:
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
    je lab1949
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1950

lab1949:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1947
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1940
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1938
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1939

lab1938:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1939:

lab1940:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1943
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1941
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1942

lab1941:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1942:

lab1943:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1946
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1944
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1945

lab1944:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1945:

lab1946:
    jmp lab1948

lab1947:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1948:

lab1950:
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
    je lab1962
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab1963

lab1962:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1960
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1953
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1951
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1952

lab1951:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1952:

lab1953:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1956
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1954
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1955

lab1954:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1955:

lab1956:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1959
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1957
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1958

lab1957:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1958:

lab1959:
    jmp lab1961

lab1960:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1961:

lab1963:
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
    je lab1975
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1976

lab1975:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1973
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1966
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1964
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1965

lab1964:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1965:

lab1966:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1969
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1967
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1968

lab1967:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1968:

lab1969:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1972
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1970
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1971

lab1970:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1971:

lab1972:
    jmp lab1974

lab1973:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1974:

lab1976:
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
    je lab1988
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab1989

lab1988:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1986
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1979
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1977
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1978

lab1977:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1978:

lab1979:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1982
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1980
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1981

lab1980:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1981:

lab1982:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1985
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1983
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1984

lab1983:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1984:

lab1985:
    jmp lab1987

lab1986:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1987:

lab1989:
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
    je lab2001
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2002

lab2001:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1999
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1992
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1990
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1991

lab1990:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1991:

lab1992:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1995
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1993
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1994

lab1993:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1994:

lab1995:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1998
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1996
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1997

lab1996:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1997:

lab1998:
    jmp lab2000

lab1999:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2000:

lab2002:
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
    je lab2014
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2015

lab2014:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2012
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2005
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2003
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2004

lab2003:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2004:

lab2005:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2008
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2006
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2007

lab2006:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2007:

lab2008:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2011
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2009
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2010

lab2009:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2010:

lab2011:
    jmp lab2013

lab2012:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2013:

lab2015:
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
    je lab2027
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2028

lab2027:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2025
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2018
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2016
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2017

lab2016:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2017:

lab2018:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2021
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2019
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2020

lab2019:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2020:

lab2021:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2024
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2022
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2023

lab2022:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2023:

lab2024:
    jmp lab2026

lab2025:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2026:

lab2028:
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
    je lab2040
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2041

lab2040:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2038
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2031
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2029
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2030

lab2029:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2030:

lab2031:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2034
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2032
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2033

lab2032:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2033:

lab2034:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2037
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2035
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2036

lab2035:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2036:

lab2037:
    jmp lab2039

lab2038:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2039:

lab2041:
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
    je lab2053
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2054

lab2053:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2051
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2044
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2042
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2043

lab2042:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2043:

lab2044:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2047
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2045
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2046

lab2045:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2046:

lab2047:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2050
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2048
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2049

lab2048:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2049:

lab2050:
    jmp lab2052

lab2051:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2052:

lab2054:
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
    je lab2066
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2067

lab2066:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2064
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2057
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2055
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2056

lab2055:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2056:

lab2057:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2060
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2058
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2059

lab2058:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2059:

lab2060:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2063
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2061
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2062

lab2061:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2062:

lab2063:
    jmp lab2065

lab2064:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2065:

lab2067:
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
    je lab2079
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2080

lab2079:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2077
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2070
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2068
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2069

lab2068:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2069:

lab2070:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2073
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2071
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2072

lab2071:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2072:

lab2073:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2076
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2074
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2075

lab2074:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2075:

lab2076:
    jmp lab2078

lab2077:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2078:

lab2080:
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
    je lab2092
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2093

lab2092:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2090
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2083
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2081
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2082

lab2081:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2082:

lab2083:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2086
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2084
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2085

lab2084:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2085:

lab2086:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2089
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2087
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2088

lab2087:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2088:

lab2089:
    jmp lab2091

lab2090:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2091:

lab2093:
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
    je lab2105
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2106

lab2105:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2103
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2096
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2094
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2095

lab2094:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2095:

lab2096:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2099
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2097
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2098

lab2097:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2098:

lab2099:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2102
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2100
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2101

lab2100:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2101:

lab2102:
    jmp lab2104

lab2103:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2104:

lab2106:
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
    je lab2118
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab2119

lab2118:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2116
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2109
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2107
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2108

lab2107:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2108:

lab2109:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2112
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2110
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2111

lab2110:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2111:

lab2112:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2115
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2113
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2114

lab2113:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2114:

lab2115:
    jmp lab2117

lab2116:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2117:

lab2119:
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
    je lab2131
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2132

lab2131:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2129
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2122
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2120
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2121

lab2120:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2121:

lab2122:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2125
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2123
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2124

lab2123:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2124:

lab2125:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2128
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2126
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2127

lab2126:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2127:

lab2128:
    jmp lab2130

lab2129:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2130:

lab2132:
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
    je lab2144
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2145

lab2144:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2142
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2135
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2133
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2134

lab2133:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2134:

lab2135:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2138
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2136
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2137

lab2136:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2137:

lab2138:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2141
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2139
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2140

lab2139:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2140:

lab2141:
    jmp lab2143

lab2142:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2143:

lab2145:
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
    je lab2157
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2158

lab2157:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2155
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2148
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2146
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2147

lab2146:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2147:

lab2148:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2151
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2149
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2150

lab2149:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2150:

lab2151:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2154
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2152
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2153

lab2152:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2153:

lab2154:
    jmp lab2156

lab2155:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2156:

lab2158:
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
    je lab2170
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2171

lab2170:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2168
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2161
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2159
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2160

lab2159:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2160:

lab2161:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2164
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2162
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2163

lab2162:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2163:

lab2164:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2167
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2165
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2166

lab2165:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2166:

lab2167:
    jmp lab2169

lab2168:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2169:

lab2171:
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
    je lab2183
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2184

lab2183:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2181
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2174
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2172
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2173

lab2172:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2173:

lab2174:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2177
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2175
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2176

lab2175:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2176:

lab2177:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2180
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2178
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2179

lab2178:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2179:

lab2180:
    jmp lab2182

lab2181:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2182:

lab2184:
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
    je lab2196
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2197

lab2196:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2194
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2187
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2185
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2186

lab2185:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2186:

lab2187:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2190
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2188
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2189

lab2188:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2189:

lab2190:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2193
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2191
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2192

lab2191:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2192:

lab2193:
    jmp lab2195

lab2194:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2195:

lab2197:
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
    je lab2209
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2210

lab2209:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2207
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2200
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2198
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2199

lab2198:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2199:

lab2200:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2203
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2201
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2202

lab2201:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2202:

lab2203:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2206
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2204
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2205

lab2204:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2205:

lab2206:
    jmp lab2208

lab2207:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2208:

lab2210:
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
    je lab2222
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab2223

lab2222:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2220
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2213
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2211
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2212

lab2211:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2212:

lab2213:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2216
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2214
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2215

lab2214:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2215:

lab2216:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2219
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2217
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2218

lab2217:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2218:

lab2219:
    jmp lab2221

lab2220:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2221:

lab2223:
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
    je lab2235
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2236

lab2235:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2233
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2226
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2224
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2225

lab2224:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2225:

lab2226:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2229
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2227
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2228

lab2227:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2228:

lab2229:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2232
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2230
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2231

lab2230:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2231:

lab2232:
    jmp lab2234

lab2233:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2234:

lab2236:
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
    je lab2248
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2249

lab2248:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2246
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2239
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2237
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2238

lab2237:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2238:

lab2239:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2242
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2240
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2241

lab2240:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2241:

lab2242:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2245
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2243
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2244

lab2243:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2244:

lab2245:
    jmp lab2247

lab2246:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2247:

lab2249:
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
    je lab2261
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2262

lab2261:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2259
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2252
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2250
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2251

lab2250:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2251:

lab2252:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2255
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2253
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2254

lab2253:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2254:

lab2255:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2258
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2256
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2257

lab2256:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2257:

lab2258:
    jmp lab2260

lab2259:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2260:

lab2262:
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
    je lab2274
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2275

lab2274:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2272
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2265
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2263
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2264

lab2263:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2264:

lab2265:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2268
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2266
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2267

lab2266:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2267:

lab2268:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2271
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2269
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2270

lab2269:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2270:

lab2271:
    jmp lab2273

lab2272:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2273:

lab2275:
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
    je lab2287
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2288

lab2287:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2285
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2278
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2276
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2277

lab2276:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2277:

lab2278:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2281
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2279
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2280

lab2279:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2280:

lab2281:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2284
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2282
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2283

lab2282:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2283:

lab2284:
    jmp lab2286

lab2285:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2286:

lab2288:
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
    je lab2300
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2301

lab2300:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2298
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2291
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2289
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2290

lab2289:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2290:

lab2291:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2294
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2292
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2293

lab2292:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2293:

lab2294:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2297
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2295
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2296

lab2295:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2296:

lab2297:
    jmp lab2299

lab2298:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2299:

lab2301:
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
    je lab2313
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2314

lab2313:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2311
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2304
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2302
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2303

lab2302:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2303:

lab2304:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2307
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2305
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2306

lab2305:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2306:

lab2307:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2310
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2308
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2309

lab2308:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2309:

lab2310:
    jmp lab2312

lab2311:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2312:

lab2314:
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
    je lab2326
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2327

lab2326:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2324
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2317
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2315
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2316

lab2315:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2316:

lab2317:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2320
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2318
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2319

lab2318:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2319:

lab2320:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2323
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2321
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2322

lab2321:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2322:

lab2323:
    jmp lab2325

lab2324:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2325:

lab2327:
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
    je lab2339
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2340

lab2339:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2337
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2330
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2328
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2329

lab2328:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2329:

lab2330:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2333
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2331
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2332

lab2331:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2332:

lab2333:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2336
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2334
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2335

lab2334:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2335:

lab2336:
    jmp lab2338

lab2337:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2338:

lab2340:
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
    je lab2352
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2353

lab2352:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2350
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2343
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2341
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2342

lab2341:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2342:

lab2343:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2346
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2344
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2345

lab2344:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2345:

lab2346:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2349
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2347
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2348

lab2347:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2348:

lab2349:
    jmp lab2351

lab2350:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2351:

lab2353:
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
    je lab2365
    ; ####initialize refcount of just acquired block
    mov qword [rcx + 0], 0
    jmp lab2366

lab2365:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2363
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2356
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2354
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2355

lab2354:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2355:

lab2356:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2359
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2357
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2358

lab2357:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2358:

lab2359:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2362
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2360
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2361

lab2360:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2361:

lab2362:
    jmp lab2364

lab2363:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2364:

lab2366:
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
    je lab2378
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab2379

lab2378:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2376
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2369
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2367
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2368

lab2367:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2368:

lab2369:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2372
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2370
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2371

lab2370:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2371:

lab2372:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2375
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2373
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2374

lab2373:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2374:

lab2375:
    jmp lab2377

lab2376:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2377:

lab2379:
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
    je lab2391
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2392

lab2391:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2389
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2382
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2380
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2381

lab2380:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2381:

lab2382:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2385
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2383
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2384

lab2383:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2384:

lab2385:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2388
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2386
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2387

lab2386:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2387:

lab2388:
    jmp lab2390

lab2389:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2390:

lab2392:
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
    je lab2404
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2405

lab2404:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2402
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2395
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2393
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2394

lab2393:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2394:

lab2395:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2398
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2396
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2397

lab2396:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2397:

lab2398:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2401
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2399
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2400

lab2399:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2400:

lab2401:
    jmp lab2403

lab2402:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2403:

lab2405:
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
    je lab2417
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2418

lab2417:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2415
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2408
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2406
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2407

lab2406:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2407:

lab2408:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2411
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2409
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2410

lab2409:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2410:

lab2411:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2414
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2412
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2413

lab2412:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2413:

lab2414:
    jmp lab2416

lab2415:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2416:

lab2418:
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
    je lab2430
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2431

lab2430:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2428
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2421
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2419
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2420

lab2419:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2420:

lab2421:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2424
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2422
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2423

lab2422:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2423:

lab2424:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2427
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2425
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2426

lab2425:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2426:

lab2427:
    jmp lab2429

lab2428:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2429:

lab2431:
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
    je lab2443
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2444

lab2443:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2441
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2434
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2432
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2433

lab2432:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2433:

lab2434:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2437
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2435
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2436

lab2435:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2436:

lab2437:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2440
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2438
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2439

lab2438:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2439:

lab2440:
    jmp lab2442

lab2441:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2442:

lab2444:
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
    je lab2456
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2457

lab2456:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2454
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2447
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2445
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2446

lab2445:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2446:

lab2447:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2450
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2448
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2449

lab2448:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2449:

lab2450:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2453
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2451
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2452

lab2451:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2452:

lab2453:
    jmp lab2455

lab2454:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2455:

lab2457:
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
    je lab2469
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2470

lab2469:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2467
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2460
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2458
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2459

lab2458:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2459:

lab2460:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2463
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2461
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2462

lab2461:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2462:

lab2463:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2466
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2464
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2465

lab2464:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2465:

lab2466:
    jmp lab2468

lab2467:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2468:

lab2470:
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
    je lab2482
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab2483

lab2482:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2480
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2473
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2471
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2472

lab2471:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2472:

lab2473:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2476
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2474
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2475

lab2474:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2475:

lab2476:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2479
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2477
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2478

lab2477:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2478:

lab2479:
    jmp lab2481

lab2480:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2481:

lab2483:
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
    je lab2495
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2496

lab2495:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2493
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2486
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2484
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2485

lab2484:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2485:

lab2486:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2489
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2487
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2488

lab2487:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2488:

lab2489:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2492
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2490
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2491

lab2490:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2491:

lab2492:
    jmp lab2494

lab2493:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2494:

lab2496:
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
    je lab2508
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2509

lab2508:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2506
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2499
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2497
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2498

lab2497:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2498:

lab2499:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2502
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2500
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2501

lab2500:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2501:

lab2502:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2505
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2503
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2504

lab2503:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2504:

lab2505:
    jmp lab2507

lab2506:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2507:

lab2509:
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
    je lab2521
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2522

lab2521:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2519
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2512
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2510
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2511

lab2510:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2511:

lab2512:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2515
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2513
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2514

lab2513:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2514:

lab2515:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2518
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2516
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2517

lab2516:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2517:

lab2518:
    jmp lab2520

lab2519:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2520:

lab2522:
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
    je lab2534
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2535

lab2534:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2532
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2525
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2523
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2524

lab2523:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2524:

lab2525:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2528
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2526
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2527

lab2526:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2527:

lab2528:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2531
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2529
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2530

lab2529:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2530:

lab2531:
    jmp lab2533

lab2532:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2533:

lab2535:
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
    je lab2547
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2548

lab2547:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2545
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2538
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2536
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2537

lab2536:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2537:

lab2538:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2541
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2539
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2540

lab2539:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2540:

lab2541:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2544
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2542
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2543

lab2542:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2543:

lab2544:
    jmp lab2546

lab2545:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2546:

lab2548:
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
    je lab2560
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2561

lab2560:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2558
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2551
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2549
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2550

lab2549:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2550:

lab2551:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2554
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2552
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2553

lab2552:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2553:

lab2554:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2557
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2555
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2556

lab2555:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2556:

lab2557:
    jmp lab2559

lab2558:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2559:

lab2561:
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
    je lab2573
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2574

lab2573:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2571
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2564
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2562
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2563

lab2562:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2563:

lab2564:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2567
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2565
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2566

lab2565:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2566:

lab2567:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2570
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2568
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2569

lab2568:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2569:

lab2570:
    jmp lab2572

lab2571:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2572:

lab2574:
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
    je lab2586
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2587

lab2586:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2584
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2577
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2575
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2576

lab2575:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2576:

lab2577:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2580
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2578
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2579

lab2578:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2579:

lab2580:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2583
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2581
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2582

lab2581:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2582:

lab2583:
    jmp lab2585

lab2584:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2585:

lab2587:
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
    je lab2599
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2600

lab2599:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2597
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2590
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2588
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2589

lab2588:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2589:

lab2590:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2593
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2591
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2592

lab2591:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2592:

lab2593:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2596
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2594
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2595

lab2594:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2595:

lab2596:
    jmp lab2598

lab2597:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2598:

lab2600:
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
    je lab2612
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2613

lab2612:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2610
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2603
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2601
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2602

lab2601:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2602:

lab2603:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2606
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2604
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2605

lab2604:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2605:

lab2606:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2609
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2607
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2608

lab2607:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2608:

lab2609:
    jmp lab2611

lab2610:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2611:

lab2613:
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

Fun_i64_Unit_2614:

Fun_i64_Unit_2614_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab2616
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab2615
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2615:
    mov rdx, [rax + 40]
    jmp lab2617

lab2616:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]

lab2617:
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
    je lab2629
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab2630

lab2629:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2627
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2620
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2618
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2619

lab2618:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2619:

lab2620:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2623
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2621
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2622

lab2621:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2622:

lab2623:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2626
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2624
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2625

lab2624:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2625:

lab2626:
    jmp lab2628

lab2627:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2628:

lab2630:
    ; #load tag
    lea rdx, [rel Gen_2631]
    ; jump gun_
    jmp gun_

Gen_2631:

Gen_2631_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab2633
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab2632
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2632:
    mov rdi, [rsi + 40]
    jmp lab2634

lab2633:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]

lab2634:
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
    je lab2646
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2647

lab2646:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2644
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2637
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2635
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2636

lab2635:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2636:

lab2637:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2640
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2638
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2639

lab2638:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2639:

lab2640:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2643
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2641
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2642

lab2641:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2642:

lab2643:
    jmp lab2645

lab2644:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2645:

lab2647:
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
    je lab2659
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2660

lab2659:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2657
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2650
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2648
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2649

lab2648:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2649:

lab2650:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2653
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2651
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2652

lab2651:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2652:

lab2653:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2656
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2654
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2655

lab2654:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2655:

lab2656:
    jmp lab2658

lab2657:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2658:

lab2660:
    ; #load tag
    lea r9, [rel Gen_2661]
    ; jump nthgen_
    jmp nthgen_

Gen_2661:

Gen_2661_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab2663
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab2662
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2662:
    jmp lab2664

lab2663:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab2664:
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
    je lab2676
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2677

lab2676:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2674
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2667
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2665
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2666

lab2665:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2666:

lab2667:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2670
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2668
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2669

lab2668:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2669:

lab2670:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2673
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2671
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2672

lab2671:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2672:

lab2673:
    jmp lab2675

lab2674:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2675:

lab2677:
    ; #load tag
    mov rdi, 0
    ; substitute (a1 := a1);
    ; #erase gen
    cmp rsi, 0
    je lab2680
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab2678
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab2679

lab2678:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab2679:

lab2680:
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
    je lab2692
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2693

lab2692:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2690
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2683
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2681
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2682

lab2681:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2682:

lab2683:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2686
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2684
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2685

lab2684:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2685:

lab2686:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2689
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2687
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2688

lab2687:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2688:

lab2689:
    jmp lab2691

lab2690:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2691:

lab2693:
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
    je lab2705
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2706

lab2705:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2703
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2696
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2694
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2695

lab2694:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2695:

lab2696:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2699
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2697
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2698

lab2697:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2698:

lab2699:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2702
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2700
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2701

lab2700:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2701:

lab2702:
    jmp lab2704

lab2703:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2704:

lab2706:
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
    je lab2718
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2719

lab2718:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2716
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2709
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2707
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2708

lab2707:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2708:

lab2709:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2712
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2710
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2711

lab2710:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2711:

lab2712:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2715
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2713
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2714

lab2713:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2714:

lab2715:
    jmp lab2717

lab2716:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2717:

lab2719:
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
    je lab2731
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2732

lab2731:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2729
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2722
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2720
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2721

lab2720:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2721:

lab2722:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2725
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2723
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2724

lab2723:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2724:

lab2725:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2728
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2726
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2727

lab2726:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2727:

lab2728:
    jmp lab2730

lab2729:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2730:

lab2732:
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
    je lab2744
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2745

lab2744:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2742
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2735
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2733
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2734

lab2733:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2734:

lab2735:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2738
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2736
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2737

lab2736:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2737:

lab2738:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2741
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2739
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2740

lab2739:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2740:

lab2741:
    jmp lab2743

lab2742:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2743:

lab2745:
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
    je lab2757
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2758

lab2757:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2755
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2748
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2746
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2747

lab2746:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2747:

lab2748:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2751
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2749
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2750

lab2749:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2750:

lab2751:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2754
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2752
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2753

lab2752:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2753:

lab2754:
    jmp lab2756

lab2755:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2756:

lab2758:
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
    je lab2770
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2771

lab2770:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2768
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2761
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2759
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2760

lab2759:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2760:

lab2761:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2764
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2762
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2763

lab2762:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2763:

lab2764:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2767
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2765
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2766

lab2765:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2766:

lab2767:
    jmp lab2769

lab2768:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2769:

lab2771:
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
    je lab2783
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2784

lab2783:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2781
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2774
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2772
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2773

lab2772:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2773:

lab2774:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2777
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2775
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2776

lab2775:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2776:

lab2777:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2780
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2778
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2779

lab2778:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2779:

lab2780:
    jmp lab2782

lab2781:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2782:

lab2784:
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
    je lab2796
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2797

lab2796:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2794
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2787
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2785
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2786

lab2785:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2786:

lab2787:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2790
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2788
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2789

lab2788:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2789:

lab2790:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2793
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2791
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2792

lab2791:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2792:

lab2793:
    jmp lab2795

lab2794:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2795:

lab2797:
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
    je lab2809
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2810

lab2809:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2807
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2800
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2798
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2799

lab2798:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2799:

lab2800:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2803
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2801
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2802

lab2801:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2802:

lab2803:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2806
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2804
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2805

lab2804:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2805:

lab2806:
    jmp lab2808

lab2807:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2808:

lab2810:
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
    je lab2822
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2823

lab2822:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2820
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2813
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2811
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2812

lab2811:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2812:

lab2813:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2816
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2814
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2815

lab2814:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2815:

lab2816:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2819
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2817
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2818

lab2817:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2818:

lab2819:
    jmp lab2821

lab2820:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2821:

lab2823:
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
    je lab2835
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2836

lab2835:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2833
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2826
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2824
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2825

lab2824:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2825:

lab2826:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2829
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2827
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2828

lab2827:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2828:

lab2829:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2832
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2830
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2831

lab2830:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2831:

lab2832:
    jmp lab2834

lab2833:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2834:

lab2836:
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
    je lab2848
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2849

lab2848:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2846
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2839
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2837
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2838

lab2837:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2838:

lab2839:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2842
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2840
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2841

lab2840:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2841:

lab2842:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2845
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2843
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2844

lab2843:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2844:

lab2845:
    jmp lab2847

lab2846:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2847:

lab2849:
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
    je lab2861
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2862

lab2861:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2859
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2852
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2850
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2851

lab2850:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2851:

lab2852:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2855
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2853
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2854

lab2853:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2854:

lab2855:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2858
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2856
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2857

lab2856:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2857:

lab2858:
    jmp lab2860

lab2859:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2860:

lab2862:
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
    je lab2874
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2875

lab2874:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2872
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2865
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2863
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2864

lab2863:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2864:

lab2865:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2868
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2866
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2867

lab2866:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2867:

lab2868:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2871
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2869
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2870

lab2869:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2870:

lab2871:
    jmp lab2873

lab2872:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2873:

lab2875:
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
    je lab2887
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2888

lab2887:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2885
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2878
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2876
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2877

lab2876:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2877:

lab2878:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2881
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2879
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2880

lab2879:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2880:

lab2881:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2884
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2882
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2883

lab2882:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2883:

lab2884:
    jmp lab2886

lab2885:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2886:

lab2888:
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
    je lab2900
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2901

lab2900:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2898
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2891
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2889
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2890

lab2889:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2890:

lab2891:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2894
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2892
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2893

lab2892:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2893:

lab2894:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2897
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2895
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2896

lab2895:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2896:

lab2897:
    jmp lab2899

lab2898:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2899:

lab2901:
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
    je lab2913
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2914

lab2913:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2911
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2904
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2902
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2903

lab2902:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2903:

lab2904:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2907
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2905
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2906

lab2905:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2906:

lab2907:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2910
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2908
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2909

lab2908:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2909:

lab2910:
    jmp lab2912

lab2911:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2912:

lab2914:
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
    je lab2926
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2927

lab2926:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2924
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2917
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2915
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2916

lab2915:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2916:

lab2917:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2920
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2918
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2919

lab2918:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2919:

lab2920:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2923
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2921
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2922

lab2921:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2922:

lab2923:
    jmp lab2925

lab2924:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2925:

lab2927:
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
    je lab2939
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2940

lab2939:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2937
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2930
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2928
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2929

lab2928:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2929:

lab2930:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2933
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2931
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2932

lab2931:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2932:

lab2933:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2936
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2934
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2935

lab2934:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2935:

lab2936:
    jmp lab2938

lab2937:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2938:

lab2940:
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
    je lab2952
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2953

lab2952:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2950
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2943
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2941
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2942

lab2941:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2942:

lab2943:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2946
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2944
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2945

lab2944:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2945:

lab2946:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2949
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2947
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2948

lab2947:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2948:

lab2949:
    jmp lab2951

lab2950:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2951:

lab2953:
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
    je lab2965
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2966

lab2965:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2963
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2956
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2954
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2955

lab2954:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2955:

lab2956:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2959
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2957
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2958

lab2957:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2958:

lab2959:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2962
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2960
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2961

lab2960:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2961:

lab2962:
    jmp lab2964

lab2963:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2964:

lab2966:
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
    je lab2978
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2979

lab2978:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2976
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2969
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2967
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2968

lab2967:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2968:

lab2969:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2972
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2970
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2971

lab2970:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2971:

lab2972:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2975
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2973
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2974

lab2973:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2974:

lab2975:
    jmp lab2977

lab2976:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2977:

lab2979:
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
    je lab2991
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2992

lab2991:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2989
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2982
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2980
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2981

lab2980:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2981:

lab2982:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2985
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2983
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2984

lab2983:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2984:

lab2985:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2988
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2986
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2987

lab2986:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2987:

lab2988:
    jmp lab2990

lab2989:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2990:

lab2992:
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
    je lab3004
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3005

lab3004:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3002
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2995
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2993
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2994

lab2993:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2994:

lab2995:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2998
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2996
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2997

lab2996:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2997:

lab2998:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3001
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2999
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3000

lab2999:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3000:

lab3001:
    jmp lab3003

lab3002:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3003:

lab3005:
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
    je lab3017
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3018

lab3017:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3015
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3008
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3006
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3007

lab3006:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3007:

lab3008:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3011
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3009
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3010

lab3009:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3010:

lab3011:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3014
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3012
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3013

lab3012:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3013:

lab3014:
    jmp lab3016

lab3015:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3016:

lab3018:
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
    je lab3030
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab3031

lab3030:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3028
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3021
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3019
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3020

lab3019:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3020:

lab3021:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3024
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3022
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3023

lab3022:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3023:

lab3024:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3027
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3025
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3026

lab3025:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3026:

lab3027:
    jmp lab3029

lab3028:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3029:

lab3031:
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
    je lab3043
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3044

lab3043:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3041
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3034
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3032
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3033

lab3032:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3033:

lab3034:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3037
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3035
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3036

lab3035:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3036:

lab3037:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3040
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3038
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3039

lab3038:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3039:

lab3040:
    jmp lab3042

lab3041:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3042:

lab3044:
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
    je lab3056
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3057

lab3056:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3054
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3047
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3045
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3046

lab3045:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3046:

lab3047:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3050
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3048
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3049

lab3048:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3049:

lab3050:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3053
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3051
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3052

lab3051:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3052:

lab3053:
    jmp lab3055

lab3054:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3055:

lab3057:
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
    je lab3069
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3070

lab3069:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3067
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3060
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3058
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3059

lab3058:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3059:

lab3060:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3063
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3061
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3062

lab3061:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3062:

lab3063:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3066
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3064
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3065

lab3064:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3065:

lab3066:
    jmp lab3068

lab3067:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3068:

lab3070:
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
    je lab3082
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3083

lab3082:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3080
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3073
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3071
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3072

lab3071:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3072:

lab3073:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3076
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3074
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3075

lab3074:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3075:

lab3076:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3079
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3077
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3078

lab3077:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3078:

lab3079:
    jmp lab3081

lab3080:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3081:

lab3083:
    ; #load tag
    lea r9, [rel Fun_Pair_i64_i64_Pair_i64_i64_3084]
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

Fun_Pair_i64_i64_Pair_i64_i64_3084:

Fun_Pair_i64_i64_Pair_i64_i64_3084_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3086
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3085
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3085:
    jmp lab3087

lab3086:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3087:
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

Pair_i64_i64_3088:

Pair_i64_i64_3088_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3089
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r9, [r8 + 40]
    jmp lab3090

lab3089:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r9, [r8 + 40]

lab3090:
    ; substitute (snd1 := snd1)(a1 := a1)(fst1 := fst1)(p := p);
    ; #move variables
    mov r10, rax
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; switch p \{ ... \};
    ; #there is only one clause, so we can just fall through

Pair_i64_i64_3091:

Pair_i64_i64_3091_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab3092
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r11, [r10 + 40]
    jmp lab3093

lab3092:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r11, [r10 + 40]

lab3093:
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
    je lab3105
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3106

lab3105:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3103
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3096
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3094
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3095

lab3094:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3095:

lab3096:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3099
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3097
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3098

lab3097:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3098:

lab3099:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3102
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3100
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3101

lab3100:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3101:

lab3102:
    jmp lab3104

lab3103:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3104:

lab3106:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3107]
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
    je lab3119
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3120

lab3119:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3117
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3110
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3108
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3109

lab3108:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3109:

lab3110:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3113
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3111
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3112

lab3111:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3112:

lab3113:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3116
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3114
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3115

lab3114:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3115:

lab3116:
    jmp lab3118

lab3117:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3118:

lab3120:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3121]
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
    je lab3133
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3134

lab3133:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3131
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3124
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3122
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3123

lab3122:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3123:

lab3124:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3127
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3125
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3126

lab3125:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3126:

lab3127:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3130
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3128
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3129

lab3128:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3129:

lab3130:
    jmp lab3132

lab3131:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3132:

lab3134:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3135]
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
    je lab3147
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3148

lab3147:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3145
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3138
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3136
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3137

lab3136:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3137:

lab3138:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3141
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3139
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3140

lab3139:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3140:

lab3141:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3144
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3142
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3143

lab3142:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3143:

lab3144:
    jmp lab3146

lab3145:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3146:

lab3148:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3149]
    ; jump bail_
    jmp bail_

List_Pair_i64_i64_3149:
    jmp near List_Pair_i64_i64_3149_Nil
    jmp near List_Pair_i64_i64_3149_Cons

List_Pair_i64_i64_3149_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3151
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3150
    ; ####increment refcount
    add qword [rax + 0], 1

lab3150:
    jmp lab3152

lab3151:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3152:
    ; let x3: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_non_steady_4_
    jmp lift_non_steady_4_

List_Pair_i64_i64_3149_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3154
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3153
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3153:
    jmp lab3155

lab3154:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3155:
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
    je lab3167
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3168

lab3167:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3165
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3158
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3156
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3157

lab3156:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3157:

lab3158:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3161
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3159
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3160

lab3159:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3160:

lab3161:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3164
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3162
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3163

lab3162:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3163:

lab3164:
    jmp lab3166

lab3165:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3166:

lab3168:
    ; #load tag
    mov rdi, 5
    ; jump lift_non_steady_4_
    jmp lift_non_steady_4_

List_Pair_i64_i64_3135:
    jmp near List_Pair_i64_i64_3135_Nil
    jmp near List_Pair_i64_i64_3135_Cons

List_Pair_i64_i64_3135_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3170
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3169
    ; ####increment refcount
    add qword [rax + 0], 1

lab3169:
    jmp lab3171

lab3170:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3171:
    ; let x2: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_non_steady_2_
    jmp lift_non_steady_2_

List_Pair_i64_i64_3135_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3173
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3172
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3172:
    jmp lab3174

lab3173:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3174:
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
    je lab3186
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3187

lab3186:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3184
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3177
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3175
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3176

lab3175:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3176:

lab3177:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3180
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3178
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3179

lab3178:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3179:

lab3180:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3183
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3181
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3182

lab3181:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3182:

lab3183:
    jmp lab3185

lab3184:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3185:

lab3187:
    ; #load tag
    mov rdi, 5
    ; jump lift_non_steady_2_
    jmp lift_non_steady_2_

List_Pair_i64_i64_3121:
    jmp near List_Pair_i64_i64_3121_Nil
    jmp near List_Pair_i64_i64_3121_Cons

List_Pair_i64_i64_3121_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3189
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3188
    ; ####increment refcount
    add qword [rax + 0], 1

lab3188:
    jmp lab3190

lab3189:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3190:
    ; let x1: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_non_steady_0_
    jmp lift_non_steady_0_

List_Pair_i64_i64_3121_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3192
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3191
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3191:
    jmp lab3193

lab3192:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3193:
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
    je lab3205
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3206

lab3205:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3203
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3196
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3194
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3195

lab3194:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3195:

lab3196:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3199
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3197
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3198

lab3197:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3198:

lab3199:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3202
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3200
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3201

lab3200:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3201:

lab3202:
    jmp lab3204

lab3203:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3204:

lab3206:
    ; #load tag
    mov rdi, 5
    ; jump lift_non_steady_0_
    jmp lift_non_steady_0_

List_Pair_i64_i64_3107:
    jmp near List_Pair_i64_i64_3107_Nil
    jmp near List_Pair_i64_i64_3107_Cons

List_Pair_i64_i64_3107_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3208
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3207
    ; ####increment refcount
    add qword [rax + 0], 1

lab3207:
    jmp lab3209

lab3208:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3209:
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

List_Pair_i64_i64_3107_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3211
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3210
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3210:
    jmp lab3212

lab3211:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3212:
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
    je lab3224
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3225

lab3224:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3222
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3215
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3213
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3214

lab3213:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3214:

lab3215:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3218
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3216
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3217

lab3216:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3217:

lab3218:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3221
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3219
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3220

lab3219:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3220:

lab3221:
    jmp lab3223

lab3222:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3223:

lab3225:
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
    je lab3237
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3238

lab3237:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3235
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3228
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3226
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3227

lab3226:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3227:

lab3228:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3231
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3229
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3230

lab3229:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3230:

lab3231:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3234
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3232
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3233

lab3232:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3233:

lab3234:
    jmp lab3236

lab3235:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3236:

lab3238:
    ; #load tag
    lea rdx, [rel _Cont_3239]
    ; jump centerLine_
    jmp centerLine_

_Cont_3239:

_Cont_3239_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab3242
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab3240
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3240:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab3241
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3241:
    jmp lab3243

lab3242:
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

lab3243:
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
    je lab3255
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3256

lab3255:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3253
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3246
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3244
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3245

lab3244:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3245:

lab3246:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab3254

lab3253:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3254:

lab3256:
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
    je lab3268
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3269

lab3268:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3266
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3259
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3257
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3258

lab3257:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3258:

lab3259:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3262
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3260
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3261

lab3260:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3261:

lab3262:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3265
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3263
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3264

lab3263:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3264:

lab3265:
    jmp lab3267

lab3266:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3267:

lab3269:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3270]
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
    je lab3282
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3283

lab3282:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3280
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3276
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3274
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3275

lab3274:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3275:

lab3276:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3279
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3277
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3278

lab3277:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3278:

lab3279:
    jmp lab3281

lab3280:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3281:

lab3283:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3284]
    ; jump bail_
    jmp bail_

List_Pair_i64_i64_3284:
    jmp near List_Pair_i64_i64_3284_Nil
    jmp near List_Pair_i64_i64_3284_Cons

List_Pair_i64_i64_3284_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3286
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3285
    ; ####increment refcount
    add qword [rax + 0], 1

lab3285:
    jmp lab3287

lab3286:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3287:
    ; let x8: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_non_steady_3_
    jmp lift_non_steady_3_

List_Pair_i64_i64_3284_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3289
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3288
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3288:
    jmp lab3290

lab3289:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3290:
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
    je lab3302
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3303

lab3302:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3300
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3293
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3291
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3292

lab3291:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3292:

lab3293:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3296
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3294
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3295

lab3294:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3295:

lab3296:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3299
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3297
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3298

lab3297:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3298:

lab3299:
    jmp lab3301

lab3300:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3301:

lab3303:
    ; #load tag
    mov rdi, 5
    ; jump lift_non_steady_3_
    jmp lift_non_steady_3_

List_Pair_i64_i64_3270:
    jmp near List_Pair_i64_i64_3270_Nil
    jmp near List_Pair_i64_i64_3270_Cons

List_Pair_i64_i64_3270_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3306
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab3304
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3304:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab3305
    ; ####increment refcount
    add qword [rax + 0], 1

lab3305:
    jmp lab3307

lab3306:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab3307:
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

List_Pair_i64_i64_3270_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3310
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab3308
    ; ####increment refcount
    add qword [r10 + 0], 1

lab3308:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
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
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab3311:
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
    je lab3323
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    je lab3336
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3337

lab3336:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3334
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3327
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3325
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3326

lab3325:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3326:

lab3327:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3330
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3328
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3329

lab3328:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3329:

lab3330:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3333
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3331
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3332

lab3331:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3332:

lab3333:
    jmp lab3335

lab3334:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3335:

lab3337:
    ; #load tag
    lea rdx, [rel _Cont_3338]
    ; jump centerLine_
    jmp centerLine_

_Cont_3338:

_Cont_3338_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab3341
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab3339
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3339:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab3340
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3340:
    jmp lab3342

lab3341:
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

lab3342:
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
    je lab3354
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3355

lab3354:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3352
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3345
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3343
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3344

lab3343:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3344:

lab3345:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab3353

lab3352:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3353:

lab3355:
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
    je lab3367
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3368

lab3367:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3365
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3358
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3356
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3357

lab3356:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3357:

lab3358:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3361
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3359
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3360

lab3359:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3360:

lab3361:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3364
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3362
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3363

lab3362:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3363:

lab3364:
    jmp lab3366

lab3365:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3366:

lab3368:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3369]
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
    je lab3381
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3382

lab3381:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3379
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3375
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3373
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3374

lab3373:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3374:

lab3375:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3378
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3376
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3377

lab3376:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3377:

lab3378:
    jmp lab3380

lab3379:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3380:

lab3382:
    ; #load tag
    lea rdx, [rel List_Pair_i64_i64_3383]
    ; jump shuttle_
    jmp shuttle_

List_Pair_i64_i64_3383:
    jmp near List_Pair_i64_i64_3383_Nil
    jmp near List_Pair_i64_i64_3383_Cons

List_Pair_i64_i64_3383_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3385
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab3384
    ; ####increment refcount
    add qword [rax + 0], 1

lab3384:
    jmp lab3386

lab3385:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab3386:
    ; let x13: List[Pair[i64, i64]] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; jump lift_non_steady_1_
    jmp lift_non_steady_1_

List_Pair_i64_i64_3383_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3388
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab3387
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3387:
    jmp lab3389

lab3388:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab3389:
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
    je lab3401
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3402

lab3401:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3399
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3392
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3390
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3391

lab3390:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3391:

lab3392:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3395
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3393
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3394

lab3393:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3394:

lab3395:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3398
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3396
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3397

lab3396:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3397:

lab3398:
    jmp lab3400

lab3399:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3400:

lab3402:
    ; #load tag
    mov rdi, 5
    ; jump lift_non_steady_1_
    jmp lift_non_steady_1_

List_Pair_i64_i64_3369:
    jmp near List_Pair_i64_i64_3369_Nil
    jmp near List_Pair_i64_i64_3369_Cons

List_Pair_i64_i64_3369_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3405
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab3403
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3403:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab3404
    ; ####increment refcount
    add qword [rax + 0], 1

lab3404:
    jmp lab3406

lab3405:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab3406:
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

List_Pair_i64_i64_3369_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab3409
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab3407
    ; ####increment refcount
    add qword [r10 + 0], 1

lab3407:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
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
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab3410:
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
    je lab3422
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    je lab3435
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3436

lab3435:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3433
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3426
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3424
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3425

lab3424:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3425:

lab3426:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3429
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3427
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3428

lab3427:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3428:

lab3429:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3432
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3430
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3431

lab3430:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3431:

lab3432:
    jmp lab3434

lab3433:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3434:

lab3436:
    ; #load tag
    lea rdx, [rel _Cont_3437]
    ; jump centerLine_
    jmp centerLine_

_Cont_3437:

_Cont_3437_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab3440
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab3438
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3438:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab3439
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3439:
    jmp lab3441

lab3440:
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

lab3441:
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
    je lab3453
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3454

lab3453:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3451
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3444
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3442
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3443

lab3442:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3443:

lab3444:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab3452

lab3451:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3452:

lab3454:
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

Fun_i64_Unit_3455:

Fun_i64_Unit_3455_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3457
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab3456
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3456:
    mov rdx, [rax + 40]
    jmp lab3458

lab3457:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]

lab3458:
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
    je lab3470
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab3471

lab3470:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3468
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3461
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3459
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3460

lab3459:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3460:

lab3461:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3464
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3462
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3463

lab3462:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3463:

lab3464:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3467
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3465
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3466

lab3465:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3466:

lab3467:
    jmp lab3469

lab3468:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3469:

lab3471:
    ; #load tag
    lea rdx, [rel Gen_3472]
    ; jump non_steady_
    jmp non_steady_

Gen_3472:

Gen_3472_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab3474
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab3473
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3473:
    mov rdi, [rsi + 40]
    jmp lab3475

lab3474:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]

lab3475:
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
    je lab3487
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3488

lab3487:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3485
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3478
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3476
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3477

lab3476:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3477:

lab3478:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3481
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3479
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3480

lab3479:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3480:

lab3481:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3484
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3482
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3483

lab3482:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3483:

lab3484:
    jmp lab3486

lab3485:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3486:

lab3488:
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
    je lab3500
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3501

lab3500:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3498
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3491
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3489
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3490

lab3489:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3490:

lab3491:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3494
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3492
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3493

lab3492:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3493:

lab3494:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3497
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3495
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3496

lab3495:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3496:

lab3497:
    jmp lab3499

lab3498:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3499:

lab3501:
    ; #load tag
    lea r9, [rel Gen_3502]
    ; jump nthgen_
    jmp nthgen_

Gen_3502:

Gen_3502_Gen:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab3504
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab3503
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3503:
    jmp lab3505

lab3504:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab3505:
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
    je lab3517
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab3518

lab3517:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3515
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3508
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3506
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3507

lab3506:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3507:

lab3508:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3511
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3509
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3510

lab3509:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3510:

lab3511:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3514
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3512
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3513

lab3512:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3513:

lab3514:
    jmp lab3516

lab3515:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3516:

lab3518:
    ; #load tag
    mov rdi, 0
    ; substitute (a1 := a1);
    ; #erase gen
    cmp rsi, 0
    je lab3521
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab3519
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab3520

lab3519:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab3520:

lab3521:
    ; invoke a1 Unit
    ; #there is only one clause, so we can jump there directly
    jmp rdx

go_loop_:
    ; if iters == 0 \{ ... \}
    cmp rdx, 0
    je lab3522
    ; else branch
    ; substitute (go0 := go)(steps0 := steps)(go := go)(a0 := a0)(iters := iters)(steps := steps);
    ; #share go
    cmp r8, 0
    je lab3523
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3523:
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
    je lab3535
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab3536

lab3535:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3533
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3526
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3524
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3525

lab3524:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3525:

lab3526:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab3534

lab3533:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3534:

lab3536:
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
    je lab3548
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab3549

lab3548:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab3546
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab3539
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3537
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3538

lab3537:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3538:

lab3539:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab3542
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3540
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3541

lab3540:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3541:

lab3542:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab3545
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab3543
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab3544

lab3543:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab3544:

lab3545:
    jmp lab3547

lab3546:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab3547:

lab3549:
    ; #load tag
    lea r9, [rel Unit_3550]
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

Unit_3550:

Unit_3550_Unit:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab3553
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab3551
    ; ####increment refcount
    add qword [rax + 0], 1

lab3551:
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab3552
    ; ####increment refcount
    add qword [rsi + 0], 1

lab3552:
    jmp lab3554

lab3553:
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

lab3554:
    ; let res: Unit = Unit();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; substitute (go := go)(a0 := a0)(iters := iters)(steps := steps);
    ; #erase res
    cmp r12, 0
    je lab3557
    ; ######check refcount
    cmp qword [r12 + 0], 0
    je lab3555
    ; ######either decrement refcount ...
    add qword [r12 + 0], -1
    jmp lab3556

lab3555:
    ; ######... or add block to lazy free list
    mov [r12 + 0], rbp
    mov rbp, r12

lab3556:

lab3557:
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

lab3522:
    ; then branch
    ; substitute (a0 := a0);
    ; #erase go
    cmp r8, 0
    je lab3560
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab3558
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab3559

lab3558:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab3559:

lab3560:
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