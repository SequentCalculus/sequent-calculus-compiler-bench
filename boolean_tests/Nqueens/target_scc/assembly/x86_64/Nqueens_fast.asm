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

neq_i_:
    ; if i1 == i2 \{ ... \}
    cmp rdx, rdi
    je lab2
    ; else branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 True
    add rdx, 0
    jmp rdx

lab2:
    ; then branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 False
    add rdx, 5
    jmp rdx

length_:
    ; substitute (a0 := a0)(l := l);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_List_i64_3]
    add rcx, rdi
    jmp rcx

List_List_i64_3:
    jmp near List_List_i64_3_Nil
    jmp near List_List_i64_3_Cons

List_List_i64_3_Nil:
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

List_List_i64_3_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab6
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab4
    ; ####increment refcount
    add qword [r8 + 0], 1

lab4:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab5
    ; ####increment refcount
    add qword [rsi + 0], 1

lab5:
    jmp lab7

lab6:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab7:
    ; substitute (a0 := a0)(ls := ls);
    ; #erase i
    cmp rsi, 0
    je lab10
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab8
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab9

lab8:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab9:

lab10:
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; lit x0 <- 1;
    mov r9, 1
    ; substitute (ls := ls)(a0 := a0)(x0 := x0);
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
    ; jump length_
    jmp length_

_Cont_24:

_Cont_24_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab26
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
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
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab27:
    ; x3 <- x0 + x1;
    mov r11, r9
    add r11, rdx
    ; substitute (x3 := x3)(a0 := a0);
    ; #move variables
    mov rdx, r11
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

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
    lea rcx, [rel List_List_i64_28]
    add rcx, r9
    jmp rcx

List_List_i64_28:
    jmp near List_List_i64_28_Nil
    jmp near List_List_i64_28_Cons

List_List_i64_28_Nil:
    ; switch l2 \{ ... \};
    lea rcx, [rel List_List_i64_29]
    add rcx, rdi
    jmp rcx

List_List_i64_29:
    jmp near List_List_i64_29_Nil
    jmp near List_List_i64_29_Cons

List_List_i64_29_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_List_i64_29_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab32
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab30
    ; ####increment refcount
    add qword [r8 + 0], 1

lab30:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab31
    ; ####increment refcount
    add qword [rsi + 0], 1

lab31:
    jmp lab33

lab32:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab33:
    ; substitute (a2 := a2)(as0 := as0)(a0 := a0);
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

List_List_i64_28_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab36
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab34
    ; ####increment refcount
    add qword [r10 + 0], 1

lab34:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab35
    ; ####increment refcount
    add qword [r8 + 0], 1

lab35:
    jmp lab37

lab36:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab37:
    ; substitute (iss := iss)(l2 := l2)(is := is)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; create a1: List[List[i64]] = (is, a0)\{ ... \};
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
    je lab49
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab50

lab49:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab47
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab48

lab47:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab48:

lab50:
    ; #load tag
    lea r9, [rel List_List_i64_51]
    ; jump append_
    jmp append_

List_List_i64_51:
    jmp near List_List_i64_51_Nil
    jmp near List_List_i64_51_Cons

List_List_i64_51_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab54
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab52
    ; ####increment refcount
    add qword [rsi + 0], 1

lab52:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab53
    ; ####increment refcount
    add qword [rax + 0], 1

lab53:
    jmp lab55

lab54:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab55:
    ; let x0: List[List[i64]] = Nil();
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

List_List_i64_51_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab58
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab56
    ; ####increment refcount
    add qword [r10 + 0], 1

lab56:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab57
    ; ####increment refcount
    add qword [r8 + 0], 1

lab57:
    jmp lab59

lab58:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab59:
    ; substitute (a0 := a0)(is := is)(a3 := a3)(as1 := as1);
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
    ; let x0: List[List[i64]] = Cons(a3, as1);
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
    je lab71
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab72

lab71:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab69
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab68
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab66
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab67

lab66:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab67:

lab68:
    jmp lab70

lab69:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab70:

lab72:
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

safe_:
    ; substitute (x := x)(d := d)(a0 := a0)(l := l);
    ; #move variables
    mov rcx, r10
    mov r10, r8
    mov r8, rcx
    mov rcx, r11
    mov r11, r9
    mov r9, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_i64_73]
    add rcx, r11
    jmp rcx

