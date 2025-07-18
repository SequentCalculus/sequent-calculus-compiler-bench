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
    lea rcx, [rel Bool_25]
    add rcx, r9
    jmp rcx

Bool_25:
    jmp near Bool_25_True
    jmp near Bool_25_False

Bool_25_True:
    ; switch b2 \{ ... \};
    lea rcx, [rel Bool_26]
    add rcx, rdi
    jmp rcx

Bool_26:
    jmp near Bool_26_True
    jmp near Bool_26_False

Bool_26_True:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_26_False:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Bool_25_False:
    ; substitute (a0 := a0);
    ; #erase b2
    cmp rsi, 0
    je lab29
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab27
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab28

lab27:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab28:

lab29:
    ; invoke a0 False
    add rdx, 5
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
    lea rcx, [rel Bool_30]
    add rcx, r9
    jmp rcx

Bool_30:
    jmp near Bool_30_True
    jmp near Bool_30_False

Bool_30_True:
    ; substitute (a0 := a0);
    ; #erase b2
    cmp rsi, 0
    je lab33
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab31
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab32

lab31:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab32:

lab33:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_30_False:
    ; switch b2 \{ ... \};
    lea rcx, [rel Bool_34]
    add rcx, rdi
    jmp rcx

Bool_34:
    jmp near Bool_34_True
    jmp near Bool_34_False

Bool_34_True:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_34_False:
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
    lea rcx, [rel Bool_35]
    add rcx, rdi
    jmp rcx

Bool_35:
    jmp near Bool_35_True
    jmp near Bool_35_False

Bool_35_True:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Bool_35_False:
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
    lea rcx, [rel Option_Player_36]
    add rcx, rdi
    jmp rcx

Option_Player_36:
    jmp near Option_Player_36_None
    jmp near Option_Player_36_Some

Option_Player_36_None:
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Option_Player_36_Some:
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
    ; substitute (a0 := a0);
    ; #erase p0
    cmp rsi, 0
    je lab42
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab40
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab41

lab40:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab41:

lab42:
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
    lea rcx, [rel List_Option_Player_43]
    add rcx, rdi
    jmp rcx

List_Option_Player_43:
    jmp near List_Option_Player_43_Nil
    jmp near List_Option_Player_43_Cons

List_Option_Player_43_Nil:
    ; invoke a0 None
    add rdx, 0
    jmp rdx

List_Option_Player_43_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab46
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab44
    ; ####increment refcount
    add qword [r8 + 0], 1

lab44:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab45
    ; ####increment refcount
    add qword [rsi + 0], 1

lab45:
    jmp lab47

lab46:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab47:
    ; substitute (a0 := a0)(p := p);
    ; #erase ps
    cmp r8, 0
    je lab50
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab48
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab49

lab48:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab49:

lab50:
    ; switch p \{ ... \};
    lea rcx, [rel Option_Player_51]
    add rcx, rdi
    jmp rcx

Option_Player_51:
    jmp near Option_Player_51_None
    jmp near Option_Player_51_Some

Option_Player_51_None:
    ; invoke a0 None
    add rdx, 0
    jmp rdx

Option_Player_51_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab53
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab52
    ; ####increment refcount
    add qword [rsi + 0], 1

lab52:
    jmp lab54

lab53:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab54:
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
    lea rcx, [rel List_Option_Player_55]
    add rcx, rdi
    jmp rcx

List_Option_Player_55:
    jmp near List_Option_Player_55_Nil
    jmp near List_Option_Player_55_Cons

List_Option_Player_55_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Option_Player_55_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab58
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab56
    ; ####increment refcount
    add qword [r8 + 0], 1

lab56:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab57
    ; ####increment refcount
    add qword [rsi + 0], 1

lab57:
    jmp lab59

lab58:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab59:
    ; substitute (a0 := a0)(ps := ps);
    ; #erase p
    cmp rsi, 0
    je lab62
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab60
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab61

lab60:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab61:

lab62:
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; switch ps \{ ... \};
    lea rcx, [rel List_Option_Player_63]
    add rcx, rdi
    jmp rcx

List_Option_Player_63:
    jmp near List_Option_Player_63_Nil
    jmp near List_Option_Player_63_Cons

List_Option_Player_63_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_Option_Player_63_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab66
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab64
    ; ####increment refcount
    add qword [r8 + 0], 1

lab64:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab65
    ; ####increment refcount
    add qword [rsi + 0], 1

lab65:
    jmp lab67

lab66:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab67:
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
    lea rcx, [rel List_i64_68]
    add rcx, r9
    jmp rcx

List_i64_68:
    jmp near List_i64_68_Nil
    jmp near List_i64_68_Cons

List_i64_68_Nil:
    ; switch acc \{ ... \};
    lea rcx, [rel List_i64_69]
    add rcx, rdi
    jmp rcx

List_i64_69:
    jmp near List_i64_69_Nil
    jmp near List_i64_69_Cons

List_i64_69_Nil:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_i64_69_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab71
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab70
    ; ####increment refcount
    add qword [r8 + 0], 1

lab70:
    mov rdi, [rsi + 40]
    jmp lab72

lab71:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]

lab72:
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

List_i64_68_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab74
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab73
    ; ####increment refcount
    add qword [r10 + 0], 1

lab73:
    mov r9, [r8 + 40]
    jmp lab75

lab74:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab75:
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
    je lab87
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab88

lab87:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab85
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab86

lab85:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab86:

lab88:
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
    lea rcx, [rel List_i64_89]
    add rcx, r9
    jmp rcx

List_i64_89:
    jmp near List_i64_89_Nil
    jmp near List_i64_89_Cons

List_i64_89_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab92
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab90
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab91

lab90:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab91:

lab92:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_i64_89_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab94
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab93
    ; ####increment refcount
    add qword [r10 + 0], 1

lab93:
    mov r9, [r8 + 40]
    jmp lab95

lab94:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab95:
    ; substitute (x := x)(f0 := f)(f := f)(xs := xs)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab96
    ; ####increment refcount
    add qword [rsi + 0], 1

lab96:
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
    je lab108
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab109

lab108:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab106
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab99
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab97
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab98

lab97:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab98:

lab99:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab107

lab106:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab107:

lab109:
    ; #load tag
    lea r9, [rel List_Option_Player_110]
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

List_Option_Player_110:
    jmp near List_Option_Player_110_Nil
    jmp near List_Option_Player_110_Cons

List_Option_Player_110_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab114
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab111
    ; ####increment refcount
    add qword [r8 + 0], 1

lab111:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab112
    ; ####increment refcount
    add qword [rsi + 0], 1

lab112:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab113
    ; ####increment refcount
    add qword [rax + 0], 1

lab113:
    jmp lab115

lab114:
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

lab115:
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

List_Option_Player_110_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab119
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab116
    ; ####increment refcount
    add qword [r12 + 0], 1

lab116:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab117
    ; ####increment refcount
    add qword [r10 + 0], 1

lab117:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab118
    ; ####increment refcount
    add qword [r8 + 0], 1

lab118:
    jmp lab120

lab119:
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

lab120:
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
    je lab145
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab146

lab145:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab143
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab144

lab143:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab144:

lab146:
    ; #load tag
    lea r9, [rel List_List_Option_Player_147]
    ; jump map_i_board_
    jmp map_i_board_

List_List_Option_Player_147:
    jmp near List_List_Option_Player_147_Nil
    jmp near List_List_Option_Player_147_Cons

List_List_Option_Player_147_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab150
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab148
    ; ####increment refcount
    add qword [rsi + 0], 1

lab148:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab149
    ; ####increment refcount
    add qword [rax + 0], 1

lab149:
    jmp lab151

lab150:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab151:
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

List_List_Option_Player_147_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab154
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab152
    ; ####increment refcount
    add qword [r10 + 0], 1

lab152:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab153
    ; ####increment refcount
    add qword [r8 + 0], 1

lab153:
    jmp lab155

lab154:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab155:
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
    je lab167
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab168

lab167:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab165
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab158
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab156
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab157

lab156:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab157:

lab158:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab161
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab159
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab160

lab159:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab160:

lab161:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab166

lab165:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab166:

lab168:
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
    lea rcx, [rel List_List_Option_Player_169]
    add rcx, r9
    jmp rcx

List_List_Option_Player_169:
    jmp near List_List_Option_Player_169_Nil
    jmp near List_List_Option_Player_169_Cons

List_List_Option_Player_169_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab172
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab170
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab171

lab170:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab171:

lab172:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_List_Option_Player_169_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab175
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab173
    ; ####increment refcount
    add qword [r10 + 0], 1

lab173:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab174
    ; ####increment refcount
    add qword [r8 + 0], 1

lab174:
    jmp lab176

lab175:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab176:
    ; substitute (x := x)(f0 := f)(f := f)(xs := xs)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab177
    ; ####increment refcount
    add qword [rsi + 0], 1

lab177:
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
    je lab189
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab190

lab189:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab187
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab180
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab178
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab179

lab178:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab179:

lab180:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab183
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab181
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab182

lab181:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab182:

lab183:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab186
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab184
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab185

lab184:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab185:

lab186:
    jmp lab188

lab187:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab188:

lab190:
    ; #load tag
    lea r9, [rel RoseTree_Pair_List_Option_Player_i64_191]
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

RoseTree_Pair_List_Option_Player_i64_191:

RoseTree_Pair_List_Option_Player_i64_191_Rose:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab195
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab192
    ; ####increment refcount
    add qword [r12 + 0], 1

lab192:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab193
    ; ####increment refcount
    add qword [r10 + 0], 1

lab193:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab194
    ; ####increment refcount
    add qword [r8 + 0], 1

lab194:
    jmp lab196

lab195:
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

lab196:
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
    je lab208
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab209

lab208:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab206
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab199
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab197
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab198

lab197:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab198:

lab199:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab207

lab206:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab207:

lab209:
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
    je lab221
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab222

lab221:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab219
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab218
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab216
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab217

lab216:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab217:

lab218:
    jmp lab220

lab219:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab220:

lab222:
    ; #load tag
    lea r9, [rel List_RoseTree_Pair_List_Option_Player_i64_223]
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

List_RoseTree_Pair_List_Option_Player_i64_223:
    jmp near List_RoseTree_Pair_List_Option_Player_i64_223_Nil
    jmp near List_RoseTree_Pair_List_Option_Player_i64_223_Cons

List_RoseTree_Pair_List_Option_Player_i64_223_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab226
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab224
    ; ####increment refcount
    add qword [rsi + 0], 1

lab224:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab225
    ; ####increment refcount
    add qword [rax + 0], 1

lab225:
    jmp lab227

lab226:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab227:
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

List_RoseTree_Pair_List_Option_Player_i64_223_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab230
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab228
    ; ####increment refcount
    add qword [r10 + 0], 1

lab228:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab229
    ; ####increment refcount
    add qword [r8 + 0], 1

lab229:
    jmp lab231

lab230:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab231:
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
    je lab243
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab244

lab243:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab241
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab234
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab232
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab233

lab232:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab233:

lab234:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab237
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab235
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab236

lab235:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab236:

lab237:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab240
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab238
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab239

lab238:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab239:

lab240:
    jmp lab242

lab241:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab242:

lab244:
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
    lea rcx, [rel List_RoseTree_Pair_List_Option_Player_i64_245]
    add rcx, r9
    jmp rcx

List_RoseTree_Pair_List_Option_Player_i64_245:
    jmp near List_RoseTree_Pair_List_Option_Player_i64_245_Nil
    jmp near List_RoseTree_Pair_List_Option_Player_i64_245_Cons

