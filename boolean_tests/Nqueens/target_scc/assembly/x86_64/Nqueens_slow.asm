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

neq_i_:
    ; if i1 == i2 \{ ... \}
    cmp rdx, rdi
    je lab7
    ; else branch
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 True
    add rdx, 0
    jmp rdx

lab7:
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
    lea rcx, [rel List_List_i64_8]
    add rcx, rdi
    jmp rcx

List_List_i64_8:
    jmp near List_List_i64_8_Nil
    jmp near List_List_i64_8_Cons

List_List_i64_8_Nil:
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

List_List_i64_8_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab11
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab9
    ; ####increment refcount
    add qword [r8 + 0], 1

lab9:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab10
    ; ####increment refcount
    add qword [rsi + 0], 1

lab10:
    jmp lab12

lab11:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab12:
    ; substitute (a0 := a0)(ls := ls);
    ; #erase i
    cmp rsi, 0
    je lab15
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab13
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab14

lab13:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab14:

lab15:
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
    je lab27
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab28

lab27:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab25
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab24
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab22
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab23

lab22:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab23:

lab24:
    jmp lab26

lab25:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab26:

lab28:
    ; #load tag
    lea rdi, [rel _Cont_29]
    ; jump length_
    jmp length_

_Cont_29:

_Cont_29_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab31
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab30
    ; ####increment refcount
    add qword [rsi + 0], 1

lab30:
    jmp lab32

lab31:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab32:
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
    lea rcx, [rel List_List_i64_33]
    add rcx, r9
    jmp rcx

List_List_i64_33:
    jmp near List_List_i64_33_Nil
    jmp near List_List_i64_33_Cons

List_List_i64_33_Nil:
    ; switch l2 \{ ... \};
    lea rcx, [rel List_List_i64_34]
    add rcx, rdi
    jmp rcx

List_List_i64_34:
    jmp near List_List_i64_34_Nil
    jmp near List_List_i64_34_Cons

List_List_i64_34_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_List_i64_34_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab37
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab35
    ; ####increment refcount
    add qword [r8 + 0], 1

lab35:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab36
    ; ####increment refcount
    add qword [rsi + 0], 1

lab36:
    jmp lab38

lab37:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab38:
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

List_List_i64_33_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab41
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab39
    ; ####increment refcount
    add qword [r10 + 0], 1

lab39:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab40
    ; ####increment refcount
    add qword [r8 + 0], 1

lab40:
    jmp lab42

lab41:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab42:
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
    lea r9, [rel List_List_i64_56]
    ; jump append_
    jmp append_

List_List_i64_56:
    jmp near List_List_i64_56_Nil
    jmp near List_List_i64_56_Cons

List_List_i64_56_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab59
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab57
    ; ####increment refcount
    add qword [rsi + 0], 1

lab57:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab58
    ; ####increment refcount
    add qword [rax + 0], 1

lab58:
    jmp lab60

lab59:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab60:
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

List_List_i64_56_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab63
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab61
    ; ####increment refcount
    add qword [r10 + 0], 1

lab61:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab62
    ; ####increment refcount
    add qword [r8 + 0], 1

lab62:
    jmp lab64

lab63:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab64:
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
    lea rcx, [rel List_i64_78]
    add rcx, r11
    jmp rcx

List_i64_78:
    jmp near List_i64_78_Nil
    jmp near List_i64_78_Cons

List_i64_78_Nil:
    ; substitute (a0 := a0);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 True
    add rdx, 0
    jmp rdx

List_i64_78_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab80
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab79
    ; ####increment refcount
    add qword [r12 + 0], 1

lab79:
    mov r11, [r10 + 40]
    jmp lab81

lab80:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]

lab81:
    ; substitute (x10 := x)(q0 := q)(a0 := a0)(q := q)(l0 := l0)(x := x)(d := d);
    ; #move variables
    mov r15, rdx
    mov [rsp + 2024], rdi
    mov rdi, r11
    ; create a1: Bool = (a0, q, l0, x, d)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
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
    je lab93
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab94

lab93:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab91
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab84
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab82
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab83

lab82:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab83:

lab84:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab87
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab85
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab86

lab85:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab86:

lab87:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab92

lab91:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab92:

lab94:
    ; ##store link to previous block
    mov [rbx + 48], r12
    ; ##store values
    mov [rbx + 40], r11
    mov qword [rbx + 32], 0
    mov [rbx + 24], r9
    mov [rbx + 16], r8
    ; ##acquire free block from heap register
    mov r8, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab106
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab107