List_i64_73:
    jmp near List_i64_73_Nil
    jmp near List_i64_73_Cons

List_i64_73_Nil:
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 True
    add rdx, 0
    jmp rdx

List_i64_73_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab75
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab74
    ; ####increment refcount
    add qword [r12 + 0], 1

lab74:
    mov r11, [r10 + 40]
    jmp lab76

lab75:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]

lab76:
    ; if x == q \{ ... \}
    cmp rdx, r11
    je lab77
    ; else branch
    ; x0 <- q + d;
    mov r15, r11
    add r15, rdi
    ; if x == x0 \{ ... \}
    cmp rdx, r15
    je lab78
    ; else branch
    ; substitute (x := x)(d := d)(a0 := a0)(q := q)(l0 := l0);
    ; x1 <- q - d;
    mov r15, r11
    sub r15, rdi
    ; if x == x1 \{ ... \}
    cmp rdx, r15
    je lab79
    ; else branch
    ; substitute (x := x)(d := d)(a0 := a0)(l0 := l0);
    ; #move variables
    mov r10, r12
    mov r11, r13
    ; lit x2 <- 1;
    mov r13, 1
    ; x3 <- d + x2;
    mov r15, rdi
    add r15, r13
    ; substitute (x := x)(x3 := x3)(l0 := l0)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, r8
    mov r8, rcx
    mov rcx, r11
    mov r11, r9
    mov r9, rcx
    mov rdi, r15
    ; jump safe_
    jmp safe_

lab79:
    ; then branch
    ; substitute (a0 := a0);
    ; #erase l0
    cmp r12, 0
    je lab82
    ; ######check refcount
    cmp qword [r12 + 0], 0
    je lab80
    ; ######either decrement refcount ...
    add qword [r12 + 0], -1
    jmp lab81

lab80:
    ; ######... or add block to lazy free list
    mov [r12 + 0], rbp
    mov rbp, r12

lab81:

lab82:
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 False
    add rdx, 5
    jmp rdx

lab78:
    ; then branch
    ; substitute (a0 := a0);
    ; #erase l0
    cmp r12, 0
    je lab85
    ; ######check refcount
    cmp qword [r12 + 0], 0
    je lab83
    ; ######either decrement refcount ...
    add qword [r12 + 0], -1
    jmp lab84

lab83:
    ; ######... or add block to lazy free list
    mov [r12 + 0], rbp
    mov rbp, r12

lab84:

lab85:
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 False
    add rdx, 5
    jmp rdx

lab77:
    ; then branch
    ; substitute (a0 := a0);
    ; #erase l0
    cmp r12, 0
    je lab88
    ; ######check refcount
    cmp qword [r12 + 0], 0
    je lab86
    ; ######either decrement refcount ...
    add qword [r12 + 0], -1
    jmp lab87

lab86:
    ; ######... or add block to lazy free list
    mov [r12 + 0], rbp
    mov rbp, r12

lab87:

lab88:
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 False
    add rdx, 5
    jmp rdx

check_:
    ; substitute (a0 := a0)(acc := acc)(q := q)(l := l);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_List_i64_89]
    add rcx, r11
    jmp rcx

List_List_i64_89:
    jmp near List_List_i64_89_Nil
    jmp near List_List_i64_89_Cons

List_List_i64_89_Nil:
    ; substitute (a0 := a0)(acc := acc);
    ; switch acc \{ ... \};
    lea rcx, [rel List_List_i64_90]
    add rcx, rdi
    jmp rcx

List_List_i64_90:
    jmp near List_List_i64_90_Nil
    jmp near List_List_i64_90_Cons

List_List_i64_90_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_List_i64_90_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab93
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab91
    ; ####increment refcount
    add qword [r8 + 0], 1

lab91:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab92
    ; ####increment refcount
    add qword [rsi + 0], 1

lab92:
    jmp lab94

lab93:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab94:
    ; substitute (a2 := a2)(as0 := as0)(a0 := a0);
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

List_List_i64_89_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab97
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab95
    ; ####increment refcount
    add qword [r12 + 0], 1

lab95:
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]
    cmp r10, 0
    je lab96
    ; ####increment refcount
    add qword [r10 + 0], 1

lab96:
    jmp lab98

lab97:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]