List_RoseTree_Pair_List_Option_Player_i64_245_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab248
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab246
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab247

lab246:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab247:

lab248:
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

List_RoseTree_Pair_List_Option_Player_i64_245_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab251
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab249
    ; ####increment refcount
    add qword [r10 + 0], 1

lab249:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab250
    ; ####increment refcount
    add qword [r8 + 0], 1

lab250:
    jmp lab252

lab251:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab252:
    ; substitute (x := x)(f0 := f)(f := f)(xs := xs)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab253
    ; ####increment refcount
    add qword [rsi + 0], 1

lab253:
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
    je lab265
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab266

lab265:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab263
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab256
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab254
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab255

lab254:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab255:

lab256:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab259
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab257
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab258

lab257:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab258:

lab259:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab262
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab260
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab261

lab260:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab261:

lab262:
    jmp lab264

lab263:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab264:

lab266:
    ; #load tag
    lea r9, [rel _Cont_267]
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

_Cont_267:

_Cont_267_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab271
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab268
    ; ####increment refcount
    add qword [r10 + 0], 1

lab268:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab269
    ; ####increment refcount
    add qword [r8 + 0], 1

lab269:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab270
    ; ####increment refcount
    add qword [rsi + 0], 1

lab270:
    jmp lab272

lab271:
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

lab272:
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
    je lab284
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab285

lab284:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab282
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab275
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab273
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab274

lab273:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab274:

lab275:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab278
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab276
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab277

lab276:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab277:

lab278:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab281
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab279
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab280

lab279:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab280:

lab281:
    jmp lab283

lab282:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab283:

lab285:
    ; #load tag
    lea r9, [rel List_i64_286]
    ; jump map_tree_i_
    jmp map_tree_i_

List_i64_286:
    jmp near List_i64_286_Nil
    jmp near List_i64_286_Cons

List_i64_286_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab288
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab287
    ; ####increment refcount
    add qword [rsi + 0], 1

lab287:
    mov rdx, [rax + 40]
    jmp lab289

lab288:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]

lab289:
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

List_i64_286_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab291
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab290
    ; ####increment refcount
    add qword [r10 + 0], 1

lab290:
    mov r9, [r8 + 40]
    jmp lab292

lab291:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab292:
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
    je lab304
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab305

lab304:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab302
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab295
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab293
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab294

lab293:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab294:

lab295:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab298
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab296
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab297

lab296:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab297:

lab298:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab301
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab299
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab300

lab299:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab300:

lab301:
    jmp lab303

lab302:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab303:

lab305:
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
    je lab306
    ; else branch
    ; substitute (f0 := f)(len := len)(f := f)(a0 := a0)(n := n);
    ; #share f
    cmp r8, 0
    je lab307
    ; ####increment refcount
    add qword [r8 + 0], 1

lab307:
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
    je lab319
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab320

lab319:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab317
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab318

lab317:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab318:

lab320:
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
    je lab332
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab333

lab332:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab330
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab329
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab327
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab328

lab327:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab328:

lab329:
    jmp lab331

lab330:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab331:

lab333:
    ; #load tag
    lea rdi, [rel Option_Player_334]
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

Option_Player_334:
    jmp near Option_Player_334_None
    jmp near Option_Player_334_Some

Option_Player_334_None:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab337
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
    je lab335
    ; ####increment refcount
    add qword [r8 + 0], 1

lab335:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab336
    ; ####increment refcount
    add qword [rsi + 0], 1

lab336:
    jmp lab338

lab337:
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

lab338:
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

Option_Player_334_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab341
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
    je lab339
    ; ####increment refcount
    add qword [r10 + 0], 1

lab339:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab340
    ; ####increment refcount
    add qword [r8 + 0], 1

lab340:
    jmp lab342

lab341:
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

lab342:
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
    je lab354
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab355

lab354:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab352
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab353

lab352:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab353:

lab355:
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

lab306:
    ; then branch
    ; substitute (a0 := a0);
    ; #erase f
    cmp r8, 0
    je lab358
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab356
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab357

lab356:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab357:

lab358:
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
    je lab370
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab371

lab370:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab368
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab364
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab362
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab363

lab362:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab363:

lab364:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab367
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab365
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab366

lab365:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab366:

lab367:
    jmp lab369

lab368:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab369:

lab371:
    ; #load tag
    lea r11, [rel List_Option_Player_372]
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

List_Option_Player_372:
    jmp near List_Option_Player_372_Nil
    jmp near List_Option_Player_372_Cons

List_Option_Player_372_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab375
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab373
    ; ####increment refcount
    add qword [rsi + 0], 1

lab373:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab374
    ; ####increment refcount
    add qword [rax + 0], 1

lab374:
    jmp lab376

lab375:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab376:
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

List_Option_Player_372_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab379
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab377
    ; ####increment refcount
    add qword [r10 + 0], 1

lab377:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab378
    ; ####increment refcount
    add qword [r8 + 0], 1

lab378:
    jmp lab380

lab379:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab380:
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
    je lab392
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab393

lab392:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab390
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab389
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab387
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab388

lab387:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab388:

lab389:
    jmp lab391

lab390:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab391:

lab393:
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
    jl lab394
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

lab394:
    ; then branch
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab397
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab395
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab396

lab395:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab396:

lab397:
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
    lea rcx, [rel List_i64_398]
    add rcx, r9
    jmp rcx

List_i64_398:
    jmp near List_i64_398_Nil
    jmp near List_i64_398_Cons

List_i64_398_Nil:
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

List_i64_398_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab400
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
    jmp lab401

lab400:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab401:
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
    je lab413
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab414

lab413:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab411
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab412

lab411:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab412:

lab414:
    ; #load tag
    lea r9, [rel List_i64_415]
    ; jump push_
    jmp push_

List_i64_415:
    jmp near List_i64_415_Nil
    jmp near List_i64_415_Cons

List_i64_415_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab417
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab416
    ; ####increment refcount
    add qword [rsi + 0], 1

lab416:
    mov rdx, [rax + 40]
    jmp lab418

lab417:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]

lab418:
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

List_i64_415_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab420
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab419
    ; ####increment refcount
    add qword [r10 + 0], 1

lab419:
    mov r9, [r8 + 40]
    jmp lab421

lab420:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab421:
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
    je lab433
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab434

lab433:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab431
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab424
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab422
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab423

lab422:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab423:

lab424:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab427
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab425
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab426

lab425:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab426:

lab427:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab432

lab431:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab432:

lab434:
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
    lea rcx, [rel List_Option_Player_435]
    add rcx, r9
    jmp rcx

List_Option_Player_435:
    jmp near List_Option_Player_435_Nil
    jmp near List_Option_Player_435_Cons

List_Option_Player_435_Nil:
    ; substitute (a0 := a0);
    ; invoke a0 None
    add rdx, 0
    jmp rdx

List_Option_Player_435_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab438
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab436
    ; ####increment refcount
    add qword [r10 + 0], 1

lab436:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab437
    ; ####increment refcount
    add qword [r8 + 0], 1

lab437:
    jmp lab439

lab438:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab439:
    ; if i == 0 \{ ... \}
    cmp rdi, 0
    je lab440
    ; else branch
    ; substitute (a0 := a0)(i := i)(ps := ps);
    ; #erase p
    cmp r8, 0
    je lab443
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab441
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab442

lab441:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab442:

lab443:
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

lab440:
    ; then branch
    ; substitute (a0 := a0)(p := p);
    ; #erase ps
    cmp r10, 0
    je lab446
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab444
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab445

lab444:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab445:

lab446:
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; switch p \{ ... \};
    lea rcx, [rel Option_Player_447]
    add rcx, rdi
    jmp rcx

Option_Player_447:
    jmp near Option_Player_447_None
    jmp near Option_Player_447_Some

Option_Player_447_None:
    ; invoke a0 None
    add rdx, 0
    jmp rdx

Option_Player_447_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab449
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab448
    ; ####increment refcount
    add qword [rsi + 0], 1

lab448:
    jmp lab450

lab449:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab450:
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
    lea rcx, [rel List_Option_Player_451]
    add rcx, r9
    jmp rcx

List_Option_Player_451:
    jmp near List_Option_Player_451_Nil
    jmp near List_Option_Player_451_Cons

List_Option_Player_451_Nil:
    ; substitute (a0 := a0);
    ; invoke a0 None
    add rdx, 0
    jmp rdx

List_Option_Player_451_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab454
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab452
    ; ####increment refcount
    add qword [r10 + 0], 1

lab452:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab453
    ; ####increment refcount
    add qword [r8 + 0], 1

lab453:
    jmp lab455

lab454:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab455:
    ; if i == 0 \{ ... \}
    cmp rdi, 0
    je lab456
    ; else branch
    ; substitute (a0 := a0)(i := i)(ps := ps);
    ; #erase p
    cmp r8, 0
    je lab459
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab457
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab458

lab457:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab458:

lab459:
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

lab456:
    ; then branch
    ; substitute (a0 := a0)(p := p);
    ; #erase ps
    cmp r10, 0
    je lab462
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab460
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab461

lab460:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab461:

lab462:
    ; #move variables
    mov rsi, r8
    mov rdi, r9
    ; switch p \{ ... \};
    lea rcx, [rel Option_Player_463]
    add rcx, rdi
    jmp rcx

Option_Player_463:
    jmp near Option_Player_463_None
    jmp near Option_Player_463_Some

Option_Player_463_None:
    ; invoke a0 None
    add rdx, 0
    jmp rdx

Option_Player_463_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab465
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab464
    ; ####increment refcount
    add qword [rsi + 0], 1

lab464:
    jmp lab466

lab465:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab466:
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
    lea rcx, [rel List_List_i64_467]
    add rcx, r9
    jmp rcx

List_List_i64_467:
    jmp near List_List_i64_467_Nil
    jmp near List_List_i64_467_Cons

List_List_i64_467_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rax, 0
    je lab470
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab468
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab469

lab468:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab469:

lab470:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 False
    add rdx, 5
    jmp rdx

List_List_i64_467_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab473
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab471
    ; ####increment refcount
    add qword [r10 + 0], 1

lab471:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab472
    ; ####increment refcount
    add qword [r8 + 0], 1

lab472:
    jmp lab474

lab473:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab474:
    ; substitute (f0 := f)(is := is)(a0 := a0)(iss := iss)(f := f);
    ; #share f
    cmp rax, 0
    je lab475
    ; ####increment refcount
    add qword [rax + 0], 1

lab475:
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
    je lab487
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab488

lab487:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab485
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab478
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab476
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab477

lab476:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab477:

lab478:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab481
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab479
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab480

lab479:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab480:

lab481:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab486

lab485:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab486:

lab488:
    ; #load tag
    lea r9, [rel Bool_489]
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

Bool_489:
    jmp near Bool_489_True
    jmp near Bool_489_False

Bool_489_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab493
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab490
    ; ####increment refcount
    add qword [r8 + 0], 1

lab490:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab491
    ; ####increment refcount
    add qword [rsi + 0], 1

lab491:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab492
    ; ####increment refcount
    add qword [rax + 0], 1

lab492:
    jmp lab494

lab493:
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

lab494:
    ; substitute (a0 := a0);
    ; #erase f
    cmp r8, 0
    je lab497
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab495
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab496

lab495:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab496:

