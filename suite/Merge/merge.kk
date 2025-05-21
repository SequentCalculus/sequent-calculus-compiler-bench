module merge

import std/os/env
import std/num/int64

fun tabulate_loop(n:int64,len:int64,f:int64 -> int64,acc:list<int64>): div list<int64>{
  if n < len then 
    tabulate_loop(n + 1.int64,len,f,Cons(f(n),acc))
  else 
    reverse(acc)
}

fun tabulate(n:int64,f:int64 -> int64): <exn,div> list<int64>{
  if n < 0.int64 then 
    throw("Negative list length")
  else 
    tabulate_loop(0.int64, n, f, Nil)
}

fun merge(l1:list<int64>,l2:list<int64>): total list<int64>{
  match l1 
    Nil -> l2
    Cons(x1,xs1) -> 
      match l2
        Nil -> l1
        Cons(x2,xs2) -> 
          if x1 <= x2 then
            Cons(x1,merge(xs1,l2))
          else 
            Cons(x2,merge(l1,xs2))
}

fun main_loop(iters:int64,l1:list<int64>,l2:list<int64>): <console,div,exn> (){
  val res = merge(l1,l2)
  if iters == 1.int64 then
    println(unjust(head(res)))
  else 
    main_loop(iters - 1.int64,l1,l2)
}

fun main(): <ndet,exn,console,div> (){
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  val l1 = tabulate(n,fn(x) 2.int64 * x)
  val l2 = tabulate(n,fn(x) (2.int64 * x) + 1.int64 )
  main_loop(iters,l1,l2)
}
