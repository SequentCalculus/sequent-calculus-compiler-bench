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
    mov rdx, rsi
    ; actual code

main_:
    ; create a0: _Cont = ()\{ ... \};
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    lea rdi, [rel _Cont_1]
    ; jump main_loop_
    jmp main_loop_

_Cont_1:

_Cont_1_Ret:
    ; exit x0
    mov rax, rdx
    jmp cleanup

mk_leaf_:
    ; let x0: List[RoseTree[Pair[List[Option[Player]], i64]]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (p := p)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; invoke a0 Rose
    ; #there is only one clause, so we can jump there directly
    jmp r9

top_:
    ; substitute (a0 := a0)(t := t);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch t \{ ... \};
    ; #there is only one clause, so we can just fall through

RoseTree_Pair_List_Option_Player_i64_2:

RoseTree_Pair_List_Option_Player_i64_2_Rose:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab5
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab3
    ; ####increment refcount
    add qword [r8 + 0], 1

lab3:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab4
    ; ####increment refcount
    add qword [rsi + 0], 1

lab4:
    jmp lab6

lab5:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab6:
    ; substitute (a0 := a0)(p := p);
    ; #erase ps
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
    ; switch p \{ ... \};
    ; #there is only one clause, so we can just fall through

Pair_List_Option_Player_i64_10:

Pair_List_Option_Player_i64_10_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab12
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab11
    ; ####increment refcount
    add qword [rsi + 0], 1

lab11:
    jmp lab13

lab12:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab13:
    ; substitute (a1 := a1)(b0 := b0)(a0 := a0);
    ; #move variables
    mov r8, rax
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, rsi
    ; invoke a0 Tup
    ; #there is only one clause, so we can jump there directly
    jmp r9

snd_:
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

Pair_List_Option_Player_i64_14:

Pair_List_Option_Player_i64_14_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab16
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab15
    ; ####increment refcount
    add qword [rsi + 0], 1

lab15:
    jmp lab17

lab16:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab17:
    ; substitute (b := b)(a0 := a0);
    ; #erase a
    cmp rsi, 0
    je lab20
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab18
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab19

lab18:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab19:

lab20:
    ; #move variables
    mov rsi, rax
    mov rdi, rdx
    mov rdx, r9
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

player_eq_:
    ; substitute (a0 := a0)(p2 := p2)(p1 := p1);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch p1 \{ ... \};
    lea rcx, [rel Player_21]
    add rcx, r9
    jmp rcx

Player_21:
    jmp near Player_21_X
    jmp near Player_21_O

Player_21_X:
    ; switch p2 \{ ... \};
    lea rcx, [rel Player_22]
    add rcx, rdi
    jmp rcx

Player_22:
    jmp near Player_22_X
    jmp near Player_22_O

Player_22_X:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Player_22_O:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Player_21_O:
    ; switch p2 \{ ... \};
    lea rcx, [rel Player_23]
    add rcx, rdi
    jmp rcx

Player_23:
    jmp near Player_23_X
    jmp near Player_23_O

Player_23_X:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Player_23_O:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

other_:
    ; substitute (a0 := a0)(p := p);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch p \{ ... \};
    lea rcx, [rel Player_24]
    add rcx, rdi
    jmp rcx

Player_24:
    jmp near Player_24_X
    jmp near Player_24_O

Player_24_X:
    ; invoke a0 O
    add rdx, 5
    jmp rdx

Player_24_O:
    ; invoke a0 X
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
    lea rcx, [rel Bool_25]
    add rcx, rdi
    jmp rcx

Bool_25:
    jmp near Bool_25_True
    jmp near Bool_25_False

Bool_25_True:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Bool_25_False:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

is_some_:
    ; substitute (a0 := a0)(p := p);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch p \{ ... \};
    lea rcx, [rel Option_Player_26]
    add rcx, rdi
    jmp rcx

Option_Player_26:
    jmp near Option_Player_26_None
    jmp near Option_Player_26_Some

Option_Player_26_None:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Option_Player_26_Some:
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
    ; substitute (a0 := a0);
    ; #erase p0
    cmp rsi, 0
    je lab32
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab30
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab31

lab30:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab31:

lab32:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

head_:
    ; substitute (a0 := a0)(l := l);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_Option_Player_33]
    add rcx, rdi
    jmp rcx

List_Option_Player_33:
    jmp near List_Option_Player_33_Nil
    jmp near List_Option_Player_33_Cons

List_Option_Player_33_Nil:
    ; invoke a0 None
    add rdx, 0
    jmp rdx

List_Option_Player_33_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab36
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab34
    ; ####increment refcount
    add qword [r8 + 0], 1

lab34:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab35
    ; ####increment refcount
    add qword [rsi + 0], 1

lab35:
    jmp lab37

lab36:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab37:
    ; substitute (a0 := a0)(p := p);
    ; #erase ps
    cmp r8, 0
    je lab40
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab38
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab39

lab38:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab39:

lab40:
    ; switch p \{ ... \};
    lea rcx, [rel Option_Player_41]
    add rcx, rdi
    jmp rcx

Option_Player_41:
    jmp near Option_Player_41_None
    jmp near Option_Player_41_Some

Option_Player_41_None:
    ; invoke a0 None
    add rdx, 0
    jmp rdx

Option_Player_41_Some:
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
    ; substitute (a1 := a1)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Some
    add rdi, 5
    jmp rdi

tail_:
    ; substitute (a0 := a0)(l := l);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_Option_Player_45]
    add rcx, rdi
    jmp rcx

List_Option_Player_45:
    jmp near List_Option_Player_45_Nil
    jmp near List_Option_Player_45_Cons

List_Option_Player_45_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Option_Player_45_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab48
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab46
    ; ####increment refcount
    add qword [r8 + 0], 1

lab46:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab47
    ; ####increment refcount
    add qword [rsi + 0], 1

lab47:
    jmp lab49

lab48:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab49:
    ; substitute (a0 := a0)(ps := ps);
    ; #erase p
    cmp rsi, 0
    je lab52
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab50
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab51

lab50:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab51:

lab52:
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; switch ps \{ ... \};
    lea rcx, [rel List_Option_Player_53]
    add rcx, rdi
    jmp rcx

List_Option_Player_53:
    jmp near List_Option_Player_53_Nil
    jmp near List_Option_Player_53_Cons

List_Option_Player_53_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Option_Player_53_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab56
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab54
    ; ####increment refcount
    add qword [r8 + 0], 1

lab54:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab55
    ; ####increment refcount
    add qword [rsi + 0], 1

lab55:
    jmp lab57

lab56:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab57:
    ; substitute (a1 := a1)(as0 := as0)(a0 := a0);
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
    lea rcx, [rel List_i64_58]
    add rcx, r9
    jmp rcx

List_i64_58:
    jmp near List_i64_58_Nil
    jmp near List_i64_58_Cons

List_i64_58_Nil:
    ; switch acc \{ ... \};
    lea rcx, [rel List_i64_59]
    add rcx, rdi
    jmp rcx

List_i64_59:
    jmp near List_i64_59_Nil
    jmp near List_i64_59_Cons

List_i64_59_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_i64_59_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab61
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
    jmp lab62

lab61:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]

lab62:
    ; substitute (a1 := a1)(as0 := as0)(a0 := a0);
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

List_i64_58_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab64
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab63
    ; ####increment refcount
    add qword [r10 + 0], 1

lab63:
    mov r9, [r8 + 40]
    jmp lab65

lab64:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab65:
    ; substitute (a0 := a0)(xs := xs)(x := x)(acc := acc);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; let x0: List[i64] = Cons(x, acc);
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
    je lab77
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab78

lab77:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab75
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab76

lab75:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab76:

lab78:
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
    ; jump rev_acc_
    jmp rev_acc_

rev_:
    ; let x0: List[i64] = Nil();
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
    ; jump rev_acc_
    jmp rev_acc_

map_i_board_:
    ; substitute (a0 := a0)(f := f)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_i64_79]
    add rcx, r9
    jmp rcx

List_i64_79:
    jmp near List_i64_79_Nil
    jmp near List_i64_79_Cons

List_i64_79_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab82
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab80
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab81

lab80:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab81:

lab82:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_i64_79_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab84
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab83
    ; ####increment refcount
    add qword [r10 + 0], 1

lab83:
    mov r9, [r8 + 40]
    jmp lab85

lab84:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab85:
    ; substitute (x := x)(f0 := f)(f := f)(xs := xs)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab86
    ; ####increment refcount
    add qword [rsi + 0], 1

lab86:
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov r8, rsi
    mov rdx, r9
    mov r9, rdi
    ; create a1: List[Option[Player]] = (f, xs, a0)\{ ... \};
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
    je lab98
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab99

lab98:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab96
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab92
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab90
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab91

lab90:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab91:

lab92:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab97

lab96:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab97:

lab99:
    ; #load tag
    lea r9, [rel List_Option_Player_100]
    ; substitute (x := x)(a1 := a1)(f0 := f0);
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

List_Option_Player_100:
    jmp near List_Option_Player_100_Nil
    jmp near List_Option_Player_100_Cons

List_Option_Player_100_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab104
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab101
    ; ####increment refcount
    add qword [r8 + 0], 1

lab101:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab102
    ; ####increment refcount
    add qword [rsi + 0], 1

lab102:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab103
    ; ####increment refcount
    add qword [rax + 0], 1

lab103:
    jmp lab105

lab104:
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

lab105:
    ; let x0: List[Option[Player]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(f := f)(x0 := x0)(xs := xs);
    ; #move variables
    mov rcx, r8
    mov r8, r10
    mov r10, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, r11
    mov r11, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump lift_map_i_board_0_
    jmp lift_map_i_board_0_

List_Option_Player_100_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab109
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab106
    ; ####increment refcount
    add qword [r12 + 0], 1

lab106:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab107
    ; ####increment refcount
    add qword [r10 + 0], 1

lab107:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab108
    ; ####increment refcount
    add qword [r8 + 0], 1

lab108:
    jmp lab110

lab109:
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

lab110:
    ; substitute (a0 := a0)(xs := xs)(f := f)(a4 := a4)(as1 := as1);
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
    ; let x0: List[Option[Player]] = Cons(a4, as1);
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
    je lab122
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab123

lab122:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab120
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab113
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab111
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab112

lab111:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab112:

lab113:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab116
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab114
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab115

lab114:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab115:

lab116:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab121

lab120:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab121:

lab123:
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(f := f)(x0 := x0)(xs := xs);
    ; #move variables
    mov rcx, r8
    mov r8, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, r11
    mov r11, rdi
    mov rdi, rcx
    ; jump lift_map_i_board_0_
    jmp lift_map_i_board_0_

lift_map_i_board_0_:
    ; substitute (xs := xs)(f := f)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; create a2: List[List[Option[Player]]] = (x0, a0)\{ ... \};
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
    je lab135
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab136

lab135:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab133
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab132
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab130
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab131

lab130:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab131:

lab132:
    jmp lab134

lab133:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab134:

lab136:
    ; #load tag
    lea r9, [rel List_List_Option_Player_137]
    ; jump map_i_board_
    jmp map_i_board_

List_List_Option_Player_137:
    jmp near List_List_Option_Player_137_Nil
    jmp near List_List_Option_Player_137_Cons

List_List_Option_Player_137_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab140
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab138
    ; ####increment refcount
    add qword [rsi + 0], 1

lab138:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab139
    ; ####increment refcount
    add qword [rax + 0], 1

lab139:
    jmp lab141

lab140:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab141:
    ; let x1: List[List[Option[Player]]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
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

List_List_Option_Player_137_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab144
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab142
    ; ####increment refcount
    add qword [r10 + 0], 1

lab142:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab143
    ; ####increment refcount
    add qword [r8 + 0], 1

lab143:
    jmp lab145

lab144:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab145:
    ; substitute (a0 := a0)(x0 := x0)(a3 := a3)(as0 := as0);
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
    ; let x1: List[List[Option[Player]]] = Cons(a3, as0);
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
    je lab157
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    ; invoke a0 Cons
    add r9, 5
    jmp r9

map_board_tree_:
    ; substitute (a0 := a0)(f := f)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_List_Option_Player_159]
    add rcx, r9
    jmp rcx

List_List_Option_Player_159:
    jmp near List_List_Option_Player_159_Nil
    jmp near List_List_Option_Player_159_Cons

List_List_Option_Player_159_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab162
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab160
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab161

lab160:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab161:

lab162:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_List_Option_Player_159_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab165
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab163
    ; ####increment refcount
    add qword [r10 + 0], 1

lab163:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab164
    ; ####increment refcount
    add qword [r8 + 0], 1

lab164:
    jmp lab166

lab165:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab166:
    ; substitute (x := x)(f0 := f)(f := f)(xs := xs)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab167
    ; ####increment refcount
    add qword [rsi + 0], 1

lab167:
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov rax, r8
    mov r8, rsi
    mov rdx, r9
    mov r9, rdi
    ; create a1: RoseTree[Pair[List[Option[Player]], i64]] = (f, xs, a0)\{ ... \};
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
    je lab179
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab180

lab179:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab177
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab173
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab171
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab172

lab171:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab172:

lab173:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab178

lab177:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab178:

lab180:
    ; #load tag
    lea r9, [rel RoseTree_Pair_List_Option_Player_i64_181]
    ; substitute (x := x)(a1 := a1)(f0 := f0);
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

RoseTree_Pair_List_Option_Player_i64_181:

RoseTree_Pair_List_Option_Player_i64_181_Rose:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab185
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab182
    ; ####increment refcount
    add qword [r12 + 0], 1

lab182:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab183
    ; ####increment refcount
    add qword [r10 + 0], 1

lab183:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab184
    ; ####increment refcount
    add qword [r8 + 0], 1

lab184:
    jmp lab186

lab185:
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

lab186:
    ; substitute (a0 := a0)(xs := xs)(f := f)(a4 := a4)(as1 := as1);
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
    ; let x0: RoseTree[Pair[List[Option[Player]], i64]] = Rose(a4, as1);
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
    je lab198
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab199

lab198:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab196
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab189
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab187
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab188

lab187:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab188:

lab189:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab192
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab190
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab191

lab190:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab191:

lab192:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab195
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab193
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab194

lab193:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab194:

lab195:
    jmp lab197

lab196:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab197:

lab199:
    ; #load tag
    mov r11, 0
    ; substitute (f := f)(xs := xs)(a0 := a0)(x0 := x0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a2: List[RoseTree[Pair[List[Option[Player]], i64]]] = (a0, x0)\{ ... \};
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
    lea r9, [rel List_RoseTree_Pair_List_Option_Player_i64_213]
    ; substitute (xs := xs)(f := f)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump map_board_tree_
    jmp map_board_tree_

List_RoseTree_Pair_List_Option_Player_i64_213:
    jmp near List_RoseTree_Pair_List_Option_Player_i64_213_Nil
    jmp near List_RoseTree_Pair_List_Option_Player_i64_213_Cons

List_RoseTree_Pair_List_Option_Player_i64_213_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab216
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab214
    ; ####increment refcount
    add qword [rsi + 0], 1

lab214:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab215
    ; ####increment refcount
    add qword [rax + 0], 1

lab215:
    jmp lab217

lab216:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab217:
    ; let x1: List[RoseTree[Pair[List[Option[Player]], i64]]] = Nil();
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

List_RoseTree_Pair_List_Option_Player_i64_213_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab220
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab218
    ; ####increment refcount
    add qword [r10 + 0], 1

lab218:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab219
    ; ####increment refcount
    add qword [r8 + 0], 1

lab219:
    jmp lab221

lab220:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab221:
    ; substitute (x0 := x0)(a0 := a0)(a3 := a3)(as0 := as0);
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
    ; let x1: List[RoseTree[Pair[List[Option[Player]], i64]]] = Cons(a3, as0);
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
    je lab233
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab234

lab233:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab231
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab224
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab222
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab223

lab222:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab223:

lab224:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab227
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab225
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab226

lab225:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab226:

lab227:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab232

lab231:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab232:

lab234:
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

map_tree_i_:
    ; substitute (a0 := a0)(f := f)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_RoseTree_Pair_List_Option_Player_i64_235]
    add rcx, r9
    jmp rcx

List_RoseTree_Pair_List_Option_Player_i64_235:
    jmp near List_RoseTree_Pair_List_Option_Player_i64_235_Nil
    jmp near List_RoseTree_Pair_List_Option_Player_i64_235_Cons

List_RoseTree_Pair_List_Option_Player_i64_235_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab238
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab236
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab237

lab236:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab237:

lab238:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_RoseTree_Pair_List_Option_Player_i64_235_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab241
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab239
    ; ####increment refcount
    add qword [r10 + 0], 1

lab239:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab240
    ; ####increment refcount
    add qword [r8 + 0], 1

lab240:
    jmp lab242

lab241:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab242:
    ; substitute (x := x)(f0 := f)(f := f)(xs := xs)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab243
    ; ####increment refcount
    add qword [rsi + 0], 1

lab243:
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov rax, r8
    mov r8, rsi
    mov rdx, r9
    mov r9, rdi
    ; create a1: _Cont = (f, xs, a0)\{ ... \};
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
    je lab255
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab256

lab255:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab253
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab246
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab244
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab245

lab244:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab245:

lab246:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab249
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab247
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab248

lab247:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab248:

lab249:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab254

lab253:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab254:

lab256:
    ; #load tag
    lea r9, [rel _Cont_257]
    ; substitute (x := x)(a1 := a1)(f0 := f0);
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

_Cont_257:

_Cont_257_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab261
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab258
    ; ####increment refcount
    add qword [r10 + 0], 1

lab258:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab259
    ; ####increment refcount
    add qword [r8 + 0], 1

lab259:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab260
    ; ####increment refcount
    add qword [rsi + 0], 1

lab260:
    jmp lab262

lab261:
    ; ##... or release blocks onto linear free list when loading
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

lab262:
    ; substitute (xs := xs)(f := f)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r8
    ; create a2: List[i64] = (x0, a0)\{ ... \};
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
    lea r9, [rel List_i64_276]
    ; jump map_tree_i_
    jmp map_tree_i_

List_i64_276:
    jmp near List_i64_276_Nil
    jmp near List_i64_276_Cons

List_i64_276_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab278
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
    jmp lab279

lab278:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]

