module motzkingoto

import std/os/env
import std/num/int64

effect ret
  ctl ret(i:int64) : int64

fun handle_ret(action:() -> <div,ret> int64): div int64{
  with ctl ret(i) i 
  action()
}

fun sum_loop(i:int64,tot:int64,stop:int64,f:int64 -> div int64): <ret,div> int64{
  if stop < i then
    ret(tot)
  else 
    sum_loop(i + 1.int64, f(i) + tot, stop, f)
}

fun sum(f:int64 -> div int64,start:int64,stop:int64) : <ret,div> int64{
  sum_loop(start,0.int64,stop,f)
}


fun motz(n:int64): <div,ret> int64{
  if n <= 1.int64 then
    ret(1.int64)
  else 
    val limit = n - 2.int64
    val product = fn(i) 
      handle_ret(fn() motz(i)) * handle_ret(fn() motz(limit - i))
    ret(
      handle_ret(fn() motz(n - 1.int64))
      + handle_ret(fn() sum(product,0.int64,limit))
    )
}

fun main_loop(iters:int64,n:int64): <console,div> (){
  val res = handle_ret(fn() motz(n))
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
