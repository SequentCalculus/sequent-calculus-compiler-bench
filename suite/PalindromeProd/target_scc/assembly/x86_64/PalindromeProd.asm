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

powi_:
    ; if e == 0 \{ ... \}
    cmp rdi, 0
    je lab2
    ; else branch
    ; lit x0 <- 1;
    mov r11, 1
    ; if e == x0 \{ ... \}
    cmp rdi, r11
    je lab3
    ; else branch
    ; substitute (b0 := b)(e := e)(a0 := a0)(b := b);
    ; #move variables
    mov r11, rdx
    ; create a1: _Cont = (a0, b)\{ ... \};
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
    je lab15
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    lea r9, [rel _Cont_17]
    ; lit x2 <- 1;
    mov r11, 1
    ; x3 <- e - x2;
    mov r13, rdi
    sub r13, r11
    ; substitute (b0 := b0)(x3 := x3)(a1 := a1);
    ; #move variables
    mov rdi, r13
    ; powi(...)
    jmp powi_

_Cont_17:

_Cont_17_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab19
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab18
    ; ####increment refcount
    add qword [rsi + 0], 1

lab18:
    jmp lab20

lab19:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab20:
    ; x5 <- b * x1;
    mov r11, r9
    imul r11, rdx
    ; substitute (x5 := x5)(a0 := a0);
    ; #move variables
    mov rdx, r11
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

lab3:
    ; then branch
    ; substitute (b := b)(a0 := a0);
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

lab2:
    ; then branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; lit x4 <- 1;
    mov rdi, 1
    ; substitute (x4 := x4)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

rev_acc_:
    ; substitute (a0 := a0)(acc := acc)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_21]
    add rcx, r9
    jmp rcx

List_21:
    jmp near List_21_Nil
    jmp near List_21_Cons

List_21_Nil:
    ; switch acc \{ ... \};
    lea rcx, [rel List_22]
    add rcx, rdi
    jmp rcx

List_22:
    jmp near List_22_Nil
    jmp near List_22_Cons

List_22_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_22_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab24
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab23
    ; ####increment refcount
    add qword [r8 + 0], 1

lab23:
    mov rdi, [rsi + 40]
    jmp lab25

lab24:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]

lab25:
    ; substitute (x1 := x1)(xs0 := xs0)(a0 := a0);
    ; #move variables
    mov rsi, r8
    mov r8, rax
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Cons
    add r9, 5
    jmp r9

List_21_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab27
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab26
    ; ####increment refcount
    add qword [r10 + 0], 1

lab26:
    mov r9, [r8 + 40]
    jmp lab28

lab27:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab28:
    ; substitute (a0 := a0)(xs := xs)(x := x)(acc := acc);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; let x0: List = Cons(x, acc);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
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
    je lab40
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab41

lab40:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab38
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab34
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab32
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab33

lab32:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab33:

lab34:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab39

lab38:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab39:

lab41:
    ; #load tag
    mov r9, 5
    ; substitute (xs := xs)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; rev_acc(...)
    jmp rev_acc_

rev_:
    ; let x0: List = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (l := l)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; rev_acc(...)
    jmp rev_acc_

digits_acc_:
    ; lit x0 <- 10;
    mov r11, 10
    ; if n < x0 \{ ... \}
    cmp rdx, r11
    jl lab42
    ; else branch
    ; substitute (n := n)(acc := acc)(a0 := a0);
    ; lit x1 <- 10;
    mov r11, 10
    ; x2 <- n / x1;
    mov rcx, rdx
    mov r13, rax
    mov rax, rdx
    cqo
    idiv r11
    mov rdx, rax
    mov rax, r13
    mov r13, rdx
    mov rdx, rcx
    ; substitute (n := n)(acc := acc)(a0 := a0)(x2 := x2);
    ; #move variables
    mov r11, r13
    ; lit x3 <- 10;
    mov r13, 10
    ; x4 <- n % x3;
    mov rcx, rdx
    mov r15, rax
    mov rax, rdx
    cqo
    idiv r13
    mov rax, r15
    mov r15, rdx
    mov rdx, rcx
    ; substitute (x2 := x2)(a0 := a0)(x4 := x4)(acc := acc);
    ; #move variables
    mov r10, rsi
    mov rdx, r11
    mov r11, rdi
    mov rsi, r8
    mov rdi, r9
    mov r9, r15
    ; let x5: List = Cons(x4, acc);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
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
    je lab54
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab55

lab54:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab52
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab51
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab49
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab50

lab49:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab50:

lab51:
    jmp lab53

lab52:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab53:

lab55:
    ; #load tag
    mov r9, 5
    ; substitute (x2 := x2)(x5 := x5)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; digits_acc(...)
    jmp digits_acc_

lab42:
    ; then branch
    ; substitute (n := n)(acc := acc)(a0 := a0);
    ; invoke a0 Cons
    add r9, 5
    jmp r9

digits_:
    ; let x0: List = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (n := n)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; digits_acc(...)
    jmp digits_acc_

list_eq_:
    ; substitute (a0 := a0)(l2 := l2)(l1 := l1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l1 \{ ... \};
    lea rcx, [rel List_56]
    add rcx, r9
    jmp rcx

List_56:
    jmp near List_56_Nil
    jmp near List_56_Cons

List_56_Nil:
    ; switch l2 \{ ... \};
    lea rcx, [rel List_57]
    add rcx, rdi
    jmp rcx

List_57:
    jmp near List_57_Nil
    jmp near List_57_Cons

List_57_Nil:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

List_57_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab59
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab58
    ; ####increment refcount
    add qword [r8 + 0], 1

lab58:
    mov rdi, [rsi + 40]
    jmp lab60

lab59:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]

lab60:
    ; substitute (a0 := a0);
    ; #erase xs
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
    ; invoke a0 False
    add rdx, 5
    jmp rdx

List_56_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab65
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab64
    ; ####increment refcount
    add qword [r10 + 0], 1

lab64:
    mov r9, [r8 + 40]
    jmp lab66

lab65:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab66:
    ; substitute (a0 := a0)(xs1 := xs1)(x1 := x1)(l2 := l2);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; switch l2 \{ ... \};
    lea rcx, [rel List_67]
    add rcx, r11
    jmp rcx

List_67:
    jmp near List_67_Nil
    jmp near List_67_Cons

List_67_Nil:
    ; substitute (a0 := a0);
    ; #erase xs1
    cmp rsi, 0
    je lab70
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab68
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab69

lab68:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab69:

lab70:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

List_67_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab72
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab71
    ; ####increment refcount
    add qword [r12 + 0], 1

lab71:
    mov r11, [r10 + 40]
    jmp lab73

lab72:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]

lab73:
    ; if x1 == x2 \{ ... \}
    cmp r9, r11
    je lab74
    ; else branch
    ; substitute (a0 := a0);
    ; #erase xs1
    cmp rsi, 0
    je lab77
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab75
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab76

lab75:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab76:

lab77:
    ; #erase xs2
    cmp r12, 0
    je lab80
    ; ######check refcount
    cmp qword [r12 + 0], 0
    je lab78
    ; ######either decrement refcount ...
    add qword [r12 + 0], -1
    jmp lab79

lab78:
    ; ######... or add block to lazy free list
    mov [r12 + 0], rbp
    mov rbp, r12

lab79:

lab80:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

lab74:
    ; then branch
    ; substitute (xs1 := xs1)(xs2 := xs2)(a0 := a0);
    ; #move variables
    mov r8, rax
    mov r9, rdx
    mov rax, rsi
    mov rdx, rdi
    mov rsi, r12
    mov rdi, r13
    ; list_eq(...)
    jmp list_eq_

is_palindrome_:
    ; create a2: List = (a0)\{ ... \};
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
    je lab92
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab93

lab92:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab90
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab89
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab87
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab88

lab87:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab88:

lab89:
    jmp lab91

lab90:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab91:

lab93:
    ; #load tag
    lea rdi, [rel List_94]
    ; digits(...)
    jmp digits_

List_94:
    jmp near List_94_Nil
    jmp near List_94_Cons

List_94_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab96
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab95
    ; ####increment refcount
    add qword [rax + 0], 1

lab95:
    jmp lab97

lab96:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab97:
    ; let digits: List = Nil();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; lift_is_palindrome_0(...)
    jmp lift_is_palindrome_0_

List_94_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab99
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab98
    ; ####increment refcount
    add qword [r8 + 0], 1

lab98:
    jmp lab100

lab99:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab100:
    ; substitute (a0 := a0)(x2 := x2)(xs1 := xs1);
    ; #move variables
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, r8
    mov r8, rsi
    ; let digits: List = Cons(x2, xs1);
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
    je lab112
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab113

lab112:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab110
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab109
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab107
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab108

lab107:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab108:

lab109:
    jmp lab111

lab110:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab111:

lab113:
    ; #load tag
    mov rdi, 5
    ; lift_is_palindrome_0(...)
    jmp lift_is_palindrome_0_

lift_is_palindrome_0_:
    ; substitute (digits0 := digits)(digits := digits)(a0 := a0);
    ; #share digits
    cmp rsi, 0
    je lab114
    ; ####increment refcount
    add qword [rsi + 0], 1

lab114:
    ; #move variables
    mov r8, rax
    mov r9, rdx
    mov rax, rsi
    mov rdx, rdi
    ; create a1: List = (digits, a0)\{ ... \};
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
    je lab126
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab127

lab126:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab124
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab117
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab115
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab116

lab115:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab116:

lab117:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab120
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab118
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab119

lab118:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab119:

lab120:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab125

lab124:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab125:

lab127:
    ; #load tag
    lea rdi, [rel List_128]
    ; rev(...)
    jmp rev_

List_128:
    jmp near List_128_Nil
    jmp near List_128_Cons

List_128_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab131
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab129
    ; ####increment refcount
    add qword [rsi + 0], 1

lab129:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab130
    ; ####increment refcount
    add qword [rax + 0], 1

lab130:
    jmp lab132

lab131:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab132:
    ; let x0: List = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (digits := digits)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; list_eq(...)
    jmp list_eq_

List_128_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab135
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab133
    ; ####increment refcount
    add qword [r10 + 0], 1

lab133:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab134
    ; ####increment refcount
    add qword [r8 + 0], 1

lab134:
    jmp lab136

lab135:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab136:
    ; substitute (a0 := a0)(digits := digits)(x1 := x1)(xs0 := xs0);
    ; #move variables
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r10
    mov r10, rsi
    mov rsi, r8
    ; let x0: List = Cons(x1, xs0);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
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
    je lab148
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab149

lab148:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab146
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab139
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab137
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab138

lab137:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab138:

lab139:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab147

lab146:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab147:

lab149:
    ; #load tag
    mov r9, 5
    ; substitute (digits := digits)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; list_eq(...)
    jmp list_eq_

max_prod_between_rec_:
    ; next_prod <- a * b;
    mov rcx, r9
    imul rcx, r11
    mov [rsp + 2024], rcx
    ; if next_prod >= curr_max \{ ... \}
    cmp [rsp + 2024], r13
    jge lab150
    ; else branch
    ; substitute (a := a)(a0 := a0)(b := b)(curr_max := curr_max)(max := max)(min := min)(curr_max1 := curr_max);
    ; #move variables
    mov rcx, r9
    mov r9, r11
    mov r11, r13
    mov [rsp + 2024], r13
    mov r13, rdi
    mov rdi, r15
    mov r15, rdx
    mov rdx, rcx
    mov rsi, r14
    ; share_max_prod_between_rec_2(...)
    jmp share_max_prod_between_rec_2_

lab150:
    ; then branch
    ; substitute (next_prod0 := next_prod)(max := max)(a := a)(b := b)(curr_max := curr_max)(a0 := a0)(next_prod := next_prod)(min := min);
    ; #move variables
    mov [rsp + 2008], rdx
    mov rdx, [rsp + 2024]
    ; create a1: Bool = (max, a, b, curr_max, a0, next_prod, min)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    mov [rbx + 24], r15
    mov [rbx + 16], r14
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab162
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab163

lab162:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab160
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab153
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab151
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab152

lab151:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab152:

lab153:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab156
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab154
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab155

lab154:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab155:

lab156:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab161

lab160:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab161:

lab163:
    ; ##store link to previous block
    mov [rbx + 48], r14
    ; ##store values
    mov [rbx + 40], r13
    mov qword [rbx + 32], 0
    mov [rbx + 24], r11
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab175
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab176

lab175:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab173
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab166
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab164
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab165

lab164:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab165:

lab166:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab169
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab167
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab168

lab167:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab168:

lab169:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab174

lab173:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab174:

lab176:
    ; ##store link to previous block
    mov [rbx + 48], r10
    ; ##store values
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
    je lab188
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab189

lab188:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab186
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab179
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab177
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab178

lab177:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab178:

lab179:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab187

lab186:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab187:

lab189:
    ; #load tag
    lea rdi, [rel Bool_190]
    ; is_palindrome(...)
    jmp is_palindrome_

Bool_190:
    jmp near Bool_190_True
    jmp near Bool_190_False

Bool_190_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab192
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov r15, [r12 + 40]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab191
    ; ####increment refcount
    add qword [r12 + 0], 1

