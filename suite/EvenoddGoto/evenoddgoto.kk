module evenoddgoto

import std/num/int64
import std/os/env

effect ret
  ctl ret(b:bool): bool

fun abs_int(i:int64): total int64{
  if i < 0.int64 then ~i else i
}

fun even_abs(i:int64): div bool{
  if i == 0.int64 then
    True
  else
    with ctl ret(b) b
    odd_abs(i - 1.int64)
}

fun odd_abs(i:int64): <div,ret> bool{
  if i == 0.int64 then
    ret(False)
  else
    ret(even_abs(i - 1.int64))
}

fun even(i:int64): <exn,div> bool{
  even_abs(abs_int(i))
}

fun odd(i:int64): <exn,div> bool {
  with ctl ret(b) b
  odd_abs(abs_int(i))
}

fun main_loop(iters:int64,n:int64): <console,div,exn> (){
  val res = even(n) && not(odd(n))
  if iters == 1.int64 then
    if res then
      println("1")
    else
      println("0")
  else
    main_loop(iters - 1.int64,n)
}

fun main(): <ndet,exn,console,div> (){
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  main_loop(iters,n)
}