lab106:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab104
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab105

lab104:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab105:

lab107:
    ; #load tag
    lea r9, [rel Bool_108]
    ; jump neq_i_
    jmp neq_i_

Bool_108:
    jmp near Bool_108_True
    jmp near Bool_108_False

Bool_108_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab111
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab109
    ; ####increment refcount
    add qword [rax + 0], 1

lab109:
    ; ###load values
    mov r13, [r8 + 56]
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab110
    ; ####increment refcount
    add qword [r8 + 0], 1

lab110:
    jmp lab112

lab111:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r13, [r8 + 56]
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]

lab112:
    ; let x0: Bool = True();
    ; #mark no allocation
    mov r14, 0
    ; #load tag
    mov r15, 0
    ; substitute (a0 := a0)(d := d)(l0 := l0)(q := q)(x := x)(x0 := x0);
    ; #move variables
    mov rcx, r13
    mov r13, r11
    mov r11, rdi
    mov rdi, rcx
    ; jump lift_safe_0_
    jmp lift_safe_0_

Bool_108_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab115
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab113
    ; ####increment refcount
    add qword [rax + 0], 1

lab113:
    ; ###load values
    mov r13, [r8 + 56]
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab114
    ; ####increment refcount
    add qword [r8 + 0], 1

lab114:
    jmp lab116

lab115:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r13, [r8 + 56]
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]

lab116:
    ; let x0: Bool = False();
    ; #mark no allocation
    mov r14, 0
    ; #load tag
    mov r15, 5
    ; substitute (a0 := a0)(d := d)(l0 := l0)(q := q)(x := x)(x0 := x0);
    ; #move variables
    mov rcx, r13
    mov r13, r11
    mov r11, rdi
    mov rdi, rcx
    ; jump lift_safe_0_
    jmp lift_safe_0_

lift_safe_0_:
    ; substitute (x := x)(d := d)(l0 := l0)(q := q)(a0 := a0)(x0 := x0);
    ; #move variables
    mov r12, rax
    mov rcx, r13
    mov r13, rdx
    mov rdx, rcx
    ; create a2: Bool = (a0, x0)\{ ... \};
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
    je lab128
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab129

lab128:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab126
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab119
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab117
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab118

lab117:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab118:

lab119:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab127

lab126:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab127:

lab129:
    ; #load tag
    lea r13, [rel Bool_130]
    ; substitute (x10 := x)(d0 := d)(q0 := q)(q := q)(a2 := a2)(x := x)(d := d)(l0 := l0);
    ; #move variables
    mov r15, rdx
    mov [rsp + 2024], rdi
    mov [rsp + 2016], r8
    mov [rsp + 2008], r9
    mov r9, r11
    ; create a3: Bool = (q, a2, x, d, l0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2008]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2016]
    mov [rbx + 48], rcx
    mov rcx, [rsp + 2024]
    mov [rbx + 40], rcx
    mov qword [rbx + 32], 0
    mov [rbx + 24], r15
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r14, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab142
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab143

lab142:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab140
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab141

lab140:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab141:

lab143:
    ; ##store link to previous block
    mov [rbx + 48], r14
    ; ##store values
    mov [rbx + 40], r13
    mov [rbx + 32], r12
    mov [rbx + 24], r11
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov r10, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab155
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab156

lab155:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab153
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab146
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab144
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab145

lab144:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab145:

lab146:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab149
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab147
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab148

lab147:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab148:

lab149:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab152
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab150
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab151

lab150:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab151:

lab152:
    jmp lab154

lab153:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab154:

lab156:
    ; #load tag
    lea r11, [rel Bool_157]
    ; x3 <- q0 + d0;
    mov r13, r9
    add r13, rdi
    ; substitute (x10 := x10)(x3 := x3)(a3 := a3);
    ; #move variables
    mov r8, r10
    mov r9, r11
    mov rdi, r13
    ; jump neq_i_
    jmp neq_i_

Bool_157:
    jmp near Bool_157_True
    jmp near Bool_157_False

Bool_157_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab160
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab158
    ; ####increment refcount
    add qword [rsi + 0], 1

lab158:
    mov rdx, [rax + 24]
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab159
    ; ####increment refcount
    add qword [r12 + 0], 1

lab159:
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]
    jmp lab161

