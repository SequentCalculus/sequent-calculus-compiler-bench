structure Boyer = struct 
  datatype Id = A | B | C | D | X | Y | Z | U | W 
              | ADD1 | AND | APPEND | CONS | CONSP 
              | DIFFERENCE | DIVIDES | EQUAL | EVEN | EXP 
              | F | FALSE | FOUR | GCD | GREATEREQP | GREATERP 
              | IF | IFF | IMPLIES | LENGTH | LESSEQP | LESSP 
              | LISTP | MEMBER | NIL | NILP | NLISTP | NOT 
              | ODD | ONE | OR | PLUS | QUOTIENT | REMAINDER 
              | REVERSE | SUB1 | TIMES | TRUE | TWO | ZERO | ZEROP

  datatype Term = Var of Id 
                | Func of Id * (Term list) * (unit -> (Term * Term) list)
                | ERROR

  fun id_equal id1 id2 = 
    case (id1,id2) of 
         (A,A) => true
       | (B,B) => true
       | (C,C) => true
       | (D,D) => true
       | (X,X) => true
       | (Y,Y) => true
       | (Z,Z) => true
       | (U,U) => true
       | (W,W) => true
       | (ADD1,ADD1) => true
       | (AND,AND) => true
       | (APPEND,APPEND) => true
       | (CONS,CONS) => true
       | (CONSP,CONSP) => true
       | (DIFFERENCE,DIFFERENCE) => true
       | (DIVIDES,DIVIDES) => true
       | (EQUAL,EQUAL) => true
       | (EVEN,EVEN) => true
       | (EXP,EXP) => true
       | (F,F) => true
       | (FALSE,FALSE) => true
       | (FOUR,FOUR) => true
       | (GCD,GCD) => true
       | (GREATEREQP,GREATEREQP) => true
       | (GREATERP,GREATERP) => true
       | (IF,IF) => true
       | (IFF,IFF) => true
       | (IMPLIES,IMPLIES) => true
       | (LENGTH,LENGTH) => true
       | (LESSEQP,LESSEQP) => true
       | (LESSP,LESSP) => true 
       | (LISTP,LISTP) => true
       | (MEMBER,MEMBER) => true
       | (NIL,NIL) => true
       | (NILP,NILP) => true
       | (NLISTP,NLISTP) => true
       | (NOT,NOT) => true
       | (ODD,ODD) => true
       | (ONE,ONE) => true
       | (OR,OR) => true
       | (PLUS,PLUS) => true
       | (QUOTIENT,QUOTIENT) => true
       | (REMAINDER,REMAINDER) => true
       | (REVERSE,REVERSE) => true
       | (SUB1,SUB1) => true
       | (TIMES,TIMES) => true
       | (TRUE,TRUE) => true
       | (TWO,TWO) => true
       | (ZERO,ZERO) => true
       | (ZEROP,ZEROP) => true
       | _ => false

  fun term_equal t1 t2 = 
    case (t1,t2) of 
         (Var id1, Var id2) => id1=id2
       | (Func (id1,args1,_),Func (id2,args2,_)) => 
           (id1=id2) andalso (term_list_equal args1 args2)
       | _ => false
  and term_list_equal (ts1:Term list) (ts2: Term list)= 
  case (ts1,ts2) of 
       (nil,nil) => true
     | (t1::tss1,t2::tss2) => (term_equal t1 t2) andalso (term_list_equal tss1 tss2)
     | _ => false

  fun find vid ls = 
    case ls of 
         nil => (false,ERROR)
       | (vid2,val2)::bs => 
           if id_equal vid vid2 
           then (true,val2) 
           else find vid bs

  fun one_way_unify term1 term2 = one_way_unify1 term1 term2 nil
  and one_way_unify1 term1 term2 subst = 
  case term2 of 
       Var vid2 => 
       (case (find vid2 subst) of 
             (true,v2) => (term_equal term1 v2,subst)
           | (false,v2) => (true,((vid2,term1)::subst)))
           | Func (f2,as2,l2) => 
               (case term1 of 
                     Var vid1 => (false,nil)
                   | Func(f1,as1,l1) => if f1=f2 then
                     one_way_unify1_lst as1 as2 subst else (false,nil)
                   | ERROR => (false,nil))
                   | ERROR => (false,nil)
  and one_way_unify1_lst tts1 tts2 subst =
  case (tts1,tts2) of 
       (nil,nil) => (true,subst)
     | (nil,_::_) => (false,nil)
     | (_::_,nil) => (false,nil)
     | (t1::ts1,t2::ts2) => 
         let val (hd_ok,subst_) = one_way_unify1 t1 t2 subst
           val (tl_ok,subst__) = one_way_unify1_lst ts1 ts2 subst_
         in
           (hd_ok andalso tl_ok,subst__)
         end



  fun truep x l =
    Option.isSome (List.find (fn t => term_equal x t) l)  
    orelse
    (case x of 
          Func(TRUE,args,lemmas) => true 
        | _ => false)

  fun falsep x l = 
    Option.isSome (List.find (fn t => term_equal x t) l) 
    orelse 
    (case x of 
          Func(FALSE,args,lemmas) => true
        | _ => false)

  fun apply_subst subst t = 
    case t of 
         Var vid => 
         (case (find vid subst) of
               (true,value) => value 
             | (false,_) => Var vid)
             | Func (f, args, ls) =>
                 Func (f, (map (fn x => apply_subst subst x) args),ls)
             | ERROR => ERROR


  fun rewrite t = 
    case t of 
         Var v => Var v
       | Func (f,args,lemmas) => 
           rewrite_with_lemmas (Func (f, (map (fn x =>
           rewrite x) args ), lemmas)) (lemmas())
       | ERROR => ERROR 
  and rewrite_with_lemmas term lss =
  rewrite_with_lemmas_helper term lss
  and rewrite_with_lemmas_helper term lss =
  case lss of 
       nil => term
     | (lhs,rhs)::ls => 
         let val (unified,subst) = one_way_unify term lhs
         in 
           if unified then 
             rewrite (apply_subst subst rhs) 
           else 
             rewrite_with_lemmas_helper term ls 
         end



  fun tautologyp x true_lst false_lst = 
    if truep x true_lst then 
      true 
    else if falsep x false_lst then 
      false 
         else 
           case x of 
                Func(IF,cond::t::e::nil,lemmas) => 
                if truep cond true_lst then 
                  tautologyp t true_lst false_lst 
                else if falsep cond false_lst
                then 
                  tautologyp e true_lst false_lst 
                     else 
                       (tautologyp t (cond::true_lst) false_lst)
                       andalso 
                       (tautologyp e true_lst (cond::false_lst))
              | _ => false

  fun boyer_a () = Var A 
  and boyer_b () = Var B
  and boyer_c () = Var C 
  and boyer_d () = Var D
  and boyer_x () = Var X
  and boyer_y () = Var Y
  and boyer_z () = Var Z 
  and boyer_u () = Var U
  and boyer_w () = Var W
  and boyer_f a = Func (F,a::nil,fn () => nil)
  and boyer_zero () = Func (ZERO,nil,fn () => nil)
  and boyer_one () = Func (ONE,nil,fn () => 
  (
  boyer_one(),
  boyer_add1 (boyer_zero())
  )::nil)
  and boyer_two () = Func (TWO,nil,fn () => 
  (
  boyer_two(),
  boyer_add1 (boyer_one())
  )::nil)
  and boyer_four () = Func(FOUR,nil, fn () => 
  (
  boyer_four(),
  boyer_add1 (boyer_add1 (boyer_two()))
  )::nil)
  and boyer_true() = Func (TRUE,nil,fn () => nil)
  and boyer_false() = Func (FALSE,nil,fn () => nil)
  and boyer_and_ a b = Func(AND,(a::b::nil),fn () => 
  (
  boyer_and_ (boyer_x()) (boyer_y()),
  boyer_if_ 
  (boyer_x()) 
  (boyer_if_ 
  (boyer_y()) 
  (boyer_true()) 
  (boyer_false())
  ) 
  (boyer_false())
  )::nil)
  and boyer_or_ a b = Func(OR,a::b::nil,fn () => 
  (
  boyer_or_ (boyer_x()) (boyer_y()),
  boyer_if_ 
  (boyer_x()) 
  (boyer_true())   
  (boyer_if_ (boyer_y()) (boyer_true()) (boyer_false()))
  )::nil)
  and boyer_not_ a = Func(NOT,a::nil,fn () => 
  (
  boyer_not_ (boyer_x()),
  boyer_if_ (boyer_x()) (boyer_false()) (boyer_true())
  )::nil)
  and boyer_implies a b = Func (IMPLIES,a::b::nil,fn () => 
  (
  boyer_implies (boyer_x()) (boyer_y()),
  boyer_if_ 
  (boyer_x()) 
  (boyer_if_ 
  (boyer_y()) 
  (boyer_true()) 
  (boyer_false())
  ) 
  (boyer_true())
  )::nil)
  and boyer_if_ a b c = Func(IF,a::b::c::nil,fn () =>
  (
  boyer_if_ 
  (boyer_if_ 
  (boyer_x()) 
  (boyer_y()) 
  (boyer_z())
  ) 
  (boyer_u()) 
  (boyer_w()), 
  boyer_if_ 
  (boyer_x()) 
  (boyer_if_ (boyer_y()) (boyer_u()) (boyer_w())) 
  (boyer_if_ (boyer_z()) (boyer_u()) (boyer_w()))
  )::nil
  )
  and boyer_zerop a = Func(ZEROP,a::nil,fn () => 
  (
  boyer_zerop (boyer_x()),
  boyer_equal (boyer_x()) (boyer_zero())
  )::nil)
  and boyer_plus a b = Func(PLUS,a::b::nil,fn () => 
  (
  boyer_plus 
  (boyer_plus (boyer_x()) (boyer_y())) 
  (boyer_z()),
  boyer_plus 
  (boyer_x()) 
  (boyer_plus (boyer_y()) (boyer_z()))
  )::(
  boyer_plus 
  (boyer_remainder (boyer_x()) (boyer_y()))
  (boyer_times 
  (boyer_y()) 
  (boyer_quotient (boyer_x()) (boyer_y()))
  ),
  boyer_x()
  )::(
  boyer_plus (boyer_x()) (boyer_add1 (boyer_y())),
  boyer_add1 (boyer_plus (boyer_x()) (boyer_y()))
  )::nil
  )
  and boyer_add1 a = Func(ADD1,a::nil, fn () => nil)
  and boyer_difference a b = Func(DIFFERENCE,a::b::nil,fn () =>
  (
  boyer_difference (boyer_x()) (boyer_x()),
  boyer_zero()
  )::(
  boyer_difference 
  (boyer_plus 
  (boyer_x()) 
  (boyer_y())
  )
  (boyer_x()),
  boyer_y()
  )::(
  boyer_difference
  (boyer_plus (boyer_y()) (boyer_x()))
  (boyer_x()),
  boyer_y()
  )::(
  boyer_difference 
  (boyer_plus (boyer_x()) (boyer_y()))
  (boyer_plus (boyer_x()) (boyer_z())),
  boyer_difference (boyer_y()) (boyer_z())
  )::(
  boyer_difference 
  (boyer_plus (boyer_y()) (boyer_plus (boyer_x()) (boyer_z()))) 
  (boyer_x()),
  boyer_plus (boyer_y()) (boyer_z())
  )::(
  boyer_difference 
  (boyer_add1 (boyer_plus (boyer_y()) (boyer_z()))) 
  (boyer_z()),
  boyer_add1 (boyer_y())
  )::(
  boyer_difference (boyer_add1 (boyer_add1 (boyer_x()))) (boyer_two()),
  boyer_x()
  )::nil)
  and boyer_quotient a  b = Func(QUOTIENT,a::b::nil,fn () =>
  (
  boyer_quotient 
  (boyer_plus 
  (boyer_x()) 
  (boyer_plus (boyer_x()) (boyer_y()))
  )
  (boyer_two()),
  boyer_plus 
  (boyer_x()) 
  (boyer_quotient (boyer_y()) (boyer_two()))
  )::nil)
  and boyer_remainder a b = Func(REMAINDER,a::b::nil,fn () =>
  (
  boyer_remainder (boyer_x()) (boyer_one()),
  boyer_zero()
  )::(
  boyer_remainder (boyer_x()) (boyer_x()),
  boyer_zero()  
  )::(
  boyer_remainder 
  (boyer_times (boyer_x()) (boyer_y())) 
  (boyer_x()),
  boyer_zero()
  )::(
  boyer_remainder 
  (boyer_times (boyer_x()) (boyer_y()))
  (boyer_y()),
  boyer_zero()
  )::nil)
  and boyer_times a b = Func(TIMES,a::b::nil,fn () => 
  (
  boyer_times 
  (boyer_x()) 
  (boyer_plus (boyer_y()) (boyer_z())),
  boyer_plus 
  (boyer_times (boyer_x()) (boyer_y())) 
  (boyer_times (boyer_x()) (boyer_z()))
  )::(
  boyer_times 
  (boyer_times (boyer_x()) (boyer_y())) 
  (boyer_z()),
  boyer_times 
  (boyer_x()) 
  (boyer_times (boyer_y()) (boyer_z()))
  )::(
  boyer_times 
  (boyer_x()) 
  (boyer_difference (boyer_y()) (boyer_z())),
  boyer_difference
  (boyer_times (boyer_y()) (boyer_x()))
  (boyer_times (boyer_z()) (boyer_x()))
  )::(
  boyer_times 
  (boyer_x()) 
  (boyer_add1 (boyer_y())),
  boyer_plus 
  (boyer_x()) 
  (boyer_times (boyer_x()) (boyer_y()))
  )::nil)
  and boyer_equal a b = Func(EQUAL,a::b::nil, fn () =>
  (
  boyer_equal
  (boyer_plus (boyer_x()) (boyer_y())) 
  (boyer_zero()),
  boyer_and_
  (boyer_zerop (boyer_x()))
  (boyer_zerop (boyer_y()))
  )::(
  boyer_equal
  (boyer_plus (boyer_x()) (boyer_y()))
  (boyer_plus (boyer_x()) (boyer_z())),
  boyer_equal (boyer_y()) (boyer_z())
  )::(
  boyer_equal
  (boyer_zero())
  (boyer_difference (boyer_x()) (boyer_y())),
  boyer_not_ (boyer_lessp (boyer_y()) (boyer_x()))
  )::(
  boyer_equal 
  (boyer_x()) 
  (boyer_difference (boyer_x()) (boyer_y())),
  boyer_or_
  (boyer_equal (boyer_x()) (boyer_zero()))
  (boyer_zerop (boyer_y()))
  )::(
  boyer_equal
  (boyer_times (boyer_x()) (boyer_y()))
  (boyer_zero()),
  boyer_or_
  (boyer_zerop (boyer_x()))
  (boyer_zerop (boyer_y()))
  )::(
  boyer_equal
  (boyer_append_ (boyer_x()) (boyer_y()))
  (boyer_append_ (boyer_x()) (boyer_z())),
  boyer_equal (boyer_y()) (boyer_z())
  )::(
  boyer_equal 
  (boyer_y()) 
  (boyer_times (boyer_x()) (boyer_y())),
  boyer_or_
  (boyer_equal (boyer_y()) (boyer_zero()))
  (boyer_equal (boyer_x()) (boyer_one()))
  )::(
  boyer_equal
  (boyer_x())
  (boyer_times (boyer_x()) (boyer_y())),
  boyer_or_
  (boyer_equal (boyer_x()) (boyer_zero()))
  (boyer_equal (boyer_y()) (boyer_one()))
  )::(
  boyer_equal
  (boyer_times (boyer_x()) (boyer_y()))
  (boyer_one()),
  boyer_and_
  (boyer_equal (boyer_x()) (boyer_one()))
  (boyer_equal (boyer_y()) (boyer_one()))
  )::(
  boyer_equal
  (boyer_difference (boyer_x()) (boyer_y()))
  (boyer_difference (boyer_z()) (boyer_y()))
  ,
  boyer_if_
  (boyer_lessp (boyer_x()) (boyer_y()))
  (boyer_not_ (boyer_lessp (boyer_y()) (boyer_z())))
  (boyer_if_
  (boyer_lessp (boyer_z()) (boyer_y()))
  (boyer_not_ (boyer_lessp (boyer_y()) (boyer_x())))
  (boyer_equal (boyer_x()) (boyer_z()))
  )
  )::(
  boyer_equal
  (boyer_lessp (boyer_x()) (boyer_y()))
  (boyer_z()),
  boyer_if_
  (boyer_lessp (boyer_x()) (boyer_y()))
  (boyer_equal (boyer_true()) (boyer_z()))
  (boyer_equal (boyer_false()) (boyer_z()))
  )::nil)
  and boyer_lessp a b = Func(LESSP,a::b::nil,fn () => 
  (
  boyer_lessp 
  (boyer_remainder (boyer_x()) (boyer_y()))
  (boyer_y()), 
  boyer_not_ (boyer_zerop (boyer_y()))
  )::(
  boyer_lessp
  (boyer_quotient (boyer_x()) (boyer_y()))
  (boyer_x()),
  boyer_and_
  (boyer_not_ (boyer_zerop (boyer_x())))
  (boyer_lessp (boyer_one()) (boyer_y()))
  )::(
  boyer_lessp
  (boyer_plus (boyer_x()) (boyer_y()))
  (boyer_z()),
  boyer_lessp (boyer_y()) (boyer_z())
  )::(
  boyer_lessp
  (boyer_times (boyer_x()) (boyer_z()))
  (boyer_times (boyer_y()) (boyer_z())),
  boyer_and_
  (boyer_not_ (boyer_zerop (boyer_z())))
  (boyer_lessp (boyer_x()) (boyer_y()))
  )::(
  boyer_lessp 
  (boyer_y()) 
  (boyer_plus (boyer_x()) (boyer_y())),
  boyer_not_ (boyer_zerop (boyer_x()))
  )::nil)
  and boyer_nil () = Func(NIL,nil,fn () => nil)
  and boyer_cons a b = Func(CONS,a::b::nil,fn () => nil)
  and boyer_member a b = Func(MEMBER,a::b::nil,fn () => 
  (
  boyer_member
  (boyer_x())
  (boyer_append_ (boyer_y()) (boyer_z())),
  boyer_or_
  (boyer_member (boyer_x()) (boyer_y()))
  (boyer_member (boyer_x()) (boyer_z()))
  )::(
  boyer_member 
  (boyer_x())
  (boyer_reverse_ (boyer_y())),
  boyer_member (boyer_x()) (boyer_y())
  )::nil)
  and boyer_length_ a = Func(LENGTH,a::nil,fn() => 
  (
  boyer_length_ (boyer_reverse_ (boyer_x())),
  boyer_length_ (boyer_x())
  )::(
  boyer_length_ 
  (boyer_cons (boyer_x()) 
  (boyer_cons (boyer_y()) 
  (boyer_cons (boyer_z())
  (boyer_cons (boyer_u())
  (boyer_w())
  )))),
  boyer_plus 
  (boyer_four())
  (boyer_length_ (boyer_w()))
  )::nil)
  and boyer_append_ a b = Func(APPEND,a::b::nil,fn () => 
  (
  boyer_append_
  (boyer_append_ (boyer_x()) (boyer_y()))
  (boyer_z()),
  boyer_append_ 
  (boyer_x()) 
  (boyer_append_ (boyer_y()) (boyer_z()))
  )::nil)
  and boyer_reverse_ a = Func(REVERSE,a::nil,fn () => 
  (
  boyer_reverse_ (boyer_append_ (boyer_x()) (boyer_y())),
  boyer_append_ (boyer_reverse_ (boyer_y())) (boyer_reverse_ (boyer_x()))
  )::nil)

  fun boyer_theorem xxxx = 
    boyer_implies 
    (boyer_and_ 
    (boyer_implies xxxx (boyer_y())) 
    (boyer_and_ 
    (boyer_implies (boyer_y()) (boyer_z()))
    (boyer_and_ 
    (boyer_implies (boyer_z()) (boyer_u()))
    (boyer_implies (boyer_u()) (boyer_w()))
    )
    )
    ) 
    (boyer_implies (boyer_x()) (boyer_w()))

  fun boyer_subst0 () = 
    [
    (X,boyer_f 
    (boyer_plus 
    (boyer_plus (boyer_a()) (boyer_b()))
    (boyer_plus (boyer_c()) (boyer_zero()))
    )
    ),
    (Y,boyer_f 
    (boyer_times
    (boyer_times (boyer_a()) (boyer_b())) 
    (boyer_plus (boyer_c()) (boyer_d()))
    )
    ),
    (Z,boyer_f 
    (boyer_reverse_
    (boyer_append_ 
    (boyer_append_ (boyer_a()) (boyer_b()))
    (boyer_nil())
    )
    )
    ),
    (U,
    (boyer_equal
    (boyer_plus (boyer_a()) (boyer_b()))
    (boyer_difference (boyer_x()) (boyer_y()))
    )
    ),
    (W,
    (boyer_lessp
    (boyer_remainder (boyer_a()) (boyer_b()))
    (boyer_member (boyer_a()) (boyer_length_ (boyer_b())))
    )
    )
    ]

  fun tautp x = 
    tautologyp (rewrite x) nil nil 

  fun test0 xxxx = 
    tautp (apply_subst (boyer_subst0()) (boyer_theorem xxxx))

  fun replicate_term n t = 
    if n=0 then nil 
    else t :: replicate_term (n-1) t

  fun test_boyer_nofib n = 
    List.all (fn t => test0 t) (replicate_term n (Var X)) 

  fun main_loop iters n = 
  let val res = test_boyer_nofib n
         in
           if iters=1
           then if res then print "1\n" else print "-1\n"
           else main_loop (iters-1) n
         end

  fun run args =   
  let val iters = valOf (Int.fromString (hd args))
    val n = valOf (Int.fromString (hd (tl args)))
  in 
    main_loop iters n
  end
end