lab497:
    ; #erase iss
    cmp rsi, 0
    je lab500
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab498
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab499

lab498:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab499:

lab500:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

Bool_489_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab504
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab501
    ; ####increment refcount
    add qword [r8 + 0], 1

lab501:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab502
    ; ####increment refcount
    add qword [rsi + 0], 1

lab502:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab503
    ; ####increment refcount
    add qword [rax + 0], 1

lab503:
    jmp lab505

lab504:
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

lab505:
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
    lea rcx, [rel List_i64_506]
    add rcx, r9
    jmp rcx

List_i64_506:
    jmp near List_i64_506_Nil
    jmp near List_i64_506_Cons

List_i64_506_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rax, 0
    je lab509
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab507
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab508

lab507:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab508:

lab509:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 True
    add rdx, 0
    jmp rdx

List_i64_506_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab511
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab510
    ; ####increment refcount
    add qword [r10 + 0], 1

lab510:
    mov r9, [r8 + 40]
    jmp lab512

lab511:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab512:
    ; substitute (f0 := f)(i := i)(a0 := a0)(is := is)(f := f);
    ; #share f
    cmp rax, 0
    je lab513
    ; ####increment refcount
    add qword [rax + 0], 1

lab513:
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
    je lab525
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab526

lab525:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab523
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab516
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab514
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab515

lab514:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab515:

lab516:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab519
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab517
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab518

lab517:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab518:

lab519:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab524

lab523:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab524:

lab526:
    ; #load tag
    lea r9, [rel Bool_527]
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

Bool_527:
    jmp near Bool_527_True
    jmp near Bool_527_False

Bool_527_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab531
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab528
    ; ####increment refcount
    add qword [r8 + 0], 1

lab528:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab529
    ; ####increment refcount
    add qword [rsi + 0], 1

lab529:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab530
    ; ####increment refcount
    add qword [rax + 0], 1

lab530:
    jmp lab532

lab531:
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

lab532:
    ; let x0: Bool = True();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a0 := a0)(f := f)(is := is)(x0 := x0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump lift_all_i_0_
    jmp lift_all_i_0_

Bool_527_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab536
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab533
    ; ####increment refcount
    add qword [r8 + 0], 1

lab533:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab534
    ; ####increment refcount
    add qword [rsi + 0], 1

lab534:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab535
    ; ####increment refcount
    add qword [rax + 0], 1

lab535:
    jmp lab537

lab536:
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

lab537:
    ; let x0: Bool = False();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 5
    ; substitute (a0 := a0)(f := f)(is := is)(x0 := x0);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump lift_all_i_0_
    jmp lift_all_i_0_

lift_all_i_0_:
    ; substitute (is := is)(f := f)(a0 := a0)(x0 := x0);
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
    je lab549
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab550

lab549:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab547
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab543
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab541
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab542

lab541:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab542:

lab543:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab546
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab544
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab545

lab544:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab545:

lab546:
    jmp lab548

lab547:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab548:

lab550:
    ; #load tag
    lea r9, [rel Bool_551]
    ; substitute (f := f)(is := is)(a2 := a2);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump all_i_
    jmp all_i_

Bool_551:
    jmp near Bool_551_True
    jmp near Bool_551_False

Bool_551_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab554
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab552
    ; ####increment refcount
    add qword [rsi + 0], 1

lab552:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab553
    ; ####increment refcount
    add qword [rax + 0], 1

lab553:
    jmp lab555

lab554:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab555:
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

Bool_551_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab558
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab556
    ; ####increment refcount
    add qword [rsi + 0], 1

lab556:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab557
    ; ####increment refcount
    add qword [rax + 0], 1

lab557:
    jmp lab559

lab558:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab559:
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

empty_:
    ; lit x0 <- 9;
    mov rdi, 9
    ; create x1: Fun[Unit, Option[Player]] = ()\{ ... \};
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    lea r9, [rel Fun_Unit_Option_Player_560]
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

Fun_Unit_Option_Player_560:

Fun_Unit_Option_Player_560_Apply:
    ; substitute (a1 := a1);
    ; #erase u
    cmp rax, 0
    je lab563
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab561
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab562

lab561:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab562:

lab563:
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
    lea rcx, [rel List_Option_Player_564]
    add rcx, r9
    jmp rcx

List_Option_Player_564:
    jmp near List_Option_Player_564_Nil
    jmp near List_Option_Player_564_Cons

List_Option_Player_564_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rsi, 0
    je lab567
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab565
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab566

lab565:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab566:

lab567:
    ; invoke a0 True
    add rdx, 0
    jmp rdx

List_Option_Player_564_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab570
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab568
    ; ####increment refcount
    add qword [r10 + 0], 1

lab568:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab569
    ; ####increment refcount
    add qword [r8 + 0], 1

lab569:
    jmp lab571

lab570:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab571:
    ; substitute (p := p)(f0 := f)(f := f)(ps := ps)(a0 := a0);
    ; #share f
    cmp rsi, 0
    je lab572
    ; ####increment refcount
    add qword [rsi + 0], 1

lab572:
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
    je lab584
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab585

lab584:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab582
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab575
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab573
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab574

lab573:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab574:

lab575:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab578
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab576
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab577

lab576:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab577:

lab578:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab583

lab582:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab583:

lab585:
    ; #load tag
    lea r9, [rel Bool_586]
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

Bool_586:
    jmp near Bool_586_True
    jmp near Bool_586_False

Bool_586_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab590
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab587
    ; ####increment refcount
    add qword [r8 + 0], 1

lab587:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab588
    ; ####increment refcount
    add qword [rsi + 0], 1

lab588:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab589
    ; ####increment refcount
    add qword [rax + 0], 1

lab589:
    jmp lab591

lab590:
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

lab591:
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
    ; jump lift_all_board_0_
    jmp lift_all_board_0_

Bool_586_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab595
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab592
    ; ####increment refcount
    add qword [r8 + 0], 1

lab592:
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
    jmp lab596

lab595:
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

lab596:
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
    ; jump lift_all_board_0_
    jmp lift_all_board_0_

lift_all_board_0_:
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
    je lab608
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab609

lab608:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab606
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab599
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab597
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab598

lab597:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab598:

lab599:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab602
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab600
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab601

lab600:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab601:

lab602:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab605
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab603
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab604

lab603:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab604:

lab605:
    jmp lab607

lab606:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab607:

lab609:
    ; #load tag
    lea r9, [rel Bool_610]
    ; jump all_board_
    jmp all_board_

Bool_610:
    jmp near Bool_610_True
    jmp near Bool_610_False

Bool_610_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab613
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab611
    ; ####increment refcount
    add qword [rsi + 0], 1

lab611:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab612
    ; ####increment refcount
    add qword [rax + 0], 1

lab612:
    jmp lab614

lab613:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab614:
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

Bool_610_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab617
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab615
    ; ####increment refcount
    add qword [rsi + 0], 1

lab615:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab616
    ; ####increment refcount
    add qword [rax + 0], 1

lab616:
    jmp lab618

lab617:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab618:
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

is_full_:
    ; create x0: Fun[Option[Player], Bool] = ()\{ ... \};
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    lea r9, [rel Fun_Option_Player_Bool_619]
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

Fun_Option_Player_Bool_619:

Fun_Option_Player_Bool_619_Apply:
    ; jump is_some_
    jmp is_some_

is_cat_:
    ; substitute (board0 := board)(a0 := a0)(board := board);
    ; #share board
    cmp rax, 0
    je lab620
    ; ####increment refcount
    add qword [rax + 0], 1

lab620:
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
    je lab632
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
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
    lea rdi, [rel Bool_634]
    ; jump is_full_
    jmp is_full_

Bool_634:
    jmp near Bool_634_True
    jmp near Bool_634_False

Bool_634_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab637
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab635
    ; ####increment refcount
    add qword [rsi + 0], 1

lab635:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab636
    ; ####increment refcount
    add qword [rax + 0], 1

lab636:
    jmp lab638

lab637:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab638:
    ; let x0: Bool = True();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; jump lift_is_cat_0_
    jmp lift_is_cat_0_

Bool_634_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab641
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab639
    ; ####increment refcount
    add qword [rsi + 0], 1

lab639:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab640
    ; ####increment refcount
    add qword [rax + 0], 1

lab640:
    jmp lab642

lab641:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab642:
    ; let x0: Bool = False();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; jump lift_is_cat_0_
    jmp lift_is_cat_0_

lift_is_cat_0_:
    ; substitute (board := board)(a0 := a0)(x0 := x0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; create a2: Bool = (a0, x0)\{ ... \};
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
    je lab654
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab655

lab654:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab652
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab645
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab643
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab644

lab643:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab644:

lab645:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab648
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab646
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab647

lab646:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab647:

lab648:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab651
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab649
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab650

lab649:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab650:

lab651:
    jmp lab653

lab652:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab653:

lab655:
    ; #load tag
    lea rdi, [rel Bool_656]
    ; substitute (board0 := board)(a2 := a2)(board := board);
    ; #share board
    cmp rax, 0
    je lab657
    ; ####increment refcount
    add qword [rax + 0], 1

lab657:
    ; #move variables
    mov r8, rax
    mov r9, rdx
    ; create a3: Bool = (a2, board)\{ ... \};
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
    je lab669
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab670

lab669:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab667
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab660
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab658
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab659

lab658:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab659:

lab660:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab663
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab661
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab662

lab661:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab662:

lab663:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab666
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab664
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab665

lab664:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab665:

lab666:
    jmp lab668

lab667:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab668:

lab670:
    ; #load tag
    lea rdi, [rel Bool_671]
    ; create a4: Bool = (a3)\{ ... \};
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
    je lab683
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab684

lab683:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab681
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab674
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab672
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab673

lab672:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab673:

lab674:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab677
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab675
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab676

lab675:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab676:

lab677:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab680
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab678
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab679

lab678:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab679:

lab680:
    jmp lab682

lab681:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab682:

lab684:
    ; #load tag
    lea rdi, [rel Bool_685]
    ; let x4: Player = X();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (board0 := board0)(x4 := x4)(a4 := a4);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump is_win_for_
    jmp is_win_for_

Bool_685:
    jmp near Bool_685_True
    jmp near Bool_685_False

Bool_685_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab687
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab686
    ; ####increment refcount
    add qword [rax + 0], 1

lab686:
    jmp lab688

lab687:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab688:
    ; let x3: Bool = True();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; substitute (x3 := x3)(a3 := a3);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

Bool_685_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab690
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab689
    ; ####increment refcount
    add qword [rax + 0], 1

lab689:
    jmp lab691

lab690:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab691:
    ; let x3: Bool = False();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 5
    ; substitute (x3 := x3)(a3 := a3);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

Bool_671:
    jmp near Bool_671_True
    jmp near Bool_671_False

Bool_671_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab694
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab692
    ; ####increment refcount
    add qword [rsi + 0], 1

lab692:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab693
    ; ####increment refcount
    add qword [rax + 0], 1

lab693:
    jmp lab695

lab694:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab695:
    ; let x2: Bool = True();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; jump lift_is_cat_1_
    jmp lift_is_cat_1_

Bool_671_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab698
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab696
    ; ####increment refcount
    add qword [rsi + 0], 1

lab696:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab697
    ; ####increment refcount
    add qword [rax + 0], 1

lab697:
    jmp lab699

lab698:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab699:
    ; let x2: Bool = False();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; jump lift_is_cat_1_
    jmp lift_is_cat_1_

Bool_656:
    jmp near Bool_656_True
    jmp near Bool_656_False

Bool_656_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab702
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab700
    ; ####increment refcount
    add qword [rsi + 0], 1

lab700:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab701
    ; ####increment refcount
    add qword [rax + 0], 1

lab701:
    jmp lab703

lab702:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab703:
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

Bool_656_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab706
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab704
    ; ####increment refcount
    add qword [rsi + 0], 1

lab704:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab705
    ; ####increment refcount
    add qword [rax + 0], 1

lab705:
    jmp lab707

lab706:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab707:
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

lift_is_cat_1_:
    ; substitute (board := board)(a2 := a2)(x2 := x2);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; create a5: Bool = (a2, x2)\{ ... \};
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
    je lab719
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab720

lab719:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab717
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab713
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab711
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab712

lab711:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab712:

lab713:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab716
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab714
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab715

lab714:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab715:

lab716:
    jmp lab718

lab717:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab718:

lab720:
    ; #load tag
    lea rdi, [rel Bool_721]
    ; create a6: Bool = (a5)\{ ... \};
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
    je lab733
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab734

lab733:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab731
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab724
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab722
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab723

lab722:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab723:

lab724:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab727
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab725
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab726

lab725:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab726:

lab727:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab730
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab728
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab729

lab728:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab729:

lab730:
    jmp lab732

lab731:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab732:

lab734:
    ; #load tag
    lea rdi, [rel Bool_735]
    ; let x7: Player = O();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (board := board)(x7 := x7)(a6 := a6);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump is_win_for_
    jmp is_win_for_

Bool_735:
    jmp near Bool_735_True
    jmp near Bool_735_False

Bool_735_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab737
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab736
    ; ####increment refcount
    add qword [rax + 0], 1

lab736:
    jmp lab738

lab737:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab738:
    ; let x6: Bool = True();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 0
    ; substitute (x6 := x6)(a5 := a5);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

Bool_735_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab740
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab739
    ; ####increment refcount
    add qword [rax + 0], 1

lab739:
    jmp lab741

lab740:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab741:
    ; let x6: Bool = False();
    ; #mark no allocation
    mov rsi, 0
    ; #load tag
    mov rdi, 5
    ; substitute (x6 := x6)(a5 := a5);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump not_
    jmp not_

Bool_721:
    jmp near Bool_721_True
    jmp near Bool_721_False

Bool_721_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab744
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab742
    ; ####increment refcount
    add qword [rsi + 0], 1

lab742:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab743
    ; ####increment refcount
    add qword [rax + 0], 1

lab743:
    jmp lab745

lab744:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab745:
    ; let x5: Bool = True();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x2 := x2)(x5 := x5)(a2 := a2);
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

Bool_721_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab748
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab746
    ; ####increment refcount
    add qword [rsi + 0], 1

lab746:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab747
    ; ####increment refcount
    add qword [rax + 0], 1

lab747:
    jmp lab749

lab748:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab749:
    ; let x5: Bool = False();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (x2 := x2)(x5 := x5)(a2 := a2);
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
    lea rcx, [rel List_i64_750]
    add rcx, r11
    jmp rcx

List_i64_750:
    jmp near List_i64_750_Nil
    jmp near List_i64_750_Cons

List_i64_750_Nil:
    ; substitute (start := start)(a0 := a0);
    ; #erase f
    cmp rax, 0
    je lab753
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab751
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab752

lab751:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab752:

lab753:
    ; #move variables
    mov rdx, rdi
    mov rsi, r8
    mov rdi, r9
    ; invoke a0 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

List_i64_750_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab755
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab754
    ; ####increment refcount
    add qword [r12 + 0], 1

lab754:
    mov r11, [r10 + 40]
    jmp lab756

lab755:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]

