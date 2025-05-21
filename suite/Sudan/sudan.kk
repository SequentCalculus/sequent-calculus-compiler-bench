module sudan

import std/os/env
import std/num/int64

fun sudan(n:int64,x:int64,y:int64): div int64{
  if n == 0.int64 then
    x + y 
  else if y == 0.int64 then 
    x
  else 
    val inner = sudan(n,x,y - 1.int64)
    sudan(n - 1.int64,inner,inner + y)
}

fun main_loop(iters:int64,n:int64,x:int64,y:int64): <console,div> () {
  val res = sudan(n,x,y)
  if iters == 1.int64 then
    println(res)
  else 
    main_loop(iters - 1.int64,n,x,y)
}

fun main(): <ndet,exn,console,div> (){
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val n = unjust(parse-int(unjust(head(tail(args))))).int64
  val x = unjust(parse-int(unjust(head(tail(tail(args)))))).int64
  val y = unjust(parse-int(unjust(head(tail(tail(tail(args))))))).int64
  main_loop(iters,n,x,y)
}