lab279:
    ; let x1: List[i64] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
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

List_i64_276_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab281
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab280
    ; ####increment refcount
    add qword [r10 + 0], 1

lab280:
    mov r9, [r8 + 40]
    jmp lab282

lab281:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab282:
    ; substitute (a0 := a0)(x0 := x0)(a3 := a3)(as0 := as0);
    ; #move variables
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r10
    mov r10, rsi
    ; let x1: List[i64] = Cons(a3, as0);
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
    je lab294
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab295

lab294:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab292
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab293

lab292:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab293:

lab295:
    ; #load tag
    mov r9, 5
    ; substitute (x0 := x0)(x1 := x1)(a0 := a0);
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

tabulate_loop_:
    ; if n == len \{ ... \}
    cmp rdx, rdi
    je lab296
    ; else branch
    ; substitute (f0 := f)(len := len)(f := f)(a0 := a0)(n := n);
    ; #share f
    cmp r8, 0
    je lab297
    ; ####increment refcount
    add qword [r8 + 0], 1

lab297:
    ; #move variables
    mov r13, rdx
    mov rax, r8
    mov rdx, r9
    ; create a1: Option[Player] = (len, f, a0, n)\{ ... \};
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
    je lab309
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab310

lab309:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab307
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab300
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab298
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab299

lab298:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab299:

lab300:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab303
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab301
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab302

lab301:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab302:

lab303:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab306
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab304
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab305

lab304:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab305:

lab306:
    jmp lab308

lab307:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab308:

lab310:
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
    je lab322
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab323

lab322:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab320
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab316
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab314
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab315

lab314:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab315:

lab316:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab321

lab320:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab321:

lab323:
    ; #load tag
    lea rdi, [rel Option_Player_324]
    ; let x1: Unit = Unit();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x1 := x1)(a1 := a1)(f0 := f0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke f0 Apply
    ; #there is only one clause, so we can jump there directly
    jmp r9

Option_Player_324:
    jmp near Option_Player_324_None
    jmp near Option_Player_324_Some

Option_Player_324_None:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab327
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    ; ###load values
    mov r11, [rsi + 56]
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab325
    ; ####increment refcount
    add qword [r8 + 0], 1

lab325:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab326
    ; ####increment refcount
    add qword [rsi + 0], 1

lab326:
    jmp lab328

lab327:
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
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]

lab328:
    ; let x0: Option[Player] = None();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; substitute (a0 := a0)(f := f)(len := len)(n := n)(x0 := x0);
    ; #move variables
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r8
    ; jump lift_tabulate_loop_0_
    jmp lift_tabulate_loop_0_

Option_Player_324_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab331
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load link to next block
    mov r8, [rsi + 48]
    ; ###load values
    mov rdi, [rsi + 40]
    ; ###load values
    mov r13, [r8 + 56]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab329
    ; ####increment refcount
    add qword [r10 + 0], 1

lab329:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab330
    ; ####increment refcount
    add qword [r8 + 0], 1

lab330:
    jmp lab332

lab331:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load link to next block
    mov r8, [rsi + 48]
    ; ###load values
    mov rdi, [rsi + 40]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r13, [r8 + 56]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]

lab332:
    ; substitute (n := n)(len := len)(f := f)(a0 := a0)(a4 := a4);
    ; #move variables
    mov r12, rax
    mov rcx, r13
    mov r13, rdx
    mov rdx, rcx
    ; let x0: Option[Player] = Some(a4);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab344
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab345

lab344:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab342
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab343

lab342:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab343:

lab345:
    ; #load tag
    mov r13, 5
    ; substitute (a0 := a0)(f := f)(len := len)(n := n)(x0 := x0);
    ; #move variables
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    mov rsi, r8
    mov rax, r10
    ; jump lift_tabulate_loop_0_
    jmp lift_tabulate_loop_0_

lab296:
    ; then branch
    ; substitute (a0 := a0);
    ; #erase f
    cmp r8, 0
    je lab348
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab346
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab347

lab346:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab347:

lab348:
    ; #move variables
    mov rax, r10
    mov rdx, r11
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

lift_tabulate_loop_0_:
    ; substitute (n := n)(f := f)(len := len)(a0 := a0)(x0 := x0);
    ; #move variables
    mov r10, rax
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; create a2: List[Option[Player]] = (a0, x0)\{ ... \};
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
    je lab360
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab361

lab360:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab358
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab351
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab349
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab350

lab349:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab350:

lab351:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab354
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab352
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab353

lab352:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab353:

lab354:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab357
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab355
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab356

lab355:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab356:

lab357:
    jmp lab359

lab358:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab359:

lab361:
    ; #load tag
    lea r11, [rel List_Option_Player_362]
    ; lit x3 <- 1;
    mov r13, 1
    ; x4 <- n + x3;
    mov r15, rdx
    add r15, r13
    ; substitute (x4 := x4)(len := len)(f := f)(a2 := a2);
    ; #move variables
    mov r8, rsi
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    mov rdx, r15
    ; jump tabulate_loop_
    jmp tabulate_loop_

List_Option_Player_362:
    jmp near List_Option_Player_362_Nil
    jmp near List_Option_Player_362_Cons

List_Option_Player_362_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab365
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab363
    ; ####increment refcount
    add qword [rsi + 0], 1

lab363:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab364
    ; ####increment refcount
    add qword [rax + 0], 1

lab364:
    jmp lab366

lab365:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab366:
    ; let x2: List[Option[Player]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x0 := x0)(x2 := x2)(a0 := a0);
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

List_Option_Player_362_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab369
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab367
    ; ####increment refcount
    add qword [r10 + 0], 1

lab367:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab368
    ; ####increment refcount
    add qword [r8 + 0], 1

lab368:
    jmp lab370

lab369:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab370:
    ; substitute (x0 := x0)(a0 := a0)(a3 := a3)(as0 := as0);
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
    ; let x2: List[Option[Player]] = Cons(a3, as0);
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
    je lab382
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    mov r9, 5
    ; substitute (x0 := x0)(x2 := x2)(a0 := a0);
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

tabulate_:
    ; if len < 0 \{ ... \}
    cmp rdx, 0
    jl lab384
    ; else branch
    ; lit x0 <- 0;
    mov r11, 0
    ; substitute (x0 := x0)(len := len)(f := f)(a0 := a0);
    ; #move variables
    mov rcx, r11
    mov r11, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov r10, r8
    mov r8, rsi
    ; jump tabulate_loop_
    jmp tabulate_loop_

lab384:
    ; then branch
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab387
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab385
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab386

lab385:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab386:

lab387:
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

push_:
    ; substitute (a0 := a0)(i := i)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_i64_388]
    add rcx, r9
    jmp rcx

List_i64_388:
    jmp near List_i64_388_Nil
    jmp near List_i64_388_Cons

List_i64_388_Nil:
    ; let x0: List[i64] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (i := i)(x0 := x0)(a0 := a0);
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

List_i64_388_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab390
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab389
    ; ####increment refcount
    add qword [r10 + 0], 1

lab389:
    mov r9, [r8 + 40]
    jmp lab391

lab390:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab391:
    ; substitute (is := is)(i := i)(i1 := i1)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; create a1: List[i64] = (i1, a0)\{ ... \};
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
    lea r9, [rel List_i64_405]
    ; jump push_
    jmp push_

List_i64_405:
    jmp near List_i64_405_Nil
    jmp near List_i64_405_Cons

List_i64_405_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab407
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab406
    ; ####increment refcount
    add qword [rsi + 0], 1

lab406:
    mov rdx, [rax + 40]
    jmp lab408

lab407:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]

lab408:
    ; let x1: List[i64] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (i1 := i1)(x1 := x1)(a0 := a0);
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

List_i64_405_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab410
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab409
    ; ####increment refcount
    add qword [r10 + 0], 1

lab409:
    mov r9, [r8 + 40]
    jmp lab411

lab410:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab411:
    ; substitute (a0 := a0)(i1 := i1)(a2 := a2)(as0 := as0);
    ; #move variables
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r10
    mov r10, rsi
    ; let x1: List[i64] = Cons(a2, as0);
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
    je lab423
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab424

lab423:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab421
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab414
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab412
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab413

lab412:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab413:

lab414:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab417
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab415
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab416

lab415:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab416:

lab417:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab422

lab421:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab422:

lab424:
    ; #load tag
    mov r9, 5
    ; substitute (i1 := i1)(x1 := x1)(a0 := a0);
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

nth_:
    ; substitute (a0 := a0)(i := i)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_Option_Player_425]
    add rcx, r9
    jmp rcx

List_Option_Player_425:
    jmp near List_Option_Player_425_Nil
    jmp near List_Option_Player_425_Cons

List_Option_Player_425_Nil:
    ; substitute (a0 := a0);
    ; invoke a0 None
    add rdx, 0
    jmp rdx

List_Option_Player_425_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab428
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab426
    ; ####increment refcount
    add qword [r10 + 0], 1

lab426:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab427
    ; ####increment refcount
    add qword [r8 + 0], 1

lab427:
    jmp lab429

lab428:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab429:
    ; if i == 0 \{ ... \}
    cmp rdi, 0
    je lab430
    ; else branch
    ; substitute (a0 := a0)(i := i)(ps := ps);
    ; #erase p
    cmp r8, 0
    je lab433
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab431
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab432

lab431:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab432:

lab433:
    ; #move variables
    mov r8, r10
    mov r9, r11
    ; lit x0 <- 1;
    mov r11, 1
    ; x1 <- i - x0;
    mov r13, rdi
    sub r13, r11
    ; substitute (ps := ps)(x1 := x1)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov rdi, r13
    ; jump nth_
    jmp nth_

lab430:
    ; then branch
    ; substitute (a0 := a0)(p := p);
    ; #erase ps
    cmp r10, 0
    je lab436
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab434
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab435

lab434:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab435:

lab436:
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; switch p \{ ... \};
    lea rcx, [rel Option_Player_437]
    add rcx, rdi
    jmp rcx

Option_Player_437:
    jmp near Option_Player_437_None
    jmp near Option_Player_437_Some

Option_Player_437_None:
    ; invoke a0 None
    add rdx, 0
    jmp rdx

Option_Player_437_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab439
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab438
    ; ####increment refcount
    add qword [rsi + 0], 1

lab438:
    jmp lab440

lab439:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab440:
    ; substitute (a1 := a1)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Some
    add rdi, 5
    jmp rdi

find_:
    ; substitute (a0 := a0)(i := i)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_Option_Player_441]
    add rcx, r9
    jmp rcx

List_Option_Player_441:
    jmp near List_Option_Player_441_Nil
    jmp near List_Option_Player_441_Cons

List_Option_Player_441_Nil:
    ; substitute (a0 := a0);
    ; invoke a0 None
    add rdx, 0
    jmp rdx

List_Option_Player_441_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab444
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab442
    ; ####increment refcount
    add qword [r10 + 0], 1

lab442:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab443
    ; ####increment refcount
    add qword [r8 + 0], 1

lab443:
    jmp lab445

lab444:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab445:
    ; if i == 0 \{ ... \}
    cmp rdi, 0
    je lab446
    ; else branch
    ; substitute (a0 := a0)(i := i)(ps := ps);
    ; #erase p
    cmp r8, 0
    je lab449
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab447
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab448

lab447:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab448:

lab449:
    ; #move variables
    mov r8, r10
    mov r9, r11
    ; lit x0 <- 1;
    mov r11, 1
    ; x1 <- i - x0;
    mov r13, rdi
    sub r13, r11
    ; substitute (ps := ps)(x1 := x1)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov rdi, r13
    ; jump find_
    jmp find_

lab446:
    ; then branch
    ; substitute (a0 := a0)(p := p);
    ; #erase ps
    cmp r10, 0
    je lab452
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab450
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab451

lab450:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab451:

lab452:
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; switch p \{ ... \};
    lea rcx, [rel Option_Player_453]
    add rcx, rdi
    jmp rcx

Option_Player_453:
    jmp near Option_Player_453_None
    jmp near Option_Player_453_Some

Option_Player_453_None:
    ; invoke a0 None
    add rdx, 0
    jmp rdx

Option_Player_453_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab455
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab454
    ; ####increment refcount
    add qword [rsi + 0], 1

lab454:
    jmp lab456

lab455:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab456:
    ; substitute (a1 := a1)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Some
    add rdi, 5
    jmp rdi