lab160:
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
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]

lab161:
    ; let x2: Bool = True();
    ; #mark no allocation
    mov r14, 0
    ; #load tag
    mov r15, 0
    ; substitute (a2 := a2)(d := d)(l0 := l0)(q := q)(x := x)(x2 := x2);
    ; #move variables
    mov rcx, rdi
    mov rdi, r11
    mov r11, rdx
    mov rdx, rcx
    mov rax, rsi
    mov rcx, r13
    mov r13, r9
    mov r9, rcx
    mov r8, r12
    ; jump lift_safe_1_
    jmp lift_safe_1_

Bool_157_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab164
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab162
    ; ####increment refcount
    add qword [rsi + 0], 1

lab162:
    mov rdx, [rax + 24]
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab163
    ; ####increment refcount
    add qword [r12 + 0], 1

lab163:
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]
    jmp lab165

lab164:
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
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    mov r11, [r8 + 40]
    mov r9, [r8 + 24]

lab165:
    ; let x2: Bool = False();
    ; #mark no allocation
    mov r14, 0
    ; #load tag
    mov r15, 5
    ; substitute (a2 := a2)(d := d)(l0 := l0)(q := q)(x := x)(x2 := x2);
    ; #move variables
    mov rcx, rdi
    mov rdi, r11
    mov r11, rdx
    mov rdx, rcx
    mov rax, rsi
    mov rcx, r13
    mov r13, r9
    mov r9, rcx
    mov r8, r12
    ; jump lift_safe_1_
    jmp lift_safe_1_

Bool_130:
    jmp near Bool_130_True
    jmp near Bool_130_False

Bool_130_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab168
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab166
    ; ####increment refcount
    add qword [rsi + 0], 1

lab166:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab167
    ; ####increment refcount
    add qword [rax + 0], 1

lab167:
    jmp lab169

lab168:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab169:
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
    ; jump and_
    jmp and_

Bool_130_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab172
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab170
    ; ####increment refcount
    add qword [rsi + 0], 1

lab170:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab171
    ; ####increment refcount
    add qword [rax + 0], 1

lab171:
    jmp lab173

lab172:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab173:
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
    ; jump and_
    jmp and_

lift_safe_1_:
    ; substitute (x := x)(d := d)(l0 := l0)(q := q)(a2 := a2)(x2 := x2);
    ; #move variables
    mov r12, rax
    mov rcx, r13
    mov r13, rdx
    mov rdx, rcx
    ; create a4: Bool = (a2, x2)\{ ... \};
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
    je lab185
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab186

lab185:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab183
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab176
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab174
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab175

lab174:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab175:

lab176:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab184

lab183:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab184:

lab186:
    ; #load tag
    lea r13, [rel Bool_187]
    ; substitute (x10 := x)(d0 := d)(q := q)(l0 := l0)(a4 := a4)(x := x)(d := d);
    ; #move variables
    mov r15, rdx
    mov [rsp + 2024], rdi
    mov r10, r8
    mov rcx, r11
    mov r11, r9
    mov r9, rcx
    ; create a5: Bool = (l0, a4, x, d)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov qword [rbx + 48], 0
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
    je lab199
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab200

lab199:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab197
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab196
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab194
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab195

lab194:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab195:

lab196:
    jmp lab198

lab197:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab198:

lab200:
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
    je lab212
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab213

lab212:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab210
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab203
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab201
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab202

lab201:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab202:

lab203:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab206
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab204
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab205

lab204:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab205:

lab206:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab211

lab210:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab211:

lab213:
    ; #load tag
    lea r11, [rel Bool_214]
    ; x6 <- q - d0;
    mov r13, r9
    sub r13, rdi
    ; substitute (x10 := x10)(x6 := x6)(a5 := a5);
    ; #move variables
    mov r8, r10
    mov r9, r11
    mov rdi, r13
    ; jump neq_i_
    jmp neq_i_

Bool_214:
    jmp near Bool_214_True
    jmp near Bool_214_False

Bool_214_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab217
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab215
    ; ####increment refcount
    add qword [rax + 0], 1

lab215:
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab216
    ; ####increment refcount
    add qword [rsi + 0], 1

lab216:
    jmp lab218

lab217:
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

lab218:
    ; let x5: Bool = True();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; substitute (a4 := a4)(d := d)(l0 := l0)(x := x)(x5 := x5);
    ; #move variables
    mov r8, rax
    mov rcx, rdi
    mov rdi, r11
    mov r11, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, rsi
    ; jump lift_safe_2_
    jmp lift_safe_2_