lab756:
    ; substitute (f0 := f)(start := start)(i := i)(a0 := a0)(is := is)(f := f);
    ; #share f
    cmp rax, 0
    je lab757
    ; ####increment refcount
    add qword [rax + 0], 1

lab757:
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
    je lab769
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab770

lab769:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab767
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab760
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab758
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab759

lab758:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab759:

lab760:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab763
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab761
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab762

lab761:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab762:

lab763:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab766
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab764
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab765

lab764:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab765:

lab766:
    jmp lab768

lab767:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab768:

lab770:
    ; #load tag
    lea r11, [rel _Cont_771]
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

_Cont_771:

_Cont_771_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab775
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab772
    ; ####increment refcount
    add qword [r10 + 0], 1

lab772:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab773
    ; ####increment refcount
    add qword [r8 + 0], 1

lab773:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab774
    ; ####increment refcount
    add qword [rsi + 0], 1

lab774:
    jmp lab776

lab775:
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

lab776:
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
    lea rcx, [rel List_i64_777]
    add rcx, r9
    jmp rcx

List_i64_777:
    jmp near List_i64_777_Nil
    jmp near List_i64_777_Cons

List_i64_777_Nil:
    ; substitute (a0 := a0);
    ; #erase f
    cmp rax, 0
    je lab780
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab778
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab779

lab778:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab779:

lab780:
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

List_i64_777_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab782
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab781
    ; ####increment refcount
    add qword [r10 + 0], 1

lab781:
    mov r9, [r8 + 40]
    jmp lab783

lab782:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab783:
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
    lea r9, [rel Fun2_i64_i64_i64_784]
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

Fun2_i64_i64_i64_784:

Fun2_i64_i64_i64_784_Apply2:
    ; if b < a \{ ... \}
    cmp rdi, rdx
    jl lab785
    ; else branch
    ; substitute (b := b)(a1 := a1);
    ; #move variables
    mov rdx, rdi
    mov rsi, r8
    mov rdi, r9
    ; invoke a1 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

lab785:
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
    lea r9, [rel Fun2_i64_i64_i64_786]
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

Fun2_i64_i64_i64_786:

Fun2_i64_i64_i64_786_Apply2:
    ; if a < b \{ ... \}
    cmp rdx, rdi
    jl lab787
    ; else branch
    ; substitute (b := b)(a1 := a1);
    ; #move variables
    mov rdx, rdi
    mov rsi, r8
    mov rdi, r9
    ; invoke a1 Ret
    ; #there is only one clause, so we can jump there directly
    jmp rdi

lab787:
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
    je lab799
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
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
    je lab812
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    je lab825
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
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
    je lab838
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
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
    je lab851
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
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
    je lab864
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    je lab877
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
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
    je lab890
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
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
    je lab903
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
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
    je lab942
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
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
    je lab955
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    je lab968
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
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
    je lab981
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
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
    je lab994
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
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
    je lab1007
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    je lab1020
    ; ####initialize refcount of just acquired block
    mov qword [r14 + 0], 0
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
    je lab1033
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
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
    je lab1046
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
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
    je lab1085
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
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
    je lab1111
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1112

lab1111:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1109
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1108
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1106
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1107

lab1106:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1107:

lab1108:
    jmp lab1110

lab1109:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1110:

lab1112:
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
    je lab1124
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab1125

lab1124:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1122
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1118
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1116
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1117

lab1116:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1117:

lab1118:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1121
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1119
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1120

lab1119:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1120:

lab1121:
    jmp lab1123

lab1122:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1123:

lab1125:
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
    je lab1137
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1138

lab1137:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1135
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1131
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1129
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1130

lab1129:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1130:

lab1131:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1134
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1132
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1133

lab1132:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1133:

lab1134:
    jmp lab1136

lab1135:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1136:

lab1138:
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
    je lab1150
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1151

lab1150:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1148
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1149

lab1148:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1149:

lab1151:
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
    je lab1176
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1177

lab1176:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1174
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1167
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1165
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1166

lab1165:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1166:

lab1167:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1170
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1168
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1169

lab1168:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1169:

lab1170:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1173
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1171
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1172

lab1171:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1172:

lab1173:
    jmp lab1175

lab1174:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1175:

lab1177:
    ; #load tag
    lea r9, [rel Option_Player_1178]
    ; jump nth_
    jmp nth_

Option_Player_1178:
    jmp near Option_Player_1178_None
    jmp near Option_Player_1178_Some

Option_Player_1178_None:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1180
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1179
    ; ####increment refcount
    add qword [rax + 0], 1

lab1179:
    jmp lab1181

lab1180:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1181:
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

Option_Player_1178_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1183
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab1182
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1182:
    jmp lab1184

lab1183:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab1184:
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
    je lab1196
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1197

lab1196:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1194
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1187
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1185
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1186

lab1185:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1186:

lab1187:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1190
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1188
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1189

lab1188:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1189:

lab1190:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1193
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1191
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1192

lab1191:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1192:

lab1193:
    jmp lab1195

lab1194:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1195:

lab1197:
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
    je lab1209
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1210

lab1209:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1207
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1200
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1198
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1199

lab1198:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1199:

lab1200:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1203
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1201
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1202

lab1201:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1202:

lab1203:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1206
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1204
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1205

lab1204:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1205:

lab1206:
    jmp lab1208

lab1207:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1208:

lab1210:
    ; #load tag
    lea r9, [rel Option_Player_1211]
    ; substitute (board := board)(i := i)(a1 := a1);
    ; #move variables
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    mov rax, rsi
    ; jump find_
    jmp find_

Option_Player_1211:
    jmp near Option_Player_1211_None
    jmp near Option_Player_1211_Some

Option_Player_1211_None:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1214
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1212
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1212:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1213
    ; ####increment refcount
    add qword [rax + 0], 1

lab1213:
    jmp lab1215

lab1214:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1215:
    ; substitute (a0 := a0);
    ; #erase p
    cmp rax, 0
    je lab1218
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab1216
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab1217

lab1216:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab1217:

lab1218:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 False
    add rdx, 5
    jmp rdx

Option_Player_1211_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1221
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab1219
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1219:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab1220
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1220:
    jmp lab1222

lab1221:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab1222:
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
    je lab1234
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1235

lab1234:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1232
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1225
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1223
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1224

lab1223:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1224:

lab1225:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1228
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1226
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1227

lab1226:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1227:

lab1228:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1233

lab1232:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1233:

lab1235:
    ; #load tag
    lea r9, [rel Fun_i64_Bool_1236]
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

Fun_i64_Bool_1236:

Fun_i64_Bool_1236_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1239
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1237
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1237:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1238
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1238:
    jmp lab1240

lab1239:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1240:
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
    je lab1252
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1253

lab1252:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1250
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1243
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1241
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1242

lab1241:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1242:

lab1243:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1246
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1244
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1245

lab1244:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1245:

lab1246:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1249
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1247
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1248

lab1247:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1248:

lab1249:
    jmp lab1251

lab1250:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1251:

lab1253:
    ; #load tag
    lea rdi, [rel Fun_List_i64_Bool_1254]
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
    je lab1266
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab1267

lab1266:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1264
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1263
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1261
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1262

lab1261:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1262:

lab1263:
    jmp lab1265

lab1264:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1265:

lab1267:
    ; #load tag
    lea rdx, [rel List_List_i64_1268]
    ; jump rows_
    jmp rows_

List_List_i64_1268:
    jmp near List_List_i64_1268_Nil
    jmp near List_List_i64_1268_Cons

List_List_i64_1268_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1271
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1269
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1269:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1270
    ; ####increment refcount
    add qword [rax + 0], 1

lab1270:
    jmp lab1272

lab1271:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1272:
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

List_List_i64_1268_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1275
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1273
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1273:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1274
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1274:
    jmp lab1276

lab1275:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1276:
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
    je lab1288
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1289

lab1288:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1286
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1279
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1277
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1278

lab1277:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1278:

lab1279:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1282
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1280
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1281

lab1280:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1281:

lab1282:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1287

lab1286:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1287:

lab1289:
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

Fun_List_i64_Bool_1254:

Fun_List_i64_Bool_1254_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1292
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1290
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1290:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1291
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1291:
    jmp lab1293

lab1292:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1293:
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
    je lab1305
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1306

lab1305:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1303
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1296
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1294
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1295

lab1294:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1295:

lab1296:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1299
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1297
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1298

lab1297:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1298:

lab1299:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1304

lab1303:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1304:

lab1306:
    ; #load tag
    lea rdi, [rel Fun_List_i64_Bool_1307]
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
    je lab1319
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab1320

lab1319:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1317
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1316
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1314
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1315

lab1314:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1315:

lab1316:
    jmp lab1318

lab1317:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1318:

lab1320:
    ; #load tag
    lea rdx, [rel List_List_i64_1321]
    ; jump cols_
    jmp cols_

List_List_i64_1321:
    jmp near List_List_i64_1321_Nil
    jmp near List_List_i64_1321_Cons

List_List_i64_1321_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1324
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1322
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1322:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1323
    ; ####increment refcount
    add qword [rax + 0], 1

lab1323:
    jmp lab1325

lab1324:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1325:
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

List_List_i64_1321_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1328
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1326
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1326:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1327
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1327:
    jmp lab1329

lab1328:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1329:
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
    je lab1341
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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

Fun_List_i64_Bool_1307:

Fun_List_i64_Bool_1307_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1345
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1343
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1343:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1344
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1344:
    jmp lab1346

lab1345:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1346:
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
    je lab1358
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1359

lab1358:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1356
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1349
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1347
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1348

lab1347:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1348:

lab1349:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1352
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1350
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1351

lab1350:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1351:

lab1352:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1355
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1353
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1354

lab1353:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1354:

lab1355:
    jmp lab1357

lab1356:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1357:

lab1359:
    ; #load tag
    lea rdi, [rel Fun_List_i64_Bool_1360]
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
    je lab1372
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab1373

lab1372:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1370
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1363
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1361
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1362

lab1361:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1362:

lab1363:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1366
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1364
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1365

lab1364:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1365:

lab1366:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1369
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1367
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1368

lab1367:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1368:

lab1369:
    jmp lab1371

lab1370:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1371:

lab1373:
    ; #load tag
    lea rdx, [rel List_List_i64_1374]
    ; jump diags_
    jmp diags_

List_List_i64_1374:
    jmp near List_List_i64_1374_Nil
    jmp near List_List_i64_1374_Cons

List_List_i64_1374_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1377
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1375
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1375:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1376
    ; ####increment refcount
    add qword [rax + 0], 1

lab1376:
    jmp lab1378

lab1377:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1378:
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

List_List_i64_1374_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1381
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1379
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1379:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1380
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1380:
    jmp lab1382

lab1381:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1382:
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
    je lab1394
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1395

lab1394:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1392
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1385
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1383
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1384

lab1383:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1384:

lab1385:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1393

lab1392:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1393:

lab1395:
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

Fun_List_i64_Bool_1360:

Fun_List_i64_Bool_1360_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1398
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1396
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1396:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1397
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1397:
    jmp lab1399

lab1398:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1399:
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
    ; substitute (board0 := board)(p0 := p)(a0 := a0)(board := board)(p := p);
    ; #share board
    cmp rax, 0
    je lab1400
    ; ####increment refcount
    add qword [rax + 0], 1

lab1400:
    ; #share p
    cmp rsi, 0
    je lab1401
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1401:
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
    je lab1413
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1414

lab1413:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1411
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1404
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1402
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1403

lab1402:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1403:

lab1404:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1407
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1405
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1406

lab1405:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1406:

lab1407:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1410
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1408
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1409

lab1408:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1409:

lab1410:
    jmp lab1412

lab1411:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1412:

lab1414:
    ; #load tag
    lea r9, [rel Bool_1415]
    ; jump has_row_
    jmp has_row_

Bool_1415:
    jmp near Bool_1415_True
    jmp near Bool_1415_False

Bool_1415_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1419
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1416
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1416:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1417
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1417:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1418
    ; ####increment refcount
    add qword [rax + 0], 1

lab1418:
    jmp lab1420

lab1419:
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

lab1420:
    ; let x0: Bool = True();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; jump lift_is_win_for_0_
    jmp lift_is_win_for_0_

Bool_1415_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1424
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1421
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1421:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1422
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1422:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1423
    ; ####increment refcount
    add qword [rax + 0], 1

lab1423:
    jmp lab1425

lab1424:
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

lab1425:
    ; let x0: Bool = False();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 5
    ; jump lift_is_win_for_0_
    jmp lift_is_win_for_0_

lift_is_win_for_0_:
    ; substitute (p := p)(board := board)(a0 := a0)(x0 := x0);
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
    je lab1437
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1438

lab1437:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1435
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1428
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1426
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1427

lab1426:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1427:

lab1428:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1431
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1429
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1430

lab1429:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1430:

lab1431:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1434
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1432
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1433

lab1432:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1433:

lab1434:
    jmp lab1436

lab1435:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1436:

lab1438:
    ; #load tag
    lea r9, [rel Bool_1439]
    ; substitute (p0 := p)(board0 := board)(a2 := a2)(p := p)(board := board);
    ; #share board
    cmp rsi, 0
    je lab1440
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1440:
    ; #share p
    cmp rax, 0
    je lab1441
    ; ####increment refcount
    add qword [rax + 0], 1

lab1441:
    ; #move variables
    mov r10, rax
    mov r11, rdx
    mov r12, rsi
    mov r13, rdi
    ; create a3: Bool = (a2, p, board)\{ ... \};
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
    je lab1453
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1454

lab1453:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1451
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1450
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1448
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1449

lab1448:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1449:

lab1450:
    jmp lab1452

lab1451:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1452:

lab1454:
    ; #load tag
    lea r9, [rel Bool_1455]
    ; substitute (board0 := board0)(p0 := p0)(a3 := a3);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump has_col_
    jmp has_col_

Bool_1455:
    jmp near Bool_1455_True
    jmp near Bool_1455_False

Bool_1455_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1459
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1456
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1456:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1457
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1457:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1458
    ; ####increment refcount
    add qword [rax + 0], 1

lab1458:
    jmp lab1460

lab1459:
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

lab1460:
    ; let x2: Bool = True();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 0
    ; substitute (a2 := a2)(board := board)(p := p)(x2 := x2);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump lift_is_win_for_1_
    jmp lift_is_win_for_1_

Bool_1455_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1464
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1461
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1461:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1462
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1462:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1463
    ; ####increment refcount
    add qword [rax + 0], 1

lab1463:
    jmp lab1465

lab1464:
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

lab1465:
    ; let x2: Bool = False();
    ; #mark no allocation
    mov r10, 0
    ; #load tag
    mov r11, 5
    ; substitute (a2 := a2)(board := board)(p := p)(x2 := x2);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump lift_is_win_for_1_
    jmp lift_is_win_for_1_

Bool_1439:
    jmp near Bool_1439_True
    jmp near Bool_1439_False

Bool_1439_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1468
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1466
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1466:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1467
    ; ####increment refcount
    add qword [rax + 0], 1

lab1467:
    jmp lab1469

lab1468:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1469:
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

Bool_1439_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1472
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1470
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1470:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1471
    ; ####increment refcount
    add qword [rax + 0], 1

lab1471:
    jmp lab1473

lab1472:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1473:
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

lift_is_win_for_1_:
    ; substitute (p := p)(board := board)(a2 := a2)(x2 := x2);
    ; #move variables
    mov rcx, r8
    mov r8, rax
    mov rax, rcx
    mov rcx, r9
    mov r9, rdx
    mov rdx, rcx
    ; create a4: Bool = (a2, x2)\{ ... \};
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
    lea r9, [rel Bool_1487]
    ; substitute (board := board)(p := p)(a4 := a4);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; jump has_diag_
    jmp has_diag_

Bool_1487:
    jmp near Bool_1487_True
    jmp near Bool_1487_False

Bool_1487_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1490
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1488
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1488:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1489
    ; ####increment refcount
    add qword [rax + 0], 1

lab1489:
    jmp lab1491

lab1490:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1491:
    ; let x3: Bool = True();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (x2 := x2)(x3 := x3)(a2 := a2);
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

Bool_1487_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1494
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1492
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1492:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1493
    ; ####increment refcount
    add qword [rax + 0], 1

lab1493:
    jmp lab1495

lab1494:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1495:
    ; let x3: Bool = False();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (x2 := x2)(x3 := x3)(a2 := a2);
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

is_win_:
    ; substitute (board0 := board)(a0 := a0)(board := board);
    ; #share board
    cmp rax, 0
    je lab1496
    ; ####increment refcount
    add qword [rax + 0], 1

lab1496:
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
    je lab1508
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1509

lab1508:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1506
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1502
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1500
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1501

lab1500:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1501:

lab1502:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1505
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1503
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1504

lab1503:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1504:

lab1505:
    jmp lab1507

lab1506:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1507:

lab1509:
    ; #load tag
    lea rdi, [rel Bool_1510]
    ; let x1: Player = X();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (board0 := board0)(x1 := x1)(a1 := a1);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump is_win_for_
    jmp is_win_for_

Bool_1510:
    jmp near Bool_1510_True
    jmp near Bool_1510_False

Bool_1510_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1513
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1511
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1511:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1512
    ; ####increment refcount
    add qword [rax + 0], 1

lab1512:
    jmp lab1514

lab1513:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1514:
    ; let x0: Bool = True();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; jump lift_is_win_0_
    jmp lift_is_win_0_

Bool_1510_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1517
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1515
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1515:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1516
    ; ####increment refcount
    add qword [rax + 0], 1

lab1516:
    jmp lab1518

lab1517:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1518:
    ; let x0: Bool = False();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; jump lift_is_win_0_
    jmp lift_is_win_0_