lab98:
    ; lit x0 <- 1;
    mov r15, 1
    ; substitute (x0 := x0)(b0 := b)(q1 := q)(b := b)(bs := bs)(q := q)(a0 := a0)(acc := acc);
    ; #share b
    cmp r10, 0
    je lab99
    ; ####increment refcount
    add qword [r10 + 0], 1

lab99:
    ; #move variables
    mov [rsp + 2032], rax
    mov [rsp + 2024], rdx
    mov [rsp + 2016], rsi
    mov [rsp + 2008], rdi
    mov rdx, r15
    mov r15, r9
    mov rsi, r10
    mov rdi, r11
    ; create a1: Bool = (b, bs, q, a0, acc)\{ ... \};
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
    mov [rbx + 24], r15
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab111
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
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
    ; ##store link to previous block
    mov [rbx + 48], r14
    ; ##store values
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
    je lab124
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab125

lab124:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab122
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab115
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab113
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab114

lab113:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab114:

lab115:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab118
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab116
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab117

lab116:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab117:

lab118:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab121
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab119
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab120

lab119:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab120:

lab121:
    jmp lab123

lab122:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab123:

lab125:
    ; #load tag
    lea r11, [rel Bool_126]
    ; substitute (q1 := q1)(x0 := x0)(b0 := b0)(a1 := a1);
    ; #move variables
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov r8, rsi
    ; jump safe_
    jmp safe_

Bool_126:
    jmp near Bool_126_True
    jmp near Bool_126_False

Bool_126_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab131
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab127
    ; ####increment refcount
    add qword [rsi + 0], 1

lab127:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab128
    ; ####increment refcount
    add qword [rax + 0], 1

lab128:
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab129
    ; ####increment refcount
    add qword [r12 + 0], 1

lab129:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab130
    ; ####increment refcount
    add qword [r10 + 0], 1

lab130:
    mov r9, [r8 + 24]
    jmp lab132

lab131:
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
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]

lab132:
    ; substitute (acc := acc)(bs := bs)(q := q)(a0 := a0)(q0 := q)(b := b);
    ; #move variables
    mov r14, rax
    mov r15, rdx
    mov rdx, r13
    mov r13, r9
    mov rax, r12
    ; let x1: List[i64] = Cons(q0, b);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r15
    mov [rbx + 48], r14
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
    je lab144
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab145

lab144:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab142
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab135
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab133
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab134

lab133:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab134:

lab135:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab138
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab136
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab137

lab136:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab137:

lab138:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab141
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab139
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab140

lab139:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab140:

lab141:
    jmp lab143

lab142:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab143:

lab145:
    ; #load tag
    mov r13, 5
    ; substitute (a0 := a0)(bs := bs)(q := q)(x1 := x1)(acc := acc);
    ; #move variables
    mov rcx, r10
    mov r10, r12
    mov r12, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, r13
    mov r13, rdx
    mov rdx, rcx
    ; let x2: List[List[i64]] = Cons(x1, acc);
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
    je lab157
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab158

lab157:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab155
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab151
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab149
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab150

lab149:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab150:

lab151:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab154
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab152
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab153

lab152:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab153:

lab154:
    jmp lab156

lab155:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab156:

lab158:
    ; #load tag
    mov r11, 5
    ; substitute (bs := bs)(x2 := x2)(q := q)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r11
    mov r11, rdx
    mov rdx, rcx
    ; jump check_
    jmp check_

Bool_126_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab163
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab159
    ; ####increment refcount
    add qword [rsi + 0], 1

lab159:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab160
    ; ####increment refcount
    add qword [rax + 0], 1

lab160:
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab161
    ; ####increment refcount
    add qword [r12 + 0], 1

lab161:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab162
    ; ####increment refcount
    add qword [r10 + 0], 1

lab162:
    mov r9, [r8 + 24]
    jmp lab164

lab163:
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
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]

lab164:
    ; substitute (bs := bs)(acc := acc)(q := q)(a0 := a0);
    ; #erase b
    cmp rax, 0
    je lab167
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab165
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab166

lab165:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab166:

lab167:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    mov rsi, r12
    mov rdi, r13
    ; jump check_
    jmp check_