Bool_214_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab221
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab219
    ; ####increment refcount
    add qword [rax + 0], 1

lab219:
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab220
    ; ####increment refcount
    add qword [rsi + 0], 1

lab220:
    jmp lab222

lab221:
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

lab222:
    ; let x5: Bool = False();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 5
    ; substitute (a4 := a4)(d := d)(l0 := l0)(x := x)(x5 := x5);
    ; #move variables
    mov r8, rax
    mov rcx, rdi
    mov rdi, r11
    mov r11, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, rsi
    ; jump lift_safe_2_
    jmp lift_safe_2_

Bool_187:
    jmp near Bool_187_True
    jmp near Bool_187_False

Bool_187_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab225
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab223
    ; ####increment refcount
    add qword [rsi + 0], 1

lab223:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab224
    ; ####increment refcount
    add qword [rax + 0], 1

lab224:
    jmp lab226

lab225:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab226:
    ; let x4: Bool = True();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x2 := x2)(x4 := x4)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump and_
    jmp and_

Bool_187_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab229
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab227
    ; ####increment refcount
    add qword [rsi + 0], 1

lab227:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
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
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab230:
    ; let x4: Bool = False();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (x2 := x2)(x4 := x4)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump and_
    jmp and_

lift_safe_2_:
    ; substitute (x := x)(d := d)(l0 := l0)(a4 := a4)(x5 := x5);
    ; #move variables
    mov r10, rax
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; create a6: Bool = (a4, x5)\{ ... \};
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
    je lab242
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
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
    lea r11, [rel Bool_244]
    ; lit x8 <- 1;
    mov r13, 1
    ; x9 <- d + x8;
    mov r15, rdi
    add r15, r13
    ; substitute (x := x)(x9 := x9)(l0 := l0)(a6 := a6);
    ; #move variables
    mov rdi, r15
    ; jump safe_
    jmp safe_

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
    ; let x7: Bool = True();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x5 := x5)(x7 := x7)(a4 := a4);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump and_
    jmp and_

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
    ; let x7: Bool = False();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (x5 := x5)(x7 := x7)(a4 := a4);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump and_
    jmp and_

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
    lea rcx, [rel List_List_i64_253]
    add rcx, r11
    jmp rcx

List_List_i64_253:
    jmp near List_List_i64_253_Nil
    jmp near List_List_i64_253_Cons

List_List_i64_253_Nil:
    ; substitute (a0 := a0)(acc := acc);
    ; switch acc \{ ... \};
    lea rcx, [rel List_List_i64_254]
    add rcx, rdi
    jmp rcx

List_List_i64_254:
    jmp near List_List_i64_254_Nil
    jmp near List_List_i64_254_Cons

List_List_i64_254_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_List_i64_254_Cons:
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

List_List_i64_253_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab261
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab259
    ; ####increment refcount
    add qword [r12 + 0], 1

lab259:
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]
    cmp r10, 0
    je lab260
    ; ####increment refcount
    add qword [r10 + 0], 1

lab260:
    jmp lab262

lab261:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]

lab262:
    ; lit x0 <- 1;
    mov r15, 1
    ; substitute (x0 := x0)(b0 := b)(q1 := q)(b := b)(bs := bs)(q := q)(a0 := a0)(acc := acc);
    ; #share b
    cmp r10, 0
    je lab263
    ; ####increment refcount
    add qword [r10 + 0], 1

lab263:
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
    je lab275
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
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
    je lab288
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab289

lab288:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab286
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab279
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab277
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab278

lab277:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab278:

lab279:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab282
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab280
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab281

lab280:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab281:

lab282:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab285
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab283
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab284

lab283:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab284:

lab285:
    jmp lab287

lab286:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab287:

lab289:
    ; #load tag
    lea r11, [rel Bool_290]
    ; substitute (q1 := q1)(x0 := x0)(b0 := b0)(a1 := a1);
    ; #move variables
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov r8, rsi
    ; jump safe_
    jmp safe_

Bool_290:
    jmp near Bool_290_True
    jmp near Bool_290_False

Bool_290_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab295
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab291
    ; ####increment refcount
    add qword [rsi + 0], 1

lab291:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab292
    ; ####increment refcount
    add qword [rax + 0], 1

lab292:
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab293
    ; ####increment refcount
    add qword [r12 + 0], 1