exists_:
    ; substitute (f := f)(a0 := a0)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_List_i64_457]
    add rcx, r9
    jmp rcx

List_List_i64_457:
    jmp near List_List_i64_457_Nil
    jmp near List_List_i64_457_Cons

List_List_i64_457_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rax, 0
    je lab460
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab458
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab459

lab458:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab459:

lab460:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 False
    add rdx, 5
    jmp rdx

List_List_i64_457_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab463
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab461
    ; ####increment refcount
    add qword [r10 + 0], 1

lab461:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab462
    ; ####increment refcount
    add qword [r8 + 0], 1

lab462:
    jmp lab464

lab463:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab464:
    ; substitute (f0 := f)(is := is)(a0 := a0)(iss := iss)(f := f);
    ; #share f
    cmp rax, 0
    je lab465
    ; ####increment refcount
    add qword [rax + 0], 1

lab465:
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create a1: Bool = (a0, iss, f)\{ ... \};
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
    je lab477
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab478

lab477:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab475
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab471
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab469
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab470

lab469:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab470:

lab471:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab474
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab472
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab473

lab472:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab473:

lab474:
    jmp lab476

lab475:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab476:

lab478:
    ; #load tag
    lea r9, [rel Bool_479]
    ; substitute (is := is)(a1 := a1)(f0 := f0);
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

Bool_479:
    jmp near Bool_479_True
    jmp near Bool_479_False

Bool_479_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab483
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab480
    ; ####increment refcount
    add qword [r8 + 0], 1

lab480:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab481
    ; ####increment refcount
    add qword [rsi + 0], 1

lab481:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab482
    ; ####increment refcount
    add qword [rax + 0], 1

lab482:
    jmp lab484

lab483:
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

lab484:
    ; substitute (a0 := a0);
    ; #erase f
    cmp r8, 0
    je lab487
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab485
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab486

lab485:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab486:

lab487:
    ; #erase iss
    cmp rsi, 0
    je lab490
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab488
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab489

lab488:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab489:

lab490:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_479_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab494
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab491
    ; ####increment refcount
    add qword [r8 + 0], 1

lab491:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab492
    ; ####increment refcount
    add qword [rsi + 0], 1

lab492:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab493
    ; ####increment refcount
    add qword [rax + 0], 1

lab493:
    jmp lab495

lab494:
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

lab495:
    ; substitute (f := f)(iss := iss)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump exists_
    jmp exists_

all_i_:
    ; substitute (f := f)(a0 := a0)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_i64_496]
    add rcx, r9
    jmp rcx

List_i64_496:
    jmp near List_i64_496_Nil
    jmp near List_i64_496_Cons

List_i64_496_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rax, 0
    je lab499
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab497
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab498

lab497:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab498:

lab499:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 True
    add rdx, 0
    jmp rdx

List_i64_496_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab501
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab500
    ; ####increment refcount
    add qword [r10 + 0], 1

lab500:
    mov r9, [r8 + 40]
    jmp lab502

lab501:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab502:
    ; substitute (f0 := f)(i := i)(a0 := a0)(is := is)(f := f);
    ; #share f
    cmp rax, 0
    je lab503
    ; ####increment refcount
    add qword [rax + 0], 1

lab503:
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov r8, rsi
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create a1: Bool = (a0, is, f)\{ ... \};
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
    je lab515
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab516

lab515:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab513
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab506
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab504
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab505

lab504:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab505:

lab506:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab509
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab507
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab508

lab507:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab508:

lab509:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab512
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab510
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab511

lab510:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab511:

lab512:
    jmp lab514

lab513:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab514:

lab516:
    ; #load tag
    lea r9, [rel Bool_517]
    ; substitute (i := i)(a1 := a1)(f0 := f0);
    ; #move variables
    mov rsi, r8
    mov r8, rax
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke f0 Apply
    ; #there is only one clause, so we can jump there directly
    jmp r9

Bool_517:
    jmp near Bool_517_True
    jmp near Bool_517_False

Bool_517_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab521
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab518
    ; ####increment refcount
    add qword [r8 + 0], 1

lab518:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab519
    ; ####increment refcount
    add qword [rsi + 0], 1

lab519:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab520
    ; ####increment refcount
    add qword [rax + 0], 1

lab520:
    jmp lab522

lab521:
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

lab522:
    ; substitute (f := f)(is := is)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump all_i_
    jmp all_i_

Bool_517_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab526
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab523
    ; ####increment refcount
    add qword [r8 + 0], 1

lab523:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab524
    ; ####increment refcount
    add qword [rsi + 0], 1

lab524:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab525
    ; ####increment refcount
    add qword [rax + 0], 1

lab525:
    jmp lab527

lab526:
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

lab527:
    ; substitute (a0 := a0);
    ; #erase f
    cmp r8, 0
    je lab530
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab528
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab529

lab528:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab529:

lab530:
    ; #erase is
    cmp rsi, 0
    je lab533
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab531
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab532

lab531:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab532:

lab533:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

empty_:
    ; lit x0 <- 9;
    mov rdi, 9
    ; create x1: Fun[Unit, Option[Player]] = ()\{ ... \};
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    lea r9, [rel Fun_Unit_Option_Player_534]
    ; substitute (x0 := x0)(x1 := x1)(a0 := a0);
    ; #move variables
    mov rsi, r8
    mov r8, rax
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump tabulate_
    jmp tabulate_

Fun_Unit_Option_Player_534:

Fun_Unit_Option_Player_534_Apply:
    ; substitute (a1 := a1);
    ; #erase u
    cmp rax, 0
    je lab537
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab535
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab536

lab535:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab536:

lab537:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a1 None
    add rdx, 0
    jmp rdx

all_board_:
    ; substitute (a0 := a0)(f := f)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_Option_Player_538]
    add rcx, r9
    jmp rcx

List_Option_Player_538:
    jmp near List_Option_Player_538_Nil
    jmp near List_Option_Player_538_Cons

List_Option_Player_538_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab541
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab539
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab540

lab539:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab540:

lab541:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

List_Option_Player_538_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab544
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab542
    ; ####increment refcount
    add qword [r10 + 0], 1

lab542:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab543
    ; ####increment refcount
    add qword [r8 + 0], 1

lab543:
    jmp lab545

lab544:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab545:
    ; substitute (p := p)(f0 := f)(f := f)(ps := ps)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab546
    ; ####increment refcount
    add qword [rsi + 0], 1

lab546:
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
    je lab558
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab559

lab558:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab556
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab549
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab547
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab548

lab547:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab548:

lab549:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab552
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab550
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab551

lab550:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab551:

lab552:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab557

lab556:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab557:

lab559:
    ; #load tag
    lea r9, [rel Bool_560]
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

Bool_560:
    jmp near Bool_560_True
    jmp near Bool_560_False

Bool_560_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab564
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab561
    ; ####increment refcount
    add qword [r8 + 0], 1

lab561:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab562
    ; ####increment refcount
    add qword [rsi + 0], 1

lab562:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab563
    ; ####increment refcount
    add qword [rax + 0], 1

lab563:
    jmp lab565

lab564:
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

lab565:
    ; substitute (ps := ps)(f := f)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump all_board_
    jmp all_board_

Bool_560_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab569
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab566
    ; ####increment refcount
    add qword [r8 + 0], 1

lab566:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab567
    ; ####increment refcount
    add qword [rsi + 0], 1

lab567:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab568
    ; ####increment refcount
    add qword [rax + 0], 1

lab568:
    jmp lab570

lab569:
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

lab570:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rax, 0
    je lab573
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab571
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab572

lab571:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab572:

lab573:
    ; #erase ps
    cmp rsi, 0
    je lab576
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab574
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab575

lab574:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab575:

lab576:
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; invoke a0 False
    add rdx, 5
    jmp rdx

is_full_:
    ; create x0: Fun[Option[Player], Bool] = ()\{ ... \};
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    lea r9, [rel Fun_Option_Player_Bool_577]
    ; substitute (board := board)(x0 := x0)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump all_board_
    jmp all_board_

Fun_Option_Player_Bool_577:

Fun_Option_Player_Bool_577_Apply:
    ; jump is_some_
    jmp is_some_

is_cat_:
    ; substitute (board1 := board)(a0 := a0)(board := board);
    ; #share board
    cmp rax, 0
    je lab578
    ; ####increment refcount
    add qword [rax + 0], 1

lab578:
    ; #move variables
    mov r8, rax
    mov r9, rdx
    ; create a3: Bool = (a0, board)\{ ... \};
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
    je lab590
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
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
    lea rdi, [rel Bool_592]
    ; jump is_full_
    jmp is_full_

Bool_592:
    jmp near Bool_592_True
    jmp near Bool_592_False

Bool_592_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab595
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab593
    ; ####increment refcount
    add qword [rsi + 0], 1

lab593:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab594
    ; ####increment refcount
    add qword [rax + 0], 1

lab594:
    jmp lab596

lab595:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab596:
    ; substitute (board0 := board)(board := board)(a0 := a0);
    ; #share board
    cmp rsi, 0
    je lab597
    ; ####increment refcount
    add qword [rsi + 0], 1

lab597:
    ; #move variables
    mov r8, rax
    mov r9, rdx
    mov rax, rsi
    mov rdx, rdi
    ; create a2: Bool = (board, a0)\{ ... \};
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
    je lab609
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab610

lab609:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab607
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab606
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab604
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab605

lab604:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab605:

lab606:
    jmp lab608

lab607:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab608:

lab610:
    ; #load tag
    lea rdi, [rel Bool_611]
    ; let x1: Player = X();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (board0 := board0)(x1 := x1)(a2 := a2);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump is_win_for_
    jmp is_win_for_

Bool_611:
    jmp near Bool_611_True
    jmp near Bool_611_False

Bool_611_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab614
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab612
    ; ####increment refcount
    add qword [rsi + 0], 1

lab612:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab613
    ; ####increment refcount
    add qword [rax + 0], 1

lab613:
    jmp lab615

lab614:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab615:
    ; let x0: Bool = True();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (a0 := a0)(board := board)(x0 := x0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump lift_is_cat_0_
    jmp lift_is_cat_0_

Bool_611_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab618
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab616
    ; ####increment refcount
    add qword [rsi + 0], 1

lab616:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab617
    ; ####increment refcount
    add qword [rax + 0], 1

lab617:
    jmp lab619

lab618:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab619:
    ; let x0: Bool = False();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (a0 := a0)(board := board)(x0 := x0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump lift_is_cat_0_
    jmp lift_is_cat_0_

Bool_592_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab622
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab620
    ; ####increment refcount
    add qword [rsi + 0], 1

lab620:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab621
    ; ####increment refcount
    add qword [rax + 0], 1

lab621:
    jmp lab623

lab622:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab623:
    ; substitute (a0 := a0);
    ; #erase board
    cmp rsi, 0
    je lab626
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab624
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab625

lab624:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab625:

lab626:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

lift_is_cat_0_:
    ; substitute (x0 := x0)(board := board)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a4: Bool = (board, a0)\{ ... \};
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
    je lab638
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab639

lab638:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab636
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab632
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab630
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab631

lab630:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab631:

lab632:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab635
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab633
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab634

lab633:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab634:

lab635:
    jmp lab637

lab636:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab637:

lab639:
    ; #load tag
    lea rdi, [rel Bool_640]
    ; jump not_
    jmp not_

Bool_640:
    jmp near Bool_640_True
    jmp near Bool_640_False

Bool_640_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab643
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab641
    ; ####increment refcount
    add qword [rsi + 0], 1

lab641:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab642
    ; ####increment refcount
    add qword [rax + 0], 1

lab642:
    jmp lab644

lab643:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab644:
    ; create a1: Bool = (a0)\{ ... \};
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
    je lab656
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab657

lab656:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab654
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab653
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab651
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab652

lab651:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab652:

lab653:
    jmp lab655

lab654:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab655:

lab657:
    ; #load tag
    lea rdi, [rel Bool_658]
    ; let x3: Player = O();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (board := board)(x3 := x3)(a1 := a1);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump is_win_for_
    jmp is_win_for_

Bool_658:
    jmp near Bool_658_True
    jmp near Bool_658_False

Bool_658_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab660
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab659
    ; ####increment refcount
    add qword [rax + 0], 1

lab659:
    jmp lab661

lab660:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab661:
    ; let x2: Bool = True();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; substitute (x2 := x2)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

Bool_658_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab663
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab662
    ; ####increment refcount
    add qword [rax + 0], 1

lab662:
    jmp lab664

lab663:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab664:
    ; let x2: Bool = False();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 5
    ; substitute (x2 := x2)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

Bool_640_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab667
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab665
    ; ####increment refcount
    add qword [rsi + 0], 1

lab665:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab666
    ; ####increment refcount
    add qword [rax + 0], 1

lab666:
    jmp lab668

lab667:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab668:
    ; substitute (a0 := a0);
    ; #erase board
    cmp rax, 0
    je lab671
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab669
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab670

lab669:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab670:

lab671:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 False
    add rdx, 5
    jmp rdx

fold_i_:
    ; substitute (f := f)(start := start)(a0 := a0)(l := l);
    ; #move variables
    mov rcx, r10
    mov r10, r8
    mov r8, rcx
    mov rcx, r11
    mov r11, r9
    mov r9, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_i64_672]
    add rcx, r11
    jmp rcx

List_i64_672:
    jmp near List_i64_672_Nil
    jmp near List_i64_672_Cons

List_i64_672_Nil:
    ; substitute (start := start)(a0 := a0);
    ; #erase f
    cmp rax, 0
    je lab675
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab673
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab674

lab673:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab674:

lab675:
    ; #move variables
    mov rdx, rdi
    mov rsi, r8
    mov rdi, r9
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

List_i64_672_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab677
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab676
    ; ####increment refcount
    add qword [r12 + 0], 1

lab676:
    mov r11, [r10 + 40]
    jmp lab678

lab677:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]

lab678:
    ; substitute (f0 := f)(start := start)(i := i)(a0 := a0)(is := is)(f := f);
    ; #share f
    cmp rax, 0
    je lab679
    ; ####increment refcount
    add qword [rax + 0], 1

lab679:
    ; #move variables
    mov r14, rax
    mov r15, rdx
    mov r10, r8
    mov rcx, r11
    mov r11, r9
    mov r9, rcx
    ; create a1: _Cont = (a0, is, f)\{ ... \};
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
    je lab691
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab692

lab691:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab689
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab682
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab680
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab681

lab680:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab681:

lab682:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab685
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab683
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab684

lab683:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab684:

lab685:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab688
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab686
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab687

lab686:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab687:

lab688:
    jmp lab690

lab689:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab690:

lab692:
    ; #load tag
    lea r11, [rel _Cont_693]
    ; substitute (start := start)(i := i)(a1 := a1)(f0 := f0);
    ; #move variables
    mov r8, r10
    mov r10, rax
    mov rcx, rdi
    mov rdi, r9
    mov r9, r11
    mov r11, rdx
    mov rdx, rcx
    ; invoke f0 Apply2
    ; #there is only one clause, so we can jump there directly
    jmp r11

_Cont_693:

_Cont_693_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab697
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab694
    ; ####increment refcount
    add qword [r10 + 0], 1

