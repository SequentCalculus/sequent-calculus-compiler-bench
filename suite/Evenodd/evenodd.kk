module evenodd

import std/os/env
import std/num/int64

fun abs_int(i:int64): total int64{
  if i < 0.int64 then ~i else i
}

fun even_abs(n:int64): div bool{
  if n == 0.int64 then 
    True 
  else 
    odd_abs(n - 1.int64)
}

fun odd_abs(n:int64): div bool{
  if n == 0.int64 then
    False 
  else 
    even_abs(n - 1.int64)
}

fun odd(n:int64): <div,exn> bool{
  odd_abs(abs_int(n))
}

fun even(n:int64): <div,exn> bool{
  even_abs(abs_int(n))
}

fun main_loop(iters:int64,n:int64): <div,exn,console> (){
  val res = even(n) && not(odd(n))
  if iters == 1.int64 then
    if res then
      println("1")
    else 
      println("0")
  else 
    main_loop(iters - 1.int64,n) 
}

fun main() : <exn,ndet,div,console> (){
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters,n)
}
