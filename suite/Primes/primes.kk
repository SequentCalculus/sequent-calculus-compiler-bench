module primes 

import std/os/env
import std/num/int64

fun len<a>(l:list<a>): total int64{
  match l
    Nil -> 0.int64
    Cons(_,xs) -> 1.int64 + len(xs)
}

fun interval_list(m:int64,n:int64): div list<int64>{
  if n < m then
    Nil
  else 
    Cons(m,interval_list(m + 1.int64,n))
}

fun remove_multiples(n:int64,l:list<int64>): div list<int64>{
  match l
    Nil -> Nil
    Cons(x,xs) -> 
      if x % n == 0.int64 then
        remove_multiples(n,xs)
      else 
        Cons(x,remove_multiples(n,xs))
}

fun sieve(l:list<int64>): div list<int64>{
  match l
    Nil -> Nil
    Cons(x,xs) -> Cons(x,sieve(remove_multiples(x,xs)))
}

fun main_loop(iters:int64,n:int64): <console,div> (){
  val x = sieve(interval_list(2.int64,n))
  if iters == 1.int64 then
    println(len(x))
  else 
    main_loop(iters - 1.int64,n)
}

fun main(): <ndet,exn,console,div> () {
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters,n)
}