lab694:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab695
    ; ####increment refcount
    add qword [r8 + 0], 1

lab695:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab696
    ; ####increment refcount
    add qword [rsi + 0], 1

lab696:
    jmp lab698

lab697:
    ; ##... or release blocks onto linear free list when loading
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

lab698:
    ; substitute (f := f)(x0 := x0)(is := is)(a0 := a0);
    ; #move variables
    mov rcx, r11
    mov r11, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, r10
    mov r10, rsi
    ; jump fold_i_
    jmp fold_i_

list_extreme_:
    ; substitute (f := f)(a0 := a0)(l := l);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; switch l \{ ... \};
    lea rcx, [rel List_i64_699]
    add rcx, r9
    jmp rcx

List_i64_699:
    jmp near List_i64_699_Nil
    jmp near List_i64_699_Cons

List_i64_699_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rax, 0
    je lab702
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab700
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab701

lab700:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab701:

lab702:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; lit x0 <- 0;
    mov rdi, 0
    ; substitute (x0 := x0)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

List_i64_699_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab704
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab703
    ; ####increment refcount
    add qword [r10 + 0], 1

lab703:
    mov r9, [r8 + 40]
    jmp lab705

lab704:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab705:
    ; substitute (f := f)(i := i)(is := is)(a0 := a0);
    ; #move variables
    mov r8, r10
    mov r10, rsi
    mov rcx, r9
    mov r9, r11
    mov r11, rdi
    mov rdi, rcx
    ; jump fold_i_
    jmp fold_i_

listmax_:
    ; create x0: Fun2[i64, i64, i64] = ()\{ ... \};
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    lea r9, [rel Fun2_i64_i64_i64_706]
    ; substitute (x0 := x0)(l := l)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump list_extreme_
    jmp list_extreme_

Fun2_i64_i64_i64_706:

Fun2_i64_i64_i64_706_Apply2:
    ; if b < a \{ ... \}
    cmp rdi, rdx
    jl lab707
    ; else branch
    ; substitute (b := b)(a1 := a1);
    ; #move variables
    mov rdx, rdi
    mov rsi, r8
    mov rdi, r9
    ; invoke a1 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

lab707:
    ; then branch
    ; substitute (a := a)(a1 := a1);
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; invoke a1 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

listmin_:
    ; create x0: Fun2[i64, i64, i64] = ()\{ ... \};
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    lea r9, [rel Fun2_i64_i64_i64_708]
    ; substitute (x0 := x0)(l := l)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump list_extreme_
    jmp list_extreme_

Fun2_i64_i64_i64_708:

Fun2_i64_i64_i64_708_Apply2:
    ; if a < b \{ ... \}
    cmp rdx, rdi
    jl lab709
    ; else branch
    ; substitute (b := b)(a1 := a1);
    ; #move variables
    mov rdx, rdi
    mov rsi, r8
    mov rdi, r9
    ; invoke a1 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

lab709:
    ; then branch
    ; substitute (a := a)(a1 := a1);
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; invoke a1 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

rows_:
    ; lit x0 <- 0;
    mov rdi, 0
    ; lit x1 <- 1;
    mov r9, 1
    ; lit x2 <- 2;
    mov r11, 2
    ; let x3: List[i64] = Nil();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; let x4: List[i64] = Cons(x2, x3);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
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
    je lab721
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab722

lab721:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab719
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab712
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab710
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab711

lab710:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab711:

lab712:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab715
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab713
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab714

lab713:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab714:

lab715:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab718
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab716
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab717

lab716:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab717:

lab718:
    jmp lab720

lab719:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab720:

lab722:
    ; #load tag
    mov r11, 5
    ; let x5: List[i64] = Cons(x1, x4);
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
    je lab734
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab735

lab734:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab732
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab728
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab726
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab727

lab726:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab727:

lab728:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab731
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab729
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab730

lab729:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab730:

lab731:
    jmp lab733

lab732:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab733:

lab735:
    ; #load tag
    mov r9, 5
    ; let x6: List[i64] = Cons(x0, x5);
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
    je lab747
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab748

lab747:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab745
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab738
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab736
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab737

lab736:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab737:

lab738:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab741
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab739
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab740

lab739:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab740:

lab741:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab744
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab742
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab743

lab742:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab743:

lab744:
    jmp lab746

lab745:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab746:

lab748:
    ; #load tag
    mov rdi, 5
    ; lit x7 <- 3;
    mov r9, 3
    ; lit x8 <- 4;
    mov r11, 4
    ; lit x9 <- 5;
    mov r13, 5
    ; let x10: List[i64] = Nil();
    ; #mark no allocation
    mov r14, 0
    ; #load tag
    mov r15, 0
    ; let x11: List[i64] = Cons(x9, x10);
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
    je lab760
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab761

lab760:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab758
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab751
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab749
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab750

lab749:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab750:

lab751:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab754
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab752
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab753

lab752:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab753:

lab754:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab757
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab755
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab756

lab755:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab756:

lab757:
    jmp lab759

lab758:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab759:

lab761:
    ; #load tag
    mov r13, 5
    ; let x12: List[i64] = Cons(x8, x11);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
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
    je lab773
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
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
    ; #load tag
    mov r11, 5
    ; let x13: List[i64] = Cons(x7, x12);
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
    je lab786
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    ; #load tag
    mov r9, 5
    ; lit x14 <- 6;
    mov r11, 6
    ; lit x15 <- 7;
    mov r13, 7
    ; lit x16 <- 8;
    mov r15, 8
    ; let x17: List[i64] = Nil();
    ; #mark no allocation
    mov qword [rsp + 2032], 0
    ; #load tag
    mov qword [rsp + 2024], 0
    ; let x18: List[i64] = Cons(x16, x17);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
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
    je lab799
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
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
    mov r15, 5
    ; let x19: List[i64] = Cons(x15, x18);
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
    je lab812
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab813

lab812:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab810
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab803
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab801
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab802

lab801:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab802:

lab803:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab806
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab804
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab805

lab804:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab805:

lab806:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab809
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab807
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab808

lab807:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab808:

lab809:
    jmp lab811

lab810:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab811:

lab813:
    ; #load tag
    mov r13, 5
    ; let x20: List[i64] = Cons(x14, x19);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
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
    je lab825
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab826

lab825:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab823
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab822
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab820
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab821

lab820:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab821:

lab822:
    jmp lab824

lab823:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab824:

lab826:
    ; #load tag
    mov r11, 5
    ; let x21: List[List[i64]] = Nil();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; let x22: List[List[i64]] = Cons(x20, x21);
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
    je lab838
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab839

lab838:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab836
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab829
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab827
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab828

lab827:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab828:

lab829:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab832
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab830
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab831

lab830:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab831:

lab832:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab837

lab836:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab837:

lab839:
    ; #load tag
    mov r11, 5
    ; let x23: List[List[i64]] = Cons(x13, x22);
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
    je lab851
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab852

lab851:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab849
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab842
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab840
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab841

lab840:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab841:

lab842:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab845
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab843
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab844

lab843:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab844:

lab845:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab848
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab846
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab847

lab846:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab847:

lab848:
    jmp lab850

lab849:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab850:

lab852:
    ; #load tag
    mov r9, 5
    ; substitute (x6 := x6)(x23 := x23)(a0 := a0);
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

cols_:
    ; lit x0 <- 0;
    mov rdi, 0
    ; lit x1 <- 3;
    mov r9, 3
    ; lit x2 <- 6;
    mov r11, 6
    ; let x3: List[i64] = Nil();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; let x4: List[i64] = Cons(x2, x3);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
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
    je lab864
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab865

lab864:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab862
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab855
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab853
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab854

lab853:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab854:

lab855:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab858
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab856
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab857

lab856:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab857:

lab858:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab861
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab859
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab860

lab859:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab860:

lab861:
    jmp lab863

lab862:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab863:

lab865:
    ; #load tag
    mov r11, 5
    ; let x5: List[i64] = Cons(x1, x4);
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
    je lab877
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab878

lab877:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab875
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab868
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab866
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab867

lab866:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab867:

lab868:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab871
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab869
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab870

lab869:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab870:

lab871:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab874
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab872
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab873

lab872:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab873:

lab874:
    jmp lab876

lab875:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab876:

lab878:
    ; #load tag
    mov r9, 5
    ; let x6: List[i64] = Cons(x0, x5);
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
    je lab890
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab891

lab890:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab888
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab881
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab879
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab880

lab879:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab880:

lab881:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab884
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab882
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab883

lab882:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab883:

lab884:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab887
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab885
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab886

lab885:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab886:

lab887:
    jmp lab889

lab888:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab889:

lab891:
    ; #load tag
    mov rdi, 5
    ; lit x7 <- 1;
    mov r9, 1
    ; lit x8 <- 4;
    mov r11, 4
    ; lit x9 <- 7;
    mov r13, 7
    ; let x10: List[i64] = Nil();
    ; #mark no allocation
    mov r14, 0
    ; #load tag
    mov r15, 0
    ; let x11: List[i64] = Cons(x9, x10);
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
    je lab903
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab904

lab903:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab901
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab894
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab892
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab893

lab892:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab893:

lab894:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab897
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab895
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab896

lab895:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab896:

lab897:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab900
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab898
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab899

lab898:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab899:

lab900:
    jmp lab902

lab901:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab902:

lab904:
    ; #load tag
    mov r13, 5
    ; let x12: List[i64] = Cons(x8, x11);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
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
    je lab916
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab917

lab916:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab914
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab907
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab905
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab906

lab905:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab906:

lab907:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab910
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab908
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab909

lab908:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab909:

lab910:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab913
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab911
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab912

lab911:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab912:

lab913:
    jmp lab915

lab914:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab915:

lab917:
    ; #load tag
    mov r11, 5
    ; let x13: List[i64] = Cons(x7, x12);
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
    je lab929
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab930

lab929:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab927
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab920
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab918
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab919

lab918:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab919:

lab920:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab923
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab921
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab922

lab921:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab922:

lab923:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab926
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab924
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab925

lab924:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab925:

lab926:
    jmp lab928

lab927:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab928:

lab930:
    ; #load tag
    mov r9, 5
    ; lit x14 <- 2;
    mov r11, 2
    ; lit x15 <- 5;
    mov r13, 5
    ; lit x16 <- 8;
    mov r15, 8
    ; let x17: List[i64] = Nil();
    ; #mark no allocation
    mov qword [rsp + 2032], 0
    ; #load tag
    mov qword [rsp + 2024], 0
    ; let x18: List[i64] = Cons(x16, x17);
    ; #allocate memory
    ; ##store values
    mov rcx, [rsp + 2024]
    mov [rbx + 56], rcx
    mov rcx, [rsp + 2032]
    mov [rbx + 48], rcx
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
    je lab942
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
    jmp lab943

lab942:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab940
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab933
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab931
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab932

lab931:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab932:

lab933:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab936
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab934
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab935

lab934:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab935:

lab936:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab939
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab937
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab938

lab937:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab938:

lab939:
    jmp lab941

lab940:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab941:

lab943:
    ; #load tag
    mov r15, 5
    ; let x19: List[i64] = Cons(x15, x18);
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
    je lab955
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab956

lab955:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab953
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab946
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab944
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab945

lab944:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab945:

lab946:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab949
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab947
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab948

lab947:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab948:

lab949:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab952
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab950
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab951

lab950:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab951:

lab952:
    jmp lab954

lab953:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab954:

lab956:
    ; #load tag
    mov r13, 5
    ; let x20: List[i64] = Cons(x14, x19);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
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
    je lab968
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab969

lab968:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab966
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab959
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab957
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab958

lab957:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab958:

lab959:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab962
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab960
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab961

lab960:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab961:

lab962:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab965
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab963
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab964

lab963:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab964:

lab965:
    jmp lab967

lab966:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab967:

lab969:
    ; #load tag
    mov r11, 5
    ; let x21: List[List[i64]] = Nil();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; let x22: List[List[i64]] = Cons(x20, x21);
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
    je lab981
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab982

lab981:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab979
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab972
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab970
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab971

lab970:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab971:

lab972:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab975
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab973
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab974

lab973:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab974:

lab975:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab978
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab976
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab977

lab976:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab977:

lab978:
    jmp lab980

lab979:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab980:

lab982:
    ; #load tag
    mov r11, 5
    ; let x23: List[List[i64]] = Cons(x13, x22);
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
    je lab994
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab995

lab994:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab992
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab985
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab983
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab984

lab983:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab984:

lab985:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab988
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab986
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab987

lab986:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab987:

lab988:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab991
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab989
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab990

lab989:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab990:

lab991:
    jmp lab993

lab992:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab993:

lab995:
    ; #load tag
    mov r9, 5
    ; substitute (x6 := x6)(x23 := x23)(a0 := a0);
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

diags_:
    ; lit x0 <- 0;
    mov rdi, 0
    ; lit x1 <- 4;
    mov r9, 4
    ; lit x2 <- 8;
    mov r11, 8
    ; let x3: List[i64] = Nil();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; let x4: List[i64] = Cons(x2, x3);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
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
    je lab1007
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1008

lab1007:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1005
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab998
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab996
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab997

lab996:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab997:

lab998:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1001
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab999
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1000

lab999:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1000:

lab1001:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1004
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1002
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1003

lab1002:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1003:

lab1004:
    jmp lab1006

lab1005:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1006:

lab1008:
    ; #load tag
    mov r11, 5
    ; let x5: List[i64] = Cons(x1, x4);
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
    je lab1020
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1021

lab1020:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1018
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1011
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1009
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1010

lab1009:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1010:

lab1011:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1014
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1012
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1013

lab1012:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1013:

lab1014:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1017
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1015
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1016

lab1015:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1016:

lab1017:
    jmp lab1019

lab1018:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1019:

lab1021:
    ; #load tag
    mov r9, 5
    ; let x6: List[i64] = Cons(x0, x5);
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
    je lab1033
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1034

lab1033:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1031
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1024
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1022
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1023

lab1022:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1023:

lab1024:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1027
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1025
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1026

lab1025:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1026:

lab1027:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1030
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1028
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1029

lab1028:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1029:

lab1030:
    jmp lab1032

lab1031:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1032:

lab1034:
    ; #load tag
    mov rdi, 5
    ; lit x7 <- 2;
    mov r9, 2
    ; lit x8 <- 4;
    mov r11, 4
    ; lit x9 <- 6;
    mov r13, 6
    ; let x10: List[i64] = Nil();
    ; #mark no allocation
    mov r14, 0
    ; #load tag
    mov r15, 0
    ; let x11: List[i64] = Cons(x9, x10);
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
    je lab1046
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1047

lab1046:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1044
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1037
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1035
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1036

lab1035:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1036:

lab1037:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1040
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1038
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1039

lab1038:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1039:

lab1040:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1043
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1041
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1042

lab1041:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1042:

lab1043:
    jmp lab1045

lab1044:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1045:

lab1047:
    ; #load tag
    mov r13, 5
    ; let x12: List[i64] = Cons(x8, x11);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
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
    je lab1059
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1060