lab293:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab294
    ; ####increment refcount
    add qword [r10 + 0], 1

lab294:
    mov r9, [r8 + 24]
    jmp lab296

lab295:
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

lab296:
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
    je lab308
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
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
    je lab321
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab322

lab321:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab319
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab318
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab316
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab317

lab316:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab317:

lab318:
    jmp lab320

lab319:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab320:

lab322:
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

Bool_290_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab327
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov r8, [rax + 48]
    ; ###load values
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab323
    ; ####increment refcount
    add qword [rsi + 0], 1

lab323:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab324
    ; ####increment refcount
    add qword [rax + 0], 1

lab324:
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab325
    ; ####increment refcount
    add qword [r12 + 0], 1

lab325:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab326
    ; ####increment refcount
    add qword [r10 + 0], 1

lab326:
    mov r9, [r8 + 24]
    jmp lab328

lab327:
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

lab328:
    ; substitute (bs := bs)(acc := acc)(q := q)(a0 := a0);
    ; #erase b
    cmp rax, 0
    je lab331
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab329
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab330

lab329:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab330:

lab331:
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
    je lab332
    ; else branch
    ; let x0: List[List[i64]] = Nil();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; substitute (q0 := q)(x0 := x0)(bs0 := bs)(a0 := a0)(bs := bs)(q := q)(acc := acc);
    ; #share bs
    cmp r8, 0
    je lab333
    ; ####increment refcount
    add qword [r8 + 0], 1

lab333:
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
    je lab345
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab346

lab345:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab343
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab336
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab334
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab335

lab334:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab335:

lab336:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab339
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab337
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab338

lab337:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab338:

lab339:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab344

lab343:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab344:

lab346:
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
    je lab358
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab359

lab358:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab356
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab349
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab347
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab348

lab347:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab348:

lab349:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab352
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab350
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab351

lab350:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab351:

lab352:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab357

lab356:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab357:

lab359:
    ; #load tag
    lea r11, [rel List_List_i64_360]
    ; substitute (bs0 := bs0)(x0 := x0)(q0 := q0)(a2 := a2);
    ; #move variables
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r8
    ; jump check_
    jmp check_

List_List_i64_360:
    jmp near List_List_i64_360_Nil
    jmp near List_List_i64_360_Cons

List_List_i64_360_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab364
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab361
    ; ####increment refcount
    add qword [rax + 0], 1

lab361:
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab362
    ; ####increment refcount
    add qword [r10 + 0], 1

lab362:
    mov r9, [rsi + 40]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab363
    ; ####increment refcount
    add qword [rsi + 0], 1

lab363:
    jmp lab365

lab364:
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

lab365:
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

List_List_i64_360_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab369
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load link to next block
    mov r10, [r8 + 48]
    ; ###load values
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab366
    ; ####increment refcount
    add qword [r8 + 0], 1

lab366:
    ; ###load values
    mov r15, [r10 + 56]
    mov r14, [r10 + 48]
    cmp r14, 0
    je lab367
    ; ####increment refcount
    add qword [r14 + 0], 1

lab367:
    mov r13, [r10 + 40]
    mov r11, [r10 + 24]
    mov r10, [r10 + 16]
    cmp r10, 0
    je lab368
    ; ####increment refcount
    add qword [r10 + 0], 1

lab368:
    jmp lab370

lab369:
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

lab370:
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
    je lab382
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab383

lab382:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab380
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab373
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab371
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab372

lab371:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab372:

lab373:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab381

lab380:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab381:

lab383:
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

lab332:
    ; then branch
    ; substitute (a0 := a0)(acc := acc);
    ; #erase bs
    cmp r8, 0
    je lab386
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab384
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab385

lab384:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab385:

lab386:
    ; #move variables
    mov rax, r10
    mov rdx, r11
    ; switch acc \{ ... \};
    lea rcx, [rel List_List_i64_387]
    add rcx, rdi
    jmp rcx

List_List_i64_387:
    jmp near List_List_i64_387_Nil
    jmp near List_List_i64_387_Cons

List_List_i64_387_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_List_i64_387_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab390
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab388
    ; ####increment refcount
    add qword [r8 + 0], 1

lab388:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab389
    ; ####increment refcount
    add qword [rsi + 0], 1

lab389:
    jmp lab391

lab390:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab391:
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
    je lab403
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab404

