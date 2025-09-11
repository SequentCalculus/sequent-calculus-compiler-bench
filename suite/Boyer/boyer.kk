module boyer

import std/os/env
import std/num/int64

type id
  ID_A
  ID_B
  ID_C
  ID_D
  ID_X
  ID_Y
  ID_Z
  ID_U
  ID_W
  ID_ADD1
  ID_AND
  ID_APPEND
  ID_CONS
  ID_DIFFERENCE
  ID_EQUAL
  ID_F
  ID_FALSE
  ID_FOUR
  ID_IF
  ID_IMPLIES
  ID_LENGTH
  ID_LESSP
  ID_MEMBER
  ID_NIL
  ID_NOT
  ID_ONE
  ID_OR
  ID_PLUS
  ID_QUOTIENT
  ID_REMAINDER
  ID_REVERSE
  ID_TIMES
  ID_TRUE
  ID_TWO
  ID_ZERO
  ID_ZEROP

type term
  Var(i : id)
  Func(f:id,t:list<term>,lemmas:() -> div list<(term,term)>)
  ERR

fun id_eq(id1:id,id2:id) : total bool {
  match (id1,id2){
    (ID_A,ID_A) -> True
    (ID_B,ID_B) -> True
    (ID_C,ID_C) -> True
    (ID_D,ID_D) -> True
    (ID_X,ID_X) -> True
    (ID_Y,ID_Y) -> True
    (ID_Z,ID_Z) -> True
    (ID_U,ID_U) -> True
    (ID_W,ID_W) -> True
    (ID_ADD1,ID_ADD1) -> True
    (ID_AND,ID_AND) -> True
    (ID_APPEND,ID_APPEND) -> True
    (ID_CONS,ID_CONS) -> True
    (ID_DIFFERENCE,ID_DIFFERENCE) -> True
    (ID_EQUAL,ID_EQUAL) -> True
    (ID_F,ID_F) -> True
    (ID_FALSE,ID_FALSE) -> True
    (ID_FOUR,ID_FOUR) -> True
    (ID_IF,ID_IF) -> True
    (ID_IMPLIES,ID_IMPLIES) -> True
    (ID_LENGTH,ID_LENGTH) -> True
    (ID_LESSP,ID_LESSP) -> True
    (ID_MEMBER,ID_MEMBER) -> True
    (ID_NIL,ID_NIL) -> True
    (ID_NOT,ID_NOT) -> True
    (ID_ONE,ID_ONE) -> True
    (ID_OR,ID_OR) -> True
    (ID_PLUS,ID_PLUS) -> True
    (ID_QUOTIENT,ID_QUOTIENT) -> True
    (ID_REMAINDER,ID_REMAINDER) -> True
    (ID_REVERSE,ID_REVERSE) -> True
    (ID_TIMES,ID_TIMES) -> True
    (ID_TRUE,ID_TRUE) -> True
    (ID_TWO,ID_TWO) -> True
    (ID_ZERO,ID_ZERO) -> True
    (ID_ZEROP,ID_ZEROP) -> True
    _ -> False
  }
}

fun term_eq(t1:term,t2:term) : total bool {
  match (t1,t2)
    (Var(id1),Var(id2)) -> id_eq(id1,id2)
    (Func(f1,args1,_),Func(f2,args2,_)) ->
      id_eq(f1,f2) && term_ls_eq(args1,args2)
    _ -> False
}

fun term_ls_eq(ls1:list<term>,ls2:list<term>) : total bool {
  match (ls1,ls2)
    (Nil,_) -> true,
    (Cons(h1,t1),Cons(h2,t2)) -> term_eq(h1,h2) && term_ls_eq(t1,t2)
    _ -> false
}

fun term_in_list(a:term,ls:list<term>) : <div,exn> bool {
  match ls
    Nil -> False
    Cons(a_,as_) ->
      if term_eq(a_,a) then
        True
      else
        term_in_list(a,as_)
}

fun all_list(ls: list<a>, f: a -> <div,exn> bool): <div,exn> bool{
  match ls{
    Nil -> True
    Cons(a,as_) -> f(a) && all_list(as_,f)
  }
}

