module deriv 

import std/os/env
import std/num/int64

type expr
  Add(sums:list<expr>)
  Sub(subs:list<expr>)
  Mul(muls:list<expr>)
  Div(divs:list<expr>)
  Num(i:int64)
  X

fun map_list<a,b>(l:list<a>,f: a -> <div,exn> b): <div,exn> list<b> {
  match l {
    Nil -> Nil
    Cons(a,as_) -> Cons(f(a),map_list(as_,f))
  }
}

fun equal(e1:expr,e2:expr): div bool{
  match (e1,e2)
    (Add(sums1),Add(sums2)) -> equal_list(sums1,sums2)
    (Sub(subs1),Sub(subs2)) -> equal_list(subs1,subs2)
    (Mul(muls1),Mul(muls2)) -> equal_list(muls1,muls2)
    (Div(divs1),Div(divs2)) -> equal_list(divs1,divs2)
    (Num(i1),Num(i2)) -> i1==i2
    (X,X) -> True
    _ -> False 
}

fun equal_list(l1:list<expr>,l2:list<expr>): div bool{
  match (l1,l2)
    (Nil,Nil) -> True
    (Nil,_) -> False
    (_,Nil) -> False
    (Cons(e1,es1),Cons(e2,es2)) -> equal(e1,e2) && equal_list(es1,es2)
}

fun deriv(e:expr) : <div,exn> expr{
  match e 
    Add(sums) -> Add(map_list(sums,deriv))
    Sub(subs) -> Sub(map_list(subs,deriv))
    Mul(muls) -> Mul(Cons(
      e,
      Cons(
        Add(map_list(muls,fn(x) Div(Cons(deriv(x), Cons(x, Nil))))),
        Nil)))
    Div(Cons(x,Cons(y,Nil))) -> Sub(
      Cons(
        Div(Cons(deriv(x), Cons(y, Nil))),
        Cons(
          Div(
            Cons(x,
              Cons(
                Mul(Cons(y, Cons(y, Cons(deriv(y), Nil)))),
                Nil))),
        Nil)))
    Num(_) -> Num(0.int64)
    X -> Num(1.int64)
    _ -> throw("Bad Expression")
}

fun mk_exp(a:expr,b:expr) : total expr{
  Add(
    Cons(
      Mul(Cons(Num(3.int64), Cons(X, Cons(X, Nil)))),
      Cons(
        Mul(Cons(a, Cons(X, Cons(X, Nil)))),
        Cons(
          Mul(Cons(b, Cons(X, Nil))),
          Cons(Num(5.int64), Nil)))))
}

fun mk_ans(a:expr,b:expr) : total expr{
  Add(
    Cons(
      Mul(
        Cons(
          Mul(Cons(Num(3.int64), Cons(X, Cons(X, Nil)))),
          Cons(
            Add(
              Cons(
                Div(Cons(Num(0.int64), Cons(Num(3.int64), Nil))),
                Cons(
                  Div(Cons(Num(1.int64), Cons(X, Nil))),
                  Cons(Div(Cons(Num(1.int64), Cons(X, Nil))), Nil)))),
            Nil))),
      Cons(
        Mul(
          Cons(
            Mul(Cons(a, Cons(X, Cons(X, Nil)))),
            Cons(
              Add(
                Cons(
                  Div(Cons(Num(0.int64), Cons(a, Nil))),
                  Cons(
                    Div(Cons(Num(1.int64), Cons(X, Nil))),
                    Cons(Div(Cons(Num(1.int64), Cons(X, Nil))), Nil)))),
              Nil))),
        Cons(
          Mul(
            Cons(
              Mul(Cons(b, Cons(X, Nil))),
              Cons(
                Add(
                  Cons(
                    Div(Cons(Num(0.int64), Cons(b, Nil))),
                    Cons(Div(Cons(Num(1.int64), Cons(X, Nil))), Nil))),
                Nil))),
          Cons(Num(0.int64), Nil)))))
}

fun main_loop(iters:int64,n:int64,m:int64): <console,div,exn> (){
  val res = deriv(mk_exp(Num(n),Num(m)))
  val expected = mk_ans(Num(n),Num(m))
  if iters == 1.int64 then 
    if equal(res,expected) then 
      println("1")
    else
      println("0")
  else 
    main_loop(iters - 1.int64,n,m)
}
 
fun main(): <exn,ndet,console,div> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  val m = unjust(parse-int(unjust(head(tail(tail(args)))))).int64
  main_loop(iters,n,m)
}
