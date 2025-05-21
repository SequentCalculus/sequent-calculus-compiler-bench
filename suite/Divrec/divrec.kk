module divrec

import std/os/env
import std/num/int64

fun create_n_loop(n:int64,acc:list<()>): div list<()>{
  if n == 0.int64 then 
    acc 
  else 
    create_n_loop(n - 1.int64, Cons((),acc))
}

fun create_n(n:int64): div list<()> {
  create_n_loop(n,Nil)
}

fun rec_div2(ls:list<()>): exn list<()>{
  match ls 
    Nil -> Nil
    Cons(x,Cons(_,xs)) -> Cons(x,rec_div2(xs))
    _ -> throw("Odd Length List")
}

fun main_loop(iters:int64,n:int64) : <div,console,exn> () {
  val res = length(rec_div2(create_n(n)))
  if iters==1.int64 then
    println(res)
  else
    main_loop(iters - 1.int64,n)
}

fun main() : <ndet,exn,div,console,exn> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters,n)
}