lab1059:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1057
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1050
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1048
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1049

lab1048:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1049:

lab1050:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1053
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1051
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1052

lab1051:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1052:

lab1053:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1058

lab1057:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1058:

lab1060:
    ; #load tag
    mov r11, 5
    ; let x13: List[i64] = Cons(x7, x12);
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
    je lab1072
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1073

lab1072:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1070
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1066
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1064
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1065

lab1064:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1065:

lab1066:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1069
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1067
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1068

lab1067:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1068:

lab1069:
    jmp lab1071

lab1070:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1071:

lab1073:
    ; #load tag
    mov r9, 5
    ; let x14: List[List[i64]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; let x15: List[List[i64]] = Cons(x13, x14);
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
    je lab1085
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1086

lab1085:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1083
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1079
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1077
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1078

lab1077:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1078:

lab1079:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1082
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1080
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1081

lab1080:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1081:

lab1082:
    jmp lab1084

lab1083:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1084:

lab1086:
    ; #load tag
    mov r9, 5
    ; substitute (x6 := x6)(x15 := x15)(a0 := a0);
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

is_occupied_:
    ; create a1: Option[Player] = (a0)\{ ... \};
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
    je lab1098
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1099

lab1098:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1096
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1089
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1087
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1088

lab1087:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1088:

lab1089:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1092
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1090
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1091

lab1090:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1091:

lab1092:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1095
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1093
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1094

lab1093:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1094:

lab1095:
    jmp lab1097

lab1096:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1097:

lab1099:
    ; #load tag
    lea r9, [rel Option_Player_1100]
    ; jump nth_
    jmp nth_

Option_Player_1100:
    jmp near Option_Player_1100_None
    jmp near Option_Player_1100_Some

Option_Player_1100_None:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1102
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1101
    ; ####increment refcount
    add qword [rax + 0], 1

lab1101:
    jmp lab1103

lab1102:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1103:
    ; let x0: Option[Player] = None();
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
    ; jump is_some_
    jmp is_some_

Option_Player_1100_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1105
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab1104
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1104:
    jmp lab1106

lab1105:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab1106:
    ; substitute (a0 := a0)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; let x0: Option[Player] = Some(a2);
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
    je lab1118
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1119

lab1118:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1116
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1115
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1113
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1114

lab1113:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1114:

lab1115:
    jmp lab1117

lab1116:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1117:

lab1119:
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
    ; jump is_some_
    jmp is_some_

player_occupies_:
    ; substitute (i := i)(board := board)(p := p)(a0 := a0);
    ; #move variables
    mov r8, rax
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a1: Option[Player] = (p, a0)\{ ... \};
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
    je lab1131
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1132

lab1131:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1129
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1122
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1120
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1121

lab1120:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1121:

lab1122:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1125
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1123
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1124

lab1123:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1124:

lab1125:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1128
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1126
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1127

lab1126:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1127:

lab1128:
    jmp lab1130

lab1129:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1130:

lab1132:
    ; #load tag
    lea r9, [rel Option_Player_1133]
    ; substitute (board := board)(i := i)(a1 := a1);
    ; #move variables
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, rsi
    ; jump find_
    jmp find_

Option_Player_1133:
    jmp near Option_Player_1133_None
    jmp near Option_Player_1133_Some

Option_Player_1133_None:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1136
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1134
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1134:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1135
    ; ####increment refcount
    add qword [rax + 0], 1

lab1135:
    jmp lab1137

lab1136:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1137:
    ; substitute (a0 := a0);
    ; #erase p
    cmp rax, 0
    je lab1140
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab1138
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab1139

lab1138:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab1139:

lab1140:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Option_Player_1133_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1143
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab1141
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1141:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab1142
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1142:
    jmp lab1144

lab1143:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab1144:
    ; substitute (p := p)(p0 := p0)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump player_eq_
    jmp player_eq_

has_trip_:
    ; substitute (a0 := a0)(l := l)(p := p)(board := board);
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
    ; create x0: Fun[i64, Bool] = (p, board)\{ ... \};
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
    je lab1156
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1157

lab1156:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1154
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1147
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1145
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1146

lab1145:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1146:

lab1147:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1150
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1148
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1149

lab1148:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1149:

lab1150:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1153
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1151
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1152

lab1151:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1152:

lab1153:
    jmp lab1155

lab1154:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1155:

lab1157:
    ; #load tag
    lea r9, [rel Fun_i64_Bool_1158]
    ; substitute (x0 := x0)(l := l)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump all_i_
    jmp all_i_

Fun_i64_Bool_1158:

Fun_i64_Bool_1158_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1161
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1159
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1159:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1160
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1160:
    jmp lab1162

lab1161:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1162:
    ; substitute (p := p)(board := board)(i := i)(a1 := a1);
    ; #move variables
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    mov rax, r8
    ; jump player_occupies_
    jmp player_occupies_

has_row_:
    ; substitute (a0 := a0)(p := p)(board := board);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create x0: Fun[List[i64], Bool] = (p, board)\{ ... \};
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
    je lab1174
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1175

lab1174:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1172
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1168
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1166
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1167

lab1166:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1167:

lab1168:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1171
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1169
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1170

lab1169:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1170:

lab1171:
    jmp lab1173

lab1172:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1173:

lab1175:
    ; #load tag
    lea rdi, [rel Fun_List_i64_Bool_1176]
    ; create a2: List[List[i64]] = (a0, x0)\{ ... \};
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
    je lab1188
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab1189

lab1188:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1186
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1179
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1177
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1178

lab1177:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1178:

lab1179:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1182
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1180
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1181

lab1180:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1181:

lab1182:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1185
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1183
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1184

lab1183:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1184:

lab1185:
    jmp lab1187

lab1186:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1187:

lab1189:
    ; #load tag
    lea rdx, [rel List_List_i64_1190]
    ; jump rows_
    jmp rows_

List_List_i64_1190:
    jmp near List_List_i64_1190_Nil
    jmp near List_List_i64_1190_Cons

List_List_i64_1190_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1193
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1191
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1191:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1192
    ; ####increment refcount
    add qword [rax + 0], 1

lab1192:
    jmp lab1194

lab1193:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1194:
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
    ; jump exists_
    jmp exists_

List_List_i64_1190_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1197
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1195
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1195:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1196
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1196:
    jmp lab1198

lab1197:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1198:
    ; substitute (x0 := x0)(a0 := a0)(a3 := a3)(as0 := as0);
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
    ; let x1: List[List[i64]] = Cons(a3, as0);
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
    je lab1210
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1211

lab1210:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1208
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1204
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1202
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1203

lab1202:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1203:

lab1204:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1207
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1205
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1206

lab1205:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1206:

lab1207:
    jmp lab1209

lab1208:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1209:

lab1211:
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
    ; jump exists_
    jmp exists_

Fun_List_i64_Bool_1176:

Fun_List_i64_Bool_1176_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1214
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1212
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1212:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1213
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1213:
    jmp lab1215

lab1214:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1215:
    ; substitute (board := board)(p := p)(l := l)(a1 := a1);
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
    ; jump has_trip_
    jmp has_trip_

has_col_:
    ; substitute (a0 := a0)(p := p)(board := board);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create x0: Fun[List[i64], Bool] = (p, board)\{ ... \};
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
    je lab1227
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1228

lab1227:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1225
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1218
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1216
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1217

lab1216:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1217:

lab1218:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1221
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1219
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1220

lab1219:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1220:

lab1221:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1224
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1222
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1223

lab1222:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1223:

lab1224:
    jmp lab1226

lab1225:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1226:

lab1228:
    ; #load tag
    lea rdi, [rel Fun_List_i64_Bool_1229]
    ; create a2: List[List[i64]] = (a0, x0)\{ ... \};
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
    je lab1241
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab1242

lab1241:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1239
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1238
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1236
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1237

lab1236:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1237:

lab1238:
    jmp lab1240

lab1239:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1240:

lab1242:
    ; #load tag
    lea rdx, [rel List_List_i64_1243]
    ; jump cols_
    jmp cols_

List_List_i64_1243:
    jmp near List_List_i64_1243_Nil
    jmp near List_List_i64_1243_Cons

List_List_i64_1243_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1246
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1244
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1244:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1245
    ; ####increment refcount
    add qword [rax + 0], 1

lab1245:
    jmp lab1247

lab1246:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1247:
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
    ; jump exists_
    jmp exists_

List_List_i64_1243_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1250
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1248
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1248:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1249
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1249:
    jmp lab1251

lab1250:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1251:
    ; substitute (x0 := x0)(a0 := a0)(a3 := a3)(as0 := as0);
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
    ; let x1: List[List[i64]] = Cons(a3, as0);
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
    je lab1263
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1264

lab1263:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1261
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1254
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1252
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1253

lab1252:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1253:

lab1254:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1257
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1255
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1256

lab1255:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1256:

lab1257:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1260
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1258
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1259

lab1258:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1259:

lab1260:
    jmp lab1262

lab1261:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1262:

lab1264:
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
    ; jump exists_
    jmp exists_

Fun_List_i64_Bool_1229:

Fun_List_i64_Bool_1229_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1267
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1265
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1265:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1266
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1266:
    jmp lab1268

lab1267:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1268:
    ; substitute (board := board)(p := p)(l := l)(a1 := a1);
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
    ; jump has_trip_
    jmp has_trip_

has_diag_:
    ; substitute (a0 := a0)(p := p)(board := board);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create x0: Fun[List[i64], Bool] = (p, board)\{ ... \};
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
    je lab1280
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1281

lab1280:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1278
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1271
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1269
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1270

lab1269:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1270:

lab1271:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1274
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1272
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1273

lab1272:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1273:

lab1274:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1277
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1275
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1276

lab1275:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1276:

lab1277:
    jmp lab1279

lab1278:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1279:

lab1281:
    ; #load tag
    lea rdi, [rel Fun_List_i64_Bool_1282]
    ; create a2: List[List[i64]] = (a0, x0)\{ ... \};
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
    je lab1294
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab1295

lab1294:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1292
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1285
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1283
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1284

lab1283:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1284:

lab1285:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1288
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1286
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1287

lab1286:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1287:

lab1288:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1291
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1289
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1290

lab1289:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1290:

lab1291:
    jmp lab1293

lab1292:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1293:

lab1295:
    ; #load tag
    lea rdx, [rel List_List_i64_1296]
    ; jump diags_
    jmp diags_

List_List_i64_1296:
    jmp near List_List_i64_1296_Nil
    jmp near List_List_i64_1296_Cons

List_List_i64_1296_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1299
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1297
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1297:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1298
    ; ####increment refcount
    add qword [rax + 0], 1

lab1298:
    jmp lab1300

lab1299:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1300:
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
    ; jump exists_
    jmp exists_

List_List_i64_1296_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1303
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1301
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1301:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1302
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1302:
    jmp lab1304

lab1303:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1304:
    ; substitute (x0 := x0)(a0 := a0)(a3 := a3)(as0 := as0);
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
    ; let x1: List[List[i64]] = Cons(a3, as0);
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
    je lab1316
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1317

lab1316:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1314
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1307
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1305
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1306

lab1305:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1306:

lab1307:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1310
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1308
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1309

lab1308:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1309:

lab1310:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1313
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1311
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1312

lab1311:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1312:

lab1313:
    jmp lab1315

lab1314:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1315:

lab1317:
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
    ; jump exists_
    jmp exists_

Fun_List_i64_Bool_1282:

Fun_List_i64_Bool_1282_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1320
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1318
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1318:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1319
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1319:
    jmp lab1321

lab1320:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1321:
    ; substitute (board := board)(p := p)(l := l)(a1 := a1);
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
    ; jump has_trip_
    jmp has_trip_

is_win_for_:
    ; substitute (board1 := board)(p1 := p)(a0 := a0)(board := board)(p := p);
    ; #share board
    cmp rax, 0
    je lab1322
    ; ####increment refcount
    add qword [rax + 0], 1

lab1322:
    ; #share p
    cmp rsi, 0
    je lab1323
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1323:
    ; #move variables
    mov r10, rax
    mov r11, rdx
    mov r12, rsi
    mov r13, rdi
    ; create a1: Bool = (a0, board, p)\{ ... \};
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
    je lab1335
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1336

lab1335:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1333
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1326
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1324
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1325

lab1324:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1325:

lab1326:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1329
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1327
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1328

lab1327:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1328:

lab1329:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1334

lab1333:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1334:

lab1336:
    ; #load tag
    lea r9, [rel Bool_1337]
    ; jump has_row_
    jmp has_row_

Bool_1337:
    jmp near Bool_1337_True
    jmp near Bool_1337_False

Bool_1337_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1341
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1338
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1338:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1339
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1339:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1340
    ; ####increment refcount
    add qword [rax + 0], 1

lab1340:
    jmp lab1342

lab1341:
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

lab1342:
    ; substitute (a0 := a0);
    ; #erase board
    cmp rsi, 0
    je lab1345
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab1343
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab1344

lab1343:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab1344:

lab1345:
    ; #erase p
    cmp r8, 0
    je lab1348
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab1346
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab1347

lab1346:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab1347:

lab1348:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_1337_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1352
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1349
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1349:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1350
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1350:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1351
    ; ####increment refcount
    add qword [rax + 0], 1

lab1351:
    jmp lab1353

lab1352:
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

lab1353:
    ; substitute (p0 := p)(board0 := board)(p := p)(a0 := a0)(board := board);
    ; #share board
    cmp rsi, 0
    je lab1354
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1354:
    ; #share p
    cmp r8, 0
    je lab1355
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1355:
    ; #move variables
    mov r10, rax
    mov r11, rdx
    mov r12, rsi
    mov r13, rdi
    mov rax, r8
    mov rdx, r9
    ; create a2: Bool = (p, a0, board)\{ ... \};
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
    je lab1367
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1368

lab1367:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1365
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1358
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1356
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1357

lab1356:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1357:

lab1358:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1361
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1359
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1360

lab1359:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1360:

lab1361:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1364
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1362
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1363

lab1362:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1363:

lab1364:
    jmp lab1366

lab1365:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1366:

lab1368:
    ; #load tag
    lea r9, [rel Bool_1369]
    ; substitute (board0 := board0)(p0 := p0)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump has_col_
    jmp has_col_

Bool_1369:
    jmp near Bool_1369_True
    jmp near Bool_1369_False

Bool_1369_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1373
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1370
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1370:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1371
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1371:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1372
    ; ####increment refcount
    add qword [rax + 0], 1

lab1372:
    jmp lab1374

lab1373:
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

lab1374:
    ; substitute (a0 := a0);
    ; #erase board
    cmp r8, 0
    je lab1377
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab1375
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab1376

lab1375:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab1376:

lab1377:
    ; #erase p
    cmp rax, 0
    je lab1380
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab1378
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab1379

lab1378:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab1379:

lab1380:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_1369_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1384
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1381
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1381:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1382
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1382:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1383
    ; ####increment refcount
    add qword [rax + 0], 1

lab1383:
    jmp lab1385

lab1384:
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

lab1385:
    ; substitute (board := board)(p := p)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump has_diag_
    jmp has_diag_

is_win_:
    ; let x0: Player = X();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (board0 := board)(x0 := x0)(a0 := a0)(board := board);
    ; #share board
    cmp rax, 0
    je lab1386
    ; ####increment refcount
    add qword [rax + 0], 1

lab1386:
    ; #move variables
    mov r10, rax
    mov r11, rdx
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create a1: Bool = (a0, board)\{ ... \};
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
    je lab1398
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1399

lab1398:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1396
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1389
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1387
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1388

lab1387:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1388:

lab1389:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1392
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1390
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1391

lab1390:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1391:

lab1392:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1395
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1393
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1394

lab1393:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1394:

lab1395:
    jmp lab1397

lab1396:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1397:

lab1399:
    ; #load tag
    lea r9, [rel Bool_1400]
    ; jump is_win_for_
    jmp is_win_for_

Bool_1400:
    jmp near Bool_1400_True
    jmp near Bool_1400_False

Bool_1400_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1403
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1401
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1401:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1402
    ; ####increment refcount
    add qword [rax + 0], 1

lab1402:
    jmp lab1404

lab1403:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1404:
    ; substitute (a0 := a0);
    ; #erase board
    cmp rsi, 0
    je lab1407
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab1405
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab1406

lab1405:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab1406:

lab1407:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_1400_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1410
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1408
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1408:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1409
    ; ####increment refcount
    add qword [rax + 0], 1

lab1409:
    jmp lab1411

lab1410:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1411:
    ; let x1: Player = O();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (board := board)(x1 := x1)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump is_win_for_
    jmp is_win_for_

game_over_:
    ; substitute (board0 := board)(a0 := a0)(board := board);
    ; #share board
    cmp rax, 0
    je lab1412
    ; ####increment refcount
    add qword [rax + 0], 1

lab1412:
    ; #move variables
    mov r8, rax
    mov r9, rdx
    ; create a1: Bool = (a0, board)\{ ... \};
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
    je lab1424
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1425

lab1424:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1422
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1415
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1413
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1414

lab1413:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1414:

lab1415:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1418
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1416
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1417

lab1416:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1417:

lab1418:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1423

lab1422:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1423:

lab1425:
    ; #load tag
    lea rdi, [rel Bool_1426]
    ; jump is_win_
    jmp is_win_

Bool_1426:
    jmp near Bool_1426_True
    jmp near Bool_1426_False

Bool_1426_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1429
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1427
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1427:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1428
    ; ####increment refcount
    add qword [rax + 0], 1

lab1428:
    jmp lab1430

lab1429:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1430:
    ; substitute (a0 := a0);
    ; #erase board
    cmp rsi, 0
    je lab1433
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab1431
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab1432

lab1431:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab1432:

lab1433:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_1426_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1436
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1434
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1434:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1435
    ; ####increment refcount
    add qword [rax + 0], 1

lab1435:
    jmp lab1437

lab1436:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1437:
    ; substitute (board := board)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump is_cat_
    jmp is_cat_

score_:
    ; let x0: Player = X();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (board0 := board)(x0 := x0)(a0 := a0)(board := board);
    ; #share board
    cmp rax, 0
    je lab1438
    ; ####increment refcount
    add qword [rax + 0], 1

lab1438:
    ; #move variables
    mov r10, rax
    mov r11, rdx
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; create a1: Bool = (a0, board)\{ ... \};
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
    je lab1450
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1451

lab1450:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1448
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1447
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1445
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1446

lab1445:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1446:

lab1447:
    jmp lab1449

lab1448:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1449:

lab1451:
    ; #load tag
    lea r9, [rel Bool_1452]
    ; jump is_win_for_
    jmp is_win_for_

Bool_1452:
    jmp near Bool_1452_True
    jmp near Bool_1452_False

Bool_1452_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1455
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1453
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1453:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1454
    ; ####increment refcount
    add qword [rax + 0], 1

lab1454:
    jmp lab1456

lab1455:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1456:
    ; substitute (a0 := a0);
    ; #erase board
    cmp rsi, 0
    je lab1459
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab1457
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab1458

lab1457:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab1458:

lab1459:
    ; lit x2 <- 1;
    mov rdi, 1
    ; substitute (x2 := x2)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

Bool_1452_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1462
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1460
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1460:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1461
    ; ####increment refcount
    add qword [rax + 0], 1

lab1461:
    jmp lab1463

lab1462:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1463:
    ; let x1: Player = O();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (x1 := x1)(board := board)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a2: Bool = (a0)\{ ... \};
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
    je lab1475
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1476

lab1475:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1473
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1466
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1464
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1465

lab1464:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1465:

lab1466:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1469
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1467
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1468

lab1467:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1468:

lab1469:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1474

lab1473:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1474:

lab1476:
    ; #load tag
    lea r9, [rel Bool_1477]
    ; substitute (board := board)(x1 := x1)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump is_win_for_
    jmp is_win_for_

Bool_1477:
    jmp near Bool_1477_True
    jmp near Bool_1477_False

Bool_1477_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1479
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1478
    ; ####increment refcount
    add qword [rax + 0], 1

lab1478:
    jmp lab1480

lab1479:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1480:
    ; lit x3 <- -1;
    mov rdi, -1
    ; substitute (x3 := x3)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

Bool_1477_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1482
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1481
    ; ####increment refcount
    add qword [rax + 0], 1

lab1481:
    jmp lab1483

lab1482:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1483:
    ; lit x4 <- 0;
    mov rdi, 0
    ; substitute (x4 := x4)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

put_at_:
    ; if i == 0 \{ ... \}
    cmp r9, 0
    je lab1484
    ; else branch
    ; if i > 0 \{ ... \}
    cmp r9, 0
    jg lab1485
    ; else branch
    ; substitute (a0 := a0);
    ; #erase x
    cmp rax, 0
    je lab1488
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab1486
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab1487

lab1486:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab1487:

lab1488:
    ; #erase xs
    cmp rsi, 0
    je lab1491
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab1489
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab1490

lab1489:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab1490:

lab1491:
    ; #move variables
    mov rax, r10
    mov rdx, r11
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

lab1485:
    ; then branch
    ; substitute (xs0 := xs)(xs := xs)(i := i)(a0 := a0)(x := x);
    ; #share xs
    cmp rsi, 0
    je lab1492
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1492:
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov rax, rsi
    mov rdx, rdi
    ; create a2: Option[Player] = (xs, i, a0, x)\{ ... \};
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
    je lab1504
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1505

lab1504:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1502
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1495
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1493
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1494

lab1493:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1494:

lab1495:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1503

lab1502:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1503:

lab1505:
    ; ##store link to previous block
    mov [rbx + 48], r8
    ; ##store values
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
    je lab1517
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1518

lab1517:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1515
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1508
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1506
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1507

lab1506:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1507:

lab1508:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1516

lab1515:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1516:

lab1518:
    ; #load tag
    lea rdi, [rel Option_Player_1519]
    ; jump head_
    jmp head_

Option_Player_1519:
    jmp near Option_Player_1519_None
    jmp near Option_Player_1519_Some

Option_Player_1519_None:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1523
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1520
    ; ####increment refcount
    add qword [rax + 0], 1

lab1520:
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab1521
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1521:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab1522
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1522:
    mov rdi, [rsi + 24]
    jmp lab1524

lab1523:
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

lab1524:
    ; let x1: Option[Player] = None();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; substitute (a0 := a0)(i := i)(x := x)(x1 := x1)(xs := xs);
    ; #move variables
    mov rcx, r8
    mov r8, r10
    mov r10, r12
    mov r12, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, r11
    mov r11, r13
    mov r13, rdx
    mov rdx, rcx
    ; jump lift_put_at_0_
    jmp lift_put_at_0_

Option_Player_1519_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1528
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load link to next block
    mov r8, [rsi + 48]
    ; ###load values
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab1525
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1525:
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab1526
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1526:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab1527
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1527:
    mov r9, [r8 + 24]
    jmp lab1529

lab1528:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load link to next block
    mov r8, [rsi + 48]
    ; ###load values
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    mov r9, [r8 + 24]

lab1529:
    ; substitute (x := x)(xs := xs)(i := i)(a0 := a0)(a8 := a8);
    ; #move variables
    mov rcx, r12
    mov r12, rax
    mov rax, rcx
    mov rcx, r13
    mov r13, rdx
    mov rdx, rcx
    ; let x1: Option[Player] = Some(a8);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
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
    mov r13, 5
    ; substitute (a0 := a0)(i := i)(x := x)(x1 := x1)(xs := xs);
    ; #move variables
    mov r8, rax
    mov rcx, r11
    mov r11, r13
    mov r13, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r10
    mov r10, r12
    mov r12, rsi
    ; jump lift_put_at_0_
    jmp lift_put_at_0_

lab1484:
    ; then branch
    ; substitute (xs := xs)(x := x)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov r8, r10
    mov r9, r11
    ; create a1: List[Option[Player]] = (x, a0)\{ ... \};
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
    je lab1554
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
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
    lea rdi, [rel List_Option_Player_1556]
    ; jump tail_
    jmp tail_

List_Option_Player_1556:
    jmp near List_Option_Player_1556_Nil
    jmp near List_Option_Player_1556_Cons

List_Option_Player_1556_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1559
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1557
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1557:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1558
    ; ####increment refcount
    add qword [rax + 0], 1

lab1558:
    jmp lab1560

lab1559:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1560:
    ; let x0: List[Option[Player]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x := x)(x0 := x0)(a0 := a0);
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

List_Option_Player_1556_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1563
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1561
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1561:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1562
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1562:
    jmp lab1564

lab1563:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1564:
    ; substitute (a0 := a0)(x := x)(a5 := a5)(as0 := as0);
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
    ; let x0: List[Option[Player]] = Cons(a5, as0);
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
    je lab1576
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1577

lab1576:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1574
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1567
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1565
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1566

lab1565:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1566:

lab1567:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1570
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1568
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1569

lab1568:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1569:

lab1570:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1573
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1571
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1572

lab1571:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1572:

lab1573:
    jmp lab1575

lab1574:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1575:

lab1577:
    ; #load tag
    mov r9, 5
    ; substitute (x := x)(x0 := x0)(a0 := a0);
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

lift_put_at_0_:
    ; substitute (xs := xs)(i := i)(x := x)(x1 := x1)(a0 := a0);
    ; #move variables
    mov rcx, r12
    mov r12, rax
    mov rax, rcx
    mov rcx, r13
    mov r13, rdx
    mov rdx, rcx
    ; create a3: List[Option[Player]] = (x1, a0)\{ ... \};
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
    je lab1589
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1590

lab1589:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1587
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1580
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1578
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1579

lab1578:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1579:

lab1580:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1583
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1581
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1582

lab1581:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1582:

lab1583:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1586
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1584
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1585

lab1584:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1585:

lab1586:
    jmp lab1588

lab1587:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1588:

lab1590:
    ; #load tag
    lea r11, [rel List_Option_Player_1591]
    ; create a4: List[Option[Player]] = (i, x, a3)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
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
    je lab1603
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1604

lab1603:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1601
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1594
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1592
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1593

lab1592:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1593:

lab1594:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1602

lab1601:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1602:

lab1604:
    ; #load tag
    lea rdi, [rel List_Option_Player_1605]
    ; jump tail_
    jmp tail_

List_Option_Player_1605:
    jmp near List_Option_Player_1605_Nil
    jmp near List_Option_Player_1605_Cons

List_Option_Player_1605_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1608
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1606
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1606:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1607
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1607:
    mov rdx, [rax + 24]
    jmp lab1609

lab1608:
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

lab1609:
    ; let x3: List[Option[Player]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a3 := a3)(i := i)(x := x)(x3 := x3);
    ; #move variables
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, r8
    mov r8, rsi
    ; jump lift_put_at_1_
    jmp lift_put_at_1_

List_Option_Player_1605_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1612
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab1610
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1610:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab1611
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1611:
    mov r9, [r8 + 24]
    jmp lab1613

lab1612:
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

lab1613:
    ; substitute (a3 := a3)(x := x)(i := i)(a7 := a7)(as2 := as2);
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
    ; let x3: List[Option[Player]] = Cons(a7, as2);
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
    je lab1625
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1626

lab1625:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1623
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1619
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1617
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1618

lab1617:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1618:

lab1619:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1622
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1620
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1621

lab1620:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1621:

lab1622:
    jmp lab1624

lab1623:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1624:

lab1626:
    ; #load tag
    mov r11, 5
    ; substitute (a3 := a3)(i := i)(x := x)(x3 := x3);
    ; #move variables
    mov r8, rsi
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump lift_put_at_1_
    jmp lift_put_at_1_

List_Option_Player_1591:
    jmp near List_Option_Player_1591_Nil
    jmp near List_Option_Player_1591_Cons

List_Option_Player_1591_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1629
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1627
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1627:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1628
    ; ####increment refcount
    add qword [rax + 0], 1

lab1628:
    jmp lab1630

lab1629:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1630:
    ; let x2: List[Option[Player]] = Nil();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x1 := x1)(x2 := x2)(a0 := a0);
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