lift_is_win_0_:
    ; substitute (board := board)(a0 := a0)(x0 := x0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; create a2: Bool = (a0, x0)\{ ... \};
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
    je lab1530
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1531

lab1530:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1528
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1521
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1519
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1520

lab1519:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1520:

lab1521:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1529

lab1528:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1529:

lab1531:
    ; #load tag
    lea rdi, [rel Bool_1532]
    ; let x3: Player = O();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; substitute (board := board)(x3 := x3)(a2 := a2);
    ; #move variables
    mov rcx, r8
    mov r8, rsi
    mov rsi, rcx
    mov rcx, r9
    mov r9, rdi
    mov rdi, rcx
    ; jump is_win_for_
    jmp is_win_for_

Bool_1532:
    jmp near Bool_1532_True
    jmp near Bool_1532_False

Bool_1532_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1535
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1533
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1533:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1534
    ; ####increment refcount
    add qword [rax + 0], 1

lab1534:
    jmp lab1536

lab1535:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1536:
    ; let x2: Bool = True();
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
    ; jump or_
    jmp or_

Bool_1532_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1539
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1537
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1537:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1538
    ; ####increment refcount
    add qword [rax + 0], 1

lab1538:
    jmp lab1540

lab1539:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1540:
    ; let x2: Bool = False();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
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
    ; jump or_
    jmp or_

game_over_:
    ; substitute (board0 := board)(a0 := a0)(board := board);
    ; #share board
    cmp rax, 0
    je lab1541
    ; ####increment refcount
    add qword [rax + 0], 1

lab1541:
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
    je lab1553
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1554

lab1553:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1551
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1544
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1542
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1543

lab1542:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1543:

lab1544:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1547
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1545
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1546

lab1545:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1546:

lab1547:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1552

lab1551:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1552:

lab1554:
    ; #load tag
    lea rdi, [rel Bool_1555]
    ; jump is_win_
    jmp is_win_

Bool_1555:
    jmp near Bool_1555_True
    jmp near Bool_1555_False

Bool_1555_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1558
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1556
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1556:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1557
    ; ####increment refcount
    add qword [rax + 0], 1

lab1557:
    jmp lab1559

lab1558:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1559:
    ; let x0: Bool = True();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; jump lift_game_over_0_
    jmp lift_game_over_0_

Bool_1555_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1562
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1560
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1560:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1561
    ; ####increment refcount
    add qword [rax + 0], 1

lab1561:
    jmp lab1563

lab1562:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1563:
    ; let x0: Bool = False();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 5
    ; jump lift_game_over_0_
    jmp lift_game_over_0_

lift_game_over_0_:
    ; substitute (board := board)(a0 := a0)(x0 := x0);
    ; #move variables
    mov rcx, rsi
    mov rsi, rax
    mov rax, rcx
    mov rcx, rdi
    mov rdi, rdx
    mov rdx, rcx
    ; create a2: Bool = (a0, x0)\{ ... \};
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
    je lab1575
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1576

lab1575:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1573
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1572
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1570
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1571

lab1570:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1571:

lab1572:
    jmp lab1574

lab1573:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1574:

lab1576:
    ; #load tag
    lea rdi, [rel Bool_1577]
    ; jump is_cat_
    jmp is_cat_

Bool_1577:
    jmp near Bool_1577_True
    jmp near Bool_1577_False

Bool_1577_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1580
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1578
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1578:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1579
    ; ####increment refcount
    add qword [rax + 0], 1

lab1579:
    jmp lab1581

lab1580:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1581:
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

Bool_1577_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1584
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1582
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1582:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1583
    ; ####increment refcount
    add qword [rax + 0], 1

lab1583:
    jmp lab1585

lab1584:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1585:
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

score_:
    ; let x0: Player = X();
    ; #mark no allocation
    mov r8, 0
    ; #load tag
    mov r9, 0
    ; substitute (board0 := board)(x0 := x0)(a0 := a0)(board := board);
    ; #share board
    cmp rax, 0
    je lab1586
    ; ####increment refcount
    add qword [rax + 0], 1

lab1586:
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
    je lab1598
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    lea r9, [rel Bool_1600]
    ; jump is_win_for_
    jmp is_win_for_

Bool_1600:
    jmp near Bool_1600_True
    jmp near Bool_1600_False

Bool_1600_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1603
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1601
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1601:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1602
    ; ####increment refcount
    add qword [rax + 0], 1

lab1602:
    jmp lab1604

lab1603:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1604:
    ; substitute (a0 := a0);
    ; #erase board
    cmp rsi, 0
    je lab1607
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab1605
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab1606

lab1605:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab1606:

lab1607:
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

Bool_1600_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1610
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1608
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1608:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1609
    ; ####increment refcount
    add qword [rax + 0], 1

lab1609:
    jmp lab1611

lab1610:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1611:
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
    je lab1623
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1624

lab1623:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1621
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1614
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1612
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1613

lab1612:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1613:

lab1614:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1617
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1615
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1616

lab1615:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1616:

lab1617:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1620
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1618
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1619

lab1618:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1619:

lab1620:
    jmp lab1622

lab1621:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1622:

lab1624:
    ; #load tag
    lea r9, [rel Bool_1625]
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

Bool_1625:
    jmp near Bool_1625_True
    jmp near Bool_1625_False

Bool_1625_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1627
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1626
    ; ####increment refcount
    add qword [rax + 0], 1

lab1626:
    jmp lab1628

lab1627:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1628:
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

Bool_1625_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1630
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]
    cmp rax, 0
    je lab1629
    ; ####increment refcount
    add qword [rax + 0], 1

lab1629:
    jmp lab1631

lab1630:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdx, [rax + 56]
    mov rax, [rax + 48]

lab1631:
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
    je lab1632
    ; else branch
    ; if i > 0 \{ ... \}
    cmp r9, 0
    jg lab1633
    ; else branch
    ; substitute (a0 := a0);
    ; #erase x
    cmp rax, 0
    je lab1636
    ; ######check refcount
    cmp qword [rax + 0], 0
    je lab1634
    ; ######either decrement refcount ...
    add qword [rax + 0], -1
    jmp lab1635

lab1634:
    ; ######... or add block to lazy free list
    mov [rax + 0], rbp
    mov rbp, rax

lab1635:

lab1636:
    ; #erase xs
    cmp rsi, 0
    je lab1639
    ; ######check refcount
    cmp qword [rsi + 0], 0
    je lab1637
    ; ######either decrement refcount ...
    add qword [rsi + 0], -1
    jmp lab1638

lab1637:
    ; ######... or add block to lazy free list
    mov [rsi + 0], rbp
    mov rbp, rsi

lab1638:

lab1639:
    ; #move variables
    mov rax, r10
    mov rdx, r11
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

lab1633:
    ; then branch
    ; substitute (xs0 := xs)(xs := xs)(i := i)(a0 := a0)(x := x);
    ; #share xs
    cmp rsi, 0
    je lab1640
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1640:
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
    je lab1652
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1653

lab1652:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1650
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1646
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1644
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1645

lab1644:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1645:

lab1646:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1651

lab1650:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1651:

lab1653:
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
    je lab1665
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1666

lab1665:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1663
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1656
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1654
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1655

lab1654:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1655:

lab1656:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1659
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1657
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1658

lab1657:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1658:

lab1659:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1664

lab1663:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1664:

lab1666:
    ; #load tag
    lea rdi, [rel Option_Player_1667]
    ; jump head_
    jmp head_

Option_Player_1667:
    jmp near Option_Player_1667_None
    jmp near Option_Player_1667_Some

Option_Player_1667_None:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1671
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1668
    ; ####increment refcount
    add qword [rax + 0], 1

lab1668:
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab1669
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1669:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab1670
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1670:
    mov rdi, [rsi + 24]
    jmp lab1672

lab1671:
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

lab1672:
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

Option_Player_1667_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1676
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load link to next block
    mov r8, [rsi + 48]
    ; ###load values
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab1673
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1673:
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab1674
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1674:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab1675
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1675:
    mov r9, [r8 + 24]
    jmp lab1677

lab1676:
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

lab1677:
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
    je lab1689
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
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

lab1632:
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
    je lab1702
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
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
    lea rdi, [rel List_Option_Player_1704]
    ; jump tail_
    jmp tail_

List_Option_Player_1704:
    jmp near List_Option_Player_1704_Nil
    jmp near List_Option_Player_1704_Cons

List_Option_Player_1704_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1707
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1705
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1705:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1706
    ; ####increment refcount
    add qword [rax + 0], 1

lab1706:
    jmp lab1708

lab1707:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1708:
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

List_Option_Player_1704_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1711
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1709
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1709:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1710
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1710:
    jmp lab1712

lab1711:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1712:
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
    je lab1724
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1725

lab1724:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1722
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1715
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1713
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1714

lab1713:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1714:

lab1715:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1718
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1716
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1717

lab1716:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1717:

lab1718:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1721
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1719
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1720

lab1719:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1720:

lab1721:
    jmp lab1723

lab1722:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1723:

lab1725:
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
    je lab1737
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1738

lab1737:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1735
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1728
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1726
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1727

lab1726:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1727:

lab1728:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1731
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1729
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1730

lab1729:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1730:

lab1731:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1734
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1732
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1733

lab1732:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1733:

lab1734:
    jmp lab1736

lab1735:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1736:

lab1738:
    ; #load tag
    lea r11, [rel List_Option_Player_1739]
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
    je lab1751
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1752

lab1751:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1749
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1742
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1740
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1741

lab1740:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1741:

lab1742:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1750

lab1749:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1750:

lab1752:
    ; #load tag
    lea rdi, [rel List_Option_Player_1753]
    ; jump tail_
    jmp tail_

List_Option_Player_1753:
    jmp near List_Option_Player_1753_Nil
    jmp near List_Option_Player_1753_Cons

List_Option_Player_1753_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1756
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1754
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1754:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1755
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1755:
    mov rdx, [rax + 24]
    jmp lab1757

lab1756:
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

lab1757:
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

List_Option_Player_1753_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1760
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab1758
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1758:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab1759
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1759:
    mov r9, [r8 + 24]
    jmp lab1761

lab1760:
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

lab1761:
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
    je lab1773
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1774

lab1773:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1771
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1767
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1765
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1766

lab1765:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1766:

lab1767:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1772

lab1771:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1772:

lab1774:
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

List_Option_Player_1739:
    jmp near List_Option_Player_1739_Nil
    jmp near List_Option_Player_1739_Cons

List_Option_Player_1739_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1777
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab1775
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1775:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab1776
    ; ####increment refcount
    add qword [rax + 0], 1

lab1776:
    jmp lab1778

lab1777:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab1778:
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

List_Option_Player_1739_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1781
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1779
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1779:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1780
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1780:
    jmp lab1782

lab1781:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1782:
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
    je lab1794
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1795

lab1794:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1792
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1788
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1786
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1787

lab1786:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1787:

lab1788:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1791
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1789
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1790

lab1789:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1790:

lab1791:
    jmp lab1793

lab1792:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1793:

lab1795:
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
    je lab1796
    ; ####increment refcount
    add qword [rax + 0], 1

lab1796:
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
    je lab1808
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1809

lab1808:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1806
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1799
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1797
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1798

lab1797:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1798:

lab1799:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1802
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1800
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1801

lab1800:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1801:

lab1802:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1807

lab1806:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1807:

lab1809:
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
    je lab1821
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
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
    lea r9, [rel Bool_1823]
    ; jump is_occupied_
    jmp is_occupied_

Bool_1823:
    jmp near Bool_1823_True
    jmp near Bool_1823_False

Bool_1823_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1827
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
    je lab1824
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1824:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab1825
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1825:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab1826
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1826:
    jmp lab1828

lab1827:
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

lab1828:
    ; substitute (a0 := a0);
    ; #erase board
    cmp r8, 0
    je lab1831
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab1829
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab1830

lab1829:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab1830:

lab1831:
    ; #erase p
    cmp r10, 0
    je lab1834
    ; ######check refcount
    cmp qword [r10 + 0], 0
    je lab1832
    ; ######either decrement refcount ...
    add qword [r10 + 0], -1
    jmp lab1833

lab1832:
    ; ######... or add block to lazy free list
    mov [r10 + 0], rbp
    mov rbp, r10

lab1833:

lab1834:
    ; #move variables
    mov rax, rsi
    mov rdx, rdi
    ; invoke a0 Nil
    add rdx, 0
    jmp rdx

Bool_1823_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1838
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
    je lab1835
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1835:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab1836
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1836:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab1837
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1837:
    jmp lab1839

lab1838:
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

lab1839:
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
    je lab1851
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1852

lab1851:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1849
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1845
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1843
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1844

lab1843:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1844:

lab1845:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1848
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1846
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1847

lab1846:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1847:

lab1848:
    jmp lab1850

lab1849:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1850:

lab1852:
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
    lea rcx, [rel List_Option_Player_1853]
    add rcx, r11
    jmp rcx

List_Option_Player_1853:
    jmp near List_Option_Player_1853_Nil
    jmp near List_Option_Player_1853_Cons

List_Option_Player_1853_Nil:
    ; substitute (acc := acc)(a0 := a0);
    ; #move variables
    mov rax, r8
    mov rdx, r9
    ; jump rev_
    jmp rev_

List_Option_Player_1853_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r10 + 0], 0
    je lab1856
    ; ##either decrement refcount and share children...
    add qword [r10 + 0], -1
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    cmp r12, 0
    je lab1854
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1854:
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]
    cmp r10, 0
    je lab1855
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1855:
    jmp lab1857

lab1856:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r10 + 0], rbx
    mov rbx, r10
    ; ###load values
    mov r13, [r10 + 56]
    mov r12, [r10 + 48]
    mov r11, [r10 + 40]
    mov r10, [r10 + 32]