fun map_list(ls: list<a>,f: a -> <div,exn> b): <div,exn> list<b>{
  match ls{
    Nil -> Nil
    Cons(a,as_) -> Cons(f(a),map_list(as_,f))
  }
}

fun replicate_term(n:int64, t:term) : div list<term> {
  if n == 0.int64 then
    Nil
  else
    Cons(t,replicate_term(n - 1.int64, t))
}

fun find(vid:id,ls:list<(id,term)>) : div (bool,term) {
  match ls
    Nil -> (False,ERR)
    Cons((vid2,val2),bs) ->
      if id_eq(vid,vid2) then
        (True,val2)
      else
        find(vid,bs)
}

fun boyer_add1(a:term): total term { Func(ID_ADD1,Cons(a,Nil),fn () Nil) }
fun boyer_zero(): total term { Func(ID_ZERO,Nil,fn () Nil) }
fun boyer_zerop(a:term): div term {
  Func(ID_ZEROP,Cons(a,Nil),fn()
    Cons((
      boyer_zerop(boyer_x()),
      boyer_equal(boyer_x(), boyer_zero())
    ), Nil)
  )
}
fun boyer_one(): div term {
  Func(ID_ONE,Nil,fn ()
    Cons((
      boyer_one(),
      boyer_add1(boyer_zero())
    ),Nil)
  )
}
fun boyer_two(): div term {
  Func(ID_TWO,Nil,fn ()
    Cons((
      boyer_two(),
      boyer_add1(boyer_one())
    ),Nil)
  )
}
fun boyer_four(): div term {
  Func(ID_FOUR,Nil,fn()
    Cons((
      boyer_four(),
      boyer_add1(boyer_add1(boyer_two()))
    ), Nil)
  )
}
fun boyer_if_(a:term,b:term,c:term): div term {
  Func(ID_IF,Cons(a,Cons(b,Cons(c,Nil))),fn ()
    Cons((
      boyer_if_(boyer_if_(boyer_x(), boyer_y(), boyer_z()), boyer_u(), boyer_w()),
      boyer_if_(boyer_x(), boyer_if_(boyer_y(), boyer_u(), boyer_w()), boyer_if_(boyer_z(), boyer_u(), boyer_w()))
    ), Nil)
  )
}
fun boyer_not_(a:term): div term {
  Func(ID_NOT,Cons(a,Nil),fn()
    Cons((
      boyer_not_(boyer_x()),
      boyer_if_(boyer_x(), boyer_false(), boyer_true())
    ), Nil)
  )
}
fun boyer_and_(a:term,b:term): div term {
  Func(ID_AND,Cons(a,Cons(b,Nil)),fn()
    Cons((
      boyer_and_(boyer_x(), boyer_y()),
      boyer_if_(boyer_x(), boyer_if_(boyer_y(), boyer_true(), boyer_false()), boyer_false())
    ), Nil)
  )
}
fun boyer_equal(a:term,b:term): div term {
  Func(ID_EQUAL,Cons(a,Cons(b,Nil)),fn()
    Cons((
      boyer_equal(boyer_plus(boyer_x(), boyer_y()), boyer_zero()),
      boyer_and_(boyer_zerop(boyer_x()), boyer_zerop(boyer_y()))
    ),
    Cons((
      boyer_equal(boyer_plus(boyer_x(), boyer_y()), boyer_plus(boyer_x(), boyer_z())),
      boyer_equal(boyer_y(), boyer_z())
    ),
    Cons((
      boyer_equal(boyer_zero(), boyer_difference(boyer_x(), boyer_y())),
      boyer_not_(boyer_lessp(boyer_y(), boyer_x()))
    ),
    Cons((
      boyer_equal(boyer_x(), boyer_difference(boyer_x(), boyer_y())),
      boyer_or_(boyer_equal(boyer_x(), boyer_zero()), boyer_zerop(boyer_y()))
    ),
    Cons((
      boyer_equal(boyer_times(boyer_x(), boyer_y()), boyer_zero()),
      boyer_or_(boyer_zerop(boyer_x()), boyer_zerop(boyer_y()))
    ),
    Cons((
      boyer_equal(boyer_append_(boyer_x(), boyer_y()), boyer_append_(boyer_x(), boyer_z())),
      boyer_equal(boyer_y(), boyer_z())
    ),
    Cons((
      boyer_equal(boyer_y(), boyer_times(boyer_x(), boyer_y())),
      boyer_or_(boyer_equal(boyer_y(), boyer_zero()), boyer_equal(boyer_x(), boyer_one()))
    ),
    Cons((
      boyer_equal(boyer_x(), boyer_times(boyer_x(), boyer_y())),
      boyer_or_(boyer_equal(boyer_x(), boyer_zero()), boyer_equal(boyer_y(), boyer_one()))
    ),
    Cons((
      boyer_equal(boyer_times(boyer_x(), boyer_y()), boyer_one()),
      boyer_and_(boyer_equal(boyer_x(), boyer_one()), boyer_equal(boyer_y(), boyer_one()))
    ),
    Cons((
      boyer_equal(boyer_difference(boyer_x(), boyer_y()), boyer_difference(boyer_z(), boyer_y())),
      boyer_if_(boyer_lessp(boyer_x(), boyer_y()),
      boyer_not_(boyer_lessp(boyer_y(), boyer_z())),
      boyer_if_(boyer_lessp(boyer_z(), boyer_y()),
      boyer_not_(boyer_lessp(boyer_y(), boyer_x())), boyer_equal(boyer_x(), boyer_z())))
    ),
    Cons((
      boyer_equal(boyer_lessp(boyer_x(), boyer_y()), boyer_z()),
      boyer_if_(boyer_lessp(boyer_x(), boyer_y()),
      boyer_equal(boyer_true(), boyer_z()),
      boyer_equal(boyer_false(), boyer_z()))
    ),
    Nil)))))))))))
  )
}
fun boyer_append_(a:term,b:term): div term {
  Func(ID_APPEND,Cons(a,Cons(b,Nil)),fn()
    Cons((
      boyer_append_(boyer_append_(boyer_x(), boyer_y()), boyer_z()),
      boyer_append_(boyer_x(), boyer_append_(boyer_y(), boyer_z()))
    ), Nil)
  )
}
fun boyer_x(): total term { Var(ID_X) }
fun boyer_y(): total term { Var(ID_Y) }
fun boyer_z(): total term { Var(ID_Z) }
fun boyer_u(): total term { Var(ID_U) }
fun boyer_w(): total term { Var(ID_W) }
fun boyer_a(): total term { Var(ID_A) }
fun boyer_b(): total term { Var(ID_B) }
fun boyer_c(): total term { Var(ID_C) }
fun boyer_d(): total term { Var(ID_D) }
fun boyer_false(): total term {
  Func(ID_FALSE,Nil,fn() Nil)
}
fun boyer_true(): total term {
  Func(ID_TRUE,Nil,fn() Nil)
}
fun boyer_or_(a:term,b:term): div term {
  Func(ID_OR,Cons(a,Cons(b,Nil)),fn()
    Cons((
      boyer_or_(boyer_x(), boyer_y()),
      boyer_if_(boyer_x(), boyer_true(), boyer_if_(boyer_y(), boyer_true(), boyer_false()))
    ), Nil)
  )
}
fun boyer_lessp(a:term,b:term): div term {
  Func(ID_LESSP,Cons(a,Cons(b,Nil)),fn()
    Cons((
      boyer_lessp(boyer_remainder(boyer_x(), boyer_y()), boyer_y()),
      boyer_not_(boyer_zerop(boyer_y()))
    ),
    Cons((
      boyer_lessp(boyer_quotient(boyer_x(), boyer_y()), boyer_x()),
      boyer_and_(boyer_not_(boyer_zerop(boyer_x())), boyer_lessp(boyer_one(), boyer_y()))
    ),
    Cons((
      boyer_lessp(boyer_plus(boyer_x(), boyer_y()), boyer_plus(boyer_x(), boyer_z())),
      boyer_lessp(boyer_y(), boyer_z())
    ),
    Cons((
      boyer_lessp(boyer_times(boyer_x(), boyer_z()), boyer_times(boyer_y(), boyer_z())),
      boyer_and_(boyer_not_(boyer_zerop(boyer_z())), boyer_lessp(boyer_x(), boyer_y()))
    ),
    Cons((
      boyer_lessp(boyer_y(), boyer_plus(boyer_x(), boyer_y())),
      boyer_not_(boyer_zerop(boyer_x()))
    ),
    Nil)))))
  )
}
fun boyer_cons(a:term,b:term): total term{
  Func(ID_CONS,Cons(a,Cons(b,Nil)),fn () Nil)
}
fun boyer_remainder(a:term,b:term): div term {
  Func(ID_REMAINDER,Cons(a,Cons(b,Nil)),fn()
    Cons((
      boyer_remainder(boyer_x(), boyer_one()),
      boyer_zero()
    ),
    Cons((
      boyer_remainder(boyer_x(), boyer_x()),
      boyer_zero()
    ),
    Cons((
      boyer_remainder(boyer_times(boyer_x(), boyer_y()), boyer_x()),
      boyer_zero()
    ),
    Cons((
      boyer_remainder(boyer_times(boyer_x(), boyer_y()), boyer_y()),
      boyer_zero()
    ),
    Nil))))
  )
}
fun boyer_quotient(a:term,b:term): div term {
  Func(ID_QUOTIENT,Cons(a,Cons(b,Nil)),fn()
    Cons((
      boyer_quotient(boyer_plus(boyer_x(), boyer_plus(boyer_x(), boyer_y())), boyer_two()),
      boyer_plus(boyer_x(), boyer_quotient(boyer_y(), boyer_two()))
    ),
    Cons((
      boyer_quotient(boyer_times(boyer_y(), boyer_x()), boyer_y()),
      boyer_if_(boyer_zerop(boyer_y()), boyer_zero(), boyer_x())
    ),
    Nil))
  )
}
fun boyer_times(a:term,b:term): div term {
  Func(ID_TIMES,Cons(a,Cons(b,Nil)),fn ()
    Cons((
      boyer_times(boyer_x(), boyer_plus(boyer_y(), boyer_z())),
      boyer_plus(boyer_times(boyer_x(), boyer_y()), boyer_times(boyer_x(), boyer_z()))
    ),
    Cons((
      boyer_times(boyer_times(boyer_x(), boyer_y()), boyer_z()),
      boyer_times(boyer_x(), boyer_times(boyer_y(), boyer_z()))
    ),
    Cons((
      boyer_times(boyer_x(), boyer_difference(boyer_y(), boyer_z())),
      boyer_difference(boyer_times(boyer_y(), boyer_x()), boyer_times(boyer_z(), boyer_x()))
    ),
    Cons((
      boyer_times(boyer_x(), boyer_add1(boyer_y())),
      boyer_plus(boyer_x(), boyer_times(boyer_x(), boyer_y()))
    ),
    Nil))))
  )
}
fun boyer_difference(a:term,b:term) : div term {
  Func(ID_DIFFERENCE,Cons(a,Cons(b,Nil)), fn()
    Cons((
      boyer_difference(boyer_x(), boyer_x()),
      boyer_zero()
    ),
    Cons((
      boyer_difference(boyer_plus(boyer_x(), boyer_y()), boyer_x()),
      boyer_y()
    ),
    Cons((
      boyer_difference(boyer_plus(boyer_y(), boyer_x()), boyer_x()),
      boyer_y()
    ),
    Cons((
      boyer_difference(boyer_plus(boyer_x(), boyer_y()), boyer_plus(boyer_x(), boyer_z())),
      boyer_difference(boyer_y(), boyer_z())
    ),
    Cons((
      boyer_difference(boyer_plus(boyer_y(), boyer_plus(boyer_x(), boyer_z())), boyer_x()),
      boyer_plus(boyer_y(), boyer_z())
    ),
    Cons((
      boyer_difference(boyer_add1(boyer_plus(boyer_y(), boyer_z())), boyer_z()),
      boyer_add1(boyer_y())
    ),
    Cons((
      boyer_difference(boyer_add1(boyer_add1(boyer_x())), boyer_two()),
      boyer_x()
    ),
    Nil)))))))
  )
}
fun boyer_implies(a:term,b:term): div term {
  Func(ID_IMPLIES,Cons(a,Cons(b,Nil)),fn()
    Cons((
      boyer_implies(boyer_x(), boyer_y()),
      boyer_if_(boyer_x(), boyer_if_(boyer_y(), boyer_true(), boyer_false()), boyer_true())
    ),
    Nil)
  )
}
fun boyer_length_(a:term): div term {
  Func(ID_LENGTH,Cons(a,Nil),fn()
    Cons((
     boyer_length_(boyer_reverse_(boyer_x())),
     boyer_length_(boyer_x())
    ),
    Cons((
      boyer_length_(boyer_cons(boyer_x(), boyer_cons(boyer_y(), boyer_cons(boyer_z(), boyer_cons(boyer_u(), boyer_w()))))),
      boyer_plus(boyer_four(), boyer_length_(boyer_w()))
    ),
    Nil))
  )
}
fun boyer_reverse_(a:term): div term {
  Func(ID_REVERSE,Cons(a,Nil),fn()
    Cons((
      boyer_reverse_(boyer_append_(boyer_x(), boyer_y())),
      boyer_append_(boyer_reverse_(boyer_y()), boyer_reverse_(boyer_x()))),
    Nil)
  )
}
fun boyer_nil(): total term {
  Func(ID_NIL,Nil,fn() Nil)
}
fun boyer_member(a:term,b:term): div term {
  Func(ID_MEMBER,Cons(a,Cons(b,Nil)),fn()
    Cons((
      boyer_member(boyer_x(), boyer_append_(boyer_y(), boyer_z())),
      boyer_or_(boyer_member(boyer_x(), boyer_y()), boyer_member(boyer_x(), boyer_z()))
    ),
    Cons((
      boyer_member(boyer_x(), boyer_reverse_(boyer_y())),
      boyer_member(boyer_x(), boyer_y())
    ), Nil))
  )
}
fun boyer_plus(a:term,b:term): div term {
  Func(ID_PLUS,Cons(a,Cons(b,Nil)),fn ()
    Cons((
      boyer_plus(boyer_plus(boyer_x(), boyer_y()), boyer_z()),
      boyer_plus(boyer_x(), boyer_plus(boyer_y(), boyer_z()))
    ),
    Cons((
      boyer_plus(boyer_remainder(boyer_x(), boyer_y()), boyer_times(boyer_y(), boyer_quotient(boyer_x(), boyer_y()))),
      boyer_x()
    ),
    Cons((
      boyer_plus(boyer_x(), boyer_add1(boyer_y())),
      boyer_add1(boyer_plus(boyer_x(), boyer_y()))
    ),
    Nil)))
  )
}
fun boyer_f(a:term): total term {
  Func(ID_F,Cons(a,Nil),fn() Nil)
}