enumerate_:
    ; if q == 0 \{ ... \}
    cmp rdx, 0
    je lab168
    ; else branch
    ; let x0: List[List[i64]] = Nil();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; substitute (q0 := q)(x0 := x0)(bs0 := bs)(a0 := a0)(bs := bs)(q := q)(acc := acc);
    ; #share bs
    cmp r8, 0
    je lab169
    ; ####increment refcount
    add qword [r8 + 0], 1

lab169:
    ; #move variables
    mov r15, rdx
    mov [rsp + 2032], rsi
    mov [rsp + 2024], rdi
    mov rsi, r12
    mov r12, r8
    mov rdi, r13
    mov r13, r9
    ; create a2: List[List[i64]] = (a0, bs, q, acc)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
    mov [rbx + 40], r15
    mov qword [rbx + 32], 0
    mov [rbx + 24], r13
    mov [rbx + 16], r12
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab181
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab182

lab181:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab179
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab172
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab170
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab171

lab170:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab171:

lab172:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab175
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab173
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab174

lab173:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab174:

lab175:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab178
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab176
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab177

lab176:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab177:

lab178:
    jmp lab180

lab179:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab180:

lab182:
    ; ##store link to previous block
    mov [rbx + 48], r12
    ; ##store values
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
    je lab194
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab195

lab194:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab192
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab191
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab189
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab190

lab189:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab190:

lab191:
    jmp lab193

lab192:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab193:

lab195:
    ; #load tag
    lea r11, [rel List_List_i64_196]
    ; substitute (bs0 := bs0)(x0 := x0)(q0 := q0)(a2 := a2);
    ; #move variables
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r8
    ; jump check_
    jmp check_

List_List_i64_196:
    jmp near List_List_i64_196_Nil
    jmp near List_List_i64_196_Cons

List_List_i64_196_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab200
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab197
    ; ####increment refcount
    add qword [rax + 0], 1

lab197:
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab198
    ; ####increment refcount
    add qword [r10 + 0], 1

lab198:
    mov r9, [rsi + 40]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab199
    ; ####increment refcount
    add qword [rsi + 0], 1

lab199:
    jmp lab201

lab200:
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
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]

lab201:
    ; let res: List[List[i64]] = Nil();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; substitute (a0 := a0)(acc := acc)(bs := bs)(q := q)(res := res);
    ; #move variables
    mov r8, rsi
    mov rcx, r11
    mov r11, r9
    mov r9, rdi
    mov rdi, rcx
    mov rsi, r10
    ; jump lift_enumerate_0_
    jmp lift_enumerate_0_

List_List_i64_196_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab205
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load link to next block
    mov r10, [r8 + 48]
    ; ###load values
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab202
    ; ####increment refcount
    add qword [r8 + 0], 1

lab202:
    ; ###load values
    mov r15, [r10 + 56]
    mov r14, [r10 + 48]
    cmp r14, 0
    je lab203
    ; ####increment refcount
    add qword [r14 + 0], 1

lab203:
    mov r13, [r10 + 40]
    mov r11, [r10 + 24]
    mov r10, [r10 + 16]
    cmp r10, 0
    je lab204
    ; ####increment refcount
    add qword [r10 + 0], 1

lab204:
    jmp lab206

lab205:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load link to next block
    mov r10, [r8 + 48]
    ; ###load values
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r15, [r10 + 56]
    mov r14, [r10 + 48]
    mov r13, [r10 + 40]
    mov r11, [r10 + 24]
    mov r10, [r10 + 16]

lab206:
    ; substitute (acc := acc)(q := q)(a0 := a0)(bs := bs)(a5 := a5)(as2 := as2);
    ; #move variables
    mov r12, rax
    mov rcx, r15
    mov r15, rdi
    mov rdi, r13
    mov r13, rdx
    mov rdx, rcx
    mov rax, r14
    mov r14, rsi
    ; let res: List[List[i64]] = Cons(a5, as2);
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
    je lab218
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
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
    mov r13, 5
    ; substitute (a0 := a0)(acc := acc)(bs := bs)(q := q)(res := res);
    ; #move variables
    mov rsi, rax
    mov rcx, r9
    mov r9, r11
    mov r11, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, r8
    mov r8, r10
    ; jump lift_enumerate_0_
    jmp lift_enumerate_0_

