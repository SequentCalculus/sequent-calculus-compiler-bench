module nqueens

import std/os/env
import std/num/int64

fun safe(x:int64,d:int64,l:list<int64>): total bool{
  match l
    Nil -> True
    Cons(q,l) -> 
      not(x == q) && not(x == (q + d)) && not(x == (q - d)) && safe(x,d + 1.int64,l)
}

fun check(l:list<list<int64>>,acc:list<list<int64>>,q:int64): total list<list<int64>>{
  match l
    Nil -> acc
    Cons(b,bs) -> 
      if safe(q,1.int64,b) then
        check(bs,Cons(Cons(q,b),acc),q)
      else 
        check(bs,acc,q)
}

fun enumerate(q:int64,acc:list<list<int64>>,bs:list<list<int64>>): div list<list<int64>>{
  if q == 0.int64 then
    acc
  else 
    val res = check(bs,Nil,q)
    enumerate(q - 1.int64,append(res,acc),bs)
}

fun gen(n:int64,nq:int64): div list<list<int64>>{
  if n == 0.int64 then
    Cons(Nil,Nil)
  else 
    val bs = gen(n - 1.int64,nq)
    enumerate(nq,Nil,bs)
}

fun nsoln(n:int64): div int64{
  length(gen(n,n)).int64
}

fun main_loop(iters:int64,n:int64): <console,div> (){
  val res = nsoln(n)
  if iters == 1.int64 then
    println(res)
  else 
    main_loop(iters - 1.int64,n)
}

fun main(): <ndet,exn,console,div> (){
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters,n)
}