fun one_way_unify(term1:term,term2:term) : <div,exn> (bool,list<(id,term)>)  {
  one_way_unify1(term1,term2,Nil)
}

fun one_way_unify1(term1:term,term2:term,subst:list<(id,term)>) : <div,exn> (bool,list<(id,term)>){
  match term2
    Var(vid2) ->
      val (found,v2) = find(vid2,subst)
      if found then
        (term_eq(term1,v2),subst)
      else
        (True,Cons((vid2,term1),subst))
    Func(f2,as2,_) -> match term1
      Func(f1,as1,_) ->
        if id_eq(f1,f2) then
          one_way_unify1_lst(as1,as2,subst)
        else
          (False,Nil)
      _ -> (False,Nil)
    ERR -> (False,Nil)
}

fun one_way_unify1_lst(tts1:list<term>,tts2:list<term>,subst:list<(id,term)>) : <div,exn> (bool,list<(id,term)>){
  match (tts1,tts2)
    (Nil,Nil) -> (True,subst)
    (Nil,_) -> (False,Nil)
    (_,Nil) -> (False,Nil)
    (Cons(t1,ts1),Cons(t2,ts2)) ->
      val (hd_ok,subst_) = one_way_unify1(t1,t2,subst)
      val (tl_ok,subst__) = one_way_unify1_lst(ts1,ts2,subst_)
      (hd_ok && tl_ok,subst__)
}