lab1857:
    ; substitute (n := n)(a0 := a0)(acc := acc)(more := more)(p := p);
    ; #move variables
    mov rcx, r12
    mov r12, r10
    mov r10, rcx
    mov rcx, r13
    mov r13, r11
    mov r11, rcx
    ; switch p \{ ... \};
    lea rcx, [rel Option_Player_1858]
    add rcx, r13
    jmp rcx

Option_Player_1858:
    jmp near Option_Player_1858_None
    jmp near Option_Player_1858_Some

Option_Player_1858_None:
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
    je lab1870
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1871

lab1870:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1868
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1861
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1859
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1860

lab1859:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1860:

lab1861:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1864
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1862
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1863

lab1862:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1863:

lab1864:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1867
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1865
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1866

lab1865:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1866:

lab1867:
    jmp lab1869

lab1868:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1869:

lab1871:
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

Option_Player_1858_Some:
    ; #load from memory
    ; ##check refcount
    cmp qword [r12 + 0], 0
    je lab1873
    ; ##either decrement refcount and share children...
    add qword [r12 + 0], -1
    ; ###load values
    mov r13, [r12 + 56]
    mov r12, [r12 + 48]
    cmp r12, 0
    je lab1872
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1872:
    jmp lab1874

lab1873:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r12 + 0], rbx
    mov rbx, r12
    ; ###load values
    mov r13, [r12 + 56]
    mov r12, [r12 + 48]

lab1874:
    ; substitute (n := n)(a0 := a0)(acc := acc)(more := more);
    ; #erase p0
    cmp r12, 0
    je lab1877
    ; ######check refcount
    cmp qword [r12 + 0], 0
    je lab1875
    ; ######either decrement refcount ...
    add qword [r12 + 0], -1
    jmp lab1876

lab1875:
    ; ######... or add block to lazy free list
    mov [r12 + 0], rbp
    mov rbp, r12

lab1876:

lab1877:
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
    je lab1878
    ; ####increment refcount
    add qword [rax + 0], 1

lab1878:
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
    je lab1890
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1891

lab1890:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1888
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1884
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1882
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1883

lab1882:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1883:

lab1884:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1887
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1885
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1886

lab1885:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1886:

lab1887:
    jmp lab1889

lab1888:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1889:

lab1891:
    ; #load tag
    lea rdi, [rel List_i64_1892]
    ; jump all_moves_
    jmp all_moves_

List_i64_1892:
    jmp near List_i64_1892_Nil
    jmp near List_i64_1892_Cons

List_i64_1892_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1896
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1893
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1893:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1894
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1894:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1895
    ; ####increment refcount
    add qword [rax + 0], 1

lab1895:
    jmp lab1897

lab1896:
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

lab1897:
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

List_i64_1892_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1901
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab1898
    ; ####increment refcount
    add qword [r12 + 0], 1

lab1898:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab1899
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1899:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab1900
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1900:
    jmp lab1902

lab1901:
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

lab1902:
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
    je lab1914
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab1915

lab1914:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1912
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1911
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1909
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1910

lab1909:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1910:

lab1911:
    jmp lab1913

lab1912:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1913:

lab1915:
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
    je lab1927
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab1928

lab1927:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1925
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1918
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1916
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1917

lab1916:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1917:

lab1918:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1921
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1919
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1920

lab1919:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1920:

lab1921:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1924
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1922
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1923

lab1922:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1923:

lab1924:
    jmp lab1926

lab1925:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1926:

lab1928:
    ; #load tag
    lea r9, [rel Fun_i64_List_Option_Player_1929]
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

Fun_i64_List_Option_Player_1929:

Fun_i64_List_Option_Player_1929_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab1932
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab1930
    ; ####increment refcount
    add qword [r10 + 0], 1

lab1930:
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab1931
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1931:
    jmp lab1933

lab1932:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]

lab1933:
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
    je lab1934
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1934:
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
    je lab1946
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1947

lab1946:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1944
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1937
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1935
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1936

lab1935:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1936:

lab1937:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1945

lab1944:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1945:

lab1947:
    ; #load tag
    lea rdi, [rel Bool_1948]
    ; jump game_over_
    jmp game_over_

Bool_1948:
    jmp near Bool_1948_True
    jmp near Bool_1948_False

Bool_1948_True:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1952
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1949
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1949:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1950
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1950:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1951
    ; ####increment refcount
    add qword [rax + 0], 1

lab1951:
    jmp lab1953

lab1952:
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

lab1953:
    ; substitute (board0 := board)(a0 := a0)(board := board);
    ; #share board
    cmp rax, 0
    je lab1954
    ; ####increment refcount
    add qword [rax + 0], 1

lab1954:
    ; #erase p
    cmp r8, 0
    je lab1957
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab1955
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab1956

lab1955:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab1956:

lab1957:
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
    je lab1969
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1970

lab1969:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1967
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1960
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1958
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1959

lab1958:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1959:

lab1960:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1963
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1961
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1962

lab1961:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1962:

lab1963:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab1968

lab1967:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1968:

lab1970:
    ; #load tag
    lea rdi, [rel _Cont_1971]
    ; jump score_
    jmp score_

_Cont_1971:

_Cont_1971_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab1974
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    cmp r8, 0
    je lab1972
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1972:
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]
    cmp rsi, 0
    je lab1973
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1973:
    jmp lab1975

lab1974:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov r9, [rsi + 56]
    mov r8, [rsi + 48]
    mov rdi, [rsi + 40]
    mov rsi, [rsi + 32]

lab1975:
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
    je lab1987
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab1988

lab1987:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab1985
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab1978
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1976
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1977

lab1976:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1977:

lab1978:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab1981
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1979
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1980

lab1979:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1980:

lab1981:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab1984
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1982
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab1983

lab1982:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab1983:

lab1984:
    jmp lab1986

lab1985:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab1986:

lab1988:
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

Bool_1948_False:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab1992
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab1989
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1989:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab1990
    ; ####increment refcount
    add qword [rsi + 0], 1

lab1990:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab1991
    ; ####increment refcount
    add qword [rax + 0], 1

lab1991:
    jmp lab1993

lab1992:
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

lab1993:
    ; substitute (board1 := board)(p0 := p)(p := p)(board := board)(a0 := a0);
    ; #share board
    cmp rax, 0
    je lab1994
    ; ####increment refcount
    add qword [rax + 0], 1

lab1994:
    ; #share p
    cmp r8, 0
    je lab1995
    ; ####increment refcount
    add qword [r8 + 0], 1

lab1995:
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
    je lab2007
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2008

lab2007:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2005
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2001
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab1999
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2000

lab1999:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2000:

lab2001:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2004
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2002
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2003

lab2002:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2003:

lab2004:
    jmp lab2006

lab2005:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2006:

lab2008:
    ; #load tag
    lea r9, [rel List_List_Option_Player_2009]
    ; jump successors_
    jmp successors_

List_List_Option_Player_2009:
    jmp near List_List_Option_Player_2009_Nil
    jmp near List_List_Option_Player_2009_Cons

List_List_Option_Player_2009_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab2013
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab2010
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2010:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab2011
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2011:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab2012
    ; ####increment refcount
    add qword [rax + 0], 1

lab2012:
    jmp lab2014

lab2013:
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

lab2014:
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

List_List_Option_Player_2009_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2018
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab2015
    ; ####increment refcount
    add qword [r12 + 0], 1

lab2015:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab2016
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2016:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab2017
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2017:
    jmp lab2019

lab2018:
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

lab2019:
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
    je lab2031
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2032

lab2031:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2029
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2022
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2020
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2021

lab2020:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2021:

lab2022:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2025
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2023
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2024

lab2023:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2024:

lab2025:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2028
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2026
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2027

lab2026:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2027:

lab2028:
    jmp lab2030

lab2029:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2030:

lab2032:
    ; #load tag
    mov r11, 5
    ; jump lift_minimax_0_
    jmp lift_minimax_0_

lift_minimax_0_:
    ; substitute (a0 := a0)(board := board)(p0 := p)(x2 := x2)(p := p);
    ; #share p
    cmp r8, 0
    je lab2033
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2033:
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
    je lab2045
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2046

lab2045:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2043
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2036
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2034
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2035

lab2034:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2035:

lab2036:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab2044

lab2043:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2044:

lab2046:
    ; #load tag
    lea r13, [rel Fun_List_Option_Player_RoseTree_Pair_List_Option_Player_i64_2047]
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
    je lab2059
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2060

lab2059:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2057
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2053
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2051
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2052

lab2051:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2052:

lab2053:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2056
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2054
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2055

lab2054:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2055:

lab2056:
    jmp lab2058

lab2057:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2058:

lab2060:
    ; #load tag
    lea r9, [rel List_RoseTree_Pair_List_Option_Player_i64_2061]
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

List_RoseTree_Pair_List_Option_Player_i64_2061:
    jmp near List_RoseTree_Pair_List_Option_Player_i64_2061_Nil
    jmp near List_RoseTree_Pair_List_Option_Player_i64_2061_Cons

List_RoseTree_Pair_List_Option_Player_i64_2061_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab2065
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab2062
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2062:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab2063
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2063:
    mov rdx, [rax + 24]
    mov rax, [rax + 16]
    cmp rax, 0
    je lab2064
    ; ####increment refcount
    add qword [rax + 0], 1

lab2064:
    jmp lab2066

lab2065:
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

lab2066:
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

List_RoseTree_Pair_List_Option_Player_i64_2061_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2070
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab2067
    ; ####increment refcount
    add qword [r12 + 0], 1

lab2067:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab2068
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2068:
    mov r9, [r8 + 24]
    mov r8, [r8 + 16]
    cmp r8, 0
    je lab2069
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2069:
    jmp lab2071

lab2070:
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

lab2071:
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
    je lab2083
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2084

lab2083:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2081
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2077
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2075
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2076

lab2075:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2076:

lab2077:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2080
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2078
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2079

lab2078:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2079:

lab2080:
    jmp lab2082

lab2081:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2082:

lab2084:
    ; #load tag
    mov r11, 5
    ; jump lift_minimax_1_
    jmp lift_minimax_1_

Fun_List_Option_Player_RoseTree_Pair_List_Option_Player_i64_2047:

Fun_List_Option_Player_RoseTree_Pair_List_Option_Player_i64_2047_Apply:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2086
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab2085
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2085:
    jmp lab2087

lab2086:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab2087:
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
    je lab2099
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2100

lab2099:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2097
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2090
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2088
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2089

lab2088:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2089:

lab2090:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2093
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2091
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2092

lab2091:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2092:

lab2093:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab2098

lab2097:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2098:

lab2100:
    ; #load tag
    lea rdi, [rel Player_2101]
    ; jump other_
    jmp other_

Player_2101:
    jmp near Player_2101_X
    jmp near Player_2101_O

Player_2101_X:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab2104
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab2102
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2102:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab2103
    ; ####increment refcount
    add qword [rax + 0], 1

lab2103:
    jmp lab2105

lab2104:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab2105:
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

Player_2101_O:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab2108
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    cmp rsi, 0
    je lab2106
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2106:
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab2107
    ; ####increment refcount
    add qword [rax + 0], 1

lab2107:
    jmp lab2109

lab2108:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rax + 0], rbx
    mov rbx, rax
    ; ###load values
    mov rdi, [rax + 56]
    mov rsi, [rax + 48]
    mov rdx, [rax + 40]
    mov rax, [rax + 32]

lab2109:
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
    lea r13, [rel Fun_RoseTree_Pair_List_Option_Player_i64_i64_2110]
    ; substitute (x4 := x4)(trees0 := trees)(p := p)(trees := trees)(board := board)(a0 := a0);
    ; #share trees
    cmp r10, 0
    je lab2111
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2111:
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
    je lab2123
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2124