lab191:
    jmp lab193

lab192:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov r15, [r12 + 40]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]

lab193:
    ; substitute (a := a)(a0 := a0)(b := b)(curr_max := curr_max)(max := max)(min := min)(next_prod := next_prod);
    ; #move variables
    mov rcx, rdi
    mov rdi, r13
    mov r13, rdx
    mov rdx, rcx
    mov rsi, r12
    mov rcx, [rsp + 2024]
    mov [rsp + 2024], r15
    mov r15, rcx
    ; share_max_prod_between_rec_3(...)
    jmp share_max_prod_between_rec_3_

Bool_190_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab195
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov r15, [r12 + 40]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]
    cmp r12, 0
    je lab194
    ; ####increment refcount
    add qword [r12 + 0], 1

lab194:
    jmp lab196

lab195:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load link to next block
    mov r12, [r8 + 48]
    ; ###load values
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov rcx, [r12 + 56]
    mov [rsp + 2024], rcx
    mov r15, [r12 + 40]
    mov r13, [r12 + 24]
    mov r12, [r12 + 16]

lab196:
    ; substitute (a := a)(a0 := a0)(b := b)(curr_max := curr_max)(max := max)(min := min)(curr_max0 := curr_max);
    ; #move variables
    mov rcx, rdi
    mov rdi, r13
    mov r13, rdx
    mov rdx, rcx
    mov r15, [rsp + 2024]
    mov [rsp + 2024], r11
    mov rsi, r12
    ; share_max_prod_between_rec_3(...)
    jmp share_max_prod_between_rec_3_

share_max_prod_between_rec_3_:
    ; share_max_prod_between_rec_2(...)
    jmp share_max_prod_between_rec_2_

share_max_prod_between_rec_2_:
    ; if a == max \{ ... \}
    cmp rdx, r13
    je lab197
    ; else branch
    ; lit x0 <- 1;
    mov qword [rsp + 2008], 1
    ; next_a <- a + x0;
    mov rcx, rdx
    add rcx, [rsp + 2008]
    mov [rsp + 1992], rcx
    ; substitute (a0 := a0)(b := b)(curr_max := curr_max)(max := max)(min := min)(next_a := next_a)(next_max := next_max);
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    mov rdi, r9
    mov r9, r11
    mov r11, r13
    mov r13, r15
    mov r15, [rsp + 1992]
    ; share_max_prod_between_rec_1(...)
    jmp share_max_prod_between_rec_1_

lab197:
    ; then branch
    ; substitute (a0 := a0)(b := b)(curr_max := curr_max)(max := max)(min := min)(min0 := min)(next_max := next_max);
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    mov rdi, r9
    mov r9, r11
    mov r11, r13
    mov r13, r15
    ; share_max_prod_between_rec_1(...)
    jmp share_max_prod_between_rec_1_

share_max_prod_between_rec_1_:
    ; if next_a == min \{ ... \}
    cmp r15, r13
    je lab198
    ; else branch
    ; substitute (a0 := a0)(curr_max := curr_max)(max := max)(min := min)(next_a := next_a)(b := b)(next_max := next_max);
    ; #move variables
    mov rcx, r9
    mov r9, r11
    mov r11, r13
    mov r13, r15
    mov r15, rdi
    mov rdi, rcx
    ; share_max_prod_between_rec_0(...)
    jmp share_max_prod_between_rec_0_

lab198:
    ; then branch
    ; lit x0 <- 1;
    mov qword [rsp + 2008], 1
    ; next_b <- b + x0;
    mov rcx, rdi
    add rcx, [rsp + 2008]
    mov [rsp + 1992], rcx
    ; substitute (a0 := a0)(curr_max := curr_max)(max := max)(min := min)(next_a := next_a)(next_b := next_b)(next_max := next_max);
    ; #move variables
    mov rdi, r9
    mov r9, r11
    mov r11, r13
    mov r13, r15
    mov r15, [rsp + 1992]
    ; share_max_prod_between_rec_0(...)
    jmp share_max_prod_between_rec_0_

share_max_prod_between_rec_0_:
    ; if next_b == max \{ ... \}
    cmp r15, r9
    je lab199
    ; else branch
    ; substitute (min := min)(max := max)(next_a := next_a)(next_b := next_b)(next_max := next_max)(a0 := a0);
    ; #move variables
    mov r14, rax
    mov rcx, r11
    mov r11, r15
    mov r15, rdx
    mov rdx, rcx
    mov rdi, r9
    mov r9, r13
    mov r13, [rsp + 2024]
    ; max_prod_between_rec(...)
    jmp max_prod_between_rec_