fun apply_subst(subst:list<(id,term)>,t:term) : <div,exn> term {
  match t
    Var(vid) ->
      val (found,value) = find(vid,subst)
      if found then
        value
      else
        Var(vid)
    Func(f,args,ls) -> Func(f,map_list(args,fn(x) apply_subst(subst,x)),ls)
    ERR -> ERR
}

fun rewrite_with_lemmas(term:term,lss:list<(term,term)>) : <div,exn> term {
  match lss
    Nil -> term
    Cons((lhs,rhs),ls) ->
      val (unified,subst) = one_way_unify(term,lhs)
      if unified then
        rewrite(apply_subst(subst,rhs))
      else
        rewrite_with_lemmas(term,ls)
  }

fun rewrite(t:term) : <div,exn> term {
  match t
    Func(f,args,lemmas) ->
      rewrite_with_lemmas(Func(f,map_list(args,rewrite),lemmas),lemmas())
    _ -> t
}

fun truep(x:term,l:list<term>) : <div,exn> bool {
  match x
    Var(_) -> term_in_list(x,l)
    Func(t,_,_) -> id_eq(t,ID_TRUE) || term_in_list(x,l)
    ERR -> term_in_list(x,l)
}

fun falsep(x:term,l:list<term>) : <div,exn> bool {
  match x
    Var(_) -> term_in_list(x,l)
    Func(t,_,_) -> id_eq(t,ID_FALSE) || term_in_list(x,l)
    ERR -> term_in_list(x,l)
}