lab2123:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2121
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2114
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2112
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2113

lab2112:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2113:

lab2114:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab2122

lab2121:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2122:

lab2124:
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
    je lab2136
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2137

lab2136:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2134
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2127
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2125
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2126

lab2125:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2126:

lab2127:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab2135

lab2134:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2135:

lab2137:
    ; #load tag
    lea r9, [rel List_i64_2138]
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

List_i64_2138:
    jmp near List_i64_2138_Nil
    jmp near List_i64_2138_Cons

List_i64_2138_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab2143
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load link to next block
    mov rsi, [rax + 48]
    ; ###load values
    mov rdx, [rax + 40]
    mov rax, [rax + 32]
    cmp rax, 0
    je lab2139
    ; ####increment refcount
    add qword [rax + 0], 1

lab2139:
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab2140
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2140:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab2141
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2141:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab2142
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2142:
    jmp lab2144

lab2143:
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

lab2144:
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

List_i64_2138_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2149
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load link to next block
    mov r10, [r8 + 48]
    ; ###load values
    mov r9, [r8 + 40]
    mov r8, [r8 + 32]
    cmp r8, 0
    je lab2145
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2145:
    ; ###load values
    mov r15, [r10 + 56]
    mov r14, [r10 + 48]
    cmp r14, 0
    je lab2146
    ; ####increment refcount
    add qword [r14 + 0], 1

lab2146:
    mov r13, [r10 + 40]
    mov r12, [r10 + 32]
    cmp r12, 0
    je lab2147
    ; ####increment refcount
    add qword [r12 + 0], 1

lab2147:
    mov r11, [r10 + 24]
    mov r10, [r10 + 16]
    cmp r10, 0
    je lab2148
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2148:
    jmp lab2150

lab2149:
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

lab2150:
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
    je lab2162
    ; ####initialize refcount of just acquired block
    mov qword [r12 + 0], 0
    jmp lab2163

lab2162:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2160
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2153
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2151
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2152

lab2151:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2152:

lab2153:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab2161

lab2160:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2161:

lab2163:
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

Fun_RoseTree_Pair_List_Option_Player_i64_i64_2110:

Fun_RoseTree_Pair_List_Option_Player_i64_i64_2110_Apply:
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
    je lab2175
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2176

lab2175:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2173
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2166
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2164
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2165

lab2164:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2165:

lab2166:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab2174

lab2173:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2174:

lab2176:
    ; #load tag
    lea rdi, [rel Pair_List_Option_Player_i64_2177]
    ; jump top_
    jmp top_

Pair_List_Option_Player_i64_2177:

Pair_List_Option_Player_i64_2177_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2179
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab2178
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2178:
    jmp lab2180

lab2179:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab2180:
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
    je lab2192
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2193

lab2192:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2190
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2183
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2181
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2182

lab2181:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2182:

lab2183:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2186
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2184
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2185

lab2184:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2185:

lab2186:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2189
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2187
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2188

lab2187:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2188:

lab2189:
    jmp lab2191

lab2190:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2191:

lab2193:
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
    lea rcx, [rel Player_2194]
    add rcx, r13
    jmp rcx

Player_2194:
    jmp near Player_2194_X
    jmp near Player_2194_O

Player_2194_X:
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
    je lab2206
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2207

lab2206:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2204
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2197
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2195
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2196

lab2195:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2196:

lab2197:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab2205

lab2204:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2205:

lab2207:
    ; #load tag
    lea rdi, [rel _Cont_2208]
    ; jump listmax_
    jmp listmax_

_Cont_2208:

_Cont_2208_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab2212
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab2209
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2209:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab2210
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2210:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab2211
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2211:
    jmp lab2213

lab2212:
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

lab2213:
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
    je lab2225
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2226

lab2225:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2223
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2222
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2220
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2221

lab2220:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2221:

lab2222:
    jmp lab2224

lab2223:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2224:

lab2226:
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

Player_2194_O:
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
    je lab2238
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2239

lab2238:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2236
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2235
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2233
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2234

lab2233:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2234:

lab2235:
    jmp lab2237

lab2236:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2237:

lab2239:
    ; #load tag
    lea rdi, [rel _Cont_2240]
    ; jump listmin_
    jmp listmin_

_Cont_2240:

_Cont_2240_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab2244
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov r11, [rsi + 56]
    mov r10, [rsi + 48]
    cmp r10, 0
    je lab2241
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2241:
    mov r9, [rsi + 40]
    mov r8, [rsi + 32]
    cmp r8, 0
    je lab2242
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2242:
    mov rdi, [rsi + 24]
    mov rsi, [rsi + 16]
    cmp rsi, 0
    je lab2243
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2243:
    jmp lab2245

lab2244:
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

lab2245:
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
    je lab2257
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2258

lab2257:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2255
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2248
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2246
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2247

lab2246:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2247:

lab2248:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2251
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2249
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2250

lab2249:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2250:

lab2251:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2254
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2252
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2253

lab2252:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2253:

lab2254:
    jmp lab2256

lab2255:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2256:

lab2258:
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
    je lab2270
    ; ####initialize refcount of just acquired block
    mov qword [rax + 0], 0
    jmp lab2271

lab2270:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2268
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2261
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2259
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2260

lab2259:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2260:

lab2261:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2264
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2262
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2263

lab2262:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2263:

lab2264:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2267
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2265
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2266

lab2265:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2266:

lab2267:
    jmp lab2269

lab2268:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2269:

lab2271:
    ; #load tag
    lea rdx, [rel List_Option_Player_2272]
    ; jump empty_
    jmp empty_

List_Option_Player_2272:
    jmp near List_Option_Player_2272_Nil
    jmp near List_Option_Player_2272_Cons

List_Option_Player_2272_Nil:
    ; #load from memory
    ; ##check refcount
    cmp qword [rax + 0], 0
    je lab2275
    ; ##either decrement refcount and share children...
    add qword [rax + 0], -1
    ; ###load values
    mov r9, [rax + 56]
    mov r8, [rax + 48]
    cmp r8, 0
    je lab2273
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2273:
    mov rdi, [rax + 40]
    mov rsi, [rax + 32]
    cmp rsi, 0
    je lab2274
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2274:
    mov rdx, [rax + 24]
    jmp lab2276

lab2275:
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

lab2276:
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

List_Option_Player_2272_Cons:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2279
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r13, [r8 + 56]
    mov r12, [r8 + 48]
    cmp r12, 0
    je lab2277
    ; ####increment refcount
    add qword [r12 + 0], 1

lab2277:
    mov r11, [r8 + 40]
    mov r10, [r8 + 32]
    cmp r10, 0
    je lab2278
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2278:
    mov r9, [r8 + 24]
    jmp lab2280

lab2279:
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

lab2280:
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
    je lab2292
    ; ####initialize refcount of just acquired block
    mov qword [r10 + 0], 0
    jmp lab2293

lab2292:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2290
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2283
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2281
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2282

lab2281:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2282:

lab2283:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab2291

lab2290:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2291:

lab2293:
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
    je lab2305
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2306

lab2305:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2303
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2296
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2294
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2295

lab2294:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2295:

lab2296:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab2304

lab2303:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2304:

lab2306:
    ; #load tag
    lea r9, [rel RoseTree_Pair_List_Option_Player_i64_2307]
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

RoseTree_Pair_List_Option_Player_i64_2307:

RoseTree_Pair_List_Option_Player_i64_2307_Rose:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2309
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    cmp r10, 0
    je lab2308
    ; ####increment refcount
    add qword [r10 + 0], 1

lab2308:
    mov r9, [r8 + 40]
    jmp lab2310

lab2309:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r11, [r8 + 56]
    mov r10, [r8 + 48]
    mov r9, [r8 + 40]

lab2310:
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
    je lab2322
    ; ####initialize refcount of just acquired block
    mov qword [r8 + 0], 0
    jmp lab2323

lab2322:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2320
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2313
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2311
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2312

lab2311:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2312:

lab2313:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2316
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2314
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2315

lab2314:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2315:

lab2316:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2319
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2317
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2318

lab2317:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2318:

lab2319:
    jmp lab2321

lab2320:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2321:

lab2323:
    ; #load tag
    mov r9, 0
    ; lit x2 <- 1;
    mov r11, 1
    ; if iters == x2 \{ ... \}
    cmp rdi, r11
    je lab2324
    ; else branch
    ; substitute (a0 := a0)(iters := iters);
    ; #erase res
    cmp r8, 0
    je lab2327
    ; ######check refcount
    cmp qword [r8 + 0], 0
    je lab2325
    ; ######either decrement refcount ...
    add qword [r8 + 0], -1
    jmp lab2326

lab2325:
    ; ######... or add block to lazy free list
    mov [r8 + 0], rbp
    mov rbp, r8

lab2326:

lab2327:
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

lab2324:
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
    je lab2339
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
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
    lea rdi, [rel _Cont_2341]
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
    je lab2353
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2354

lab2353:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2351
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
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
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
    cmp rcx, 0
    je lab2347
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2345
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2346

lab2345:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2346:

lab2347:
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
    cmp rcx, 0
    je lab2350
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2348
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2349

lab2348:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2349:

lab2350:
    jmp lab2352

lab2351:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2352:

lab2354:
    ; #load tag
    lea rdi, [rel Pair_List_Option_Player_i64_2355]
    ; jump top_
    jmp top_

Pair_List_Option_Player_i64_2355:

Pair_List_Option_Player_i64_2355_Tup:
    ; #load from memory
    ; ##check refcount
    cmp qword [r8 + 0], 0
    je lab2357
    ; ##either decrement refcount and share children...
    add qword [r8 + 0], -1
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]
    cmp r8, 0
    je lab2356
    ; ####increment refcount
    add qword [r8 + 0], 1

lab2356:
    jmp lab2358

lab2357:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [r8 + 0], rbx
    mov rbx, r8
    ; ###load values
    mov r9, [r8 + 56]
    mov r8, [r8 + 48]

lab2358:
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
    je lab2370
    ; ####initialize refcount of just acquired block
    mov qword [rsi + 0], 0
    jmp lab2371

lab2370:
    ; ###(2) check non-linear lazy free list for next block
    mov rbx, rbp
    mov rbp, [rbp + 0]
    cmp rbp, 0
    je lab2368
    ; ####mark linear free list empty
    mov qword [rbx + 0], 0
    ; ####erase children of next block
    ; #####check child 1 for erasure
    mov rcx, [rbx + 16]
    cmp rcx, 0
    je lab2361
    ; ######check refcount
    cmp qword [rcx + 0], 0
    je lab2359
    ; ######either decrement refcount ...
    add qword [rcx + 0], -1
    jmp lab2360

lab2359:
    ; ######... or add block to lazy free list
    mov [rcx + 0], rbp
    mov rbp, rcx

lab2360:

lab2361:
    ; #####check child 2 for erasure
    mov rcx, [rbx + 32]
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
    ; #####check child 3 for erasure
    mov rcx, [rbx + 48]
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
    jmp lab2369

lab2368:
    ; ###(3) fall back to bump allocation
    mov rbp, rbx
    add rbp, 64

lab2369:

lab2371:
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

_Cont_2341:

_Cont_2341_Ret:
    ; #load from memory
    ; ##check refcount
    cmp qword [rsi + 0], 0
    je lab2373
    ; ##either decrement refcount and share children...
    add qword [rsi + 0], -1
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]
    cmp rsi, 0
    je lab2372
    ; ####increment refcount
    add qword [rsi + 0], 1

lab2372:
    jmp lab2374

lab2373:
    ; ##... or release blocks onto linear free list when loading
    ; ###release block
    mov [rsi + 0], rbx
    mov rbx, rsi
    ; ###load values
    mov rdi, [rsi + 56]
    mov rsi, [rsi + 48]

lab2374:
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