lab199:
    ; then branch
    ; substitute (curr_max := curr_max)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

max_prod_between_:
    ; lit x0 <- 0;
    mov r11, 0
    ; substitute (min := min)(max := max)(min0 := min)(min1 := min)(x0 := x0)(a0 := a0);
    ; #move variables
    mov r15, r9
    mov r9, rdx
    mov r13, r11
    mov r11, rdx
    mov r14, r8
    ; max_prod_between_rec(...)
    jmp max_prod_between_rec_

max_prod_:
    ; lit x0 <- 10;
    mov r9, 10
    ; lit x1 <- 1;
    mov r11, 1
    ; x2 <- num_digits - x1;
    mov r13, rdx
    sub r13, r11
    ; substitute (x2 := x2)(x0 := x0)(a0 := a0)(num_digits := num_digits);
    ; #move variables
    mov r11, rdx
    mov r8, rsi
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    mov rdx, r13
    ; create a2: _Cont = (a0, num_digits)\{ ... \};
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
    je lab211
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab212

lab211:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab209
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab202
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab200
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab201

lab200:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab201:

lab202:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab205
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab203
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab204

lab203:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab204:

lab205:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab208
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab206
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab207

lab206:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab207:

lab208:
    jmp lab210

lab209:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab210:

lab212:
    ; #load tag
    lea r9, [rel _Cont_213]
    ; substitute (x0 := x0)(x2 := x2)(a2 := a2);
    ; #move variables
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; powi(...)
    jmp powi_

_Cont_213:

_Cont_213_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab215
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab214
    ; ####increment refcount
    add qword [rsi + 0], 1

lab214:
    jmp lab216

lab215:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab216:
    ; substitute (num_digits := num_digits)(a0 := a0)(min := min);
    ; #move variables
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a1: _Cont = (a0, min)\{ ... \};
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
    je lab228
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab229

lab228:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab226
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab219
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab217
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab218

lab217:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab218:

lab219:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab222
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab220
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab221

lab220:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab221:

lab222:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab225
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab223
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab224

lab223:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab224:

lab225:
    jmp lab227

lab226:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab227:

lab229:
    ; #load tag
    lea rdi, [rel _Cont_230]
    ; lit x4 <- 10;
    mov r9, 10
    ; substitute (x4 := x4)(num_digits := num_digits)(a1 := a1);
    ; #move variables
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov r8, rsi
    ; powi(...)
    jmp powi_

_Cont_230:

_Cont_230_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab232
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab231
    ; ####increment refcount
    add qword [rsi + 0], 1

lab231:
    jmp lab233

lab232:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab233:
    ; lit x5 <- 1;
    mov r11, 1
    ; max <- x3 - x5;
    mov r13, rdx
    sub r13, r11
    ; substitute (min := min)(max := max)(a0 := a0);
    ; #move variables
    mov r8, rsi
    mov rdx, r9
    mov r9, rdi
    mov rdi, r13
    ; max_prod_between(...)
    jmp max_prod_between_

main_loop_:
    ; substitute (num_digits0 := num_digits)(num_digits := num_digits)(a0 := a0)(iters := iters);
    ; #move variables
    mov r11, rdx
    mov rdx, rdi
    ; create a1: _Cont = (num_digits, a0, iters)\{ ... \};
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
    je lab245
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab246

lab245:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab243
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab242
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab240
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab241

lab240:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab241:

lab242:
    jmp lab244

lab243:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab244:

lab246:
    ; #load tag
    lea rdi, [rel _Cont_247]
    ; max_prod(...)
    jmp max_prod_

_Cont_247:

_Cont_247_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab249
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab248
    ; ####increment refcount
    add qword [r8 + 0], 1

lab248:
    mov rdi, [rsi + 24]
    jmp lab250

lab249:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]

lab250:
    ; if iters == 0 \{ ... \}
    cmp r11, 0
    je lab251
    ; else branch
    ; substitute (iters := iters)(num_digits := num_digits)(a0 := a0);
    ; #move variables
    mov rdx, r11
    ; lit x0 <- 1;
    mov r11, 1
    ; x1 <- iters - x0;
    mov r13, rdx
    sub r13, r11
    ; substitute (x1 := x1)(num_digits := num_digits)(a0 := a0);
    ; #move variables
    mov rdx, r13
    ; main_loop(...)
    jmp main_loop_

lab251:
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