lab168:
    ; then branch
    ; substitute (a0 := a0)(acc := acc);
    ; #erase bs
    cmp r8, 0
    je lab222
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab220
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab221

lab220:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab221:

lab222:
    ; #move variables
    mov rax, r10
    mov rdx, r11
    ; switch acc \{ ... \};
    lea rcx, [rel List_List_i64_223]
    add rcx, rdi
    jmp rcx

List_List_i64_223:
    jmp near List_List_i64_223_Nil
    jmp near List_List_i64_223_Cons

List_List_i64_223_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_List_i64_223_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab226
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab224
    ; ####increment refcount
    add qword [r8 + 0], 1

lab224:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab225
    ; ####increment refcount
    add qword [rsi + 0], 1

lab225:
    jmp lab227

lab226:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab227:
    ; substitute (a3 := a3)(as0 := as0)(a0 := a0);
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

lift_enumerate_0_:
    ; lit x1 <- 1;
    mov r15, 1
    ; x2 <- q - x1;
    mov rcx, r11
    sub rcx, r15
    mov [rsp + 2024], rcx
    ; substitute (res := res)(acc := acc)(bs := bs)(a0 := a0)(x2 := x2);
    ; #move variables
    mov r10, rax
    mov r11, rdx
    mov rax, r12
    mov rdx, r13
    mov r13, [rsp + 2024]
    ; create a1: List[List[i64]] = (bs, a0, x2)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov qword [rbx + 48], 0
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
    je lab239
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab240

lab239:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab237
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab230
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab228
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab229

lab228:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab229:

lab230:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab238

lab237:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab238:

lab240:
    ; #load tag
    lea r9, [rel List_List_i64_241]
    ; jump append_
    jmp append_

List_List_i64_241:
    jmp near List_List_i64_241_Nil
    jmp near List_List_i64_241_Cons

List_List_i64_241_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab244
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab242
    ; ####increment refcount
    add qword [rsi + 0], 1

lab242:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab243
    ; ####increment refcount
    add qword [rax + 0], 1

lab243:
    jmp lab245

lab244:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]

lab245:
    ; let x3: List[List[i64]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (x2 := x2)(x3 := x3)(bs := bs)(a0 := a0);
    ; #move variables
    mov r8, rax
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; jump enumerate_
    jmp enumerate_

List_List_i64_241_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab248
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab246
    ; ####increment refcount
    add qword [r10 + 0], 1

lab246:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab247
    ; ####increment refcount
    add qword [r8 + 0], 1

lab247:
    jmp lab249

lab248:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r13, [r8 + 56]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]

lab249:
    ; substitute (x2 := x2)(a0 := a0)(bs := bs)(a4 := a4)(as1 := as1);
    ; #move variables
    mov r12, rsi
    mov rsi, r10
    mov r10, rax
    mov rcx, r13
    mov r13, rdi
    mov rdi, r11
    mov r11, rdx
    mov rdx, rcx
    ; let x3: List[List[i64]] = Cons(a4, as1);
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
    je lab261
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab262

lab261:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab259
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab252
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab250
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab251

lab250:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab251:

lab252:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab255
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab253
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab254

lab253:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab254:

lab255:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab258
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab256
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab257

lab256:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab257:

lab258:
    jmp lab260

lab259:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab260:

lab262:
    ; #load tag
    mov r11, 5
    ; substitute (x2 := x2)(x3 := x3)(bs := bs)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; jump enumerate_
    jmp enumerate_

gen_:
    ; if n == 0 \{ ... \}
    cmp rdx, 0
    je lab263
    ; else branch
    ; lit x2 <- 1;
    mov r11, 1
    ; x3 <- n - x2;
    mov r13, rdx
    sub r13, r11
    ; substitute (x3 := x3)(nq0 := nq)(a0 := a0)(nq := nq);
    ; #move variables
    mov r11, rdi
    mov rdx, r13
    ; create a1: List[List[i64]] = (a0, nq)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov qword [rbx + 48], 0
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
    lea r9, [rel List_List_i64_277]
    ; jump gen_
    jmp gen_

List_List_i64_277:
    jmp near List_List_i64_277_Nil
    jmp near List_List_i64_277_Cons

