module factorialaccumulator

import std/os/env
import std/num/int64

fun factorial(a:int64,i:int64): div int64{
  if i == 0.int64 then
    a 
  else 
    factorial((i * a) % 1000000007.int64, i - 1.int64)
}

fun main_loop(iters:int64,n:int64) : <console,div> (){
  val res = factorial(1.int64,n)
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