List_Option_Player_1591_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1633
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1631
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1631:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1632
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1632:
    jmp lab1634

lab1633:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1634:
    ; substitute (a0 := a0)(x1 := x1)(a6 := a6)(as1 := as1);
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
    ; let x2: List[Option[Player]] = Cons(a6, as1);
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
    je lab1646
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1647

lab1646:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1644
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1637
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1635
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1636

lab1635:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1636:

lab1637:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1640
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1638
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1639

lab1638:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1639:

lab1640:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1643
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1641
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1642

lab1641:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1642:

lab1643:
    jmp lab1645

lab1644:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1645:

lab1647:
    ; #load tag
    mov r9, 5
    ; substitute (x1 := x1)(x2 := x2)(a0 := a0);
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

lift_put_at_1_:
    ; lit x4 <- 1;
    mov r13, 1
    ; x5 <- i - x4;
    mov r15, rdi
    sub r15, r13
    ; substitute (x := x)(x3 := x3)(x5 := x5)(a3 := a3);
    ; #move variables
    mov rsi, r10
    mov r10, rax
    mov rdi, r11
    mov r11, rdx
    mov rax, r8
    mov rdx, r9
    mov r9, r15
    ; jump put_at_
    jmp put_at_

move_to_:
    ; substitute (board0 := board)(i0 := i)(i := i)(a0 := a0)(board := board)(p := p);
    ; #share board
    cmp rax, 0
    je lab1648
    ; ####increment refcount
    add qword [rax + 0], 1

lab1648:
    ; #move variables
    mov r12, rax
    mov r13, rdx
    mov r14, rsi
    mov r15, rdi
    mov rdi, r9
    ; create a1: Bool = (i, a0, board, p)\{ ... \};
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
    je lab1660
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1661

lab1660:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1658
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1651
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1649
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1650

lab1649:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1650:

lab1651:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1659

lab1658:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1659:

lab1661:
    ; ##store link to previous block
    mov [rbx + 48], r10
    ; ##store values
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
    je lab1673
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1674

lab1673:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1671
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1664
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1662
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1663

lab1662:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1663:

lab1664:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1672

lab1671:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1672:

lab1674:
    ; #load tag
    lea r9, [rel Bool_1675]
    ; jump is_occupied_
    jmp is_occupied_

Bool_1675:
    jmp near Bool_1675_True
    jmp near Bool_1675_False

Bool_1675_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1679
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
    je lab1676
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1676:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab1677
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1677:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab1678
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1678:
    jmp lab1680

lab1679:
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
    mov rsi, [rsi + 16]

lab1680:
    ; substitute (a0 := a0);
    ; #erase board
    cmp r8, 0
    je lab1683
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab1681
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab1682

lab1681:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab1682:

lab1683:
    ; #erase p
    cmp r10, 0
    je lab1686
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab1684
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab1685

lab1684:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab1685:

lab1686:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

Bool_1675_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1690
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
    je lab1687
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1687:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab1688
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1688:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab1689
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1689:
    jmp lab1691

lab1690:
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
    mov rsi, [rsi + 16]

lab1691:
    ; let x0: Option[Player] = Some(p);
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
    je lab1703
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1704

lab1703:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1701
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1697
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1695
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1696