List_List_i64_277_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab279
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
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
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab280:
    ; let bs: List[List[i64]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (a0 := a0)(bs := bs)(nq := nq);
    ; #move variables
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    mov rsi, r8
    ; jump lift_gen_0_
    jmp lift_gen_0_

List_List_i64_277_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab282
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab281
    ; ####increment refcount
    add qword [r8 + 0], 1

lab281:
    jmp lab283

lab282:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab283:
    ; substitute (nq := nq)(a0 := a0)(a2 := a2)(as0 := as0);
    ; #move variables
    mov r10, rsi
    mov rsi, r8
    mov r8, rax
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; let bs: List[List[i64]] = Cons(a2, as0);
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
    je lab295
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab296

lab295:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab293
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab286
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab284
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab285

lab284:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab285:

lab286:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab289
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab287
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab288

lab287:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab288:

lab289:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab292
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab290
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab291

lab290:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab291:

lab292:
    jmp lab294

lab293:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab294:

lab296:
    ; #load tag
    mov r9, 5
    ; substitute (a0 := a0)(bs := bs)(nq := nq);
    ; #move variables
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, rsi
    mov rsi, r8
    ; jump lift_gen_0_
    jmp lift_gen_0_

lab263:
    ; then branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; let x0: List[i64] = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; let x1: List[List[i64]] = Nil();
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

lift_gen_0_:
    ; let x4: List[List[i64]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (nq := nq)(x4 := x4)(bs := bs)(a0 := a0);
    ; #move variables
    mov r8, rsi
    mov rsi, r10
    mov r10, rax
    mov rcx, r9
    mov r9, rdi
    mov rdi, r11
    mov r11, rdx
    mov rdx, rcx
    ; jump enumerate_
    jmp enumerate_

nsoln_:
    ; create a1: List[List[i64]] = (a0)\{ ... \};
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
    je lab308
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab309

lab308:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab306
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab299
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab297
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab298

lab297:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab298:

lab299:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab302
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab300
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab301

lab300:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab301:

lab302:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab305
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab303
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab304

lab303:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab304:

lab305:
    jmp lab307

lab306:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab307:

lab309:
    ; #load tag
    lea rdi, [rel List_List_i64_310]
    ; substitute (n := n)(n0 := n)(a1 := a1);
    ; #move variables
    mov r9, rdi
    mov rdi, rdx
    mov r8, rsi
    ; jump gen_
    jmp gen_

List_List_i64_310:
    jmp near List_List_i64_310_Nil
    jmp near List_List_i64_310_Cons

List_List_i64_310_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab312
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab311
    ; ####increment refcount
    add qword [rax + 0], 1

lab311:
    jmp lab313

lab312:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab313:
    ; let x0: List[List[i64]] = Nil();
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
    ; jump length_
    jmp length_

List_List_i64_310_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab315
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab314
    ; ####increment refcount
    add qword [r8 + 0], 1

lab314:
    jmp lab316

lab315:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab316:
    ; substitute (a0 := a0)(a2 := a2)(as0 := as0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let x0: List[List[i64]] = Cons(a2, as0);
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
    je lab328
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab329

lab328:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab326
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab319
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab317
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab318

lab317:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab318:

lab319:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab322
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab320
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab321

lab320:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab321:

lab322:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab325
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab323
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab324

lab323:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab324:

lab325:
    jmp lab327

lab326:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab327:

lab329:
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
    ; jump length_
    jmp length_

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
    je lab341
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab342

lab341:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab339
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab332
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab330
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab331

lab330:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab331:

lab332:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab335
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab333
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab334

lab333:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab334:

lab335:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab338
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab336
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab337

lab336:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab337:

lab338:
    jmp lab340

lab339:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab340:

lab342:
    ; #load tag
    lea rdi, [rel _Cont_343]
    ; jump nsoln_
    jmp nsoln_

_Cont_343:

_Cont_343_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab345
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab344
    ; ####increment refcount
    add qword [r8 + 0], 1

lab344:
    mov rdi, [rsi + 24]
    jmp lab346

lab345:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]

lab346:
    ; lit x0 <- 1;
    mov r13, 1
    ; if iters == x0 \{ ... \}
    cmp r11, r13
    je lab347
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
    ; jump main_loop_
    jmp main_loop_

lab347:
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