lab403:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab401
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab394
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab392
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab393

lab392:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab393:

lab394:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab397
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab395
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab396

lab395:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab396:

lab397:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab400
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab398
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab399

lab398:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab399:

lab400:
    jmp lab402

lab401:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab402:

lab404:
    ; #load tag
    lea r9, [rel List_List_i64_405]
    ; jump append_
    jmp append_

List_List_i64_405:
    jmp near List_List_i64_405_Nil
    jmp near List_List_i64_405_Cons

List_List_i64_405_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab408
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab406
    ; ####increment refcount
    add qword [rsi + 0], 1

lab406:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab407
    ; ####increment refcount
    add qword [rax + 0], 1

lab407:
    jmp lab409

lab408:
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

lab409:
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

List_List_i64_405_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab412
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab410
    ; ####increment refcount
    add qword [r10 + 0], 1

lab410:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab411
    ; ####increment refcount
    add qword [r8 + 0], 1

lab411:
    jmp lab413

lab412:
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

lab413:
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
    je lab425
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab426

lab425:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab423
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab416
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab414
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab415

lab414:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab415:

lab416:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab419
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab417
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab418

lab417:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab418:

lab419:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab422
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab420
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab421

lab420:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab421:

lab422:
    jmp lab424

lab423:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab424:

lab426:
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
    je lab427
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
    je lab439
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab440

lab439:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab437
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab430
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab428
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab429

lab428:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab429:

lab430:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab433
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab431
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab432

lab431:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab432:

lab433:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab436
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab434
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab435

lab434:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab435:

lab436:
    jmp lab438

lab437:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab438:

lab440:
    ; #load tag
    lea r9, [rel List_List_i64_441]
    ; jump gen_
    jmp gen_

List_List_i64_441:
    jmp near List_List_i64_441_Nil
    jmp near List_List_i64_441_Cons

List_List_i64_441_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab443
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab442
    ; ####increment refcount
    add qword [rax + 0], 1

lab442:
    jmp lab444

lab443:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab444:
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

List_List_i64_441_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab446
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab445
    ; ####increment refcount
    add qword [r8 + 0], 1

lab445:
    jmp lab447

lab446:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab447:
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
    je lab459
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab460

lab459:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab457
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab450
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab448
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab449

lab448:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab449:

lab450:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab453
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab451
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab452

lab451:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab452:

lab453:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab456
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab454
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab455

lab454:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab455:

lab456:
    jmp lab458

lab457:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab458:

lab460:
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

lab427:
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
    je lab472
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab473

lab472:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab470
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab463
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab461
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab462

lab461:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab462:

lab463:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab466
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab464
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab465

lab464:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab465:

lab466:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab469
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab467
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab468

lab467:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab468:

lab469:
    jmp lab471

lab470:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab471:

lab473:
    ; #load tag
    lea rdi, [rel List_List_i64_474]
    ; substitute (n := n)(n0 := n)(a1 := a1);
    ; #move variables
    mov r9, rdi
    mov rdi, rdx
    mov r8, rsi
    ; jump gen_
    jmp gen_

List_List_i64_474:
    jmp near List_List_i64_474_Nil
    jmp near List_List_i64_474_Cons

List_List_i64_474_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab476
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab475
    ; ####increment refcount
    add qword [rax + 0], 1

lab475:
    jmp lab477

lab476:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab477:
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

List_List_i64_474_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab479
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
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
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab480:
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
    je lab492
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
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
    je lab505
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab506

lab505:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab503
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab496
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab494
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab495

lab494:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab495:

lab496:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab499
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab497
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab498

lab497:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab498:

lab499:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab502
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab500
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab501

lab500:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab501:

lab502:
    jmp lab504

lab503:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab504:

lab506:
    ; #load tag
    lea rdi, [rel _Cont_507]
    ; jump nsoln_
    jmp nsoln_

_Cont_507:

_Cont_507_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab509
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab508
    ; ####increment refcount
    add qword [r8 + 0], 1

lab508:
    mov rdi, [rsi + 24]
    jmp lab510

lab509:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]

lab510:
    ; lit x0 <- 1;
    mov r13, 1
    ; if iters == x0 \{ ... \}
    cmp r11, r13
    je lab511
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

lab511:
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