lab1695:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1696:

lab1697:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1700
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1698
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1699

lab1698:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1699:

lab1700:
    jmp lab1702

lab1701:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1702:

lab1704:
    ; #load tag
    mov r11, 5
    ; substitute (x0 := x0)(board := board)(i := i)(a0 := a0);
    ; #move variables
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r10
    mov r10, rsi
    mov rsi, r8
    ; jump put_at_
    jmp put_at_

all_moves_rec_:
    ; substitute (n := n)(a0 := a0)(acc := acc)(board := board);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; switch board \{ ... \};
    lea rcx, [rel List_Option_Player_1705]
    add rcx, r11
    jmp rcx

List_Option_Player_1705:
    jmp near List_Option_Player_1705_Nil
    jmp near List_Option_Player_1705_Cons

List_Option_Player_1705_Nil:
    ; substitute (acc := acc)(a0 := a0);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; jump rev_
    jmp rev_

List_Option_Player_1705_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab1708
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab1706
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1706:
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]
    cmp r10, 0
    je lab1707
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1707:
    jmp lab1709

lab1708:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]

lab1709:
    ; substitute (n := n)(a0 := a0)(acc := acc)(more := more)(p := p);
    ; #move variables
    mov rcx, r12
    mov r12, r10
    mov r10, rcx
    mov rcx, r13
    mov r13, r11
    mov r11, rcx
    ; switch p \{ ... \};
    lea rcx, [rel Option_Player_1710]
    add rcx, r13
    jmp rcx

Option_Player_1710:
    jmp near Option_Player_1710_None
    jmp near Option_Player_1710_Some

Option_Player_1710_None:
    ; lit x0 <- 1;
    mov r13, 1
    ; x1 <- n + x0;
    mov r15, rdx
    add r15, r13
    ; substitute (x1 := x1)(a0 := a0)(more := more)(n := n)(acc := acc);
    ; #move variables
    mov r13, r9
    mov r9, r11
    mov r11, rdx
    mov r12, r8
    mov r8, r10
    mov rdx, r15
    ; let x2: List[i64] = Cons(n, acc);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
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
    je lab1722
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1723

lab1722:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1720
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1713
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1711
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1712

lab1711:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1712:

lab1713:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1716
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1714
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1715

lab1714:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1715:

lab1716:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1721

lab1720:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1721:

lab1723:
    ; #load tag
    mov r11, 5
    ; substitute (x1 := x1)(more := more)(x2 := x2)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, r11
    mov r11, rdi
    mov rdi, rcx
    ; jump all_moves_rec_
    jmp all_moves_rec_

Option_Player_1710_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [r12 + 0], 0
    je lab1725
    ; ##either decrement refcount and share children...
    add qword [r12 + 0], -1
    ; ###load values
    mov r13, [r12 + 56]
    mov r12, [r12 + 48]
    cmp r12, 0
    je lab1724
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1724:
    jmp lab1726

lab1725:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov r13, [r12 + 56]
    mov r12, [r12 + 48]

lab1726:
    ; substitute (n := n)(a0 := a0)(acc := acc)(more := more);
    ; #erase p0
    cmp r12, 0
    je lab1729
    ; ######check refcount
    cmp qword [r12 + 0], 0
    je lab1727
    ; ######either decrement refcount ...
    add qword [r12 + 0], -1
    jmp lab1728

lab1727:
    ; ######... or add block to lazy free list
    mov [r12 + 0], rbp
    mov rbp, r12

lab1728:

lab1729:
    ; lit x3 <- 1;
    mov r13, 1
    ; x4 <- n + x3;
    mov r15, rdx
    add r15, r13
    ; substitute (x4 := x4)(more := more)(acc := acc)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    mov rdx, r15
    ; jump all_moves_rec_
    jmp all_moves_rec_

all_moves_:
    ; lit x0 <- 0;
    mov r9, 0
    ; let x1: List[i64] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (x0 := x0)(board := board)(x1 := x1)(a0 := a0);
    ; #move variables
    mov r8, r10
    mov r10, rsi
    mov rsi, rax
    mov rcx, r9
    mov r9, r11
    mov r11, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump all_moves_rec_
    jmp all_moves_rec_

successors_:
    ; substitute (board0 := board)(p := p)(a0 := a0)(board := board);
    ; #share board
    cmp rax, 0
    je lab1730
    ; ####increment refcount
    add qword [rax + 0], 1

lab1730:
    ; #move variables
    mov r10, rax
    mov r11, rdx
    ; create a1: List[i64] = (p, a0, board)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    mov [rbx + 24], rdi
    mov [rbx + 16], rsi
    ; ##acquire free block from heap register
    mov rsi, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1742
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1743

lab1742:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1740
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1736
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1734
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1735

lab1734:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1735:

lab1736:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1739
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1737
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1738

lab1737:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1738:

lab1739:
    jmp lab1741

lab1740:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1741:

lab1743:
    ; #load tag
    lea rdi, [rel List_i64_1744]
    ; jump all_moves_
    jmp all_moves_

List_i64_1744:
    jmp near List_i64_1744_Nil
    jmp near List_i64_1744_Cons

List_i64_1744_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1748
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1745
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1745:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1746
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1746:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1747
    ; ####increment refcount
    add qword [rax + 0], 1

lab1747:
    jmp lab1749

lab1748:
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

lab1749:
    ; let x0: List[i64] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(board := board)(p := p)(x0 := x0);
    ; #move variables
    mov rcx, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump lift_successors_0_
    jmp lift_successors_0_

List_i64_1744_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1753
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab1750
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1750:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab1751
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1751:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab1752
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1752:
    jmp lab1754

lab1753:
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

lab1754:
    ; substitute (board := board)(a0 := a0)(p := p)(a3 := a3)(as0 := as0);
    ; #move variables
    mov rcx, r13
    mov r13, rdi
    mov rdi, r11
    mov r11, rdx
    mov rdx, rcx
    mov rax, r12
    mov r12, rsi
    mov rsi, r10
    ; let x0: List[i64] = Cons(a3, as0);
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
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
    je lab1766
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1767

lab1766:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1764
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1757
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1755
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1756

lab1755:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1756:

lab1757:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1760
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1758
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1759

lab1758:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1759:

lab1760:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1763
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1761
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1762

lab1761:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1762:

lab1763:
    jmp lab1765

lab1764:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1765:

