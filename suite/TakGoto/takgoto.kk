module takgoto

import std/os/env
import std/num/int64

effect ret
  ctl ret(i:int64) : int64

fun handle_ret(action:()-> <div,ret> int64) : div int64 {
  with ctl ret(i) i 
  action()
}

fun tak(x:int64,y:int64,z:int64): <ret,div> int64{
  if y < x then
    tak(
      handle_ret(fn() tak(x - 1.int64,y,z)),
      handle_ret(fn() tak(y - 1.int64,z,x)),
      handle_ret(fn() tak(z - 1.int64,x,y))
    )
  else 
    ret(z)
}

fun main_loop(iters:int64,x:int64,y:int64,z:int64): <console,div> (){
  val res = handle_ret(fn() tak(x,y,z))
  if iters == 1.int64 then
    println(res)
  else 
    main_loop(iters - 1.int64,x,y,z)
}

fun main(): <ndet,exn,console,div> (){
  val args = get-args()
  val iters = unjust(parse-int(unjust(head(args)))).int64
  val x = unjust(parse-int(unjust(head(tail(args))))).int64
  val y = unjust(parse-int(unjust(head(tail(tail(args)))))).int64
  val z = unjust(parse-int(unjust(head(tail(tail(tail(args))))))).int64
  main_loop(iters,x,y,z)
}
