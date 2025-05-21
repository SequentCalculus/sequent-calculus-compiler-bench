module motzkin

import std/os/env
import std/num/int64

fun sum_loop(i:int64,tot:int64,stop:int64,f:int64 -> div int64): div int64{
  if stop < i then
    tot
  else 
    sum_loop(i + 1.int64,f(i) + tot,stop,f)
}

fun sum(f:int64 -> div int64, start:int64,stop:int64): div int64{
  sum_loop(start,0.int64,stop,f)
}

fun motz(n:int64): div int64{
  if n <= 1.int64 then
    1.int64
  else 
    val limit = n - 2.int64
    val product = fn(i) motz(i) * motz(limit - i)
    motz(n - 1.int64) + sum(product,0.int64,limit)
}

fun main_loop(iters:int64,n:int64): <console,div> (){
  val res = motz(n)
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