fun tautologyp(x:term,true_lst:list<term>,false_lst:list<term>) : <div,exn> bool {
  if truep(x,true_lst) then
    True
  else if falsep(x,false_lst) then
    False
  else match x
    Var(_) -> False
    Func(ID_IF,Cons(cond,Cons(t,Cons(e,Nil))),_) ->
      if truep(cond,true_lst) then
        tautologyp(t,true_lst,false_lst)
      else if falsep(cond,false_lst) then
        tautologyp(e,true_lst,false_lst)
      else
        (tautologyp(t,Cons(cond,true_lst),false_lst))
        &&
        (tautologyp(e,true_lst,Cons(cond,false_lst)))
    ERR -> False
}

fun tautp(x:term) : <div,exn> bool {
  tautologyp(rewrite(x),Nil,Nil)
}

fun boyer_subst0(): div list<(id,term)> {
  Cons((ID_X,boyer_f(boyer_plus(boyer_plus(boyer_a(),boyer_b()),boyer_plus(boyer_c(),boyer_zero())))),
    Cons((ID_Y,boyer_f(boyer_times(boyer_times(boyer_a(), boyer_b()), boyer_plus(boyer_c(), boyer_d())))),
      Cons((ID_Z,boyer_f(boyer_reverse_(boyer_append_(boyer_append_(boyer_a(), boyer_b()), boyer_nil())))),
        Cons((ID_U,boyer_equal(boyer_plus(boyer_a(), boyer_b()), boyer_difference(boyer_x(), boyer_y()))),
          Cons((ID_W,boyer_lessp(boyer_remainder(boyer_a(), boyer_b()), boyer_member(boyer_a(), boyer_length_(boyer_b())))),
          Nil)))))
}

fun boyer_theorem(xxxx:term) : div term {
  boyer_implies(
    boyer_and_(
      boyer_implies(xxxx, boyer_y()),
      boyer_and_(
        boyer_implies(boyer_y(), boyer_z()),
        boyer_and_(
          boyer_implies(boyer_z(), boyer_u()),
          boyer_implies(boyer_u(), boyer_w())
        )
      )
    ),
    boyer_implies(boyer_x(), boyer_w())
  )
}

fun test0(xxxx:term) : <div,exn> bool {
  tautp(apply_subst(boyer_subst0(),boyer_theorem(xxxx)))
}

fun test_boyer_nofib(n:int64) : <div,exn> bool {
  all_list(replicate_term(n,Var(ID_X)),fn (t) test0(t))
}

fun main_loop(iters:int64, n:int64) : <div,console,exn> () {
  val res = test_boyer_nofib(n)
  if iters == 1.int64 then
    if res then
      println("1")
    else
      println("0")
  else
    main_loop(iters - 1.int64,n)
}

pub fun main() : <console,exn,ndet,div> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters,n)
}