lab1767:
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(board := board)(p := p)(x0 := x0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump lift_successors_0_
    jmp lift_successors_0_

lift_successors_0_:
    ; substitute (a0 := a0)(x0 := x0)(p := p)(board := board);
    ; #move variables
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; create x1: Fun[i64, List[Option[Player]]] = (p, board)\{ ... \};
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
    je lab1779
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1780

lab1779:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1777
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1770
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1768
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1769

lab1768:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1769:

lab1770:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1773
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1771
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1772

lab1771:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1772:

lab1773:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1776
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1774
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1775

lab1774:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1775:

lab1776:
    jmp lab1778

lab1777:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1778:

lab1780:
    ; #load tag
    lea r9, [rel Fun_i64_List_Option_Player_1781]
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
    ; jump map_i_board_
    jmp map_i_board_

Fun_i64_List_Option_Player_1781:

Fun_i64_List_Option_Player_1781_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1784
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1782
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1782:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1783
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1783:
    jmp lab1785

lab1784:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1785:
    ; substitute (board := board)(p := p)(i := i)(a2 := a2);
    ; #move variables
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r10
    mov r10, rsi
    mov rsi, r8
    ; jump move_to_
    jmp move_to_

minimax_:
    ; substitute (board2 := board)(board := board)(a0 := a0)(p := p);
    ; #share board
    cmp rsi, 0
    je lab1786
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1786:
    ; #move variables
    mov r10, rax
    mov r11, rdx
    mov rax, rsi
    mov rdx, rdi
    ; create a9: Bool = (board, a0, p)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    mov [rbx + 24], rdi
    mov [rbx + 16], rsi
    ; ##acquire free block from heap register
    mov rsi, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1798
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1799

lab1798:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1796
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1789
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1787
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1788

lab1787:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1788:

lab1789:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1797

lab1796:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1797:

lab1799:
    ; #load tag
    lea rdi, [rel Bool_1800]
    ; jump game_over_
    jmp game_over_

Bool_1800:
    jmp near Bool_1800_True
    jmp near Bool_1800_False

Bool_1800_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1804
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1801
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1801:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1802
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1802:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1803
    ; ####increment refcount
    add qword [rax + 0], 1

lab1803:
    jmp lab1805

lab1804:
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

lab1805:
    ; substitute (board0 := board)(a0 := a0)(board := board);
    ; #share board
    cmp rax, 0
    je lab1806
    ; ####increment refcount
    add qword [rax + 0], 1

lab1806:
    ; #erase p
    cmp r8, 0
    je lab1809
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab1807
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab1808

lab1807:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab1808:

lab1809:
    ; #move variables
    mov r8, rax
    mov r9, rdx
    ; create a1: _Cont = (a0, board)\{ ... \};
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
    je lab1821
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1822

lab1821:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1819
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1812
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1810
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1811

lab1810:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1811:

lab1812:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1815
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1813
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1814

lab1813:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1814:

lab1815:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1820

lab1819:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1820:

lab1822:
    ; #load tag
    lea rdi, [rel _Cont_1823]
    ; jump score_
    jmp score_

_Cont_1823:

_Cont_1823_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1826
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab1824
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1824:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab1825
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1825:
    jmp lab1827

lab1826:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab1827:
    ; substitute (a0 := a0)(board := board)(x0 := x0);
    ; #move variables
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, rsi
    mov rsi, r8
    ; let x1: Pair[List[Option[Player]], i64] = Tup(board, x0);
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
    je lab1839
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1840

lab1839:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1837
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1830
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1828
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1829

lab1828:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1829:

lab1830:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1833
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1831
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1832

lab1831:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1832:

lab1833:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1838

lab1837:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1838:

lab1840:
    ; #load tag
    mov rdi, 0
    ; substitute (x1 := x1)(a0 := a0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump mk_leaf_
    jmp mk_leaf_

Bool_1800_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1844
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1841
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1841:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1842
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1842:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1843
    ; ####increment refcount
    add qword [rax + 0], 1

lab1843:
    jmp lab1845

lab1844:
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

lab1845:
    ; substitute (board1 := board)(p0 := p)(p := p)(board := board)(a0 := a0);
    ; #share board
    cmp rax, 0
    je lab1846
    ; ####increment refcount
    add qword [rax + 0], 1

lab1846:
    ; #share p
    cmp r8, 0
    je lab1847
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1847:
    ; #move variables
    mov r10, rax
    mov r11, rdx
    mov r12, rsi
    mov r13, rdi
    mov rsi, r8
    mov rdi, r9
    ; create a6: List[List[Option[Player]]] = (p, board, a0)\{ ... \};
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
    je lab1859
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1860

lab1859:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1857
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1853
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1851
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1852

lab1851:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1852:

lab1853:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1856
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1854
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1855

lab1854:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1855:

lab1856:
    jmp lab1858

lab1857:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1858:

lab1860:
    ; #load tag
    lea r9, [rel List_List_Option_Player_1861]
    ; jump successors_
    jmp successors_

List_List_Option_Player_1861:
    jmp near List_List_Option_Player_1861_Nil
    jmp near List_List_Option_Player_1861_Cons

List_List_Option_Player_1861_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1865
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1862
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1862:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1863
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1863:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1864
    ; ####increment refcount
    add qword [rax + 0], 1

lab1864:
    jmp lab1866

lab1865:
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

lab1866:
    ; let x2: List[List[Option[Player]]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(board := board)(p := p)(x2 := x2);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump lift_minimax_0_
    jmp lift_minimax_0_

List_List_Option_Player_1861_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1870
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab1867
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1867:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab1868
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1868:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab1869
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1869:
    jmp lab1871

lab1870:
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

lab1871:
    ; substitute (a0 := a0)(board := board)(p := p)(a15 := a15)(as2 := as2);
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
    ; let x2: List[List[Option[Player]]] = Cons(a15, as2);
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
    je lab1883
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1884

lab1883:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1881
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1874
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1872
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1873

lab1872:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1873:

lab1874:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1877
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1875
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1876

lab1875:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1876:

lab1877:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1880
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1878
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1879

lab1878:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1879:

lab1880:
    jmp lab1882

lab1881:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1882:

lab1884:
    ; #load tag
    mov r11, 5
    ; jump lift_minimax_0_
    jmp lift_minimax_0_

lift_minimax_0_:
    ; substitute (a0 := a0)(board := board)(p0 := p)(x2 := x2)(p := p);
    ; #share p
    cmp r8, 0
    je lab1885
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1885:
    ; #move variables
    mov r12, r8
    mov r13, r9
    ; create x3: Fun[List[Option[Player]], RoseTree[Pair[List[Option[Player]], i64]]] = (p)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r13
    mov [rbx + 48], r12
    ; ##mark unused fields with null
    mov qword [rbx + 16], 0
    mov qword [rbx + 32], 0
    ; ##acquire free block from heap register
    mov r12, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab1897
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
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
    lea r13, [rel Fun_List_Option_Player_RoseTree_Pair_List_Option_Player_i64_1899]
    ; substitute (x3 := x3)(x2 := x2)(p0 := p0)(board := board)(a0 := a0);
    ; #move variables
    mov rcx, r12
    mov r12, rax
    mov rax, rcx
    mov rcx, r13
    mov r13, rdx
    mov rdx, rcx
    mov rcx, r10
    mov r10, rsi
    mov rsi, rcx
    mov rcx, r11
    mov r11, rdi
    mov rdi, rcx
    ; create a10: List[RoseTree[Pair[List[Option[Player]], i64]]] = (p0, board, a0)\{ ... \};
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
    je lab1911
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1912

lab1911:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1909
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1905
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1903
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1904

lab1903:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1904:

lab1905:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1908
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1906
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1907

lab1906:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1907:

lab1908:
    jmp lab1910

lab1909:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1910:

lab1912:
    ; #load tag
    lea r9, [rel List_RoseTree_Pair_List_Option_Player_i64_1913]
    ; substitute (x2 := x2)(x3 := x3)(a10 := a10);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump map_board_tree_
    jmp map_board_tree_

List_RoseTree_Pair_List_Option_Player_i64_1913:
    jmp near List_RoseTree_Pair_List_Option_Player_i64_1913_Nil
    jmp near List_RoseTree_Pair_List_Option_Player_i64_1913_Cons

List_RoseTree_Pair_List_Option_Player_i64_1913_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1917
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1914
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1914:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1915
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1915:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1916
    ; ####increment refcount
    add qword [rax + 0], 1

lab1916:
    jmp lab1918

lab1917:
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

lab1918:
    ; let trees: List[RoseTree[Pair[List[Option[Player]], i64]]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(board := board)(p0 := p0)(trees := trees);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump lift_minimax_1_
    jmp lift_minimax_1_

List_RoseTree_Pair_List_Option_Player_i64_1913_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1922
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab1919
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1919:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab1920
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1920:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab1921
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1921:
    jmp lab1923

lab1922:
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

lab1923:
    ; substitute (a0 := a0)(board := board)(p0 := p0)(a14 := a14)(as1 := as1);
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
    ; let trees: List[RoseTree[Pair[List[Option[Player]], i64]]] = Cons(a14, as1);
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
    je lab1935
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1936

lab1935:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1933
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1926
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1924
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1925

lab1924:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1925:

lab1926:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1929
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1927
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1928

lab1927:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1928:

lab1929:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1932
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1930
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1931

lab1930:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1931:

lab1932:
    jmp lab1934

lab1933:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1934:

lab1936:
    ; #load tag
    mov r11, 5
    ; jump lift_minimax_1_
    jmp lift_minimax_1_

Fun_List_Option_Player_RoseTree_Pair_List_Option_Player_i64_1899:

Fun_List_Option_Player_RoseTree_Pair_List_Option_Player_i64_1899_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1938
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab1937
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1937:
    jmp lab1939

lab1938:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab1939:
    ; substitute (p := p)(a7 := a7)(b := b);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a8: Player = (a7, b)\{ ... \};
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
    je lab1951
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1952

lab1951:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1949
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1942
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1940
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1941

lab1940:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1941:

lab1942:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1945
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1943
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1944

lab1943:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1944:

lab1945:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1950

lab1949:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1950:

lab1952:
    ; #load tag
    lea rdi, [rel Player_1953]
    ; jump other_
    jmp other_

Player_1953:
    jmp near Player_1953_X
    jmp near Player_1953_O

Player_1953_X:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1956
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1954
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1954:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1955
    ; ####increment refcount
    add qword [rax + 0], 1

lab1955:
    jmp lab1957

lab1956:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1957:
    ; let x10: Player = X();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x10 := x10)(b := b)(a7 := a7);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump minimax_
    jmp minimax_

Player_1953_O:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1960
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1958
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1958:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1959
    ; ####increment refcount
    add qword [rax + 0], 1

lab1959:
    jmp lab1961

lab1960:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1961:
    ; let x10: Player = O();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (x10 := x10)(b := b)(a7 := a7);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump minimax_
    jmp minimax_

lift_minimax_1_:
    ; create x4: Fun[RoseTree[Pair[List[Option[Player]], i64]], i64] = ()\{ ... \};
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    lea r13, [rel Fun_RoseTree_Pair_List_Option_Player_i64_i64_1962]
    ; substitute (x4 := x4)(trees0 := trees)(p := p)(trees := trees)(board := board)(a0 := a0);
    ; #share trees
    cmp r10, 0
    je lab1963
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1963:
    ; #move variables
    mov r14, rax
    mov r15, rdx
    mov rax, r12
    mov r12, rsi
    mov rdx, r13
    mov r13, rdi
    mov rsi, r10
    mov rdi, r11
    ; create a11: List[i64] = (p, trees, board, a0)\{ ... \};
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
    je lab1975
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
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
    je lab1988
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    lea r9, [rel List_i64_1990]
    ; substitute (trees0 := trees0)(x4 := x4)(a11 := a11);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump map_tree_i_
    jmp map_tree_i_

List_i64_1990:
    jmp near List_i64_1990_Nil
    jmp near List_i64_1990_Cons

List_i64_1990_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1995
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1991
    ; ####increment refcount
    add qword [rax + 0], 1

lab1991:
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab1992
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1992:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab1993
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1993:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab1994
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1994:
    jmp lab1996

lab1995:
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

lab1996:
    ; let scores: List[i64] = Nil();
    ; #mark no allocation
    mov r12, 0
    ; #load tag
    mov r13, 0
    ; substitute (a0 := a0)(board := board)(p := p)(scores := scores)(trees := trees);
    ; #move variables
    mov rcx, r10
    mov r10, r12
    mov r12, rsi
    mov rsi, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, r13
    mov r13, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    ; jump lift_minimax_2_
    jmp lift_minimax_2_

List_i64_1990_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2001
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load link to next block
    mov r10, [r8 + 48]
    ; ###load values
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1997
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1997:
    ; ###load values
    mov r15, [r10 + 56]
    mov r14, [r10 + 48]
    cmp r14, 0
    je lab1998
    ; ####increment refcount
    add qword [r14 + 0], 1

lab1998:
    mov r13, [r10 + 40]
    mov r12, [r10 + 32]
    cmp r12, 0
    je lab1999
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1999:
    mov r11, [r10 + 24]
    mov r10, [r10 + 16]
    cmp r10, 0
    je lab2000
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2000:
    jmp lab2002

lab2001:
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
    mov r12, [r10 + 32]
    mov r11, [r10 + 24]
    mov r10, [r10 + 16]

lab2002:
    ; substitute (a0 := a0)(board := board)(p := p)(trees := trees)(a13 := a13)(as0 := as0);
    ; #move variables
    mov rcx, r15
    mov r15, rdi
    mov rdi, r13
    mov r13, rdx
    mov rdx, rcx
    mov rax, r14
    mov r14, rsi
    mov rsi, r12
    ; let scores: List[i64] = Cons(a13, as0);
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
    je lab2014
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
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
    mov r13, 5
    ; substitute (a0 := a0)(board := board)(p := p)(scores := scores)(trees := trees);
    ; #move variables
    mov rcx, r12
    mov r12, r10
    mov r10, rcx
    mov rcx, r13
    mov r13, r11
    mov r11, rcx
    ; jump lift_minimax_2_
    jmp lift_minimax_2_

Fun_RoseTree_Pair_List_Option_Player_i64_i64_1962:

Fun_RoseTree_Pair_List_Option_Player_i64_i64_1962_Apply:
    ; create a5: Pair[List[Option[Player]], i64] = (a4)\{ ... \};
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
    je lab2027
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
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
    lea rdi, [rel Pair_List_Option_Player_i64_2029]
    ; jump top_
    jmp top_

Pair_List_Option_Player_i64_2029:

Pair_List_Option_Player_i64_2029_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2031
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab2030
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2030:
    jmp lab2032

lab2031:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab2032:
    ; substitute (a4 := a4)(a12 := a12)(b0 := b0);
    ; #move variables
    mov rsi, rax
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, r8
    ; let x9: Pair[List[Option[Player]], i64] = Tup(a12, b0);
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
    je lab2044
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2045

lab2044:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2042
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2035
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2033
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2034

lab2033:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2034:

lab2035:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2038
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2036
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2037

lab2036:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2037:

lab2038:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2041
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2039
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2040

lab2039:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2040:

lab2041:
    jmp lab2043

lab2042:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2043:

lab2045:
    ; #load tag
    mov rdi, 0
    ; substitute (x9 := x9)(a4 := a4);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump snd_
    jmp snd_

lift_minimax_2_:
    ; substitute (a0 := a0)(board := board)(trees := trees)(scores := scores)(p := p);
    ; #move variables
    mov rcx, r12
    mov r12, r8
    mov r8, rcx
    mov rcx, r13
    mov r13, r9
    mov r9, rcx
    ; switch p \{ ... \};
    lea rcx, [rel Player_2046]
    add rcx, r13
    jmp rcx

Player_2046:
    jmp near Player_2046_X
    jmp near Player_2046_O

Player_2046_X:
    ; substitute (scores := scores)(board := board)(trees := trees)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; create a2: _Cont = (board, trees, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    mov [rbx + 24], rdi
    mov [rbx + 16], rsi
    ; ##acquire free block from heap register
    mov rsi, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2058
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2059

lab2058:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2056
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2049
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2047
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2048

lab2047:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2048:

lab2049:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab2057

lab2056:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2057:

lab2059:
    ; #load tag
    lea rdi, [rel _Cont_2060]
    ; jump listmax_
    jmp listmax_

_Cont_2060:

_Cont_2060_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab2064
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab2061
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2061:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab2062
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2062:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab2063
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2063:
    jmp lab2065

lab2064:
    ; ##... or release blocks onto linear free list when loading
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

lab2065:
    ; substitute (a0 := a0)(trees := trees)(board := board)(x5 := x5);
    ; #move variables
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    mov rax, r10
    ; let x6: Pair[List[Option[Player]], i64] = Tup(board, x5);
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
    je lab2077
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2078

lab2077:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2075
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2074
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2072
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2073

lab2072:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2073:

lab2074:
    jmp lab2076

lab2075:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2076:

lab2078:
    ; #load tag
    mov r9, 0
    ; substitute (x6 := x6)(trees := trees)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Rose
    ; #there is only one clause, so we can jump there directly
    jmp r9

Player_2046_O:
    ; substitute (scores := scores)(board := board)(trees := trees)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    ; create a3: _Cont = (board, trees, a0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r11
    mov [rbx + 48], r10
    mov [rbx + 40], r9
    mov [rbx + 32], r8
    mov [rbx + 24], rdi
    mov [rbx + 16], rsi
    ; ##acquire free block from heap register
    mov rsi, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2090
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2091

lab2090:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2088
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2087
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2085
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2086

lab2085:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2086:

lab2087:
    jmp lab2089

lab2088:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2089:

lab2091:
    ; #load tag
    lea rdi, [rel _Cont_2092]
    ; jump listmin_
    jmp listmin_

_Cont_2092:

_Cont_2092_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab2096
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab2093
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2093:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab2094
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2094:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab2095
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2095:
    jmp lab2097

lab2096:
    ; ##... or release blocks onto linear free list when loading
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

lab2097:
    ; substitute (a0 := a0)(trees := trees)(board := board)(x7 := x7);
    ; #move variables
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    mov rax, r10
    ; let x8: Pair[List[Option[Player]], i64] = Tup(board, x7);
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
    je lab2109
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2110

lab2109:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2107
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2100
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2098
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2099

lab2098:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2099:

lab2100:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2103
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2101
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2102

lab2101:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2102:

lab2103:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2106
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2104
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2105

lab2104:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2105:

lab2106:
    jmp lab2108

lab2107:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2108:

lab2110:
    ; #load tag
    mov r9, 0
    ; substitute (x8 := x8)(trees := trees)(a0 := a0);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; invoke a0 Rose
    ; #there is only one clause, so we can jump there directly
    jmp r9

main_loop_:
    ; let x0: Player = X();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; create a3: List[Option[Player]] = (iters, a0, x0)\{ ... \};
    ; #allocate memory
    ; ##store values
    mov [rbx + 56], r9
    mov [rbx + 48], r8
    mov [rbx + 40], rdi
    mov [rbx + 32], rsi
    mov [rbx + 24], rdx
    mov qword [rbx + 16], 0
    ; ##acquire free block from heap register
    mov rax, rbx
    ; ##get next free block into heap register
    ; ###(1) check linear free list for next block
    mov rbx, [rbx + 0]
    cmp rbx, 0
    je lab2122
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab2123

lab2122:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2120
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2113
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2111
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2112

lab2111:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2112:

lab2113:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2116
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2114
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2115

lab2114:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2115:

lab2116:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2119
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2117
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2118

lab2117:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2118:

lab2119:
    jmp lab2121

lab2120:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2121:

lab2123:
    ; #load tag
    lea rdx, [rel List_Option_Player_2124]
    ; jump empty_
    jmp empty_

List_Option_Player_2124:
    jmp near List_Option_Player_2124_Nil
    jmp near List_Option_Player_2124_Cons

List_Option_Player_2124_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab2127
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab2125
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2125:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab2126
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2126:
    mov rdx, [rax + 24]
    jmp lab2128

lab2127:
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

lab2128:
    ; let x1: List[Option[Player]] = Nil();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(iters := iters)(x0 := x0)(x1 := x1);
    ; #move variables
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, rsi
    ; jump lift_main_loop_0_
    jmp lift_main_loop_0_

List_Option_Player_2124_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2131
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab2129
    ; ####increment refcount
    add qword [r12 + 0], 1

lab2129:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab2130
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2130:
    mov r9, [r8 + 24]
    jmp lab2132

lab2131:
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

lab2132:
    ; substitute (x0 := x0)(a0 := a0)(iters := iters)(a7 := a7)(as1 := as1);
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
    ; let x1: List[Option[Player]] = Cons(a7, as1);
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
    ; substitute (a0 := a0)(iters := iters)(x0 := x0)(x1 := x1);
    ; #move variables
    mov r8, rax
    mov rcx, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, rsi
    ; jump lift_main_loop_0_
    jmp lift_main_loop_0_

lift_main_loop_0_:
    ; substitute (x1 := x1)(x0 := x0)(iters := iters)(a0 := a0);
    ; #move variables
    mov rcx, r10
    mov r10, rax
    mov rax, rcx
    mov rcx, r11
    mov r11, rdx
    mov rdx, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    mov rsi, r8
    ; create a4: RoseTree[Pair[List[Option[Player]], i64]] = (iters, a0)\{ ... \};
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
    lea r9, [rel RoseTree_Pair_List_Option_Player_i64_2159]
    ; substitute (x0 := x0)(x1 := x1)(a4 := a4);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump minimax_
    jmp minimax_

RoseTree_Pair_List_Option_Player_i64_2159:

RoseTree_Pair_List_Option_Player_i64_2159_Rose:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2161
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab2160
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2160:
    mov r9, [r8 + 40]
    jmp lab2162

lab2161:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab2162:
    ; substitute (a0 := a0)(iters := iters)(a6 := a6)(as0 := as0);
    ; #move variables
    mov r8, rax
    mov rcx, r11
    mov r11, rdi
    mov rdi, r9
    mov r9, rdx
    mov rdx, rcx
    mov rax, r10
    mov r10, rsi
    ; let res: RoseTree[Pair[List[Option[Player]], i64]] = Rose(a6, as0);
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
    je lab2174
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2175

lab2174:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2172
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2165
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2163
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2164

lab2163:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2164:

lab2165:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2168
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2166
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2167

lab2166:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2167:

lab2168:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2171
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2169
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2170

lab2169:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2170:

lab2171:
    jmp lab2173

lab2172:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2173:

lab2175:
    ; #load tag
    mov r9, 0
    ; lit x2 <- 1;
    mov r11, 1
    ; if iters == x2 \{ ... \}
    cmp rdi, r11
    je lab2176
    ; else branch
    ; substitute (a0 := a0)(iters := iters);
    ; #erase res
    cmp r8, 0
    je lab2179
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab2177
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab2178

lab2177:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab2178:

lab2179:
    ; lit x5 <- 1;
    mov r9, 1
    ; x6 <- iters - x5;
    mov r11, rdi
    sub r11, r9
    ; substitute (x6 := x6)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rdi, rdx
    mov rdx, r11
    ; jump main_loop_
    jmp main_loop_

lab2176:
    ; then branch
    ; substitute (res := res)(a0 := a0);
    ; #move variables
    mov rsi, rax
    mov rdi, rdx
    mov rax, r8
    mov rdx, r9
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
    lea rdi, [rel _Cont_2193]
    ; create a2: Pair[List[Option[Player]], i64] = (a1)\{ ... \};
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
    je lab2205
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2206

lab2205:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2203
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2196
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2194
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2195

lab2194:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2195:

lab2196:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2199
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2197
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2198

lab2197:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2198:

lab2199:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2202
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2200
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2201

lab2200:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2201:

lab2202:
    jmp lab2204

lab2203:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2204:

lab2206:
    ; #load tag
    lea rdi, [rel Pair_List_Option_Player_i64_2207]
    ; jump top_
    jmp top_

Pair_List_Option_Player_i64_2207:

Pair_List_Option_Player_i64_2207_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2209
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab2208
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2208:
    jmp lab2210

lab2209:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab2210:
    ; substitute (a1 := a1)(a5 := a5)(b0 := b0);
    ; #move variables
    mov rsi, rax
    mov rcx, r9
    mov r9, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, r8
    ; let x4: Pair[List[Option[Player]], i64] = Tup(a5, b0);
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
    je lab2222
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
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
    mov rdi, 0
    ; substitute (x4 := x4)(a1 := a1);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump snd_
    jmp snd_

_Cont_2193:

_Cont_2193_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab2225
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab2224
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2224:
    jmp lab2226

lab2225:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab2226:
    ; println_i64 x3;
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
    ; lit x7 <- 0;
    mov rdi, 0
    ; substitute (x7 := x7)(a0 := a0);
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